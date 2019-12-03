#!/usr/bin/env swipl
:- use_module(library(csv)).
:- use_module(intcode).

:- initialization(main, main).
main([InputFile]) :-
    csv_read_file(InputFile, [Row]),
    Row =.. [_|Program],
    intcode_input(12, 2, Program, [X|_]),
    write(X).
