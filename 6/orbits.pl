:- module(
    orbits,
    [
        parse_orbits/2,
        orbit/2,
        unique_satellites/2,
        count_orbits/2,
        orbital_transfer/3
    ]
).

:- use_module(library(clpfd)).
:- use_module(library(lists)).

user:file_search_path(adventofcode, AdventOfCode) :-
    prolog_load_context(directory, Dir),
    file_directory_name(Dir, AdventOfCode).
:- use_module(adventofcode(helpers/listutils)).


:- dynamic orbit/2.

parse_orbit(String, orbit(Satellite, Planet)) :-
    split_string(String, ")", "", [SPlanet,SSatellite]),
    atom_string(Planet, SPlanet),
    atom_string(Satellite, SSatellite).

parse_orbits(OrbitStrings, Orbits) :-
    maplist(parse_orbit, OrbitStrings, Orbits).


orbits(Satellite, Planet) :-
    orbit(Satellite, Planet).
orbits(Satellite, Planet) :-
    orbit(Satellite, Indirect), orbits(Indirect, Planet).

count_orbits(Satellite, Length) :-
    findall(Planet, orbits(Satellite, Planet), Planets),
    length(Planets, Length).


satellites([], []).
satellites([orbit(Sat, _) | Orbits], [Sat | Sats]) :-
    satellites(Orbits, Sats).

unique_satellites(Orbits, Sats) :-
    satellites(Orbits, NonUqSats),
    sort(NonUqSats, Sats).


directly_orbits_or_is_orbited(X, Y) :-
    orbit(X, Y).
directly_orbits_or_is_orbited(X, Y) :-
    orbit(Y, X).

orbital_transfer(X, X, Path, Path).
orbital_transfer(From, To, Path, FinalPath) :-
    directly_orbits_or_is_orbited(From, Planet),
    % Don't repeat our steps
    not(member(Planet, Path)),
    orbital_transfer(Planet, To, [Planet | Path], FinalPath).

orbital_transfer(From, To, Transfers) :-
    orbital_transfer(From, To, [], Transfers).
