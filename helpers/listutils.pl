
:- module(listutils, [list_nth_replace/4, list_slice/4]).

:- use_module(library(clpfd)).

list_nth_replace(Xs, Index, Replacement, Ys) :-
    length(Prefix, Index),
    append(Prefix, [_|Suffix], Xs),
    append(Prefix, [Replacement|Suffix], Ys).


list_slice(Xs, 0, Length, Slice) :-
    length(Xs, L),
    (
        L #< Length 
    -> 
        length(Slice, L)
    ;
        length(Slice, Length)
    ),
    append(Slice, _, Xs).


list_slice([_|Xs], Index, Length, Slice) :-
    Index #> 0,
    NewIndex #= Index - 1,
    list_slice(Xs, NewIndex, Length, Slice).
