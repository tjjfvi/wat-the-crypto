import { assertEquals } from "https://deno.land/std@0.163.0/testing/asserts.ts"
import { instantiate } from "./sr25519.ts"

const { field, fieldI, scalar, mem, readU256, u256, u512, wasm, writeU256 } = instantiate()

const u256s = [
  0n,
  1n,
  2n,
  (1n << 32n) - 1n,
  1n << 32n,
  1n << 128n,
  u256 - 1n,
  field - 1n,
  scalar - 1n,
  field,
  scalar,
  u256 - field,
  u256 - scalar,
]

for (let i = 0; i < 512; i++) {
  wasm.keccak_f1600(wasm.free_adr.value)
  wasm.keccak_f1600(wasm.free_adr.value + 56)
  u256s.push(readU256(wasm.free_adr.value))
}

const aAdr = wasm.free_adr.value
const bAdr = wasm.free_adr.value + 256
const oAdr = wasm.free_adr.value + 512

Deno.test("u256 add / sub", () => {
  for (const aU256 of u256s) {
    for (const bU256 of u256s) {
      writeU256(aAdr, aU256)
      writeU256(bAdr, bU256)
      wasm._u256_add(aAdr, 1n, bAdr, 0n)
      assertU256Equals(readU256(aAdr), (aU256 + bU256) % u256)

      writeU256(aAdr, aU256)
      writeU256(bAdr, bU256)
      wasm.u256_sub(oAdr, aAdr, bAdr)
      assertU256Equals(readU256(oAdr), (u256 + aU256 - bU256) % u256)
    }
  }
})

Deno.test("mod field / mod scalar", () => {
  for (const aU256 of u256s) {
    writeU256(aAdr, aU256)
    wasm.u256_mod_neg(aAdr, wasm.neg_field.value)
    assertU256Equals(readU256(aAdr), aU256 % field)
    writeU256(aAdr, aU256)
    wasm.u256_mod_neg(aAdr, wasm.neg_scalar.value)
    assertU256Equals(readU256(aAdr), aU256 % scalar)
  }
})

Deno.test("field add", () => {
  for (const aU256 of u256s) {
    for (const bU256 of u256s) {
      writeU256(aAdr, aU256 % field)
      writeU256(bAdr, bU256 % field)
      wasm.field_add(aAdr, bAdr)
      assertU256Equals(readU256(aAdr), (aU256 + bU256) % field)
    }
  }
})

Deno.test("scalar add", () => {
  for (const aU256 of u256s) {
    for (const bU256 of u256s) {
      writeU256(aAdr, aU256 % scalar)
      writeU256(bAdr, bU256 % scalar)
      wasm.scalar_add(aAdr, bAdr)
      assertU256Equals(readU256(aAdr), (aU256 + bU256) % scalar)
    }
  }
})

Deno.test("u256 mul u512", () => {
  for (const aU256 of u256s) {
    for (const bU256 of u256s) {
      writeU256(aAdr, aU256)
      writeU256(bAdr, bU256)
      mem.fill(0, oAdr, oAdr + 64)
      wasm._u256_mul_u512(oAdr, aAdr, bAdr)
      assertU512Equals(readU512(oAdr), (aU256 * bU256) % u512)
    }
  }
})

Deno.test("field mul", () => {
  for (const aU256 of u256s) {
    for (const bU256 of u256s) {
      writeU256(aAdr, aU256)
      writeU256(bAdr, bU256)
      wasm.field_mul(aAdr, bAdr)
      assertU256Equals(readU256(aAdr), (aU256 * bU256) % field)
    }
  }
})

Deno.test("scalar mul", () => {
  for (const aU256 of u256s) {
    for (const bU256 of u256s) {
      writeU256(aAdr, aU256)
      writeU256(bAdr, bU256)
      wasm.scalar_mul(aAdr, bAdr)
      assertU256Equals(readU256(aAdr), (aU256 * bU256) % scalar)
    }
  }
})

Deno.test("field invsqrt", () => {
  for (const aU256 of u256s) {
    if ((aU256 % field) === 0n) continue
    writeU256(aAdr, aU256 % field)
    if (wasm.field_invsqrt(aAdr)) {
      assertU256Equals(readU256(aAdr) ** 2n * aU256 % field, 1n)
    } else {
      assertU256Equals(readU256(aAdr) ** 2n * aU256 % field, fieldI)
    }
  }
})

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
