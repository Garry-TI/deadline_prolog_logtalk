%%%  events.lgt  %%%
%%%
%%%  Event dispatch object — routes timed events from the clock to
%%%  their actual handler routines in actions.lgt and npc_ai.lgt.
%%%
%%%  ZIL source: main.zil (I-START-INTERRUPTS references)
%%%              actions.zil (I-NEWSPAPER, I-MAIL, I-CALL, etc.)
%%%
%%%  Copyright 1982 Infocom, Inc. (original game)
%%%  Logtalk refactoring: see CLAUDE.md

:- object(events).

    :- info([
        version is 1:0:0,
        comment is 'Event dispatch: routes clock events to action/NPC handlers.'
    ]).

    %% ---------------------------------------------------------------
    %% TIMED EVENTS — routed from clock queue
    %% ---------------------------------------------------------------

    :- public i_newspaper/0.
    i_newspaper :- actions::i_newspaper.

    :- public i_mail/0.
    i_mail :- actions::i_mail.

    :- public i_call/0.
    i_call :- actions::i_call.

    :- public i_baxter_arrive/0.
    i_baxter_arrive :- npc_ai::i_baxter_arrive.

    :- public i_coates_arrive/0.
    i_coates_arrive :- npc_ai::i_coates_arrive.

:- end_object.
