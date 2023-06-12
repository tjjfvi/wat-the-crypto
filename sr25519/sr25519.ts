import { assertEquals } from "https://deno.land/std@0.163.0/testing/asserts.ts"
import { u256 as $u256 } from "https://deno.land/x/scale@v0.11.2/codecs/int.ts"
// import { log } from "../common/log.ts"
import keccakCode from "./keccak.wasm.ts"
import ristrettoCode from "./ristretto.wasm.ts"
import sr25519Code from "./sr25519.wasm.ts"

console.log(keccakCode.length, "bytes of wasm")
console.log(ristrettoCode.length, "bytes of wasm")
console.log(sr25519Code.length, "bytes of wasm")

export const { sign } = instantiate()

export function instantiate() {
  const u512 = 1n << 512n
  const u256 = 1n << 256n
  const field = (1n << 255n) - 19n
  const scalar = (1n << 252n) + 27742317777372353535851937790883648493n
  const fieldI = 19681161376707505956807079304988542015446066515923890162744021073123829784752n
  const ristD = 37095705934669439343138083508754565189542113879843219016388785533085940283555n

  const memory = new WebAssembly.Memory({ initial: 10, maximum: 128 })

  const keccakModule = new WebAssembly.Module(keccakCode)
  const keccakInstance = new WebAssembly.Instance(keccakModule, {
    host: { memory },
    // log,
  })

  const ristrettoModule = new WebAssembly.Module(ristrettoCode)
  const ristrettoInstance = new WebAssembly.Instance(ristrettoModule, {
    host: { memory },
    // log,
  })

  const sr25519Module = new WebAssembly.Module(sr25519Code)
  const sr25519Instance = new WebAssembly.Instance(sr25519Module, {
    host: { memory },
    keccak: keccakInstance.exports,
    ristretto: ristrettoInstance.exports,
    // log,
  })

  interface Wasm {
    keccak_rc_adr: WebAssembly.Global
    field: WebAssembly.Global
    scalar: WebAssembly.Global
    neg_field: WebAssembly.Global
    neg_scalar: WebAssembly.Global
    u256_mod_scalar: WebAssembly.Global
    field_neg_two: WebAssembly.Global
    rist_d: WebAssembly.Global
    field_invsqrt_pow: WebAssembly.Global
    field_i: WebAssembly.Global
    field_neg_i: WebAssembly.Global
    field_neg_one: WebAssembly.Global
    rist_inv_root_a_sub_d: WebAssembly.Global
    curve_a: WebAssembly.Global
    rist_2d: WebAssembly.Global
    rist_basepoint: WebAssembly.Global
    rist_zero: WebAssembly.Global
    free_adr: WebAssembly.Global

    keccak_f1600(adr: number): void

    _u256_add(o: number, s: bigint, x: number, n: bigint): number
    u256_sub(o: number, x: number, y: number): number
    u256_mod_neg(x: number, y: number): number
    _u256_mul_u512(o: number, x: number, y: number): void
    field_add(o: number, x: number): void
    field_mul(x: number, y: number): void
    scalar_add(o: number, x: number): void
    scalar_mul(x: number, y: number): void
    field_invsqrt(o: number): number

    rist_decode(o: number, s: number): number
    rist_encode(o: number, x: number): number

    curve_dbl(x: number): void
    curve_add(x: number, y: number): void

    sign(
      msg_adr: number,
      msg_len: number,
      pub_adr: number,
      key_adr: number,
      rng_adr: number,
      sig_adr: number,
    ): void
  }

  const wasm = {
    ...keccakInstance.exports,
    ...ristrettoInstance.exports,
    ...sr25519Instance.exports,
  } as never as Wasm
  const mem = new Uint8Array(memory.buffer)

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

  writeU256(wasm.field.value, field)
  writeU256(wasm.scalar.value, scalar)
  writeU256(wasm.neg_field.value, u256 - field)
  writeU256(wasm.neg_scalar.value, u256 - scalar)
  writeU256(wasm.u256_mod_scalar.value, u256 % scalar)
  writeU256(wasm.field_neg_two.value, field - 2n)
  writeU256(wasm.field_invsqrt_pow.value, 3n + 7n * (field - 5n) / 8n)
  writeU256(wasm.field_i.value, fieldI)
  writeU256(wasm.field_neg_i.value, field - fieldI)
  writeU256(wasm.field_neg_one.value, field - 1n)
  writeU256(
    wasm.rist_inv_root_a_sub_d.value,
    54469307008909316920995813868745141605393597292927456921205312896311721017578n,
  )
  writeU256(wasm.rist_d.value, ristD)
  writeU256(wasm.curve_a.value, 486662n)
  writeU256(wasm.rist_2d.value, 2n * ristD)
  writeU256(
    wasm.rist_basepoint.value,
    7413488746097234319268533557746747958297143720389000677696299943083562100178n,
  )
  writeU256(
    wasm.rist_basepoint.value + 32,
    9771384041963202563870679428059935816164187996444183106833894008023910952347n,
  )
  writeU256(wasm.rist_basepoint.value + 64, 1n)
  writeU256(
    wasm.rist_basepoint.value + 96,
    11068640767834918466713275874066756361490786778694627043054626174422747718218n,
  )
  writeU256(wasm.rist_zero.value + 32, 1n)
  writeU256(wasm.rist_zero.value + 64, 1n)

  function sign(
    secret: Uint8Array,
    pubkey: Uint8Array,
    msg: Uint8Array,
    rand = crypto.getRandomValues(new Uint8Array(32)),
  ) {
    assertEquals(secret.length, 64)
    assertEquals(pubkey.length, 32)
    const secretAdr = wasm.free_adr.value
    const pubkeyAdr = secretAdr + 64
    const randAdr = pubkeyAdr + 32
    const sigAdr = randAdr + 32
    const msgAdr = sigAdr + 64
    mem.set(secret, secretAdr)
    mem.set(pubkey, pubkeyAdr)
    mem.set(msg, msgAdr)
    mem.set(rand, randAdr)
    wasm.sign(
      msgAdr,
      msg.length,
      pubkeyAdr,
      secretAdr,
      randAdr,
      sigAdr,
    )
    const sig = mem.slice(sigAdr, sigAdr + 64)
    mem.fill(0, secretAdr, msgAdr + msg.length - secretAdr)
    return sig
  }

  function readU256(adr: number) {
    return $u256.decode(mem.subarray(adr, adr + 32))
  }

  function writeU256(adr: number, value: bigint) {
    mem.subarray(adr, adr + 32).set($u256.encode(value))
  }

  return { readU256, writeU256, wasm, mem, u256, u512, field, scalar, ristD, fieldI, sign }
}
