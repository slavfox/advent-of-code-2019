# Day 1 notes

In `part2`, a more readable but not tail-recursive implementation of `total_fuel/2` could look like:

```prolog
total_fuel(0, 0).
total_fuel(Mass, Fuel) :-
    fuel(Mass, ModuleFuel),
    total_fuel(ModuleFuel, FuelFuel),
    Fuel is ModuleFuel + FuelFuel.
```

---

Lines of code:

* **Part 1:**
  * `fuel/2`: 3
  * `main/1`: 5

  Total: 8

* **Part 2:**
  * `fuel/2`: 3
  * `total_fuel/3`: 5
  * `total_fuel/2`: 2
  * `main/1`: 5

  Total: 15
