import { u256 as $u256 } from "https://deno.land/x/scale@v0.11.2/codecs/int.ts"
import { log } from "../common/log.ts"
import wasmCode from "./sr25519.wasm.ts"

console.log(wasmCode.length, "bytes of wasm")

export const u512 = 1n << 512n
export const u256 = 1n << 256n
export const coef = (1n << 255n) - 19n
export const exp = (1n << 252n) + 27742317777372353535851937790883648493n

const memory = new WebAssembly.Memory({ initial: 10, maximum: 128 })

const wasmModule = new WebAssembly.Module(wasmCode)
const wasmInstance = new WebAssembly.Instance(wasmModule, {
  sr25519: { memory },
  log,
})

interface Sr25519Wasm {
  coef: WebAssembly.Global
  exp: WebAssembly.Global
  neg_u256_mod_exp: WebAssembly.Global
  neg_coef: WebAssembly.Global
  neg_exp: WebAssembly.Global

  free_adr: WebAssembly.Global
  keccak_f1600(adr: number): void
  _u256_add(o: number, s: bigint, x: number, n: bigint): number
  u256_sub(o: number, x: number, y: number): number
  _u256_mul_u512(o: number, x: number, y: number): void
  coef_add(o: number, x: number): void
  coef_mul(o: number, x: number, y: number): void
  exp_add(o: number, x: number): void
}

export const wasm = wasmInstance.exports as never as Sr25519Wasm
export const mem = new Uint8Array(memory.buffer)

writeU256(wasm.coef.value, coef)
writeU256(wasm.exp.value, exp)
writeU256(wasm.neg_u256_mod_exp.value, exp - (u256 % exp))
writeU256(wasm.neg_coef.value, u256 - coef)
writeU256(wasm.neg_exp.value, u256 - exp)

export function readU256(adr: number) {
  return $u256.decode(mem.subarray(adr, adr + 32))
}

export function writeU256(adr: number, value: bigint) {
  mem.subarray(adr, adr + 32).set($u256.encode(value))
}
