#!/usr/bin/env swipl
:- use_module(library(apply)).
:- use_module(library(clpfd)).

user:file_search_path(adventofcode, AdventOfCode) :-
    prolog_load_context(directory, Dir),
    file_directory_name(Dir, AdventOfCode).
:- use_module(adventofcode(helpers/readfile)).

:- use_module(orbits).


:- initialization(main, main).
main([InputFile]) :-
    read_strings(InputFile, Strings),
    parse_orbits(Strings, Orbits),
    maplist(asserta, Orbits),
    orbit('YOU', YouPlanet),
    orbit('SAN', SanPlanet),
    orbital_transfer(YouPlanet, SanPlanet, Path),
    length(Path, OrbitalTransfers),
    write(OrbitalTransfers).
