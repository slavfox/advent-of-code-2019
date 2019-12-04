# Day 1 notes

In `part2`, a more readable but not tail-recursive implementation of `total_fuel/2` could look like:

```prolog
total_fuel(0, 0).
total_fuel(Mass, Fuel) :-
    fuel(Mass, ModuleFuel),
    total_fuel(ModuleFuel, FuelFuel),
    Fuel is ModuleFuel + FuelFuel.
```
