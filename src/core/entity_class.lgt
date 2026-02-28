%% entity_class.lgt
%%
%% Abstract base classes for all game entities.
%% Defines the interface that rooms, objects, and NPCs implement.
%%
%% Hierarchy:
%%   entity  - base for all game objects (items, doors, furniture)
%%     npc   - extends entity for characters/people
%%   room    - base for all locations

% =================================================================
%  PROTOTYPE: entity
%  Base for all game objects (items, containers, doors, furniture)
% =================================================================

:- object(entity).

    :- info([
        version is 1:0:0,
        comment is 'Abstract base for all game entities.'
    ]).

    :- public(desc/1).
    :- public(ldesc/1).
    :- public(fdesc/1).
    :- public(synonym/1).
    :- public(adjective/1).
    :- public(size/1).
    :- public(capacity/1).
    :- public(initial_location/1).
    :- public(initial_flags/1).
    :- public(action/1).
    :- public(article/1).
    :- public(read_text/1).
    :- public(pill_count/1).

    size(5).
    capacity(100).
    initial_flags([]).
    article(the).

    :- public(has_flag_now/1).
    has_flag_now(Flag) :-
        self(Self),
        state::has_flag(Self, Flag).

    :- public(is_visible/0).
    is_visible :-
        \+ has_flag_now(invisible).

    :- public(is_open/0).
    is_open :-
        has_flag_now(openbit).

    :- public(is_takeable/0).
    is_takeable :-
        has_flag_now(takebit).

    :- public(describe/0).
    describe :-
        self(Self),
        ( state::has_flag(Self, touchbit) ->
            ( ::ldesc(D) -> true ; ::desc(D) )
        ;
            ( ::fdesc(D) -> true
            ; ::ldesc(D) -> true
            ; ::desc(D)
            )
        ),
        writeln(D).

    :- public(describe_in_room/0).
    describe_in_room :-
        is_visible,
        \+ has_flag_now(ndescbit),
        ::desc(D),
        format("There is ~w here.~n", [D]).

:- end_object.


% =================================================================
%  PROTOTYPE: npc
%  Extends entity for non-player characters (people)
% =================================================================

:- object(npc,
    extends(entity)).

    :- info([
        version is 1:0:0,
        comment is 'Abstract base for NPCs/people. Extends entity.'
    ]).

    :- public(character_index/1).
    :- public(transit_line/1).
    :- public(dialogue_response/2).
    :- public(greet_response/0).
    :- public(give_response/1).
    :- public(show_response/1).

    initial_flags([person]).

    :- public(is_person/0).
    is_person.

    describe_in_room :-
        is_visible,
        \+ has_flag_now(ndescbit),
        ::desc(D),
        format("~w is here.~n", [D]).

:- end_object.


% =================================================================
%  PROTOTYPE: room
%  Base for all game locations
% =================================================================

:- object(room).

    :- info([
        version is 1:0:0,
        comment is 'Abstract base for all game rooms/locations.'
    ]).

    :- public(desc/1).
    :- public(ldesc/1).
    :- public(fdesc/1).
    :- public(exit/3).
    :- public(action/1).
    :- public(global_objects/1).
    :- public(initial_flags/1).
    :- public(synonym/1).
    :- public(adjective/1).
    :- public(station/1).
    :- public(line/1).

    global_objects([]).
    initial_flags([rlandbit, onbit]).

    :- public(is_lit/0).
    is_lit :-
        self(Self),
        ( state::has_flag(Self, onbit) -> true
        ;
            state::location(LightObj, Self),
            state::has_flag(LightObj, lightbit),
            state::has_flag(LightObj, onbit)
        ).

    :- public(describe/0).
    describe :-
        self(Self),
        ::desc(ShortDesc),
        writeln(ShortDesc),
        ( state::has_flag(Self, touchbit) ->
            true
        ;
            ( ::ldesc(LD) -> writeln(LD)
            ; ::fdesc(FD) -> writeln(FD)
            ; true
            )
        ).

    :- public(describe_exits/0).
    describe_exits :-
        ( ::exit(_, _, _) -> true ; true ).

    :- public(get_exit/2).
    get_exit(Dir, Target) :-
        ::exit(Dir, Target, Condition),
        check_condition(Condition).

    :- private(check_condition/1).
    check_condition(always).
    check_condition(Cond) :-
        is_list(Cond),
        Cond = [door, DoorEntity, open],
        state::has_flag(DoorEntity, openbit).
    check_condition(Cond) :-
        is_list(Cond),
        Cond = [flag, Flag],
        state::global_val(Flag, true).
    check_condition(Msg) :-
        atom(Msg),
        Msg \= always,
        writeln(Msg), fail.
    check_condition(Msg) :-
        string(Msg),
        writeln(Msg), fail.

:- end_object.
