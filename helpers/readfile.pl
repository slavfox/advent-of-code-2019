:- module(
    readfile,
    [ 
        read_strings/2,
        read_numbers/2
    ]
).

:- use_module(library(apply)).
:- use_module(library(csv)).
:- use_module(library(readutil)).

read_file(Stream, []) :-
    at_end_of_stream(Stream).
read_file(Stream, [X|L]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_codes(Stream, Codes),
    string_codes(X, Codes),
    read_file(Stream, L),
    !.

read_strings(FileName, Strings) :-
    open(FileName, read, F),
    read_file(F, Strings).

read_numbers(FileName, Numbers) :-
    open(FileName, read, F),
    read_file(F, Lines),
    maplist(number_string, Numbers, Lines).
