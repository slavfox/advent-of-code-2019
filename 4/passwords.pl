:- module(passwords,
          [ count_passwords/3,
            count_passwords2/3
          ]).

adjacent_duplicate([H, H|_]).
adjacent_duplicate([_|T]) :-
    adjacent_duplicate(T).

trailing_standalone_adjacent_duplicate([J, H, H]) :-
    J\=H.
trailing_standalone_adjacent_duplicate([J, H, H, K | _]) :-
    J\=H, K\=H.
trailing_standalone_adjacent_duplicate([_|T]) :-
    trailing_standalone_adjacent_duplicate(T).
standalone_adjacent_duplicate([X, X, Y | _]) :-
    X \= Y.
standalone_adjacent_duplicate(X) :-
    trailing_standalone_adjacent_duplicate(X).

is_valid_password(Number) :-
    number_codes(Number, CodeList),
    adjacent_duplicate(CodeList),
    sort(0, @=<, CodeList, Sorted),
    number_codes(Number, Sorted).

is_valid_password2(Number) :-
    number_codes(Number, CodeList),
    standalone_adjacent_duplicate(CodeList),
    sort(0, @=<, CodeList, Sorted),
    number_codes(Number, Sorted).


count_passwords(X, X, Comparator, Accumulated, Count) :-
    call(Comparator, X),
    Count is Accumulated+1.
count_passwords(X, X, _, Count, Count).
count_passwords(From, To, Comparator, Accumulated, Count) :-
    call(Comparator, To),
    NewTo is To-1,
    NewAccum is Accumulated+1,
    count_passwords(From, NewTo, Comparator, NewAccum, Count).
count_passwords(From, To, Comparator, Accumulated, Count) :-
    NewTo is To-1,
    count_passwords(From, NewTo, Comparator, Accumulated, Count).

count_passwords(From, To, Count) :-
    count_passwords(From, To, is_valid_password, 0, Count).

count_passwords2(From, To, Count) :-
    count_passwords(From, To, is_valid_password2, 0, Count).
