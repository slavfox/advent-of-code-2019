:- module(
    wires,
    [
        atom_direction/2,
        closest_point/2,
        intersections/3,
        segments/2,
        segments_distance_travelled/2
    ]
).

:- use_module(library(clpfd)).
:- use_module(library(lists)).


atom_direction(Atom, step(Direction, Distance)) :-
    atom_chars(Atom, [Direction|DistanceChars]),
    number_chars(Distance, DistanceChars).


move_distance(step('U', Dist), point(StartX, StartY), point(StartX, EndY)) :-
    EndY#=StartY+Dist.
move_distance(step('D', Dist), point(StartX, StartY), point(StartX, EndY)) :-
    EndY#=StartY-Dist.
move_distance(step('L', Dist), point(StartX, StartY), point(EndX, StartY)) :-
    EndX#=StartX-Dist.
move_distance(step('R', Dist), point(StartX, StartY), point(EndX, StartY)) :-
    EndX#=StartX+Dist.


rev_segments([Step], [segment(point(0, 0), NewPoint)]) :-
    move_distance(Step, point(0, 0), NewPoint).
rev_segments([Step|Steps], [segment(P1, P2), segment(P0, P1)|Segments]) :-
    move_distance(Step, P1, P2),
    rev_segments(Steps, [segment(P0, P1)|Segments]).

% The same as above, but tracking total distance
rev_segments_distance_travelled(
    [step(Dir, Dist)], [step(segment(point(0, 0), NewPoint), Dist)]
) :-
    move_distance(step(Dir, Dist), point(0, 0), NewPoint).
rev_segments_distance_travelled(
    [step(Dir, Dist) | Steps],
    [step(segment(P1, P2), Dist1), step(segment(P0, P1), Dist0) | Segments]
) :-
    Dist1 #= Dist0 + Dist,
    move_distance(step(Dir, Dist), P1, P2),
    rev_segments_distance_travelled(
        Steps, [step(segment(P0, P1), Dist0) | Segments]
    ).

segments(Steps, Segments) :-
    reverse(Steps, RevSteps),
    rev_segments(RevSteps, Segments).

segments_distance_travelled(Steps, Segments) :-
    reverse(Steps, RevSteps),
    rev_segments_distance_travelled(RevSteps, Segments).

intersection_point(
    segment(point(X2, Y2), point(X2, Y3)),
    segment(point(X0, Y0), point(X1, Y0)),
    point(X2, Y0)
) :-
    intersection_point(
        segment(point(X0, Y0), point(X1, Y0)),
        segment(point(X2, Y2), point(X2, Y3)),
        point(X2, Y0)
    ).
intersection_point(
    segment(point(X0, Y0), point(X1, Y0)),
    segment(point(X2, Y2), point(X2, Y3)),
    point(X2, Y0)
) :-
    % Ignore starting points to avoid (0, 0) being an intersection
    X2#\=X0,
    Y2#\=Y0,
    (
        X1#>X0
    ->
        % First segment going right
        X2 in X0..X1
    ;
        % First segment going left
        X2 in X1..X0
    ),
    (
        Y3#>Y2
    ->
        % Second segment going up
        Y0 in Y2..Y3
    ;
        % Second segment going down
        Y0 in Y3..Y2
    ).


% An empty list has no intersections
intersections([], _, _, []).
% Short circuit with distance
intersections(
    [step(segment(point(LX0, LY0), point(LX1, LY1)), LD)|Ls],
    RightAll,
    [step(segment(point(RX0, RY0), point(RX1, RY1)), RD)|Rs],
    [point_with_distance(X, Y, D)|Is]
) :-
    intersection_point(
        segment(point(LX0, LY0), point(LX1, LY1)),
        segment(point(RX0, RY0), point(RX1, RY1)),
        point(X, Y)
    ),
    D #=
        (LD - abs(LX1 - X) - abs(LY1 - Y))
      + (RD - abs(RX1 - X) - abs(RY1 - Y)),
    intersections(
        [step(segment(point(LX0, LY0), point(LX1, LY1)), LD)|Ls],
        RightAll, Rs, Is
    ).
% If L intersects with R, I is the intersection
intersections([L|Ls], RightAll, [R|Rs], [I|Is]) :-
    intersection_point(L, R, I),
    intersections([L|Ls], RightAll, Rs, Is).
% else L doesn't intersect with R, so try the rest of Rs
intersections([L|Ls], RightAll, [_|Rs], Is) :-
    intersections([L|Ls], RightAll, Rs, Is).
% if we ran out of Rs, repeat for the next element in Ls
intersections([_|Ls], RightAll, [], Is) :-
    intersections(Ls, RightAll, RightAll, Is).
intersections(Ls, Rs, Is) :-
    intersections(Ls, Rs, Rs, Is).

manhattan(point(FromX, FromY), point(ToX, ToY), Distance) :-
    Distance #= abs(FromX - ToX) + abs(FromY - ToY).
manhattan(Point, Distance) :-
    manhattan(point(0, 0), Point, Distance).

closest_point([], Result, Result).
% for points
closest_point([point(X, Y) | Points], inf, Result) :-
    manhattan(point(X, Y), Distance),
    closest_point(Points, Distance, Result).
closest_point([point(X, Y) | Points], LocalMinimum, Result) :-
    manhattan(point(X, Y), Distance),
    (
        Distance #< LocalMinimum
    ->
        closest_point(Points, Distance, Result)
    ;
        closest_point(Points, LocalMinimum, Result)
    ).
% for points_with_distance
closest_point([point_with_distance(_, _, D)|Points], inf, Result) :-
    closest_point(Points, D, Result).
closest_point([point_with_distance(_, _, D)|Points], LocalMinimum, Result) :-
    (
        D #< LocalMinimum
    ->
        closest_point(Points, D, Result)
    ;
        closest_point(Points, LocalMinimum, Result)
    ).

closest_point(Points, Closest) :-
    closest_point(Points, inf, Closest).
