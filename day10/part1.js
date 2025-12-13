import { readFileSync } from "fs";

function parse_light_diagram(line_splitted) {
  const light_diagram_str = line_splitted[0].replace(/^\[|\]$/g, "")

  return [...light_diagram_str].reduce(
    (acc, char, idx) => {
      if (char == '#') acc.push(idx);
      return acc;
    }
    , [])
}

function parse_buttons(line_splitted) {
  return line_splitted.slice(1, -1)
    .map((str, _) => [...str.replace(/^\(|\)|\,|$/g, "")])
    .map((list, _) => list.map(Number))
}

function parse_line(line) {
  const line_splitted = line.split(' ');
  let light_diagram = parse_light_diagram(line_splitted);
  let buttons = parse_buttons(line_splitted)

  return [light_diagram, ...buttons];
}


function main() {
  const input =
    readFileSync("input_test", "utf-8")
      .trim()
      .split('\n')
      .map((line, _) => parse_line(line));

  console.log(input);
}

main()
