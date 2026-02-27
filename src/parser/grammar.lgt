%%%  grammar.lgt  %%%
%%%
%%%  DCG grammar rules for parsing player commands.
%%%  Corresponds to ZIL SYNTAX definitions in syntax.zil.
%%%
%%%  The grammar produces command/3 terms of the form:
%%%    cmd(Verb, DirectObject, IndirectObject)
%%%  where IndirectObject may be none, or a pair(Prep, Object).
%%%
%%%  ZIL source: syntax.zil (all SYNTAX directives)
%%%
%%%  Copyright 1982 Infocom, Inc. (original game)
%%%  Logtalk refactoring: see CLAUDE.md

:- object(grammar).

    :- info([
        version is 1:0:0,
        comment is 'DCG grammar: parses token lists into cmd/3 structures.'
    ]).

    %% ---------------------------------------------------------------
    %% PUBLIC API
    %% ---------------------------------------------------------------

    %% parse(+Tokens, -Command)
    %% Parse a token list into a cmd/3 structure.
    :- public(parse/2).
    parse(Tokens, Command) :-
        phrase(command(Command), Tokens).

    %% ---------------------------------------------------------------
    %% TOP-LEVEL GRAMMAR
    %% ---------------------------------------------------------------

    :- private(command//1).
    :- use_module(library(dcg/basics), []).

    command(cmd(v_walk, Dir, none)) -->
        [Dir], { lexer::is_direction(Dir) }.

    command(cmd(v_walk, Dir, none)) -->
        [walk], [Dir], { lexer::is_direction(Dir) }.

    command(cmd(v_walk, Dir, none)) -->
        [go], [Dir], { lexer::is_direction(Dir) }.

    command(Cmd) --> verb_command(Cmd).

    %% ---------------------------------------------------------------
    %% SYSTEM / META COMMANDS
    %% ZIL: BRIEF, SUPER, VERBOSE, INVENTORY, QUIT, SAVE, etc.
    %% ---------------------------------------------------------------

    :- private(verb_command//1).

    verb_command(cmd(v_brief,    none, none)) --> [brief].
    verb_command(cmd(v_super,    none, none)) --> [super].
    verb_command(cmd(v_verbose,  none, none)) --> [verbose].
    verb_command(cmd(v_inventory,none, none)) --> [inventory].
    verb_command(cmd(v_time,     none, none)) --> [time].
    verb_command(cmd(v_quit,     none, none)) --> [quit].
    verb_command(cmd(v_restart,  none, none)) --> [restart].
    verb_command(cmd(v_restore,  none, none)) --> [restore].
    verb_command(cmd(v_save,     none, none)) --> [save].
    verb_command(cmd(v_score,    none, none)) --> [score].
    verb_command(cmd(v_version,  none, none)) --> [version].
    verb_command(cmd(v_diagnose, none, none)) --> [diagnose].
    verb_command(cmd(v_script,   none, none)) --> [script].
    verb_command(cmd(v_unscript, none, none)) --> [unscript].
    verb_command(cmd(v_again,    none, none)) --> [again].
    verb_command(cmd(v_again,    none, none)) --> [g].
    verb_command(cmd(v_bug,      none, none)) --> [bug].
    verb_command(cmd(v_wait,     none, none)) --> [wait].
    verb_command(cmd(v_space,    none, none)) --> [space].
    verb_command(cmd(v_skip,     none, none)) --> [skip].

    %% ---------------------------------------------------------------
    %% LOOK / EXAMINE
    %% ZIL: LOOK, EXAMINE, LOOK IN, LOOK AT, LOOK UNDER, etc.
    %% ---------------------------------------------------------------

    verb_command(cmd(v_look, none, none)) --> [look].
    verb_command(cmd(v_look, none, none)) --> [look], [around].
    verb_command(cmd(v_examine, DO, none)) --> [examine], noun_phrase(DO).
    verb_command(cmd(v_examine, DO, none)) --> [look], [at], noun_phrase(DO).
    verb_command(cmd(v_examine, DO, none)) --> [look], [over], noun_phrase(DO).
    verb_command(cmd(v_examine, DO, none)) --> [watch], noun_phrase(DO).
    verb_command(cmd(v_look_inside, DO, none)) --> [look], [in], noun_phrase(DO).
    verb_command(cmd(v_look_inside, DO, none)) --> [look], [inside], noun_phrase(DO).
    verb_command(cmd(v_look_inside, DO, none)) --> [look], [through], noun_phrase(DO).
    verb_command(cmd(v_look_inside, DO, none)) --> [look], [with], noun_phrase(DO).
    verb_command(cmd(v_look_inside, DO, none)) --> [look], [out], noun_phrase(DO).
    verb_command(cmd(v_look_inside, DO, none)) --> [peek], [in], noun_phrase(DO).
    verb_command(cmd(v_look_inside, DO, none)) --> [what], [in], noun_phrase(DO).
    verb_command(cmd(v_look_inside, DO, none)) --> [what], [on], noun_phrase(DO).
    verb_command(cmd(v_look_on, DO, none))     --> [look], [on], noun_phrase(DO).
    verb_command(cmd(v_look_under, DO, none))  --> [look], [under], noun_phrase(DO).
    verb_command(cmd(v_look_behind, DO, none)) --> [look], [behind], noun_phrase(DO).
    verb_command(cmd(v_look_up, DO, none))     --> [look], [up], noun_phrase(DO).
    verb_command(cmd(v_look_down, DO, none))   --> [look], [down], noun_phrase(DO).

    %% ---------------------------------------------------------------
    %% TAKE / DROP / PUT
    %% ---------------------------------------------------------------

    verb_command(cmd(v_take, DO, none)) --> [take], noun_phrase(DO).
    verb_command(cmd(v_take, DO, none)) --> [pick], [up], noun_phrase(DO).
    verb_command(cmd(v_take, DO, none)) --> [raise], noun_phrase(DO).
    verb_command(cmd(v_take, DO, none)) --> [raise], [up], noun_phrase(DO).
    verb_command(cmd(v_take, DO, pair(from, IO))) --> [take], noun_phrase(DO), [from], noun_phrase(IO).
    verb_command(cmd(v_take, DO, pair(out_of, IO))) --> [take], noun_phrase(DO), [out], noun_phrase(IO).
    verb_command(cmd(v_take, DO, pair(off_of, IO))) --> [take], noun_phrase(DO), [off], noun_phrase(IO).
    %% HOLD UP: "hold pad up to light" → V-HOLD-UP
    verb_command(cmd(v_hold_up, DO, pair(to, IO))) --> [hold], noun_phrase(DO), [up], [to], noun_phrase(IO).
    verb_command(cmd(v_hold_up, DO, pair(to, IO))) --> [hold], [up], noun_phrase(DO), [to], noun_phrase(IO).

    verb_command(cmd(v_drop, DO, none)) --> [drop], noun_phrase(DO).
    verb_command(cmd(v_drop, DO, none)) --> [leave], noun_phrase(DO).
    verb_command(cmd(v_drop, DO, none)) --> [put], [down], noun_phrase(DO).
    verb_command(cmd(v_drop, DO, none)) --> [pour], noun_phrase(DO).

    verb_command(cmd(v_put, DO, pair(in, IO)))      --> [put], noun_phrase(DO), [in], noun_phrase(IO).
    verb_command(cmd(v_put, DO, pair(in, IO)))      --> [insert], noun_phrase(DO), [in], noun_phrase(IO).
    verb_command(cmd(v_put, DO, pair(in, IO)))      --> [throw], noun_phrase(DO), [in], noun_phrase(IO).
    verb_command(cmd(v_put, DO, pair(on, IO)))      --> [put], noun_phrase(DO), [on], noun_phrase(IO).
    verb_command(cmd(v_put, DO, pair(on, IO)))      --> [throw], noun_phrase(DO), [on], noun_phrase(IO).
    verb_command(cmd(v_put, DO, pair(on, IO)))      --> [squeeze], noun_phrase(DO), [on], noun_phrase(IO).
    verb_command(cmd(v_put, DO, pair(apply_to, IO)))--> [apply], noun_phrase(DO), [to], noun_phrase(IO).
    verb_command(cmd(v_put_under, DO, pair(under, IO))) --> [put], noun_phrase(DO), [under], noun_phrase(IO).
    verb_command(cmd(v_put_under, DO, pair(under, IO))) --> [push], noun_phrase(DO), [under], noun_phrase(IO).
    verb_command(cmd(v_put_under, DO, pair(under, IO))) --> [slide], noun_phrase(DO), [under], noun_phrase(IO).
    verb_command(cmd(v_pour_on, DO, pair(on, IO)))  --> [pour], noun_phrase(DO), [on], noun_phrase(IO).

    %% ---------------------------------------------------------------
    %% OPEN / CLOSE / LOCK / UNLOCK
    %% ---------------------------------------------------------------

    verb_command(cmd(v_open, DO, none))         --> [open], noun_phrase(DO).
    verb_command(cmd(v_open, DO, none))         --> [open], [up], noun_phrase(DO).
    verb_command(cmd(v_open, DO, pair(with, IO))) --> [open], noun_phrase(DO), [with], noun_phrase(IO).
    verb_command(cmd(v_close, DO, none))        --> [close], noun_phrase(DO).
    verb_command(cmd(v_lock, DO, pair(with, IO))) --> [lock], noun_phrase(DO), [with], noun_phrase(IO).
    verb_command(cmd(v_unlock, DO, none))       --> [unlock], noun_phrase(DO).
    verb_command(cmd(v_unlock, DO, pair(with, IO))) --> [unlock], noun_phrase(DO), [with], noun_phrase(IO).

    %% ---------------------------------------------------------------
    %% MOVEMENT / ENTER / EXIT
    %% ---------------------------------------------------------------

    verb_command(cmd(v_enter, none, none)) --> [enter].
    verb_command(cmd(v_enter, DO, none))   --> [enter], noun_phrase(DO).
    verb_command(cmd(v_exit,  none, none)) --> [exit].
    verb_command(cmd(v_exit,  DO, none))   --> [exit], noun_phrase(DO).
    verb_command(cmd(v_exit,  none, none)) --> [leave].
    verb_command(cmd(v_through, DO, none)) --> [walk], [to], noun_phrase(DO).
    verb_command(cmd(v_through, DO, none)) --> [walk], [in], noun_phrase(DO).
    verb_command(cmd(v_through, DO, none)) --> [walk], [with], noun_phrase(DO).
    verb_command(cmd(v_through, DO, none)) --> [go], [through], noun_phrase(DO).
    verb_command(cmd(v_walk_around, DO, none)) --> [walk], [around], noun_phrase(DO).

    %% ---------------------------------------------------------------
    %% READ
    %% ---------------------------------------------------------------

    verb_command(cmd(v_read, DO, pair(page, intnum(N)))) --> [read], noun_phrase(DO), number_token(N).
    verb_command(cmd(v_read, DO, none))           --> [read], noun_phrase(DO).
    verb_command(cmd(v_read, DO, pair(with, IO))) --> [read], noun_phrase(DO), [with], noun_phrase(IO).
    verb_command(cmd(v_read, DO, pair(with, IO))) --> [look], [at], noun_phrase(DO), [with], noun_phrase(IO).

    %% ---------------------------------------------------------------
    %% ACCUSE / ARREST / CONFRONT
    %% ZIL: <SYNTAX ACCUSE OBJECT (FIND PERSON) WITH OBJECT = V-ACCUSE PRE-ACCUSE>
    %% ---------------------------------------------------------------

    verb_command(cmd(v_accuse, Person, pair(with, Evidence))) -->
        [accuse], noun_phrase(Person), [with], noun_phrase(Evidence).
    verb_command(cmd(v_accuse, Person, none)) -->
        [accuse], noun_phrase(Person).
    verb_command(cmd(v_arrest, Person, none)) -->
        [arrest], noun_phrase(Person).
    verb_command(cmd(v_arrest, Person, pair(for, Evidence))) -->
        [arrest], noun_phrase(Person), [for], noun_phrase(Evidence).
    verb_command(cmd(v_confront, Person, pair(with, Evidence))) -->
        [confront], noun_phrase(Person), [with], noun_phrase(Evidence).

    %% ---------------------------------------------------------------
    %% ASK / TELL / DIALOGUE
    %% ---------------------------------------------------------------

    verb_command(cmd(v_ask_about, Person, pair(about, Topic))) -->
        [ask], noun_phrase(Person), [about], noun_phrase(Topic).
    verb_command(cmd(v_ask_for, Person, pair(for, Item))) -->
        [ask], noun_phrase(Person), [for], noun_phrase(Item).
    verb_command(cmd(v_tell, Person, none)) -->
        [ask], noun_phrase(Person).
    verb_command(cmd(v_tell, Person, none)) -->
        [tell], noun_phrase(Person).
    verb_command(cmd(v_tell_me, Person, pair(about, Topic))) -->
        [tell], noun_phrase(Person), [about], noun_phrase(Topic).
    verb_command(cmd(v_tell, Person, none)) -->
        [say], [to], noun_phrase(Person).
    verb_command(cmd(v_say, none, none)) --> [say].
    verb_command(cmd(v_hello, none, none)) --> [hello].
    verb_command(cmd(v_hello, DO, none))   --> [hello], noun_phrase(DO).
    verb_command(cmd(v_goodbye, none, none)) --> [goodbye].
    verb_command(cmd(v_goodbye, DO, none))   --> [goodbye], noun_phrase(DO).
    verb_command(cmd(v_reply, none, none)) --> [answer].
    verb_command(cmd(v_reply, DO, none))   --> [answer], noun_phrase(DO).

    %% ---------------------------------------------------------------
    %% GIVE / SHOW
    %% ---------------------------------------------------------------

    verb_command(cmd(v_give, Item, pair(to, Person))) -->
        [give], noun_phrase(Item), [to], noun_phrase(Person).
    verb_command(cmd(v_give, Item, pair(to, Person))) -->
        [hand], noun_phrase(Item), [to], noun_phrase(Person).
    verb_command(cmd(v_show, Item, pair(to, Person))) -->
        [show], noun_phrase(Item), [to], noun_phrase(Person).
    verb_command(cmd(v_show, Item, pair(to, Person))) -->
        [show], noun_phrase(Item), noun_phrase(Person).

    %% ---------------------------------------------------------------
    %% SEARCH / ANALYZE / FINGERPRINT
    %% ---------------------------------------------------------------

    verb_command(cmd(v_search, DO, none)) --> [search], noun_phrase(DO).
    verb_command(cmd(v_search, DO, none)) --> [search], [in], noun_phrase(DO).
    verb_command(cmd(v_search, DO, none)) --> [search], [up], noun_phrase(DO).
    verb_command(cmd(v_search_around, DO, none)) --> [search], [around], noun_phrase(DO).
    verb_command(cmd(v_search_around, DO, none)) --> [search], [near], noun_phrase(DO).
    verb_command(cmd(v_search_around, DO, none)) --> [look], [near], noun_phrase(DO).
    verb_command(cmd(v_find, DO, none))   --> [find], noun_phrase(DO).
    verb_command(cmd(v_find, DO, none))   --> [search], [for], noun_phrase(DO).
    verb_command(cmd(v_find, DO, none))   --> [look], [for], noun_phrase(DO).
    verb_command(cmd(v_analyze, DO, none)) --> [analyze], noun_phrase(DO).
    verb_command(cmd(v_analyze, DO, pair(for, IO))) --> [analyze], noun_phrase(DO), [for], noun_phrase(IO).
    verb_command(cmd(v_fingerprint, DO, none)) --> [fingerprint], noun_phrase(DO).
    verb_command(cmd(v_what, DO, none)) --> [what], noun_phrase(DO).
    verb_command(cmd(v_what, DO, none)) --> [what], [about], noun_phrase(DO).
    verb_command(cmd(v_know, DO, none)) --> [know], [about], noun_phrase(DO).

    %% ---------------------------------------------------------------
    %% ATTACK / KILL / FIGHT
    %% ---------------------------------------------------------------

    verb_command(cmd(v_attack, Person, none)) --> [attack], noun_phrase(Person).
    verb_command(cmd(v_attack, Person, pair(with, Weapon))) -->
        [attack], noun_phrase(Person), [with], noun_phrase(Weapon).
    verb_command(cmd(v_attack, Person, pair(with, Weapon))) -->
        [strike], noun_phrase(Person), [with], noun_phrase(Weapon).
    verb_command(cmd(v_attack, Person, none)) --> [strike], noun_phrase(Person).
    verb_command(cmd(v_attack, Person, none)) --> [knock], [down], noun_phrase(Person).
    verb_command(cmd(v_kill, Person, none))   --> [kill], noun_phrase(Person).
    verb_command(cmd(v_kill, Person, pair(with, Weapon))) -->
        [kill], noun_phrase(Person), [with], noun_phrase(Weapon).

    %% ---------------------------------------------------------------
    %% PUSH / PULL / MOVE
    %% ---------------------------------------------------------------

    verb_command(cmd(v_push, DO, none)) --> [push], noun_phrase(DO).
    verb_command(cmd(v_push, DO, none)) --> [push], [on], noun_phrase(DO).
    verb_command(cmd(v_pull, DO, none)) --> [pull], noun_phrase(DO).
    verb_command(cmd(v_pull, DO, none)) --> [pull], [on], noun_phrase(DO).
    verb_command(cmd(v_move, DO, none)) --> [move], noun_phrase(DO).

    %% ---------------------------------------------------------------
    %% LAMP ON / LAMP OFF (LIGHT / EXTINGUISH / TURN ON / TURN OFF)
    %% ---------------------------------------------------------------

    verb_command(cmd(v_lamp_on,  DO, none)) --> [light], noun_phrase(DO).
    verb_command(cmd(v_lamp_on,  DO, none)) --> [turn], [on], noun_phrase(DO).
    verb_command(cmd(v_lamp_on,  DO, none)) --> [strike], noun_phrase(DO).
    verb_command(cmd(v_lamp_off, DO, none)) --> [extinguish], noun_phrase(DO).
    verb_command(cmd(v_lamp_off, DO, none)) --> [turn], [off], noun_phrase(DO).
    verb_command(cmd(v_lamp_off, DO, none)) --> [blow], [out], noun_phrase(DO).
    verb_command(cmd(v_burn, DO, pair(with, IO))) -->
        [burn], noun_phrase(DO), [with], noun_phrase(IO).
    verb_command(cmd(v_burn, DO, pair(with, IO))) -->
        [light], noun_phrase(DO), [with], noun_phrase(IO).

    %% ---------------------------------------------------------------
    %% TURN (switch / rotate objects)
    %% ---------------------------------------------------------------

    verb_command(cmd(v_turn, DO, pair(to, intnum(N)))) --> [turn], noun_phrase(DO), [to], number_token(N).
    verb_command(cmd(v_turn, none, pair(to, intnum(N)))) --> [turn], [to], number_token(N).
    verb_command(cmd(v_turn, DO, pair(to, IO))) --> [turn], noun_phrase(DO), [to], noun_phrase(IO).
    verb_command(cmd(v_turn, none, pair(to, IO))) --> [turn], [to], noun_phrase(IO).
    verb_command(cmd(v_turn, DO, none))         --> [turn], noun_phrase(DO).
    verb_command(cmd(v_turn, DO, none))         --> [turn], [in], noun_phrase(DO).
    verb_command(cmd(v_turn_up, DO, none))      --> [turn], [up], noun_phrase(DO).
    verb_command(cmd(v_turn_down, DO, none))    --> [turn], [down], noun_phrase(DO).

    %% ---------------------------------------------------------------
    %% CLIMB
    %% ---------------------------------------------------------------

    verb_command(cmd(v_climb_up,   DO, none)) --> [climb], [up], noun_phrase(DO).
    verb_command(cmd(v_climb_down, DO, none)) --> [climb], [down], noun_phrase(DO).
    verb_command(cmd(v_climb_up,   DO, none)) --> [walk], [up], noun_phrase(DO).
    verb_command(cmd(v_climb_down, DO, none)) --> [walk], [down], noun_phrase(DO).
    verb_command(cmd(v_climb_on,   DO, none)) --> [climb], [on], noun_phrase(DO).

    %% ---------------------------------------------------------------
    %% WAIT
    %% ---------------------------------------------------------------

    verb_command(cmd(v_wait, none, none)) --> [wait].
    verb_command(cmd(v_wait_for, DO, none))    --> [wait], [for], noun_phrase(DO).
    verb_command(cmd(v_wait_until, DO, none))  --> [wait], [until], noun_phrase(DO).
    verb_command(cmd(v_wait_for, DO, none))    --> [wait], noun_phrase(DO).

    %% ---------------------------------------------------------------
    %% MISC VERBS
    %% ---------------------------------------------------------------

    verb_command(cmd(v_eat, DO, none))       --> [eat], noun_phrase(DO).
    verb_command(cmd(v_drink, DO, none))     --> [drink], noun_phrase(DO).
    verb_command(cmd(v_taste, DO, none))     --> [taste], noun_phrase(DO).
    verb_command(cmd(v_smell, DO, none))     --> [smell], noun_phrase(DO).
    verb_command(cmd(v_listen, DO, none))    --> [listen], [to], noun_phrase(DO).
    verb_command(cmd(v_listen, DO, none))    --> [listen], [at], noun_phrase(DO).
    verb_command(cmd(v_rub, DO, none))       --> [rub], noun_phrase(DO).
    verb_command(cmd(v_rub, DO, pair(with, IO))) --> [rub], noun_phrase(DO), [with], noun_phrase(IO).
    verb_command(cmd(v_rub, DO, pair(with, IO))) --> [shade], noun_phrase(DO), [with], noun_phrase(IO).
    verb_command(cmd(v_rub_over, DO, pair(over, IO))) --> [rub], noun_phrase(DO), [over], noun_phrase(IO).
    verb_command(cmd(v_rub_over, DO, pair(on, IO)))   --> [rub], noun_phrase(DO), [on], noun_phrase(IO).
    %% RUN-OVER: "run pencil over pad" → V-RUN-OVER
    verb_command(cmd(v_run_over, DO, pair(over, IO))) --> [run], noun_phrase(DO), [over], noun_phrase(IO).
    verb_command(cmd(v_run_over, DO, pair(on, IO)))   --> [run], noun_phrase(DO), [on], noun_phrase(IO).
    verb_command(cmd(v_shake, DO, none))     --> [shake], noun_phrase(DO).
    verb_command(cmd(v_squeeze, DO, none))   --> [squeeze], noun_phrase(DO).
    verb_command(cmd(v_wave, DO, none))      --> [wave], noun_phrase(DO).
    verb_command(cmd(v_wave, DO, pair(at, IO))) --> [wave], noun_phrase(DO), [at], noun_phrase(IO).
    verb_command(cmd(v_throw_at, DO, pair(at, IO))) --> [throw], noun_phrase(DO), [at], noun_phrase(IO).
    verb_command(cmd(v_throw_through, DO, pair(with, IO))) --> [throw], noun_phrase(DO), [with], noun_phrase(IO).
    verb_command(cmd(v_tie, DO, pair(to, IO))) --> [tie], noun_phrase(DO), [to], noun_phrase(IO).
    verb_command(cmd(v_untie, DO, none))     --> [untie], noun_phrase(DO).
    verb_command(cmd(v_untie, DO, pair(from, IO))) --> [untie], noun_phrase(DO), [from], noun_phrase(IO).
    verb_command(cmd(v_cut, DO, pair(with, IO))) --> [cut], noun_phrase(DO), [with], noun_phrase(IO).
    verb_command(cmd(v_pick, DO, none))      --> [pick], noun_phrase(DO).
    verb_command(cmd(v_pick, DO, pair(with, IO))) --> [pick], noun_phrase(DO), [with], noun_phrase(IO).
    verb_command(cmd(v_ring, DO, none))      --> [ring], noun_phrase(DO).
    verb_command(cmd(v_ring, DO, pair(with, IO))) --> [ring], noun_phrase(DO), [with], noun_phrase(IO).
    verb_command(cmd(v_lower, DO, none))     --> [lower], noun_phrase(DO).
    verb_command(cmd(v_raise, DO, none))     --> [raise], noun_phrase(DO).
    verb_command(cmd(v_kick, DO, none))      --> [kick], noun_phrase(DO).
    verb_command(cmd(v_kiss, DO, none))      --> [kiss], noun_phrase(DO).
    verb_command(cmd(v_knock, DO, none))     --> [knock], [on], noun_phrase(DO).
    verb_command(cmd(v_knock, DO, none))     --> [knock], [at], noun_phrase(DO).
    verb_command(cmd(v_count, DO, none))     --> [count], noun_phrase(DO).
    verb_command(cmd(v_count, none, none))   --> [count].
    verb_command(cmd(v_cross, DO, none))     --> [cross], noun_phrase(DO).
    verb_command(cmd(v_fill, DO, pair(with, IO))) --> [fill], noun_phrase(DO), [with], noun_phrase(IO).
    verb_command(cmd(v_fill, DO, none))      --> [fill], noun_phrase(DO).
    verb_command(cmd(v_flush, DO, none))     --> [flush], noun_phrase(DO).
    verb_command(cmd(v_follow, DO, none))    --> [follow], noun_phrase(DO).
    verb_command(cmd(v_play, DO, none))      --> [play], noun_phrase(DO).
    verb_command(cmd(v_lean, DO, pair(against, IO))) --> [lean], noun_phrase(DO), [against], noun_phrase(IO).
    verb_command(cmd(v_lean, DO, pair(on, IO))) --> [lean], noun_phrase(DO), [on], noun_phrase(IO).
    verb_command(cmd(v_lean, none, none))    --> [lean].
    verb_command(cmd(v_hide, none, none))    --> [hide].
    verb_command(cmd(v_hide_behind, DO, none)) --> [hide], [behind], noun_phrase(DO).
    verb_command(cmd(v_hide_behind, DO, none)) --> [walk], [behind], noun_phrase(DO).
    verb_command(cmd(v_swim, none, none))    --> [swim].
    verb_command(cmd(v_swim, DO, none))      --> [swim], [in], noun_phrase(DO).
    verb_command(cmd(v_jump, none, none))    --> [jump].
    verb_command(cmd(v_jump, DO, none))      --> [jump], [over], noun_phrase(DO).
    verb_command(cmd(v_jump, DO, none))      --> [jump], [across], noun_phrase(DO).
    verb_command(cmd(v_jump, DO, none))      --> [jump], [in], noun_phrase(DO).
    verb_command(cmd(v_mumble, none, none))  --> [mumble].
    verb_command(cmd(v_mung, DO, pair(with, IO))) --> [destroy], noun_phrase(DO), [with], noun_phrase(IO).
    verb_command(cmd(v_mung, DO, pair(with, IO))) --> [poke], noun_phrase(DO), [with], noun_phrase(IO).
    verb_command(cmd(v_use, DO, none))       --> [use], noun_phrase(DO).
    verb_command(cmd(v_swing, DO, none))     --> [swing], noun_phrase(DO).
    verb_command(cmd(v_swing, DO, pair(at, IO))) --> [swing], noun_phrase(DO), [at], noun_phrase(IO).
    verb_command(cmd(v_send_for, DO, none))  --> [send], [for], noun_phrase(DO).
    verb_command(cmd(v_call, none, none))    --> [call].
    verb_command(cmd(v_call, DO, none))      --> [call], noun_phrase(DO).
    verb_command(cmd(v_phone, DO, none))     --> [call], [up], noun_phrase(DO).
    verb_command(cmd(v_write, none, pair(with, IO))) --> [write], [with], noun_phrase(IO).
    verb_command(cmd(v_write, DO, pair(with, IO)))   --> [write], [on], noun_phrase(DO), [with], noun_phrase(IO).
    verb_command(cmd(v_wake, DO, none))      --> [wake], noun_phrase(DO).
    verb_command(cmd(v_wake, DO, none))      --> [wake], [up], noun_phrase(DO).
    verb_command(cmd(v_thank, none, none))   --> [thanks].
    verb_command(cmd(v_thank, DO, none))     --> [thanks], noun_phrase(DO).
    verb_command(cmd(v_yn, none, none))      --> [yes].
    verb_command(cmd(v_climb_foo, DO, none)) --> [climb], noun_phrase(DO).

    %% ---------------------------------------------------------------
    %% NOUN PHRASE PARSING
    %% ---------------------------------------------------------------

    %% ---------------------------------------------------------------
    %% NUMBER TOKEN (for page numbers, times, etc.)
    %% ZIL: INTNUM token type, parsed into P-NUMBER global
    %% ---------------------------------------------------------------

    :- private(number_token//1).
    :- uses(user, [atom_number/2]).
    number_token(N) --> [Atom], { atom(Atom), atom_number(Atom, N), integer(N) }.

    %% ---------------------------------------------------------------
    %% NOUN PHRASE PARSING
    %% ---------------------------------------------------------------

    :- private(noun_phrase//1).

    %% Pronoun
    noun_phrase(pronoun(Type)) -->
        [Word], { lexer::is_pronoun(Word, Type) }.

    %% Single word (most common case)
    noun_phrase(np(Words)) -->
        noun_words(Words), { Words \= [] }.

    %% Collect consecutive non-preposition, non-verb words as a noun phrase
    :- private(noun_words//1).
    noun_words([W|Rest]) -->
        [W],
        { \+ stop_word(W) },
        noun_words(Rest).
    noun_words([]) --> [].

    %% Words that terminate a noun phrase
    :- private(stop_word/1).
    stop_word(with).
    stop_word(to).
    stop_word(in).
    stop_word(on).
    stop_word(at).
    stop_word(for).
    stop_word(from).
    stop_word(about).
    stop_word(under).
    stop_word(behind).
    stop_word(against).
    stop_word(over).
    stop_word(across).
    stop_word(out).
    stop_word(off).
    stop_word(up).
    stop_word(down).
    stop_word(near).
    stop_word(then).

:- end_object.
