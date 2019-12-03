#!/usr/bin/env swipl
:- use_module(library(apply)).
:- use_module(library(csv)).
:- use_module(library(lists)).


direction(Atom, [Direction, Distance]) :-
    atom_chars(Atom, [Direction|DistanceChars]),
    number_chars(Distance, DistanceChars).


move('U', [StartX, StartY], [StartX, EndY]) :-
    EndY is StartY + 1.
move('D', [StartX, StartY], [StartX, EndY]) :-
    EndY is StartY - 1.
move('L', [StartX, StartY], [EndX, StartY]) :-
    EndX is StartX - 1.
move('R', [StartX, StartY], [EndX, StartY]) :-
    EndX is StartX + 1.


visited_cells([], _, V, V).
% If there's 0 distance left, drop the direction and parse the next one
visited_cells([[_, 0] | Xs], P, A, V) :- 
    visited_cells(Xs, P, A, V).
% If there's distance left, move in that direction and add the new point to the visited list.
visited_cells([[Dir, Dist] | Dirs], Pos, Accumulator, Visited) :-
    Dist > 0,
    move(Dir, Pos, NewPos),
    Remaining is Dist - 1,
    visited_cells(
        [[Dir, Remaining] | Dirs], 
        NewPos, 
        [NewPos | Accumulator], 
        Visited
    ).
visited_cells([[Dir, Dist] | Dirs], Visited) :-
    visited_cells([[Dir, Dist] | Dirs], [0, 0], [], Visited).

manhattan([X, Y], Distance) :-
    Distance is abs(X) + abs(Y).

:- initialization(main, main).
main([InputFile]) :-
    % read data
    findall(Row, csv_read_file_row(InputFile, Row, []), [Row1, Row2]),
    Row1 =.. [_|Atoms1],
    Row2 =.. [_|Atoms2],
    maplist(direction, Atoms1, Directions1),
    maplist(direction, Atoms2, Directions2),
    % Build a (massive) list of all points that have a wire
    visited_cells(Directions1, Visited1),
    visited_cells(Directions2, Visited2),
    % Find the intersections
    list_to_set(Visited1, Set1),
    list_to_set(Visited2, Set2),
    intersection(Set1, Set2, Intersections),
    % Get a distance for each one
    maplist(manhattan, Intersections, Distances),
    % Print out the smallest one
    min_list(Distances, Nearest),
    write(Nearest).
    
    
