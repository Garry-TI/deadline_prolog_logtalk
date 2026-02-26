# CLAUDE.md — Deadline: ZIL → Logtalk/Prolog Refactoring

## Project Overview

This project refactors **Deadline** (Infocom, 1982) from ZIL (Zork Implementation Language)
into idiomatic **Logtalk 3.97.1 + SWI-Prolog 10.0.1**.

**Deadline** is a detective interactive-fiction game set at the Robner estate. The player
has 1200 turns (~20 hours) to investigate a murder before Chief Inspector Klutz arrives
and ends the investigation.

**Original source**: 10 ZIL files, ~12,000 lines
**Refactored target**: `src/` directory, 20 Logtalk `.lgt` files

---

## Environment

| Tool | Location |
|---|---|
| SWI-Prolog 10.0.1 | `D:/Program Files/swipl/bin/swipl.exe` |
| Logtalk 3.97.1 | `D:/Program Files (x86)/Logtalk/` |
| Integration script | `D:/Program Files (x86)/Logtalk/integration/swilgt.ps1` |
| LOGTALKUSER | `D:/logtalk/` |

### Running the Game

```powershell
# From project root:
.\run.ps1

# Or directly:
& "D:\Program Files (x86)\Logtalk\integration\swilgt.ps1"
# Then at the ?- prompt:
?- logtalk_load('src/loader.lgt'), go.
```

### Testing a Single File

```powershell
& "D:\Program Files (x86)\Logtalk\integration\swilgt.ps1"
?- logtalk_load('src/loader.lgt').
?- south_lawn::desc(D), write(D).
?- location(player, R), write(R).
```

---

## Source File Map

| Logtalk File | ZIL Source | Purpose |
|---|---|---|
| `src/loader.lgt` | `deadline.zil` | Master loader |
| `src/deadline.lgt` | `main.zil` (GO) | Entry point, `go/0` |
| `src/core/flags.lgt` | `dungeon.zil` | Flag atom constants |
| `src/core/state.lgt` | All files | Dynamic predicate declarations |
| `src/core/entity_class.lgt` | `dungeon.zil` | Abstract `room` and `entity` classes |
| `src/core/categories.lgt` | `dungeon.zil` flags | Shared behavior categories |
| `src/core/utils.lgt` | `macros.zil` | Utility predicates |
| `src/world/rooms.lgt` | `dungeon.zil` ROOM blocks | 30 room prototypes |
| `src/world/objects.lgt` | `dungeon.zil` OBJECT blocks | 254 object prototypes |
| `src/world/npcs.lgt` | `dungeon.zil` PERSON objects | 20 NPC prototypes |
| `src/world/globals_init.lgt` | `dungeon.zil` | Initial state facts |
| `src/parser/lexer.lgt` | `parser.zil` | Tokenizer, buzz-word filter |
| `src/parser/grammar.lgt` | `syntax.zil` | DCG grammar rules (100+ verbs) |
| `src/parser/resolver.lgt` | `parser.zil`, `crufty.zil` | Object disambiguation |
| `src/engine/clock.lgt` | `clock.zil` | Timed event queue |
| `src/engine/npc_ai.lgt` | `goal.zil` | NPC pathfinding |
| `src/engine/game_loop.lgt` | `main.zil` | Main loop, action dispatch |
| `src/engine/verbs.lgt` | `verbs.zil` | 193 verb implementations |
| `src/engine/actions.lgt` | `actions.zil` | 198 room/object action handlers |

---

## ZIL → Logtalk/Prolog Mapping Reference

| ZIL Construct | Logtalk/Prolog Equivalent |
|---|---|
| `<ROOM name (props)>` | `:- object(name, extends(room)).` prototype |
| `<OBJECT name (props)>` | `:- object(name, extends(entity)).` prototype |
| `<ROUTINE name (...) body>` | Logtalk method or Prolog predicate |
| `<GLOBAL name val>` | `global_val(name, val)` dynamic fact |
| `<SETG name val>` | `set_global(name, val)` (retract old, assert new) |
| `<FSET obj flag>` | `assertz(has_flag(obj, flag))` |
| `<FCLEAR obj flag>` | `retract(has_flag(obj, flag))` |
| `<FSET? obj flag>` | `has_flag(obj, flag)` succeeds/fails |
| `<MOVE obj dest>` | `move_entity(obj, dest)` |
| `<REMOVE obj>` | `retract(location(obj, _))` |
| `<LOC obj>` | `location(obj, Loc)` |
| `<IN? obj loc>` | `location(obj, loc)` |
| `<FIRST? container>` | `location(Child, container)` with `Child \= player` |
| `<COND (p1 a1) ...>` | Multi-clause predicate or `( p1 -> a1 ; p2 -> a2 ; ... )` |
| `<VERB? v1 v2 ...>` | `current_verb(V), memberchk(V, [v1,v2,...])` |
| `<TELL "text" CR>` | `writeln('text')` or `format("text~n")` |
| `<QUEUE rtn delay>` | `queue_event(rtn, delay)` |
| `<ENABLE int>` | `enable_event(int)` |
| `<DISABLE int>` | `disable_event(int)` |
| `<RTRUE>` | predicate succeeds (`true`) |
| `<RFALSE>` | predicate fails (`fail`) |
| `PRSA` | `current_verb(V)` dynamic fact |
| `PRSO` | `current_do(DO)` dynamic fact (direct object) |
| `PRSI` | `current_io(IO)` dynamic fact (indirect object) |
| `HERE` | `current_room(R)` dynamic fact |
| `WINNER` | `current_actor(A)` dynamic fact |
| `SCORE` | `global_val(score, N)` |
| `MOVES` | `global_val(moves, N)` |
| `PRESENT-TIME` | `global_val(present_time, N)` |
| `M-BEG / M-END / M-ENTER / M-LOOK` | atoms: `beg / end / enter / look` |
| `M-FATAL / M-HANDLED / M-NOT-HANDLED` | atoms: `fatal / handled / not_handled` |
| `SYNTAX VERB OBJECT = V-VERB` | DCG rule: `verb_phrase(verb, DO, none) --> [verb], noun_phrase(DO).` |
| `FLAGS PERSON` | category `person` imported by NPC objects |
| `FLAGS DOORBIT CONTBIT OPENBIT` | `has_flag(entity, doorbit)`, etc. |
| `(IN room)` | `location(obj, room)` initial fact |
| `(SYNONYM w1 w2)` | `synonym(entity, [w1, w2])` |
| `(ADJECTIVE adj)` | `adjective(entity, adj)` |

---

## Architecture Patterns

### Adding a New Room

```prolog
% In src/world/rooms.lgt
:- object(my_room, extends(room)).
    :- info([comment is 'My Room']).
    desc("My Room").
    ldesc("A detailed description of my room.").
    exit(north, other_room, always).
    exit(south, yet_another_room, [door, front_door, open]).
    global_objects([my_global_object]).
:- end_object.
```

Then add to `src/world/globals_init.lgt`:
```prolog
:- assertz(location(player, my_room)).  % if starting here
```

### Adding a New Object

```prolog
% In src/world/objects.lgt
:- object(my_object, extends(entity), imports(takeable)).
    desc("my object").
    synonym([object, thing]).
    adjective([my]).
    initial_location(my_room).
    initial_flags([takebit]).
    size(5).
:- end_object.
```

### Adding a New Verb

1. Add DCG rule to `src/parser/grammar.lgt`:
```prolog
verb_phrase(my_verb, DO, none) --> [my_verb_word], noun_phrase(DO).
```

2. Add implementation to `src/engine/verbs.lgt`:
```prolog
execute_verb(my_verb, DO, _IO) :-
    format("You ~w the ~w.~n", [my_verb_word, DO]).
```

---

## Coding Conventions

- **File extension**: `.lgt` for all Logtalk files
- **Atom naming**: `snake_case` (e.g., `south_lawn`, `front_door`)
- **Object names**: ZIL names converted to snake_case (FRONT-DOOR → `front_door`)
- **Flag names**: ZIL flag names as atoms, lowercase (DOORBIT → `doorbit`)
- **Predicate names**: `snake_case` verbs
- **Descriptions**: Use atom strings (single-quoted if spaces, double-quoted for long text)
- **Dynamic state**: ONLY in `src/core/state.lgt` declarations; facts asserted at init
- **No singleton variables**: Use `_Name` prefix for intentionally unused vars
- **Action handler pattern**: `handle_action(RoomOrObj, Phase, Verb, DO, IO)`

---

## Game Constants

| Constant | Value | Meaning |
|---|---|---|
| `present_time` start | 0 | Ticks elapsed (max 1199 before Klutz arrives) |
| `score` start | 8 | Hour of day (8am), increments each 60 moves |
| `moves` start | 0 | Moves within current hour (resets at 60) |
| Time limit | 1200 ticks | ~20 hours game time |
| NPC Baxter arrives | tick 115 | Fixed |
| NPC Coates arrives | tick 230±5 | Randomized |
| Newspaper delivery | tick 175±40 | Randomized |
| Mail delivery | tick 70±60 | Randomized |
| Phone call | tick 60±10 | Randomized |

---

## Testing Checklist

- [ ] `logtalk_load('src/loader.lgt')` loads without errors
- [ ] `south_lawn::desc(D)` returns `"South Lawn"`
- [ ] `location(player, south_lawn)` succeeds after `go/0`
- [ ] Typing `north` moves player to `front_path`
- [ ] `inventory` shows empty hands
- [ ] `look` shows room description with objects
- [ ] After 115 ticks, Baxter appears in foyer
- [ ] After 1200 ticks, Klutz arrives and game ends
- [ ] `accuse mrs_robner with letter` triggers accusation handler

---

## Known Issues / Notes

- The original ZIL source has some compilation errors (multiply-defined labels) — these
  are in the source archive and do not affect this Logtalk refactoring
- The original parser used Z-Machine-specific byte packing; the DCG replacement is cleaner
- `crufty.zil` contains one utility routine (`THIS-IT?`) absorbed into `resolver.lgt`
- `m1.zil` is an empty module file — not translated
- `macros.zil` macros are inlined as Prolog predicates in `utils.lgt`
