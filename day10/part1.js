import { readFileSync } from "fs";

function parseLightDiagram(lineSplitted) {
  const lightDiagramStr = lineSplitted[0].replace(/^\[|\]$/g, "")

  return [...lightDiagramStr].reduce(
    (acc, char, idx) => {
      if (char == '#') acc.push(idx);
      return acc;
    }
    , [])
}

function parseButtons(lineSplitted) {
  return lineSplitted.slice(1, -1)
    .map((str, _) => [...str.replace(/^\(|\)|\,|$/g, "")])
    .map((list, _) => list.map(Number))
}

function parseLine(line) {
  const lineSplitted = line.split(' ');
  let lightDiagram = parseLightDiagram(lineSplitted);
  let buttons = parseButtons(lineSplitted)

  return [buttons, lightDiagram];
}

function mergeButtons(ButtonX, ButtonY) {
  const result = [...[...ButtonX, ...ButtonY].reduce((set, btn) => {
    set.has(btn) ? set.delete(btn) : set.add(btn);
    return set;
  }, new Set())];

  return result;
}

function ButtonsEquals(buttonsX, buttonsY) {
  let same_len = buttonsX.length === buttonsY.length;
  let contains_same_values = [...new Set(buttonsX)].every(v => buttonsY.includes(v));

  return same_len && contains_same_values;
}

function createCombinations(btnArray, len, start, combinations, result) {
  if (combinations.length === len) {
    result.push([...combinations]);
    return;
  }

  for (let i = start; i <= btnArray.length - (len - combinations.length); i++) {
    combinations.push(btnArray[i]);
    createCombinations(btnArray, len, i + 1, combinations, result);
    combinations.pop();
  }
}

function combinationsOfButtons(btnArray, len) {
  const result = [];
  createCombinations(btnArray, len, 0, [], result);
  return result;
}


function getMinToggles(buttons, target) {
  for (let minBtn = 1; minBtn <= buttons.length; minBtn++) {
    let buttonsCombinations = combinationsOfButtons(buttons, minBtn);

    for (let buttons of buttonsCombinations) {
      let attemptButton = buttons.reduce((acc, btn) => mergeButtons(acc, btn), [])

      if (ButtonsEquals(attemptButton, target)) {
        return minBtn;
      }
    }
  }
  return -1;
}

function main() {
  const input =
    readFileSync("input", "utf-8").trim().split('\n')
      .map((line, _) => parseLine(line));

  const minToggles =
    input
      .map((lineInput, _) =>
        getMinToggles(lineInput[0], lineInput[1])
      )

  const sumToggles =
    minToggles
      .reduce((acc, value) => acc + value, 0);

  console.log(sumToggles)
}

main()
