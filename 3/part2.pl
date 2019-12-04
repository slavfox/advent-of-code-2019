#!/usr/bin/env swipl

:- use_module(library(apply)).
:- use_module(library(csv)).
:- use_module(wires).


:- initialization(main, main).
main([InputFile]) :-
    findall(Row, csv_read_file_row(InputFile, Row, []), [Row1, Row2]),
    Row1 =.. [_|Atoms1],
    Row2 =.. [_|Atoms2],
    maplist(atom_direction, Atoms1, Dirs1),
    maplist(atom_direction, Atoms2, Dirs2),
    segments_distance_travelled(Dirs1, Segments1),
    segments_distance_travelled(Dirs2, Segments2),
    intersections(Segments1, Segments2, Intersections),
    closest_point(Intersections, Result),
    write(Result).
