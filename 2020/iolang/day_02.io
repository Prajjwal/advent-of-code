input := File clone openForReading("../inputs/day_02") readLines

Entry := Object clone
Entry parse := method (str,
)

Entry min := 0
Entry max := 0
Entry char := nil
