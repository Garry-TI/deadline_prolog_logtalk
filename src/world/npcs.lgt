%%%  npcs.lgt  %%%
%%%
%%%  All NPC (Non-Player Character) prototypes for Deadline.
%%%  Translated from dungeon.zil OBJECT definitions with (FLAGS PERSON ...).
%%%
%%%  NPCs are Logtalk prototype objects that extend 'npc' and import 'person'.
%%%  Initial locations are set in globals_init.lgt.
%%%
%%%  ZIL source: dungeon.zil (lines 1010-1144, 2080-2097)
%%%
%%%  Characters:
%%%    0 = player
%%%    1 = gardener (Mr. McNabb)
%%%    2 = baxter (Mr. Baxter) - arrives at tick 115
%%%    3 = dunbar (Ms. Dunbar) - starts in living room
%%%    4 = george (George Robner) - starts in his bedroom
%%%    5 = mrs_robner (Mrs. Robner) - starts in living room
%%%    6 = rourke (Mrs. Rourke) - starts in kitchen
%%%    7 = coates (Mr. Coates) - arrives at tick 230
%%%
%%%  Copyright 1982 Infocom, Inc. (original game)
%%%  Logtalk refactoring: see CLAUDE.md

%% ===================================================================
%%  PLAYER
%% ===================================================================

:- object(player, extends(npc), imports(person)).
    :- info([comment is 'The player character (Inspector)']).
    desc("player").
    synonym([me, player, inspector]).
    initial_flags([ndescbit, person]).
    character_index(0).
:- end_object.

%% ===================================================================
%%  MR. McNABB (The Gardener)
%% ===================================================================

:- object(gardener, extends(npc), imports(person)).
    :- info([comment is 'Mr. McNabb, the estate gardener']).
    desc("Mr. McNabb").
    synonym([mcnabb]).
    adjective([mr, mister, angus]).
    initial_flags([person, openbit]).
    capacity(40).
    character_index(1).

    %% McNabb starts in north_lawn
    initial_location(north_lawn).

    %% Custom greeting
    greet_response :-
        writeln("Mr. McNabb grunts in your general direction.").

    %% McNabb dialogue responses
    dialogue_response(murder, "McNabb shakes his head slowly. \"A terrible business,\" he says.").
    dialogue_response(roses, "\"I was working on the roses early this morning,\" he says.").
    dialogue_response(ladder, "He glances away. \"I don't know nothin' about no ladder.\"").
    dialogue_response(robner, "He pauses. \"Mr. Robner was a fair employer.\"").

:- end_object.

%% Global version (for reference when McNabb is not in current room)
:- object(global_gardener, extends(npc), imports(person)).
    :- info([comment is 'Global reference to McNabb']).
    desc("Mr. McNabb").
    synonym([mcnabb]).
    adjective([mr, mister, angus]).
    initial_flags([person, ndescbit]).
    character_index(1).
:- end_object.

%% ===================================================================
%%  MR. BAXTER (Arrives at tick 115)
%% ===================================================================

:- object(baxter, extends(npc), imports(person)).
    :- info([comment is 'Mr. Baxter, the business attorney - arrives at tick 115']).
    desc("Mr. Baxter").
    synonym([baxter]).
    adjective([mister, mr]).
    initial_flags([person, openbit]).
    capacity(40).
    character_index(2).

    %% Baxter has no initial location - placed by clock event
    %% initial_location set dynamically in clock.lgt

    %% Baxter dialogue responses
    dialogue_response(murder, "\"I have no idea who would want to kill Marshall,\" he says evenly.").
    dialogue_response(will, "His eyes narrow slightly. \"That's a personal matter.\"").
    dialogue_response(focus, "Baxter clears his throat. \"I don't know what you're talking about.\"").
    dialogue_response(papers, "He looks away. \"Those are confidential business documents.\"").
    dialogue_response(robner, "\"Marshall was my client for twenty years,\" he says.").
    dialogue_response(gardener, "\"I don't know much about Mr. McNabb.\"").
    dialogue_response(rourke, "\"I don't know much about Mrs. Rourke.\"").

    greet_response :-
        writeln("\"Good morning, Inspector,\" says Mr. Baxter, adjusting his tie.").

:- end_object.

:- object(global_baxter, extends(npc), imports(person)).
    :- info([comment is 'Global reference to Baxter']).
    desc("Mr. Baxter").
    synonym([baxter]).
    adjective([mister, mr]).
    initial_flags([person, ndescbit]).
    character_index(2).
:- end_object.

%% ===================================================================
%%  MS. DUNBAR (Secretary)
%% ===================================================================

:- object(dunbar, extends(npc), imports(person)).
    :- info([comment is 'Ms. Dunbar, the Robner secretary - starts in living room']).
    desc("Ms. Dunbar").
    synonym([dunbar]).
    adjective([ms, mrs]).
    initial_flags([person, openbit]).
    capacity(40).
    character_index(3).
    initial_location(living_room).

    %% Dunbar dialogue responses
    dialogue_response(murder, "\"It's just too horrible,\" she says, dabbing her eyes.").
    dialogue_response(will, "She looks uncomfortable. \"I really don't know about Mr. Robner's personal affairs.\"").
    dialogue_response(loblo, "\"Yes, I take LoBlo for my blood pressure.\"").
    dialogue_response(letter, "She turns red. \"That's personal correspondence.\"").
    dialogue_response(robner, "\"Mr. Robner was a wonderful employer.\" She sniffles.").
    dialogue_response(meeting, "She hesitates. \"I - I was here all morning.\"").
    dialogue_response(gardener, "\"He seems nice, if you can talk to him. You usually can't, really.\" She laughs briefly. \"Don't ever disturb his roses, or you'll learn the meaning of temper.\" She giggles again.").

    greet_response :-
        writeln("Ms. Dunbar looks up at you with red-rimmed eyes.").

:- end_object.

:- object(global_dunbar, extends(npc), imports(person)).
    :- info([comment is 'Global reference to Dunbar']).
    desc("Ms. Dunbar").
    synonym([dunbar]).
    adjective([ms, mrs]).
    initial_flags([person, ndescbit]).
    character_index(3).
:- end_object.

%% ===================================================================
%%  GEORGE ROBNER (Son of Deceased)
%% ===================================================================

:- object(george, extends(npc), imports(person)).
    :- info([comment is 'George Robner, the son - starts in his bedroom']).
    desc("George").
    adjective([george]).
    synonym([george, robner]).
    initial_flags([person, openbit]).
    capacity(40).
    character_index(4).
    initial_location(george_room).

    %% George dialogue responses
    dialogue_response(murder, "\"Someone killed my father,\" he says flatly. \"I want to know who.\"").
    dialogue_response(will, "His jaw tightens. \"Dad was going to cut me out. I know that.\"").
    dialogue_response(robner, "\"My father and I didn't see eye to eye on things.\"").
    dialogue_response(meeting, "He looks away. \"I didn't see him this morning.\"").
    dialogue_response(gardener, "\"McNabb, that old bore? Always talking about the damn roses and weeds. Don't ask him about them, unless you have all day.\"").

    greet_response :-
        writeln("George looks up from where he's sitting. He appears pale and shaken.").

:- end_object.

:- object(global_george, extends(npc), imports(person)).
    :- info([comment is 'Global reference to George']).
    desc("George").
    adjective([george]).
    synonym([george, robner]).
    initial_flags([person, ndescbit]).
    character_index(4).
:- end_object.

%% ===================================================================
%%  MRS. LESLIE ROBNER (Widow)
%% ===================================================================

:- object(mrs_robner, extends(npc), imports(person)).
    :- info([comment is 'Mrs. Robner, the widow - starts in living room']).
    desc("Mrs. Robner").
    synonym([robner, mother, leslie]).
    adjective([mrs, ms, leslie]).
    initial_flags([person, openbit]).
    capacity(40).
    character_index(5).
    initial_location(living_room).

    %% Mrs. Robner dialogue responses
    dialogue_response(murder, "\"I still can't believe he's gone,\" she says softly.").
    dialogue_response(will, "\"Marshall changed his will recently. I know that much.\"").
    dialogue_response(robner, "\"He was under so much pressure lately. The business...\"").
    dialogue_response(suicide, "She shudders. \"Marshall would never have done that.\"").
    dialogue_response(letter, "She flushes slightly. \"That was from my friend Steven.\"").
    dialogue_response(steven, "\"Steven is an old friend. We correspond regularly.\"").
    dialogue_response(baxter, "Her eyes cloud. \"Mr. Baxter handled Marshall's legal affairs.\"").
    dialogue_response(gardener, "\"I don't pay much attention to him. He's worked out well; the grounds are in excellent condition. You must take a look at his roses while you're here. They're really spectacular.\"").

    greet_response :-
        writeln("Mrs. Robner acknowledges you with a brief nod. She is clearly distraught.").

:- end_object.

:- object(global_mrs_robner, extends(npc), imports(person)).
    :- info([comment is 'Global reference to Mrs. Robner']).
    desc("Mrs. Robner").
    synonym([robner, mother, leslie]).
    adjective([mrs, ms, leslie]).
    initial_flags([person, ndescbit]).
    character_index(5).
:- end_object.

%% ===================================================================
%%  MRS. ROURKE (Housekeeper)
%% ===================================================================

:- object(rourke, extends(npc), imports(person)).
    :- info([comment is 'Mrs. Rourke, the housekeeper - starts in kitchen']).
    desc("Mrs. Rourke").
    synonym([rourke]).
    adjective([ms, mrs]).
    initial_flags([person, openbit]).
    capacity(40).
    character_index(6).
    initial_location(kitchen).

    %% Rourke dialogue responses
    dialogue_response(murder, "\"I served the family for twenty years,\" she says primly. \"Mr. Robner was a good man.\"").
    dialogue_response(tray, "\"I brought his tray up at nine o'clock, as usual.\"").
    dialogue_response(cup, "\"The good china? I put it on the tray myself.\"").
    dialogue_response(sugar, "\"I always put sugar on the tray. Mr. Robner liked his tea sweet.\"").
    dialogue_response(robner, "\"He seemed perfectly well last night at dinner.\"").
    dialogue_response(baxter, "\"Mr. Baxter comes every week. A perfectly nice man.\"").
    dialogue_response(gardener, "\"Oh, don't let him frighten you. Let him alone and don't bother his roses. Gets positively livid about that. Got the green thumb, that's for sure.\"").

    greet_response :-
        writeln("\"Good morning,\" Mrs. Rourke says briskly, continuing her work.").

:- end_object.

:- object(global_rourke, extends(npc), imports(person)).
    :- info([comment is 'Global reference to Rourke']).
    desc("Mrs. Rourke").
    synonym([rourke]).
    adjective([ms, mrs]).
    initial_flags([person, ndescbit]).
    character_index(6).
:- end_object.

%% ===================================================================
%%  MR. COATES (Attorney - Arrives at tick 230)
%% ===================================================================

:- object(coates, extends(npc), imports(person)).
    :- info([comment is 'Mr. Coates, another attorney - arrives ~tick 230']).
    desc("Mr. Coates").
    synonym([coates]).
    adjective([mr]).
    initial_flags([person]).
    character_index(7).
    %% No initial location - placed by clock event

    %% Coates dialogue responses
    dialogue_response(will, "\"I handle the Robner estate accounts,\" he says carefully.").
    dialogue_response(robner, "\"Marshall was a valued client.\"").
    dialogue_response(baxter, "A slight pause. \"Baxter handles the corporate matters.\"").

    greet_response :-
        writeln("Mr. Coates nods formally. \"Inspector.\"").

:- end_object.

:- object(global_coates, extends(npc), imports(person)).
    :- info([comment is 'Global reference to Coates']).
    desc("Mr. Coates").
    synonym([coates]).
    adjective([mr]).
    initial_flags([person, ndescbit]).
    character_index(7).
:- end_object.

%% ===================================================================
%%  MR. ROBNER (Deceased - global reference only)
%% ===================================================================

:- object(global_mr_robner, extends(npc), imports(person)).
    :- info([comment is 'Reference to the deceased Mr. Robner (for dialogue topics)']).
    desc("Mr. Robner").
    synonym([robner, father, marshall]).
    adjective([mr, mister]).
    initial_flags([person, ndescbit]).
:- end_object.

%% ===================================================================
%%  GLOBAL CHARACTER TABLE
%%  Maps character_index to NPC atom (for pronoun resolution)
%% ===================================================================

:- object(character_table).
    :- info([comment is 'Maps character indices to NPC atoms (ZIL GLOBAL-CHARACTER-TABLE)']).

    :- public(npc_for_index/2).
    npc_for_index(0, player).
    npc_for_index(1, gardener).
    npc_for_index(2, baxter).
    npc_for_index(3, dunbar).
    npc_for_index(4, george).
    npc_for_index(5, mrs_robner).
    npc_for_index(6, rourke).
    npc_for_index(7, coates).

    :- public(all_npcs/1).
    all_npcs([gardener, baxter, dunbar, george, mrs_robner, rourke, coates]).

:- end_object.
