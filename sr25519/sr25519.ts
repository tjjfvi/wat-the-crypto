import { log } from "../common/log.ts"
import wasmCode from "./sr25519.wasm.ts"

console.log(wasmCode.length, "bytes of wasm")

const memory = new WebAssembly.Memory({ initial: 1, maximum: 128 })

const wasmModule = new WebAssembly.Module(wasmCode)
const wasmInstance = new WebAssembly.Instance(wasmModule, {
  sr25519: { memory },
  log,
})

interface Sr25519Wasm {
  keccak_f1600(adr: number): void
}

export const wasm = wasmInstance.exports as never as Sr25519Wasm
export const memBuf = new Uint8Array(memory.buffer)
