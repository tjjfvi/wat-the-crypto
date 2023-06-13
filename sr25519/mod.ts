import { derivePubkey, secretFromSeed64, sign } from "./sr25519.ts"

export class Sr25519 {
  constructor(readonly publicKey: Uint8Array, readonly secretKey: Uint8Array) {
    if (publicKey.length !== 32) throw new Error("Invalid publicKey")
    if (secretKey.length !== 64) throw new Error("Invalid secretKey")
  }

  static fromSecret(secret: Uint8Array) {
    return new Sr25519(derivePubkey(secret), secret)
  }

  static fromSeed64(seed: Uint8Array) {
    return Sr25519.fromSecret(secretFromSeed64(seed))
  }

  sign(ctx: Uint8Array, msg: Uint8Array) {
    return sign(ctx, this.secretKey, this.publicKey, msg)
  }
}
