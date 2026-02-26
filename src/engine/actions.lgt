%%%  actions.lgt  %%%
%%%
%%%  Room and object action handlers (the "PREACTIONS" table + object
%%%  P?ACTION handlers in ZIL). These override default verb behavior
%%%  for specific rooms, objects, and NPCs.
%%%
%%%  ZIL source: actions.zil (198 action routines for rooms/objects/NPCs)
%%%
%%%  Copyright 1982 Infocom, Inc. (original game)
%%%  Logtalk refactoring: see CLAUDE.md

:- object(actions).

    :- info([
        version is 1:0:0,
        comment is 'Room/object/NPC action handlers; pre-action checks; event routines.'
    ]).

    :- uses(user, [member/2]).

    %% ---------------------------------------------------------------
    %% PRE-ACTION HANDLERS
    %% Called before object-specific handlers in the PERFORM chain.
    %% ZIL: PREACTIONS table in main.zil
    %% ---------------------------------------------------------------

    :- public(pre_action/3).

    %% PRE-TAKE: weight check, non-takeable check, fixed objects
    pre_action(v_take, DO, _IO) :-
        ( DO = none -> true
        ; state::has_flag(DO, person) ->
            ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
            format("~w wouldn't appreciate that.~n", [D]),
            fail
        ; \+ state::has_flag(DO, takebit) ->
            ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
            format("You can't take the ~w.~n", [D]),
            fail
        ;   true
        ).

    %% PRE-EXAMINE: room check (can't examine rooms you're in)
    pre_action(v_examine, DO, _IO) :-
        ( DO = none -> true
        ;   true
        ).

    %% PRE-ACCUSE: must have evidence
    pre_action(v_accuse, Person, pair(with, Evidence)) :-
        Person \= none,
        Evidence \= none,
        %% Check if player has the evidence
        ( state::location(Evidence, player) -> true
        ;
            ( catch(Evidence::desc(ED), _, ED = Evidence) -> true ; ED = Evidence ),
            format("You don't have the ~w.~n", [ED]),
            fail
        ).

    %% ---------------------------------------------------------------
    %% ROOM ACTION HANDLERS
    %% Called with phase (m_beg, m_end, m_enter, m_look) by PERFORM.
    %% ---------------------------------------------------------------

    %% in_roses action: gardener anger when player enters rose garden
    :- public(in_roses_action/4).
    in_roses_action(m_enter, v_walk, _DO, _IO) :-
        state::global_val(gardener_angry, false),
        state::location(gardener, GardenerLoc),
        member(GardenerLoc, [rose_garden, north_lawn, west_lawn]),
        !,
        writeln("In the distance you hear \"Hey! WHAT? You, there!\" and other choice words"),
        writeln("muffled by a strong Scottish burr and a stiff breeze. Now, standing at the"),
        writeln("edge of the garden, can be seen the person of Mr. Angus McNabb, the gardener."),
        writeln("He advances, looking crazed and gesticulating wildly. With each carefully"),
        writeln("chosen step in your direction, a barely visible wince of pain comes to his"),
        writeln("deeply-lined face."),
        state::set_global(gardener_angry, true),
        state::move_entity(gardener, in_roses),
        clock::queue_and_enable(actions::i_gardener_calm, 90).
    in_roses_action(_, _, _, _) :- true.

    %% foyer action: Mrs. Robner welcome on first enter
    :- public(foyer_action/4).
    foyer_action(m_enter, v_walk, _DO, _IO) :-
        \+ state::has_flag(foyer, touchbit),
        state::global_val(present_time, T),
        T < 700,
        !,
        writeln("Mrs. Robner appears, walking down a hallway from the north."),
        welcome_player.
    foyer_action(_, _, _, _) :- true.

    :- private(welcome_player/0).
    welcome_player :-
        writeln("\"Ah, you must be the Inspector from the police. How kind of you to come so"),
        writeln("quickly. I am Leslie Robner. Won't you please come in? I am afraid it is"),
        writeln("all quite dreadful. My husband -- \" She pauses, dabbing at her eyes. \"Well,"),
        writeln("please make yourself at home. I will be in the living room should you need"),
        writeln("anything.\""),
        state::move_entity(mrs_robner, living_room).

    %% library action: hidden door behind bookshelves
    :- public(library_action/4).
    library_action(m_beg, v_push, library_button, _IO) :-
        !,
        library_button_press.
    library_action(m_beg, v_push, blue_button, _IO) :-
        !,
        blue_button_press.
    library_action(m_beg, v_push, red_button, _IO) :-
        !,
        red_button_press.
    library_action(_, _, _, _) :- true.

    %% ---------------------------------------------------------------
    %% OBJECT ACTION HANDLERS
    %% ---------------------------------------------------------------

    %% Library button: reveals hidden closet
    :- public(library_button_action/3).
    library_button_action(v_push, _, _) :-
        !,
        library_button_press.
    library_button_action(_, _, _) :- true.

    :- public(library_button_press/0).
    library_button_press :-
        ( state::has_flag(hidden_door_l, invisible) ->
            state::clear_flag(hidden_door_l, invisible),
            state::clear_flag(library_button, invisible),
            writeln("You hear a click, and a section of the bookshelf swings open,"),
            writeln("revealing a hidden closet!")
        ;   writeln("The bookshelf is already open.")
        ).

    %% Blue button (in hidden closet): same effect
    :- public(blue_button_press/0).
    blue_button_press :-
        writeln("You press the blue button. The bookshelf swings closed with a soft click."),
        state::set_flag(hidden_door_l, invisible).

    %% Red button: triggers something else (per actions.zil)
    :- public(red_button_press/0).
    red_button_press :-
        writeln("You press the red button. Nothing seems to happen.").

    %% Safe: combination required
    :- public(safe_action/3).
    safe_action(v_open, safe, _IO) :-
        !,
        safe_open.
    safe_action(v_unlock, safe, _IO) :-
        !,
        safe_open.
    safe_action(_, _, _) :- true.

    :- public(safe_open/0).
    safe_open :-
        ( state::has_flag(safe, openbit) ->
            writeln("The safe is already open.")
        ; state::global_val(safe_opened, true) ->
            state::set_flag(safe, openbit),
            writeln("The safe opens.")
        ;   writeln("The safe is locked. You'll need to find the combination.")
        ).

    %% Front door action: locked/unlocked state
    :- public(front_door_action/3).
    front_door_action(v_open, front_door, _IO) :-
        !,
        ( state::has_flag(front_door, openbit) ->
            writeln("The front door is already open.")
        ;   state::set_flag(front_door, openbit),
            writeln("You open the front door.")
        ).
    front_door_action(v_close, front_door, _IO) :-
        !,
        ( state::has_flag(front_door, openbit) ->
            state::clear_flag(front_door, openbit),
            writeln("You close the front door.")
        ;   writeln("The front door is already closed.")
        ).
    front_door_action(_, _, _) :- true.

    %% Bay window: can be opened
    :- public(bay_window_action/3).
    bay_window_action(v_open, bay_window, _IO) :-
        !,
        ( state::has_flag(bay_window, openbit) ->
            writeln("The bay window is already open.")
        ;   state::set_flag(bay_window, openbit),
            writeln("You open the bay window.")
        ).
    bay_window_action(v_close, bay_window, _IO) :-
        !,
        ( state::has_flag(bay_window, openbit) ->
            state::clear_flag(bay_window, openbit),
            writeln("You close the bay window.")
        ;   writeln("The bay window is already closed.")
        ).
    bay_window_action(_, _, _) :- true.

    %% Ladder: special climb behavior
    :- public(ladder_action/3).
    ladder_action(v_climb_up, ladder, _IO) :-
        !,
        ( state::location(ladder, in_roses) ->
            ( state::global_val(ladder_flag, true) ->
                %% Ladder is leaning against house → can climb to balcony
                state::move_entity(player, library_balcony),
                state::set_current_room(library_balcony),
                verbs::v_look
            ;   writeln("The ladder is just lying here; you'd need to lean it against something.")
            )
        ; state::location(ladder, in_orchard) ->
            ( state::global_val(ladder_flag_2, true) ->
                state::move_entity(player, bedroom_balcony),
                state::set_current_room(bedroom_balcony),
                verbs::v_look
            ;   writeln("The ladder is here but not positioned for climbing.")
            )
        ;   writeln("You can't climb the ladder from here.")
        ).
    ladder_action(v_take, ladder, _IO) :-
        !,
        ( state::global_val(gardener_angry, true) ->
            writeln("Mr. McNabb won't let you take the ladder.")
        ;
            state::move_entity(ladder, player),
            state::set_flag(ladder, touchbit),
            writeln("Taken.")
        ).
    ladder_action(v_lean, ladder, pair(against, _IO)) :-
        !,
        state::current_room(Room),
        ( Room = in_roses ->
            state::set_global(ladder_flag, true),
            writeln("You lean the ladder against the house. Its top end rests against the balcony above.")
        ; Room = in_orchard ->
            state::set_global(ladder_flag_2, true),
            writeln("You lean the ladder against the house. Its top end reaches the bedroom balcony.")
        ;   writeln("There's nothing suitable to lean it against here.")
        ).
    ladder_action(_, _, _) :- true.

    %% Ebullion: the poison - key evidence
    :- public(ebullion_action/3).
    ebullion_action(v_examine, ebullion, _IO) :-
        !,
        writeln("A small quantity of a clear liquid. The label on the bottle reads: Ebullion."),
        writeln("A powerful poison often used as a sedative in small doses.").
    ebullion_action(_, _, _) :- true.

    %% Note paper: key evidence
    :- public(note_paper_action/3).
    note_paper_action(v_read, note_paper, _IO) :-
        !,
        writeln("The note reads:"),
        writeln("\"George -- I must speak with you privately tonight."),
        writeln("It is a matter of the gravest importance."),
        writeln("-- Father\"").
    note_paper_action(v_examine, note_paper, _IO) :-
        !,
        writeln("A small piece of notepaper, covered in neat handwriting.").
    note_paper_action(_, _, _) :- true.

    %% Desk calendar: shows today's date and appointments
    :- public(desk_calendar_action/3).
    desk_calendar_action(v_read, desk_calendar, _IO) :-
        !,
        writeln("The calendar shows today's date: Thursday."),
        writeln("Appointments:"),
        writeln("  9:00 AM - Dr. Baxter (health consultation)"),
        writeln("  11:30 AM - Attorney (re: will revision)").
    desk_calendar_action(_, _, _) :- true.

    %% Trash: examine reveals crumpled note
    :- public(trash_action/3).
    trash_action(v_examine, trash, _IO) :-
        !,
        writeln("Crumpled papers, apparently torn and discarded."),
        writeln("Some of the fragments are legible.").
    trash_action(v_search, trash, _IO) :-
        !,
        writeln("Among the crumpled papers you find fragments of what appears to be a letter."),
        state::clear_flag(fragment, invisible),
        writeln("A torn fragment of paper is visible among the trash.").
    trash_action(_, _, _) :- true.

    %% ---------------------------------------------------------------
    %% NPC ACTION HANDLERS
    %% ---------------------------------------------------------------

    %% Gardener: angry if player enters rose garden
    :- public(gardener_action/3).
    gardener_action(v_ask_about, gardener, pair(about, _Topic)) :-
        state::global_val(gardener_angry, true),
        !,
        writeln("\"Get awa' from my roses! I'll no' speak to you while you're here!\"").
    gardener_action(v_ask_about, gardener, pair(about, Topic)) :-
        !,
        ( catch(gardener::dialogue_response(Topic, Response), _, Response = none) ->
            ( Response = none ->
                writeln("Mr. McNabb grumbles but says nothing useful.")
            ;   writeln(Response)
            )
        ;   writeln("Mr. McNabb grumbles but says nothing useful.")
        ).
    gardener_action(v_give, gardener, pair(to, _)) :-
        state::global_val(gardener_angry, true),
        !,
        writeln("\"Take that away! I'll no' have any truck with ya!\"").
    gardener_action(_, _, _) :- true.

    %% Dunbar: key witness
    :- public(dunbar_action/3).
    dunbar_action(v_ask_about, dunbar, pair(about, Topic)) :-
        !,
        ( catch(dunbar::dialogue_response(Topic, Response), _, Response = none) ->
            ( Response = none ->
                writeln("\"I'm afraid I can't help you with that,\" Ms. Dunbar says.")
            ;   writeln(Response)
            )
        ;   writeln("\"I'm afraid I can't help you with that,\" Ms. Dunbar says.")
        ).
    dunbar_action(v_show, dunbar, pair(to, Evidence)) :-
        !,
        ( catch(dunbar::show_response(Evidence), _, fail) -> true
        ;   writeln("Ms. Dunbar examines it carefully but says nothing.")
        ).
    dunbar_action(_, _, _) :- true.

    %% Mrs. Robner: grieving widow
    :- public(mrs_robner_action/3).
    mrs_robner_action(v_ask_about, mrs_robner, pair(about, Topic)) :-
        !,
        ( catch(mrs_robner::dialogue_response(Topic, Response), _, Response = none) ->
            ( Response = none ->
                writeln("\"I really can't discuss that right now,\" she says, dabbing her eyes.")
            ;   writeln(Response)
            )
        ;   writeln("\"I really can't discuss that right now,\" she says, dabbing her eyes.")
        ).
    mrs_robner_action(_, _, _) :- true.

    %% George: nervous son
    :- public(george_action/3).
    george_action(v_ask_about, george, pair(about, Topic)) :-
        !,
        ( catch(george::dialogue_response(Topic, Response), _, Response = none) ->
            ( Response = none ->
                writeln("George shrugs. \"I don't know what you mean.\"")
            ;   writeln(Response)
            )
        ;   writeln("George shrugs. \"I don't know what you mean.\"")
        ).
    george_action(_, _, _) :- true.

    %% Rourke: the maid
    :- public(rourke_action/3).
    rourke_action(v_ask_about, rourke, pair(about, Topic)) :-
        !,
        ( catch(rourke::dialogue_response(Topic, Response), _, Response = none) ->
            ( Response = none ->
                writeln("Mrs. Rourke shakes her head. \"I wouldn't know about that.\"")
            ;   writeln(Response)
            )
        ;   writeln("Mrs. Rourke shakes her head. \"I wouldn't know about that.\"")
        ).
    rourke_action(_, _, _) :- true.

    %% Baxter: the doctor
    :- public(baxter_action/3).
    baxter_action(v_ask_about, baxter, pair(about, Topic)) :-
        !,
        ( catch(baxter::dialogue_response(Topic, Response), _, Response = none) ->
            ( Response = none ->
                writeln("\"I'm sorry, I can't discuss a patient's medical history.\"")
            ;   writeln(Response)
            )
        ;   writeln("\"I'm sorry, I can't discuss a patient's medical history.\"")
        ).
    baxter_action(_, _, _) :- true.

    %% ---------------------------------------------------------------
    %% TIMED EVENTS (ZIL: I-xxx interrupt routines)
    %% ---------------------------------------------------------------

    %% Newspaper delivery
    :- public(i_newspaper/0).
    i_newspaper :-
        state::current_room(Here),
        ( Here = south_lawn ; Here = front_path ; Here = west_of_door ->
            writeln("A young boy cycles up and throws the morning newspaper onto the path.")
        ;   true
        ),
        state::move_entity(newspaper, front_path),
        clock::disable_event(actions::i_newspaper).

    %% Mail delivery
    :- public(i_mail/0).
    i_mail :-
        state::current_room(Here),
        ( Here = south_lawn ; Here = front_path ; Here = foyer ->
            writeln("The mailman arrives and deposits a small pile of letters in the foyer.")
        ;   true
        ),
        state::move_entity(envelope, foyer),
        state::move_entity(letter, foyer),
        clock::disable_event(actions::i_mail).

    %% Phone call
    :- public(i_call/0).
    i_call :-
        state::current_room(Here),
        ( Here = foyer ; Here = living_room ; Here = nfoyer ->
            writeln("The telephone rings.")
        ;   true
        ),
        clock::disable_event(actions::i_call).

    %% Gardener calms down (GARDENER-NO-REPLY cleared)
    :- public(i_gardener_calm/0).
    i_gardener_calm :-
        state::set_global(gardener_angry, false).

    %% Show hole in rose garden (I-SHOW-HOLE event)
    :- public(i_show_hole/0).
    i_show_hole :-
        state::clear_flag(hole, invisible),
        state::current_room(in_roses),
        writeln("You notice disturbed earth -- there appear to be holes in the soft dirt.").

    %% Baxter arrives
    :- public(i_baxter_arrive/0).
    i_baxter_arrive :- npc_ai::i_baxter_arrive.

    %% Coates arrives
    :- public(i_coates_arrive/0).
    i_coates_arrive :- npc_ai::i_coates_arrive.

    %% ---------------------------------------------------------------
    %% UTILITY
    %% ---------------------------------------------------------------

    %% Format a door open/closed description (ZIL: DDESC macro)
    :- public(ddesc/3).
    ddesc(Prefix, Door, Suffix) :-
        ( state::has_flag(Door, openbit) ->
            State = "open"
        ;   State = "closed"
        ),
        format("~w~w~w~n", [Prefix, State, Suffix]).

:- end_object.
