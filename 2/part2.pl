#!/usr/bin/env swipl
:- use_module(library(csv)).
:- use_module(library(clpfd)).
:- use_module(intcode).

:- initialization(main, main).
main([InputFile]) :-
    csv_read_file(InputFile, [Row]),
    Row =.. [_|Program],
    Noun in 0..99,
    Verb in 0..99,
    intcode_input(Noun, Verb, Program, [19690720|_]),
    Out #= 100 * Noun + Verb,
    write(Out).
