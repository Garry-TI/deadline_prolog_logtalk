%%%  game_loop.lgt  %%%
%%%
%%%  Main game loop and action dispatch pipeline (PERFORM routine).
%%%  Reads player input, parses it, dispatches to verb/action handlers,
%%%  runs the clock, and repeats until game end.
%%%
%%%  ZIL source: main.zil (GO, MAIN-LOOP, PERFORM, QCONTEXT-CHECK)
%%%
%%%  Copyright 1982 Infocom, Inc. (original game)
%%%  Logtalk refactoring: see CLAUDE.md

:- object(game_loop).

    :- info([
        version is 1:0:0,
        comment is 'Main game loop and action dispatch (mirrors ZIL PERFORM pipeline).'
    ]).

    :- uses(user, [read_line_to_string/2, string_length/2, memberchk/2]).

    %% ---------------------------------------------------------------
    %% CONSTANTS
    %% ZIL: M-FATAL, M-HANDLED, M-NOT-HANDLED, M-BEG, M-END, M-ENTER, M-LOOK
    %% ---------------------------------------------------------------

    %% Action result codes (return values from action handlers)
    :- public(result/1).
    result(m_fatal).      % fatal: halt current action chain
    result(m_handled).    % handled: don't pass to next handler
    result(m_not_handled).% not handled: pass to next handler

    %% Room action phases
    :- public(phase/1).
    phase(m_beg).    % before action
    phase(m_end).    % after action
    phase(m_enter).  % entering room
    phase(m_look).   % looking at room

    %% ---------------------------------------------------------------
    %% ENTRY POINT
    %% ZIL: GO routine in main.zil
    %% ---------------------------------------------------------------

    :- public(go/0).
    go :-
        %% Initialize game state
        globals_init::initialize,
        %% Queue initial events (newspaper, mail, arrivals)
        clock::start_interrupts,
        %% Start NPC movement schedules
        npc_ai::start_movement,
        %% Print game banner and initial room description
        print_banner,
        nl,
        %% Look at starting room
        verbs::v_look,
        %% Enter main loop
        main_loop.

    :- private(print_banner/0).
    print_banner :-
        nl,
        writeln("DEADLINE"),
        writeln("An Interactive Mystery"),
        writeln("Copyright 1982 by Infocom, Inc."),
        writeln("All rights reserved. DEADLINE and INFOCOM are registered trademarks of Infocom, Inc."),
        writeln("Release 27 / Serial number 821108"),
        nl,
        clock::display_time,
        nl.

    %% ---------------------------------------------------------------
    %% MAIN LOOP
    %% ZIL: MAIN-LOOP routine in main.zil
    %% Reads player input, dispatches action, runs clock, repeats.
    %% ---------------------------------------------------------------

    :- public(main_loop/0).
    main_loop :-
        repeat,
            read_command,
        fail.
    main_loop.

    :- private(read_command/0).
    read_command :-
        nl,
        write("> "),
        read_line_to_string(user_input, Input),
        ( string_length(Input, 0) ->
            true  % empty input: just repeat
        ;
            process_input(Input)
        ).

    :- private(process_input/1).
    process_input(Input) :-
        ( resolver::parse_and_resolve(Input, cmd(Verb, DO, IO)) ->
            %% Update context: clear qcontext if player left room
            update_qcontext,
            %% Execute the command
            perform(Verb, DO, IO),
            %% Advance clock (unless meta-command)
            ( skip_clock(Verb) -> true ; clock::clocker )
        ;   true  % parse failure already printed message
        ).

    %% Commands that don't advance the clock
    :- private(skip_clock/1).
    skip_clock(v_brief).
    skip_clock(v_super).
    skip_clock(v_verbose).
    skip_clock(v_save).
    skip_clock(v_restore).
    skip_clock(v_script).
    skip_clock(v_unscript).
    skip_clock(v_quit).
    skip_clock(v_restart).
    skip_clock(v_version).
    skip_clock(v_score).
    skip_clock(v_time).

    %% ---------------------------------------------------------------
    %% QCONTEXT CHECK
    %% ZIL: QCONTEXT-CHECK - if player typed WHAT/FIND/TELL, redirect
    %% to the NPC being addressed (QCONTEXT).
    %% ---------------------------------------------------------------

    :- private(update_qcontext/0).
    update_qcontext :-
        state::current_room(Here),
        ( state::global_val(qcontext_room, QRoom), QRoom \= Here ->
            state::set_global(qcontext, none),
            state::set_global(qcontext_room, none)
        ;   true
        ).

    :- public(qcontext_redirect/1).
    qcontext_redirect(DO) :-
        state::global_val(qcontext, QCtx),
        QCtx \= none,
        state::current_room(Here),
        state::location(QCtx, Here),
        state::global_val(qcontext_room, Here),
        state::current_actor(player),
        state::current_verb(Verb),
        memberchk(Verb, [v_what, v_find, v_tell_me, v_show]),
        %% Redirect: set winner to the NPC being addressed
        state::set_current_actor(QCtx),
        ( catch(QCtx::desc(D), _, D = QCtx) -> true ; D = QCtx ),
        format("(said to ~w)~n", [D]),
        state::set_current_action(Verb, DO, none).

    %% ---------------------------------------------------------------
    %% PERFORM
    %% ZIL: PERFORM routine - chain-of-responsibility action dispatch.
    %%
    %% Priority order (mirrors ZIL):
    %%   1. Winner (current actor) action handler
    %%   2. Room action handler (M-BEG phase)
    %%   3. Pre-action handler (PREACTIONS table)
    %%   4. Indirect object action handler
    %%   5. Direct object action handler
    %%   6. Generic verb action handler (ACTIONS table)
    %%   7. Room action handler (M-END phase)
    %% ---------------------------------------------------------------

    :- public(perform/3).
    perform(Verb, DO, IO) :-
        %% Save previous action for AGAIN
        ( Verb \= v_again ->
            state::retractall(global_val(last_verb, _)),
            state::retractall(global_val(last_do, _)),
            state::retractall(global_val(last_io, _)),
            state::assertz(global_val(last_verb, Verb)),
            state::assertz(global_val(last_do, DO)),
            state::assertz(global_val(last_io, IO))
        ;   true
        ),
        %% Resolve any pronouns in DO/IO
        resolve_objects(Verb, DO, IO, ResDO, ResIO),
        %% Update PRSO/PRSI
        state::set_current_action(Verb, ResDO, ResIO),
        %% Update pronouns for the resolved objects
        update_pronouns(ResDO, ResIO),
        %% Dispatch through the pipeline
        dispatch(Verb, ResDO, ResIO).

    :- private(resolve_objects/5).
    resolve_objects(_Verb, DO, IO, ResDO, ResIO) :-
        resolve_one(DO, ResDO),
        resolve_one(IO, ResIO).

    :- private(resolve_one/2).
    resolve_one(none, none) :- !.
    resolve_one(pair(Prep, Obj), pair(Prep, ResObj)) :-
        !,
        resolve_one(Obj, ResObj).
    resolve_one(pronoun(Type), Entity) :-
        !,
        ( state::pronoun(Type, Entity), Entity \= none -> true
        ;   format("I'm not sure what you're referring to.~n", []),
            fail
        ).
    resolve_one(np(Words), Entity) :-
        !,
        resolver::resolve_np(np(Words), _, direct, Entity).
    resolve_one(Entity, Entity).  % already an atom

    :- private(update_pronouns/2).
    update_pronouns(DO, _IO) :-
        ( atom(DO), DO \= none ->
            ( state::has_flag(DO, person) ->
                resolver::update_pronoun_him_her(DO)
            ;   resolver::update_pronoun_it(DO)
            )
        ;   true
        ).

    :- private(dispatch/3).
    dispatch(Verb, DO, IO) :-
        state::current_actor(Actor),
        state::current_room(Room),

        %% 1. Actor/winner action handler (intercepts if succeeds)
        ( Actor \= player,
          catch(Actor::action(ActorHandler), _, fail),
          call(ActorHandler, Verb, DO, IO) -> true
        ;

        %% 2. Room M-BEG handler (intercepts if succeeds)
          ( catch(Room::action(RoomHandler), _, fail),
            call(RoomHandler, m_beg, Verb, DO, IO) ) -> true
        ;

        %% 3. Pre-action gate check
        %% pre_action is a guard: if a clause exists and fails, it means
        %% the action is blocked (e.g. "You can't take that."). If it
        %% succeeds or has no matching clause, continue to verb handler.
          ( pre_action_check(Verb, DO, IO) ->

            %% 4. Indirect object handler (intercepts if succeeds)
            ( ( IO \= none, io_obj(IO, IOObj),
                catch(IOObj::action(IOHandler), _, fail),
                call(IOHandler, Verb, DO, IO) ) -> true
            ;

            %% 5. Direct object handler (intercepts if succeeds)
              ( DO \= none,
                catch(DO::action(DOHandler), _, fail),
                call(DOHandler, Verb, DO, IO) ) -> true
            ;

            %% 6. Generic verb handler
              call_verb(Verb, DO, IO) -> true
            ;

            %% Default: no handler found
              format("I don't know how to do that.~n", [])
            )

          ; true  %% pre_action gate failed = blocked, stop here
          )
        ),

        %% 7. Room M-END handler (always runs after action)
        ( catch(Room::action(EndHandler), _, fail),
          call(EndHandler, m_end, Verb, DO, IO) -> true
        ;   true
        ).

    %% pre_action_check/3 - returns true if no pre_action clause exists
    %% for this verb, or if the pre_action clause succeeds. Fails only
    %% when a pre_action clause exists and explicitly fails (= blocked).
    :- private(pre_action_check/3).
    pre_action_check(Verb, DO, IO) :-
        ( catch(actions::pre_action(Verb, DO, IO), _, true) ->
            true  %% pre_action succeeded or threw (caught as true)
        ;
            %% pre_action failed: is it because no clause exists, or
            %% because the clause explicitly failed (blocked)?
            %% Check if a clause head matches this verb at all.
            ( \+ catch(actions::pre_action(Verb, _, _), _, fail) ->
                true  %% no clause for this verb at all: not blocked
            ;
                fail  %% clause exists but failed: blocked
            )
        ).

    :- private(io_obj/2).
    io_obj(pair(_, Obj), Obj) :- !.
    io_obj(Obj, Obj).

    :- private(call_verb/3).
    call_verb(Verb, DO, IO) :-
        ( catch(verbs::dispatch_verb(Verb, DO, IO), _, fail) -> true
        ; true
        ).

    %% ---------------------------------------------------------------
    %% ROOM DESCRIPTION
    %% Called when player enters a room or types LOOK.
    %% ---------------------------------------------------------------

    :- public(describe_current_room/0).
    describe_current_room :-
        state::current_room(Room),
        %% Room name banner
        ( catch(Room::desc(ShortDesc), _, ShortDesc = Room) -> true ; ShortDesc = Room ),
        nl,
        writeln(ShortDesc),
        %% Long description: try room_look action first, then static ldesc
        ( \+ state::has_flag(Room, touchbit) ->
            ( catch(actions::room_look(Room), _, fail) -> true
            ; catch(Room::fdesc(FD), _, fail) -> writeln(FD)
            ; catch(Room::ldesc(LD), _, fail) -> writeln(LD)
            ; true
            )
        ;
            %% Verbose mode or room_look: always show desc
            ( state::global_val(verbose_mode, true) ->
                ( catch(actions::room_look(Room), _, fail) -> true
                ; catch(Room::ldesc(LD), _, fail) -> writeln(LD)
                ; true
                )
            ;   true
            )
        ),
        state::set_flag(Room, touchbit),
        %% List room contents
        nl,
        utils::describe_room_contents(Room),
        nl.

    %% ---------------------------------------------------------------
    %% MOVEMENT
    %% Handle player walking in a direction.
    %% ---------------------------------------------------------------

    :- public(move_player/1).
    move_player(Direction) :-
        state::current_room(Room),
        ( catch(Room::get_exit(Direction, Target), _, fail) ->
            state::move_entity(player, Target),
            state::set_current_room(Target),
            %% Room entrance event
            ( catch(Target::action(AH), _, fail) ->
                call(AH, m_enter, v_walk, Target, none)
            ;   true
            ),
            describe_current_room
        ;
            %% Exit blocked or non-existent
            ( catch(Room::exit(Direction, none, Msg), _, fail),
              ( atom(Msg) ; string(Msg) ) ->
                writeln(Msg)
            ;   format("You can't go that way.~n", [])
            )
        ).

    %% ---------------------------------------------------------------
    %% GAME OVER / QUIT
    %% ---------------------------------------------------------------

    :- public(game_over/1).
    game_over(Message) :-
        nl, writeln(Message), nl,
        halt.

    :- public(confirm_quit/0).
    confirm_quit :-
        write("Are you sure you want to quit? (y/n) "),
        read_line_to_string(user_input, Ans),
        ( string_lower(Ans, "y") -> halt ; true ).

:- end_object.
