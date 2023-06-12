import { assertEquals } from "https://deno.land/std@0.163.0/testing/asserts.ts"
import { decodeHex, encodeHex } from "../common/hex.ts"
import { sign } from "./sr25519.ts"

const secret = decodeHex(
  "5046adc1dba838867b2bbbfdd0c3423e58b57970b5267a90f57960924a87f1560a6a85eaa642dac835424b5d7c8d637c00408c7a73da672b7f498521420b6dd3",
)
const pubkey = decodeHex(
  "def12e42f3e487e9b14095aa8d5cc16a33491f1b50dadcf8811d1480f3fa8627",
)

Deno.test("sign 'hello world' rand 0", () => {
  assertEquals(
    encodeHex(sign(secret, pubkey, new TextEncoder().encode("hello world"), new Uint8Array(32))),
    "b86ab8e1dc16ac59b69f55546c62b5cb40c9d4123985e80d2ba8b4f36394bd10ac5f34ae9f0780a03d4579b818bdee0e0df662f3006c01965da09956f34ccb89",
  )
})

Deno.test("sign 'hello world' rand 1", () => {
  assertEquals(
    encodeHex(sign(secret, pubkey, new TextEncoder().encode("hello world"), new Uint8Array([1]))),
    "a0a7d8574c54b9c789133e1901176a5f16eb10c773430406d872f8f4436b8a4f2ddc3bc306f8d2dfda7ccddd040980f4d523d8c454e652985e342660dc31bb81",
  )
})
