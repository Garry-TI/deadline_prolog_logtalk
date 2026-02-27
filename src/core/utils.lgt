%%%  utils.lgt  %%%
%%%
%%%  Utility predicates for the Deadline game engine.
%%%  Corresponds to ZIL macros.zil and common helper patterns.
%%%
%%%  ZIL source: macros.zil (TELL, VERB?, PROB, RFATAL, ENABLE, DISABLE, ABS)
%%%
%%%  Copyright 1982 Infocom, Inc. (original game)
%%%  Logtalk refactoring: see CLAUDE.md

:- object(utils).

    :- info([
        version is 1:0:0,
        comment is 'Utility predicates: output, probability, entity queries.'
    ]).

    :- uses(user, [random_between/3, nth0/3, length/2, memberchk/2]).

    %% ---------------------------------------------------------------
    %% OUTPUT UTILITIES
    %% ZIL TELL macro equivalent
    %% ---------------------------------------------------------------

    %% tell(+Text) - print text with newline (ZIL <TELL "text" CR>)
    :- public(tell/1).
    tell(Text) :-
        writeln(Text).

    %% tell_no_nl(+Text) - print text without newline
    :- public(tell_no_nl/1).
    tell_no_nl(Text) :-
        write(Text).

    %% tell_format(+Format, +Args) - formatted output
    :- public(tell_format/2).
    tell_format(Format, Args) :-
        format(Format, Args).

    %% crlf - print a newline (ZIL <CRLF>)
    :- public(crlf/0).
    crlf :- nl.

    %% print_desc(+Entity) - print entity description with article
    :- public(print_desc/1).
    print_desc(Entity) :-
        ( catch(Entity::article(Art), _, Art = the) -> true ; Art = the ),
        catch(Entity::desc(D), _, D = Entity),
        format("~w ~w", [Art, D]).

    %% ---------------------------------------------------------------
    %% PROBABILITY UTILITIES
    %% ZIL PROB macro: <PROB N> returns true N% of the time
    %% ---------------------------------------------------------------

    %% prob(+Percent) - succeed Percent% of the time (0-100)
    :- public(prob/1).
    prob(Percent) :-
        integer(Percent),
        Percent >= 0,
        Percent =< 100,
        random_between(1, 100, R),
        R =< Percent.

    %% pick_one(+List, -Element) - pick a random element from a list
    :- public(pick_one/2).
    pick_one(List, Element) :-
        length(List, Len),
        Len > 0,
        random_between(0, Len-1, Idx),
        nth0(Idx, List, Element).

    %% random_range(+Min, +Max, -Value) - random integer in [Min, Max]
    :- public(random_range/3).
    random_range(Min, Max, Value) :-
        random_between(Min, Max, Value).

    %% abs_val(+N, -AbsN) - absolute value (ZIL ABS macro)
    :- public(abs_val/2).
    abs_val(N, AbsN) :-
        AbsN is abs(N).

    %% ---------------------------------------------------------------
    %% VERB/ACTION TESTING
    %% ZIL VERB? macro: <VERB? v1 v2 ...>
    %% ---------------------------------------------------------------

    %% current_verb_is(+VerbList) - test if current verb matches any in list
    :- public(current_verb_is/1).
    current_verb_is(VerbList) :-
        state::current_verb(V),
        memberchk(V, VerbList).

    %% ---------------------------------------------------------------
    %% ENTITY QUERY UTILITIES
    %% ---------------------------------------------------------------

    %% is_in_room(+Entity, +Room) - entity is at this room (ZIL IN?)
    :- public(is_in_room/2).
    is_in_room(Entity, Room) :-
        state::location(Entity, Room).

    %% is_in(+Entity, +Container) - entity is inside container
    :- public(is_in/2).
    is_in(Entity, Container) :-
        state::location(Entity, Container).

    %% objects_in_room(+Room, -Objects) - list of visible objects in room
    :- public(objects_in_room/2).
    objects_in_room(Room, Objects) :-
        findall(Obj, (
            state::location(Obj, Room),
            Obj \= player,
            \+ state::has_flag(Obj, invisible),
            \+ state::has_flag(Obj, ndescbit)
        ), Objects).

    %% npcs_in_room(+Room, -NPCs) - list of NPCs in room
    :- public(npcs_in_room/2).
    npcs_in_room(Room, NPCs) :-
        findall(NPC, (
            state::location(NPC, Room),
            state::has_flag(NPC, person)
        ), NPCs).

    %% player_has(+Item) - player is carrying item
    :- public(player_has/1).
    player_has(Item) :-
        state::location(Item, player).

    %% player_in_room(+Room) - player is in this room
    :- public(player_in_room/1).
    player_in_room(Room) :-
        state::current_room(Room).

    %% player_weight - total weight player is carrying
    :- public(player_weight/1).
    player_weight(Total) :-
        findall(S, (
            state::location(Item, player),
            ( catch(Item::size(S), _, S = 5) -> true ; S = 5 )
        ), Sizes),
        sumlist(Sizes, Total).

    %% can_carry(+Item) - player can carry this item (weight check)
    :- public(can_carry/1).
    can_carry(Item) :-
        ( catch(Item::size(S), _, S = 5) -> true ; S = 5 ),
        player_weight(Current),
        state::global_val(load_max, Max),
        Current + S =< Max.

    %% ---------------------------------------------------------------
    %% DIRECTION UTILITIES
    %% ---------------------------------------------------------------

    %% normalize_direction(+Input, -Direction) - normalize direction synonyms
    :- public(normalize_direction/2).
    normalize_direction(n, north).
    normalize_direction(s, south).
    normalize_direction(e, east).
    normalize_direction(w, west).
    normalize_direction(u, up).
    normalize_direction(d, down).
    normalize_direction(nw, northwest).
    normalize_direction(ne, northeast).
    normalize_direction(sw, southwest).
    normalize_direction(se, southeast).
    normalize_direction(northwest, northwest).
    normalize_direction(northeast, northeast).
    normalize_direction(southwest, southwest).
    normalize_direction(southeast, southeast).
    normalize_direction(north, north).
    normalize_direction(south, south).
    normalize_direction(east, east).
    normalize_direction(west, west).
    normalize_direction(up, up).
    normalize_direction(down, down).
    normalize_direction(in, in).
    normalize_direction(out, out).
    normalize_direction(upstairs, up).
    normalize_direction(downstairs, down).

    %% all_directions(-Dirs) - list of all valid directions
    :- public(all_directions/1).
    all_directions([north, south, east, west, northeast, northwest, southeast, southwest,
                    up, down, in, out]).

    %% ---------------------------------------------------------------
    %% ROOM DESCRIPTION UTILITIES
    %% ---------------------------------------------------------------

    %% describe_room_contents(+Room) - list items and NPCs in room
    :- public(describe_room_contents/1).
    describe_room_contents(Room) :-
        findall(NPC, (
            state::location(NPC, Room),
            NPC \= player,
            state::has_flag(NPC, person),
            \+ state::has_flag(NPC, invisible)
        ), NPCs),
        describe_npc_list(NPCs),
        findall(Obj, (
            state::location(Obj, Room),
            \+ state::has_flag(Obj, person),
            \+ state::has_flag(Obj, invisible),
            \+ state::has_flag(Obj, ndescbit),
            Obj \= player
        ), Objs),
        describe_obj_list(Objs).

    :- private(describe_npc_list/1).
    describe_npc_list([]).
    describe_npc_list([NPC|Rest]) :-
        get_entity_desc(NPC, D),
        format("~w is here.~n", [D]),
        describe_npc_list(Rest).

    :- private(describe_obj_list/1).
    describe_obj_list([]).
    describe_obj_list([Obj|Rest]) :-
        describe_object_in_room(Obj),
        describe_obj_list(Rest).

    :- private(describe_object_in_room/1).
    describe_object_in_room(Obj) :-
        %% Use fdesc (first description) if object hasn't been touched
        ( \+ state::has_flag(Obj, touchbit),
          catch(Obj::fdesc(FD), _, fail) ->
            writeln(FD)
        ;
            get_entity_desc(Obj, D),
            format("There is ~w here.~n", [D])
        ),
        %% If object is a surface/open container, list its visible contents
        describe_surface_contents(Obj).

    :- private(describe_surface_contents/1).
    describe_surface_contents(Obj) :-
        ( ( state::has_flag(Obj, surfacebit) ; state::has_flag(Obj, contbit) ),
          state::has_flag(Obj, openbit) ->
            findall(Child, (
                state::location(Child, Obj),
                \+ state::has_flag(Child, invisible),
                \+ state::has_flag(Child, ndescbit)
            ), Children),
            describe_surface_children(Obj, Children)
        ; true
        ).

    :- private(describe_surface_children/2).
    describe_surface_children(_, []).
    describe_surface_children(Surface, [Child|Rest]) :-
        get_entity_desc(Surface, SD),
        ( \+ state::has_flag(Child, touchbit),
          catch(Child::fdesc(FD), _, fail) ->
            writeln(FD)
        ;
            get_entity_desc(Child, CD),
            format("Sitting on the ~w is ~w.~n", [SD, CD])
        ),
        describe_surface_children(Surface, Rest).

    :- private(get_entity_desc/2).
    get_entity_desc(Entity, Desc) :-
        ( catch(Entity::desc(D), _, fail) ->
            Desc = D
        ;
            Desc = Entity
        ).

    %% ---------------------------------------------------------------
    %% STRING/TEXT UTILITIES
    %% ---------------------------------------------------------------

    %% article_for(+Entity, -Article) - get appropriate article
    :- public(article_for/2).
    article_for(Entity, an) :-
        state::has_flag(Entity, vowelbit), !.
    article_for(Entity, '') :-
        state::has_flag(Entity, narticlebit), !.
    article_for(_, a).

    %% print_list(+List) - print a comma-separated list
    :- public(print_list/1).
    print_list([]) :- nl.
    print_list([X]) :- write(X), nl.
    print_list([X|Rest]) :-
        write(X), write(', '),
        print_list(Rest).

    %% sumlist(+List, -Sum) - sum a list of numbers
    :- public(sumlist/2).
    sumlist([], 0).
    sumlist([H|T], Sum) :-
        sumlist(T, Rest),
        Sum is H + Rest.

:- end_object.
