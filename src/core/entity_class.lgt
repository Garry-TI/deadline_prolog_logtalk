%%%  entity_class.lgt  %%%
%%%
%%%  Abstract base classes for all game entities.
%%%  Defines the interface that all rooms, objects, and NPCs must implement.
%%%
%%%  Hierarchy:
%%%    entity          <- base for all game objects (items, doors, furniture)
%%%      npc           <- extends entity for characters/people
%%%    room            <- base for all locations
%%%
%%%  ZIL source: dungeon.zil (OBJECT/ROOM structure and properties)
%%%
%%%  Copyright 1982 Infocom, Inc. (original game)
%%%  Logtalk refactoring: see CLAUDE.md

%% ===================================================================
%%  ABSTRACT CLASS: entity
%%  Base for all game objects (items, containers, doors, furniture, NPCs)
%% ===================================================================

:- object(entity,
    instantiates(class),
    specializes(object)).

    :- info([
        version is 1:0:0,
        comment is 'Abstract base class for all game entities (objects, items, NPCs).'
    ]).

    %% desc(?Description) — short name (used in room listings, "the DESC")
    :- public desc/1.
    :- multifile desc/1.

    %% ldesc(?LongDescription) — long description (shown on EXAMINE or first look)
    :- public ldesc/1.
    :- multifile ldesc/1.

    %% fdesc(?FirstDescription) — description before object is touched/taken
    :- public fdesc/1.
    :- multifile fdesc/1.

    %% synonym(+Entity, ?WordList) — words that identify this entity
    :- public synonym/1.
    :- multifile synonym/1.

    %% adjective(+Entity, ?AdjList) — adjectives for this entity
    :- public adjective/1.
    :- multifile adjective/1.

    %% size(?Size) — object size/weight for carry limit (ZIL SIZE property)
    :- public size/1.
    :- multifile size/1.
    size(5).   % default size

    %% capacity(?Capacity) — max total size this container can hold
    :- public capacity/1.
    :- multifile capacity/1.
    capacity(100).  % default unlimited

    %% initial_location(?Room) — where entity starts at game begin
    :- public initial_location/1.
    :- multifile initial_location/1.

    %% initial_flags(?FlagList) — flags set at game start
    :- public initial_flags/1.
    :- multifile initial_flags/1.
    initial_flags([]).

    %% action(?Routine) — action handler routine for this entity
    :- public action/1.
    :- multifile action/1.

    %% article(?Article) — article to use ("a", "an", "the", "")
    :- public article/1.
    article(the).

    %% has_flag_now(?Flag) — runtime flag check (uses state)
    :- public has_flag_now/1.
    has_flag_now(Flag) :-
        self(Self),
        state::has_flag(Self, Flag).

    %% is_visible — true if entity is not invisible at runtime
    :- public is_visible/0.
    is_visible :-
        \+ self::has_flag_now(invisible).

    %% is_open — true if entity is currently open
    :- public is_open/0.
    is_open :-
        self::has_flag_now(openbit).

    %% is_takeable — true if entity can be taken
    :- public is_takeable/0.
    is_takeable :-
        self::has_flag_now(takebit).

    %% describe — print the entity's description
    :- public describe/0.
    describe :-
        self(Self),
        ( state::has_flag(Self, touchbit) ->
            ( self::ldesc(D) -> true ; self::desc(D) )
        ;
            ( self::fdesc(D) -> true
            ; self::ldesc(D) -> true
            ; self::desc(D)
            )
        ),
        writeln(D).

    %% describe_in_room — how this entity appears in a room listing
    :- public describe_in_room/0.
    describe_in_room :-
        self::is_visible,
        \+ self::has_flag_now(ndescbit),
        self::desc(D),
        format("There is ~w here.~n", [D]).

:- end_object.


%% ===================================================================
%%  ABSTRACT CLASS: npc
%%  Extends entity for non-player characters (people)
%% ===================================================================

:- object(npc,
    instantiates(class),
    specializes(entity)).

    :- info([
        version is 1:0:0,
        comment is 'Abstract base class for NPCs/people. Extends entity.'
    ]).

    %% character_index(?Index) — index in GLOBAL-CHARACTER-TABLE (for pronouns)
    :- public character_index/1.
    :- multifile character_index/1.

    %% transit_line(?Line) — which transit line this NPC uses for movement
    :- public transit_line/1.
    :- multifile transit_line/1.

    %% initial_flags override — all NPCs get person flag
    initial_flags([person]).

    %% is_person — confirms this is an NPC
    :- public is_person/0.
    is_person.

    %% describe_in_room override for NPCs
    describe_in_room :-
        self::is_visible,
        \+ self::has_flag_now(ndescbit),
        self::desc(D),
        format("~w is here.~n", [D]).

:- end_object.


%% ===================================================================
%%  ABSTRACT CLASS: room
%%  Base for all game locations
%% ===================================================================

:- object(room,
    instantiates(class),
    specializes(object)).

    :- info([
        version is 1:0:0,
        comment is 'Abstract base class for all game rooms/locations.'
    ]).

    %% desc(?ShortDescription) — room name (shown in brief mode, compass)
    :- public desc/1.
    :- multifile desc/1.

    %% ldesc(?LongDescription) — full room description
    :- public ldesc/1.
    :- multifile ldesc/1.

    %% fdesc(?FirstDescription) — description shown on first visit
    :- public fdesc/1.
    :- multifile fdesc/1.

    %% exit(+Direction, ?Target, ?Condition) — room exit definition
    %%   Direction: north | south | east | west | ne | nw | se | sw | up | down | in | out
    %%   Target:    room atom | none
    %%   Condition: always | [door, DoorEntity, open] | [flag, FlagName] | string (blocked msg)
    :- public exit/3.
    :- multifile exit/3.

    %% action(?Routine) — room action handler (for M-BEG, M-END, M-ENTER, M-LOOK)
    :- public action/1.
    :- multifile action/1.

    %% global_objects(?ObjectList) — local-global objects referenceable in this room
    :- public global_objects/1.
    :- multifile global_objects/1.
    global_objects([]).

    %% initial_flags(?FlagList) — room flags at game start
    :- public initial_flags/1.
    :- multifile initial_flags/1.
    initial_flags([rlandbit, onbit]).

    %% synonym(?WordList) — words that identify this room
    :- public synonym/1.
    :- multifile synonym/1.

    %% adjective(?AdjList) — adjectives for this room
    :- public adjective/1.
    :- multifile adjective/1.

    %% station(?TransitStation) — NPC transit station for this room
    :- public station/1.
    :- multifile station/1.

    %% line(?LineNumber) — transit line number for this room
    :- public line/1.
    :- multifile line/1.

    %% is_lit — true if room is currently lit
    :- public is_lit/0.
    is_lit :-
        self(Self),
        ( state::has_flag(Self, onbit) -> true
        ;
          % Check if any light-producing object is in the room
          state::location(LightObj, Self),
          state::has_flag(LightObj, lightbit),
          state::has_flag(LightObj, onbit)
        ).

    %% describe — print full room description
    :- public describe/0.
    describe :-
        self(Self),
        self::desc(ShortDesc),
        format("~`-t~*|~n", [50]),
        writeln(ShortDesc),
        format("~`-t~*|~n", [50]),
        ( state::has_flag(Self, touchbit) ->
            true  % brief mode: just show title
        ;
            ( self::ldesc(LD) -> writeln(LD)
            ; self::fdesc(FD) -> writeln(FD)
            ; true
            )
        ).

    %% describe_exits — list available exits
    :- public describe_exits/0.
    describe_exits :-
        ( self::exit(_, _, _) ->
            true  % exits listed as part of room description in ZIL
        ;   true
        ).

    %% get_exit(+Direction, ?Target) — resolve an exit given game state
    :- public get_exit/2.
    get_exit(Dir, Target) :-
        self::exit(Dir, Target, Condition),
        check_exit_condition(Condition, Target).

    :- private check_exit_condition/2.
    check_exit_condition(always, _).
    check_exit_condition([door, DoorEntity, open], _) :-
        state::has_flag(DoorEntity, openbit).
    check_exit_condition([flag, Flag], _) :-
        state::global_val(Flag, true).
    check_exit_condition(Msg, _) :-
        atom(Msg), writeln(Msg), fail.
    check_exit_condition(Msg, _) :-
        string(Msg), writeln(Msg), fail.

:- end_object.
