%%%  globals_init.lgt  %%%
%%%
%%%  Initial game state initialization.
%%%  Asserts all starting dynamic facts for locations, flags, and global variables.
%%%
%%%  This file is loaded last in the world group, after all room/object/NPC
%%%  prototypes are defined. It populates the state::location/2, state::has_flag/2,
%%%  and state::global_val/2 databases to represent the start of the game.
%%%
%%%  ZIL source: dungeon.zil (IN properties, FLAGS properties, GLOBAL values)
%%%              main.zil (GO routine: initial SETG calls)
%%%
%%%  Copyright 1982 Infocom, Inc. (original game)
%%%  Logtalk refactoring: see CLAUDE.md

:- object(globals_init).

    :- info([
        version is 1:0:0,
        comment is 'Asserts initial game state. Call globals_init::initialize/0 at startup.'
    ]).

    :- uses(user, [member/2]).

    :- public(initialize/0).
    initialize :-
        init_global_vars,
        init_npc_locations,
        init_object_locations,
        init_global_object_locations,
        init_entity_initial_flags,
        init_object_flags,
        init_room_flags,
        init_pronouns.

    %% ---------------------------------------------------------------
    %% GLOBAL VARIABLES (ZIL GLOBAL definitions + GO routine SETG calls)
    %% ---------------------------------------------------------------

    :- private(init_global_vars/0).
    init_global_vars :-
        %% From clock.zil + main.zil GO routine
        state::assertz(global_val(present_time, 0)),    % ticks elapsed (max 1199)
        state::assertz(global_val(score, 8)),            % hour of day (8am)
        state::assertz(global_val(moves, 0)),            % moves within hour
        state::assertz(global_val(load_max, 100)),       % carry limit
        state::assertz(global_val(load_allowed, 100)),   % remaining carry
        state::assertz(global_val(lit, true)),           % room is lit
        state::assertz(global_val(p_won, false)),        % last parse succeeded
        state::assertz(global_val(clock_wait, false)),   % skip next clock tick
        state::assertz(global_val(verbose_mode, false)), % brief mode by default
        %% Ladder flags (controls balcony access)
        state::assertz(global_val(ladder_flag, false)),
        state::assertz(global_val(ladder_flag_2, false)),
        %% Gardener state
        state::assertz(global_val(gardener_angry, false)),
        %% Dialogue context
        state::assertz(global_val(qcontext, none)),
        state::assertz(global_val(qcontext_room, none)),
        %% Game progression flags
        state::assertz(global_val(fragment_found, false)),
        state::assertz(global_val(safe_opened, false)),
        state::assertz(global_val(dunbar_dead, false)),
        state::assertz(global_val(baxter_arrived, false)),
        state::assertz(global_val(coates_arrived, false)),
        %% Calendar page (ZIL: CALENDAR-PAGE, default July 7)
        state::assertz(global_val(calendar_page, 7)),
        %% George calendar flag (ZIL: G-CALENDAR)
        state::assertz(global_val(g_calendar, false)),
        %% Phone call state machine (ZIL: actions.zil lines 1984-2187)
        state::assertz(global_val(call_ring, false)),
        state::assertz(global_val(call_in_progress, 0)),
        state::assertz(global_val(call_waiting, 0)),
        state::assertz(global_val(call_move, false)),
        state::assertz(global_val(call_overheard, false)),
        state::assertz(global_val(robner_old_loc, none)),
        %% Fingerprint/analysis system (ZIL: FINGERPRINT-OBJ, ANALYSIS-OBJ, ANALYSIS-GOAL)
        state::assertz(global_val(fingerprint_obj, none)),
        state::assertz(global_val(analysis_obj, none)),
        state::assertz(global_val(analysis_goal, none)),
        %% Last action tracking (L-PRSA, L-PRSO, L-PRSI)
        state::assertz(global_val(last_verb, none)),
        state::assertz(global_val(last_do, none)),
        state::assertz(global_val(last_io, none)).

    %% ---------------------------------------------------------------
    %% NPC INITIAL LOCATIONS (ZIL: (IN room) properties on OBJECT)
    %% ---------------------------------------------------------------

    :- private(init_npc_locations/0).
    init_npc_locations :-
        %% Player starts on South Lawn (GO routine: <SETG HERE ,SOUTH-LAWN>)
        state::assertz(location(player, south_lawn)),
        state::assertz(current_room(south_lawn)),
        state::assertz(current_actor(player)),

        %% Mr. McNabb (gardener) starts on North Lawn
        state::assertz(location(gardener, north_lawn)),

        %% Ms. Dunbar starts in Living Room
        state::assertz(location(dunbar, living_room)),

        %% George starts in his bedroom
        state::assertz(location(george, george_room)),

        %% Mrs. Robner starts in Living Room
        state::assertz(location(mrs_robner, living_room)),

        %% Mrs. Rourke starts in Kitchen
        state::assertz(location(rourke, kitchen)),

        %% Baxter and Coates have no initial location (arrive via events)
        true.

    %% ---------------------------------------------------------------
    %% OBJECT INITIAL LOCATIONS (ZIL: (IN room/container) properties)
    %% ---------------------------------------------------------------

    :- private(init_object_locations/0).
    init_object_locations :-
        %% Library desk and contents
        state::assertz(location(library_desk, library)),
        state::assertz(location(note_paper, library_desk)),
        state::assertz(location(desk_calendar, library_desk)),
        state::assertz(location(tray, library)),
        state::assertz(location(sugar_bowl, tray)),
        state::assertz(location(cup, library)),
        state::assertz(location(saucer, library)),
        state::assertz(location(trash_basket, library)),
        state::assertz(location(trash, trash_basket)),
        state::assertz(location(library_carpet, library)),
        state::assertz(location(library_button, library)),
        state::assertz(location(mud_spot, library)),
        state::assertz(location(bookshelves, library)),
        state::assertz(location(pencil, library)),
        state::assertz(location(ebullion_bottle, library)),
        state::assertz(location(ebullion, ebullion_bottle)),

        %% Hidden closet
        state::assertz(location(red_button, hidden_closet)),
        state::assertz(location(blue_button, hidden_closet)),
        state::assertz(location(safe, hidden_closet)),
        state::assertz(location(dust, hidden_closet)),
        state::assertz(location(baxter_papers, safe)),
        state::assertz(location(new_will, safe)),

        %% Foyer
        state::assertz(location(foyer_table, foyer)),
        state::assertz(location(crystal_lamp, foyer)),

        %% Living room
        state::assertz(location(living_room_table, living_room)),
        state::assertz(location(fireplace, living_room)),
        state::assertz(location(wood_pile, living_room)),
        state::assertz(location(portraits, living_room)),
        state::assertz(location(lr_cabinets, living_room)),

        %% Dining room
        state::assertz(location(seurat, dining_room)),
        state::assertz(location(paintings, dining_room)),
        state::assertz(location(dining_room_table, dining_room)),
        state::assertz(location(trestle_table, dining_room)),

        %% Kitchen
        state::assertz(location(cups, kitchen)),
        state::assertz(location(saucers, kitchen)),
        state::assertz(location(china, kitchen)),
        state::assertz(location(plates, kitchen)),
        state::assertz(location(shelf_unit, kitchen)),
        state::assertz(location(appliance_1, kitchen)),
        state::assertz(location(appliance_2, kitchen)),
        state::assertz(location(k_cabinets, kitchen)),
        state::assertz(location(silverware, k_cabinets)),
        state::assertz(location(glasses, k_cabinets)),

        %% Pantry
        state::assertz(location(p_shelves, pantry)),
        state::assertz(location(foods, p_shelves)),

        %% Shed
        state::assertz(location(ladder, shed_room)),
        state::assertz(location(tools_1, shed_room)),
        state::assertz(location(tools_2, shed_room)),
        state::assertz(location(s_shelves, shed_room)),

        %% Rose garden / orchard
        state::assertz(location(hole, in_roses)),
        state::assertz(location(fragment, in_roses)),
        state::assertz(location(berry_bush, in_orchard)),

        %% Dunbar's bathroom / cabinet
        state::assertz(location(dunbar_cabinet, dunbar_bath)),
        state::assertz(location(loblo_bottle, dunbar_cabinet)),
        state::assertz(location(loblo, loblo_bottle)),
        state::assertz(location(aspirin_bottle, dunbar_cabinet)),
        state::assertz(location(aspirin, aspirin_bottle)),
        state::assertz(location(dum_kof_bottle, dunbar_cabinet)),
        state::assertz(location(dum_kof, dum_kof_bottle)),

        %% Rourke's bathroom
        state::assertz(location(rourke_shelves, rourke_bath)),

        %% Master bedroom
        state::assertz(location(master_bedroom_dresser, master_bedroom)),
        state::assertz(location(four_poster, master_bedroom)),
        state::assertz(location(lounge, master_bedroom)),
        state::assertz(location(bedroom_mirror, master_bedroom)),

        %% Master bathroom
        state::assertz(location(bathtub, master_bath)),
        state::assertz(location(master_bath_counter, master_bath)),
        state::assertz(location(bathroom_mirror, master_bath)),
        state::assertz(location(hanging_plants, master_bath)),
        state::assertz(location(sneezo_bottle, master_bath_counter)),
        state::assertz(location(sneezo, sneezo_bottle)),
        state::assertz(location(allergone_bottle, master_bath_counter)),
        state::assertz(location(allergone, allergone_bottle)),

        %% George's room/bath
        state::assertz(location(liquor_cabinet, george_room)),
        state::assertz(location(scotch, liquor_cabinet)),
        state::assertz(location(bourbon, liquor_cabinet)),
        state::assertz(location(stereo, george_room)),
        state::assertz(location(records, george_room)),
        state::assertz(location(tapes, george_room)),
        state::assertz(location(shaving_gear, george_bath)),

        %% Balcony objects
        state::assertz(location(l_railing, library_balcony)),
        state::assertz(location(b_railing, bedroom_balcony)),
        state::assertz(location(l_balcony, library_balcony)),
        state::assertz(location(b_balcony, bedroom_balcony)),
        state::assertz(location(tree_tops, bedroom_balcony)),

        %% Corridor
        state::assertz(location(corridor_window, corridor_4)),

        %% Guest room
        state::assertz(location(guest_window, guest_room)),

        %% Upstairs closets
        state::assertz(location(c11_shelves, closet_11)),
        state::assertz(location(c11_linens, c11_shelves)),
        state::assertz(location(uc_shelves, upstairs_closet)),
        state::assertz(location(uc_linens, uc_shelves)),
        state::assertz(location(uc_towels, uc_shelves)),

        %% East of door (exterior)
        state::assertz(location(cornerstone, east_of_door)).

    %% ---------------------------------------------------------------
    %% GLOBAL OBJECTS (ZIL: IN GLOBAL-OBJECTS — accessible everywhere)
    %% Iterates over entities with initial_location(global_objects) and
    %% asserts location facts for the global_objects pseudo-container.
    %% ---------------------------------------------------------------

    :- private(init_global_object_locations/0).
    init_global_object_locations :-
        forall(
            ( extends_object(Obj, entity),
              catch(Obj::initial_location(global_objects), _, fail)
            ),
            state::assertz(location(Obj, global_objects))
        ).

    %% ---------------------------------------------------------------
    %% ENTITY INITIAL FLAGS (from object initial_flags/1 predicates)
    %% Iterates over all entity/npc prototypes and asserts their flags.
    %% ---------------------------------------------------------------

    :- private(init_entity_initial_flags/0).
    init_entity_initial_flags :-
        forall(
            ( extends_object(Obj, entity),
              catch(Obj::initial_flags(Flags), _, Flags = []),
              Flags \= [],
              member(Flag, Flags)
            ),
            state::assertz(has_flag(Obj, Flag))
        ),
        %% Also handle NPC objects (extend npc which extends entity)
        forall(
            ( extends_object(Obj, npc),
              catch(Obj::initial_flags(Flags), _, Flags = []),
              Flags \= [],
              member(Flag, Flags)
            ),
            state::assertz(has_flag(Obj, Flag))
        ).

    %% ---------------------------------------------------------------
    %% OBJECT INITIAL FLAGS (manual overrides and additional flags)
    %% ---------------------------------------------------------------

    :- private(init_object_flags/0).
    init_object_flags :-
        %% Doors - initial states
        state::assertz(has_flag(south_closet_door, doorbit)),
        state::assertz(has_flag(south_closet_door, contbit)),
        state::assertz(has_flag(south_closet_door, openbit)),   % open
        state::assertz(has_flag(front_door, doorbit)),
        state::assertz(has_flag(front_door, contbit)),          % closed
        state::assertz(has_flag(dunbar_bath_door, doorbit)),
        state::assertz(has_flag(dunbar_bath_door, openbit)),    % open
        state::assertz(has_flag(george_bath_door, doorbit)),
        state::assertz(has_flag(george_bath_door, openbit)),    % open
        state::assertz(has_flag(hidden_door_l, invisible)),     % hidden
        state::assertz(has_flag(hidden_door_b, invisible)),     % hidden

        %% Bay window - closed initially
        state::assertz(has_flag(bay_window, doorbit)),
        state::assertz(has_flag(bay_window, contbit)),

        %% Key evidence items - initially invisible
        state::assertz(has_flag(hole, invisible)),
        state::assertz(has_flag(fragment, invisible)),
        state::assertz(has_flag(mud_spot, invisible)),
        state::assertz(has_flag(library_button, invisible)),
        state::assertz(has_flag(baxter_papers, invisible)),

        %% Containers - open initially
        state::assertz(has_flag(library_desk, openbit)),
        state::assertz(has_flag(trash_basket, openbit)),
        state::assertz(has_flag(foyer_table, openbit)),
        state::assertz(has_flag(tray, openbit)),
        state::assertz(has_flag(safe, contbit)),   % NOT open - requires combination
        state::assertz(has_flag(dunbar_cabinet, contbit)),

        %% Player person flag (player is not an NPC prototype, so not
        %% covered by init_entity_initial_flags)
        state::assertz(has_flag(player, person)).

    %% ---------------------------------------------------------------
    %% ROOM INITIAL FLAGS
    %% ---------------------------------------------------------------

    :- private(init_room_flags/0).
    init_room_flags :-
        %% All rooms start lit (rlandbit + onbit)
        forall(
            member(Room, [
                south_lawn, front_path, west_of_door, east_of_door,
                west_lawn, east_lawn, east_side, west_side,
                shed_room, behind_shed, rose_garden, in_roses,
                orchard, in_orchard, north_lawn,
                foyer, nfoyer, living_room, corner, dining_room,
                kitchen, pantry, shall_1, shall_2, rourke_room,
                rourke_bath, south_closet, stair_bottom, stairs,
                stair_top, corridor_1, corridor_2, corridor_3, corridor_4,
                library, library_balcony, upstairs_closet, hidden_closet,
                master_bedroom, master_bath, bedroom_balcony,
                north_hall, guest_room, shall_11, shall_12, closet_11,
                dunbar_bath, dunbar_room, george_bath, george_room
            ]),
            ( state::assertz(has_flag(Room, rlandbit)),
              state::assertz(has_flag(Room, onbit)) )
        ).

    %% ---------------------------------------------------------------
    %% PRONOUN INITIALIZATION
    %% ZIL: <SETG P-HIM-HER ,MRS-ROBNER> / <SETG P-IT-OBJECT <>>
    %% ---------------------------------------------------------------

    :- private(init_pronouns/0).
    init_pronouns :-
        %% Initial HIM-HER pronoun is Mrs. Robner (from main.zil GO routine)
        state::assertz(pronoun(him_her, mrs_robner)),
        state::assertz(pronoun_room(him_her, foyer)),
        %% IT pronoun starts unset
        state::assertz(pronoun(it, none)),
        state::assertz(pronoun_room(it, south_lawn)).

:- end_object.
