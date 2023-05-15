export const log = {
  u32: (x: number) => console.log(x >>> 0),
  u64: (x: bigint) => console.log(x & ((1n << 64n) - 1n)),
  brk: () => console.log(),
}
