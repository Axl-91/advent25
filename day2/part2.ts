import path from "node:path";
import { promises as fs } from "fs";
import { fileURLToPath } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

function isIdValid(id: string): boolean {
  if (id.length == 1) return true;
  return !(id + id).slice(1, -1).includes(id);
}

function getResultFromRanges(ranges: string[]): number {
  let result = 0;

  for (let range of ranges) {
    let [first, last] = range.split("-")
    let begin = parseInt(first);
    let end = parseInt(last);

    while (begin <= end) {
      if (!isIdValid(begin.toString())) {
        result += begin;
      }
      begin++;
    }
  }
  return result
}

async function main() {
  let filePath = path.join(__dirname, "input");
  let inputFile = await fs.readFile(filePath, "utf-8")
  let ranges = inputFile.trim().split(",");

  let result = getResultFromRanges(ranges)
  console.log(`Final result: ${result}`)

  return 0;
}

main()

