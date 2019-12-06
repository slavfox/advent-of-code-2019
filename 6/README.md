# Day 6 notes

Oh boy, it's time to unleash something ugly -
[metapredicates!](https://www.swi-prolog.org/pldoc/man?section=metapred)
Rather than build our own graph and pathfinding algorithm, we just parse the
input into a list of `orbit(x, y)` structures and `asserta/1` every one of them
as a fact.

For the non-Prologgers, this is the same as just executing one big file full of
```prolog
orbit('PQK', 'Q5S').
orbit('8QF', 'BST').
orbit('7DY', 'PBP').
orbit('DJG', 'PLT').
orbit('L9D', 'LBP').
orbit('SBH', 'WMD').
orbit('XJZ', 'PS9').
orbit('6Q1', 'FNM').
% ...
```

We can then leverage Prolog's own graph search by just redefining the classic
[`ancestor/2`](https://en.wikibooks.org/wiki/Prolog/Recursive_Rules):

```prolog
orbits(Satellite, Planet) :-
    orbit(Satellite, Planet).
orbits(Satellite, Planet) :-
    orbit(Satellite, Indirect), orbits(Indirect, Planet).
```

Neat!

---

Lines of code:

* **`orbits.pl`:**

  * 47 total - 10 `module/2` - 6 `use_module/1` = 31

* **Part 1:**
  * `main/1`: 8

* **Part 2:**
  * `main/1`: 9

Total: 31 + 9 = 40
