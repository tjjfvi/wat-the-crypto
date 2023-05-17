import { log } from "../common/log.ts"
import wasmCode from "./sr25519.wasm.ts"

console.log(wasmCode.length, "bytes of wasm")

const memory = new WebAssembly.Memory({ initial: 10, maximum: 128 })

const wasmModule = new WebAssembly.Module(wasmCode)
const wasmInstance = new WebAssembly.Instance(wasmModule, {
  sr25519: { memory },
  log,
})

interface Sr25519Wasm {
  free_adr: WebAssembly.Global
  keccak_f1600(adr: number): void
  u256_add_u32_mul_overflow(o: number, s: bigint, x: number): number
  _u256_mul_u512(o: number, x: number, y: number): void
  coef_add(o: number, x: number): void
  coef_mul(o: number, x: number, y: number): void
  exp_add(o: number, x: number): void
}

export const wasm = wasmInstance.exports as never as Sr25519Wasm
export const memBuf = new Uint8Array(memory.buffer)
