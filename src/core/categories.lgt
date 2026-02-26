%%%  categories.lgt  %%%
%%%
%%%  Logtalk categories providing shared behavior traits for game entities.
%%%  Categories are imported by object prototypes to add behavior.
%%%
%%%  ZIL equivalent: FLAGS bit-fields (TAKEBIT, CONTBIT, DOORBIT, etc.)
%%%  Each category corresponds to one or more ZIL flag combinations.
%%%
%%%  Copyright 1982 Infocom, Inc. (original game)
%%%  Logtalk refactoring: see CLAUDE.md

%% ===================================================================
%%  CATEGORY: takeable
%%  Objects that can be picked up by the player (ZIL TAKEBIT)
%% ===================================================================

:- category(takeable).

    :- info([
        version is 1:0:0,
        comment is 'Provides take/drop behavior. Corresponds to ZIL TAKEBIT.'
    ]).

    :- public(can_take/0).
    can_take.

    :- public(take_action/0).
    take_action :-
        self(Self),
        state::current_actor(Actor),
        state::location(Self, _OldLoc),
        state::move_entity(Self, Actor),
        state::set_flag(Self, touchbit),
        self::desc(D),
        format("Taken.~n", []),
        % Update pronoun IT
        state::retractall(pronoun(it, _)),
        state::assertz(pronoun(it, Self)),
        state::current_room(R),
        state::retractall(pronoun_room(it, _)),
        state::assertz(pronoun_room(it, R)).

    :- public(drop_action/0).
    drop_action :-
        self(Self),
        state::current_room(Room),
        state::move_entity(Self, Room),
        self::desc(D),
        format("Dropped.~n", []).

:- end_category.


%% ===================================================================
%%  CATEGORY: container
%%  Objects that can hold other objects (ZIL CONTBIT)
%% ===================================================================

:- category(container).

    :- info([
        version is 1:0:0,
        comment is 'Container behavior. Corresponds to ZIL CONTBIT.'
    ]).

    :- public(can_contain/0).
    can_contain.

    :- public(put_in_action/1).
    put_in_action(Item) :-
        self(Self),
        ( state::has_flag(Self, openbit) ->
            state::move_entity(Item, Self),
            format("Done.~n", [])
        ;
            self::desc(D),
            format("The ~w is closed.~n", [D])
        ).

    :- public(list_contents/0).
    list_contents :-
        self(Self),
        self::desc(D),
        ( state::location(_, Self) ->
            format("The ~w contains:~n", [D]),
            forall(
                state::location(Item, Self),
                ( entity::desc(Item, ID), format("  ~w~n", [ID]) )
            )
        ;
            format("The ~w is empty.~n", [D])
        ).

:- end_category.


%% ===================================================================
%%  CATEGORY: door
%%  Openable/closable barriers between rooms (ZIL DOORBIT CONTBIT)
%% ===================================================================

:- category(door).

    :- info([
        version is 1:0:0,
        comment is 'Door behavior (open/close/lock). ZIL DOORBIT.'
    ]).

    :- public(is_door/0).
    is_door.

    :- public(open_action/0).
    open_action :-
        self(Self),
        ( state::has_flag(Self, openbit) ->
            self::desc(D),
            format("The ~w is already open.~n", [D])
        ; state::has_flag(Self, lockbit) ->
            self::desc(D),
            format("The ~w is locked.~n", [D])
        ;
            state::set_flag(Self, openbit),
            self::desc(D),
            format("Opened.~n", [])
        ).

    :- public(close_action/0).
    close_action :-
        self(Self),
        ( state::has_flag(Self, openbit) ->
            state::clear_flag(Self, openbit),
            self::desc(D),
            format("Closed.~n", [])
        ;
            self::desc(D),
            format("The ~w is already closed.~n", [D])
        ).

    :- public(lock_action/1).
    lock_action(KeyObj) :-
        self(Self),
        ( state::has_flag(Self, lockbit) ->
            self::desc(D),
            format("The ~w is already locked.~n", [D])
        ;
            state::clear_flag(Self, openbit),
            state::set_flag(Self, lockbit),
            format("Locked.~n", [])
        ).

    :- public(unlock_action/1).
    unlock_action(KeyObj) :-
        self(Self),
        ( state::has_flag(Self, lockbit) ->
            state::clear_flag(Self, lockbit),
            self::desc(D),
            format("Unlocked.~n", [])
        ;
            self::desc(D),
            format("The ~w is not locked.~n", [D])
        ).

:- end_category.


%% ===================================================================
%%  CATEGORY: lockable
%%  Objects that can be locked/unlocked (extends door behavior)
%% ===================================================================

:- category(lockable).

    :- info([
        version is 1:0:0,
        comment is 'Lockable objects (doors/containers that need a key).'
    ]).

    :- public(required_key/1).
    :- multifile required_key/1.

:- end_category.


%% ===================================================================
%%  CATEGORY: person
%%  NPC character behavior (ZIL FLAGS PERSON)
%% ===================================================================

:- category(person).

    :- info([
        version is 1:0:0,
        comment is 'NPC person behavior. Corresponds to ZIL PERSON flag.'
    ]).

    :- public(is_person/0).
    is_person.

    %% dialogue_response(+Topic, -Response) - NPC dialogue
    :- public(dialogue_response/2).
    :- multifile dialogue_response/2.

    %% give_response(+Item) - NPC reaction to being given an item
    :- public(give_response/1).
    :- multifile give_response/1.
    give_response(_) :-
        self::desc(D),
        format("~w doesn't want that.~n", [D]).

    %% show_response(+Item) - NPC reaction to being shown an item
    :- public(show_response/1).
    :- multifile show_response/1.
    show_response(_) :-
        self::desc(D),
        format("~w looks at it carefully.~n", [D]).

    %% greet_response - NPC reaction to HELLO
    :- public(greet_response/0).
    :- multifile greet_response/0.
    greet_response :-
        self::desc(D),
        format("~w nods politely.~n", [D]).

:- end_category.


%% ===================================================================
%%  CATEGORY: surface
%%  Objects things can be placed ON (ZIL SURFACEBIT ONBIT)
%% ===================================================================

:- category(surface).

    :- info([
        version is 1:0:0,
        comment is 'Surface objects (tables, shelves). ZIL SURFACEBIT.'
    ]).

    :- public(can_place_on/0).
    can_place_on.

    :- public(put_on_action/1).
    put_on_action(Item) :-
        self(Self),
        state::move_entity(Item, Self),
        format("Done.~n", []).

    :- public(list_surface/0).
    list_surface :-
        self(Self),
        self::desc(D),
        ( state::location(_, Self) ->
            format("On the ~w:~n", [D]),
            forall(
                state::location(Item, Self),
                ( entity::desc(Item, ID), format("  ~w~n", [ID]) )
            )
        ;   true
        ).

:- end_category.


%% ===================================================================
%%  CATEGORY: readable
%%  Objects that can be read (ZIL READBIT)
%% ===================================================================

:- category(readable).

    :- info([
        version is 1:0:0,
        comment is 'Readable objects (books, papers, signs). ZIL READBIT.'
    ]).

    :- public(read_text/1).
    :- multifile read_text/1.

    :- public(read_action/0).
    read_action :-
        ( self::read_text(Text) ->
            writeln(Text)
        ;
            self::desc(D),
            format("There is nothing written on the ~w.~n", [D])
        ).

:- end_category.


%% ===================================================================
%%  CATEGORY: lightable
%%  Objects that produce or can be lit (ZIL LIGHTBIT BURNBIT FLAMEBIT)
%% ===================================================================

:- category(lightable).

    :- info([
        version is 1:0:0,
        comment is 'Light-producing objects. ZIL LIGHTBIT/BURNBIT/FLAMEBIT.'
    ]).

    :- public(turn_on_action/0).
    turn_on_action :-
        self(Self),
        ( state::has_flag(Self, onbit) ->
            self::desc(D),
            format("The ~w is already on.~n", [D])
        ;
            state::set_flag(Self, onbit),
            self::desc(D),
            format("The ~w is now on.~n", [D])
        ).

    :- public(turn_off_action/0).
    turn_off_action :-
        self(Self),
        ( state::has_flag(Self, onbit) ->
            state::clear_flag(Self, onbit),
            self::desc(D),
            format("The ~w is now off.~n", [D])
        ;
            self::desc(D),
            format("The ~w is already off.~n", [D])
        ).

:- end_category.
