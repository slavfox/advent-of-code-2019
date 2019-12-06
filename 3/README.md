# Day 3 notes

Hey, this has started getting unbearably slow. Nice!
This could be optimized way better, but it's late. I'll work on this more
tomorrow.

---

I really like how obvious Prolog makes that you're writing shitty code.

I did this [the dumb way first](https://github.com/slavfox/advent-of-code-2019/blob/14762ad29cc010c5f4009958c5376d81a491fbe0/3/part1.pl)
just for fun, and the performance was... not great:
```shell
$ time ./part1.pl input.txt
1674     6643.72 real      3009.59 user        16.70 sys
```

After optimizations:
```shell
$ time ./part1.pl input.txt
1674        1.24 real         1.09 user         0.03 sys
```

Part2 wasn't particularly hard, since I could abuse Prolog's near-untypedness to
reuse most predicate clauses, and only write new ones for the alternate distance
calculation method.

As usual, all the meat is in a separate file: [wires.pl](./wires.pl).

---

Lines of code:

* **`wires.pl`:**

  * 135 total - 10 `module/2` - 2 `use_module/1` = 132

* **Part 1:**
  * `main/1`: 11

* **Part 2:**
  * `main/1`: 11

Total: 11 + 132 = 143
