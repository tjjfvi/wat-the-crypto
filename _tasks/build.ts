import * as path from "https://deno.land/std@0.163.0/path/mod.ts"
import { encodeHex } from "../util.ts"

const wasmPaths = [
  "hashers/xxhash",
  "hashers/blake2b",
]

await Promise.all(wasmPaths.map(build))

async function build(wasmPath: string) {
  const process = Deno.run({
    cmd: ["wat2wasm", wasmPath + ".wat", "--output=-"],
    stdout: "piped",
    stderr: "inherit",
    stdin: "null",
  })

  if (!(await process.status()).success) {
    throw new Error(wasmPath + ".wat build failed")
  }

  const wasm = await process.output()

  await Deno.writeTextFile(
    wasmPath + ".wasm.ts",
    `
// @generated

import { decodeHex } from "${path.relative(path.dirname(wasmPath), "util.ts")}"

export default decodeHex(\n"${encodeHex(wasm).replace(/.{0,64}|$/g, "\\\n$&")}",\n)
`.trimStart(),
  )
}
