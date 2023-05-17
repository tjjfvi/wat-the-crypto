import { assertEquals } from "https://deno.land/std@0.163.0/testing/asserts.ts"
import buffer from "https://deno.land/std@0.177.0/node/internal_binding/buffer.ts"
import { coef, exp, mem, readU256, u256, u512, wasm, writeU256 } from "./sr25519.ts"

const u256s = [
  0n,
  1n,
  2n,
  (1n << 32n) - 1n,
  1n << 32n,
  1n << 128n,
  u256 - 1n,
  coef - 1n,
  exp - 1n,
  coef,
  exp,
  u256 - coef,
  u256 - exp,
]

for (let i = 0; i < 256; i++) {
  wasm.keccak_f1600(wasm.free_adr.value)
  wasm.keccak_f1600(wasm.free_adr.value + 56)
  u256s.push(readU256(wasm.free_adr.value))
}

const aAdr = wasm.free_adr.value
const bAdr = wasm.free_adr.value + 256
const oAdr = wasm.free_adr.value + 512

for (const aU256 of u256s) {
  writeU256(aAdr, aU256)
  wasm.u256_mod_neg(aAdr, wasm.neg_coef.value)
  assertU256Equals(readU256(aAdr), aU256 % coef)
  writeU256(aAdr, aU256)
  wasm.u256_mod_neg(aAdr, wasm.neg_exp.value)
  assertU256Equals(readU256(aAdr), aU256 % exp)
}

// for (const aU256 of u256s) {
//   for (const bU256 of u256s) {
//     writeU256(aAdr, aU256)
//     writeU256(bAdr, bU256)
//     wasm._u256_add(aAdr, 1n, bAdr, 0n)
//     assertU256Equals(readU256(aAdr), (aU256 + bU256) % u256)

//     writeU256(aAdr, aU256)
//     writeU256(bAdr, bU256)
//     wasm.u256_sub(oAdr, aAdr, bAdr)
//     assertU256Equals(readU256(oAdr), (u256 + aU256 - bU256) % u256)
//   }
// }

// for (const aU256 of u256s) {
//   for (const bU256 of u256s) {
//     writeU256(aAdr, aU256 % coef)
//     writeU256(bAdr, bU256 % coef)
//     wasm.coef_add(aAdr, bAdr)
//     assertU256Equals(readU256(aAdr), (aU256 + bU256) % coef)
//   }
// }

// for (const aU256 of u256s) {
//   for (const bU256 of u256s) {
//     writeU256(aAdr, aU256 % exp)
//     writeU256(bAdr, bU256 % exp)
//     wasm.exp_add(aAdr, bAdr)
//     assertU256Equals(readU256(aAdr), (aU256 + bU256) % exp)
//   }
// }

// for (const aU256 of u256s) {
//   for (const bU256 of u256s) {
//     writeU256(aAdr, aU256)
//     writeU256(bAdr, bU256)
//     mem.fill(0, oAdr, oAdr + 64)
//     wasm._u256_mul_u512(oAdr, aAdr, bAdr)
//     assertU512Equals(readU512(oAdr), (aU256 * bU256) % u512)
//   }
// }

// for (const aU256 of u256s) {
//   for (const bU256 of u256s) {
//     writeU256(aAdr, aU256)
//     writeU256(bAdr, bU256)
//     wasm.coef_mul(oAdr, aAdr, bAdr)
//     assertU256Equals(readU256(oAdr), (aU256 * bU256) % coef)
//   }
// }

console.log(2n ** 252n)
console.log(exp - (((2n ** 252n) * (exp - (u256 % exp))) >> 256n))

for (const aU256 of [340282366920938463463374607431768211456n]) {
  for (
    const bU256 of [115792089237316195423570985008687907853269984665640564039457584007913129639935n]
  ) {
    console.log(aU256, bU256)
    writeU256(aAdr, aU256)
    writeU256(bAdr, bU256)
    wasm.exp_mul(oAdr, aAdr, bAdr)
    console.log(fmtLongInt(readU512(384), 512))
    console.log(fmtLongInt(aU256 * bU256, 512))
    console.log(fmtLongInt(((aU256 * bU256) % u256) % exp, 256))
    let x = ((aU256 * bU256) >> 256n) % exp
    console.log(fmtLongInt(exp - (((exp - (u256 % exp)) * x) >> 256n), 256))
    console.log(fmtLongInt(exp - (((exp - (u256 % exp)) * x) >> 256n), 256))
    console.log(readU512(384) % exp === (aU256 * bU256) % exp)
    console.log(fmtLongInt(readU512(384), 512))
    console.log(fmtLongInt(readU512(384) % exp, 256))
    console.log(fmtLongInt(readU512(448), 512))
    console.log(fmtLongInt(readU256(wasm.neg_u256_mod_exp.value), 256))
    console.log(fmtLongInt(exp - (u256 % exp), 256))
    console.log(fmtLongInt((exp - (u256 % exp)) * x, 512))
    console.log(fmtLongInt(x, 256))
    console.log(fmtLongInt(exp, 256))
    assertU256Equals(readU256(oAdr), (aU256 * bU256) % exp)
  }
}

function readU512(adr: number) {
  return readU256(adr) | (readU256(adr + 32) << 256n)
}

function assertU256Equals(a: bigint, b: bigint) {
  if (a !== b) {
    assertEquals(fmtLongInt(a, 256), fmtLongInt(b, 256))
  }
}

function assertU512Equals(a: bigint, b: bigint) {
  if (a !== b) {
    assertEquals(fmtLongInt(a, 512), fmtLongInt(b, 512))
  }
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
