%%%  loader.lgt  %%%
%%%
%%%  Master loader for Deadline Logtalk/Prolog refactoring.
%%%  Loads all source files in dependency order.
%%%
%%%  ZIL source: deadline.zil (IFILE chain)
%%%
%%%  Usage:
%%%    ?- logtalk_load('src/loader.lgt').
%%%    ?- go.
%%%
%%%  Copyright 1982 Infocom, Inc. (original game)
%%%  Logtalk refactoring: see CLAUDE.md

:- initialization((
    %% Enable Logtalk portability flags
    set_logtalk_flag(unknown_entities, silent),

    %% ---- Core Layer ----
    logtalk_load('src/core/flags', []),
    logtalk_load('src/core/state', []),
    logtalk_load('src/core/entity_class', []),
    logtalk_load('src/core/categories', []),
    logtalk_load('src/core/utils', []),

    %% ---- World Layer ----
    logtalk_load('src/world/rooms', []),
    logtalk_load('src/world/objects', []),
    logtalk_load('src/world/npcs', []),
    logtalk_load('src/world/globals_init', []),

    %% ---- Parser Layer ----
    logtalk_load('src/parser/lexer', []),
    logtalk_load('src/parser/grammar', []),
    logtalk_load('src/parser/resolver', []),

    %% ---- Engine Layer ----
    logtalk_load('src/engine/clock', []),
    logtalk_load('src/engine/npc_ai', []),
    logtalk_load('src/engine/game_loop', []),
    logtalk_load('src/engine/verbs', []),
    logtalk_load('src/engine/actions', []),
    logtalk_load('src/engine/events', []),

    %% ---- Entry Point ----
    logtalk_load('src/deadline', [])
)).
