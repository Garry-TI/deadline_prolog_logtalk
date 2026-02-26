%%%  state.lgt  %%%
%%%
%%%  Central dynamic state management for the Deadline game.
%%%  ALL mutable game state is declared and managed here.
%%%
%%%  ZIL equivalents:
%%%    location/2     <- <MOVE obj dest> / <LOC obj> / <IN? obj loc>
%%%    has_flag/2     <- <FSET obj flag> / <FCLEAR obj flag> / <FSET? obj flag>
%%%    global_val/2   <- <GLOBAL name val> / <SETG name val>
%%%    event/3        <- <QUEUE rtn delay> / <ENABLE> / <DISABLE>
%%%    current_room/1 <- HERE
%%%    current_actor/1 <- WINNER
%%%    current_verb/1 <- PRSA
%%%    current_do/1   <- PRSO (direct object)
%%%    current_io/1   <- PRSI (indirect object)
%%%
%%%  Copyright 1982 Infocom, Inc. (original game)
%%%  Logtalk refactoring: see CLAUDE.md

:- object(state).

    :- info([
        version is 1:0:0,
        comment is 'Central dynamic game state - all mutable facts live here.'
    ]).

    %% ---------------------------------------------------------------
    %% SPATIAL STATE
    %% ---------------------------------------------------------------

    %% location(Entity, Place) - where an entity currently is
    %% Entity can be: any object atom, npc atom, or 'player'
    %% Place can be: any room atom, container object atom
    :- public(location/2).
    :- dynamic(location/2).

    %% ---------------------------------------------------------------
    %% OBJECT STATE - FLAGS
    %% ---------------------------------------------------------------

    %% has_flag(Entity, Flag) - entity currently has this flag set
    %% Replaces ZIL FSET/FCLEAR/FSET? bitmask operations
    :- public(has_flag/2).
    :- dynamic(has_flag/2).

    %% ---------------------------------------------------------------
    %% GLOBAL VARIABLES
    %% ---------------------------------------------------------------

    %% global_val(Name, Value) - named global game variables
    %% Replaces ZIL <GLOBAL name val> and <SETG name val>
    %%
    %% Key globals:
    %%   present_time  - ticks elapsed (0..1199, then game over)
    %%   score         - current hour (8..23, then 0)
    %%   moves         - moves within current hour (0..59)
    %%   p_won         - whether last parser call succeeded
    %%   lit           - whether current room is lit
    %%   clock_wait    - if true, skip one clocker tick
    %%   load_max      - max carry weight (100)
    %%   load_allowed  - current carry weight remaining
    %%   verbose_mode  - brief/verbose room descriptions
    %%   last_verb     - L-PRSA: last action's verb
    %%   last_do       - L-PRSO: last action's direct object
    %%   last_io       - L-PRSI: last action's indirect object
    %%   gardener_angry - gardener is blocking access
    %%   ladder_flag   - ladder is visible in rose garden
    %%   qcontext      - NPC being addressed in dialogue
    %%   qcontext_room - room where dialogue context is valid
    :- public(global_val/2).
    :- dynamic(global_val/2).

    %% ---------------------------------------------------------------
    %% CURRENT ACTION STATE (parser output)
    %% ---------------------------------------------------------------

    %% current_room(Room) - player's current location (ZIL HERE)
    :- public(current_room/1).
    :- dynamic(current_room/1).

    %% current_actor(Actor) - who is acting (ZIL WINNER)
    :- public(current_actor/1).
    :- dynamic(current_actor/1).

    %% current_verb(Verb) - parsed action verb (ZIL PRSA)
    :- public(current_verb/1).
    :- dynamic(current_verb/1).

    %% current_do(DirectObj) - direct object (ZIL PRSO)
    :- public(current_do/1).
    :- dynamic(current_do/1).

    %% current_io(IndirectObj) - indirect object (ZIL PRSI)
    :- public(current_io/1).
    :- dynamic(current_io/1).

    %% pronoun(Type, Entity) - pronoun referent tracking
    %% Type: it | him_her
    :- public(pronoun/2).
    :- dynamic(pronoun/2).

    %% pronoun_room(Type, Room) - room where pronoun was set
    :- public(pronoun_room/2).
    :- dynamic(pronoun_room/2).

    %% ---------------------------------------------------------------
    %% EVENT / CLOCK SYSTEM
    %% ---------------------------------------------------------------

    %% event(Routine, FireAtTick, Priority)
    %%   Routine    - callable predicate (0-arity) to execute
    %%   FireAtTick - countdown ticks remaining before firing
    %%   Priority   - demon | normal (demons run first)
    :- public(event/3).
    :- dynamic(event/3).

    %% event_enabled(Routine) - event is active in queue
    :- public(event_enabled/1).
    :- dynamic(event_enabled/1).

    %% ---------------------------------------------------------------
    %% NPC AI STATE
    %% ---------------------------------------------------------------

    %% npc_goal(NPC, PathList) - remaining rooms in NPC's path
    :- public(npc_goal/2).
    :- dynamic(npc_goal/2).

    %% npc_goal_enabled(NPC) - NPC is actively pursuing a goal
    :- public(npc_goal_enabled/1).
    :- dynamic(npc_goal_enabled/1).

    %% ---------------------------------------------------------------
    %% CONVENIENCE PREDICATES
    %% ---------------------------------------------------------------

    %% set_global(+Name, +Value) - update a global variable
    :- public(set_global/2).
    set_global(Name, Value) :-
        retractall(global_val(Name, _)),
        assertz(global_val(Name, Value)).

    %% get_global(+Name, ?Value) - retrieve a global variable
    :- public(get_global/2).
    get_global(Name, Value) :-
        global_val(Name, Value).

    %% set_flag(+Entity, +Flag) - set a flag on an entity
    :- public(set_flag/2).
    set_flag(Entity, Flag) :-
        ( has_flag(Entity, Flag) -> true
        ; assertz(has_flag(Entity, Flag))
        ).

    %% clear_flag(+Entity, +Flag) - remove a flag from an entity
    :- public(clear_flag/2).
    clear_flag(Entity, Flag) :-
        retractall(has_flag(Entity, Flag)).

    %% test_flag(+Entity, +Flag) - test if entity has flag
    :- public(test_flag/2).
    test_flag(Entity, Flag) :-
        has_flag(Entity, Flag).

    %% move_entity(+Entity, +Destination) - move entity to new location
    :- public(move_entity/2).
    move_entity(Entity, Destination) :-
        retractall(location(Entity, _)),
        assertz(location(Entity, Destination)).

    %% remove_entity(+Entity) - remove entity from all locations
    :- public(remove_entity/1).
    remove_entity(Entity) :-
        retractall(location(Entity, _)).

    %% entity_at(+Entity, ?Place) - test/get entity location
    :- public(entity_at/2).
    entity_at(Entity, Place) :-
        location(Entity, Place).

    %% entities_in(+Place, -Entities) - all entities at a location
    :- public(entities_in/2).
    entities_in(Place, Entities) :-
        findall(E, location(E, Place), Entities).

    %% set_current_room(+Room) - update player's current room
    :- public(set_current_room/1).
    set_current_room(Room) :-
        retractall(current_room(_)),
        assertz(current_room(Room)).

    %% set_current_actor(+Actor) - update current actor (WINNER)
    :- public(set_current_actor/1).
    set_current_actor(Actor) :-
        retractall(current_actor(_)),
        assertz(current_actor(Actor)).

    %% set_current_action(+Verb, +DO, +IO) - update parsed action
    :- public(set_current_action/3).
    set_current_action(Verb, DO, IO) :-
        retractall(current_verb(_)),
        retractall(current_do(_)),
        retractall(current_io(_)),
        assertz(current_verb(Verb)),
        assertz(current_do(DO)),
        assertz(current_io(IO)).

    %% increment_global(+Name, ?OldVal, ?NewVal) - increment numeric global
    :- public(increment_global/3).
    increment_global(Name, OldVal, NewVal) :-
        ( global_val(Name, OldVal) -> true ; OldVal = 0 ),
        NewVal is OldVal + 1,
        set_global(Name, NewVal).

    %% add_to_global(+Name, +Amount, ?NewVal) - add amount to numeric global
    :- public(add_to_global/3).
    add_to_global(Name, Amount, NewVal) :-
        ( global_val(Name, OldVal) -> true ; OldVal = 0 ),
        NewVal is OldVal + Amount,
        set_global(Name, NewVal).

:- end_object.
