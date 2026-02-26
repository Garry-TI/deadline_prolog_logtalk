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

    :- public initialize/0.
    initialize :-
        init_global_vars,
        init_npc_locations,
        init_object_locations,
        init_object_flags,
        init_room_flags,
        init_pronouns.

    %% ---------------------------------------------------------------
    %% GLOBAL VARIABLES (ZIL GLOBAL definitions + GO routine SETG calls)
    %% ---------------------------------------------------------------

    :- private init_global_vars/0.
    init_global_vars :-
        %% From clock.zil + main.zil GO routine
        assertz(state::global_val(present_time, 0)),    % ticks elapsed (max 1199)
        assertz(state::global_val(score, 8)),            % hour of day (8am)
        assertz(state::global_val(moves, 0)),            % moves within hour
        assertz(state::global_val(load_max, 100)),       % carry limit
        assertz(state::global_val(load_allowed, 100)),   % remaining carry
        assertz(state::global_val(lit, true)),           % room is lit
        assertz(state::global_val(p_won, false)),        % last parse succeeded
        assertz(state::global_val(clock_wait, false)),   % skip next clock tick
        assertz(state::global_val(verbose_mode, false)), % brief mode by default
        %% Ladder flags (controls balcony access)
        assertz(state::global_val(ladder_flag, false)),
        assertz(state::global_val(ladder_flag_2, false)),
        %% Gardener state
        assertz(state::global_val(gardener_angry, false)),
        %% Dialogue context
        assertz(state::global_val(qcontext, none)),
        assertz(state::global_val(qcontext_room, none)),
        %% Game progression flags
        assertz(state::global_val(fragment_found, false)),
        assertz(state::global_val(safe_opened, false)),
        assertz(state::global_val(dunbar_dead, false)),
        assertz(state::global_val(baxter_arrived, false)),
        assertz(state::global_val(coates_arrived, false)),
        %% Last action tracking (L-PRSA, L-PRSO, L-PRSI)
        assertz(state::global_val(last_verb, none)),
        assertz(state::global_val(last_do, none)),
        assertz(state::global_val(last_io, none)).

    %% ---------------------------------------------------------------
    %% NPC INITIAL LOCATIONS (ZIL: (IN room) properties on OBJECT)
    %% ---------------------------------------------------------------

    :- private init_npc_locations/0.
    init_npc_locations :-
        %% Player starts on South Lawn (GO routine: <SETG HERE ,SOUTH-LAWN>)
        assertz(state::location(player, south_lawn)),
        assertz(state::current_room(south_lawn)),
        assertz(state::current_actor(player)),

        %% Mr. McNabb (gardener) starts on North Lawn
        assertz(state::location(gardener, north_lawn)),

        %% Ms. Dunbar starts in Living Room
        assertz(state::location(dunbar, living_room)),

        %% George starts in his bedroom
        assertz(state::location(george, george_room)),

        %% Mrs. Robner starts in Living Room
        assertz(state::location(mrs_robner, living_room)),

        %% Mrs. Rourke starts in Kitchen
        assertz(state::location(rourke, kitchen)),

        %% Baxter and Coates have no initial location (arrive via events)
        true.

    %% ---------------------------------------------------------------
    %% OBJECT INITIAL LOCATIONS (ZIL: (IN room/container) properties)
    %% ---------------------------------------------------------------

    :- private init_object_locations/0.
    init_object_locations :-
        %% Library desk and contents
        assertz(state::location(library_desk, library)),
        assertz(state::location(note_paper, library_desk)),
        assertz(state::location(desk_calendar, library_desk)),
        assertz(state::location(tray, library)),
        assertz(state::location(sugar_bowl, tray)),
        assertz(state::location(cup, library)),
        assertz(state::location(saucer, library)),
        assertz(state::location(trash_basket, library)),
        assertz(state::location(trash, trash_basket)),
        assertz(state::location(library_carpet, library)),
        assertz(state::location(library_button, library)),
        assertz(state::location(mud_spot, library)),
        assertz(state::location(bookshelves, library)),
        assertz(state::location(ebullion_bottle, library)),
        assertz(state::location(ebullion, ebullion_bottle)),

        %% Hidden closet
        assertz(state::location(red_button, hidden_closet)),
        assertz(state::location(blue_button, hidden_closet)),
        assertz(state::location(safe, hidden_closet)),
        assertz(state::location(dust, hidden_closet)),
        assertz(state::location(baxter_papers, safe)),
        assertz(state::location(new_will, safe)),

        %% Foyer
        assertz(state::location(foyer_table, foyer)),
        assertz(state::location(crystal_lamp, foyer)),

        %% Living room
        assertz(state::location(living_room_table, living_room)),
        assertz(state::location(fireplace, living_room)),
        assertz(state::location(wood_pile, living_room)),
        assertz(state::location(portraits, living_room)),
        assertz(state::location(lr_cabinets, living_room)),

        %% Dining room
        assertz(state::location(seurat, dining_room)),
        assertz(state::location(paintings, dining_room)),
        assertz(state::location(dining_room_table, dining_room)),
        assertz(state::location(trestle_table, dining_room)),

        %% Kitchen
        assertz(state::location(cups, kitchen)),
        assertz(state::location(saucers, kitchen)),
        assertz(state::location(china, kitchen)),
        assertz(state::location(plates, kitchen)),
        assertz(state::location(shelf_unit, kitchen)),
        assertz(state::location(appliance_1, kitchen)),
        assertz(state::location(appliance_2, kitchen)),
        assertz(state::location(k_cabinets, kitchen)),
        assertz(state::location(silverware, k_cabinets)),
        assertz(state::location(glasses, k_cabinets)),

        %% Pantry
        assertz(state::location(p_shelves, pantry)),
        assertz(state::location(foods, p_shelves)),

        %% Shed
        assertz(state::location(ladder, shed_room)),
        assertz(state::location(tools_1, shed_room)),
        assertz(state::location(tools_2, shed_room)),
        assertz(state::location(s_shelves, shed_room)),

        %% Rose garden / orchard
        assertz(state::location(hole, in_roses)),
        assertz(state::location(fragment, in_roses)),
        assertz(state::location(berry_bush, in_orchard)),

        %% Dunbar's bathroom / cabinet
        assertz(state::location(dunbar_cabinet, dunbar_bath)),
        assertz(state::location(loblo_bottle, dunbar_cabinet)),
        assertz(state::location(loblo, loblo_bottle)),
        assertz(state::location(aspirin_bottle, dunbar_cabinet)),
        assertz(state::location(aspirin, aspirin_bottle)),
        assertz(state::location(dum_kof_bottle, dunbar_cabinet)),
        assertz(state::location(dum_kof, dum_kof_bottle)),

        %% Rourke's bathroom
        assertz(state::location(rourke_shelves, rourke_bath)),

        %% Master bedroom
        assertz(state::location(master_bedroom_dresser, master_bedroom)),
        assertz(state::location(four_poster, master_bedroom)),
        assertz(state::location(lounge, master_bedroom)),
        assertz(state::location(bedroom_mirror, master_bedroom)),

        %% Master bathroom
        assertz(state::location(bathtub, master_bath)),
        assertz(state::location(master_bath_counter, master_bath)),
        assertz(state::location(bathroom_mirror, master_bath)),
        assertz(state::location(hanging_plants, master_bath)),
        assertz(state::location(sneezo_bottle, master_bath_counter)),
        assertz(state::location(sneezo, sneezo_bottle)),
        assertz(state::location(allergone_bottle, master_bath_counter)),
        assertz(state::location(allergone, allergone_bottle)),

        %% George's room/bath
        assertz(state::location(liquor_cabinet, george_room)),
        assertz(state::location(scotch, liquor_cabinet)),
        assertz(state::location(bourbon, liquor_cabinet)),
        assertz(state::location(stereo, george_room)),
        assertz(state::location(records, george_room)),
        assertz(state::location(tapes, george_room)),
        assertz(state::location(shaving_gear, george_bath)),

        %% Balcony objects
        assertz(state::location(l_railing, library_balcony)),
        assertz(state::location(b_railing, bedroom_balcony)),
        assertz(state::location(l_balcony, library_balcony)),
        assertz(state::location(b_balcony, bedroom_balcony)),
        assertz(state::location(tree_tops, bedroom_balcony)),

        %% Corridor
        assertz(state::location(corridor_window, corridor_4)),

        %% Guest room
        assertz(state::location(guest_window, guest_room)),

        %% Upstairs closets
        assertz(state::location(c11_shelves, closet_11)),
        assertz(state::location(c11_linens, c11_shelves)),
        assertz(state::location(uc_shelves, upstairs_closet)),
        assertz(state::location(uc_linens, uc_shelves)),
        assertz(state::location(uc_towels, uc_shelves)),

        %% East of door (exterior)
        assertz(state::location(cornerstone, east_of_door)).

    %% ---------------------------------------------------------------
    %% OBJECT INITIAL FLAGS
    %% ---------------------------------------------------------------

    :- private init_object_flags/0.
    init_object_flags :-
        %% Doors — initial states
        assertz(state::has_flag(south_closet_door, doorbit)),
        assertz(state::has_flag(south_closet_door, contbit)),
        assertz(state::has_flag(south_closet_door, openbit)),   % open
        assertz(state::has_flag(front_door, doorbit)),
        assertz(state::has_flag(front_door, contbit)),          % closed
        assertz(state::has_flag(dunbar_bath_door, doorbit)),
        assertz(state::has_flag(dunbar_bath_door, openbit)),    % open
        assertz(state::has_flag(george_bath_door, doorbit)),
        assertz(state::has_flag(george_bath_door, openbit)),    % open
        assertz(state::has_flag(hidden_door_l, invisible)),     % hidden
        assertz(state::has_flag(hidden_door_b, invisible)),     % hidden

        %% Bay window — closed initially
        assertz(state::has_flag(bay_window, doorbit)),
        assertz(state::has_flag(bay_window, contbit)),

        %% Key evidence items — initially invisible
        assertz(state::has_flag(hole, invisible)),
        assertz(state::has_flag(fragment, invisible)),
        assertz(state::has_flag(mud_spot, invisible)),
        assertz(state::has_flag(library_button, invisible)),
        assertz(state::has_flag(baxter_papers, invisible)),

        %% Containers — open initially
        assertz(state::has_flag(library_desk, openbit)),
        assertz(state::has_flag(trash_basket, openbit)),
        assertz(state::has_flag(foyer_table, openbit)),
        assertz(state::has_flag(tray, openbit)),
        assertz(state::has_flag(safe, contbit)),   % NOT open — requires combination
        assertz(state::has_flag(dunbar_cabinet, contbit)),

        %% NPC person flags
        assertz(state::has_flag(player, person)),
        assertz(state::has_flag(gardener, person)),
        assertz(state::has_flag(gardener, openbit)),
        assertz(state::has_flag(dunbar, person)),
        assertz(state::has_flag(dunbar, openbit)),
        assertz(state::has_flag(george, person)),
        assertz(state::has_flag(george, openbit)),
        assertz(state::has_flag(mrs_robner, person)),
        assertz(state::has_flag(mrs_robner, openbit)),
        assertz(state::has_flag(rourke, person)),
        assertz(state::has_flag(rourke, openbit)),
        assertz(state::has_flag(baxter, person)),
        assertz(state::has_flag(coates, person)).

    %% ---------------------------------------------------------------
    %% ROOM INITIAL FLAGS
    %% ---------------------------------------------------------------

    :- private init_room_flags/0.
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
            ( assertz(state::has_flag(Room, rlandbit)),
              assertz(state::has_flag(Room, onbit)) )
        ).

    %% ---------------------------------------------------------------
    %% PRONOUN INITIALIZATION
    %% ZIL: <SETG P-HIM-HER ,MRS-ROBNER> / <SETG P-IT-OBJECT <>>
    %% ---------------------------------------------------------------

    :- private init_pronouns/0.
    init_pronouns :-
        %% Initial HIM-HER pronoun is Mrs. Robner (from main.zil GO routine)
        assertz(state::pronoun(him_her, mrs_robner)),
        assertz(state::pronoun_room(him_her, foyer)),
        %% IT pronoun starts unset
        assertz(state::pronoun(it, none)),
        assertz(state::pronoun_room(it, south_lawn)).

:- end_object.
