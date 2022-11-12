import * as refImpl from "https://esm.sh/@noble/hashes@1.1.2/blake2b"
import { Blake2b } from "../blake2b.ts"
import { testHasher } from "./test_util.ts"

for (const size of [512, 8, 16, 32, 64, 128, 256] as const) {
  testHasher({
    name: `blake2b ${size}`,
    reference: (data) => refImpl.blake2b(data, { dkLen: size / 8 }),
    create: () => new Blake2b(size / 8),
  })
}
