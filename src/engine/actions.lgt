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
    %% ROOM LOOK HANDLERS (M-LOOK)
    %% Called by describe_current_room to produce dynamic room descriptions.
    %% ZIL: each room's ACTION routine checks RARG = M-LOOK.
    %% ---------------------------------------------------------------

    :- public(room_look/1).

    room_look(front_path) :- !,
        ddesc("You are at the Robners' front door, which is ", front_door, "."),
        writeln("You can walk around the house from here to the east or west. To the south a"),
        writeln("rolling lawn leads to the entrance of the estate.").

    room_look(rose_garden) :- !,
        writeln("You are at the edge of a large rose garden, meticulously maintained by the"),
        writeln("gardener, Mr. McNabb. He is said to be exceedingly proud of this particular"),
        writeln("garden, which is the envy of the neighbors. Rows of roses are neatly arranged"),
        writeln("and the sweet fragrance of the flowers is worth a trip here in itself. An"),
        writeln("orchard to the east contains many varieties of fruit trees and wide lawns lie"),
        writeln("to the west and north. The roses themselves are to the south, filling the area"),
        writeln("between you and the back of the house.").

    room_look(in_orchard) :- !,
        writeln("You are amidst lovely trees bearing apples, pears, peaches, and other fruits."),
        writeln("A grape arbor and several berry bushes may also be seen. The kitchen window"),
        writeln("and east side of the house are just to your south, and a path skirts the"),
        writeln("orchard to your north."),
        ( state::global_val(ladder_flag_2, true) ->
            writeln("A ladder is leaning against the balcony above.")
        ;   writeln("There is no way into the house from here.")
        ).

    room_look(in_roses) :- !,
        writeln("You are among rows of roses. The ground is soft, and your footsteps leave"),
        writeln("a rather bad impression as many poor seedlings are trampled underfoot. A"),
        writeln("safer place to admire the flowers lies to the north. A window to the south"),
        writeln("allows a view into the house."),
        ( state::global_val(ladder_flag, true) ->
            writeln("A ladder is leaning against the house, its upper end against a balcony"),
            writeln("above.")
        ;   writeln("There is no way into the house from here.")
        ),
        ( \+ state::has_flag(hole, invisible) ->
            writeln("There are holes in the soft dirt near your feet.")
        ;   true
        ).

    room_look(foyer) :- !,
        ddesc("This is the foyer of the Robner house, beautifully appointed with a fine\ncrystal chandelier, marble floors, and a large marble-topped table. The front\ndoor, to the south, is ", front_door, ". The foyer continues north.").

    room_look(shall_1) :- !,
        ddesc("You are in an east-west hallway south of the staircase. A door to the south\nis ", rourke_door, ".").

    room_look(shall_2) :- !,
        ddesc("This is the end of the east-west hallway. To the south a small door\nis ", south_closet_door, "."),
        ddesc("Another door, to the east, is ", rourke_bath_door, ".").

    room_look(rourke_room) :- !,
        ddesc("This is the bedroom of the housekeeper, Mrs. Rourke, and is very simply\nfurnished. A single bed, flanked by bare wooden end tables, sits below a\nclosed window on the south end of the room. The floor is hardwood, with no\nrug. The only exit is a door to the north, which is ", rourke_door, ".").

    room_look(rourke_bath) :- !,
        ddesc("This is Mrs. Rourke's bathroom. Aside from the usual bathroom fixtures\nare two shelves affixed to the wall. The door at the west side of the\nroom is ", rourke_bath_door, ".").

    room_look(living_room) :- !,
        ddesc("This is a large and impressive room, whose furnishings bespeak the great\npersonal wealth of the Robners. The south side of the room is a large bay\nwindow, now ", bay_window, ", which looks out onto the front yard."),
        writeln("A wood pile sits beside a huge fieldstone fireplace. A double doorway leading"),
        writeln("to the main hall is the only exit. Pictures of Mrs. Robner's colonial ancestors"),
        writeln("line one wall. The room contains formal seating for at least fifteen people,"),
        writeln("in several groups of chairs and couches. Tables and cabinets, all of the"),
        writeln("finest mahogany and walnut, complete the furnishings. On one of the tables is"),
        writeln("a telephone.").

    room_look(corridor_1) :- !,
        write("You are just west of the staircase. There are doors on both sides (north and\nsouth) of the hallway, which continues west. "),
        ( state::has_flag(dunbar_door, openbit) ->
            ( state::has_flag(master_bedroom_door, openbit) ->
                writeln("Both doors are open.")
            ;   writeln("The door to the south is open.")
            )
        ; state::has_flag(master_bedroom_door, openbit) ->
            writeln("The door to the north is open.")
        ;   writeln("Both doors are closed.")
        ).

    room_look(corridor_3) :- !,
        ddesc("This section of hallway is near the west end. Through the window at the end\nof the hall you can see some trees and the lake beyond. The hallway continues\neast and west, and a door to the south is ", george_door, ".").

    room_look(corridor_4) :- !,
        writeln("This is the west end of the upstairs hall. To the north is the library,"),
        writeln("where Mr. Robner was found. Its solid oak door has been knocked down and"),
        writeln("is lying just inside the entrance to the library. A window which cannot"),
        writeln("be opened is at the end of the hallway.").

    room_look(library) :- !,
        writeln("This is the library where Mr. Robner's body was found. It is decorated in a"),
        writeln("simple but comfortable style. Mr. Robner obviously spent a great deal of time"),
        writeln("here. A wide executive desk sits before tall balcony windows which lie at the"),
        writeln("north of the room. A telephone is sitting on the desk. The east side of the"),
        writeln("room is composed of three large bookshelf units containing numerous volumes"),
        writeln("on many topics. The floor is carpeted from wall to wall. The massive oak door"),
        writeln("which blocked the entrance has been forcibly knocked off its hinges and is"),
        writeln("lying by the doorway."),
        ( state::has_flag(library_balcony_door, openbit) ->
            writeln("The window to the balcony has been opened.")
        ;   true
        ),
        ( state::has_flag(hidden_door_l, openbit) ->
            writeln("The bookshelf unit on the far left has been swung open,"),
            writeln("revealing a room behind it!")
        ;   true
        ).

    room_look(library_balcony) :- !,
        ddesc("The balcony is bare of furniture, though it has a beautiful view of the rose\ngarden, the north lawn and the lake. A metal railing around the balcony\nprevents an accidental drop to the thorny roses below. The window between the\nbalcony and the library is ", library_balcony_door, "."),
        ( state::global_val(ladder_flag, true) ->
            writeln("The top of a ladder is resting on the metal railing.")
        ;   true
        ).

    room_look(hidden_closet) :- !,
        write("This is a secret room situated between the library and the master bedroom.\nThe room is bare and somewhat dusty, as if it were not often used. An\nunmarked switchplate surrounds two buttons, one blue and one red. A formidable\nsafe is embedded in the south wall."),
        ( state::has_flag(safe, openbit) ->
            writeln(" The heavy safe door is wide open.")
        ;   nl
        ),
        ( state::has_flag(hidden_door_l, openbit) ->
            writeln("The library can be seen through a door to the west.")
        ; state::has_flag(hidden_door_b, openbit) ->
            writeln("The master bedroom can be seen through a door to the east.")
        ;   true
        ).

    room_look(master_bedroom) :- !,
        ddesc("This is the Robners' master bedroom, decorated in the Queen Anne style. A\nlarge four-poster bed with paired end tables fills the south end of the room.\nOn one of the end tables is a telephone. Dressers, a small chair, and a lounge\nare against the walls. The north wall contains a balcony window, which is\n", bedroom_balcony_door, ". An open doorway leads east to the bathroom. A large\nmirror with a gilt frame hangs on the west wall."),
        ( state::has_flag(hidden_door_b, openbit) ->
            writeln("Part of the west wall has been swung away, revealing a hidden closet.")
        ;   true
        ).

    room_look(bedroom_balcony) :- !,
        ddesc("This balcony is atop the orchard, with the tallest of the fruit trees rising\nto about the level of the balcony. A metal railing surrounds the balcony,\npreventing a precipitous descent. A glass door leading to the master bedroom\nis ", bedroom_balcony_door, "."),
        ( state::global_val(ladder_flag_2, true) ->
            writeln("The top of a ladder is visible here, leaning on the railing.")
        ;   true
        ).

    room_look(shall_11) :- !,
        ddesc("The hallway turns a corner here and continues east. To the north is the\nhead of the stairs. A door to the south is ", dunbar_bath_door, ".").

    room_look(dunbar_bath) :- !,
        write("This bathroom contains the usual sink, toilet, and bath. A medicine\ncabinet, "),
        ( state::has_flag(dunbar_cabinet, openbit) ->
            write("lying partially open")
        ;   write("closed")
        ),
        ddesc(", is above the sink. A door to the north\nis ", dunbar_bath_door, ".").

    room_look(dunbar_room) :- !,
        ddesc("This is Ms. Dunbar's room. It is furnished in the usual style, with a few\nadditions indicative of Ms. Dunbar's taste. The bedroom door\nis ", dunbar_door, ".").

    room_look(george_bath) :- !,
        ddesc("This is George's bathroom, with all the appropriate fixtures. Shaving gear\nsits near the sink. The door, to the west, is ", george_bath_door, ".").

    room_look(george_room) :- !,
        write("This is George's bedroom. In addition to the normal furnishings, there\nis a small liquor cabinet, and a stereo with records and tapes. The door,\nleading to the hallway to the north, is "),
        ( state::has_flag(george_door, openbit) -> write("open") ; write("closed") ),
        ddesc(". Another door, to the east, is ", george_bath_door, ".").

    %% Fallback: no room_look handler - fail so describe_current_room uses ldesc
    room_look(_) :- fail.

    %% ddesc(+Prefix, +DoorEntity, +Suffix) - print text with door state
    :- private(ddesc/3).
    ddesc(Prefix, Door, Suffix) :-
        write(Prefix),
        ( state::has_flag(Door, openbit) -> write("open") ; write("closed") ),
        writeln(Suffix).

    %% ---------------------------------------------------------------
    %% ROOM ACTION HANDLERS (M-BEG, M-END, M-ENTER)
    %% Called with phase (m_beg, m_end, m_enter) by PERFORM.
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
    %% OBJECT ACTION HANDLERS
    %% ZIL: P?ACTION routines for individual objects.
    %% object_action(+Verb, +DO, +IO) succeeds if the object handles
    %% the verb (intercepting the default verb handler).
    %% ---------------------------------------------------------------

    :- public(object_action/3).

    %% CUP-F
    object_action(V, cup, _IO) :-
        ( member(V, [v_examine, v_look_inside]) ->
            writeln("The cup is painted with a scene from Greek mythology and has a brown"),
            writeln("discoloration at the bottom.")
        ; V = v_smell ->
            writeln("The cup smells faintly of tea.")
        ; V = v_fingerprint ->
            writeln("There don't seem to be any fingerprints on the cup.")
        ; fail
        ).

    %% SAUCER-F
    object_action(V, saucer, _IO) :-
        ( member(V, [v_examine]) ->
            writeln("The saucer is hand-painted with a mythological scene. It has a couple of"),
            writeln("small areas of brown discoloration.")
        ; V = v_smell ->
            writeln("There is a faint smell of tea.")
        ; fail
        ).

    %% LIBRARY-CARPET-F
    object_action(V, library_carpet, _IO) :-
        ( V = v_look_under ->
            writeln("The carpeting is wall-to-wall so you can't look under it.")
        ; V = v_examine ->
            writeln("The carpet is an expensive affair, and quite clean, except for"),
            writeln("a few small areas of dried mud in the vicinity of the desk."),
            writeln("There are no other stains or markings that you can see."),
            state::clear_flag(mud_spot, invisible)
        ; fail
        ).

    %% BOOKSHELVES-F
    object_action(V, bookshelves, _IO) :-
        ( V = v_take ->
            writeln("You have better things to do than taking books from the shelves.")
        ; V = v_read ->
            writeln("Reading, while educational, will not help you solve this case.")
        ; member(V, [v_examine, v_search]) ->
            writeln("The shelves contain many books and manuscripts covering a wide range of"),
            writeln("subjects. They are meticulously arranged.")
        ; fail
        ).

    %% LIBRARY-DESK-F
    object_action(V, library_desk, _IO) :-
        ( V = v_look_inside ->
            writeln("There's nothing of interest in the desk.")
        ; V = v_examine ->
            writeln("It's a wide executive desk. A telephone sits on top."),
            %% List items on the desk
            ( state::location(note_paper, library_desk) ->
                writeln("Lying atop the desk is a pad of white note paper.")
            ; true
            ),
            ( state::location(desk_calendar, library_desk) ->
                writeln("A desk calendar is open to today's date.")
            ; true
            )
        ; fail
        ).

    %% NOTE-PAPER-F (pad) — ZIL: NOTE-PAPER-F in actions.zil
    %% Key evidence: hidden impressions revealed by rubbing/shading with pencil
    object_action(V, note_paper, IO) :-
        ( member(V, [v_read, v_examine]) ->
            ( state::global_val(note_read, true) ->
                pad_read("Examination of the paper")
            ;
                writeln("There doesn't seem to be anything written on the pad.")
            )
        ; V = v_rub ->
            ( IO = none ->
                writeln("You should try rubbing or shading the pad with something.")
            ; IO = pair(with, pencil) ->
                pad_read("Shading the paper with the pencil")
            ; IO = pencil ->
                pad_read("Shading the paper with the pencil")
            ;
                writeln("You should try rubbing or shading the pad with something.")
            )
        ; V = v_rub_over, IO = pair(over, note_paper) ->
            %% "rub pencil over pad" — PRSO=pencil, PRSI=pad, but dispatched as DO=pad
            pad_read("Running the pencil over the paper")
        ; V = v_run_over, IO = pair(over, note_paper) ->
            pad_read("Running the pencil over the paper")
        ; V = v_run_over, IO = pair(on, note_paper) ->
            pad_read("Running the pencil over the paper")
        ; V = v_hold_up ->
            pad_read("Looking at the pad against the light")
        ; fail
        ).

    %% PAD-READ helper — reveals hidden impressions on the notepad
    :- private(pad_read/1).
    pad_read(Method) :-
        state::set_global(note_read, true),
        format("~w reveals impressions left by writing on the previous sheet.~n", [Method]),
        writeln("The writer must have borne down heavily, but only a few words come out"),
        writeln("clearly:"),
        nl,
        writeln("  Baxter,"),
        nl,
        writeln("                  st time"),
        writeln(" nsist             op       merg"),
        writeln("       mnidy               Oth"),
        writeln("          forc"),
        writeln("         ocumen     y poss"),
        writeln("  plica     y      Focus s"),
        writeln("          recons"),
        writeln("late!"),
        writeln("                              rsha").

    %% DESK-CALENDAR-F
    object_action(V, desk_calendar, _IO) :-
        ( member(V, [v_read, v_examine]) ->
            writeln("The calendar is open to today's date. Several appointments are noted."),
            writeln("One says: \"Call Coates about the merger -- 10 AM.\"")
        ; fail
        ).

    %% TRASH-BASKET-F
    object_action(V, trash_basket, _IO) :-
        ( member(V, [v_examine, v_look_inside]) ->
            writeln("The wastepaper basket contains some crumpled papers.")
        ; fail
        ).

    %% TRASH-F (crumpled papers)
    object_action(V, trash, _IO) :-
        ( member(V, [v_take, v_read, v_examine]) ->
            state::set_flag(trash, touchbit),
            state::set_flag(trash_basket, touchbit),
            fail  %% RFALSE in ZIL means don't handle, pass to verb
        ; fail
        ).

    %% TRAY-F
    object_action(V, tray, _IO) :-
        ( V = v_examine ->
            writeln("It's a large collapsible tray, the kind used for serving tea.")
        ; fail
        ).

    %% PENCIL-F — also handles "rub pencil over pad", "run pencil over pad"
    object_action(V, pencil, IO) :-
        ( V = v_examine ->
            writeln("It's an ordinary pencil.")
        ; member(V, [v_rub_over, v_run_over]),
          ( IO = pair(over, note_paper) ; IO = pair(on, note_paper) ) ->
            pad_read("Running the pencil over the paper")
        ; fail
        ).

    %% EBULLION-BOTTLE-F
    object_action(V, ebullion_bottle, _IO) :-
        ( member(V, [v_read, v_examine]) ->
            writeln("The label reads: \"Ebullion: For temporary relief of upset stomach"),
            writeln("and gastrointestinal distress. CAUTION: Do not exceed recommended"),
            writeln("dosage. Keep away from children.\"")
        ; fail
        ).

    %% TELEPHONE-F
    object_action(V, telephone, _IO) :-
        ( V = v_examine ->
            writeln("It's a standard telephone.")
        ; V = v_take ->
            writeln("You can't take the telephone.")
        ; fail
        ).

    %% SUGAR-BOWL-F
    object_action(V, sugar_bowl, _IO) :-
        ( V = v_examine ->
            writeln("It's a white porcelain bowl with a small amount of white powder in it.")
        ; V = v_taste ->
            writeln("It tastes like ordinary table sugar.")
        ; fail
        ).

    %% FRAGMENT-F (pottery fragment — key evidence)
    object_action(V, fragment, _IO) :-
        ( V = v_examine ->
            writeln("It's a small fragment of what looks like fine china. It has a trace"),
            writeln("of brown discoloration.")
        ; V = v_smell ->
            writeln("It smells faintly of tea.")
        ; fail
        ).

    %% NEWSPAPER-F
    object_action(V, newspaper, _IO) :-
        ( member(V, [v_read, v_examine]) ->
            writeln("The lead story concerns the death of Marshall Robner, president of"),
            writeln("Robner Corp. The death has been ruled a suicide. Robner is survived by"),
            writeln("his wife Leslie, and son George."),
            state::set_flag(newspaper, touchbit)
        ; fail
        ).

    %% ENVELOPE-F
    object_action(V, envelope, _IO) :-
        ( V = v_examine ->
            writeln("It's a plain white envelope addressed to Mrs. Leslie Robner.")
        ; V = v_open ->
            ( state::has_flag(envelope, openbit) ->
                writeln("It's already open.")
            ;
                writeln("Opening the envelope, you find a letter inside."),
                state::set_flag(envelope, openbit),
                state::assertz(location(letter, envelope))
            )
        ; fail
        ).

    %% LETTER-F
    object_action(V, letter, _IO) :-
        ( member(V, [v_read, v_examine]) ->
            writeln("The letter is from the law offices of Coates and Coates. It reads,"),
            writeln("in part: \"...with regard to the new will, our initial opinion is that"),
            writeln("the document would stand up in court...\"")
        ; fail
        ).

    %% SUICIDE-NOTE-F
    object_action(V, suicide_note, _IO) :-
        ( member(V, [v_read, v_examine]) ->
            writeln("The note reads: \"I have decided that I can no longer go on living in"),
            writeln("this world. My apologies to those I leave behind. M. Robner.\"")
        ; fail
        ).

    %% SAFE-F (hidden closet)
    object_action(V, safe, _IO) :-
        ( V = v_examine ->
            ( state::has_flag(safe, openbit) ->
                writeln("The safe is open.")
            ;
                writeln("It's a small wall safe with a combination lock.")
            )
        ; fail
        ).

    %% LIBRARY-BUTTON-F (hidden black button behind bookshelves)
    object_action(V, library_button, _IO) :-
        ( V = v_push ->
            ( state::has_flag(hidden_door_l, openbit) ->
                writeln("The bookshelf swings closed, concealing the entrance."),
                state::clear_flag(hidden_door_l, openbit)
            ;
                writeln("The bookshelf swings open, revealing a small closet behind it!"),
                state::set_flag(hidden_door_l, openbit)
            )
        ; V = v_examine ->
            writeln("It's a small black button recessed into the back of the bookshelf.")
        ; fail
        ).

    %% RED-BUTTON-F (hidden closet — toggles library door)
    object_action(V, red_button, _IO) :-
        ( V = v_push ->
            ( state::has_flag(hidden_door_l, openbit) ->
                writeln("The door to the library swings closed."),
                state::clear_flag(hidden_door_l, openbit)
            ;
                writeln("The door to the library swings open."),
                state::set_flag(hidden_door_l, openbit)
            )
        ; V = v_examine ->
            writeln("It's a red button mounted on the wall.")
        ; fail
        ).

    %% BLUE-BUTTON-F (hidden closet — toggles bedroom door)
    object_action(V, blue_button, _IO) :-
        ( V = v_push ->
            ( state::has_flag(hidden_door_b, openbit) ->
                writeln("The door to the master bedroom swings closed."),
                state::clear_flag(hidden_door_b, openbit)
            ;
                writeln("The door to the master bedroom swings open."),
                state::set_flag(hidden_door_b, openbit)
            )
        ; V = v_examine ->
            writeln("It's a blue button mounted on the wall.")
        ; fail
        ).

    %% LADDER-F
    object_action(V, ladder, _IO) :-
        ( V = v_examine ->
            writeln("It's a wooden ladder about 15 feet long, caked with dirt.")
        ; V = v_take ->
            writeln("Taken."),
            state::retract(location(ladder, _)),
            state::assertz(location(ladder, player)),
            state::clear_flag(ladder, ladder_flag),
            state::clear_flag(ladder, ladder_flag_2)
        ; fail
        ).

    %% HOUSE-F
    object_action(V, house, _IO) :-
        ( V = v_examine ->
            writeln("The Robner house is a large colonial-style mansion set on a beautifully"),
            writeln("landscaped estate.")
        ; fail
        ).

    %% LAWN-F
    object_action(V, lawn, _IO) :-
        ( V = v_examine ->
            writeln("The lawn is well manicured.")
        ; fail
        ).

    %% ROSE-F
    object_action(V, roses, _IO) :-
        ( V = v_smell ->
            writeln("The roses smell lovely.")
        ; V = v_examine ->
            writeln("The roses are of many colors -- red, white, pink and yellow.")
        ; V = v_take ->
            writeln("You'd better not. The gardener might see you."),
            fail
        ; fail
        ).

    %% LIBRARY-DOOR-F (broken oak door)
    object_action(V, library_door, _IO) :-
        ( V = v_examine ->
            writeln("The solid oak door has been forcibly knocked off its hinges."),
            writeln("It is lying just inside the entrance to the library.")
        ; fail
        ).

    %% MUD-SPOT-F
    object_action(V, mud_spot, _IO) :-
        ( V = v_examine ->
            writeln("They look like ordinary spots of dried mud.")
        ; fail
        ).

    %% FOYER-TABLE-F
    object_action(V, foyer_table, _IO) :-
        ( V = v_examine ->
            writeln("It's a fine marble-topped table in the foyer.")
        ; fail
        ).

    %% TOILET-F
    object_action(V, toilet, _IO) :-
        ( V = v_examine ->
            writeln("It's a standard toilet. You search behind the tank for the Tidy-Bowl man,"),
            writeln("but he is nowhere to be found.")
        ; V = v_flush ->
            writeln("WHOOOOSH!")
        ; fail
        ).

    %% SHOWER-F
    object_action(V, shower, _IO) :-
        ( V = v_examine ->
            writeln("It's a standard shower stall.")
        ; V = v_take ->
            writeln("A shower would be nice, but this is hardly the place for it.")
        ; fail
        ).

    %% BED-F
    object_action(V, bed, _IO) :-
        ( V = v_examine ->
            writeln("It's a large, comfortable-looking bed.")
        ; fail
        ).

    %% STEREO-F
    object_action(V, stereo, _IO) :-
        ( V = v_examine ->
            writeln("It's a high-quality stereo system with turntable, amplifier, and speakers.")
        ; fail
        ).

    %% LIQUOR-F (George's room)
    object_action(V, liquor_cabinet, _IO) :-
        ( V = v_examine ->
            writeln("The liquor cabinet contains a generous supply of various spirits.")
        ; V = v_drink ->
            writeln("This is no time for a drink. You're on a case!")
        ; fail
        ).

    %% PAINTINGS-F / SEURAT-F
    object_action(V, paintings, _IO) :-
        ( V = v_examine ->
            writeln("The paintings are a fine collection of originals and prints.")
        ; fail
        ).

    object_action(V, seurat, _IO) :-
        ( V = v_examine ->
            writeln("It's a beautiful Seurat painting of a riverside scene.")
        ; fail
        ).

    %% PORTRAITS-F
    object_action(V, portraits, _IO) :-
        ( V = v_examine ->
            writeln("The portraits depict several generations of Robners, all looking"),
            writeln("serious and prosperous.")
        ; fail
        ).

    %% AIR-F
    object_action(V, air, _IO) :-
        ( V = v_smell ->
            state::current_room(Room),
            ( member(Room, [rose_garden, in_roses]) ->
                writeln("The sweet scent of roses fills the air.")
            ; member(Room, [south_lawn, front_path, east_lawn, west_lawn]) ->
                writeln("You can smell a faint breeze from the lake.")
            ;
                writeln("You smell nothing unusual.")
            )
        ; fail
        ).

    %% GROUND-F / FLOOR-F
    object_action(V, ground, _IO) :-
        ( V = v_examine ->
            state::current_room(Room),
            ( Room = library ->
                writeln("The floor is covered with an expensive carpet.")
            ; Room = foyer ->
                writeln("The floor is made of polished marble.")
            ;
                writeln("You see nothing special about the ground.")
            )
        ; fail
        ).

    %% DUST-F (hidden closet)
    object_action(V, dust, _IO) :-
        ( V = v_examine ->
            writeln("There is a thin layer of dust on most surfaces.")
        ; fail
        ).

    %% BAXTER-PAPERS-F (in safe)
    object_action(V, baxter_papers, _IO) :-
        ( member(V, [v_read, v_examine]) ->
            writeln("These are legal documents pertaining to the proposed merger of Robner"),
            writeln("Corp. with the Omnidyne Corporation. The terms would have given Baxter"),
            writeln("a considerable amount of money and power in the new company.")
        ; fail
        ).

    %% NEW-WILL-F (in safe)
    object_action(V, new_will, _IO) :-
        ( member(V, [v_read, v_examine]) ->
            writeln("This is a draft of a new will, apparently written recently by"),
            writeln("Mr. Robner. Under the terms of this will, George Robner would"),
            writeln("receive only a small trust, while the bulk of the estate would"),
            writeln("go to various charities and research foundations.")
        ; fail
        ).

    %% MEDICINE cabinet items
    %% Medicine bottles — examine shows label
    object_action(V, loblo_bottle, _IO) :-
        ( member(V, [v_read, v_examine]) ->
            writeln("The label reads: \"Frobizz Pharmacy #69105"),
            writeln("Ms. S. Dunbar"),
            writeln("LoBLO - Take 1 tablet 3 times daily"),
            writeln("Fizmo Labs, Ltd. - Kingston, Ont."),
            writeln("LoBLO Brand of Methsparin, USP 10mg Tablets"),
            writeln("Warning: LoBLO may be dangerous when used in combination"),
            writeln("with other medications.\"")
        ; fail
        ).

    object_action(V, loblo, _IO) :-
        ( V = v_examine ->
            writeln("They are small white tablets.")
        ; fail
        ).

    object_action(V, sneezo_bottle, _IO) :-
        ( member(V, [v_read, v_examine]) ->
            writeln("The label reads: \"Sneezo: For temporary relief of nasal congestion.\"")
        ; fail
        ).

    object_action(V, allergone_bottle, _IO) :-
        ( member(V, [v_read, v_examine]) ->
            writeln("The label reads: \"Allergone: For relief of allergy symptoms.\"")
        ; fail
        ).

    object_action(V, dum_kof_bottle, _IO) :-
        ( member(V, [v_read, v_examine]) ->
            writeln("The label reads: \"Dum-Kof: Effective cough suppressant.\"")
        ; fail
        ).

    %% ---------------------------------------------------------------
    %% BALCONY & RAILING HANDLERS
    %% ZIL: L-RAILING-F, B-RAILING-F, L-BALCONY-F, B-BALCONY-F
    %% ---------------------------------------------------------------

    %% L-RAILING-F — library balcony railing (key evidence: paint scrapes)
    object_action(V, l_railing, _IO) :-
        ( V = v_examine ->
            writeln("The railing is made of a sturdy metal and helps prevent nasty falls. There is"),
            writeln("a small area of paint scraped off the outside edge.")
        ; fail
        ).

    %% B-RAILING-F — bedroom balcony railing
    object_action(V, b_railing, _IO) :-
        ( V = v_examine ->
            writeln("This sturdy railing protects people on the balcony from being impaled upon"),
            writeln("the exotic plants below. The railing itself is uniformly painted.")
        ; fail
        ).

    %% L-BALCONY-F — library balcony surface (evidence: dried mud)
    object_action(V, l_balcony, _IO) :-
        ( V = v_examine ->
            writeln("The balcony itself is made of wood, except the railing which is metal. The"),
            writeln("balcony is in good repair, but a few spots of dried mud soil the floor.")
        ; fail
        ).

    %% B-BALCONY-F — bedroom balcony surface
    object_action(V, b_balcony, _IO) :-
        ( V = v_examine ->
            writeln("The balcony is wooden, excepting the metal railing surrounding it."),
            writeln("It is in good repair and is quite clean.")
        ; fail
        ).

    %% ---------------------------------------------------------------
    %% FURNITURE & DISPLAY HANDLERS
    %% ZIL: MASTER-BEDROOM-DRESSER-F, LR-CABINETS-F, S-SHELVES-F
    %% ---------------------------------------------------------------

    %% MASTER-BEDROOM-DRESSER-F
    object_action(V, master_bedroom_dresser, _IO) :-
        ( V = v_examine ->
            writeln("The dresser is a beautiful piece of cabinetry.")
        ; fail
        ).

    %% LR-CABINETS-F — living room cabinets
    object_action(V, lr_cabinets, _IO) :-
        ( V = v_examine ->
            writeln("The cabinets are beautifully handworked walnut and mahogany.")
        ; fail
        ).

    %% S-SHELVES-F — shed shelves
    object_action(V, s_shelves, _IO) :-
        ( V = v_examine ->
            writeln("The shelves contain various garden tools.")
        ; fail
        ).

    %% SILVERWARE-F
    object_action(V, silverware, _IO) :-
        ( V = v_examine ->
            writeln("The silver is of the finest quality and design.")
        ; V = v_take ->
            writeln("The silverware is not yours to take.")
        ; fail
        ).

    %% ---------------------------------------------------------------
    %% CHINA SET HANDLERS (kitchen/dining)
    %% ZIL: CSCP handler shared by CUPS-F, SAUCERS-F, PLATES-F, CHINA-F
    %% ---------------------------------------------------------------

    object_action(V, cups, _IO) :-
        ( V = v_examine ->
            writeln("Each one is hand-painted and depicts a scene from Greek mythology.")
        ; V = v_take ->
            writeln("Mrs. Robner would not appreciate your taking her valuable china.")
        ; fail
        ).

    object_action(V, saucers, _IO) :-
        ( V = v_examine ->
            writeln("Each one is hand-painted and depicts a scene from Greek mythology.")
        ; V = v_take ->
            writeln("Mrs. Robner would not appreciate your taking her valuable china.")
        ; fail
        ).

    object_action(V, plates, _IO) :-
        ( V = v_examine ->
            writeln("Each one is hand-painted and depicts a scene from Greek mythology.")
        ; V = v_take ->
            writeln("Mrs. Robner would not appreciate your taking her valuable china.")
        ; fail
        ).

    object_action(V, china, _IO) :-
        ( V = v_examine ->
            writeln("Each one is hand-painted and depicts a scene from Greek mythology.")
        ; V = v_take ->
            writeln("Mrs. Robner would not appreciate your taking her valuable china.")
        ; fail
        ).

    %% ---------------------------------------------------------------
    %% CRIME SCENE EVIDENCE
    %% ZIL: CORPSE-F, PISTOL-F
    %% ---------------------------------------------------------------

    %% CORPSE-F (Dunbar's body — late game evidence)
    object_action(V, corpse, _IO) :-
        ( V = v_examine ->
            writeln("The corpse is most gruesome. Ms. Dunbar was apparently shot in the"),
            writeln("head at close range, leaving a most distasteful mess.")
        ; fail
        ).

    %% PISTOL-F
    object_action(V, pistol, _IO) :-
        ( V = v_examine ->
            writeln("The pistol has bloodstains on it. It has recently been fired.")
        ; fail
        ).

:- end_object.
