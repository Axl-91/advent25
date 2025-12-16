import strutils
import tables

var tableCache = initTable[(string, bool, bool), int]()

proc findOuts(tableVals: Table[string, seq[string]], initValue: string, visitReq1: bool, visitReq2: bool): int =
  if (initValue == "out" and visitReq1 and visitReq2):
      return 1

  var total = 0
  if (tableCache.hasKey((initValue, visitReq1, visitReq2))): 
    return tableCache[(initValue, visitReq1, visitReq2)]

  let adjValues = tableVals.getOrDefault(initValue, @[])

  for nextValue in adjValues:
    total += findOuts(tableVals, nextValue, nextValue == "fft" or visitReq1, nextValue == "dac" or visitReq2)

  tableCache[(initValue, visitReq1, visitReq2)] = total
  total

proc initValTable(lines: seq[string], tableVals: var Table[string, seq[string]]) =
  for line in lines:
    let lineSplitted = split(line)

    var key = lineSplitted[0]
    key = key[0 ..< (key.len - 1)]
    let values = lineSplitted[1 ..< lineSplitted.len]

    tableVals[key] = values

proc main() =
  let initValue = "svr"
  var tableVals = initTable[string, seq[string]]()

  let input = readFile("input")
  var lines = splitLines(input)
  let lines_len = lines.len - 1
  lines = lines[0 ..< lines_len]

  initValTable(lines, tableVals)

  let result = findOuts(tableVals, initValue, false, false)

  echo result

when isMainModule:
  main()

