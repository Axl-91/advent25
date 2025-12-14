import { readFileSync } from "fs";

const joltageCache = new Map();

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

function getTargetJoltage(joltage) {
  return joltage.reduce(
    (acc, val, idx) => {
      if (val % 2 != 0) acc.push(idx)
      return acc
    }, [])
}

function getNewJoltage(joltage, buttons_combination) {
  let new_joltage = joltage.slice();

  for (let combination of buttons_combination) {
    for (let btn of combination) {
      new_joltage[btn] -= 1;
    }
  }
  return new_joltage;
}



function makeKey(buttons, joltage) {
  const buttonsKey = buttons
    .map(btn => btn.slice().sort((a, b) => a - b).join(","))
    .sort()
    .join("|");

  const joltageKey = joltage.join(",");

  return `${buttonsKey}::${joltageKey}`;
}


function getMinJoltage(buttons, joltage) {
  const MAX = 900_000_000;
  const key = makeKey(buttons, joltage);
  let valueMult = 1

  if (joltageCache.has(key)) {
    return joltageCache.get(key);
  }

  if (joltage.every(v => v === 0)) {
    joltageCache.set(key, 0);
    return 0;
  }

  if (joltage.some(b => b < 0)) {
    joltageCache.set(key, MAX);
    return MAX;
  }

  while (joltage.every(b => b % 2 == 0)) {
    joltage = joltage.map(b => b / 2)
    valueMult *= 2;
  }

  let target = getTargetJoltage(joltage);
  let attempts = [];

  for (let len_btn = 1; len_btn <= buttons.length; len_btn++) {
    let buttonsCombinations = combinationsOfButtons(buttons, len_btn);

    for (let buttonsComb of buttonsCombinations) {
      let resultButtons = buttonsComb.reduce((acc, btn) => sumButtons(acc, btn), [])

      if (ButtonsEquals(resultButtons, target)) {
        let newJoltage = getNewJoltage(joltage, buttonsComb);
        let minJoltage = getMinJoltage(buttons, newJoltage) + buttonsComb.length;
        minJoltage *= valueMult

        attempts.push(minJoltage)
      }
    }
  }

  let result = attempts.length === 0 ?
    MAX
    : attempts.reduce((prev, curr) => Math.min(prev, curr))

  joltageCache.set(key, result);

  return result;
}

function main() {
  const input =
    readFileSync("input", "utf-8").trim().split('\n')
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

  const minTogglesJoltage =
    input
      .map(([buttons, _, joltage]) =>
        getMinJoltage(buttons, joltage)
      );

  const sumTogglesJoltage =
    minTogglesJoltage
      .reduce((acc, value) => acc + value, 0);

  console.log(`Part 2: ${sumTogglesJoltage}`)
}

main()
