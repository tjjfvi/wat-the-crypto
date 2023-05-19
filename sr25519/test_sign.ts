import { assertEquals } from "https://deno.land/std@0.163.0/testing/asserts.ts"
import { decodeHex, encodeHex } from "../common/hex.ts"
import { fmtInt } from "../common/log.ts"
import { mem, readU256, wasm } from "./sr25519.ts"
import { readU512 } from "./test_arith.ts"

const secret = decodeHex(
  "caa835781b15c7706f65b71f7a58c807ab360faed6440fb23e0f4c52e930de0a0a6a85eaa642dac835424b5d7c8d637c00408c7a73da672b7f498521420b6dd3",
)
const pubkey = decodeHex("def12e42f3e487e9b14095aa8d5cc16a33491f1b50dadcf8811d1480f3fa8627")

mem.set(
  decodeHex(
    "caa835781b15c7706f65b71f7a58c807ab360faed6440fb23e0f4c52e930de0a0a6a85eaa642dac835424b5d7c8d637c00408c7a73da672b7f498521420b6dd3def12e42f3e487e9b14095aa8d5cc16a33491f1b50dadcf8811d1480f3fa8627",
  ),
  wasm.free_adr.value,
)

const message = new TextEncoder().encode("hello world")

mem.set(message, wasm.free_adr.value + 96 + 64)

mem[wasm.free_adr.value + 1000] = 1

wasm.sign(
  wasm.free_adr.value + 96 + 64,
  message.length,
  wasm.free_adr.value + 64,
  wasm.free_adr.value,
  wasm.free_adr.value + 1000,
  wasm.free_adr.value + 96,
)
console.log(wasm.free_adr.value + 100)

// console.log(encodeHex(mem.slice(3013, 3013 + 128)))

// assertEquals(
//   encodeHex(mem.slice(wasm.free_adr.value + 96, wasm.free_adr.value + 96 + 64)),
//   "b86ab8e1dc16ac59b69f55546c62b5cb40c9d4123985e80d2ba8b4f36394bd10ac5f34ae9f0780a03d4579b818bdee0e0df662f3006c01965da09956f34ccb89",
// )
assertEquals(
  encodeHex(mem.slice(wasm.free_adr.value + 96, wasm.free_adr.value + 96 + 64)),
  "a0a7d8574c54b9c789133e1901176a5f16eb10c773430406d872f8f4436b8a4f2ddc3bc306f8d2dfda7ccddd040980f4d523d8c454e652985e342660dc31bb81",
)
console.log(encodeHex(mem.slice(wasm.free_adr.value + 96 + 32, wasm.free_adr.value + 96 + 64)))

console.log("!!!", fmtInt(readU256(3276), 512))

console.log(fmtInt(readU256(1733), 256))

console.log("---")
console.log(encodeHex(mem.slice(2501, 2501 + 200)))
console.log("---")
console.log(encodeHex(mem.slice(2757, 2757 + 200)))
// console.log(mem[2501 + 200])
// console.log(mem[2501 + 201])
