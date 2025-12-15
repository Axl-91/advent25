import strutils
import sequtils
import tables

proc findOuts(tableVals: Table[string, seq[string]], initValue: string, valVisited: seq[string]): int =
  var total = 0
  var visited = valVisited

  if (initValue == "out"):
    if (visited.contains("fft") and visited.contains("dac")):
      return 1
    else:
      return 0

  for value in tableVals[initValue]:
    if (visited.contains(value)):
      continue
    else: 
      visited.add(value)
      let totalVal = findOuts(tableVals, value, visited)
      total += totalVal

  total

proc main() =
    let input = readFile("input")
    var lines = splitLines(input)
    let lines_len = lines.len - 1
    let valVisited = ["svr"].toSeq()

    lines = lines[0 ..< lines_len]
    var tableVals = initTable[string, seq[string]]()

    for line in lines:
      let lineSplitted = split(line)

      var key = lineSplitted[0]
      key = key[0 ..< (key.len - 1)]
      let values = lineSplitted[1 ..< lineSplitted.len]

      tableVals[key] = values

    let result = findOuts(tableVals, "svr", valVisited)

    echo result

when isMainModule:
  main()
