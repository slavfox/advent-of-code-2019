#!/usr/bin/env swipl
:- use_module(library(apply)).
:- use_module(library(lists)).

user:file_search_path(adventofcode, AdventOfCode) :- 
    prolog_load_context(directory, Dir),
    file_directory_name(Dir, AdventOfCode).
:- use_module(adventofcode(helpers/readfile)).


fuel(Mass, Fuel) :-
    X is div(Mass, 3),
    % important change: we now make sure that Fuel is not negative, so that we
    % terminate as soon as possible.
    Fuel is max(X-2, 0).

total_fuel(0, TotalFuel, TotalFuel). 
total_fuel(Mass, AccumulatedFuel, TotalFuel) :-
    fuel(Mass, Fuel),
    Accum is AccumulatedFuel + Fuel,
    total_fuel(Fuel, Accum, TotalFuel).

total_fuel(Mass, Fuel) :- 
    total_fuel(Mass, 0, Fuel).


:- initialization(main, main).
main([InputFile]) :-
    read_numbers(InputFile, Numbers),
    maplist(total_fuel, Numbers, Fuel),
    sum_list(Fuel, Sum),
    write(Sum).
