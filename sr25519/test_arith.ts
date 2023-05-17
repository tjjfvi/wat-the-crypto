import { assertEquals } from "https://deno.land/std@0.163.0/testing/asserts.ts"
import * as $ from "https://deno.land/x/scale@v0.11.2/mod.ts"
import { memBuf, wasm } from "./sr25519.ts"

const u256s = []

for (let i = 0; i < 128; i++) {
  wasm.keccak_f1600(wasm.free_adr.value)
  wasm.keccak_f1600(wasm.free_adr.value + 56)
  u256s.push(readU256(wasm.free_adr.value))
}

const aAdr = wasm.free_adr.value
const bAdr = wasm.free_adr.value + 256
const oAdr = wasm.free_adr.value + 512

const u512 = 1n << 512n
const u256 = 1n << 256n
const coef = (1n << 255n) - 19n
const exp = (1n << 252n) + 27742317777372353535851937790883648493n

console.log(fmtLongInt(coef, 256))
console.log(fmtLongInt(exp, 256))

for (const aU256 of u256s) {
  for (const bU256 of u256s) {
    writeU256(aAdr, aU256)
    writeU256(bAdr, bU256)
    wasm.u256_add_u32_mul_overflow(aAdr, 1n, bAdr)
    assertU256Equals(readU256(aAdr), (aU256 + bU256) % u256)

    writeU256(aAdr, aU256)
    writeU256(bAdr, bU256)
    wasm.u256_add_u32_mul_overflow(aAdr, -1n, bAdr)
    assertU256Equals(readU256(aAdr), (u256 + aU256 - bU256) % u256)
  }
}

for (const aU256 of u256s) {
  for (const bU256 of u256s) {
    writeU256(aAdr, aU256 % coef)
    writeU256(bAdr, bU256 % coef)
    wasm.coef_add(aAdr, bAdr)
    assertU256Equals(readU256(aAdr), (aU256 + bU256) % coef)
  }
}

// for (const aU256 of u256s) {
//   for (const bU256 of u256s) {
//     writeU256(aAdr, aU256 % exp)
//     writeU256(bAdr, bU256 % exp)
//     wasm.coef_add(aAdr, bAdr)
//     assertU256Equals(readU256(aAdr), (aU256 + bU256) % exp)
//   }
// }

for (const aU256 of u256s) {
  for (const bU256 of u256s) {
    console.log("---")
    writeU256(aAdr, aU256)
    writeU256(bAdr, bU256)
    memBuf.fill(0, oAdr, oAdr + 64)
    wasm._u256_mul_u512(oAdr, aAdr, bAdr)
    assertU512Equals(readU512(oAdr), (aU256 * bU256) % u512)
  }
}

function readU512(adr: number) {
  return readU256(adr) | (readU256(adr + 32) << 256n)
}

function readU256(adr: number) {
  return $.u256.decode(memBuf.subarray(adr, adr + 32))
}

function writeU256(adr: number, value: bigint) {
  memBuf.subarray(adr, adr + 32).set($.u256.encode(value))
}

function assertU256Equals(a: bigint, b: bigint) {
  assertEquals(fmtLongInt(a, 256), fmtLongInt(b, 256))
}

function assertU512Equals(a: bigint, b: bigint) {
  assertEquals(fmtLongInt(a, 512), fmtLongInt(b, 512))
}

function fmtLongInt(x: bigint, bits: number) {
  return fmtInt(x, bits).split(/(?=(?:.{8})+$)/).join("_")
}

function fmtInt(x: number | bigint, bits: number) {
  return x
    .toString(16)
    .padStart(bits / 4, "0")
    .split(/(?=(?:..)+$)/)
    .reverse()
    .join("")
}
