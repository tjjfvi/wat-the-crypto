export interface Hasher {
  update(data: Uint8Array): void
  digest(): Uint8Array
  digestInto(digest: Uint8Array): void
  dispose(): void
}
