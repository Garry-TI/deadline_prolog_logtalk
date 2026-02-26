%%%  clock.lgt  %%%
%%%
%%%  Event queue system and time management.
%%%  Maintains a queue of timed events; fires them when their countdown
%%%  reaches zero. Tracks present_time (total ticks), score (hour), and
%%%  moves (minutes within the hour).
%%%
%%%  ZIL source: clock.zil (DEMON, QUEUE, INT, CLOCKER routines)
%%%              main.zil (I-START-INTERRUPTS, CLOCK-WAIT global)
%%%
%%%  Copyright 1982 Infocom, Inc. (original game)
%%%  Logtalk refactoring: see CLAUDE.md

:- object(clock).

    :- info([
        version is 1:0:0,
        comment is 'Event queue and game clock. Manages time, queues events, fires them on tick.'
    ]).

    %% ---------------------------------------------------------------
    %% PUBLIC API
    %% ---------------------------------------------------------------

    %% queue_event(+Routine, +Delay)
    %% Register an event to fire after Delay ticks.
    %% If Routine already in queue, update its countdown.
    %% ZIL: <QUEUE routine tick>
    :- public queue_event/2.
    queue_event(Routine, Delay) :-
        state::global_val(present_time, T),
        FireAt is T + Delay,
        ( state::event(Routine, _, _) ->
            state::retractall(event(Routine, _, _)),
            state::assertz(event(Routine, FireAt, normal))
        ;
            state::assertz(event(Routine, FireAt, normal))
        ).

    %% queue_demon(+Routine, +Delay)
    %% Register a daemon (runs every tick, not one-shot).
    %% ZIL: <DEMON routine tick>
    :- public queue_demon/2.
    queue_demon(Routine, Delay) :-
        state::global_val(present_time, T),
        FireAt is T + Delay,
        ( state::event(Routine, _, _) ->
            state::retractall(event(Routine, _, _)),
            state::assertz(event(Routine, FireAt, demon))
        ;
            state::assertz(event(Routine, FireAt, demon))
        ).

    %% enable_event(+Routine)
    %% Mark an event as active (it will fire when its time comes).
    %% ZIL: <ENABLE ...>
    :- public enable_event/1.
    enable_event(Routine) :-
        ( state::event_enabled(Routine) -> true
        ; state::assertz(event_enabled(Routine))
        ).

    %% disable_event(+Routine)
    %% Prevent an event from firing (keep it queued but inactive).
    %% ZIL: <DISABLE ...>
    :- public disable_event/1.
    disable_event(Routine) :-
        state::retractall(event_enabled(Routine)).

    %% queue_and_enable(+Routine, +Delay)
    %% Queue and immediately enable an event (common pattern in ZIL).
    :- public queue_and_enable/2.
    queue_and_enable(Routine, Delay) :-
        queue_event(Routine, Delay),
        enable_event(Routine).

    %% clocker
    %% Advance time by one tick and fire all due enabled events.
    %% ZIL: CLOCKER routine in clock.zil
    :- public clocker/0.
    clocker :-
        %% ZIL: CLOCK-WAIT check — skip this tick if set
        ( state::global_val(clock_wait, true) ->
            state::set_global(clock_wait, false)
        ;
            advance_time,
            check_deadline,
            fire_events
        ).

    %% ---------------------------------------------------------------
    %% TIME ADVANCEMENT
    %% ZIL: SCORE = hour (8-23 wrapping), MOVES = minutes (0-59)
    %%      PRESENT-TIME = total ticks since game start
    %% ---------------------------------------------------------------

    :- private advance_time/0.
    advance_time :-
        %% Increment total tick counter
        state::increment_global(present_time, _, _),

        %% Increment minutes counter; roll over at 60 → advance hour
        state::global_val(moves, M),
        M1 is M + 1,
        ( M1 > 59 ->
            state::set_global(moves, 0),
            state::global_val(score, H),
            H1 is H + 1,
            ( H1 > 23 ->
                state::set_global(score, 0)
            ;   state::set_global(score, H1)
            )
        ;   state::set_global(moves, M1)
        ).

    %% check_deadline/0 — end game if time limit exceeded
    %% ZIL: <COND (<G? ,PRESENT-TIME 1199> ... <QUIT>)>
    :- private check_deadline/0.
    check_deadline :-
        state::global_val(present_time, T),
        ( T > 1199 ->
            nl,
            writeln("Chief Inspector Klutz walks up to you, seemingly from out of nowhere."),
            writeln("\"I'm sorry, Inspector, but your time is up here.  I'm sorry that you"),
            writeln("didn't have any more time to investigate the case.  Maybe next time...\""),
            writeln("He escorts you to a waiting police car, in which you go off into"),
            writeln("the sunset."),
            nl,
            halt
        ;   true
        ).

    %% fire_events/0 — fire all enabled events whose countdown has expired
    :- private fire_events/0.
    fire_events :-
        state::global_val(present_time, T),
        %% Check all enabled events
        forall(
            ( state::event(Routine, FireAt, _Type),
              state::event_enabled(Routine),
              T >= FireAt
            ),
            fire_one(Routine, T)
        ).

    :- private fire_one/2.
    fire_one(Routine, _T) :-
        ( call(Routine) -> true ; true ),  % fire event; ignore failure
        %% Remove one-shot events; leave demons for re-queue
        ( state::event(Routine, _, demon) ->
            true  % demons stay in queue
        ;
            state::retractall(event(Routine, _, _)),
            state::retractall(event_enabled(Routine))
        ).

    %% ---------------------------------------------------------------
    %% GAME START EVENTS
    %% ZIL: I-START-INTERRUPTS queues all initial events
    %% Called once during initialization (first move after GO).
    %% ---------------------------------------------------------------

    :- public start_interrupts/0.
    start_interrupts :-
        random_between(1, 40, Rnd1),
        queue_and_enable(events::i_newspaper, 175 + Rnd1),
        random_between(1, 60, Rnd2),
        queue_and_enable(events::i_mail, 70 + Rnd2),
        random_between(1, 10, Rnd3),
        queue_and_enable(events::i_call, 60 + Rnd3),
        queue_and_enable(events::i_baxter_arrive, 115),
        random_between(1, 5, Rnd4),
        queue_and_enable(events::i_coates_arrive, 230 + Rnd4).

    %% ---------------------------------------------------------------
    %% CLOCK DISPLAY
    %% ---------------------------------------------------------------

    %% display_time/0 — show the current time (score=hour, moves=minutes)
    :- public display_time/0.
    display_time :-
        state::global_val(score, H),
        state::global_val(moves, M),
        ( H < 12 -> Period = 'AM' ; Period = 'PM' ),
        ( H =:= 0 -> H12 = 12
        ; H > 12 -> H12 is H - 12
        ; H12 = H
        ),
        format("The time is ~w:~`0t~w~2|~w~n", [H12, M, Period]).

:- end_object.
