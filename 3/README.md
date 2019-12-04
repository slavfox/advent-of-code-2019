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
calculation method. This results in the entire difference between
[part1.pl](./part1.pl) and [part2.pl](./part2.pl) being just

```diff
diff --git 1/part1.pl 2/part2.pl
index 9a8d621..7c2524e 100755
--- 1/part1.pl
+++ 2/part2.pl
@@ -12,8 +12,8 @@ main([InputFile]) :-
     Row2 =.. [_|Atoms2],
     maplist(atom_direction, Atoms1, Dirs1),
     maplist(atom_direction, Atoms2, Dirs2),
-    segments(Dirs1, Segments1),
-    segments(Dirs2, Segments2),
+    segments_distance_travelled(Dirs1, Segments1),
+    segments_distance_travelled(Dirs2, Segments2),
     intersections(Segments1, Segments2, Intersections),
     closest_point(Intersections, Result),
     write(Result).
```

Nice!

As usual, all the meat is in a separate file: [wires.pl](./wires.pl).
