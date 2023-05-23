import * as flags from "https://deno.land/std@0.163.0/flags/mod.ts"
import * as path from "https://deno.land/std@0.163.0/path/mod.ts"
import { assertEquals } from "https://deno.land/std@0.163.0/testing/asserts.ts"
import { encodeHex } from "../util.ts"

const { check } = flags.parse(Deno.args, { boolean: ["check"] })

const wasmPaths = [
  "hashers/xxhash",
  "hashers/blake2b",
]

let success = true
await Promise.all(wasmPaths.map((wasmPath) =>
  build(wasmPath).catch((error) => {
    console.error(`${wasmPath}:`, error)
    success = false
  })
))
Deno.exit(success ? 0 : 1)

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

  const content = `
// @generated

import { decodeHex } from "${path.relative(path.dirname(wasmPath), "util.ts")}"

export default decodeHex(\n"${encodeHex(wasm).replace(/.{0,64}|$/g, "\\\n$&")}",\n)
`.trimStart()

  const outputPath = wasmPath + ".wasm.ts"
  if (check) {
    const existing = await Deno.readTextFile(outputPath)
    assertEquals(existing, content, "Outdated file")
  } else {
    await Deno.writeTextFile(outputPath, content)
  }
}
