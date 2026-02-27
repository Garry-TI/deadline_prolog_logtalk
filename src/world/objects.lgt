%%%  objects.lgt  %%%
%%%
%%%  All game object prototypes for Deadline.
%%%  Translated from dungeon.zil OBJECT definitions (non-NPC).
%%%
%%%  Objects are Logtalk prototypes extending 'entity', importing categories
%%%  that correspond to their ZIL FLAGS.
%%%
%%%  ZIL source: dungeon.zil (OBJECT blocks, lines 840-2440+)
%%%
%%%  Copyright 1982 Infocom, Inc. (original game)
%%%  Logtalk refactoring: see CLAUDE.md

%% ===================================================================
%%  DOORS
%%  ZIL source: dungeon.zil lines 840-938
%% ===================================================================

:- object(south_closet_door, extends(entity), imports(door)).
    :- info([comment is 'South closet door - initially open']).
    adjective([closet]).
    synonym([door]).
    desc("south closet door").
    initial_flags([doorbit, contbit, openbit]).
    initial_location(local_globals).
:- end_object.

:- object(front_door, extends(entity), imports(door)).
    :- info([comment is 'Front door - initially closed']).
    synonym([door]).
    adjective([front]).
    desc("front door").
    initial_flags([doorbit, contbit]).
    initial_location(local_globals).
:- end_object.

:- object(rourke_door, extends(entity), imports(door)).
    :- info([comment is "Mrs. Rourke's room door"]).
    synonym([door]).
    desc("door").
    initial_flags([doorbit, contbit]).
    initial_location(local_globals).
:- end_object.

:- object(dunbar_door, extends(entity), imports(door)).
    :- info([comment is "Dunbar's bedroom door"]).
    synonym([door]).
    adjective([dunbar, south]).
    desc("south door").
    initial_flags([doorbit, contbit]).
    initial_location(local_globals).
:- end_object.

:- object(dunbar_bath_door, extends(entity), imports(door)).
    :- info([comment is "Dunbar's bathroom door - initially open"]).
    synonym([door]).
    desc("door").
    initial_flags([doorbit, contbit, openbit]).
    initial_location(local_globals).
:- end_object.

:- object(rourke_bath_door, extends(entity), imports(door)).
    :- info([comment is "Rourke's bathroom door"]).
    synonym([door]).
    adjective([bathroom]).
    desc("bathroom door").
    initial_flags([doorbit, contbit]).
    initial_location(local_globals).
:- end_object.

:- object(master_bedroom_door, extends(entity), imports(door)).
    :- info([comment is 'Master bedroom door']).
    synonym([door]).
    adjective([bedroom, master, north]).
    desc("bedroom door").
    initial_flags([doorbit, contbit]).
    initial_location(local_globals).
:- end_object.

:- object(george_door, extends(entity), imports(door)).
    :- info([comment is "George's bedroom door"]).
    synonym([door]).
    adjective([bedroom, south]).
    desc("bedroom door").
    initial_flags([doorbit, contbit]).
    initial_location(local_globals).
:- end_object.

:- object(george_bath_door, extends(entity), imports(door)).
    :- info([comment is "George's bathroom door - initially open"]).
    synonym([door]).
    adjective([bathroom, east]).
    desc("bathroom door").
    initial_flags([doorbit, contbit, openbit]).
    initial_location(local_globals).
:- end_object.

:- object(hidden_door_l, extends(entity), imports(door)).
    :- info([comment is 'Hidden door (library side) - initially invisible']).
    synonym([door]).
    adjective([hidden]).
    desc("hidden door").
    initial_flags([doorbit, contbit, invisible]).
    initial_location(local_globals).
:- end_object.

:- object(hidden_door_b, extends(entity), imports(door)).
    :- info([comment is 'Hidden door (bedroom side) - initially invisible']).
    synonym([door]).
    adjective([hidden]).
    desc("hidden door").
    initial_flags([doorbit, contbit, invisible]).
    initial_location(local_globals).
:- end_object.

:- object(library_balcony_door, extends(entity), imports(door)).
    :- info([comment is 'Library balcony door']).
    synonym([door, doors, window]).
    adjective([balcony]).
    desc("balcony door").
    initial_flags([doorbit, contbit]).
    initial_location(local_globals).
:- end_object.

:- object(bedroom_balcony_door, extends(entity), imports(door)).
    :- info([comment is 'Bedroom balcony door']).
    synonym([door, doors, window]).
    adjective([glass, balcony]).
    desc("balcony door").
    initial_flags([doorbit, contbit]).
    initial_location(local_globals).
:- end_object.

%% ===================================================================
%%  LOCAL GLOBALS - Environmental Objects
%%  ZIL source: dungeon.zil lines 941-999
%% ===================================================================

:- object(rose, extends(entity)).
    :- info([comment is 'Roses in the garden']).
    desc("roses").
    synonym([bed, rose, roses]).
    adjective([red, white, pink, yellow]).
    initial_location(local_globals).
:- end_object.

:- object(house, extends(entity)).
    :- info([comment is 'The Robner house']).
    desc("house").
    synonym([house, wall]).
    adjective([robner]).
    initial_location(local_globals).
:- end_object.

:- object(lawn, extends(entity)).
    :- info([comment is 'The estate lawn']).
    desc("lawn").
    synonym([lawn, grass]).
    adjective([green]).
    initial_location(local_globals).
:- end_object.

:- object(shed, extends(entity)).
    :- info([comment is 'The garden shed']).
    desc("shed").
    synonym([shed, cabin]).
    adjective([log, wooden, wood]).
    initial_location(local_globals).
:- end_object.

:- object(lake, extends(entity)).
    :- info([comment is 'The lake bordering the estate']).
    desc("lake").
    synonym([lake, water]).
    initial_location(local_globals).
:- end_object.

:- object(balcony, extends(entity)).
    :- info([comment is 'Generic balcony reference']).
    desc("balcony").
    synonym([balcony]).
    initial_location(local_globals).
:- end_object.

:- object(bay_window, extends(entity), imports(door)).
    :- info([comment is 'Bay window on the west side of living room']).
    desc("bay window").
    synonym([window]).
    adjective([bay]).
    initial_flags([doorbit, contbit]).
    initial_location(local_globals).
:- end_object.

:- object(telephone, extends(entity)).
    :- info([comment is 'Telephone (appears in multiple rooms via local_globals)']).
    desc("telephone").
    synonym([telephone, phone, receiver]).
    initial_location(local_globals).
:- end_object.

:- object(fruit_trees, extends(entity)).
    :- info([comment is 'Fruit trees in the orchard']).
    desc("fruit tree").
    synonym([tree]).
    adjective([fruit, apple, pear, peach]).
    initial_flags([ndescbit]).
    initial_location(local_globals).
:- end_object.

:- object(closet, extends(entity)).
    :- info([comment is 'Generic closet reference']).
    desc("closet").
    synonym([closet]).
    initial_location(local_globals).
:- end_object.

:- object(shed_window, extends(entity)).
    :- info([comment is 'Window in the garden shed']).
    desc("window").
    synonym([window]).
    adjective([shed, dirty, grimy]).
    initial_location(local_globals).
:- end_object.

:- object(kitchen_window, extends(entity)).
    :- info([comment is 'Kitchen window']).
    desc("kitchen window").
    synonym([window]).
    adjective([kitchen]).
    initial_flags([ndescbit]).
    initial_location(local_globals).
:- end_object.

:- object(dining_room_window, extends(entity)).
    :- info([comment is 'Dining room picture window']).
    desc("dining room window").
    synonym([window]).
    adjective([dining, room]).
    initial_flags([ndescbit]).
    initial_location(local_globals).
:- end_object.

:- object(window, extends(entity)).
    :- info([comment is 'Generic window']).
    desc("window").
    synonym([window]).
    initial_flags([ndescbit]).
    initial_location(local_globals).
:- end_object.

%% Furniture local globals
:- object(chair, extends(entity)).
    :- info([comment is 'Chair (appears in many rooms)']).
    desc("chair").
    synonym([chair, chairs]).
    initial_flags([ndescbit, furniture]).
    initial_location(local_globals).
:- end_object.

:- object(sofa, extends(entity), imports([surface, container])).
    :- info([comment is 'Sofa in living room']).
    desc("sofa").
    synonym([couch, sofa, couches]).
    initial_flags([ndescbit, surfacebit, contbit, openbit, vehbit, furniture]).
    initial_location(local_globals).
    capacity(30).
:- end_object.

:- object(lgtable, extends(entity)).
    :- info([comment is 'Small table in living room']).
    desc("table").
    synonym([table, tables]).
    initial_flags([ndescbit, furniture]).
    initial_location(local_globals).
:- end_object.

:- object(end_table, extends(entity)).
    :- info([comment is 'Pair of end tables (in multiple rooms)']).
    desc("pair of end tables").
    synonym([table, tables]).
    adjective([end]).
    initial_flags([ndescbit, furniture]).
    initial_location(local_globals).
:- end_object.

:- object(bed, extends(entity), imports([surface, container])).
    :- info([comment is 'Bed (in multiple rooms)']).
    desc("bed").
    synonym([bed]).
    initial_flags([ndescbit, surfacebit, contbit, openbit, furniture, vehbit]).
    capacity(30).
    initial_location(local_globals).
:- end_object.

:- object(sink, extends(entity)).
    :- info([comment is 'Sink (in multiple bathrooms)']).
    desc("sink").
    synonym([sink, sinks, bowl, basin]).
    initial_flags([ndescbit, furniture]).
    initial_location(local_globals).
:- end_object.

:- object(toilet, extends(entity), imports(surface)).
    :- info([comment is 'Toilet (in multiple bathrooms)']).
    desc("toilet").
    synonym([toilet]).
    initial_flags([ndescbit, furniture, surfacebit, vehbit]).
    initial_location(local_globals).
:- end_object.

:- object(shower, extends(entity)).
    :- info([comment is 'Shower/bathtub (in multiple bathrooms)']).
    desc("shower").
    synonym([shower, tub, bath, bathtub]).
    adjective([shower, bath]).
    initial_flags([ndescbit, trytakebit, furniture]).
    initial_location(local_globals).
:- end_object.

%% ===================================================================
%%  GLOBAL OBJECTS (accessible everywhere)
%% ===================================================================

:- object(ground, extends(entity)).
    :- info([comment is 'The ground']).
    desc("ground").
    synonym([ground, dirt, mud, soil]).
    adjective([hard]).
    initial_location(global_objects).
:- end_object.

:- object(air, extends(entity)).
    :- info([comment is 'The air']).
    desc("air").
    synonym([air, wind, breeze]).
    initial_location(global_objects).
:- end_object.

:- object(global_fingerprints, extends(entity)).
    :- info([comment is 'Fingerprints (global reference for analysis commands)']).
    synonym([fingerprint]).
    desc("fingerprints").
    initial_location(global_objects).
:- end_object.

:- object(global_murder, extends(entity)).
    :- info([comment is 'Murder as a discussion topic']).
    desc("murder").
    synonym([murder, killing, crime]).
    initial_location(global_objects).
:- end_object.

:- object(global_suicide, extends(entity)).
    :- info([comment is 'Suicide as a discussion topic']).
    desc("suicide").
    synonym([suicide]).
    initial_location(global_objects).
:- end_object.

:- object(global_focus, extends(entity)).
    :- info([comment is 'The Focus scandal (discussion topic)']).
    desc("Focus").
    synonym([focus, scandal, case]).
    adjective([focus]).
    initial_location(global_objects).
:- end_object.

:- object(global_omnidyne, extends(entity)).
    :- info([comment is 'Omnidyne Corporation (discussion topic)']).
    desc("Omnidyne Corporation").
    synonym([omnidyne]).
    initial_location(global_objects).
:- end_object.

:- object(global_roses, extends(entity)).
    :- info([comment is 'Global roses reference']).
    desc("roses").
    synonym([roses, garden, rose]).
    adjective([rose]).
    initial_location(global_objects).
:- end_object.

:- object(global_weather, extends(entity)).
    :- info([comment is 'Weather (discussion topic)']).
    desc("weather").
    synonym([weather, climate, wrong, problem]).
    initial_location(global_objects).
:- end_object.

:- object(global_light, extends(entity)).
    :- info([comment is 'Light/sunlight reference']).
    desc("light").
    synonym([light, sunlight]).
    initial_location(global_objects).
:- end_object.

:- object(global_old_will, extends(entity)).
    :- info([comment is 'Current/old will (discussion topic)']).
    desc("present will").
    synonym([will]).
    adjective([current, present, old]).
    initial_location(global_objects).
:- end_object.

:- object(global_new_will, extends(entity)).
    :- info([comment is 'New will (discussion topic)']).
    desc("new will").
    synonym([will]).
    adjective([new]).
    initial_location(global_objects).
:- end_object.

:- object(global_hole, extends(entity)).
    :- info([comment is 'Holes (global reference)']).
    desc("holes").
    synonym([hole, holes]).
    initial_flags([ndescbit]).
    initial_location(global_objects).
:- end_object.

:- object(global_ladder, extends(entity)).
    :- info([comment is 'Ladder (global reference)']).
    synonym([ladder]).
    adjective([wooden]).
    desc("ladder").
    initial_flags([ndescbit]).
    initial_location(global_objects).
:- end_object.

:- object(global_ebullion, extends(entity)).
    :- info([comment is 'Ebullion tablets (global reference)']).
    desc("Ebullion tablets").
    synonym([tablets, ebullion, pills]).
    adjective([ebullion]).
    initial_location(global_objects).
:- end_object.

:- object(global_loblo, extends(entity)).
    :- info([comment is 'LoBlo tablets (global reference)']).
    desc("LoBlo tablets").
    synonym([tablets, loblo, pills]).
    adjective([loblo]).
    initial_location(global_objects).
:- end_object.

:- object(global_meeting, extends(entity)).
    :- info([comment is 'Secret meeting (discussion topic)']).
    desc("meeting").
    synonym([meeting, rendezvous, tryst]).
    adjective([secret, private]).
    initial_location(global_objects).
:- end_object.

:- object(global_call, extends(entity)).
    :- info([comment is 'Telephone call (discussion topic)']).
    desc("telephone conversation").
    synonym([call, conversation, left, right]).
    adjective([telephone, phone]).
    initial_location(global_objects).
:- end_object.

:- object(global_pen, extends(entity)).
    :- info([comment is 'Pen (global reference)']).
    desc("pen").
    synonym([pen]).
    adjective([blue]).
    initial_location(global_objects).
:- end_object.

:- object(global_safe, extends(entity)).
    :- info([comment is 'Safe (global reference)']).
    desc("safe").
    synonym([combination, safe]).
    initial_location(global_objects).
:- end_object.

:- object(global_steven, extends(entity)).
    :- info([comment is 'Steven (Mrs. Robner\'s correspondent)']).
    desc("Steven").
    synonym([steven, steve]).
    initial_location(global_objects).
:- end_object.

:- object(global_room, extends(entity)).
    :- info([comment is 'Room/walls reference']).
    synonym([room, wall, walls]).
    desc("room").
    initial_location(global_objects).
:- end_object.

:- object(global_merger, extends(entity)).
    :- info([comment is 'Omnidyne merger (discussion topic)']).
    synonym([merger]).
    adjective([omnidyne]).
    desc("merger").
    initial_location(global_objects).
:- end_object.

:- object(global_duffy, extends(entity)).
    :- info([comment is 'Sergeant Duffy']).
    synonym([duffy]).
    adjective([sergeant]).
    desc("Sergeant Duffy").
    initial_location(global_objects).
:- end_object.

:- object(global_water, extends(entity)).
    :- info([comment is 'Water reference']).
    desc("water").
    synonym([water]).
    initial_location(global_objects).
:- end_object.

:- object(global_sneezo, extends(entity)).
    :- info([comment is 'Sneezo tablets (global reference)']).
    desc("Sneezo tablets").
    synonym([tablets, sneezo, decong, pills]).
    adjective([decong, sneezo]).
    initial_location(global_objects).
:- end_object.

:- object(global_allergone, extends(entity)).
    :- info([comment is 'Allergone tablets (global reference)']).
    desc("Allergone tablets").
    synonym([tablets, allergone, pills]).
    adjective([allergone]).
    initial_location(global_objects).
:- end_object.

:- object(global_hidden_closet, extends(entity)).
    :- info([comment is 'Hidden closet (global reference)']).
    desc("hidden closet").
    synonym([closet]).
    adjective([hidden]).
    initial_flags([ndescbit]).
    initial_location(global_objects).
:- end_object.

%% ===================================================================
%%  FOYER OBJECTS
%% ===================================================================

:- object(foyer_table, extends(entity), imports([surface, container])).
    :- info([comment is 'Marble-top table in the foyer']).
    desc("marble-top table").
    synonym([table]).
    adjective([marble]).
    initial_flags([ndescbit, openbit, contbit, surfacebit]).
    capacity(40).
    initial_location(foyer).
:- end_object.

:- object(crystal_lamp, extends(entity)).
    :- info([comment is 'Crystal lamp in the foyer']).
    desc("crystal lamp").
    synonym([lamp, chandelier]).
    adjective([fine, crystal]).
    initial_flags([ndescbit]).
    initial_location(foyer).
:- end_object.

%% ===================================================================
%%  LIBRARY - EVIDENCE AND KEY OBJECTS
%% ===================================================================

:- object(library_desk, extends(entity), imports([surface, container])).
    :- info([comment is 'Large executive desk in the library - key evidence location']).
    synonym([desk]).
    adjective([large, executive]).
    desc("desk").
    initial_flags([ndescbit, surfacebit, contbit, openbit]).
    capacity(25).
    initial_location(library).
:- end_object.

:- object(note_paper, extends(entity), imports([takeable, readable])).
    :- info([comment is 'Note pad on the library desk']).
    synonym([pad, paper, notepad]).
    adjective([note, white]).
    fdesc("Lying atop the desk is a pad of white note paper.").
    desc("note pad").
    initial_flags([takebit, readbit, burnbit]).
    initial_location(library_desk).
    read_text("The notepad contains some scrawled figures and the name \"Baxter\" underlined several times.").
:- end_object.

:- object(desk_calendar, extends(entity), imports([takeable, readable])).
    :- info([comment is 'Desk calendar - shows recent appointments']).
    desc("desk calendar").
    synonym([calendar, july]).
    adjective([desk]).
    initial_flags([takebit, readbit, burnbit]).
    initial_location(library_desk).
:- end_object.

:- object(tray, extends(entity), imports([takeable, surface, container])).
    :- info([comment is 'Tea tray beside the library desk - crime scene']).
    desc("tray").
    fdesc("Beside the desk is a large collapsible tray.").
    synonym([tray]).
    adjective([large, collapsible]).
    initial_flags([takebit, contbit, openbit, surfacebit]).
    capacity(40).
    size(40).
    initial_location(library).
:- end_object.

:- object(cup, extends(entity), imports(takeable)).
    :- info([comment is 'Overturned teacup in library - key evidence']).
    synonym([cup, teacup]).
    adjective([tea, beautiful]).
    desc("cup").
    fdesc("Turned onto its side, lying on the floor, is a beautiful teacup.").
    initial_flags([takebit]).
    size(4).
    initial_location(library).
:- end_object.

:- object(saucer, extends(entity), imports(takeable)).
    :- info([comment is 'Overturned saucer in library - key evidence']).
    synonym([saucer]).
    adjective([beautiful]).
    desc("saucer").
    fdesc("Lying on the floor, overturned, is a beautiful saucer.").
    initial_flags([takebit]).
    size(4).
    initial_location(library).
:- end_object.

:- object(trash_basket, extends(entity), imports([takeable, container])).
    :- info([comment is 'Wastepaper basket in library']).
    synonym([basket]).
    adjective([wastep, wicker, trash]).
    desc("wastepaper basket").
    fdesc("Alongside the desk is a wicker wastepaper basket.").
    initial_flags([takebit, openbit, contbit]).
    capacity(15).
    size(10).
    initial_location(library).
:- end_object.

:- object(trash, extends(entity), imports([takeable, readable])).
    :- info([comment is 'Crumpled papers in the wastepaper basket']).
    synonym([trash, papers]).
    adjective([crumpled]).
    desc("bunch of crumpled papers").
    ldesc("Inside the wastepaper basket are some crumpled papers.").
    initial_flags([takebit, readbit]).
    read_text("There are three wads of paper. One is a shopping list. Another is a list \
of current stock prices. The last is the start of a letter to the Board of \
Directors of the Robner Corp. Unfortunately, it does not contain enough \
information to allow even a guess about the intent of the letter.").
    initial_location(trash_basket).
:- end_object.

:- object(library_carpet, extends(entity)).
    :- info([comment is 'Library carpet - fingerprint evidence']).
    synonym([carpet, rug]).
    desc("carpet").
    initial_flags([ndescbit]).
    initial_location(library).
:- end_object.

:- object(pencil, extends(entity), imports(takeable)).
    :- info([comment is 'Pencil near the desk - used to shade note pad']).
    synonym([pencil]).
    desc("pencil").
    fdesc("A pencil is lying on the floor near the desk.").
    initial_flags([takebit]).
    initial_location(library).
:- end_object.

:- object(library_door, extends(entity), imports(readable)).
    :- info([comment is 'The broken library door - evidence of locked-room mystery']).
    desc("oak door").
    synonym([door]).
    adjective([oak, broken]).
    initial_flags([ndescbit]).
    read_text("The door is a magnificent solid oak piece. Its metal bolt is bent and the \
metal piece in which it rested has been sheared off the door frame. It seems \
clear that the door was securely locked from the inside when it was broken down.").
    initial_location(local_globals).
:- end_object.

:- object(library_button, extends(entity)).
    :- info([comment is 'Hidden black button in library - opens hidden door']).
    synonym([button]).
    adjective([black]).
    desc("black button").
    initial_flags([ndescbit, invisible]).
    initial_location(library).
:- end_object.

:- object(mud_spot, extends(entity), imports(readable)).
    :- info([comment is 'Mud spots on library floor - key evidence']).
    desc("mud spots").
    synonym([spot, mark, dirt, mud]).
    adjective([dried]).
    initial_flags([ndescbit, invisible]).
    read_text("The spots, which seem to be dried dirt or mud, are in the area between \
the balcony and the desk.").
    initial_location(library).
:- end_object.

:- object(bookshelves, extends(entity)).
    :- info([comment is 'Bookshelves in the library']).
    synonym([bookshelves, shelves, book, books]).
    adjective([book]).
    desc("set of bookshelves").
    initial_flags([ndescbit]).
    initial_location(library).
:- end_object.

%% ===================================================================
%%  HIDDEN CLOSET OBJECTS
%% ===================================================================

:- object(red_button, extends(entity)).
    :- info([comment is 'Red button in hidden closet']).
    synonym([button]).
    adjective([red]).
    desc("red button").
    initial_flags([ndescbit]).
    initial_location(hidden_closet).
:- end_object.

:- object(blue_button, extends(entity)).
    :- info([comment is 'Blue button in hidden closet']).
    synonym([button]).
    adjective([blue]).
    desc("blue button").
    initial_flags([ndescbit]).
    initial_location(hidden_closet).
:- end_object.

:- object(safe, extends(entity), imports(container)).
    :- info([comment is 'Wall safe in the hidden closet - contains key evidence']).
    desc("safe").
    synonym([combination, safe, door]).
    adjective([safe, wall, large]).
    initial_flags([ndescbit, contbit]).
    capacity(15).
    initial_location(hidden_closet).
:- end_object.

:- object(dust, extends(entity)).
    :- info([comment is 'Dust and cobwebs in the hidden closet']).
    desc("dust and cobwebs").
    synonym([dust, cobwebs]).
    initial_flags([ndescbit]).
    initial_location(hidden_closet).
:- end_object.

%% ===================================================================
%%  KEY EVIDENCE - Documents
%% ===================================================================

:- object(baxter_papers, extends(entity), imports([takeable, readable])).
    :- info([comment is 'Incriminating papers in the safe - key evidence']).
    synonym([stack, papers]).
    fdesc("A stack of papers bound together is in the safe.").
    desc("stack of papers").
    initial_flags([takebit, readbit, burnbit, invisible]).
    initial_location(safe).
    read_text("Leafing through these papers, it becomes obvious that they incriminate Mr. \
Baxter in wrongdoings regarding the Focus scandal. They document funds which were \
embezzled by Baxter and tell how the scandal was hushed up. This evidence would be \
sufficient to convict Mr. Baxter in the Focus case.").
:- end_object.

:- object(new_will, extends(entity), imports([takeable, readable])).
    :- info([comment is 'New will in the safe - key evidence']).
    desc("new will").
    synonym([will]).
    adjective([new]).
    initial_flags([takebit, readbit, burnbit]).
    initial_location(safe).
    read_text("This is Mr. Robner's new will, disowning George and giving his entire \
estate to his wife.").
:- end_object.

:- object(newspaper, extends(entity), imports([takeable, readable])).
    :- info([comment is 'Daily Herald newspaper - arrives at tick 175']).
    fdesc("Leaning against the front door is today's issue of the Daily Herald.").
    desc("Daily Herald").
    synonym([newspaper, herald, section, paper]).
    adjective([daily, front, first]).
    initial_flags([takebit, readbit, burnbit]).
:- end_object.

:- object(second_section, extends(entity), imports(readable)).
    :- info([comment is 'Second section of the newspaper']).
    desc("second section of the Herald").
    synonym([section]).
    adjective([second, back, last]).
    initial_flags([readbit]).
    initial_location(global_objects).
:- end_object.

:- object(envelope, extends(entity), imports([takeable, readable, container])).
    :- info([comment is 'Handwritten envelope - arrives with morning mail']).
    fdesc("A handwritten envelope, recently delivered, is lying on the table.").
    desc("handwritten envelope").
    synonym([envelope]).
    adjective([handwr]).
    initial_flags([takebit, readbit, burnbit, contbit]).
    capacity(2).
    read_text("CANAAN CT POST OFFICE\n* JULY 06 * 08:00 *\n\n\
Mrs. Marshall Robner\n506 Lake View Rd.\nMaitland, Ct.").
:- end_object.

:- object(letter, extends(entity), imports([takeable, readable])).
    :- info([comment is 'Letter from Steven inside the envelope - key evidence']).
    desc("letter").
    synonym([letter]).
    initial_flags([takebit, readbit, burnbit]).
    size(1).
    initial_location(envelope).
    read_text("\"Dear Leslie,\n   I am sorry to learn that Marshall has been despondent \
again. His obsessive interest in business must be causing you terrible anguish. It \
doesn't surprise me that he talks of suicide when he's in this state, but the thought \
of the business going to Baxter after he's gone will keep him alive.\n   So George has \
finally gone too far? It's hard to believe, after all those empty threats, that Marshall \
actually followed through. It serves that little leech right, if you ask me. This means \
that, should the unthinkable happen, you will be provided for as you deserve.\n   I'll \
see you Friday as usual.\n\nLove,\nSteven\"").
:- end_object.

:- object(lab_report, extends(entity), imports([takeable, readable])).
    :- info([comment is 'Lab report - arrives after fragment analysis']).
    desc("lab report").
    synonym([report, paper, note, slip]).
    adjective([lab]).
    initial_flags([takebit, readbit]).
    read_text("Dear Inspector,\n\n   In response to your request for analysis of the \
ceramic fragment, we have found evidence of a drug called Methsparin, which is usually \
sold in this country under the name \"LoBlo\". It is a blood pressure lowering agent \
used primarily in Europe, which explains the oversight in our blood analysis of the \
deceased. A double check reveals a high blood level of Methsparin. While the amount of \
Methsparin in the blood isn't dangerous in itself, a strong reaction between it and \
various other drugs has been well documented. As you may have gathered, one of those \
drugs is Amitraxin (Ebullion). The effect of Methsparin is to displace Amitraxin from \
protein binding, leaving more free in the blood and simulating an overdose.\n   Your \
new evidence leads me to conclude that the cause of death was Amitraxin toxicity \
secondary to ingestion of Methsparin and Amitraxin in combination.\n\nSincerely,\n\
Arthur Chatworth, Pathologist").
:- end_object.

%% ===================================================================
%%  SHED OBJECTS
%% ===================================================================

:- object(ladder, extends(entity), imports(takeable)).
    :- info([comment is 'Wooden ladder in the shed - needed for balcony access']).
    synonym([ladder]).
    adjective([wooden]).
    desc("wooden ladder").
    fdesc("Leaning in a corner is a wooden ladder.").
    initial_flags([takebit, climbbit]).
    size(50).
    initial_location(shed_room).
:- end_object.

:- object(tools_1, extends(entity)).
    :- info([comment is 'Carpentry tools in shed']).
    synonym([tools, saw, hammer, rope]).
    desc("collection of carpentry tools").
    initial_flags([ndescbit]).
    initial_location(shed_room).
:- end_object.

:- object(tools_2, extends(entity)).
    :- info([comment is 'Garden tools in shed']).
    synonym([spade, hoe, rake, hose]).
    desc("collection of garden tools").
    initial_flags([ndescbit, duplicate]).
    initial_location(shed_room).
:- end_object.

:- object(s_shelves, extends(entity), imports([surface, container])).
    :- info([comment is 'Shelves in the shed']).
    synonym([shelves]).
    desc("shelf").
    initial_flags([ndescbit, openbit, contbit, surfacebit]).
    capacity(20).
    initial_location(shed_room).
:- end_object.

%% ===================================================================
%%  ROSE GARDEN OBJECTS
%% ===================================================================

:- object(hole, extends(entity)).
    :- info([comment is 'Holes in the rose garden - key evidence location']).
    desc("holes").
    synonym([hole, holes]).
    adjective([deep]).
    initial_flags([ndescbit, invisible]).
    initial_location(in_roses).
:- end_object.

:- object(fragment, extends(entity), imports(takeable)).
    :- info([comment is 'Porcelain fragment in rose garden hole - key evidence']).
    desc("fragment").
    synonym([piece, porcelain, fragment, shard]).
    initial_flags([invisible, takebit]).
    initial_location(in_roses).
:- end_object.

:- object(sugar_bowl, extends(entity), imports(takeable)).
    :- info([comment is 'Sugar bowl on the library tray - contains LoBlo']).
    desc("sugar bowl").
    fdesc("Sitting on the tray is a bowl containing a white powdery substance.").
    synonym([bowl, sugar, substance, powder]).
    adjective([sugar, white, powder]).
    initial_flags([takebit]).
    initial_location(tray).
:- end_object.

%% ===================================================================
%%  MEDICINE CABINET (DUNBAR'S BATHROOM)
%% ===================================================================

:- object(dunbar_cabinet, extends(entity), imports(container)).
    :- info([comment is "Medicine cabinet in Dunbar's bathroom"]).
    desc("cabinet").
    synonym([cabinet, chest]).
    adjective([medicine]).
    initial_flags([ndescbit, contbit, searchbit]).
    capacity(50).
    initial_location(dunbar_bath).
:- end_object.

:- object(loblo_bottle, extends(entity), imports([takeable, readable, container])).
    :- info([comment is "Bottle of LoBlo in Dunbar's medicine cabinet"]).
    desc("bottle of LoBlo").
    synonym([bottle, loblo, label]).
    adjective([loblo]).
    fdesc("On the bottom shelf is a bottle of tablets labelled 'LoBlo'.").
    initial_flags([takebit, readbit, contbit]).
    capacity(5).
    initial_location(dunbar_cabinet).
    read_text("Frobizz Pharmacy   #69105\n\nMs. S. Dunbar\nLoBLO\n\
Take 1 tablet 3 times daily\n\nFizmo Labs, Ltd. - Kingston, Ont.\n\
LoBLO Brand of Methsparin, USP\n10mg Tablets\n\nWarning: LoBLO may be dangerous \
when used in combination with other medications. Please read the enclosed circular \
prior to using these tablets.").
:- end_object.

:- object(loblo, extends(entity), imports(takeable)).
    :- info([comment is 'LoBlo tablets (the murder weapon ingredient)']).
    desc("couple of LoBLO tablets").
    synonym([couple, tablets, pills, loblo]).
    adjective([loblo]).
    initial_flags([takebit, drugbit]).
    size(4).
    initial_location(loblo_bottle).
:- end_object.

:- object(aspirin_bottle, extends(entity), imports([takeable, readable, container])).
    :- info([comment is "Aspirin bottle in Dunbar's cabinet"]).
    desc("bottle of aspirin").
    fdesc("On the top shelf, among various toilet items, is a bottle of aspirin.").
    synonym([bottle, aspirin, label]).
    adjective([aspirin]).
    initial_flags([takebit, readbit, contbit]).
    capacity(5).
    initial_location(dunbar_cabinet).
    read_text("Generic ASPIRIN, usp\n     30mg / 5 gr").
:- end_object.

:- object(aspirin, extends(entity), imports(takeable)).
    :- info([comment is 'Aspirin tablets']).
    desc("handful of aspirin tablets").
    synonym([pills, tablets, aspirin, handful]).
    adjective([aspirin]).
    initial_flags([takebit, drugbit]).
    size(4).
    initial_location(aspirin_bottle).
:- end_object.

:- object(dum_kof_bottle, extends(entity), imports([takeable, readable, container])).
    :- info([comment is 'Cough medicine bottle in Dunbar\'s cabinet']).
    desc("bottle of cough medicine").
    fdesc("Standing on a shelf beside some nail polish is a bottle of cough medicine.").
    synonym([bottle, medicine, dum_kof, label]).
    adjective([cough]).
    initial_flags([takebit, readbit, contbit]).
    capacity(4).
    initial_location(dunbar_cabinet).
    read_text("General Drug Co.\n        DUM - KOF\n     Cough Supressant\n\n\
Directions:  1 tsp every 3-4 hrs\nWarning:  Take as Directed. May cause sedation \
when taken with other drugs.").
:- end_object.

:- object(dum_kof, extends(entity), imports(takeable)).
    :- info([comment is 'Cough syrup in the bottle']).
    desc("quantity of cough syrup").
    synonym([syrup]).
    adjective([cough]).
    initial_flags([takebit]).
    size(4).
    initial_location(dum_kof_bottle).
:- end_object.

%% ===================================================================
%%  MASTER BATHROOM OBJECTS
%% ===================================================================

:- object(bathtub, extends(entity), imports(container)).
    :- info([comment is 'Bathtub in master bathroom']).
    desc("bathtub").
    synonym([tub, bathtub]).
    adjective([bath]).
    initial_flags([ndescbit, vehbit, openbit, contbit, furniture]).
    capacity(50).
    initial_location(master_bath).
:- end_object.

:- object(master_bath_counter, extends(entity), imports([surface, container])).
    :- info([comment is 'Counter in master bathroom']).
    desc("counter").
    synonym([counter]).
    adjective([long]).
    initial_flags([ndescbit, furniture, surfacebit, contbit, openbit]).
    capacity(50).
    initial_location(master_bath).
:- end_object.

:- object(bathroom_mirror, extends(entity)).
    :- info([comment is 'Mirror in master bathroom']).
    desc("mirror").
    synonym([mirror]).
    initial_flags([ndescbit]).
    initial_location(master_bath).
:- end_object.

:- object(hanging_plants, extends(entity)).
    :- info([comment is 'Hanging plants in master bathroom']).
    desc("hanging plant").
    synonym([plant, plants]).
    adjective([hanging]).
    initial_flags([ndescbit]).
    initial_location(master_bath).
:- end_object.

:- object(sneezo_bottle, extends(entity), imports([takeable, readable, container])).
    :- info([comment is 'Sneezo decongestant bottle on master bath counter']).
    desc("bottle of Sneezo brand decongestant").
    synonym([bottle, decong, sneezo]).
    adjective([bottle, decong, sneezo, brand]).
    fdesc("On the counter is a bottle of Sneezo tablets.").
    initial_flags([takebit, readbit, contbit]).
    capacity(5).
    initial_location(master_bath_counter).
    read_text("Lakeville Pharmacy   #223224\n\nMrs. M. Robner\n\
Take 1 tablet every 3 hours as needed\n\nSniffle Labs\nSneezo Tablets").
:- end_object.

:- object(sneezo, extends(entity), imports(takeable)).
    :- info([comment is 'Sneezo tablets']).
    desc("handful of Sneezo tablets").
    synonym([handful, tablets, decong, sneezo]).
    adjective([decong, sneezo]).
    initial_flags([takebit, drugbit]).
    size(4).
    initial_location(sneezo_bottle).
:- end_object.

:- object(allergone_bottle, extends(entity), imports([takeable, readable, container])).
    :- info([comment is 'Allergone bottle on master bath counter']).
    desc("bottle of Allergone").
    synonym([bottle, allergone]).
    adjective([bottle, allergone]).
    fdesc("Beside a toothbrush is a bottle of Allergone.").
    initial_flags([takebit, readbit, contbit]).
    capacity(5).
    initial_location(master_bath_counter).
    read_text("Lakeville Pharmacy   #220331\n\nMrs. M. Robner\n\
Take 2 tablets every 4 hours as needed for allergy symptoms. Do not exceed \
recommended dosage.\n\nRash Labs / Allergone Tablets\n\nMay cause extreme drowsiness. \
Do not use machinery or drive while taking this medication. Combination of Allergone \
with alcohol is dangerous. In case of overdose consult a physician promptly. Keep out \
of the reach of children!").
:- end_object.

:- object(allergone, extends(entity), imports(takeable)).
    :- info([comment is 'Allergone tablets']).
    desc("bunch of Allergone tablets").
    synonym([bunch, tablets, allergone]).
    adjective([allergone]).
    initial_flags([takebit, drugbit]).
    size(4).
    initial_location(allergone_bottle).
:- end_object.

%% ===================================================================
%%  MASTER BEDROOM OBJECTS
%% ===================================================================

:- object(master_bedroom_dresser, extends(entity), imports(container)).
    :- info([comment is 'Dresser in master bedroom']).
    desc("dresser").
    synonym([dresser]).
    initial_flags([ndescbit, contbit]).
    capacity(30).
    initial_location(master_bedroom).
:- end_object.

:- object(four_poster, extends(entity), imports([surface, container])).
    :- info([comment is 'Four-poster bed in master bedroom']).
    desc("four-poster bed").
    synonym([bed, poster]).
    adjective([four]).
    initial_flags([ndescbit, surfacebit, contbit, openbit, furniture, vehbit]).
    capacity(30).
    initial_location(master_bedroom).
:- end_object.

:- object(lounge, extends(entity)).
    :- info([comment is 'Lounge in master bedroom']).
    desc("lounge").
    synonym([lounge]).
    initial_flags([ndescbit, furniture]).
    initial_location(master_bedroom).
:- end_object.

:- object(bedroom_mirror, extends(entity)).
    :- info([comment is 'Large mirror in master bedroom']).
    desc("large mirror").
    synonym([mirror, frame]).
    adjective([large, gilt]).
    initial_flags([ndescbit]).
    initial_location(master_bedroom).
:- end_object.

%% ===================================================================
%%  LIBRARY MEDICINE
%% ===================================================================

:- object(ebullion_bottle, extends(entity), imports([takeable, readable, container])).
    :- info([comment is 'Ebullion prescription bottle in library - key evidence']).
    desc("bottle of Ebullion").
    synonym([label, bottle, ebullion]).
    adjective([ebullion]).
    initial_flags([takebit, contbit, readbit]).
    capacity(5).
    initial_location(library).
    read_text("Head Drugs     No. 44543\n\nMr. Marshall Robner\n\nEBULLION Tablets, 25mg.\n\n\
Directions: Take 1 or 2 twice daily for depression.\n\nWarning: Keep out of the reach \
of children. May be harmful or fatal in sufficient dosage.").
:- end_object.

:- object(ebullion, extends(entity), imports(takeable)).
    :- info([comment is 'Ebullion tablets (Mr. Robner\'s depression medication)']).
    desc("couple of Ebullion tablets").
    synonym([couple, tablets, ebullion]).
    adjective([ebullion]).
    initial_flags([takebit, drugbit]).
    size(4).
    initial_location(ebullion_bottle).
:- end_object.

%% ===================================================================
%%  GEORGE'S BEDROOM OBJECTS
%% ===================================================================

:- object(liquor_cabinet, extends(entity), imports(container)).
    :- info([comment is "Liquor cabinet in George's room"]).
    desc("liquor cabinet").
    synonym([cabinet]).
    adjective([liquor]).
    initial_flags([ndescbit, contbit, searchbit]).
    capacity(30).
    initial_location(george_room).
:- end_object.

:- object(scotch, extends(entity), imports(takeable)).
    :- info([comment is 'Bottle of Scotch in liquor cabinet']).
    desc("bottle of Scotch").
    fdesc("A half-filled bottle of Scotch is in the cabinet.").
    synonym([bottle, scotch]).
    adjective([scotch]).
    initial_flags([takebit]).
    initial_location(liquor_cabinet).
:- end_object.

:- object(bourbon, extends(entity), imports(takeable)).
    :- info([comment is 'Bottle of Bourbon in liquor cabinet']).
    desc("bottle of Bourbon").
    fdesc("A nearly empty bottle of Bourbon is here.").
    synonym([bottle, bourbon]).
    adjective([bourbon]).
    initial_flags([takebit]).
    initial_location(liquor_cabinet).
:- end_object.

:- object(stereo, extends(entity)).
    :- info([comment is "Stereo in George's room"]).
    desc("stereo").
    synonym([stereo, volume, music, hifi]).
    initial_flags([ndescbit]).
    initial_location(george_room).
:- end_object.

:- object(records, extends(entity)).
    :- info([comment is "Record collection in George's room"]).
    desc("record collection").
    synonym([record]).
    initial_flags([ndescbit]).
    initial_location(george_room).
:- end_object.

:- object(tapes, extends(entity)).
    :- info([comment is "Tape collection in George's room"]).
    desc("tape collection").
    synonym([tape, tapes, cassette]).
    initial_flags([ndescbit]).
    initial_location(george_room).
:- end_object.

:- object(shaving_gear, extends(entity)).
    :- info([comment is "Shaving gear in George's bathroom"]).
    desc("shaving gear").
    synonym([gear, razor, cream]).
    adjective([shaving]).
    initial_flags([ndescbit]).
    initial_location(george_bath).
:- end_object.

%% ===================================================================
%%  DINING ROOM OBJECTS
%% ===================================================================

:- object(seurat, extends(entity)).
    :- info([comment is 'Seurat painting in dining room']).
    desc("Seurat").
    synonym([seurat]).
    initial_flags([ndescbit]).
    initial_location(dining_room).
:- end_object.

:- object(paintings, extends(entity)).
    :- info([comment is 'Collection of paintings in dining room']).
    desc("collection of paintings").
    synonym([painting, collection, picture]).
    adjective([painting]).
    initial_flags([ndescbit]).
    initial_location(dining_room).
:- end_object.

:- object(dining_room_table, extends(entity)).
    :- info([comment is 'Long dining table']).
    desc("long table").
    synonym([table]).
    adjective([long]).
    initial_flags([furniture, ndescbit]).
    initial_location(dining_room).
:- end_object.

:- object(trestle_table, extends(entity)).
    :- info([comment is 'Trestle table in dining room']).
    desc("trestle table").
    synonym([table]).
    adjective([large, trestle]).
    initial_flags([ndescbit]).
    initial_location(dining_room).
:- end_object.

%% ===================================================================
%%  KITCHEN OBJECTS
%% ===================================================================

:- object(cups, extends(entity)).
    :- info([comment is 'Group of antique teacups in kitchen']).
    synonym([group, cups, teacup]).
    adjective([cups, antique, tea]).
    desc("group of cups").
    initial_flags([ndescbit]).
    initial_location(kitchen).
:- end_object.

:- object(saucers, extends(entity)).
    :- info([comment is 'Group of saucers in kitchen']).
    synonym([group, saucer]).
    adjective([saucer, antique]).
    desc("group of saucers").
    initial_flags([ndescbit]).
    initial_location(kitchen).
:- end_object.

:- object(china, extends(entity)).
    :- info([comment is 'Fine china set in kitchen']).
    synonym([china]).
    desc("china").
    initial_flags([ndescbit]).
    initial_location(kitchen).
:- end_object.

:- object(plates, extends(entity)).
    :- info([comment is 'Plates in kitchen']).
    synonym([plate, plates]).
    desc("plates").
    initial_flags([ndescbit]).
    initial_location(kitchen).
:- end_object.

:- object(shelf_unit, extends(entity)).
    :- info([comment is 'Shelf unit with china in kitchen']).
    desc("shelf unit").
    synonym([shelf, unit]).
    adjective([beautiful, shelf]).
    initial_flags([ndescbit]).
    initial_location(kitchen).
:- end_object.

:- object(appliance_1, extends(entity)).
    :- info([comment is 'Kitchen appliances (cooking)']).
    desc("appliance").
    synonym([appliance, oven, stove, refrigerator]).
    initial_flags([ndescbit]).
    initial_location(kitchen).
:- end_object.

:- object(appliance_2, extends(entity)).
    :- info([comment is 'Kitchen appliances (cleaning)']).
    desc("appliance").
    synonym([washer, dishwasher, disposal, compactor]).
    adjective([garbage, dish]).
    initial_flags([ndescbit, duplicate]).
    initial_location(kitchen).
:- end_object.

:- object(k_cabinets, extends(entity), imports(container)).
    :- info([comment is 'Kitchen cabinets']).
    desc("cabinet").
    synonym([cabinet]).
    initial_flags([ndescbit, contbit]).
    capacity(50).
    initial_location(kitchen).
:- end_object.

:- object(silverware, extends(entity)).
    :- info([comment is 'Silverware in kitchen cabinet']).
    desc("set of silverware").
    synonym([silver]).
    initial_flags([trytakebit]).
    initial_location(k_cabinets).
:- end_object.

:- object(glasses, extends(entity)).
    :- info([comment is 'Glass collection in kitchen cabinet']).
    desc("glass collection").
    synonym([glass, glasses, collection]).
    adjective([glass]).
    initial_flags([trytakebit]).
    initial_location(k_cabinets).
:- end_object.

%% ===================================================================
%%  PANTRY OBJECTS
%% ===================================================================

:- object(p_shelves, extends(entity), imports([surface, container])).
    :- info([comment is 'Wooden shelves in pantry']).
    desc("set of wooden shelves").
    synonym([shelves]).
    adjective([wooden]).
    initial_flags([ndescbit, contbit, openbit, surfacebit]).
    capacity(30).
    initial_location(pantry).
:- end_object.

:- object(foods, extends(entity)).
    :- info([comment is 'Food assortment in pantry']).
    desc("food assortment").
    synonym([food, foods, can, cans]).
    adjective([dried, canned, packaged]).
    initial_location(p_shelves).
:- end_object.

%% ===================================================================
%%  LIVING ROOM OBJECTS
%% ===================================================================

:- object(living_room_table, extends(entity), imports([surface, container])).
    :- info([comment is 'Living room table']).
    desc("living room table").
    synonym([table, tables]).
    adjective([living, room]).
    initial_flags([ndescbit, surfacebit, contbit, openbit, furniture]).
    capacity(40).
    initial_location(living_room).
:- end_object.

:- object(fireplace, extends(entity)).
    :- info([comment is 'Fieldstone fireplace in living room']).
    desc("fieldstone fireplace").
    synonym([firepl]).
    adjective([fields]).
    initial_flags([ndescbit]).
    initial_location(living_room).
:- end_object.

:- object(wood_pile, extends(entity)).
    :- info([comment is 'Wood pile by the fireplace']).
    desc("wood pile").
    synonym([pile]).
    adjective([wood]).
    initial_flags([ndescbit]).
    initial_location(living_room).
:- end_object.

:- object(portraits, extends(entity)).
    :- info([comment is 'Collection of portraits in living room']).
    desc("collection of portraits").
    synonym([portraits, collection, picture, painting]).
    adjective([portraits]).
    initial_flags([ndescbit]).
    initial_location(living_room).
:- end_object.

:- object(lr_cabinets, extends(entity)).
    :- info([comment is 'Fine wooden cabinets in living room']).
    desc("fine wooden cabinets").
    synonym([cabinet]).
    adjective([fine, wooden]).
    initial_flags([ndescbit]).
    initial_location(living_room).
:- end_object.

%% ===================================================================
%%  BALCONY / CORRIDOR OBJECTS
%% ===================================================================

:- object(l_railing, extends(entity)).
    :- info([comment is 'Metal railing on library balcony']).
    synonym([railing]).
    adjective([metal]).
    desc("railing").
    initial_flags([ndescbit]).
    initial_location(library_balcony).
:- end_object.

:- object(b_railing, extends(entity)).
    :- info([comment is 'Metal railing on bedroom balcony']).
    synonym([railing]).
    adjective([metal]).
    desc("railing").
    initial_flags([ndescbit]).
    initial_location(bedroom_balcony).
:- end_object.

:- object(l_balcony, extends(entity)).
    :- info([comment is 'Library balcony surface reference']).
    synonym([balcony]).
    desc("balcony").
    initial_flags([ndescbit]).
    initial_location(library_balcony).
:- end_object.

:- object(b_balcony, extends(entity)).
    :- info([comment is 'Bedroom balcony surface reference']).
    synonym([balcony]).
    desc("balcony").
    initial_flags([ndescbit]).
    initial_location(bedroom_balcony).
:- end_object.

:- object(corridor_window, extends(entity)).
    :- info([comment is 'Window at end of 2nd floor corridor']).
    desc("window").
    synonym([window]).
    initial_flags([ndescbit]).
    initial_location(corridor_4).
:- end_object.

:- object(tree_tops, extends(entity)).
    :- info([comment is 'Treetops visible from bedroom balcony']).
    desc("treetop").
    synonym([treetop, top]).
    adjective([tree]).
    initial_flags([ndescbit]).
    initial_location(bedroom_balcony).
:- end_object.

%% ===================================================================
%%  ROURKE BATH OBJECTS
%% ===================================================================

:- object(rourke_shelves, extends(entity), imports([surface, container])).
    :- info([comment is "Shelves in Rourke's bathroom"]).
    desc("shelf").
    synonym([shelves, shelf]).
    initial_flags([ndescbit, contbit, openbit, surfacebit]).
    capacity(30).
    initial_location(rourke_bath).
:- end_object.

%% ===================================================================
%%  CLOSET OBJECTS
%% ===================================================================

:- object(c11_shelves, extends(entity), imports([surface, container])).
    :- info([comment is 'Shelves in south upstairs closet']).
    desc("shelf").
    synonym([shelves, shelf]).
    initial_flags([ndescbit, contbit, openbit, surfacebit]).
    capacity(30).
    initial_location(closet_11).
:- end_object.

:- object(c11_linens, extends(entity)).
    :- info([comment is 'Linens on shelves in closet 11']).
    desc("linens").
    synonym([linens, sheets, linen]).
    initial_flags([ndescbit]).
    initial_location(c11_shelves).
:- end_object.

:- object(uc_shelves, extends(entity), imports([surface, container])).
    :- info([comment is 'Shelves in upstairs closet']).
    desc("shelf").
    synonym([shelves, shelf]).
    initial_flags([ndescbit, contbit, openbit, surfacebit]).
    capacity(30).
    initial_location(upstairs_closet).
:- end_object.

:- object(uc_linens, extends(entity)).
    :- info([comment is 'Linens in upstairs closet']).
    desc("linens").
    synonym([linens, sheets, linen]).
    initial_flags([ndescbit]).
    initial_location(uc_shelves).
:- end_object.

:- object(uc_towels, extends(entity)).
    :- info([comment is 'Towels in upstairs closet']).
    desc("towel").
    synonym([towel, towels]).
    initial_flags([ndescbit]).
    initial_location(uc_shelves).
:- end_object.

%% ===================================================================
%%  MISCELLANEOUS EXTERIOR / SPECIAL OBJECTS
%% ===================================================================

:- object(cornerstone, extends(entity), imports(readable)).
    :- info([comment is 'Cornerstone of the house (east side)']).
    desc("cornerstone").
    ldesc("The ornately carved cornerstone of the house is nearby.").
    synonym([cornerstone, stone]).
    adjective([carved, ornate]).
    initial_flags([readbit]).
    initial_location(east_of_door).
    read_text("DEADLINE: An INTERLOGIC Mystery\n       By Infocom, Inc.\n\
     Marc Blank, Chief Architect\n   Copyright 1982 by Infocom, Inc.\n\
        All rights reserved.\nDEADLINE and INTERLOGIC are trademarks of Infocom, Inc.").
:- end_object.

:- object(berry_bush, extends(entity)).
    :- info([comment is 'Berry bush in the orchard']).
    desc("berry bush").
    synonym([bush]).
    adjective([berry, berrie]).
    initial_flags([ndescbit]).
    initial_location(in_orchard).
:- end_object.

:- object(guest_window, extends(entity)).
    :- info([comment is 'Window in the guest room']).
    desc("window").
    synonym([window]).
    initial_flags([ndescbit]).
    initial_location(guest_room).
:- end_object.

%% ===================================================================
%%  OBJECTS PLACED DYNAMICALLY BY EVENTS
%%  (appear during gameplay via clock events)
%% ===================================================================

:- object(pistol, extends(entity), imports(takeable)).
    :- info([comment is 'Smoking gun - appears near Dunbar\'s body']).
    desc("smoking gun").
    synonym([pistol, gun]).
    adjective([smoking]).
    fdesc("Lying beside the body is a smoking gun.").
    initial_flags([takebit]).
    %% Placed dynamically when Dunbar's suicide is discovered
:- end_object.

:- object(corpse, extends(entity)).
    :- info([comment is 'Body of Ms. Dunbar - placed by event']).
    desc("body of Ms. Dunbar").
    synonym([body, dunbar, corpse, stiff]).
    adjective([ms, bloody]).
    fdesc("Sprawled on the floor is the body of Ms. Dunbar.").
    %% Placed dynamically when Dunbar commits suicide
:- end_object.

:- object(suicide_note, extends(entity), imports([takeable, readable])).
    :- info([comment is "Dunbar's suicide note - placed near her body"]).
    desc("suicide note").
    synonym([note, handwr]).
    adjective([suicide]).
    fdesc("Next to the body, near a pool of blood, is a note.").
    initial_flags([takebit, readbit]).
    read_text("The note is written in thin blue ink in a very unsteady hand and \
is smeared with blood from your touch. It says:\n\n    \"I killed Mr. Robner. \
Please forgive me.\"").
:- end_object.

:- object(pool_of_blood, extends(entity)).
    :- info([comment is "Pool of blood near Dunbar's body"]).
    desc("pool of blood").
    synonym([pool, blood]).
    ldesc("A pool of blood is at the head of the body.").
:- end_object.

:- object(pen, extends(entity), imports(takeable)).
    :- info([comment is 'Blue pen - placed dynamically']).
    desc("blue pen").
    synonym([pen]).
    adjective([blue]).
    initial_flags([takebit]).
    %% Placed dynamically
:- end_object.

%% ===================================================================
%%  GLOBAL/DISCUSSION-ONLY OBJECTS
%% ===================================================================

:- object(global_mr_robner_obj, extends(entity)).
    :- info([comment is 'Mr. Robner as discussion reference']).
    desc("Mr. Robner").
    synonym([robner, father, marshall]).
    adjective([mr, mister]).
    initial_flags([person, ndescbit]).
    initial_location(global_objects).
:- end_object.

:- object(circular, extends(entity)).
    :- info([comment is 'Circular pamphlet (discussion topic)']).
    desc("circular").
    synonym([circular]).
    initial_location(global_objects).
:- end_object.

:- object(today, extends(entity)).
    :- info([comment is '"Today" as a discussion topic']).
    desc("today").
    synonym([today]).
    initial_location(global_objects).
:- end_object.

:- object(global_warrant, extends(entity)).
    :- info([comment is 'Search warrant (discussion topic)']).
    desc("search warrant").
    synonym([warrant]).
    adjective([search]).
    initial_location(global_objects).
:- end_object.

:- object(noon, extends(entity)).
    :- info([comment is 'Noon reference']).
    desc("noontime").
    synonym([noon]).
    initial_location(global_objects).
:- end_object.
