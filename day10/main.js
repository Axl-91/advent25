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

function parseJoltage(lineSplitted) {
  return lineSplitted.at(-1).replace(/^\{|\}|$/g, "").split(",").map(Number)
}

function parseLine(line) {
  const lineSplitted = line.split(' ');
  let lightDiagram = parseLightDiagram(lineSplitted);
  let buttons = parseButtons(lineSplitted)
  let joltage = parseJoltage(lineSplitted)

  return [buttons, lightDiagram, joltage];
}

function sumButtons(ButtonX, ButtonY) {
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
      let resultButtons = buttons.reduce((acc, btn) => sumButtons(acc, btn), [])
      if (ButtonsEquals(resultButtons, target)) return minBtn;
    }
  }
  return -1;
}

function getMinTogglesWithJoltage(buttons, target, joltageTarget) {
  let joltage = Array(joltageTarget.flat().length).fill(0);
  for (let minBtn = 1; minBtn <= buttons.length; minBtn++) {
    let buttonsCombinations = combinationsOfButtons(buttons, minBtn);

    for (let buttons of buttonsCombinations) {
      let resultButtons = buttons.reduce((acc, btn) => sumButtons(acc, btn), [])

      if (ButtonsEquals(resultButtons, target)) {
        for (let btn of buttons.flat()) {
          joltage[btn] += 1;
        }
        // console.log(joltage)
        return minBtn;
      }
    }
  }
  return -1;
}

function main() {
  const input =
    readFileSync("input_test", "utf-8").trim().split('\n')
      .map((line, _) => parseLine(line));

  const minToggles =
    input
      .map(([buttons, target, _]) =>
        getMinToggles(buttons, target)
      )

  const sumToggles =
    minToggles
      .reduce((acc, value) => acc + value, 0);

  console.log(`Part 1: ${sumToggles}`)

  // const minTogglesWithJoltage =
  input
    .map(([buttons, target, joltage], _) =>
      getMinTogglesWithJoltage(buttons, target, joltage)
    );
}

main()
