%%%  npc_ai.lgt  %%%
%%%
%%%  NPC movement AI using transit lines and goal-directed pathfinding.
%%%  Each NPC follows a schedule of movement goals; they travel between
%%%  rooms by following their assigned transit line and transferring
%%%  between lines at designated transfer points.
%%%
%%%  ZIL source: goal.zil (ESTABLISH-GOAL, FOLLOW-GOAL, MOVE-PERSON,
%%%              START-MOVEMENT, I-GARDENER, I-DUNBAR, I-GEORGE, etc.)
%%%
%%%  Copyright 1982 Infocom, Inc. (original game)
%%%  Logtalk refactoring: see CLAUDE.md

:- object(npc_ai).

    :- info([
        version is 1:0:0,
        comment is 'NPC movement AI: transit lines, goal pursuit, scheduled movement.'
    ]).

    :- uses(user, [nth0/3, append/3, member/2, numlist/3, reverse/2, random_between/3]).

    %% ---------------------------------------------------------------
    %% TRANSIT LINES
    %% ZIL: TOP-OF-THE-LINE, BOTTOM-LINE, OUTSIDE-LINE, FOOD-LINE
    %% Each line is an ordered list of rooms; NPCs traverse it to reach goals.
    %% ---------------------------------------------------------------

    %% transit_line(+LineId, -RoomList)
    :- public(transit_line/2).

    %% Upstairs hallway (library side → staircase → shall rooms)
    transit_line(top_line, [
        library_balcony, library, corridor_4, corridor_3,
        corridor_2, corridor_1, stair_top, shall_11, shall_12
    ]).

    %% Main floor (foyer → stair area → shall rooms)
    transit_line(bottom_line, [
        foyer, nfoyer, stair_bottom, shall_1, shall_2
    ]).

    %% Exterior grounds circuit
    transit_line(outside_line, [
        front_path, east_of_door, east_side, east_lawn,
        orchard, north_lawn, rose_garden, west_lawn,
        west_side, west_of_door, south_lawn
    ]).

    %% Kitchen/dining area
    transit_line(food_line, [
        dining_room, corner, kitchen, pantry
    ]).

    %% ---------------------------------------------------------------
    %% ROOM LINE MEMBERSHIP
    %% Which transit line a room belongs to (for pathfinding).
    %% ---------------------------------------------------------------

    :- public(room_line/2).

    room_line(library_balcony,  top_line).
    room_line(library,          top_line).
    room_line(corridor_1,       top_line).
    room_line(corridor_2,       top_line).
    room_line(corridor_3,       top_line).
    room_line(corridor_4,       top_line).
    room_line(stair_top,        top_line).
    room_line(shall_11,         top_line).
    room_line(shall_12,         top_line).
    room_line(master_bedroom,   top_line).
    room_line(master_bath,      top_line).
    room_line(north_hall,       top_line).
    room_line(guest_room,       top_line).
    room_line(dunbar_room,      top_line).
    room_line(dunbar_bath,      top_line).
    room_line(george_room,      top_line).
    room_line(george_bath,      top_line).
    room_line(upstairs_closet,  top_line).
    room_line(closet_11,        top_line).
    room_line(bedroom_balcony,  top_line).

    room_line(foyer,            bottom_line).
    room_line(nfoyer,           bottom_line).
    room_line(stair_bottom,     bottom_line).
    room_line(shall_1,          bottom_line).
    room_line(shall_2,          bottom_line).
    room_line(living_room,      bottom_line).
    room_line(rourke_room,      bottom_line).
    room_line(rourke_bath,      bottom_line).
    room_line(south_closet,     bottom_line).

    room_line(front_path,       outside_line).
    room_line(east_of_door,     outside_line).
    room_line(west_of_door,     outside_line).
    room_line(south_lawn,       outside_line).
    room_line(east_lawn,        outside_line).
    room_line(west_lawn,        outside_line).
    room_line(east_side,        outside_line).
    room_line(west_side,        outside_line).
    room_line(north_lawn,       outside_line).
    room_line(rose_garden,      outside_line).
    room_line(in_roses,         outside_line).
    room_line(orchard,          outside_line).
    room_line(in_orchard,       outside_line).
    room_line(behind_shed,      outside_line).
    room_line(shed_room,        outside_line).

    room_line(dining_room,      food_line).
    room_line(corner,           food_line).
    room_line(kitchen,          food_line).
    room_line(pantry,           food_line).

    %% Transfer points between lines
    %% ZIL: STAIRS for top↔bottom, FRONT-PATH/FOYER for outside↔bottom
    :- public(transfer_point/3).
    transfer_point(top_line,     bottom_line,  stair_top).
    transfer_point(top_line,     bottom_line,  stairs).
    transfer_point(bottom_line,  top_line,     stair_bottom).
    transfer_point(bottom_line,  top_line,     stairs).
    transfer_point(outside_line, bottom_line,  front_path).
    transfer_point(bottom_line,  outside_line, foyer).
    transfer_point(food_line,    bottom_line,  corner).
    transfer_point(bottom_line,  food_line,    nfoyer).

    %% ---------------------------------------------------------------
    %% ESTABLISH GOAL
    %% Set an NPC's movement destination.
    %% ZIL: ESTABLISH-GOAL routine in goal.zil
    %% ---------------------------------------------------------------

    :- public(establish_goal/2).
    establish_goal(NPC, Destination) :-
        state::location(NPC, CurrentRoom),
        ( state::npc_goal(NPC, _) ->
            state::retractall(npc_goal(NPC, _))
        ;   true
        ),
        build_path(CurrentRoom, Destination, Path),
        ( Path = [] ->
            true  % already there
        ;
            state::assertz(npc_goal(NPC, Path)),
            state::assertz(npc_goal_enabled(NPC))
        ).

    %% ---------------------------------------------------------------
    %% PATH BUILDING
    %% Find a sequence of rooms from Source to Destination.
    %% Uses transit lines with transfers.
    %% ---------------------------------------------------------------

    :- private(build_path/3).
    build_path(From, To, []) :-
        From = To, !.

    build_path(From, To, Path) :-
        ( room_line(From, SrcLine), room_line(To, DstLine) ->
            ( SrcLine = DstLine ->
                %% Same line: traverse directly
                line_path(SrcLine, From, To, Path)
            ;
                %% Different lines: go to transfer point, then to destination
                transfer_point(SrcLine, DstLine, Transfer),
                line_path(SrcLine, From, Transfer, Leg1),
                line_path(DstLine, Transfer, To, Leg2),
                append(Leg1, Leg2, Path)
            )
        ;
            %% Unknown line: try direct adjacency
            Path = [To]
        ).

    :- private(line_path/4).
    line_path(Line, From, To, Path) :-
        transit_line(Line, Rooms),
        ( nth0(I, Rooms, From), nth0(J, Rooms, To) ->
            ( I =< J ->
                numlist(I, J, Indices),
                indices_to_rooms(Indices, Rooms, Path0),
                Path0 = [_|Path]  % drop From (already there)
            ;
                numlist(J, I, Indices),
                reverse(Indices, RevIdx),
                indices_to_rooms(RevIdx, Rooms, Path0),
                Path0 = [_|Path]
            )
        ;
            Path = [To]  % fallback
        ).

    :- private(indices_to_rooms/3).
    indices_to_rooms([], _, []).
    indices_to_rooms([Idx|Is], Rooms, [R|Rs]) :-
        nth0(Idx, Rooms, R),
        indices_to_rooms(Is, Rooms, Rs).

    %% ---------------------------------------------------------------
    %% FOLLOW GOAL
    %% Advance NPC one step along its current path.
    %% ZIL: FOLLOW-GOAL routine in goal.zil
    %% ---------------------------------------------------------------

    :- public(follow_goal/1).
    follow_goal(NPC) :-
        ( state::npc_goal_enabled(NPC),
          state::npc_goal(NPC, Path),
          Path \= []
        ->
            Path = [NextRoom|Rest],
            move_npc(NPC, NextRoom),
            ( Rest = [] ->
                %% Goal reached
                state::retractall(npc_goal(NPC, _)),
                state::retractall(npc_goal_enabled(NPC)),
                goal_reached(NPC)
            ;
                state::retractall(npc_goal(NPC, _)),
                state::assertz(npc_goal(NPC, Rest))
            )
        ;   true
        ).

    :- private(goal_reached/1).

    %% Gardener reached destination (ZIL: I-GARDENER G-REACHED, goal.zil lines 507-543)
    goal_reached(gardener) :-
        !,
        state::location(gardener, Loc),
        ( Loc = rose_garden ->
            %% Queue I-G-I-G event (2 + random 1-10 ticks)
            random_between(3, 12, Delay),
            clock::queue_and_enable(actions::i_g_i_g, Delay)
        ; Loc = orchard ->
            %% Reclaim ladder if not in orchard
            ( \+ state::location(ladder, orchard) ->
                %% Move ladder to orchard
                ( state::location(ladder, player) ->
                    state::move_entity(ladder, orchard),
                    writeln("McNabb comes over to you and takes the ladder. He walks off"),
                    writeln("toward the orchard.")
                ; state::current_room(PlayerRoom),
                  state::location(ladder, PlayerRoom) ->
                    state::move_entity(ladder, orchard),
                    writeln("McNabb picks up the ladder and walks away toward the orchard.")
                ; state::current_room(orchard) ->
                    state::move_entity(ladder, orchard),
                    writeln("McNabb places the ladder he was carrying on the ground.")
                ;
                    state::move_entity(ladder, orchard)
                ),
                state::clear_flag(ladder, ndescbit),
                state::set_global(ladder_flag, false),
                state::set_global(ladder_flag_2, false),
                state::set_flag(ladder, touchbit)
            ; true )
        ; Loc = in_roses ->
            %% McNabb arrived at in_roses to show holes
            ( state::current_room(in_roses) ->
                %% Player is here — show the hole immediately
                actions::show_hole
            ;
                %% Player hasn't followed yet — queue I-SHOW-HOLE
                clock::queue_and_enable(actions::i_show_hole, 1)
            )
        ;
            true
        ).

    %% Other NPCs — no special arrival behavior
    goal_reached(_NPC) :- true.

    %% ---------------------------------------------------------------
    %% MOVE NPC
    %% Move an NPC to a new room with appropriate narration.
    %% ZIL: MOVE-PERSON routine in goal.zil
    %% ---------------------------------------------------------------

    :- public(move_npc/2).
    move_npc(NPC, Where) :-
        state::location(NPC, OldRoom),
        state::current_room(Here),
        %% Narrate the movement if player can observe it
        narrate_movement(NPC, OldRoom, Where, Here),
        state::move_entity(NPC, Where).

    :- private(narrate_movement/4).
    narrate_movement(NPC, OldRoom, NewRoom, Here) :-
        ( OldRoom = Here ->
            %% NPC leaving player's room
            ( catch(NPC::desc(D), _, D = NPC) -> true ; D = NPC ),
            format("~w leaves to the ~w.~n", [D, NewRoom])
        ; NewRoom = Here ->
            %% NPC entering player's room
            ( catch(NPC::desc(D), _, D = NPC) -> true ; D = NPC ),
            format("~w steps into the room.~n", [D])
        ;   true  % movement invisible to player
        ).

    %% ---------------------------------------------------------------
    %% SCHEDULED NPC MOVEMENT
    %% Each NPC has a movement schedule (time-based goal changes).
    %% ZIL: MOVEMENT-GOALS table in goal.zil
    %% ---------------------------------------------------------------

    %% npc_schedule(+NPC, -Schedule)
    %% Schedule: list of schedule_entry(TickOffset, MaxJitter, Destination)
    :- public(npc_schedule/2).

    npc_schedule(gardener, [
        entry(60,  10, north_lawn),   % 9-10 AM
        entry(60,  10, east_lawn),    % 10-11 AM
        entry(60,  10, rose_garden),  % 11AM-1PM
        entry(120,  0, in_roses),     % inspect roses
        entry(60,  10, orchard),      % 1-2 PM
        entry(60,  15, south_lawn),   % 2-3 PM
        entry(120, 15, west_lawn)     % 3-5 PM
    ]).

    npc_schedule(baxter, [
        entry(120, 2, living_room),   % Arrives ~9:55 AM
        entry(360, 10, south_lawn)    % Leaves ~4 PM
    ]).

    npc_schedule(dunbar, [
        entry(60,  10, dunbar_bath),   % 9-9:30 AM
        entry(30,  10, dunbar_room),   % 9:30-11:30 AM
        entry(135, 20, living_room),   % 11:30 AM-2 PM
        entry(135, 20, dunbar_room)
    ]).

    npc_schedule(george, [
        entry(80,  10, kitchen),       % 9:20-9:50 AM
        entry(30,  10, dining_room),   % 9:50-11 AM
        entry(70,  20, george_room),   % 11-11:45 AM
        entry(45,  15, living_room),   % 11:45 AM-12:30 PM
        entry(60,  10, east_lawn),     % 12:30-2 PM
        entry(75,  20, living_room),   % 2-3 PM
        entry(60,  15, george_room)
    ]).

    npc_schedule(mrs_robner, [
        entry(30,  10, dining_room),   % 8:30-9 AM
        entry(100, 15, dining_room),   % 10:10-11:10
        entry(60,  20, living_room),   % 11:10-12:40
        entry(90,  20, master_bedroom),% 12:40-1:50
        entry(70,  30, living_room)
    ]).

    npc_schedule(rourke, [
        entry(60,  10, kitchen),       % 9-10 AM
        entry(60,  20, dining_room),   % 10-11 AM
        entry(60,  10, kitchen),       % 11 AM-1 PM
        entry(120, 20, living_room),   % 1PM-2PM
        entry(60,  30, rourke_room)
    ]).

    %% ---------------------------------------------------------------
    %% SCHEDULED MOVEMENT TICK
    %% Call once per move for each NPC to advance their schedule.
    %% ---------------------------------------------------------------

    %% tick_npc/1 - advance NPC one step along their path (called every tick)
    :- public(tick_npc/1).
    tick_npc(NPC) :-
        ( state::npc_goal_enabled(NPC) ->
            follow_goal(NPC)
        ;   true
        ).

    %% I-FOLLOW: move all NPCs one step each tick (ZIL: I-FOLLOW)
    :- public(i_follow/0).
    i_follow :-
        tick_npc(gardener),
        tick_npc(baxter),
        tick_npc(dunbar),
        tick_npc(george),
        tick_npc(mrs_robner),
        tick_npc(rourke),
        tick_npc(coates),
        clock::queue_and_enable(npc_ai::i_follow, 1).

    %% Start all NPC movement schedules.
    %% ZIL: START-MOVEMENT routine
    :- public(start_movement/0).
    start_movement :-
        %% Queue schedule advancers — each NPC's first goal fires after
        %% an initial delay (matching ZIL's leading zero-destination entry).
        %% The initial delay is the first entry's delay field.
        queue_first_schedule(gardener),
        queue_first_schedule(dunbar),
        queue_first_schedule(george),
        queue_first_schedule(mrs_robner),
        queue_first_schedule(rourke),
        %% Start per-tick movement (I-FOLLOW equivalent)
        clock::queue_and_enable(npc_ai::i_follow, 1).

    :- private(queue_first_schedule/1).
    queue_first_schedule(NPC) :-
        npc_schedule(NPC, [entry(Delay, Jitter, _) | _]),
        state::assertz(global_val(npc_sched_idx(NPC), 0)),
        ( Jitter > 0 ->
            MaxJ is Jitter * 2,
            random_between(0, MaxJ, Rand),
            ActualDelay is Delay + Rand - Jitter
        ;   ActualDelay = Delay
        ),
        npc_tick_event(NPC, Event),
        clock::queue_and_enable(Event, ActualDelay).

    %% ---------------------------------------------------------------
    %% SCHEDULE-BASED GOAL SETTING
    %% ZIL: IMOVEMENT — reads schedule entry, establishes goal, re-queues
    %% for next entry's delay. Each NPC has a schedule index tracking
    %% their current position in their schedule list.
    %% ---------------------------------------------------------------

    :- public(tick_gardener/0).
    tick_gardener :- advance_schedule(gardener).

    :- public(tick_dunbar/0).
    tick_dunbar :- advance_schedule(dunbar).

    :- public(tick_george/0).
    tick_george :- advance_schedule(george).

    :- public(tick_mrs_robner/0).
    tick_mrs_robner :- advance_schedule(mrs_robner).

    :- public(tick_rourke/0).
    tick_rourke :- advance_schedule(rourke).

    %% advance_schedule/1 - establish goal from current entry, then queue
    %% the next entry using the NEXT entry's delay (ZIL: IMOVEMENT)
    %%
    %% Schedule semantics: entry(Delay, Jitter, Destination) means
    %% "after Delay +/- Jitter ticks, set goal to Destination".
    %% The initial delay is handled by queue_first_schedule.
    :- private(advance_schedule/1).
    advance_schedule(NPC) :-
        npc_schedule(NPC, Schedule),
        ( state::global_val(npc_sched_idx(NPC), Idx) -> true
        ;   Idx = 0
        ),
        length(Schedule, Len),
        ( Idx < Len ->
            nth0(Idx, Schedule, entry(_Delay, _Jitter, Destination)),
            %% Establish goal for this entry's destination
            establish_goal(NPC, Destination),
            %% Advance index
            NextIdx is Idx + 1,
            state::retractall(global_val(npc_sched_idx(NPC), _)),
            state::assertz(global_val(npc_sched_idx(NPC), NextIdx)),
            %% Queue next entry using its delay
            ( NextIdx < Len ->
                nth0(NextIdx, Schedule, entry(NextDelay, NextJitter, _)),
                ( NextJitter > 0 ->
                    MaxJ is NextJitter * 2,
                    random_between(0, MaxJ, Rand),
                    ActualDelay is NextDelay + Rand - NextJitter
                ;   ActualDelay = NextDelay
                ),
                npc_tick_event(NPC, Event),
                clock::queue_and_enable(Event, ActualDelay)
            ;   true  % last entry — no more to queue
            )
        ;   true  % schedule exhausted
        ).

    %% Map NPC to its tick event for re-queuing
    :- private(npc_tick_event/2).
    npc_tick_event(gardener, npc_ai::tick_gardener).
    npc_tick_event(dunbar, npc_ai::tick_dunbar).
    npc_tick_event(george, npc_ai::tick_george).
    npc_tick_event(mrs_robner, npc_ai::tick_mrs_robner).
    npc_tick_event(rourke, npc_ai::tick_rourke).

    %% ---------------------------------------------------------------
    %% BAXTER / COATES ARRIVAL EVENTS
    %% ZIL: I-BAXTER-ARRIVE, I-COATES-ARRIVE
    %% ---------------------------------------------------------------

    :- public(i_baxter_arrive/0).
    i_baxter_arrive :-
        state::set_global(baxter_arrived, true),
        state::assertz(location(baxter, front_path)),
        state::current_room(Here),
        ( Here = foyer ; Here = front_path ; Here = south_lawn ->
            writeln("There is a knock at the front door.")
        ;   true
        ),
        establish_goal(baxter, living_room).

    :- public(i_coates_arrive/0).
    i_coates_arrive :-
        state::set_global(coates_arrived, true),
        state::assertz(location(coates, front_path)),
        state::current_room(Here),
        ( Here = foyer ; Here = front_path ->
            writeln("A police car pulls up outside.")
        ;   true
        ),
        establish_goal(coates, living_room).

    %% ---------------------------------------------------------------
    %% ATTENTION / FOLLOW SYSTEM
    %% ZIL: I-FOLLOW, I-ATTENTION - NPCs notice the player nearby
    %% ---------------------------------------------------------------

    :- public(i_follow/0).
    i_follow :-
        %% Check if any NPC wants to follow or block the player
        state::current_room(Here),
        forall(
            ( member(NPC, [gardener, dunbar, george, mrs_robner, rourke]),
              state::location(NPC, Here),
              npc_should_react(NPC, Here)
            ),
            npc_react(NPC)
        ),
        clock::queue_and_enable(npc_ai::i_follow, 1).

    :- private(npc_should_react/2).
    npc_should_react(gardener, _Here) :-
        state::global_val(gardener_angry, true).
    npc_should_react(_, _) :- false.

    :- private(npc_react/1).
    npc_react(gardener) :-
        state::global_val(gardener_angry, true),
        writeln("Mr. McNabb blocks your path angrily, muttering about his roses.").
    npc_react(_) :- true.

:- end_object.
