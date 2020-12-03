world := File clone openForReading("../inputs/day_03") readLines

xBoundary := world at(0) size
yBoundary := world size

Toboggan := Object clone
Toboggan stepX := 3
Toboggan stepY := 1
Toboggan x := 0
Toboggan y := 0

Toboggan with := method (
    stepX, stepY,

    t := Toboggan clone
    t stepX = stepX
    t stepY = stepY

    t
)

Toboggan move := method(
    x = (x + stepX) % xBoundary
    y = y + stepY

    if (outOfBounds, return nil)

    return true
)

Toboggan atTree := method(
    (world at (y) at (x)) == 35
)

Toboggan outOfBounds := method(y >= yBoundary)

# Part 1

toboggan := Toboggan clone
treeCount := 0

while (toboggan move,
    if (toboggan atTree, treeCount = treeCount + 1))

treeCount println

# Part 2
toboggans := list (
    list (1, 1), list (3, 1),
    list (5, 1), list (7, 1),
    list (1, 2)
) map (step, Toboggan with (step at (0), step at (1)))

treeCounts := toboggans map (toboggan,
    treeCount := 0
    while (toboggan move, if (toboggan atTree, treeCount = treeCount + 1))
    BigNum with (treeCount)
)

treeCounts reduce (*) println
