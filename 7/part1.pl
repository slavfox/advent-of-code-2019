#!/usr/bin/env swipl
:- use_module(library(clpfd)).
:- use_module(library(csv)).
:- use_module(library(lists)).
:- use_module(pure_intcode).

amplifier(_, [], Result, Result).
amplifier(Program, [Input | Inputs], PrevOut, Result) :-
    intcode(Program, _, [Input, PrevOut], [Out]),
    amplifier(Program, Inputs, Out, Result).

amplifiers(_, [], []).
amplifiers(Program, [Input | Inputs], [Output | Outputs]) :-
    amplifier(Program, Input, 0, Output),
    amplifiers(Program, Inputs, Outputs).


:- initialization(main, main).
main([InputFile]) :-
    csv_read_file(InputFile, [Row]),
    Row =.. [_|Program],
    findall(Input, permutation([0, 1 , 2 , 3 , 4], Input), Inputs),
    amplifiers(Program, Inputs, Outputs),
    max_list(Outputs, Max),
    writeln(Max).
