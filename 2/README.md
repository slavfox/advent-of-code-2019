# Day 2 notes

I pretty much yelled out in joy when I saw that the second part was "okay, you've written an algo that finds the output given an input, now find the input given an output". Prolog *loves* those kinda problems. Just compare [part1.pl](./part1.pl) and [part2.pl](./part2.pl); all of the meat is in [intcode.pl](./intcode.pl), and pretty much nothing needed changes to solve part 2.

This is getting slow... ish, though. It's still faster than I expected, honestly! On my shitty Macbook Air:
```
$ time ./part2.pl input.txt
6472       11.87 real        11.73 user         0.02 sys
```
I expected times at least an order of magnitude slower.