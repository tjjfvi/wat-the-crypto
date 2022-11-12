import * as refImpl from "https://esm.sh/@polkadot/util-crypto@10.1.6/xxhash/index.js"
import { Xxhash } from "../xxhash.ts"
import { testHasher } from "./test_util.ts"

for (const size of [512, 64, 128, 256, 384, 512] as const) {
  testHasher({
    name: `xxhash ${size}`,
    reference: (data) => refImpl.xxhashAsU8a(data, size),
    create: () => new Xxhash(size / 64),
  })
}
