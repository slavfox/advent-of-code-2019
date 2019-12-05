:- module(intcode, [intcode/2]).

:- use_module(library(clpfd)).
:- use_module(library(lists)).

user:file_search_path(adventofcode, AdventOfCode) :-
    prolog_load_context(directory, Dir),
    file_directory_name(Dir, AdventOfCode).
:- use_module(adventofcode(helpers/listutils)).


intcode_instruction_params(IPtr, [], _, [], IPtr).
intcode_instruction_params(
    IPtr0, [0|Modes], Prog, [position(Addr)|Params], IPtr2
) :-
    nth0(IPtr0, Prog, Addr),
    IPtr1 #= IPtr0 + 1,
    intcode_instruction_params(IPtr1, Modes, Prog, Params, IPtr2).
intcode_instruction_params(
    IPtr0, [1|Modes], Prog, [immediate(Param)|Params], IPtr2
) :-
    nth0(IPtr0, Prog, Param),
    IPtr1 #= IPtr0 + 1,
    intcode_instruction_params(IPtr1, Modes, Prog, Params, IPtr2).


intcode_modes(_, []).
intcode_modes(ModesInt, [Mode|Modes]) :-
    Mode #= ModesInt mod 10,
    Rest #= ModesInt div 10,
    intcode_modes(Rest, Modes).
intcode_modes(1, ModesInt, [Left, Right, 0]) :-
    intcode_modes(ModesInt, [Left, Right, 0]).
intcode_modes(2, ModesInt, [Left, Right, 0]) :-
    intcode_modes(ModesInt, [Left, Right, 0]).
intcode_modes(3, ModesInt, [0]) :-
    intcode_modes(ModesInt, [0]).
intcode_modes(4, ModesInt, [Arg]) :-
    intcode_modes(ModesInt, [Arg]).
intcode_modes(5, ModesInt, [Op, Addr]) :-
    intcode_modes(ModesInt, [Op, Addr]).
intcode_modes(6, ModesInt, [Op, Addr]) :-
    intcode_modes(ModesInt, [Op, Addr]).
intcode_modes(7, ModesInt, [Left, Right, 0]) :-
    intcode_modes(ModesInt, [Left, Right, 0]).
intcode_modes(8, ModesInt, [Left, Right, 0]) :-
    intcode_modes(ModesInt, [Left, Right, 0]).
intcode_modes(99, _, []).

intcode_instruction(Instruction, Opcode, Modes) :-
    Opcode #= Instruction mod 100,
    ModesInt #= Instruction div 100,
    intcode_modes(Opcode, ModesInt, Modes).


intcode_param_value(position(Addr), Prog, Value) :-
    nth0(Addr, Prog, Value).
intcode_param_value(immediate(X), _, X).

if_lt_1(First, Second, 1) :-
    First #< Second.
if_lt_1(First, Second, 0) :-
    First #>= Second.

if_eq_1(First, Second, 1) :-
    First #= Second.
if_eq_1(First, Second, 0) :-
    First #\= Second.

intcode_eval(1, [L, R, position(Addr)], IPtr, IPtr, Prog, NewProg) :-
    intcode_param_value(L, Prog, Left),
    intcode_param_value(R, Prog, Right),
    Value #= Left + Right,
    list_nth_replace(Prog, Addr, Value, NewProg).
intcode_eval(2, [L, R, position(Addr)], IPtr, IPtr, Prog, NewProg) :-
    intcode_param_value(L, Prog, Left),
    intcode_param_value(R, Prog, Right),
    Value #= Left * Right,
    list_nth_replace(Prog, Addr, Value, NewProg).
intcode_eval(3, [position(Addr)], IPtr, IPtr, Prog, NewProg) :-
    read(Value),
    list_nth_replace(Prog, Addr, Value, NewProg).
intcode_eval(4, [Arg], IPtr, IPtr, Prog, Prog) :-
    intcode_param_value(Arg, Prog, Value),
    writeln(Value).
% jump
intcode_eval(5, [Arg, Addr], _, NewPtr, Prog, Prog) :-
    intcode_param_value(Arg, Prog, Value),
    Value #\= 0,
    intcode_param_value(Addr, Prog, NewPtr).
% no jump
intcode_eval(5, [Arg, _], IPtr, IPtr, Prog, Prog) :-
    intcode_param_value(Arg, Prog, Value),
    Value #= 0.
% jump
intcode_eval(6, [Arg, Addr], _, NewPtr, Prog, Prog) :-
    intcode_param_value(Arg, Prog, Value),
    Value #= 0,
    intcode_param_value(Addr, Prog, NewPtr).
% no jump
intcode_eval(6, [Arg, _], IPtr, IPtr, Prog, Prog) :-
    intcode_param_value(Arg, Prog, Value),
    Value #\= 0.
intcode_eval(7, [L, R, position(Addr)], IPtr, IPtr, Prog, NewProg) :-
    intcode_param_value(L, Prog, Left),
    intcode_param_value(R, Prog, Right),
    if_lt_1(Left, Right, Value),
    list_nth_replace(Prog, Addr, Value, NewProg).
intcode_eval(8, [L, R, position(Addr)], IPtr, IPtr, Prog, NewProg) :-
    intcode_param_value(L, Prog, Left),
    intcode_param_value(R, Prog, Right),
    if_eq_1(Left, Right, Value),
    list_nth_replace(Prog, Addr, Value, NewProg).
intcode_eval(99, [], IPtr, IPtr, Prog, [halt|Prog]).


intcode(_, [halt|Prog], Prog).
intcode(IPtr0, Prog, Result) :-
    nth0(IPtr0, Prog, Instruction),
    intcode_instruction(Instruction, Opcode, Modes),
    ParamPointer #= IPtr0 + 1,
    intcode_instruction_params(ParamPointer, Modes, Prog, Params, IPtr1),
    intcode_eval(Opcode, Params, IPtr1, IPtr2, Prog, NewProg),
    intcode(IPtr2, NewProg, Result).

intcode(Prog, Result) :-
    intcode(0, Prog, Result).
