const u64 = (1n << 64n) - 1n
export const log = {
  u32: (x: number) => console.log(fmtInt(x >>> 0, 32), x >>> 0),
  u64: (x: bigint) => console.log(fmtInt(x & u64, 64), x & u64),
  i32: (x: number) => console.log(fmtInt(x >>> 0, 32), x),
  i64: (x: bigint) => console.log(fmtInt(x & u64, 64), x),
  brk: () => console.log(),
}

export function fmtInt(x: number | bigint, bits: number) {
  return x
    .toString(16)
    .padStart(bits / 4, "0")
    .split(/(?=(?:..)+$)/)
    .reverse()
    .join("")
}
