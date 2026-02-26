%%%  lexer.lgt  %%%
%%%
%%%  Input tokenizer, buzz-word filter, and synonym normalizer.
%%%  Converts raw player input (a string or atom) into a cleaned list
%%%  of canonical word atoms ready for grammar.lgt's DCG rules.
%%%
%%%  ZIL source: syntax.zil (BUZZ words, SYNONYM definitions)
%%%              parser.zil (PARSER routine, P-LEXV handling)
%%%
%%%  Copyright 1982 Infocom, Inc. (original game)
%%%  Logtalk refactoring: see CLAUDE.md

:- object(lexer).

    :- info([
        version is 1:0:0,
        comment is 'Tokenize, filter buzz words, and normalize synonyms from player input.'
    ]).

    %% ---------------------------------------------------------------
    %% PUBLIC API
    %% ---------------------------------------------------------------

    %% tokenize(+InputAtomOrString, -TokenList)
    %% Convert player input to a clean list of canonical word atoms.
    :- public tokenize/2.
    tokenize(Input, Tokens) :-
        ( atom(Input) -> atom_string(Input, S) ; S = Input ),
        string_lower(S, Lower),
        split_string(Lower, " \t\r\n", " \t\r\n", Parts),
        include([P]>>(P \= ""), Parts, NonEmpty),
        maplist([P, W]>>(atom_string(W, P)), NonEmpty, Words),
        maplist(normalize_word, Words, Normalized),
        exclude(buzz_word, Normalized, Tokens).

    %% tokenize_raw(+Input, -Tokens)
    %% Like tokenize/2 but does not filter buzz words.
    :- public tokenize_raw/2.
    tokenize_raw(Input, Tokens) :-
        ( atom(Input) -> atom_string(Input, S) ; S = Input ),
        string_lower(S, Lower),
        split_string(Lower, " \t\r\n", " \t\r\n", Parts),
        include([P]>>(P \= ""), Parts, NonEmpty),
        maplist([P, W]>>(atom_string(W, P)), NonEmpty, Words),
        maplist(normalize_word, Words, Tokens).

    %% ---------------------------------------------------------------
    %% BUZZ WORD FILTER
    %% ZIL: <BUZZ A AN THE IS ARE AND OF THEN ALL ONE BUT EXCEPT ...>
    %% ---------------------------------------------------------------

    :- public buzz_word/1.

    buzz_word(a).
    buzz_word(an).
    buzz_word(the).
    buzz_word(is).
    buzz_word(are).
    buzz_word(and).
    buzz_word(of).
    buzz_word(then).
    buzz_word(all).
    buzz_word(one).
    buzz_word(but).
    buzz_word(except).
    buzz_word(y).
    buzz_word(minute).
    buzz_word(back).
    buzz_word(page).
    buzz_word(carefully).
    buzz_word(quietly).
    buzz_word(slowly).
    buzz_word(quickly).
    buzz_word(briefly).
    buzz_word(do).
    buzz_word(you).
    buzz_word(have).
    buzz_word(was).
    buzz_word(were).
    buzz_word(your).
    buzz_word(some).

    %% ---------------------------------------------------------------
    %% SYNONYM NORMALIZATION
    %% ZIL: <SYNONYM canonical synonym1 synonym2 ...>
    %% All synonyms map to the canonical (first listed) word.
    %% ---------------------------------------------------------------

    :- private normalize_word/2.
    normalize_word(Word, Canonical) :-
        ( synonym_map(Word, Canonical) -> true ; Canonical = Word ).

    %% synonym_map(?Input, ?Canonical) — normalize a word to its canonical form
    :- public synonym_map/2.

    %% ---- Preposition synonyms (syntax.zil) ----
    synonym_map(using,    with).
    synonym_map(through,  with).
    synonym_map(inside,   in).
    synonym_map(into,     in).
    synonym_map(underneath, under).
    synonym_map(beneath,  under).

    %% ---- Direction synonyms ----
    synonym_map(n,         north).
    synonym_map(s,         south).
    synonym_map(e,         east).
    synonym_map(w,         west).
    synonym_map(d,         down).
    synonym_map(downstairs, down).
    synonym_map(u,         up).
    synonym_map(upstairs,  up).
    synonym_map(northwest, northwest).
    synonym_map(northeast, northeast).
    synonym_map(southwest, southwest).
    synonym_map(southeast, southeast).
    synonym_map(nw,        northwest).
    synonym_map(ne,        northeast).
    synonym_map(sw,        southwest).
    synonym_map(se,        southeast).
    synonym_map(southe,    southeast).   % typo in original syntax.zil

    %% ---- Verb synonyms (syntax.zil SYNONYM directives) ----
    synonym_map(analyse,   analyze).
    synonym_map(check,     analyze).
    synonym_map(test,      analyze).
    synonym_map(dust,      analyze).
    synonym_map(reply,     answer).
    synonym_map(question,  ask).
    synonym_map(inquire,   ask).
    synonym_map(fight,     attack).
    synonym_map(hurt,      attack).
    synonym_map(injure,    attack).
    synonym_map(hit,       attack).
    synonym_map(clean,     brush).
    synonym_map(wipe,      brush).
    synonym_map(incinerate, burn).
    synonym_map(ignite,    burn).
    synonym_map(hey,       call).
    synonym_map(dial,      call).
    synonym_map(sit,       climb).
    synonym_map(hatch,     climb).
    synonym_map(ford,      cross).
    synonym_map(slice,     cut).
    synonym_map(pierce,    cut).
    synonym_map(damn,      curse).
    synonym_map(imbibe,    drink).
    synonym_map(swallow,   drink).
    synonym_map(release,   drop).
    synonym_map(consume,   eat).
    synonym_map(describe,  examine).
    synonym_map(douse,     extinguish).
    synonym_map(where,     find).
    synonym_map(there,     find).
    synonym_map(seen,      find).
    synonym_map(pursue,    follow).
    synonym_map(chase,     follow).
    synonym_map(hand,      give).
    synonym_map(donate,    give).
    synonym_map(offer,     give).
    synonym_map(hi,        hello).
    synonym_map(i,         inventory).
    synonym_map(leap,      jump).
    synonym_map(bite,      kick).
    synonym_map(taunt,     kick).
    synonym_map(dispatch,  kill).
    synonym_map(strangle,  kill).
    synonym_map(rap,       knock).
    synonym_map(stand,     lean).
    synonym_map(prop,      lean).
    synonym_map(l,         look).
    synonym_map(stare,     look).
    synonym_map(gaze,      look).
    synonym_map(dig,       search).
    synonym_map(tug,       pull).
    synonym_map(sigh,      mumble).
    synonym_map(damage,    destroy).
    synonym_map(break,     destroy).
    synonym_map(smash,     destroy).
    synonym_map(jab,       poke).
    synonym_map(blind,     poke).
    synonym_map(spill,     pour).
    synonym_map(press,     push).
    synonym_map(stuff,     put).
    synonym_map(insert,    put).
    synonym_map(place,     put).
    synonym_map(lift,      raise).
    synonym_map(molest,    rape).
    synonym_map(skim,      read).
    synonym_map(peal,      ring).
    synonym_map(touch,     rub).
    synonym_map(feel,      rub).
    synonym_map(shade,     rub).
    synonym_map(hop,       skip).
    synonym_map(sniff,     smell).
    synonym_map(thrust,    swing).
    synonym_map(get,       take).
    synonym_map(hold,      take).
    synonym_map(carry,     take).
    synonym_map(remove,    take).
    synonym_map(lead,      take).
    synonym_map(talk,      say).
    synonym_map(fasten,    tie).
    synonym_map(secure,    tie).
    synonym_map(attach,    tie).
    synonym_map(flip,      turn).
    synonym_map(shut,      turn).
    synonym_map(free,      untie).
    synonym_map(unfasten,  untie).
    synonym_map(unattach,  untie).
    synonym_map(unhook,    untie).
    synonym_map(go,        walk).
    synonym_map(run,       walk).
    synonym_map(proceed,   walk).
    synonym_map(brandish,  wave).
    synonym_map(q,         quit).
    synonym_map(t,         time).
    synonym_map(whats,     what).
    synonym_map(who,       what).
    synonym_map(no,        yes).
    synonym_map(maybe,     yes).
    synonym_map(thank,     thanks).
    synonym_map(did,       when).
    synonym_map(why,       when).
    synonym_map(how,       when).
    synonym_map(superbrief, super).
    synonym_map(bathe,     swim).
    synonym_map(wade,      swim).
    synonym_map(hurl,      throw).
    synonym_map(chuck,     throw).
    synonym_map(toss,      throw).

    %% Punctuation / special characters — strip these
    synonym_map('.',  '.').
    synonym_map(',',  ',').
    synonym_map('"',  '"').

    %% ---------------------------------------------------------------
    %% DIRECTION CLASSIFICATION
    %% ---------------------------------------------------------------

    :- public is_direction/1.
    is_direction(north).
    is_direction(south).
    is_direction(east).
    is_direction(west).
    is_direction(northeast).
    is_direction(northwest).
    is_direction(southeast).
    is_direction(southwest).
    is_direction(up).
    is_direction(down).
    is_direction(in).
    is_direction(out).

    %% ---------------------------------------------------------------
    %% PRONOUN RECOGNITION
    %% ---------------------------------------------------------------

    :- public is_pronoun/2.
    is_pronoun(it,  it).
    is_pronoun(him, him_her).
    is_pronoun(her, him_her).
    is_pronoun(them, them).

    %% ---------------------------------------------------------------
    %% NUMBER HANDLING
    %% ---------------------------------------------------------------

    %% parse_number(+Atom, -Number) — parse an atom as a number
    :- public parse_number/2.
    parse_number(Atom, Number) :-
        atom(Atom),
        atom_number(Atom, Number).

:- end_object.
