# Day 4 notes

In this case, the naive solution is too slow for me to try it even for fun.
Regardless, here it is:

```
has_repeated_digit(Number) :-
    Number #>= 10,
    Tenth #= Number div 10,
    Number mod 10 #= Tenth mod 10.
has_repeated_digit(Number) :-
    Number #>= 10,
    Tenth #= Number div 10,
    has_repeated_digit(Tenth).

digits_dont_decrease(Number) :-
    Number #< 10.
digits_dont_decrease(Number) :-
    Number #>= 10,
    Tenth #= Number div 10,
    Tenth mod 10 #>= Number mod 10,
    digits_dont_decrease(Tenth).

password(From, To, Password) :-
    Password in From..To,
    digits_dont_decrease(Password),
    has_repeated_digit(Password).


:- initialization(main, main).
main([InputFile]) :-
    findall(Password, (password(124075, 580769, Password), label([Password])), Solutions),
    length(Solutions, Count),
    write(Count).
```

This solution isn't particularly great, but it's Good Enough for me to just
leave it as-is.
As usual, all the meat is in a separate file: [passwords.pl](./passwords.pl).
