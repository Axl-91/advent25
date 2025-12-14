import { readFileSync } from "fs";
import { init } from "z3-solver";

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

async function getMinJoltage(buttons, joltages, z3Context) {
  // Create an optimize object from Z3
  const { Int, Optimize } = z3Context("main");
  const optimizer = new Optimize();

  // Create a variable for each button
  const variables = [];
  buttons.forEach((_, idx) => {
    const value = Int.const(String.fromCodePoint(idx + 97));
    optimizer.add(value.ge(0));
    variables.push(value);
  });

  // Create conditions for each joltage number
  joltages.forEach((joltage, jIdx) => {
    let condition = Int.val(0);
    buttons.forEach((_, bIdx) => {
      if (buttons[bIdx].includes(jIdx))
        condition = condition.add(variables[bIdx]);
    });
    condition = condition.eq(Int.val(joltage));
    optimizer.add(condition);
  });

  // Create the sum of all z3 Values
  const sum = variables.reduce((prev, curr) => prev.add(curr));

  optimizer.minimize(sum);

  // If there is a satisfactory result get it and put it into the result
  if ((await optimizer.check()) == "sat") {
    let minToggles = parseInt(optimizer.model().eval(sum));
    return minToggles;
  }

  return -1
}

async function main() {
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

  let z3Context = (await init()).Context;

  const minTogglesJoltage =
    await Promise.all(input
      .map(async ([buttons, _, joltage]) =>
        await getMinJoltage(buttons, joltage, z3Context)
      ));

  if (minTogglesJoltage.some(v => v < 0)) {
    console.log("Fail")
    return -1
  }

  const resultSum = minTogglesJoltage.reduce((x, y) => x + y)


  console.log(`Part 2: ${resultSum}`)
}

main()
