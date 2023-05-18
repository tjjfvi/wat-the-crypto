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
  keccak_rc_adr: WebAssembly.Global
  coef: WebAssembly.Global
  exp: WebAssembly.Global
  neg_coef: WebAssembly.Global
  neg_exp: WebAssembly.Global
  u256_mod_exp: WebAssembly.Global
  coef_neg_two: WebAssembly.Global
  rist_d: WebAssembly.Global
  free_adr: WebAssembly.Global

  keccak_f1600(adr: number): void

  _u256_add(o: number, s: bigint, x: number, n: bigint): number
  u256_sub(o: number, x: number, y: number): number
  u256_mod_neg(x: number, y: number): number
  _u256_mul_u512(o: number, x: number, y: number): void
  coef_add(o: number, x: number): void
  coef_mul(x: number, y: number): void
  exp_add(o: number, x: number): void
  exp_mul(x: number, y: number): void
  coef_inv(o: number, x: number): void
}

export const wasm = wasmInstance.exports as never as Sr25519Wasm
export const mem = new Uint8Array(memory.buffer)

mem.set(
  new Uint8Array(
    new BigUint64Array([
      0x0000000000000001n,
      0x0000000000008082n,
      0x800000000000808an,
      0x8000000080008000n,
      0x000000000000808bn,
      0x0000000080000001n,
      0x8000000080008081n,
      0x8000000000008009n,
      0x000000000000008an,
      0x0000000000000088n,
      0x0000000080008009n,
      0x000000008000000an,
      0x000000008000808bn,
      0x800000000000008bn,
      0x8000000000008089n,
      0x8000000000008003n,
      0x8000000000008002n,
      0x8000000000000080n,
      0x000000000000800an,
      0x800000008000000an,
      0x8000000080008081n,
      0x8000000000008080n,
      0x0000000080000001n,
      0x8000000080008008n,
    ]).buffer,
  ),
  wasm.keccak_rc_adr.value,
)

writeU256(wasm.coef.value, coef)
writeU256(wasm.exp.value, exp)
writeU256(wasm.neg_coef.value, u256 - coef)
writeU256(wasm.neg_exp.value, u256 - exp)
writeU256(wasm.u256_mod_exp.value, u256 % exp)
writeU256(wasm.coef_neg_two.value, coef - 2n)

writeU256(wasm.free_adr.value, 121666n)
wasm.coef_inv(wasm.rist_d.value, wasm.free_adr.value)
writeU256(wasm.free_adr.value, u256 - 121665n)
wasm.coef_mul(wasm.rist_d.value, wasm.free_adr.value)

export function readU256(adr: number) {
  return $u256.decode(mem.subarray(adr, adr + 32))
}

export function writeU256(adr: number, value: bigint) {
  mem.subarray(adr, adr + 32).set($u256.encode(value))
}
