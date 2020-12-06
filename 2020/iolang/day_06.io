input := File clone openForReading ("../inputs/day_06") readLines

Group := Object clone
answers := nil
size := 0
Group with := method (
    group := self clone
    group answers := list ()
    group count := 0
    group
)

Group addAnswers := method (str, answers appendSeq (str asList); size = size + 1)
Group someoneAgreedTo := method (answers unique size)
Group allAgreedTo := method (
    answers uniqueCount select (count, count at (1) == (self size)) size
)

groups := input reduce (acc, line,
    if (line size < 1,
      acc append (Group with),
      acc last addAnswers (line))

    acc
, list (Group with))

# Part 1
groups map (group, group someoneAgreedTo) sum println # => 6947

# Part 2
groups map (group, group allAgreedTo) sum println # => 3398
