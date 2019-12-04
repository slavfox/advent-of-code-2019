#!/usr/bin/env swipl
user:file_search_path(adventofcode, AdventOfCode) :- 
    prolog_load_context(directory, Dir),
    file_directory_name(Dir, AdventOfCode).
:- use_module(adventofcode(helpers/readfile)).
:- use_module(passwords).

:- initialization(main, main).
main([InputFile]) :-
    read_strings(InputFile, [String]),
    split_string(String, "-", "", [SFrom,STo]),
    number_string(From, SFrom),
    number_string(To, STo),
    count_passwords2(From, To, Count),
    write(Count).
