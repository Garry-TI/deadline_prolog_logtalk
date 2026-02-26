%%%  flags.lgt  %%%
%%%
%%%  ZIL flag name constants for the Deadline refactoring.
%%%  Each flag is an atom used in has_flag(Entity, Flag) predicates.
%%%
%%%  ZIL source: dungeon.zil (FLAGS properties on OBJECT and ROOM definitions)
%%%
%%%  Copyright 1982 Infocom, Inc. (original game)
%%%  Logtalk refactoring: see CLAUDE.md

:- object(flags).

    :- info([
        version is 1:0:0,
        comment is 'Flag atom constants from original ZIL source.'
    ]).

    %% Object/Room flags (from ZIL FLAGS property)
    %%
    %% touchbit    - object has been touched/taken by player
    %% takebit     - object can be taken by player
    %% contbit     - object is a container
    %% openbit     - container/door is currently open
    %% doorbit     - object is a door (openable/closable)
    %% lockbit     - object is locked (cannot be opened)
    %% transbit    - container contents visible even when closed
    %% searchbit   - object can be searched
    %% surfacebit  - object is a surface (things can be placed on it)
    %% onbit       - object is on/active (lights, room lighting)
    %% lightbit    - object produces light
    %% burnbit     - object can burn
    %% flamebit    - object is on fire / produces flame
    %% weaponbit   - object is a weapon
    %% drinkbit    - object can be drunk
    %% eatbit      - object can be eaten
    %% climbbit    - object can be climbed
    %% vehbit      - object is a vehicle
    %% rlandbit    - room is land (not water/underground)
    %% sacredbit   - room/object is sacred (cannot take items here?)
    %% ndescbit    - do not describe this object in room listings
    %% invisible   - object is not visible to player
    %% person      - object is a person/NPC
    %% looneybit   - NPC is in 'looney' state
    %% duplicate   - object is a duplicate (skip in TAKE ALL)
    %% vowelbit    - description starts with a vowel (use "an")
    %% narticlebit - use no article before description
    %% trytakebit  - disallow implicit take of this object
    %% wornbit     - object is currently worn
    %% readbit     - object can be read

    %% Room flags
    :- public room_flag/1.
    room_flag(rlandbit).
    room_flag(onbit).
    room_flag(sacredbit).
    room_flag(touchbit).

    %% Object interaction flags
    :- public interaction_flag/1.
    interaction_flag(takebit).
    interaction_flag(contbit).
    interaction_flag(openbit).
    interaction_flag(doorbit).
    interaction_flag(lockbit).
    interaction_flag(transbit).
    interaction_flag(searchbit).
    interaction_flag(surfacebit).
    interaction_flag(onbit).
    interaction_flag(trytakebit).
    interaction_flag(wornbit).

    %% Physical/state flags
    :- public physical_flag/1.
    physical_flag(lightbit).
    physical_flag(burnbit).
    physical_flag(flamebit).
    physical_flag(weaponbit).
    physical_flag(drinkbit).
    physical_flag(eatbit).
    physical_flag(climbbit).
    physical_flag(vehbit).
    physical_flag(readbit).

    %% NPC/character flags
    :- public npc_flag/1.
    npc_flag(person).
    npc_flag(looneybit).

    %% Display/description flags
    :- public display_flag/1.
    display_flag(ndescbit).
    display_flag(invisible).
    display_flag(vowelbit).
    display_flag(narticlebit).
    display_flag(touchbit).
    display_flag(duplicate).

    %% All valid flags (for validation)
    :- public valid_flag/1.
    valid_flag(F) :- room_flag(F).
    valid_flag(F) :- interaction_flag(F).
    valid_flag(F) :- physical_flag(F).
    valid_flag(F) :- npc_flag(F).
    valid_flag(F) :- display_flag(F).

:- end_object.
