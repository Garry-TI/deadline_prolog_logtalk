# Deadline: ZIL to Logtalk/Prolog Refactoring

**Deadline** is a 1982 interactive fiction detective game written by Marc Blank and published by Infocom. The player is an inspector investigating the apparent suicide of Marshall Robner at his estate, with 12 hours of game time (1200 turns) to solve the case before Chief Inspector Klutz arrives.

This repository contains both the **original ZIL source code** and an ongoing **refactoring into Logtalk 3.97.1 + SWI-Prolog 10.0.1**.

## Further Information

* [Wikipedia](https://en.wikipedia.org/wiki/Deadline_(video_game))
* [The Digital Antiquarian](https://www.filfre.net/2012/07/deadline/)
* [The Interactive Fiction Database](https://ifdb.tads.org/viewgame?id=p976o7x5ies9ltdh)
* [The Infocom Gallery](http://infocom.elsewhere.org/gallery/deadline_grey/)
* [IFWiki](http://www.ifwiki.org/index.php/Deadline)

---

## Original ZIL Source

The ZIL (Zork Implementation Language) source code was contributed anonymously and represents a snapshot of the Infocom development system. There is currently no known way to compile this source into a playable Z-machine file. The original source is preserved unmodified in the repository root:

| File | Lines | Purpose |
|------|------:|---------|
| `dungeon.zil` | 2,540 | 50 rooms, 204 objects, NPC definitions |
| `actions.zil` | 4,533 | 198 action handlers for rooms, objects, NPCs |
| `verbs.zil` | 1,900 | 193 verb implementation routines |
| `syntax.zil` | 604 | 253 grammar rules (SYNTAX declarations) |
| `parser.zil` | 1,116 | NLP parser and input processing |
| `goal.zil` | 728 | NPC pathfinding, movement schedules, goal tracking |
| `clock.zil` | 82 | Timed event queue system |
| `main.zil` | 196 | Game loop, PERFORM dispatch, initialization |
| `macros.zil` | 96 | TELL, VERB?, PROB utility macros |
| `crufty.zil` | 16 | THIS-IT? disambiguation utility |

---

## Logtalk/Prolog Refactoring

### Requirements

| Tool | Version | Notes |
|------|---------|-------|
| SWI-Prolog | 10.0.1+ | [Download](https://www.swi-prolog.org/Download.html) |
| Logtalk | 3.97.1+ | [Download](https://logtalk.org/download.html) |

### Running the Game

**Using the run script (Windows):**
```powershell
.\run.ps1
```

**Manual start:**
```powershell
# Launch SWI-Prolog with Logtalk integration
& "D:\Program Files (x86)\Logtalk\integration\swilgt.ps1"

# At the ?- prompt:
?- logtalk_load('src/loader.lgt'), go.
```

**Testing individual components:**
```prolog
?- logtalk_load('src/loader.lgt').
?- south_lawn::desc(D), write(D).      % Query a room description
?- location(player, R), write(R).       % Check player location
?- george::dialogue_response(murder, R), write(R).  % Test NPC dialogue
```

### Project Structure

```
src/
  loader.lgt              Master loader (loads all files in dependency order)
  deadline.lgt             Entry point (go/0)
  core/
    flags.lgt              27 flag atom constants (doorbit, takebit, etc.)
    state.lgt              Dynamic predicate declarations (location/2, has_flag/2, etc.)
    entity_class.lgt       Abstract room, entity, and npc prototypes
    categories.lgt         Reusable behaviors (takeable, container, door, person, etc.)
    utils.lgt              40+ utility predicates (tell, prob, pick_one, etc.)
  world/
    rooms.lgt              51 room prototype objects
    objects.lgt            172 object prototype objects
    npcs.lgt               17 NPC/character objects with dialogue
    globals_init.lgt       63 global variable initializations, all initial state
  parser/
    lexer.lgt              Tokenizer with buzz-word filtering
    grammar.lgt            239 DCG verb grammar rules
    resolver.lgt           Object disambiguation and scope checking
  engine/
    clock.lgt              Event queue, time advancement, deadline check
    npc_ai.lgt             Transit-line pathfinding, movement schedules, goal pursuit
    game_loop.lgt          Main loop, PERFORM dispatch pipeline, pronoun tracking
    verbs.lgt              97 verb handler implementations
    actions.lgt            Room/object/NPC action handlers, event routines
    events.lgt             Event dispatch routing (12 event types)
```

---

## Features Refactored to Date

### Core Infrastructure (100%)
- **State management**: All mutable state as dynamic predicates (`location/2`, `has_flag/2`, `global_val/2`)
- **Flag system**: 27 ZIL flags mapped to atom predicates
- **Object model**: Abstract prototypes for rooms, entities, and NPCs using Logtalk's prototype-based OOP
- **Categories**: 8 reusable behavior categories (takeable, container, door, lockable, person, surface, readable, lightable)
- **Utility library**: 40+ predicates covering output, probability, entity queries, player utilities

### World Data (85%)
- **Rooms**: All 51 rooms with descriptions, exits, door conditions, and global objects
- **Objects**: 172 of 204 objects defined with synonyms, adjectives, flags, and locations
- **NPCs**: 17 character objects with dialogue systems
- **Initial state**: 63 globals, 99 object locations, all room/entity flags initialized

### Parser System (94%)
- **Lexer**: Full tokenizer with buzz-word filtering and synonym mapping
- **Grammar**: 239 of 253 ZIL syntax rules as DCG rules
- **Resolver**: Noun phrase disambiguation, pronoun resolution (it/him/her), scope checking

### Game Engine (100%)
- **Clock**: Event queue with one-shot and daemon events, time tracking (hour/minute), 1200-tick deadline
- **Game loop**: Full PERFORM dispatch pipeline (actor → room M-BEG → pre-action → IO action → DO action → verb handler → room M-END)
- **NPC pathfinding**: 4 transit lines with transfer points, `establish_goal`/`follow_goal` system

### NPC Systems

#### Mr. McNabb (Gardener) - Complete
- Full movement schedule (6 destinations across the day)
- Goal-reached handlers (rose garden queues I-G-I-G, orchard reclaims ladder, in_roses shows holes)
- Location-based descriptions (IN-MOTION check, 8 activity states)
- Complete dialogue (gardener, murder, hole, roses, ladder + show/confront responses)
- Evidence discovery: hole inspection, fragment finding
- Carry-check display, COM-CHECK redirect, observation points

#### Mr. Baxter - Partial
- Arrival event at tick 115
- 7 dialogue responses
- Movement schedule (arrives, goes to living room, departs at 4PM)

#### George Robner - Complete
- Full movement schedule (7 destinations: kitchen, dining, bedroom, living room, east lawn)
- Goal-reached handler (stereo at bedroom, relax at east lawn, will destruction at north lawn)
- Location-based descriptions (8 states: snack, red herrings, pacing, staring, stereo, thinking)
- Complete verb handlers (hello, call, search, accuse, arrest with game-ending sequence)
- Show/confront handlers (lab report, letter, desk calendar, newspaper) with ZIL-accurate text
- 17 dialogue responses including context-sensitive topics (safe, hidden closet, new will, steven)
- **Full I-GEORGE-HACK safe access sequence** (4 interconnected routines):
  - `george_hack`: Calendar trigger, George heads to his room
  - `i_george_hack`: Per-tick daemon (handles player intrusion, door slamming, following detection)
  - `i_george_hack_2`: Door peeking (George checks hallway, retreats if player nearby)
  - `i_george_hack_3`: Safe access progression (17-phase state machine, player can catch George with the will = winning condition)
  - `i_george_leave_closet`: Exit after capture

#### Ms. Dunbar, Mrs. Robner, Mrs. Rourke, Mr. Coates - Partial
- Object definitions with basic dialogue
- Coates: arrival event, will reading trigger, goal-reached handler, departure sequence
- Coates: ZIL-accurate dialogue (attorney-client privilege responses)
- Mrs. Robner: ask-about handler with emotional responses

### Event System
- **Newspaper delivery** (tick 175 +/- 40)
- **Mail delivery** (tick 70 +/- 60)
- **Phone call** (tick 60 +/- 10)
- **Baxter arrival** (tick 115)
- **Coates arrival** (tick 230 +/- 5)
- **Will reading ceremony**: 3-phase state machine with NPC gathering, player waiting, full narrative
- **Will aftermath**: Coates departure, George hack trigger, will-missed guilt messages
- **George will destruction**: Complete safe access sequence with player detection
- **Stereo system**: George puts on random records from ZIL RECORD-TABLE

### Investigation Mechanics
- **Analyze verb**: Full pipeline (grammar → resolver → verb handler → do_fingerprint)
- **Fingerprint system**: Duffy dispatched with analysis goal tracking
- **Fragment/hole discovery**: Evidence found through McNabb's rose garden

### Room-Specific Handlers
- 35+ rooms with custom M-LOOK descriptions
- George's room: stereo display when music playing
- George's bathroom: fixture descriptions with door state
- Library balcony / bay window: observation points for distant NPCs
- Door state display in descriptions (open/closed)

---

## TODO: Remaining Features to Refactor

### High Priority (Blocks Core Gameplay)

- [ ] **Object action handlers** (~100 remaining): Most objects lack verb-specific responses (examine, read, open, take interactions for furniture, evidence items, containers)
- [ ] **Dunbar NPC system**: Full dialogue, suicide event sequence (I-DUNBAR-DEATH), Baxter's reaction, body discovery
- [ ] **Mrs. Robner NPC system**: Full dialogue, phone call handler, bedroom investigation, Steven affair subplot
- [ ] **Baxter NPC system**: Full dialogue, confront/show responses, merger subplot, Dunbar death reaction, departure sequence
- [ ] **Rourke NPC system**: Full dialogue, gossip responses, room cleaning schedule
- [ ] **Accusation/arrest system**: Full ARREST verb for all suspects, evidence evaluation, multiple endings with reports
- [ ] **Safe puzzle**: Combination discovery, safe opening, new will retrieval (independent of George hack)
- [ ] **Phone call event**: Full I-CALL handler with overheard conversation, Mrs. Robner's reaction

### Medium Priority (Enhances Gameplay)

- [ ] **Remaining verb implementations** (~50 stubs): push, pull, attack, kill, burn, smell, taste, squeeze, wave, throw-at, listen-to, etc.
- [ ] **Room M-BEG/M-END handlers**: Pre/post-action checks for room-specific behavior (e.g., library restricts certain actions)
- [ ] **Missing objects** (32 remaining): Minor decorative items, variant objects, some evidence pieces
- [ ] **NPC give/show response handlers**: NPCs react to being given or shown arbitrary items
- [ ] **NPC attention system** (I-ATTENTION): NPCs notice and react to the player's presence
- [ ] **Discretion system** (DISCRETION routine): NPCs conditionally reveal information about other NPCs
- [ ] **Ladder puzzle**: Placement, climbing, balcony access mechanics
- [ ] **Bookshelf/hidden closet puzzle**: Player-initiated discovery (independent of George sequence)
- [ ] **Score tracking**: Point accumulation for discoveries and correct deductions
- [ ] **Multiple game endings**: 8+ ending reports based on evidence collected and suspect arrested

### Low Priority (Polish)

- [ ] **Save/restore**: Game state serialization and deserialization
- [ ] **First-discovery descriptions** (fdesc): Special text shown only the first time an object is seen
- [ ] **Missing grammar rules** (14 remaining): Rare verb aliases and edge-case phrasings
- [ ] **Compilation warning cleanup**: Resolve 67 warnings (singleton variables, unused imports)
- [ ] **NPC reaction sequences**: Elaborate context-dependent NPC behaviors beyond dialogue
- [ ] **Easter eggs**: Hidden interactions and responses from the original game
- [ ] **WAIT system**: Enhancements for waiting specific amounts of time
- [ ] **AGAIN command**: Full repeat-last-action with edge case handling

---

## Architecture Notes

### ZIL to Logtalk Mapping

| ZIL Construct | Logtalk/Prolog Equivalent |
|---|---|
| `<ROOM name>` | `:- object(name, extends(room)).` prototype |
| `<OBJECT name>` | `:- object(name, extends(entity)).` prototype |
| `<GLOBAL name val>` | `global_val(name, val)` dynamic fact |
| `<SETG name val>` | `state::set_global(name, val)` |
| `<FSET obj flag>` | `state::set_flag(obj, flag)` |
| `<FCLEAR obj flag>` | `state::clear_flag(obj, flag)` |
| `<MOVE obj dest>` | `state::move_entity(obj, dest)` |
| `<VERB? v1 v2>` | `current_verb(V), memberchk(V, [v1,v2])` |
| `<TELL "text" CR>` | `writeln("text")` |
| `<QUEUE rtn delay>` | `clock::queue_event(rtn, delay)` |
| `<RTRUE> / <RFALSE>` | succeed / fail |
| `PRSA / PRSO / PRSI` | `current_verb/1`, `current_do/1`, `current_io/1` |

### Key Design Decisions

- **Prototype-based OOP**: Rooms and objects use Logtalk's `extends` (prototype inheritance) rather than class instantiation
- **Centralized state**: All mutable state lives in `state.lgt` dynamic predicates; objects are stateless prototypes
- **DCG parser**: ZIL's byte-packed Z-Machine tokenizer replaced with clean DCG grammar rules
- **Transit-line pathfinding**: NPC movement uses the original ZIL's transit line concept (ordered room lists with transfer points between lines)
- **Event-driven**: Clock events use the same queue/enable/disable pattern as ZIL's interrupt system

---

## Some Trivia and Notes

* DEADLINE is derived from Zork source code, and there are traces of the original Dungeon attributes in the ZIL code.
* The original ZIL source has some compilation issues (multiply-defined labels) that exist in the archive and do not affect the Logtalk refactoring.
* `crufty.zil` contains a single utility routine (`THIS-IT?`) absorbed into `resolver.lgt`.
* `m1.zil` is an empty module file and was not translated.
* The original parser used Z-Machine-specific byte packing; the DCG replacement is cleaner and more maintainable.
