input := File clone openForReading("../inputs/day_01") readLines map(asNumber)

pairThatSumsTo := method (
    target,
    input foreach (i,
      input foreach (j,
        if (i + j == target, return list(i, j))
      )
    )
)

tripletThatSumsTo := method (
    target,
    input foreach (k,
      pair := pairThatSumsTo(target - k)
      if (pair, return (pair append(k)))
    )
)

pairThatSumsTo(2020) reduce(*) println
tripletThatSumsTo(2020) reduce(*) println
