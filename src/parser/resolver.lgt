%%%  resolver.lgt  %%%
%%%
%%%  Object disambiguation, scope checking, and pronoun resolution.
%%%  Converts parsed noun phrases into specific game object atoms.
%%%
%%%  ZIL source: parser.zil (SNARF-OBJECTS, CLAUSE, SYNTAX-CHECK)
%%%              crufty.zil (object disambiguation, scope checks)
%%%
%%%  Copyright 1982 Infocom, Inc. (original game)
%%%  Logtalk refactoring: see CLAUDE.md

:- object(resolver).

    :- info([
        version is 1:0:0,
        comment is 'Resolve noun phrases to game objects; check scope; handle pronouns.'
    ]).

    :- uses(user, [member/2, memberchk/2, read_line_to_string/2, atom_string/2]).

    %% ---------------------------------------------------------------
    %% PUBLIC API
    %% ---------------------------------------------------------------

    %% resolve_command(+RawCmd, -ResolvedCmd)
    %% Take a cmd/3 with np(Words) or pronoun(Type) noun phrases
    %% and resolve them to game object atoms.
    :- public(resolve_command/2).
    resolve_command(cmd(Verb, RawDO, RawIO), cmd(Verb, DO, IO)) :-
        resolve_np(RawDO, Verb, direct,   DO),
        resolve_np(RawIO, Verb, indirect, IO).

    %% ---------------------------------------------------------------
    %% NOUN PHRASE RESOLUTION
    %% ---------------------------------------------------------------

    :- private(resolve_np/4).

    resolve_np(none, _, _, none) :- !.

    resolve_np(intnum(N), _, _, intnum(N)) :- !.

    resolve_np(pronoun(Type), _, _, Entity) :-
        !,
        resolve_pronoun(Type, Entity).

    resolve_np(pair(Prep, RawObj), Verb, Role, pair(Prep, Obj)) :-
        !,
        resolve_np(RawObj, Verb, Role, Obj).

    resolve_np(np(Words), Verb, Role, Entity) :-
        !,
        find_candidates(Words, Candidates),
        ( Candidates = [] ->
            words_to_phrase(Words, Phrase),
            format("You don't see any ~w here.~n", [Phrase]),
            fail
        ; Candidates = [Entity] ->
            true
        ; disambiguate(Candidates, Words, Entity)
        ).

    resolve_np(Entity, _, _, Entity) :-
        atom(Entity), !.  % already resolved

    %% ---------------------------------------------------------------
    %% PRONOUN RESOLUTION
    %% ZIL: P-IT-OBJECT (P-IT), P-HIM-HER global variables
    %% ---------------------------------------------------------------

    :- private(resolve_pronoun/2).
    resolve_pronoun(it, Entity) :-
        ( state::pronoun(it, Entity), Entity \= none ->
            check_pronoun_valid(it, Entity)
        ;
            writeln("I'm not sure what 'it' refers to."),
            fail
        ).

    resolve_pronoun(him_her, Entity) :-
        ( state::pronoun(him_her, Entity), Entity \= none ->
            check_pronoun_valid(him_her, Entity)
        ;
            writeln("I'm not sure who you mean."),
            fail
        ).

    resolve_pronoun(them, Entity) :-
        %% THEM resolution: try him_her first, then it
        ( state::pronoun(him_her, Entity), Entity \= none -> true
        ; state::pronoun(it, Entity), Entity \= none -> true
        ;   writeln("I'm not sure what 'them' refers to."),
            fail
        ).

    %% Check pronoun referent is accessible: same room or in player inventory
    :- private(check_pronoun_valid/2).
    check_pronoun_valid(_, Entity) :-
        ( is_accessible(Entity) -> true
        ;
            %% ZIL: pronoun_room check - if in same room, valid
            state::pronoun_room(_, Room),
            state::current_room(Room)
        ->  true
        ;   true   % allow for now; verbs can check accessibility themselves
        ).

    %% ---------------------------------------------------------------
    %% OBJECT CANDIDATE SEARCH
    %% Find all objects that match the given word list.
    %% ZIL: SNARF-OBJECTS + CLAUSE object matching
    %% ---------------------------------------------------------------

    :- private(find_candidates/2).
    find_candidates(Words, Candidates) :-
        findall(Entity, (
            candidate_object(Entity),
            object_matches(Entity, Words)
        ), AllRaw),
        sort(AllRaw, All),  %% deduplicate
        %% Prefer visible, accessible objects
        filter_accessible(All, Accessible),
        ( Accessible \= [] ->
            Candidates = Accessible
        ;   Candidates = All
        ).

    :- private(words_to_phrase/2).
    words_to_phrase([], '').
    words_to_phrase([W], W).
    words_to_phrase([W|Ws], Phrase) :-
        Ws \= [],
        words_to_phrase(Ws, Rest),
        atom_concat(W, ' ', W1),
        atom_concat(W1, Rest, Phrase).

    :- private(filter_accessible/2).
    filter_accessible([], []).
    filter_accessible([E|Es], Result) :-
        ( is_accessible(E) ->
            Result = [E|Rest], filter_accessible(Es, Rest)
        ;   filter_accessible(Es, Result)
        ).

    %% candidate_object(-Entity)
    %% Objects potentially visible to the player right now.
    :- private(candidate_object/1).
    candidate_object(Entity) :-
        state::current_room(Room),
        (
            %% Objects in current room
            state::location(Entity, Room),
            \+ state::has_flag(Entity, invisible)
        ;
            %% Objects in player's inventory
            state::location(Entity, player)
        ;
            %% Objects in open containers in room
            state::location(Container, Room),
            state::has_flag(Container, openbit),
            state::location(Entity, Container),
            \+ state::has_flag(Entity, invisible)
        ;
            %% Global objects accessible from this room
            room_global_object(Room, Entity)
        ).

    :- private(room_global_object/2).
    room_global_object(Room, Entity) :-
        catch(Room::global_objects(Globals), _, Globals = []),
        member(Entity, Globals).

    %% is_accessible(-Entity)
    :- public(is_accessible/1).
    is_accessible(Entity) :-
        state::current_room(Room),
        (
            state::location(Entity, Room),
            \+ state::has_flag(Entity, invisible)
        ;
            state::location(Entity, player)
        ;
            state::location(Container, Room),
            state::has_flag(Container, openbit),
            state::location(Entity, Container)
        ;
            state::location(Container, player),
            state::has_flag(Container, openbit),
            state::location(Entity, Container)
        ;
            %% Room global objects (doors, scenery, etc.)
            room_global_object(Room, Entity),
            \+ state::has_flag(Entity, invisible)
        ).

    %% ---------------------------------------------------------------
    %% OBJECT WORD MATCHING
    %% An object matches a word list if:
    %%   - A word in the list matches the object's synonym/1
    %%   - Additional words match the object's adjective/1
    %% ---------------------------------------------------------------

    :- private(object_matches/2).
    object_matches(Entity, Words) :-
        %% Must have at least one matching noun synonym
        has_matching_noun(Entity, Words),
        %% Non-noun words are treated as adjectives and must match
        forall(
            ( member(W, Words), \+ matches_noun(Entity, W) ),
            object_has_adjective(Entity, W)
        ).

    :- private(has_matching_noun/2).
    has_matching_noun(Entity, Words) :-
        member(Word, Words),
        matches_noun(Entity, Word),
        !.

    %% matches_noun/2 - check if Word is a valid noun for Entity
    :- private(matches_noun/2).
    matches_noun(Entity, Word) :-
        ( catch(Entity::synonym(Syns), _, Syns = []) ->
            ( is_list(Syns) ->
                member(Word, Syns)
            ;   Word = Syns
            )
        ;   false
        ).
    matches_noun(Entity, Word) :-
        %% Entity name itself can be used as a noun
        Entity = Word.

    :- private(object_has_adjective/2).
    object_has_adjective(Entity, Adj) :-
        ( catch(Entity::adjective(Adjs), _, Adjs = []) ->
            ( is_list(Adjs) ->
                member(Adj, Adjs)
            ;   Adj = Adjs
            )
        ;   false
        ).

    %% Determine if Word is used as an adjective (not a main noun)
    :- private(is_adjective_word/2).
    is_adjective_word(Entity, Word) :-
        \+ matches_noun(Entity, Word),
        object_has_adjective(Entity, Word).

    %% ---------------------------------------------------------------
    %% DISAMBIGUATION
    %% When multiple objects match, use scope/context to pick one.
    %% ZIL: SNARF-OBJECTS disambiguation pass + user prompt
    %% ---------------------------------------------------------------

    :- private(disambiguate/3).
    disambiguate(Candidates, Words, Entity) :-
        %% Step 1: Prefer objects in room over inventory (for some verbs)
        state::current_room(Room),
        filter_in_location(Candidates, Room, InRoom),
        ( InRoom = [Entity] -> ! ; true ),

        %% Step 2: Prefer player inventory
        filter_in_location(Candidates, player, InInv),
        ( InInv = [Entity] -> ! ; true ),

        %% Step 3: Ask player to disambiguate
        !,
        ask_disambiguation(Candidates, Words, Entity).

    :- private(filter_in_location/3).
    filter_in_location([], _, []).
    filter_in_location([E|Es], Loc, Result) :-
        ( state::location(E, Loc) ->
            Result = [E|Rest], filter_in_location(Es, Loc, Rest)
        ;   filter_in_location(Es, Loc, Result)
        ).

    disambiguate([Entity|_], _, Entity).  % fallback: pick first

    :- private(print_candidate_list/1).
    print_candidate_list([]).
    print_candidate_list([C|Cs]) :-
        ( catch(C::desc(D), _, D = C) -> true ; D = C ),
        format("  - ~w~n", [D]),
        print_candidate_list(Cs).

    :- private(ask_disambiguation/3).
    ask_disambiguation(Candidates, _Words, Entity) :-
        writeln("Which do you mean:"),
        print_candidate_list(Candidates),
        write("? "),
        read_line_to_string(user_input, Line),
        lexer::tokenize(Line, Tokens),
        ( Tokens = [] ->
            writeln("Please specify which one."), fail
        ;
            find_candidates(Tokens, NewCands),
            intersection(NewCands, Candidates, Matches),
            ( Matches = [Entity] -> true
            ; Matches = [] ->
                writeln("I don't see that here."), fail
            ;   Matches = [Entity|_]  % still ambiguous - pick first
            )
        ).

    %% ---------------------------------------------------------------
    %% SCOPE PREDICATES
    %% Correspond to ZIL scope modifiers: HELD, CARRIED, ON-GROUND,
    %% IN-ROOM, HAVE, MANY, TAKE, etc.
    %% ---------------------------------------------------------------

    %% in_scope_held(+Entity) - entity is carried by player (HELD/CARRIED)
    :- public(in_scope_held/1).
    in_scope_held(Entity) :-
        state::location(Entity, player).

    %% in_scope_in_room(+Entity) - entity is in current room (IN-ROOM)
    :- public(in_scope_in_room/1).
    in_scope_in_room(Entity) :-
        state::current_room(Room),
        state::location(Entity, Room),
        \+ state::has_flag(Entity, invisible).

    %% in_scope_on_ground(+Entity) - entity is in room (ON-GROUND)
    %% ZIL ON-GROUND includes room-level objects
    :- public(in_scope_on_ground/1).
    in_scope_on_ground(Entity) :-
        state::current_room(Room),
        state::location(Entity, Room),
        \+ state::has_flag(Entity, invisible).

    %% in_scope_any(+Entity) - held or in room (catch-all scope)
    :- public(in_scope_any/1).
    in_scope_any(Entity) :-
        ( in_scope_held(Entity) ; in_scope_in_room(Entity) ).

    %% ---------------------------------------------------------------
    %% PRONOUN UPDATING
    %% Called after successful resolution to update pronoun globals.
    %% ZIL: SETG P-IT-OBJECT / SETG P-HIM-HER
    %% ---------------------------------------------------------------

    :- public(update_pronoun_it/1).
    update_pronoun_it(Entity) :-
        state::current_room(Room),
        state::retractall(pronoun(it, _)),
        state::assertz(pronoun(it, Entity)),
        state::retractall(pronoun_room(it, _)),
        state::assertz(pronoun_room(it, Room)).

    :- public(update_pronoun_him_her/1).
    update_pronoun_him_her(Entity) :-
        state::current_room(Room),
        state::retractall(pronoun(him_her, _)),
        state::assertz(pronoun(him_her, Entity)),
        state::retractall(pronoun_room(him_her, _)),
        state::assertz(pronoun_room(him_her, Room)).

    %% ---------------------------------------------------------------
    %% FULL PARSE PIPELINE
    %% Tokenize → parse grammar → resolve objects
    %% ---------------------------------------------------------------

    %% parse_and_resolve(+InputString, -ResolvedCmd)
    :- public(parse_and_resolve/2).
    parse_and_resolve(Input, ResolvedCmd) :-
        lexer::tokenize(Input, Tokens),
        ( Tokens = [] ->
            writeln("What?"), fail
        ;   true
        ),
        ( grammar::parse(Tokens, RawCmd) ->
            resolve_command(RawCmd, ResolvedCmd)
        ;
            %% Try the input as a direction directly
            ( Tokens = [Dir], lexer::is_direction(Dir) ->
                ResolvedCmd = cmd(v_walk, Dir, none)
            ;
                format("I don't understand that.~n", []),
                fail
            )
        ).

    %% ---------------------------------------------------------------
    %% UTILITIES
    %% ---------------------------------------------------------------

    %% entity_desc(+Entity, -Desc) - get short description for error messages
    :- public(entity_desc/2).
    entity_desc(Entity, Desc) :-
        ( catch(Entity::desc(D), _, D = Entity) -> Desc = D ; Desc = Entity ).

    %% intersection/3 - list intersection
    :- private(intersection/3).
    intersection([], _, []).
    intersection([H|T], L2, [H|R]) :-
        memberchk(H, L2), !,
        intersection(T, L2, R).
    intersection([_|T], L2, R) :-
        intersection(T, L2, R).

:- end_object.
