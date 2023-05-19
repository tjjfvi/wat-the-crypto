import { assertEquals } from "https://deno.land/std@0.163.0/testing/asserts.ts"
import { instantiate } from "./sr25519.ts"

const { mem, wasm } = instantiate()

const state = new BigUint64Array(mem.buffer, wasm.free_adr.value, 25)

Deno.test("keccak", () => {
  state.fill(0n)

  wasm.keccak_f1600(state.byteOffset)

  assertEquals(
    state,
    new BigUint64Array([
      0xf1258f7940e1dde7n,
      0x84d5ccf933c0478an,
      0xd598261ea65aa9een,
      0xbd1547306f80494dn,
      0x8b284e056253d057n,
      0xff97a42d7f8e6fd4n,
      0x90fee5a0a44647c4n,
      0x8c5bda0cd6192e76n,
      0xad30a6f71b19059cn,
      0x30935ab7d08ffc64n,
      0xeb5aa93f2317d635n,
      0xa9a6e6260d712103n,
      0x81a57c16dbcf555fn,
      0x43b831cd0347c826n,
      0x01f22f1a11a5569fn,
      0x05e5635a21d9ae61n,
      0x64befef28cc970f2n,
      0x613670957bc46611n,
      0xb87c5a554fd00ecbn,
      0x8c3ee88a1ccf32c8n,
      0x940c7922ae3a2614n,
      0x1841f924a2c509e4n,
      0x16f53526e70465c2n,
      0x75f644e97f30a13bn,
      0xeaf1ff7b5ceca249n,
    ]),
  )

  wasm.keccak_f1600(state.byteOffset)

  assertEquals(
    state,
    new BigUint64Array([
      0x2d5c954df96ecb3cn,
      0x6a332cd07057b56dn,
      0x093d8d1270d76b6cn,
      0x8a20d9b25569d094n,
      0x4f9c4f99e5e7f156n,
      0xf957b9a2da65fb38n,
      0x85773dae1275af0dn,
      0xfaf4f247c3d810f7n,
      0x1f1b9ee6f79a8759n,
      0xe4fecc0fee98b425n,
      0x68ce61b6b9ce68a1n,
      0xdeea66c4ba8f974fn,
      0x33c43d836eafb1f5n,
      0xe00654042719dbd9n,
      0x7cf8a9f009831265n,
      0xfd5449a6bf174743n,
      0x97ddad33d8994b40n,
      0x48ead5fc5d0be774n,
      0xe3b8c8ee55b7b03cn,
      0x91a0226e649e42e9n,
      0x900e3129e7badd7bn,
      0x202a9ec5faa3cce8n,
      0x5b3402464e1c3db6n,
      0x609f4e62a44c1059n,
      0x20d06cd26a8fbf5cn,
    ]),
  )
})
