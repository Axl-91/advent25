import os
import strutils
import tables

proc findOuts(tableVals: Table[string, seq[string]], values: seq[string]): (int, int) =
  var total = 0
  var repeats = 0
  
  for value in values:
    if (value == "out"):
      total += 1
    elif (value == "you"):
      repeats += 1
    else: 
      let (totalVal, repeatsVal)= findOuts(tableVals, tableVals[value])
      total += totalVal
      repeats += repeatsVal

  (total, repeats)

proc main() =
    let input = readFile("input")
    var lines = splitLines(input)
    let lines_len = lines.len - 1

    lines = lines[0 ..< lines_len]
    var tableVals = initTable[string, seq[string]]()

    for line in lines:
      let lineSplitted = split(line)

      var key = lineSplitted[0]
      key = key[0 ..< (key.len - 1)]
      let values = lineSplitted[1 ..< lineSplitted.len]

      tableVals[key] = values

    let (parcialResult, repeats) = findOuts(tableVals, tableVals["you"])
    let result = parcialResult + parcialResult * repeats

    echo result

when isMainModule:
  main()
