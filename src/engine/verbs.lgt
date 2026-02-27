%%%  verbs.lgt  %%%
%%%
%%%  Generic verb implementations (the "ACTIONS table" in ZIL).
%%%  These are the default behaviors for verbs when no object-specific
%%%  action handler intercepts first.
%%%
%%%  ZIL source: verbs.zil (V-LOOK, V-EXAMINE, V-TAKE, V-DROP, V-PUT,
%%%              V-OPEN, V-CLOSE, V-INVENTORY, V-WALK, V-WAIT, etc.)
%%%
%%%  Copyright 1982 Infocom, Inc. (original game)
%%%  Logtalk refactoring: see CLAUDE.md

:- object(verbs).

    :- info([
        version is 1:0:0,
        comment is 'Default verb handlers: look, take, drop, put, open, close, inventory, etc.'
    ]).


    %% ---------------------------------------------------------------
    %% DISPATCH ENTRY POINT
    %% Called by game_loop::dispatch/3 as the generic verb handler.
    %% ---------------------------------------------------------------

    :- public(dispatch_verb/3).
    dispatch_verb(Verb, DO, IO) :-
        verb_handler(Verb, DO, IO).

    :- private(verb_handler/3).

    %% ---------------------------------------------------------------
    %% META / SYSTEM COMMANDS
    %% ---------------------------------------------------------------

    verb_handler(v_look, _, _)    :- v_look.
    verb_handler(v_verbose, _, _) :- v_verbose.
    verb_handler(v_brief, _, _)   :- v_brief.
    verb_handler(v_super, _, _)   :- v_super_brief.
    verb_handler(v_inventory, _, _) :- v_inventory.
    verb_handler(v_score, _, _)   :- v_score.
    verb_handler(v_time, _, _)    :- v_time.
    verb_handler(v_quit, _, _)    :- v_quit.
    verb_handler(v_restart, _, _) :- v_restart.
    verb_handler(v_wait, _, _)    :- v_wait.
    verb_handler(v_again, _, _)   :- v_again.
    verb_handler(v_version, _, _) :- v_version.
    verb_handler(v_diagnose, _, _):- v_diagnose.

    %% ---------------------------------------------------------------
    %% LOOK / EXAMINE
    %% ---------------------------------------------------------------

    verb_handler(v_examine, DO, _)      :- v_examine(DO).
    verb_handler(v_look_inside, DO, _)  :- v_look_inside(DO).
    verb_handler(v_look_under, DO, _)   :- v_look_under(DO).
    verb_handler(v_look_behind, DO, _)  :- v_look_behind(DO).
    verb_handler(v_look_on, DO, _)      :- v_look_on(DO).
    verb_handler(v_read, DO, _)         :- v_read(DO).
    verb_handler(v_search, DO, _)       :- v_search(DO).
    verb_handler(v_search_around, DO, _):- v_search_around(DO).
    verb_handler(v_find, DO, _)         :- v_find(DO).

    %% ---------------------------------------------------------------
    %% MOVEMENT
    %% ---------------------------------------------------------------

    verb_handler(v_walk, Dir, _)    :- v_walk(Dir).
    verb_handler(v_enter, none, _)  :- writeln("Enter what?").
    verb_handler(v_enter, DO, _)    :- v_through(DO).
    verb_handler(v_exit, none, _)   :- v_exit.
    verb_handler(v_exit, _, _)      :- v_exit.
    verb_handler(v_through, DO, _)  :- v_through(DO).
    verb_handler(v_climb_up, DO, _) :- v_climb_up(DO).
    verb_handler(v_climb_down, DO, _):- v_climb_down(DO).

    %% ---------------------------------------------------------------
    %% OBJECT MANIPULATION
    %% ---------------------------------------------------------------

    verb_handler(v_take, DO, _)              :- v_take(DO).
    verb_handler(v_drop, DO, _)              :- v_drop(DO).
    verb_handler(v_put, DO, pair(in, IO))    :- v_put(DO, in, IO).
    verb_handler(v_put, DO, pair(on, IO))    :- v_put(DO, on, IO).
    verb_handler(v_put, DO, pair(_, IO))     :- v_put(DO, in, IO).
    verb_handler(v_put, DO, _)               :- format("Put ~w where?~n", [DO]).
    verb_handler(v_put_under, DO, pair(under, IO)) :- v_put_under(DO, IO).
    verb_handler(v_open, DO, _)              :- v_open(DO).
    verb_handler(v_close, DO, _)             :- v_close(DO).
    verb_handler(v_lock, DO, pair(with, IO)) :- v_lock(DO, IO).
    verb_handler(v_unlock, DO, _)            :- v_unlock(DO).
    verb_handler(v_raise, DO, _)             :- v_take(DO).
    verb_handler(v_lower, DO, _)             :- v_drop(DO).
    verb_handler(v_push, DO, _)              :- v_push(DO).
    verb_handler(v_pull, DO, _)              :- v_pull(DO).
    verb_handler(v_move, DO, _)              :- v_move(DO).
    verb_handler(v_turn, DO, _)              :- v_turn(DO).
    verb_handler(v_use, DO, _)               :- v_use(DO).
    verb_handler(v_throw_at, DO, pair(at, IO)):- v_throw(DO, IO).

    %% ---------------------------------------------------------------
    %% DIALOGUE / SOCIAL
    %% ---------------------------------------------------------------

    verb_handler(v_accuse, Person, pair(with, Ev)) :- v_accuse(Person, Ev).
    verb_handler(v_accuse, Person, none)            :- v_accuse(Person, none).
    verb_handler(v_arrest, Person, _)               :- v_arrest(Person).
    verb_handler(v_confront, Person, pair(with, Ev)):- v_confront(Person, Ev).
    verb_handler(v_ask_about, Person, pair(about, Topic)) :- v_ask_about(Person, Topic).
    verb_handler(v_tell_me, Person, pair(about, Topic))   :- v_ask_about(Person, Topic).
    verb_handler(v_ask_for, Person, pair(for, Item))      :- v_ask_for(Person, Item).
    verb_handler(v_give, Item, pair(to, Person))          :- v_give(Item, Person).
    verb_handler(v_show, Item, pair(to, Person))          :- v_show(Item, Person).
    verb_handler(v_tell, Person, _)                       :- v_tell(Person).
    verb_handler(v_hello, _, _)                           :- v_hello.
    verb_handler(v_goodbye, _, _)                         :- v_goodbye.
    verb_handler(v_reply, _, _)                           :- v_reply.
    verb_handler(v_say, _, _)                             :- v_say.
    verb_handler(v_yn, _, _)                              :- v_yn.
    verb_handler(v_thank, _, _)                           :- v_thank.

    %% ---------------------------------------------------------------
    %% INVESTIGATE / ANALYZE
    %% ---------------------------------------------------------------

    verb_handler(v_analyze, DO, _)         :- v_analyze(DO).
    verb_handler(v_fingerprint, DO, _)     :- v_fingerprint(DO).
    verb_handler(v_what, DO, _)            :- v_what(DO).
    verb_handler(v_know, DO, _)            :- v_what(DO).

    %% ---------------------------------------------------------------
    %% MISC VERBS
    %% ---------------------------------------------------------------

    verb_handler(v_eat, DO, _)             :- v_eat(DO).
    verb_handler(v_drink, DO, _)           :- v_drink(DO).
    verb_handler(v_taste, DO, _)           :- v_taste(DO).
    verb_handler(v_smell, DO, _)           :- v_smell(DO).
    verb_handler(v_listen, DO, _)          :- v_listen(DO).
    verb_handler(v_rub, DO, _)             :- v_rub(DO).
    verb_handler(v_rub_over, _, _)        :- writeln("That doesn't seem to do anything.").
    verb_handler(v_run_over, _, _)        :- writeln("That doesn't seem to do anything.").
    verb_handler(v_hold_up, _, _)         :- writeln("That doesn't seem to reveal anything.").
    verb_handler(v_shake, DO, _)           :- v_shake(DO).
    verb_handler(v_wave, DO, _)            :- v_wave(DO).
    verb_handler(v_squeeze, DO, _)         :- v_squeeze(DO).
    verb_handler(v_kick, DO, _)            :- v_kick(DO).
    verb_handler(v_kiss, DO, _)            :- v_kiss(DO).
    verb_handler(v_knock, DO, _)           :- v_knock(DO).
    verb_handler(v_jump, _, _)             :- v_jump.
    verb_handler(v_swim, _, _)             :- v_swim.
    verb_handler(v_sleep, _, _)            :- writeln("You aren't sleepy.").
    verb_handler(v_mumble, _, _)           :- writeln("Mumble mumble.").
    verb_handler(v_skip, _, _)             :- writeln("You skip for a moment.").
    verb_handler(v_wait_for, DO, _)        :- v_wait_for(DO).
    verb_handler(v_wait_until, DO, _)      :- v_wait_for(DO).
    verb_handler(v_follow, DO, _)          :- v_follow(DO).
    verb_handler(v_call, DO, _)            :- v_call(DO).
    verb_handler(v_phone, DO, _)           :- v_phone(DO).
    verb_handler(v_attack, DO, _)          :- v_attack(DO).
    verb_handler(v_kill, DO, _)            :- v_kill(DO).

    %% ---------------------------------------------------------------
    %% LOOK (V-LOOK)
    %% ZIL: V-LOOK / DESCRIBE-ROOM / DESCRIBE-OBJECTS
    %% ---------------------------------------------------------------

    :- public(v_look/0).
    v_look :-
        game_loop::describe_current_room.

    %% ---------------------------------------------------------------
    %% VERBOSE / BRIEF
    %% ---------------------------------------------------------------

    :- public(v_verbose/0).
    v_verbose :-
        state::set_global(verbose_mode, true),
        writeln("OK, you will get verbose descriptions.").

    :- public(v_brief/0).
    v_brief :-
        state::set_global(verbose_mode, false),
        writeln("OK, you will get brief descriptions.").

    :- public(v_super_brief/0).
    v_super_brief :-
        state::set_global(verbose_mode, super),
        writeln("OK, you will get super-brief descriptions.").

    %% ---------------------------------------------------------------
    %% EXAMINE (V-EXAMINE)
    %% ---------------------------------------------------------------

    :- public(v_examine/1).
    v_examine(none) :- writeln("Examine what?").
    v_examine(DO) :-
        ( \+ resolver::is_accessible(DO) ->
            format("You don't see that here.~n", [])
        ;
            state::set_flag(DO, touchbit),
            %% 1. Try object's TEXT property (ZIL P?TEXT)
            ( catch(DO::text(T), _, fail) ->
                writeln(T)
            %% 2. Person: use character description
            ; state::has_flag(DO, person) ->
                person_examine(DO)
            %% 3. Container/door: look inside
            ; ( state::has_flag(DO, contbit) ; state::has_flag(DO, doorbit) ) ->
                v_look_inside(DO)
            %% 4. Generic fallback
            ;   ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
                format("There's nothing special about the ~w.~n", [D])
            )
        ).

    :- private(person_examine/1).
    person_examine(DO) :-
        catch(DO::ldesc(D), _, D = ''),
        ( D \= '' -> writeln(D) ; true ).

    %% ---------------------------------------------------------------
    %% LOOK INSIDE (V-LOOK-INSIDE)
    %% ---------------------------------------------------------------

    :- public(v_look_inside/1).
    v_look_inside(none) :- writeln("Look inside what?").
    v_look_inside(DO) :-
        ( state::has_flag(DO, contbit) ->
            ( state::has_flag(DO, openbit) ->
                ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
                findall(Item, (
                    state::location(Item, DO),
                    \+ state::has_flag(Item, invisible)
                ), Items),
                ( Items = [] ->
                    format("The ~w is empty.~n", [D])
                ;
                    format("The ~w contains:~n", [D]),
                    list_container_items(Items)
                )
            ;
                ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
                format("The ~w is closed.~n", [D])
            )
        ;   format("You can't look inside that.~n", [])
        ).

    :- private(list_container_items/1).
    list_container_items([]).
    list_container_items([Item|Rest]) :-
        ( catch(Item::desc(ID), _, ID = Item) -> true ; ID = Item ),
        format("  ~w~n", [ID]),
        list_container_items(Rest).

    %% ---------------------------------------------------------------
    %% LOOK UNDER/BEHIND/ON
    %% ---------------------------------------------------------------

    :- public(v_look_under/1).
    v_look_under(none) :- writeln("Look under what?").
    v_look_under(_DO) :- writeln("There's nothing under there.").

    :- public(v_look_behind/1).
    v_look_behind(none) :- writeln("Look behind what?").
    v_look_behind(_DO) :- writeln("There's nothing behind there.").

    :- public(v_look_on/1).
    v_look_on(none) :- writeln("Look on what?").
    v_look_on(DO) :-
        ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
        ( state::location(_, DO) ->
            format("On the ~w:~n", [D]),
            forall(
                state::location(Item, DO),
                ( catch(Item::desc(ID), _, ID = Item) -> true ; ID = Item,
                  format("  ~w~n", [ID])
                )
            )
        ;   format("There's nothing on the ~w.~n", [D])
        ).

    %% ---------------------------------------------------------------
    %% READ (V-READ)
    %% ---------------------------------------------------------------

    :- public(v_read/1).
    v_read(none) :- writeln("Read what?").
    v_read(DO) :-
        ( catch(DO::read_action, _, fail) -> true
        ;   ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
            format("There is nothing written on the ~w.~n", [D])
        ).

    %% ---------------------------------------------------------------
    %% INVENTORY (V-INVENTORY)
    %% ZIL: V-INVENTORY
    %% ---------------------------------------------------------------

    :- public(v_inventory/0).
    v_inventory :-
        findall(Item, state::location(Item, player), Items),
        ( Items = [] ->
            writeln("You are carrying nothing.")
        ;
            writeln("You are carrying:"),
            print_item_list(Items)
        ).

    %% ---------------------------------------------------------------
    %% TAKE (V-TAKE)
    %% ZIL: V-TAKE / PRE-TAKE
    %% ---------------------------------------------------------------

    :- public(v_take/1).
    v_take(none) :- writeln("Take what?").
    v_take(DO) :-
        ( state::location(DO, player) ->
            ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
            format("You already have the ~w.~n", [D])
        ; \+ resolver::is_accessible(DO) ->
            ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
            format("You don't see the ~w here.~n", [D])
        ; \+ state::has_flag(DO, takebit) ->
            ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
            format("You can't take the ~w.~n", [D])
        ; state::has_flag(DO, person) ->
            ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
            format("~w wouldn't appreciate that.~n", [D])
        ; \+ utils::can_carry(DO) ->
            writeln("Your load is too heavy.")
        ;
            state::move_entity(DO, player),
            state::set_flag(DO, touchbit),
            writeln("Taken.")
        ).

    %% ---------------------------------------------------------------
    %% DROP (V-DROP)
    %% ---------------------------------------------------------------

    :- public(v_drop/1).
    v_drop(none) :- writeln("Drop what?").
    v_drop(DO) :-
        ( \+ state::location(DO, player) ->
            ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
            format("You don't have the ~w.~n", [D])
        ;
            state::current_room(Room),
            state::move_entity(DO, Room),
            writeln("Dropped.")
        ).

    %% ---------------------------------------------------------------
    %% PUT (V-PUT)
    %% ---------------------------------------------------------------

    :- public(v_put/3).
    v_put(none, _, _) :- writeln("Put what?").
    v_put(DO, _, none) :- format("Put the ~w where?~n", [DO]).
    v_put(DO, _Prep, Container) :-
        ( \+ state::location(DO, player) ->
            ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
            format("You don't have the ~w.~n", [D])
        ; \+ state::has_flag(Container, contbit) ->
            ( catch(Container::desc(D), _, D = Container) -> true ; D = Container ),
            format("You can't put anything in the ~w.~n", [D])
        ; \+ state::has_flag(Container, openbit) ->
            ( catch(Container::desc(D), _, D = Container) -> true ; D = Container ),
            format("The ~w is closed.~n", [D])
        ;
            state::move_entity(DO, Container),
            writeln("Done.")
        ).

    :- public(v_put_under/2).
    v_put_under(_DO, _Under) :-
        writeln("That's not possible.").

    %% ---------------------------------------------------------------
    %% OPEN / CLOSE / LOCK / UNLOCK
    %% ---------------------------------------------------------------

    :- public(v_open/1).
    v_open(none) :- writeln("Open what?").
    v_open(DO) :-
        ( \+ state::has_flag(DO, doorbit), \+ state::has_flag(DO, contbit) ->
            writeln("That's not something you can open.")
        ; state::has_flag(DO, openbit) ->
            ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
            format("The ~w is already open.~n", [D])
        ; state::has_flag(DO, lockbit) ->
            ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
            format("The ~w is locked.~n", [D])
        ;
            state::set_flag(DO, openbit),
            ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
            %% ZIL V-OPEN content display logic (verbs.zil lines 536-556)
            ( state::has_flag(DO, doorbit) ->
                format("The ~w is now open.~n", [D])
            ;
                %% Find visible children
                findall(Child, (
                    state::location(Child, DO),
                    \+ state::has_flag(Child, invisible)
                ), Children),
                ( Children = [] ->
                    writeln("Opened.")
                ; Children = [Only] ->
                    %% Single item: show its fdesc if it has one
                    ( catch(Only::fdesc(FD), _, fail) ->
                        format("The ~w opens.~n", [D]),
                        writeln(FD)
                    ;
                        format("Opening the ~w reveals ", [D]),
                        print_contents(Children),
                        writeln(".")
                    )
                ;
                    %% Multiple items: "Opening the X reveals a Y, a Z, and a W."
                    format("Opening the ~w reveals ", [D]),
                    print_contents(Children),
                    writeln(".")
                )
            )
        ).

    %% print_contents(+Items) - ZIL PRINT-CONTENTS: "a X, a Y, and a Z"
    :- private(print_contents/1).
    print_contents([]) :- !.
    print_contents([Only]) :-
        !,
        ( catch(Only::desc(CD), _, CD = Only) -> true ; CD = Only ),
        format("a ~w", [CD]).
    print_contents([Item, Last]) :-
        !,
        ( catch(Item::desc(CD1), _, CD1 = Item) -> true ; CD1 = Item ),
        ( catch(Last::desc(CD2), _, CD2 = Last) -> true ; CD2 = Last ),
        format("a ~w, and a ~w", [CD1, CD2]).
    print_contents([Item|Rest]) :-
        ( catch(Item::desc(CD), _, CD = Item) -> true ; CD = Item ),
        format("a ~w, ", [CD]),
        print_contents(Rest).

    :- public(v_close/1).
    v_close(none) :- writeln("Close what?").
    v_close(DO) :-
        ( \+ state::has_flag(DO, doorbit), \+ state::has_flag(DO, contbit) ->
            writeln("That's not something you can close.")
        ; \+ state::has_flag(DO, openbit) ->
            ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
            format("The ~w is already closed.~n", [D])
        ;
            state::clear_flag(DO, openbit),
            writeln("Closed.")
        ).

    :- public(v_lock/2).
    v_lock(none, _) :- writeln("Lock what?").
    v_lock(DO, _Key) :-
        ( state::has_flag(DO, lockbit) ->
            ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
            format("The ~w is already locked.~n", [D])
        ;
            state::clear_flag(DO, openbit),
            state::set_flag(DO, lockbit),
            writeln("Locked.")
        ).

    :- public(v_unlock/1).
    v_unlock(none) :- writeln("Unlock what?").
    v_unlock(DO) :-
        ( \+ state::has_flag(DO, lockbit) ->
            ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
            format("The ~w isn't locked.~n", [D])
        ;
            state::clear_flag(DO, lockbit),
            writeln("Unlocked.")
        ).

    %% ---------------------------------------------------------------
    %% MOVEMENT
    %% ---------------------------------------------------------------

    :- public(v_walk/1).
    v_walk(Dir) :-
        game_loop::move_player(Dir).

    :- public(v_exit/0).
    v_exit :-
        state::current_room(Room),
        ( catch(Room::exit(out, Target, _Cond), _, fail) ->
            game_loop::move_player(out)
        ; catch(Room::exit(south, _, _), _, fail) ->
            game_loop::move_player(south)
        ;   writeln("You can't exit from here.")
        ).

    :- public(v_through/1).
    v_through(DO) :-
        ( DO = none -> writeln("Go through what?")
        ;   writeln("You can't go through that.")
        ).

    :- public(v_climb_up/1).
    v_climb_up(_DO) :- game_loop::move_player(up).

    :- public(v_climb_down/1).
    v_climb_down(_DO) :- game_loop::move_player(down).

    %% ---------------------------------------------------------------
    %% WAIT
    %% ---------------------------------------------------------------

    :- public(v_wait/0).
    v_wait :- writeln("Time passes.").

    :- public(v_wait_for/1).
    v_wait_for(none) :- writeln("Wait for what?").
    v_wait_for(_DO) :- writeln("Time passes.").

    %% ---------------------------------------------------------------
    %% SEARCH
    %% ---------------------------------------------------------------

    :- public(v_search/1).
    v_search(none) :- writeln("Search what?").
    v_search(DO) :-
        v_examine(DO).

    :- public(v_search_around/1).
    v_search_around(_) :-
        state::current_room(Room),
        ( catch(Room::ldesc(D), _, D = '') -> true ; D = '' ),
        ( D = '' -> writeln("You see nothing unusual.") ; writeln(D) ).

    :- public(v_find/1).
    v_find(none) :- writeln("Find what?").
    v_find(DO) :-
        ( state::location(DO, Loc) ->
            ( Loc = player ->
                ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
                format("You are carrying the ~w.~n", [D])
            ;   ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
                ( catch(Loc::desc(LD), _, LD = Loc) -> true ; LD = Loc ),
                format("The ~w is in ~w.~n", [D, LD])
            )
        ;   writeln("I can't find that.")
        ).

    %% ---------------------------------------------------------------
    %% ANALYSE / FINGERPRINT
    %% ---------------------------------------------------------------

    :- public(v_analyze/1).
    v_analyze(none) :- writeln("Analyze what?").
    v_analyze(DO) :-
        ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
        format("You study the ~w carefully but find nothing extraordinary.~n", [D]).

    :- public(v_fingerprint/1).
    v_fingerprint(none) :- writeln("Fingerprint what?").
    v_fingerprint(DO) :-
        ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
        format("You look for fingerprints on the ~w.~n", [D]),
        writeln("You find nothing conclusive.").

    %% ---------------------------------------------------------------
    %% ACCUSE / ARREST / CONFRONT
    %% ---------------------------------------------------------------

    :- public(v_accuse/2).
    v_accuse(none, _) :- writeln("Accuse whom?").
    v_accuse(Person, Evidence) :-
        ( catch(Person::desc(D), _, D = Person) -> true ; D = Person ),
        format("\"~w, I accuse you of the murder of Marshall Robner!", [D]),
        ( Evidence \= none ->
            ( catch(Evidence::desc(ED), _, ED = Evidence) -> true ; ED = Evidence ),
            format(" I have this ~w as evidence!", [ED])
        ;   true
        ),
        nl,
        writeln("\""),
        writeln("This requires more proof before making a formal accusation.").

    :- public(v_arrest/1).
    v_arrest(none) :- writeln("Arrest whom?").
    v_arrest(Person) :-
        ( catch(Person::desc(D), _, D = Person) -> true ; D = Person ),
        format("You attempt to arrest ~w. Without sufficient evidence, this won't stick.~n", [D]).

    :- public(v_confront/2).
    v_confront(none, _) :- writeln("Confront whom?").
    v_confront(Person, Evidence) :-
        ( catch(Person::desc(D), _, D = Person) -> true ; D = Person ),
        ( Evidence \= none ->
            ( catch(Evidence::desc(ED), _, ED = Evidence) -> true ; ED = Evidence ),
            format("You confront ~w with the ~w.~n", [D, ED])
        ;   format("You confront ~w.~n", [D])
        ),
        writeln("They look uncomfortable but say nothing incriminating.").

    %% ---------------------------------------------------------------
    %% ASK / TELL / DIALOGUE
    %% ---------------------------------------------------------------

    :- public(v_ask_about/2).
    v_ask_about(none, _) :- writeln("Ask whom?").
    v_ask_about(Person, Topic) :-
        ( catch(Person::dialogue_response(Topic, Response), _, Response = none) ->
            ( Response = none ->
                ( catch(Person::desc(D), _, D = Person) -> true ; D = Person ),
                format("~w has nothing to say about that.~n", [D])
            ;   writeln(Response)
            )
        ;
            ( catch(Person::desc(D), _, D = Person) -> true ; D = Person ),
            format("~w has nothing to say about that.~n", [D])
        ).

    :- public(v_ask_for/2).
    v_ask_for(Person, _Item) :-
        ( catch(Person::desc(D), _, D = Person) -> true ; D = Person ),
        format("~w declines.~n", [D]).

    :- public(v_give/2).
    v_give(none, _)  :- writeln("Give what?").
    v_give(_, none)  :- writeln("Give it to whom?").
    v_give(Item, Person) :-
        ( \+ state::location(Item, player) ->
            ( catch(Item::desc(D), _, D = Item) -> true ; D = Item ),
            format("You don't have the ~w.~n", [D])
        ;
            ( catch(Person::give_response(Item), _, fail) -> true
            ;   ( catch(Person::desc(D), _, D = Person) -> true ; D = Person ),
                format("~w doesn't want that.~n", [D])
            )
        ).

    :- public(v_show/2).
    v_show(none, _)  :- writeln("Show what?").
    v_show(_, none)  :- writeln("Show it to whom?").
    v_show(Item, Person) :-
        ( catch(Person::show_response(Item), _, fail) -> true
        ;   ( catch(Person::desc(D), _, D = Person) -> true ; D = Person ),
            format("~w looks at it without much interest.~n", [D])
        ).

    :- public(v_tell/1).
    v_tell(none) :- writeln("Tell whom?").
    v_tell(Person) :-
        ( catch(Person::desc(D), _, D = Person) -> true ; D = Person ),
        format("~w nods politely.~n", [D]).

    :- public(v_hello/0).
    v_hello :-
        state::current_room(Room),
        findall(NPC, (
            state::location(NPC, Room),
            state::has_flag(NPC, person),
            NPC \= player
        ), NPCs),
        ( NPCs = [] ->
            writeln("There's no one here to greet.")
        ;   greet_npc_list(NPCs)
        ).

    :- public(v_goodbye/0).
    v_goodbye :- writeln("Goodbye.").

    :- public(v_reply/0).
    v_reply :- writeln("There is no question to reply to.").

    :- public(v_say/0).
    v_say :- writeln("Say what?").

    :- public(v_yn/0).
    v_yn :- writeln("That's a rhetorical question.").

    :- public(v_thank/0).
    v_thank :- writeln("You're welcome, I'm sure.").

    %% ---------------------------------------------------------------
    %% WHAT
    %% ---------------------------------------------------------------

    :- public(v_what/1).
    v_what(none) :- writeln("What about what?").
    v_what(DO) :-
        ( catch(DO::ldesc(D), _, D = '') ->
            ( D = '' ->
                ( catch(DO::desc(D2), _, D2 = DO) -> true ; D2 = DO ),
                format("You don't know much about ~w.~n", [D2])
            ;   writeln(D)
            )
        ;   ( catch(DO::desc(D2), _, D2 = DO) -> true ; D2 = DO ),
            format("You don't know much about ~w.~n", [D2])
        ).

    %% ---------------------------------------------------------------
    %% EAT / DRINK / TASTE / SMELL
    %% ---------------------------------------------------------------

    :- public(v_eat/1).
    v_eat(none) :- writeln("Eat what?").
    v_eat(DO) :-
        ( state::has_flag(DO, foodbit) ->
            ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
            format("You eat the ~w.~n", [D]),
            state::remove_entity(DO)
        ;   writeln("That's not edible.")
        ).

    :- public(v_drink/1).
    v_drink(none) :- writeln("Drink what?").
    v_drink(DO) :-
        ( state::has_flag(DO, drinkbit) ->
            ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
            format("You drink the ~w.~n", [D]),
            state::remove_entity(DO)
        ;   writeln("That's not drinkable.")
        ).

    :- public(v_taste/1).
    v_taste(DO) :-
        ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
        format("The ~w tastes unremarkable.~n", [D]).

    :- public(v_smell/1).
    v_smell(DO) :-
        ( DO = none ->
            writeln("You detect nothing unusual.")
        ;   ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
            format("The ~w smells unremarkable.~n", [D])
        ).

    :- public(v_listen/1).
    v_listen(_) :- writeln("You hear nothing unusual.").

    %% ---------------------------------------------------------------
    %% PHYSICAL MANIPULATION
    %% ---------------------------------------------------------------

    :- public(v_rub/1).
    v_rub(none) :- writeln("Rub what?").
    v_rub(DO) :-
        ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
        format("Rubbing the ~w achieves nothing.~n", [D]).

    :- public(v_shake/1).
    v_shake(none) :- writeln("Shake what?").
    v_shake(DO) :-
        ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
        format("You shake the ~w. Nothing falls out.~n", [D]).

    :- public(v_wave/1).
    v_wave(none) :- writeln("Wave what?").
    v_wave(DO) :-
        ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
        format("You wave the ~w. Nothing happens.~n", [D]).

    :- public(v_squeeze/1).
    v_squeeze(none) :- writeln("Squeeze what?").
    v_squeeze(DO) :-
        ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
        format("Squeezing the ~w doesn't help.~n", [D]).

    :- public(v_push/1).
    v_push(none) :- writeln("Push what?").
    v_push(DO) :-
        ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
        format("Pushing the ~w doesn't accomplish anything.~n", [D]).

    :- public(v_pull/1).
    v_pull(none) :- writeln("Pull what?").
    v_pull(DO) :-
        ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
        format("Pulling the ~w doesn't accomplish anything.~n", [D]).

    :- public(v_move/1).
    v_move(none) :- writeln("Move what?").
    v_move(DO) :-
        ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
        format("Moving the ~w reveals nothing.~n", [D]).

    :- public(v_turn/1).
    v_turn(none) :- writeln("Turn what?").
    v_turn(DO) :-
        ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
        format("Turning the ~w accomplishes nothing.~n", [D]).

    :- public(v_use/1).
    v_use(none) :- writeln("Use what?").
    v_use(DO) :-
        ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
        format("You don't know how to use the ~w that way.~n", [D]).

    :- public(v_throw/2).
    v_throw(none, _) :- writeln("Throw what?").
    v_throw(DO, _At) :-
        ( \+ state::location(DO, player) ->
            writeln("You're not holding that.")
        ;
            state::current_room(Room),
            state::move_entity(DO, Room),
            ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
            format("You throw the ~w.~n", [D])
        ).

    :- public(v_kick/1).
    v_kick(none) :- writeln("Kick what?").
    v_kick(DO) :-
        ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
        format("Kicking the ~w doesn't help.~n", [D]).

    :- public(v_kiss/1).
    v_kiss(none) :- writeln("Kiss what?").
    v_kiss(_DO) :- writeln("Don't be ridiculous.").

    :- public(v_knock/1).
    v_knock(none) :- writeln("Knock on what?").
    v_knock(_DO) :- writeln("There is no answer.").

    :- public(v_jump/0).
    v_jump :- writeln("You jump up and down. Nothing happens.").

    :- public(v_swim/0).
    v_swim :- writeln("There's no suitable water here.").

    :- public(v_attack/1).
    v_attack(_) :- writeln("Violence is not the answer in a detective story.").

    :- public(v_kill/1).
    v_kill(_) :- writeln("Violence is not the answer in a detective story.").

    :- public(v_follow/1).
    v_follow(none) :- writeln("Follow whom?").
    v_follow(Person) :-
        ( catch(Person::desc(D), _, D = Person) -> true ; D = Person ),
        format("You'll have to follow ~w yourself.~n", [D]).

    :- public(v_call/1).
    v_call(none) :- writeln("The telephone is in the foyer.").
    v_call(DO) :-
        ( catch(DO::desc(D), _, D = DO) -> true ; D = DO ),
        format("There's no way to call ~w right now.~n", [D]).

    :- public(v_phone/1).
    v_phone(_DO) :- writeln("You'd need access to a telephone.").

    %% ---------------------------------------------------------------
    %% SCORE / TIME
    %% ---------------------------------------------------------------

    :- public(v_score/0).
    v_score :-
        writeln("Scoring is handled through your investigative progress."),
        clock::display_time.

    :- public(v_time/0).
    v_time :- clock::display_time.

    %% ---------------------------------------------------------------
    %% QUIT / RESTART / VERSION / DIAGNOSE
    %% ---------------------------------------------------------------

    :- public(v_quit/0).
    v_quit :- game_loop::confirm_quit.

    :- public(v_restart/0).
    v_restart :-
        writeln("Restarting..."),
        halt.  % caller should re-invoke go/0 in a real implementation

    :- public(v_version/0).
    v_version :-
        writeln("DEADLINE"),
        writeln("Logtalk/Prolog refactoring"),
        writeln("Original game Copyright 1982 Infocom, Inc.").

    :- public(v_diagnose/0).
    v_diagnose :-
        writeln("You are in good health.").

    %% ---------------------------------------------------------------
    %% AGAIN
    %% ---------------------------------------------------------------

    :- public(v_again/0).
    v_again :-
        ( state::global_val(last_verb, V), V \= none ->
            state::global_val(last_do, DO),
            state::global_val(last_io, IO),
            game_loop::perform(V, DO, IO)
        ;   writeln("Nothing to repeat.")
        ).

    %% ---------------------------------------------------------------
    %% HELPER PREDICATES
    %% ---------------------------------------------------------------

    :- private(print_item_list/1).
    print_item_list([]).
    print_item_list([Item|Rest]) :-
        ( catch(Item::desc(D), _, D = Item) -> true ; D = Item ),
        format("  ~w~n", [D]),
        print_item_list(Rest).

    :- private(greet_npc_list/1).
    greet_npc_list([]).
    greet_npc_list([NPC|Rest]) :-
        ( catch(NPC::greet_response, _, fail) -> true
        ;   ( catch(NPC::desc(D), _, D = NPC) -> true ; D = NPC ),
            format("~w nods politely.~n", [D])
        ),
        greet_npc_list(Rest).

:- end_object.
