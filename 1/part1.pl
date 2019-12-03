#!/usr/bin/env swipl
% Library imports
:- use_module(library(apply)).
:- use_module(library(lists)).

% Helpers boilerplate
user:file_search_path(adventofcode, AdventOfCode) :- 
    prolog_load_context(directory, Dir),
    file_directory_name(Dir, AdventOfCode).
:- use_module(adventofcode(helpers/readfile)).


fuel(Mass, Fuel) :-
    X is div(Mass, 3),
    Fuel is X-2.

:- initialization(main, main).
main([InputFile]) :-
    read_numbers(InputFile, Numbers),
    maplist(fuel, Numbers, Fuel),
    sum_list(Fuel, Sum),
    write(Sum).
