:- module(intcode, [intcode/4, intcode_input/4]).

:- use_module(library(clpfd)).
:- use_module(library(lists)).

user:file_search_path(adventofcode, AdventOfCode) :- 
    prolog_load_context(directory, Dir),
    file_directory_name(Dir, AdventOfCode).
:- use_module(adventofcode(helpers/listutils)).


intcode_add([LAddr, RAddr, ResultAddr], Program, NewProgram) :-
    nth0(LAddr, Program, Left),
    nth0(RAddr, Program, Right),
    Result #= Left + Right,
    list_nth_replace(Program, ResultAddr, Result, NewProgram).

intcode_multiply([LAddr, RAddr, ResultAddr], Program, NewProgram) :-
    nth0(LAddr, Program, Left),
    nth0(RAddr, Program, Right),
    Result #= Left * Right,
    list_nth_replace(Program, ResultAddr, Result, NewProgram).

intcode_next(InstructionPointer, Program, Result) :-
    NewPointer #= InstructionPointer + 4,
    list_slice(Program, NewPointer, 4, Stack),
    intcode(Stack, NewPointer, Program, Result).

% [99, ...]: terminate.
intcode([99|_], _, X, X).
% [1, X, Y, Z]: sum the values at X and Y and put the result into Z.
intcode([1, LAddr, RAddr, ResultAddr], InstructionPointer, Program, Result) :-
    intcode_add([LAddr, RAddr, ResultAddr], Program, NewProgram),
    intcode_next(InstructionPointer, NewProgram, Result).
% [2, X, Y, Z]: multiply the values at X and Y and put the result into Z.
intcode([2, LAddr, RAddr, ResultAddr], InstructionPointer, Program, Result) :-
    intcode_multiply([LAddr, RAddr, ResultAddr], Program, NewProgram),
    intcode_next(InstructionPointer, NewProgram, Result).

intcode_input(Noun, Verb, [I0, _, _, I3 | Program], Result) :-
    intcode([I0, Noun, Verb, I3], 0, [I0, Noun, Verb, I3 | Program], Result).
