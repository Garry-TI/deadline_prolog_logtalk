%%%  rooms.lgt  %%%
%%%
%%%  All 30 room prototypes for Deadline.
%%%  Translated from dungeon.zil ROOM definitions.
%%%
%%%  Each room is a Logtalk prototype that extends the abstract 'room' class.
%%%  Exits are encoded as exit(Direction, Target, Condition) predicates.
%%%
%%%  ZIL source: dungeon.zil (ROOM blocks, lines 46-838)
%%%
%%%  Copyright 1982 Infocom, Inc. (original game)
%%%  Logtalk refactoring: see CLAUDE.md

%% ===================================================================
%%  EXTERIOR — Grounds of Robner Estate
%% ===================================================================

:- object(south_lawn, extends(room)).
    :- info([comment is 'South Lawn — starting location']).
    desc("South Lawn").
    ldesc("You are on a wide lawn just north of the entrance to the Robner \
estate. Directly north at the end of a pebbled path is the Robner house, \
flanked to the northeast and northwest by a vast expanse of well-kept lawn. \
Beyond the house can be seen the lakefront.").
    synonym([lawn]).
    adjective([south]).
    initial_flags([rlandbit, onbit]).
    exit(north, front_path, always).
    exit(south, none, "Leaving the estate would mean quitting the case and, \
most probably, your job.").
    exit(nw, west_lawn, always).
    exit(ne, east_lawn, always).
    global_objects([lawn, house]).
    line(2).
    station(front_path).
:- end_object.

:- object(front_path, extends(room)).
    :- info([comment is 'Front Path — leads to front door']).
    desc("Front Path").
    synonym([path]).
    adjective([front]).
    initial_flags([rlandbit, onbit]).
    exit(in, foyer, [door, front_door, open]).
    exit(north, foyer, [door, front_door, open]).
    exit(south, south_lawn, always).
    exit(se, south_lawn, always).
    exit(sw, south_lawn, always).
    exit(west, west_of_door, always).
    exit(east, east_of_door, always).
    global_objects([house, front_door]).
    line(2).
    station(front_path).
:- end_object.

:- object(west_of_door, extends(room)).
    :- info([comment is 'West of Front Door']).
    desc("West of Front Door").
    ldesc("You are in front of the Robner house just west of the front door. \
To the north is a large bay window through which can be seen part of the \
living room. To the northwest is the west side of the house.").
    initial_flags([rlandbit, onbit]).
    exit(north, living_room, [door, bay_window, open]).
    exit(ne, living_room, [door, bay_window, open]).
    exit(east, front_path, always).
    exit(west, west_lawn, always).
    exit(south, south_lawn, always).
    exit(se, south_lawn, always).
    exit(sw, south_lawn, always).
    exit(nw, west_side, always).
    global_objects([bay_window, house]).
    line(2).
    station(west_of_door).
:- end_object.

:- object(east_of_door, extends(room)).
    :- info([comment is 'East of Front Door']).
    desc("East of Front Door").
    ldesc("You are in front of the Robner house just east of the front door. \
A small window, closed and securely locked, is the only thing of note here. \
To the northeast is the east side of the house.").
    initial_flags([rlandbit, onbit]).
    exit(north, none, "The window is closed and locked.").
    exit(west, front_path, always).
    exit(east, east_lawn, always).
    exit(south, south_lawn, always).
    exit(se, south_lawn, always).
    exit(sw, south_lawn, always).
    exit(ne, east_side, always).
    global_objects([window, house]).
    line(2).
    station(east_of_door).
:- end_object.

:- object(west_lawn, extends(room)).
    :- info([comment is 'West Lawn']).
    desc("West Lawn").
    ldesc("This is a sprawling lawn west of the Robner house. To the west and \
north is the lake shore. To the northeast is a rose garden, and to the south \
another wide lawn.").
    synonym([lawn]).
    adjective([west]).
    initial_flags([rlandbit, onbit]).
    exit(north, none, "You can't go into the lake.").
    exit(nw, none, "You can't go into the lake.").
    exit(west, none, "You can't go into the lake.").
    exit(ne, rose_garden, always).
    exit(east, west_side, always).
    exit(se, west_of_door, always).
    exit(south, south_lawn, always).
    global_objects([lawn, house, lake]).
    line(2).
    station(west_lawn).
:- end_object.

:- object(east_lawn, extends(room)).
    :- info([comment is 'East Lawn']).
    desc("East Lawn").
    ldesc("You are on a neatly manicured lawn, east of the house, which \
extends north and east to the shore of a lake. To the northwest is a peaceful \
orchard, and toward the south another wide lawn. Southeast, beside the lake, \
is a small shed with a solitary dirty window.").
    synonym([lawn]).
    adjective([east]).
    initial_flags([rlandbit, onbit]).
    exit(north, none, "You can't go into the lake.").
    exit(ne, none, "You can't go into the lake.").
    exit(east, none, "You can't go into the lake.").
    exit(nw, orchard, always).
    exit(west, east_side, always).
    exit(sw, east_of_door, always).
    exit(south, south_lawn, always).
    exit(se, shed_room, always).
    exit(in, shed_room, always).
    global_objects([house, lawn, shed, lake, shed_window]).
    line(2).
    station(east_lawn).
:- end_object.

:- object(east_side, extends(room)).
    :- info([comment is 'East Side of House']).
    desc("East Side of House").
    ldesc("There are no windows or entries of any kind here at the east side \
of the house. To the north is the orchard, and the front lawn lies to the \
south. A lawn also slopes down toward the shore of a lake to the east.").
    initial_flags([rlandbit, onbit]).
    exit(north, orchard, always).
    exit(ne, east_lawn, always).
    exit(south, east_of_door, always).
    exit(se, east_lawn, always).
    exit(east, east_lawn, always).
    exit(west, none, "You can't enter the house here.").
    global_objects([house]).
    line(2).
    station(east_side).
:- end_object.

:- object(west_side, extends(room)).
    :- info([comment is 'West Side of House']).
    desc("West Side of House").
    ldesc("There are no doors or windows at ground level here on the west side \
of the house. A beautiful rose garden, separated by a tall fence, lies to the \
north, and the front of the house is to your south. A large lawn bordering the \
lake lies to the west.").
    initial_flags([rlandbit, onbit]).
    exit(sw, west_lawn, always).
    exit(west, west_lawn, always).
    exit(nw, west_lawn, always).
    exit(north, none, "A fence prevents your mucking up the rose garden.").
    exit(se, west_of_door, always).
    exit(south, west_of_door, always).
    exit(east, none, "You can't enter the house here.").
    global_objects([house]).
    line(2).
    station(west_side).
:- end_object.

:- object(shed_room, extends(room)).
    :- info([comment is 'Shed — garden tool storage']).
    desc("Shed").
    ldesc("This small garden shed is filled with implements of gardening and \
lawn care. Shelves filled with various tools line the walls and a filthy window \
looks out on the lawn.").
    synonym([shed, cabin]).
    adjective([tool, garden, wooden]).
    initial_flags([rlandbit, onbit]).
    exit(out, east_lawn, always).
    exit(north, east_lawn, always).
    exit(nw, east_lawn, always).
    global_objects([shed, shed_window]).
    line(2).
    station(east_lawn).
:- end_object.

:- object(behind_shed, extends(room)).
    :- info([comment is 'Behind the Shed']).
    desc("Behind the Shed").
    ldesc("You are now between the shed and the lake, a position invisible from \
the house or the adjacent lawns. There are no windows here, but you can easily \
enter the shed via the door around the corner.").
    initial_flags([rlandbit, onbit]).
    exit(out, east_lawn, always).
    exit(in, shed_room, always).
    exit(east, none, "You can't go into the lake.").
    exit(west, east_lawn, always).
    exit(north, east_lawn, always).
    exit(south, south_lawn, always).
    global_objects([shed]).
    line(2).
    station(east_lawn).
:- end_object.

:- object(rose_garden, extends(room)).
    :- info([comment is 'Garden Path — rose garden entrance']).
    desc("Garden Path").
    synonym([path]).
    adjective([garden, rose, flower]).
    initial_flags([rlandbit, onbit]).
    exit(north, north_lawn, always).
    exit(ne, north_lawn, always).
    exit(nw, north_lawn, always).
    exit(sw, west_lawn, always).
    exit(west, west_lawn, always).
    exit(east, orchard, always).
    exit(south, in_roses, always).
    exit(se, in_roses, always).
    global_objects([rose, house, dining_room_window]).
    line(2).
    station(rose_garden).
:- end_object.

:- object(in_roses, extends(room)).
    :- info([comment is 'Among the Roses — key evidence location']).
    desc("Among the Roses").
    initial_flags([rlandbit, onbit]).
    exit(up, library_balcony, [flag, ladder_flag]).
    exit(north, rose_garden, always).
    exit(ne, rose_garden, always).
    exit(nw, rose_garden, always).
    exit(west, west_lawn, always).
    exit(east, in_orchard, always).
    exit(south, none, "You can't enter the house here.").
    global_objects([dining_room_window, house, rose, balcony]).
    line(2).
    station(rose_garden).
:- end_object.

:- object(orchard, extends(room)).
    :- info([comment is 'Orchard Path']).
    desc("Orchard Path").
    ldesc("You are on a path at the edge of a small orchard of fruit trees \
which abuts the eastern side of the back of the house. The orchard is obviously \
intended more to display the beauty of the blossoms in spring than to produce \
significant amounts of fruit. The windows of the kitchen look out onto the \
orchard, although your view of them is blocked by the trees and a small grape \
arbor. To the west is a path along a rose garden, and lawns sweep out to the \
north and east.").
    synonym([path]).
    adjective([orchard]).
    initial_flags([rlandbit, onbit]).
    exit(east, east_lawn, always).
    exit(se, east_lawn, always).
    exit(north, north_lawn, always).
    exit(nw, north_lawn, always).
    exit(ne, north_lawn, always).
    exit(west, rose_garden, always).
    exit(south, in_orchard, always).
    exit(sw, in_orchard, always).
    global_objects([kitchen_window, house, fruit_trees]).
    line(2).
    station(orchard).
:- end_object.

:- object(in_orchard, extends(room)).
    :- info([comment is 'In the Orchard']).
    desc("In the Orchard").
    initial_flags([rlandbit, onbit]).
    exit(north, orchard, always).
    exit(west, in_roses, always).
    exit(nw, orchard, always).
    exit(ne, orchard, always).
    exit(up, bedroom_balcony, [flag, ladder_flag_2]).
    exit(south, east_side, always).
    global_objects([kitchen_window, house, fruit_trees, balcony]).
    line(2).
    station(orchard).
:- end_object.

:- object(north_lawn, extends(room)).
    :- info([comment is 'North Lawn']).
    desc("North Lawn").
    ldesc("This idyllic spot lies on a jut of land well north of the house and \
is surrounded on three sides by lake shore. Its charm includes the sweet smell \
of roses blown on a southwest breeze from the rose garden and by the sound of \
the leaves rustling in the orchard to the southeast.").
    synonym([lawn]).
    adjective([north]).
    initial_flags([rlandbit, onbit]).
    exit(ne, none, "You can't go into the lake.").
    exit(nw, none, "You can't go into the lake.").
    exit(north, none, "You can't go into the lake.").
    exit(east, none, "You can't go into the lake.").
    exit(west, none, "You can't go into the lake.").
    exit(sw, rose_garden, always).
    exit(se, orchard, always).
    exit(south, rose_garden, always).
    global_objects([lawn, house, lake]).
    line(2).
    station(north_lawn).
:- end_object.

%% ===================================================================
%%  FIRST FLOOR — Robner House Interior
%% ===================================================================

:- object(foyer, extends(room)).
    :- info([comment is 'Foyer — house entrance']).
    desc("Foyer").
    synonym([foyer]).
    initial_flags([rlandbit, onbit]).
    exit(south, front_path, [door, front_door, open]).
    exit(north, nfoyer, always).
    exit(out, front_path, [door, front_door, open]).
    global_objects([front_door]).
    line(1).
    station(foyer).
:- end_object.

:- object(nfoyer, extends(room)).
    :- info([comment is 'North of Foyer — hallway']).
    desc("North of Foyer").
    ldesc("This is a hallway north of the foyer. To the west is an open \
doorway, and to the east is the foot of a staircase. The hall continues north.").
    initial_flags([rlandbit, onbit]).
    exit(south, foyer, always).
    exit(west, living_room, always).
    exit(east, stair_bottom, always).
    exit(north, corner, always).
    line(1).
    station(nfoyer).
:- end_object.

:- object(living_room, extends(room)).
    :- info([comment is 'Living Room']).
    desc("Living Room").
    synonym([room]).
    adjective([living]).
    initial_flags([rlandbit, onbit]).
    exit(east, nfoyer, always).
    exit(out, nfoyer, always).
    exit(south, west_of_door, [door, bay_window, open]).
    global_objects([bay_window, telephone, sofa, chair, lgtable]).
    line(1).
    station(nfoyer).
:- end_object.

:- object(corner, extends(room)).
    :- info([comment is 'Corner — hallway junction']).
    desc("Corner").
    ldesc("You are at the corner of two halls, one a short hallway to the west \
ending with a set of doors, and the other a long hall leading south toward the \
front door. To the north are swinging double doors leading into the kitchen.").
    initial_flags([rlandbit, onbit]).
    exit(south, nfoyer, always).
    exit(west, dining_room, always).
    exit(north, kitchen, always).
    line(3).
    station(corner).
:- end_object.

:- object(dining_room, extends(room)).
    :- info([comment is 'Dining Room']).
    desc("Dining Room").
    ldesc("You have entered the dining room. A long table seating twelve is in \
the center of the room and a large trestle table is against the south wall. A \
large picture window to the north allows a view of the rose garden. Hanging on \
the wall are several cheerful paintings, including one by Seurat which appears \
to be an original.").
    synonym([room]).
    adjective([dining]).
    initial_flags([rlandbit, onbit]).
    exit(east, corner, always).
    exit(out, corner, always).
    global_objects([dining_room_window]).
    line(3).
    station(dining_room).
:- end_object.

:- object(kitchen, extends(room)).
    :- info([comment is 'Kitchen']).
    desc("Kitchen").
    synonym([kitchen]).
    initial_flags([rlandbit, onbit]).
    ldesc("This is the Robner kitchen, quite large and with a full complement \
of appliances and labor-saving devices. On one wall, a beautifully-crafted \
shelf unit contains rare china, a unique hand-painted family heirloom depicting \
scenes from Greek mythology. The china consists of many place settings of \
plates, teacups, and saucers. There are several cabinets which likely contain \
silverware, glasses, and the like. To the east is a pantry.").
    exit(south, corner, always).
    exit(east, pantry, always).
    global_objects([kitchen_window, sink]).
    line(3).
    station(kitchen).
:- end_object.

:- object(pantry, extends(room)).
    :- info([comment is 'Pantry']).
    desc("Pantry").
    synonym([pantry]).
    initial_flags([rlandbit, onbit]).
    ldesc("This is the pantry with shelves containing a large selection of \
canned and packaged foods, such as fruits, vegetables, and dry goods.").
    exit(west, kitchen, always).
    line(3).
    station(pantry).
:- end_object.

:- object(shall_1, extends(room)).
    :- info([comment is 'South Hallway (west section)']).
    desc("South Hallway").
    initial_flags([rlandbit, onbit]).
    exit(east, shall_2, always).
    exit(north, stair_bottom, always).
    exit(south, rourke_room, [door, rourke_door, open]).
    global_objects([rourke_door]).
    line(1).
    station(shall_1).
:- end_object.

:- object(shall_2, extends(room)).
    :- info([comment is 'South Hallway (east section)']).
    desc("South Hallway").
    initial_flags([rlandbit, onbit]).
    exit(east, rourke_bath, [door, rourke_bath_door, open]).
    exit(west, shall_1, always).
    exit(south, south_closet, [door, south_closet_door, open]).
    global_objects([rourke_bath_door, south_closet_door]).
    line(1).
    station(shall_2).
:- end_object.

:- object(rourke_room, extends(room)).
    :- info([comment is "Mrs. Rourke's Room"]).
    desc("Mrs. Rourke's Room").
    synonym([bedroom, room]).
    adjective([rourke]).
    initial_flags([rlandbit, onbit]).
    exit(north, shall_1, [door, rourke_door, open]).
    exit(out, shall_1, [door, rourke_door, open]).
    global_objects([rourke_door, end_table, chair, bed, window]).
    line(1).
    station(shall_1).
:- end_object.

:- object(rourke_bath, extends(room)).
    :- info([comment is "Mrs. Rourke's Bathroom"]).
    desc("Mrs. Rourke's Bathroom").
    initial_flags([rlandbit, onbit]).
    exit(west, shall_2, [door, rourke_bath_door, open]).
    global_objects([rourke_bath_door, toilet, shower, sink]).
    line(1).
    station(shall_2).
:- end_object.

:- object(south_closet, extends(room)).
    :- info([comment is 'South Closet']).
    desc("South Closet").
    ldesc("This is a little-used storage closet containing odds and ends of no \
interest whatsoever. The exit is to the north.").
    synonym([closet]).
    adjective([south]).
    initial_flags([rlandbit, onbit]).
    exit(north, shall_2, [door, south_closet_door, open]).
    exit(out, shall_2, [door, south_closet_door, open]).
    global_objects([south_closet_door, closet]).
    line(1).
    station(shall_2).
:- end_object.

:- object(stair_bottom, extends(room)).
    :- info([comment is 'Bottom of Stairs']).
    desc("Bottom of Stairs").
    ldesc("You are at the foot of the stairs to the second floor. Open archways \
lead west and south.").
    initial_flags([rlandbit, onbit]).
    exit(up, stairs, always).
    exit(south, shall_1, always).
    exit(west, nfoyer, always).
    global_objects([stairs]).
    line(1).
    station(stair_bottom).
:- end_object.

%% ===================================================================
%%  STAIRCASE
%% ===================================================================

:- object(stairs, extends(room)).
    :- info([comment is 'Stairs — mid-landing']).
    desc("Stairs").
    ldesc("You are on a landing halfway up the flight of stairs. You notice \
that the stairs do indeed make quite a noise when stepped upon.").
    synonym([stairs]).
    initial_flags([rlandbit, onbit]).
    exit(up, stair_top, always).
    exit(down, stair_bottom, always).
    global_objects([stairs]).
    line(1).
    station(stairs).
:- end_object.

%% ===================================================================
%%  SECOND FLOOR — Robner House
%% ===================================================================

:- object(stair_top, extends(room)).
    :- info([comment is 'Top of Stairs']).
    desc("Top of Stairs").
    ldesc("You are at the top of the staircase where short hallways run north \
and south and a corridor the length of the house heads west.").
    initial_flags([rlandbit, onbit]).
    exit(down, stairs, always).
    exit(north, north_hall, always).
    exit(south, shall_11, always).
    exit(west, corridor_1, always).
    global_objects([stairs]).
    line(0).
    station(stair_top).
:- end_object.

:- object(corridor_1, extends(room)).
    :- info([comment is 'Hallway (east section, 2nd floor)']).
    desc("Hallway").
    initial_flags([rlandbit, onbit]).
    exit(east, stair_top, always).
    exit(west, corridor_2, always).
    exit(south, dunbar_room, [door, dunbar_door, open]).
    exit(north, master_bedroom, [door, master_bedroom_door, open]).
    global_objects([dunbar_door, master_bedroom_door]).
    line(0).
    station(corridor_1).
:- end_object.

:- object(corridor_2, extends(room)).
    :- info([comment is 'Hallway (middle, 2nd floor) — linen closet']).
    desc("Hallway").
    ldesc("This is approximately the middle of the corridor, a convenient place \
for a closet full of linens. Stairs to the east and a window to the west are \
about equidistant. The closet, to the north, is open and rather shallow.").
    initial_flags([rlandbit, onbit]).
    exit(north, upstairs_closet, always).
    exit(east, corridor_1, always).
    exit(west, corridor_3, always).
    global_objects([closet]).
    line(0).
    station(corridor_2).
:- end_object.

:- object(corridor_3, extends(room)).
    :- info([comment is 'Hallway (west section, 2nd floor)']).
    desc("Hallway").
    initial_flags([rlandbit, onbit]).
    exit(east, corridor_2, always).
    exit(west, corridor_4, always).
    exit(south, george_room, [door, george_door, open]).
    global_objects([george_door]).
    line(0).
    station(corridor_3).
:- end_object.

:- object(corridor_4, extends(room)).
    :- info([comment is 'End of Hallway (2nd floor) — library entrance']).
    desc("End of Hallway").
    initial_flags([rlandbit, onbit]).
    exit(east, corridor_3, always).
    exit(west, none, "The hall ends here.").
    exit(north, library, always).
    global_objects([library_door]).
    line(0).
    station(corridor_4).
:- end_object.

:- object(library, extends(room)).
    :- info([comment is 'Library — crime scene']).
    desc("Library").
    synonym([library]).
    initial_flags([rlandbit, onbit]).
    exit(east, hidden_closet, [door, hidden_door_l, open]).
    exit(south, corridor_4, always).
    exit(north, library_balcony, [door, library_balcony_door, open]).
    global_objects([hidden_door_l, library_balcony_door, telephone, library_door]).
    line(0).
    station(library).
:- end_object.

:- object(library_balcony, extends(room)).
    :- info([comment is 'Library Balcony — overlooking rose garden']).
    desc("Library Balcony").
    synonym([balcony]).
    adjective([library]).
    initial_flags([rlandbit, onbit]).
    exit(south, library, [door, library_balcony_door, open]).
    exit(down, in_roses, [flag, ladder_flag],
         "The fall would probably kill you.").
    global_objects([library_balcony_door]).
    line(0).
    station(library_balcony).
:- end_object.

:- object(upstairs_closet, extends(room)).
    :- info([comment is 'Upstairs Closet — linen storage']).
    desc("Upstairs Closet").
    ldesc("The closet is rather shallow and has some shelves full of assorted \
linens, towels, and uninteresting toilet articles.").
    synonym([closet]).
    adjective([upstairs]).
    initial_flags([rlandbit, onbit]).
    exit(out, corridor_2, always).
    exit(south, corridor_2, always).
    global_objects([closet]).
    line(0).
    station(corridor_2).
:- end_object.

:- object(hidden_closet, extends(room)).
    :- info([comment is 'Hidden Closet — secret passage']).
    desc("Hidden Closet").
    synonym([closet]).
    adjective([hidden]).
    initial_flags([rlandbit, onbit]).
    exit(east, master_bedroom, [door, hidden_door_b, open]).
    exit(west, library, [door, hidden_door_l, open]).
    global_objects([hidden_door_b, hidden_door_l, closet]).
    line(0).
    station(library).
:- end_object.

:- object(master_bedroom, extends(room)).
    :- info([comment is 'Master Bedroom — Robners\' room']).
    desc("Master Bedroom").
    synonym([bedroom, room]).
    adjective([master, robner]).
    initial_flags([rlandbit, onbit]).
    exit(west, hidden_closet, [door, hidden_door_b, open]).
    exit(north, bedroom_balcony, [door, bedroom_balcony_door, open]).
    exit(south, corridor_1, [door, master_bedroom_door, open]).
    exit(east, master_bath, always).
    global_objects([hidden_door_b, bedroom_balcony_door, master_bedroom_door,
                    end_table, chair, telephone]).
    line(0).
    station(corridor_1).
:- end_object.

:- object(master_bath, extends(room)).
    :- info([comment is 'Master Bathroom']).
    desc("Master Bathroom").
    ldesc("This is Mr. and Mrs. Robner's private bathroom, accessible only from \
the bedroom through a door to the west. On one wall is a mirror over a long \
counter containing two sinks, and in addition to the usual bathroom fixtures is \
a jacuzzi. Hanging plants give the room an almost tropical atmosphere.").
    synonym([bath, bathroom]).
    adjective([master]).
    initial_flags([rlandbit, onbit]).
    exit(west, master_bedroom, always).
    exit(out, master_bedroom, always).
    global_objects([shower, toilet, sink]).
:- end_object.

:- object(bedroom_balcony, extends(room)).
    :- info([comment is 'Bedroom Balcony']).
    desc("Bedroom Balcony").
    synonym([balcony]).
    adjective([bedroom]).
    initial_flags([rlandbit, onbit]).
    exit(south, master_bedroom, [door, bedroom_balcony_door, open]).
    exit(down, in_orchard, [flag, ladder_flag_2],
         "The jump is inadvisable.").
    global_objects([bedroom_balcony_door]).
:- end_object.

:- object(north_hall, extends(room)).
    :- info([comment is 'North Upstairs Hall']).
    desc("North Upstairs Hall").
    ldesc("This is the end of a short north-south hallway. To the east is a \
small room.").
    initial_flags([rlandbit, onbit]).
    exit(east, guest_room, always).
    exit(south, stair_top, always).
    line(0).
    station(stair_top).
:- end_object.

:- object(guest_room, extends(room)).
    :- info([comment is 'Guest Room']).
    desc("Guest Room").
    ldesc("This room contains the bare essentials for a guest room: bed, \
tables, and a chair. A window looks out toward the east.").
    initial_flags([rlandbit, onbit]).
    exit(west, north_hall, always).
    global_objects([end_table, chair, bed]).
    line(0).
    station(stair_top).
:- end_object.

:- object(shall_11, extends(room)).
    :- info([comment is 'South Upstairs Hall (west)']).
    desc("South Upstairs Hall").
    initial_flags([rlandbit, onbit]).
    exit(north, stair_top, always).
    exit(east, shall_12, always).
    exit(south, dunbar_bath, [door, dunbar_bath_door, open]).
    global_objects([dunbar_bath_door]).
    line(0).
    station(shall_11).
:- end_object.

:- object(shall_12, extends(room)).
    :- info([comment is 'End of South Hall (2nd floor)']).
    desc("End of South Hall").
    ldesc("The hall ends here. To the south is a walk-in closet.").
    initial_flags([rlandbit, onbit]).
    exit(west, shall_11, always).
    exit(south, closet_11, always).
    exit(in, closet_11, always).
    line(0).
    station(shall_12).
:- end_object.

:- object(closet_11, extends(room)).
    :- info([comment is 'Large upstairs closet']).
    desc("Closet").
    ldesc("This large closet has many shelves containing various cleaning \
equipment and supplies.").
    initial_flags([rlandbit, onbit]).
    exit(out, shall_12, always).
    exit(north, shall_12, always).
    global_objects([closet]).
:- end_object.

:- object(dunbar_bath, extends(room)).
    :- info([comment is "Dunbar's Bathroom"]).
    desc("Dunbar's Bathroom").
    synonym([bathroom, bath]).
    adjective([dunbar]).
    initial_flags([rlandbit, onbit]).
    exit(north, shall_11, [door, dunbar_bath_door, open]).
    global_objects([dunbar_bath_door, shower, toilet, sink]).
    line(0).
    station(shall_11).
:- end_object.

:- object(dunbar_room, extends(room)).
    :- info([comment is "Dunbar's Bedroom"]).
    desc("Dunbar's Bedroom").
    synonym([bedroom, room]).
    adjective([dunbar]).
    initial_flags([rlandbit, onbit]).
    exit(north, corridor_1, [door, dunbar_door, open]).
    global_objects([dunbar_door, end_table, chair, bed]).
    line(0).
    station(corridor_1).
:- end_object.

:- object(george_bath, extends(room)).
    :- info([comment is "George's Bathroom"]).
    desc("George's Bathroom").
    synonym([bathroom, room]).
    adjective([george]).
    initial_flags([rlandbit, onbit]).
    exit(west, george_room, [door, george_bath_door, open]).
    global_objects([george_bath_door, toilet, shower, sink]).
    line(0).
    station(corridor_3).
:- end_object.

:- object(george_room, extends(room)).
    :- info([comment is "George's Bedroom"]).
    desc("George's Bedroom").
    synonym([bedroom, room]).
    adjective([george]).
    initial_flags([rlandbit, onbit]).
    exit(north, corridor_3, [door, george_door, open]).
    exit(east, george_bath, [door, george_bath_door, open]).
    global_objects([george_door, george_bath_door, end_table, chair, bed]).
    line(0).
    station(corridor_3).
:- end_object.

%% ===================================================================
%%  SPECIAL ROOM — Debug/Kludge
%% ===================================================================

:- object(xxx, extends(room)).
    :- info([comment is 'Internal kludge room (not accessible in normal play)']).
    desc("X").
    fdesc("FROB").
:- end_object.
