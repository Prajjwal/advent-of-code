input := File clone openForReading("../inputs/day_02") readLines

Entry := Object clone
Entry matcher := Regex with("""(\d+)-(\d+)\ (\w):\ (\w+)""") extended
Entry parse := method (line,
    entry := Entry clone
    matches := line findRegex (matcher)

    if (matches,
      entry rule_a = matches at (1) asNumber
      entry rule_b = matches at (2) asNumber
      entry char = matches at (3)
      entry password = matches at (4)
    )

    return entry
)

Entry rule_a := 0
Entry rule_b := 0
Entry char := nil
Entry password := nil
Entry is_valid_1 := method (
    char_count := password occurrencesOfSeq (char)

    return (char_count >= rule_a) and (char_count <= rule_b)
)
Entry is_valid_2 := method (
    match_at_a := (char at (0) == password at (rule_a - 1))
    match_at_b := (char at (0) == password at (rule_b - 1))

    return match_at_a != match_at_b
)

input map (line, Entry parse (line) is_valid_1) select (v, v) size println
input map (line, Entry parse (line) is_valid_2) select (v, v) size println
