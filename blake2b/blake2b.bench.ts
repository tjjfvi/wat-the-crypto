import * as refImpl from "https://esm.sh/@noble/hashes@1.1.2/blake2b"
import { benchHasher } from "../bench_util.ts"
import { Blake2b } from "./blake2b.ts"

benchHasher({
  name: "blake2b",
  reference: (data) => refImpl.blake2b(data),
  std: "BLAKE2B",
  create: () => new Blake2b(),
})
