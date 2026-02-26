%%%  deadline.lgt  %%%
%%%
%%%  Entry point for the Deadline game.
%%%  Provides the top-level go/0 predicate that starts the game.
%%%
%%%  ZIL source: main.zil (GO routine)
%%%
%%%  Usage:
%%%    ?- logtalk_load('src/loader.lgt').
%%%    ?- go.
%%%
%%%  Copyright 1982 Infocom, Inc. (original game)
%%%  Logtalk refactoring: see CLAUDE.md

:- object(deadline).

    :- info([
        version is 1:0:0,
        comment is 'Deadline game entry point. Call go/0 to start.'
    ]).

    :- public go/0.
    go :-
        game_loop::go.

:- end_object.

%% Top-level convenience predicate — call from the Prolog prompt.
:- initialization((
    assertz((go :- deadline::go))
)).
