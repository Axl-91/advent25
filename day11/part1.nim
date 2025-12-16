import strutils
import tables

proc findOuts(tableVals: Table[string, seq[string]], initValue: string): int =
  if (initValue == "out"):
    return 1

  var total = 0
  
  for nextValue in tableVals[initValue]:
    let totalVal= findOuts(tableVals, nextValue)
    total += totalVal

  total

proc initValTable(lines: seq[string], tableVals: var Table[string, seq[string]]) =
  for line in lines:
    let lineSplitted = split(line)

    var key = lineSplitted[0]
    key = key[0 ..< (key.len - 1)]
    let values = lineSplitted[1 ..< lineSplitted.len]

    tableVals[key] = values

proc main() =
  let initValue = "you"
  var tableVals = initTable[string, seq[string]]()

  let input = readFile("input")
  var lines = splitLines(input)
  let lines_len = lines.len - 1
  lines = lines[0 ..< lines_len]

  initValTable(lines, tableVals)

  let result = findOuts(tableVals, initValue)
  echo result

when isMainModule:
  main()
