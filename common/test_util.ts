import { assertEquals } from "https://deno.land/std@0.163.0/testing/asserts.ts"
import { assertSnapshot } from "https://deno.land/std@0.163.0/testing/snapshot.ts"
import { Hasher } from "./hasher.ts"
import { encodeHex } from "./hex.ts"

interface TestHasherProps {
  name: string
  reference: (data: Uint8Array) => Uint8Array
  create: () => Hasher
}

const lorem =
  // cspell:disable-next-line
  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

const license = await fetch(new URL("../LICENSE", import.meta.url)).then((r) => r.arrayBuffer())

export const testCases: [name: string, data: Uint8Array][] = [
  ["empty", new Uint8Array()],
  ["[0; 1024]", new Uint8Array(1024)],
  ["0..256", new Uint8Array(Array.from({ length: 256 }, (_, i) => i))],
  ["lorem", new TextEncoder().encode(lorem)],
  ["license", new Uint8Array(license)],
]

export function testHasher(props: TestHasherProps) {
  Deno.test(props.name, async (t) => {
    for (const [name, data] of testCases) {
      await t.step(name, async (t) => {
        const hash = encodeHex(props.reference(data))
        await t.step(`reference`, async (t) => {
          await assertSnapshot(t, hash)
        })
        await t.step(`straight`, () => {
          const hasher = props.create()
          hasher.update(data)
          assertEquals(encodeHex(hasher.digest()), hash)
          hasher.dispose()
        })
        for (const chunkSize of [1, 13, 31, 32, 33, 49, 64, 65, 113]) {
          await t.step(`chunked ${chunkSize}`, () => {
            const hasher = props.create()
            for (let i = 0; i < data.length; i += chunkSize) {
              hasher.update(data.subarray(i, i + chunkSize))
            }
            assertEquals(encodeHex(hasher.digest()), hash)
            hasher.dispose()
          })
        }
      })
    }
  })
}
