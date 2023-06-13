/// <reference lib="deno.unstable"/>

import { DigestAlgorithm } from "https://deno.land/std@0.163.0/crypto/_wasm/mod.ts"
import { crypto } from "https://deno.land/std@0.163.0/crypto/mod.ts"
import { Hasher } from "./hasher.ts"
import { testCases } from "./test_util.ts"

interface BenchHasherProps {
  name: string
  reference: (data: Uint8Array) => Uint8Array
  std?: DigestAlgorithm
  create: () => Hasher
}

export function benchHasher(props: BenchHasherProps) {
  for (const [name, data] of testCases) {
    Deno.bench(`  js ${props.name} ${name}`, () => {
      props.reference(data)
    })
    if (props.std) {
      Deno.bench(` std ${props.name} ${name}`, () => {
        crypto.subtle.digestSync(props.std!, data)
      })
    }
    Deno.bench(`wasm ${props.name} ${name}`, () => {
      const hasher = props.create()
      hasher.update(data)
      hasher.digest()
      hasher.dispose()
    })
  }
}
