(module
  (import "sr25519" "memory" (memory 1))

  (import "log" "u32" (func $log_u32 (param i32)))
  (import "log" "u64" (func $log_u64 (param i64)))
  (import "log" "i32" (func $log_i32 (param i32)))
  (import "log" "i64" (func $log_i64 (param i64)))
  (import "log" "brk" (func $log_brk))
  (func $dbg_u32 (param $v i32) (result i32) local.get $v call $log_u32 local.get $v)
  (func $dbg_u64 (param $v i64) (result i64) local.get $v call $log_u64 local.get $v)
  (func $dbg_i32 (param $v i32) (result i32) local.get $v call $log_i32 local.get $v)
  (func $dbg_i64 (param $v i64) (result i64) local.get $v call $log_i64 local.get $v)

  ;; 192 bytes
  (export "keccak_rc_adr" (global $keccak_rc_adr))
  (global $keccak_rc_adr i32 (i32.const 0))
  (global $keccak_rc_end i32 (i32.const 192))

  ;; 32 bytes
  (export "coef" (global $coef))
  (global $coef i32 (i32.const 192))

  ;; 32 bytes
  (export "exp" (global $exp))
  (global $exp i32 (i32.const 224))

  ;; 32 bytes
  ;; u256 - coef
  (export "neg_coef" (global $neg_coef))
  (global $neg_coef i32 (i32.const 256))

  ;; 32 bytes
  ;; -exp
  (export "neg_exp" (global $neg_exp))
  (global $neg_exp i32 (i32.const 288))

  ;; 32 bytes
  ;; u256 % exp
  (export "u256_mod_exp" (global $u256_mod_exp))
  (global $u256_mod_exp i32 (i32.const 320))

  ;; 32 bytes
  ;; coef - 2
  (export "coef_neg_two" (global $coef_neg_two))
  (global $coef_neg_two i32 (i32.const 352))

  ;; 32 bytes
  ;; 1
  (global $one i32 (i32.const 384))
  (data (i32.const 384) "\01")

  ;; 32 bytes
  (global $u256_mod_tmp i32 (i32.const 416))

  ;; 64 bytes
  (global $coef_mul_tmp i32 (i32.const 448))
  (global $coef_mul_tmp_shr_256 i32 (i32.const 480))

  ;; 64 bytes
  (global $exp_mul_tmp i32 (i32.const 512))
  (global $exp_mul_tmp_shr_256 i32 (i32.const 544))

  ;; 32 bytes
  (global $coef_mul_eq_tmp i32 (i32.const 576))

  (global $rist_decomp_tmp_s i32 (i32.const 608))
  (global $rist_decomp_tmp_u1 i32 (i32.const 640))
  (global $rist_decomp_tmp_u2 i32 (i32.const 672))
  (global $rist_decomp_tmp_v i32 (i32.const 704))
  (global $rist_decomp_tmp_i i32 (i32.const 736))
  (global $rist_decomp_tmp_dx i32 (i32.const 768))
  (global $rist_decomp_tmp_dy i32 (i32.const 800))
  (global $rist_decomp_tmp_u2_2 i32 (i32.const 832))

  ;; 32 bytes
  ;; 2
  (global $two i32 (i32.const 864))
  (data (i32.const 864) "\02")

  ;; 32 bytes
  ;; -121665/121666
  (export "rist_d" (global $rist_d))
  (global $rist_d i32 (i32.const 896))

  (global (export "free_adr") i32 (i32.const 896))

  (func $_keccak_0 (param $adr i32) (result i32) (result i64)
    (i32.add (local.get $adr) (i32.const 8))
    (i64.load offset=0 (local.get $adr))
    (i64.xor (i64.load offset=40 (local.get $adr)))
    (i64.xor (i64.load offset=80 (local.get $adr)))
    (i64.xor (i64.load offset=120 (local.get $adr)))
    (i64.xor (i64.load offset=160 (local.get $adr)))
  )

  (func $_keccak_1 (param $adr i32) (param $n i64) (result i32)
    (i32.add (local.get $adr) (i32.const 8))
    (i64.store offset=0 (local.get $adr) (i64.load offset=0 (local.get $adr)) (i64.xor (local.get $n)))
    (i64.store offset=40 (local.get $adr) (i64.load offset=40 (local.get $adr)) (i64.xor (local.get $n)))
    (i64.store offset=80 (local.get $adr) (i64.load offset=80 (local.get $adr)) (i64.xor (local.get $n)))
    (i64.store offset=120 (local.get $adr) (i64.load offset=120 (local.get $adr)) (i64.xor (local.get $n)))
    (i64.store offset=160 (local.get $adr) (i64.load offset=160 (local.get $adr)) (i64.xor (local.get $n)))
  )

  (func $_keccak_2 (param $adr i32) (param $v i64) (param $n i32) (param $l i64) (result i32) (result i64)
    (local.get $adr)
    (i64.load (local.tee $adr (i32.add (local.get $adr) (local.get $n))))
    (i64.store (local.get $adr) (i64.rotl (local.get $v) (local.get $l)))
  )

  (func $_keccak_3 (param $adr i32) (result i32)
    (local $x0 i64)
    (local $x1 i64)
    (local $x2 i64)
    (local $x3 i64)
    (local $x4 i64)

    (i32.add (local.get $adr) (i32.const 40))
    (local.set $x0 (i64.load offset=0 (local.get $adr)))
    (local.set $x1 (i64.load offset=8 (local.get $adr)))
    (local.set $x2 (i64.load offset=16 (local.get $adr)))
    (local.set $x3 (i64.load offset=24 (local.get $adr)))
    (local.set $x4 (i64.load offset=32 (local.get $adr)))
    (i64.store offset=0 (local.get $adr) (local.get $x0) (i64.xor (i64.and (local.get $x2) (i64.xor (local.get $x1) (i64.const -1)))))
    (i64.store offset=8 (local.get $adr) (local.get $x1) (i64.xor (i64.and (local.get $x3) (i64.xor (local.get $x2) (i64.const -1)))))
    (i64.store offset=16 (local.get $adr) (local.get $x2) (i64.xor (i64.and (local.get $x4) (i64.xor (local.get $x3) (i64.const -1)))))
    (i64.store offset=24 (local.get $adr) (local.get $x3) (i64.xor (i64.and (local.get $x0) (i64.xor (local.get $x4) (i64.const -1)))))
    (i64.store offset=32 (local.get $adr) (local.get $x4) (i64.xor (i64.and (local.get $x1) (i64.xor (local.get $x0) (i64.const -1)))))
  )

  (export "keccak_f1600" (func $keccak_f1600))
  (func $keccak_f1600 (param $adr i32)
    (local $rc_adr i32)
    (local $x0 i64)
    (local $x1 i64)
    (local $x2 i64)
    (local $x3 i64)
    (local $x4 i64)
    (local $n i64)

    (local.set $rc_adr (global.get $keccak_rc_adr))

    (loop $rc
      (local.get $adr)
      (local.set $x0 (call $_keccak_0))
      (local.set $x1 (call $_keccak_0))
      (local.set $x2 (call $_keccak_0))
      (local.set $x3 (call $_keccak_0))
      (local.set $x4 (call $_keccak_0))
      (drop)

      (local.get $adr)
      (call $_keccak_1 (local.get $x4) (i64.xor (i64.rotl (local.get $x1) (i64.const 1))))
      (call $_keccak_1 (local.get $x0) (i64.xor (i64.rotl (local.get $x2) (i64.const 1))))
      (call $_keccak_1 (local.get $x1) (i64.xor (i64.rotl (local.get $x3) (i64.const 1))))
      (call $_keccak_1 (local.get $x2) (i64.xor (i64.rotl (local.get $x4) (i64.const 1))))
      (call $_keccak_1 (local.get $x3) (i64.xor (i64.rotl (local.get $x0) (i64.const 1))))
      (drop)

      (local.get $adr) (i64.load offset=8 (local.get $adr))
      (call $_keccak_2 (i32.const 80) (i64.const 1))
      (call $_keccak_2 (i32.const 56) (i64.const 3))
      (call $_keccak_2 (i32.const 88) (i64.const 6))
      (call $_keccak_2 (i32.const 136) (i64.const 10))
      (call $_keccak_2 (i32.const 144) (i64.const 15))
      (call $_keccak_2 (i32.const 24) (i64.const 21))
      (call $_keccak_2 (i32.const 40) (i64.const 28))
      (call $_keccak_2 (i32.const 128) (i64.const 36))
      (call $_keccak_2 (i32.const 64) (i64.const 45))
      (call $_keccak_2 (i32.const 168) (i64.const 55))
      (call $_keccak_2 (i32.const 192) (i64.const 2))
      (call $_keccak_2 (i32.const 32) (i64.const 14))
      (call $_keccak_2 (i32.const 120) (i64.const 27))
      (call $_keccak_2 (i32.const 184) (i64.const 41))
      (call $_keccak_2 (i32.const 152) (i64.const 56))
      (call $_keccak_2 (i32.const 104) (i64.const 8))
      (call $_keccak_2 (i32.const 96) (i64.const 25))
      (call $_keccak_2 (i32.const 16) (i64.const 43))
      (call $_keccak_2 (i32.const 160) (i64.const 62))
      (call $_keccak_2 (i32.const 112) (i64.const 18))
      (call $_keccak_2 (i32.const 176) (i64.const 39))
      (call $_keccak_2 (i32.const 72) (i64.const 61))
      (call $_keccak_2 (i32.const 48) (i64.const 20))
      (call $_keccak_2 (i32.const 8) (i64.const 44))
      (drop) (drop)

      (local.get $adr)
      (call $_keccak_3)
      (call $_keccak_3)
      (call $_keccak_3)
      (call $_keccak_3)
      (call $_keccak_3)
      (drop)

      (i64.store (local.get $adr) (i64.load (local.get $adr)) (i64.xor (i64.load (local.get $rc_adr))))
      (local.tee $rc_adr (i32.add (local.get $rc_adr) (i32.const 8)))
      (br_if $rc (i32.lt_u (global.get $keccak_rc_end)))
    )
  )

  (global $strobe_i i32 (i32.const 0x00))
  (global $strobe_a i32 (i32.const 0x01))
  (global $strobe_c i32 (i32.const 0x02))
  (global $strobe_t i32 (i32.const 0x04))
  (global $strobe_m i32 (i32.const 0x08))
  (global $strobe_k i32 (i32.const 0x10))

  (global $strobe_ck i32 (i32.const 0x12))
  (global $strobe_ma i32 (i32.const 0x09))
  (global $strobe_ac i32 (i32.const 0x03))

  (data $strobe_init_data
    "\9c\6d\16\8f\f8\fd\55\da"
    "\2a\a7\3c\23\55\65\35\63"
    "\dc\0c\47\5c\55\15\26\f6"
    "\73\3b\ea\22\f1\6c\b5\7c"
    "\d3\1f\68\2e\66\0e\e9\12"
    "\82\4a\77\22\01\ee\13\94"
    "\22\6f\4a\fc\b6\2d\33\12"
    "\93\cc\92\e8\a6\24\ac\f6"
    "\e1\b6\00\95\e3\22\bb\fb"
    "\c8\45\e5\b2\69\95\fe\7d"
    "\7c\84\13\74\d1\ff\58\98"
    "\c9\2e\e0\63\6b\06\72\73"
    "\21\c9\2a\60\39\07\03\53"
    "\49\cc\bb\1b\92\b7\b0\05"
    "\7e\8f\a8\7f\ce\bc\7e\88"
    "\65\6f\cb\45\ae\04\bc\34"
    "\ca\be\ae\be\79\d9\17\50"
    "\c0\e8\bf\13\b9\66\50\4d"
    "\13\43\59\72\65\dd\88\65"
    "\ad\f9\14\09\cc\9b\20\d5"
    "\f4\74\44\04\1f\97\b6\99"
    "\dd\fb\de\e9\1e\a8\7b\d0"
    "\9b\f8\b0\2d\a7\5a\96\e9"
    "\47\f0\7f\5b\65\bb\4e\6e"
    "\fe\fa\a1\6a\bf\d9\fb\f6"
  )

  (func $strobe_init (param $strobe i32)

  )

  (func $strobe_begin_op (param $strobe i32) (param $flags i32)
    (local $pos i32)
    (local $adr i32)
    (local $old_begin i32)

    (local.set $old_begin (i32.load8_u offset=201 (local.get $strobe)))
    (local.set $pos (i32.load8_u offset=200 (local.get $strobe)))
    (i32.store8 offset=201 (local.get $strobe) (i32.add (local.get $pos) (i32.const 1)))

    (local.tee $adr (i32.add (local.get $pos) (local.get $strobe)))
    (i32.store8 (i32.xor (i32.load8_u (local.get $adr)) (local.get $old_begin)))
    (local.tee $pos (i32.add (local.get $pos) (i32.const 1)))
    (if (i32.eq (global.get $strobe_r)) (then
      (call $strobe_run_f (local.get $strobe) (local.get $pos))
      (local.set $pos (i32.const 0))
    ))

    (local.tee $adr (i32.add (local.get $pos) (local.get $strobe)))
    (i32.store8 (i32.xor (i32.load8_u (local.get $adr)) (local.get $flags)))
    (local.tee $pos (i32.add (local.get $pos) (i32.const 1)))
    (if (i32.or (i32.and (local.get $flags) (global.get $strobe_ck)) (i32.eq (global.get $strobe_r))) (then
      (call $strobe_run_f (local.get $strobe) (local.get $pos))
      (local.set $pos (i32.const 0))
    ))
    (i32.store8 offset=200 (local.get $strobe) (local.get $pos))
  )

  (global $strobe_r i32 (i32.const 166))

  (func $strobe_absorb (param $strobe i32) (param $read_adr i32) (param $read_len i32)
    (local $read_end i32)
    (local $pos i32)
    (local $adr i32)

    (local.set $read_end (i32.add (local.get $read_adr) (local.get $read_len)))
    (local.set $pos (i32.load8_u offset=200 (local.get $strobe)))

    (loop $read
      (local.tee $adr (i32.add (local.get $pos) (local.get $strobe)))
      (i32.store8 (i32.xor (i32.load8_u (local.get $adr)) (i32.load8_u (local.get $read_adr))))
      (local.tee $pos (i32.add (local.get $pos) (i32.const 1)))
      (if (i32.eq (global.get $strobe_r)) (then
        (call $strobe_run_f (local.get $strobe) (local.get $pos))
        (local.set $pos (i32.const 0))
      ))
      (local.tee $read_adr (i32.add (local.get $read_adr) (i32.const 1)))
      (br_if $read (i32.lt_u (local.get $read_end)))
    )
    (i32.store8 offset=200 (local.get $strobe) (local.get $pos))
  )

  (func $strobe_overwrite (param $strobe i32) (param $read_adr i32) (param $read_len i32)
    (local $read_end i32)
    (local $pos i32)

    (local.set $read_end (i32.add (local.get $read_adr) (local.get $read_len)))
    (local.set $pos (i32.load8_u offset=200 (local.get $strobe)))

    (loop $read
      (i32.store8 (i32.add (local.get $pos) (local.get $strobe)) (i32.load8_u (local.get $read_adr)))
      (local.tee $pos (i32.add (local.get $pos) (i32.const 1)))
      (if (i32.eq (global.get $strobe_r)) (then
        (call $strobe_run_f (local.get $strobe) (local.get $pos))
        (local.set $pos (i32.const 0))
      ))
      (local.tee $read_adr (i32.add (local.get $read_adr) (i32.const 1)))
      (br_if $read (i32.lt_u (local.get $read_end)))
    )
    (i32.store8 offset=200 (local.get $strobe) (local.get $pos))
  )

  (func $strobe_run_f (param $strobe i32) (param $pos i32)
    (local $adr i32)
    (local.tee $adr (i32.add (local.get $strobe) (local.get $pos)))
    (i32.store16 (i32.xor (i32.load16_u (local.get $adr)) (i32.load16_u offset=201 (local.get $strobe))))
    (i32.store8 offset=167 (local.get $strobe) (i32.xor (i32.load8_u offset=167 (local.get $strobe)) (i32.const 0x80)))
    (call $keccak_f1600 (local.get $strobe))
    (i32.store16 offset=200 (local.get $strobe) (i32.const 0))
  )

  (func $_u256_add_0
    (param $o i32) (param $s i64) (param $x i32) (param $n i64)
    (result i32) (result i64) (result i32) (result i64)

    (i32.add (local.get $o) (i32.const 4))
    (local.get $s)
    (i32.add (local.get $x) (i32.const 4))
    (i64.store32 (local.get $o) (local.tee $n
      (local.get $n)
      (i64.add (i64.load32_u (local.get $o)))
      (i64.add (i64.mul (local.get $s) (i64.load32_u offset=0 (local.get $x))))
    ))
    (i64.shr_u (local.get $n) (i64.const 32))
  )

  ;; *o += (s as u32) * (*x) + n
  ;; returns overflow
  (export "_u256_add" (func $_u256_add))
  (func $_u256_add (param $o i32) (param $s i64) (param $x i32) (param $n i64) (result i32)

    (local.get $o) (local.get $s) (local.get $x) (local.get $n)
    (call $_u256_add_0)
    (call $_u256_add_0)
    (call $_u256_add_0)
    (call $_u256_add_0)
    (call $_u256_add_0)
    (call $_u256_add_0)
    (call $_u256_add_0)
    (call $_u256_add_0)
    (local.set $n) (drop) (drop) (drop)

    (i32.wrap_i64 (local.get $n))
  )

  ;; *o %= -(*x)
  (export "u256_mod_neg" (func $u256_mod_neg))
  (func $u256_mod_neg (param $o i32) (param $x i32)
    (memory.copy (global.get $u256_mod_tmp) (local.get $o) (i32.const 32))
    (loop $s
      (if (call $_u256_add (global.get $u256_mod_tmp) (i64.const 1) (local.get $x) (i64.const 0)) (then
        (memory.copy (local.get $o) (global.get $u256_mod_tmp) (i32.const 32))
        (br $s)
      ))
    )
    (memory.fill (global.get $u256_mod_tmp) (i32.const 0) (i32.const 32))
  )

  (export "coef_add" (func $coef_add))
  (func $coef_add (param $o i32) (param $x i32)
    (drop (call $_u256_add (local.get $o) (i64.const 1) (local.get $x) (i64.const 0)))
    (call $u256_mod_neg (local.get $o) (global.get $neg_coef))
  )

  (export "exp_add" (func $exp_add))
  (func $exp_add (param $o i32) (param $x i32)
    (drop (call $_u256_add (local.get $o) (i64.const 1) (local.get $x) (i64.const 0)))
    (call $u256_mod_neg (local.get $o) (global.get $neg_exp))
  )

  ;; *o = (*o as u256) + ((*x) * (*y))
  (export "_u256_mul_u512" (func $u256_mul_u512))
  (func $u256_mul_u512 (param $o i32) (param $x i32) (param $y i32)
    (i32.store offset=32 (local.get $o) (call $_u256_add
      (local.get $o)
      (i64.load32_u offset=0 (local.get $x))
      (local.get $y)
      (i64.const 0)
    ))
    (i32.store offset=36 (local.get $o) (call $_u256_add
      (i32.add (local.get $o) (i32.const 4))
      (i64.load32_u offset=4 (local.get $x))
      (local.get $y)
      (i64.const 0)
    ))
    (i32.store offset=40 (local.get $o) (call $_u256_add
      (i32.add (local.get $o) (i32.const 8))
      (i64.load32_u offset=8 (local.get $x))
      (local.get $y)
      (i64.const 0)
    ))
    (i32.store offset=44 (local.get $o) (call $_u256_add
      (i32.add (local.get $o) (i32.const 12))
      (i64.load32_u offset=12 (local.get $x))
      (local.get $y)
      (i64.const 0)
    ))
    (i32.store offset=48 (local.get $o) (call $_u256_add
      (i32.add (local.get $o) (i32.const 16))
      (i64.load32_u offset=16 (local.get $x))
      (local.get $y)
      (i64.const 0)
    ))
    (i32.store offset=52 (local.get $o) (call $_u256_add
      (i32.add (local.get $o) (i32.const 20))
      (i64.load32_u offset=20 (local.get $x))
      (local.get $y)
      (i64.const 0)
    ))
    (i32.store offset=56 (local.get $o) (call $_u256_add
      (i32.add (local.get $o) (i32.const 24))
      (i64.load32_u offset=24 (local.get $x))
      (local.get $y)
      (i64.const 0)
    ))
    (i32.store offset=60 (local.get $o) (call $_u256_add
      (i32.add (local.get $o) (i32.const 28))
      (i64.load32_u offset=28 (local.get $x))
      (local.get $y)
      (i64.const 0)
    ))
  )

  ;; o: &coef; x: &coef; y: &coef
  ;; *x *= *y
  (export "coef_mul" (func $coef_mul))
  (func $coef_mul (param $x i32) (param $y i32)
    (call $u256_mul_u512 (global.get $coef_mul_tmp) (local.get $x) (local.get $y))
    (call $u256_mod_neg (global.get $coef_mul_tmp) (global.get $neg_coef))
    (call $u256_mod_neg (global.get $coef_mul_tmp_shr_256) (global.get $neg_coef))
    (drop (call $_u256_add (global.get $coef_mul_tmp) (i64.const 0) (global.get $coef_mul_tmp_shr_256)
      (call $_u256_add (global.get $coef_mul_tmp) (i64.const 38) (global.get $coef_mul_tmp_shr_256) (i64.const 0))
      (call $u256_mod_neg (global.get $coef_mul_tmp) (global.get $neg_coef))
      (i64.mul (i64.extend_i32_u) (i64.const 38))
    ))
    (call $u256_mod_neg (global.get $coef_mul_tmp) (global.get $neg_coef))
    (memory.copy (local.get $x) (global.get $coef_mul_tmp) (i32.const 32))
    (memory.fill (global.get $coef_mul_tmp) (i32.const 0) (i32.const 64))
  )

  ;; *o = ~(*x)
  (func $u256_inv (param $o i32) (param $x i32)
    (i64.store offset=0 (local.get $o) (i64.xor (i64.load offset=0 (local.get $x)) (i64.const -1)))
    (i64.store offset=8 (local.get $o) (i64.xor (i64.load offset=8 (local.get $x)) (i64.const -1)))
    (i64.store offset=16 (local.get $o) (i64.xor (i64.load offset=16 (local.get $x)) (i64.const -1)))
    (i64.store offset=24 (local.get $o) (i64.xor (i64.load offset=24 (local.get $x)) (i64.const -1)))
  )

  ;; *o = *x - *y
  (export "u256_sub" (func $u256_sub))
  (func $u256_sub (param $o i32) (param $x i32) (param $y i32)
    (call $u256_inv (local.get $o) (local.get $y))
    (drop (call $_u256_add (local.get $o) (i64.const 1) (local.get $x) (i64.const 1)))
  )

  ;; o: &coef; x: &coef; y: &coef
  ;; *x *= (*y)
  (export "exp_mul" (func $exp_mul))
  (func $exp_mul (param $x i32) (param $y i32)
    (local $n i32)
    (call $u256_mul_u512 (global.get $exp_mul_tmp) (local.get $x) (local.get $y))
    (call $u256_mod_neg (global.get $exp_mul_tmp_shr_256) (global.get $neg_exp))
    (local.set $n (global.get $exp_mul_tmp_shr_256))
    (loop $n
      (local.tee $n (i32.sub (local.get $n) (i32.const 1)))
      (call $u256_mod_neg (global.get $neg_exp))
      (drop (call $_u256_add
        (local.get $n)
        (i64.extend_i32_u (call $_u256_add (local.get $n) (i64.load8_u offset=32 (local.get $n)) (global.get $u256_mod_exp) (i64.const 0)))
        (global.get $u256_mod_exp)
        (i64.const 0)
      ))
      (call $u256_mod_neg (local.get $n) (global.get $neg_exp))
      (br_if $n (i32.gt_u (local.get $n) (global.get $exp_mul_tmp)))
    )
    (memory.copy (local.get $x) (global.get $exp_mul_tmp) (i32.const 32))
    (memory.fill (global.get $exp_mul_tmp) (i32.const 0) (i32.const 64))
  )

  (table $fns 2 funcref)
  (elem (i32.const 0)
    $coef_mul
    $coef_sqr
  )

  ;; <T> x: &T, y: &T
  ;; *x *= *y
  (type $mul_fn (func (param i32) (param i32)))
  ;; <T> x: &T
  ;; *x *= *x
  (type $sqr_fn (func (param i32)))

  (func $coef_sqr (param $x i32)
    (call $coef_mul (local.get $x) (local.get $x))
  )

  ;; <T> o: &T; x: &T; e: u32; f: &mul_fn<T>
  ;; *o = *o^u32 * (*x)^e
  (func $pow_u32 (param $o i32) (param $x i32) (param $e i32) (param $mul i32) (param $sqr i32)
    (local $m i32)
    (local.set $m (i32.const 0x80000000))
    (loop $m
      (call_indirect $fns (type $sqr_fn) (local.get $o) (local.get $sqr))
      (if (i32.and (local.get $e) (local.get $m)) (then
        (call_indirect $fns (type $mul_fn) (local.get $o) (local.get $x) (local.get $mul))
      ))
      (br_if $m (local.tee $m (i32.shr_u (local.get $m) (i32.const 1))))
    )
  )

  ;; <T> o: &T; x: &T; e: &u256; f: &mul_fn<T>
  ;; *o = *o^(u256) * (*x)^(*e)
  (func $pow (param $o i32) (param $x i32) (param $e i32) (param $mul i32) (param $sqr i32)
    (local $m i32)
    (local.set $m (i32.add (local.get $e) (i32.const 28)))
    (loop $m
      (call $pow_u32 (local.get $o) (local.get $x) (i32.load (local.get $m)) (local.get $mul) (local.get $sqr))
      (local.tee $m (i32.sub (local.get $m) (i32.const 4)))
      (br_if $m (i32.ge_u (local.get $e)))
    )
  )

  ;; o: &coef; x: &coef
  ;; *o = 1 / (*x)
  (export "coef_inv" (func $coef_inv))
  (func $coef_inv (param $o i32) (param $x i32)
    (memory.copy (local.get $o) (global.get $one) (i32.const 32))
    (call $pow (local.get $o) (local.get $x) (global.get $coef_neg_two) (i32.const 0) (i32.const 1))
  )

  ;; *n == 0
  (func $u256_eqz (param $n i32) (result i32)
    (i64.eqz (i64.load offset=0 (local.get $n)))
    (i32.and (i64.eqz (i64.load offset=8 (local.get $n))))
    (i32.and (i64.eqz (i64.load offset=16 (local.get $n))))
    (i32.and (i64.eqz (i64.load offset=24 (local.get $n))))
  )

  (func $coef_invsqrt (param $x i32))

  (func $rist_decomp (param $o i32) (param $s i32) (result i32)
    (local $y i32)
    (local $t i32)

    (memory.copy (global.get $rist_decomp_tmp_s) (local.get $s) (i32.const 32))
    (if (call $_u256_add (global.get $rist_decomp_tmp_s) (i64.const 1) (global.get $neg_coef) (i64.const 0)) (then) (else
      (return (i32.const 1))
    ))
    (if (i32.and (i32.load8_u (local.get $s)) (i32.const 1)) (then
      (return (i32.const 1))
    ))
    (memory.copy (global.get $rist_decomp_tmp_u1) (local.get $s) (i32.const 32))
    (call $coef_sqr (global.get $rist_decomp_tmp_u1))
    (memory.copy (global.get $rist_decomp_tmp_u2) (global.get $rist_decomp_tmp_u1) (i32.const 32))
    (call $u256_sub (global.get $rist_decomp_tmp_u1) (global.get $coef) (global.get $rist_decomp_tmp_u1))
    (call $coef_add (global.get $rist_decomp_tmp_u1) (global.get $one))
    (call $coef_add (global.get $rist_decomp_tmp_u2) (global.get $one))

    (memory.copy (global.get $rist_decomp_tmp_u2_2) (global.get $rist_decomp_tmp_u2) (i32.const 32))
    (call $coef_sqr (global.get $rist_decomp_tmp_u2_2))

    (memory.copy (global.get $rist_decomp_tmp_v) (global.get $rist_d) (i32.const 32))
    (call $coef_mul (global.get $rist_decomp_tmp_v) (global.get $rist_decomp_tmp_u1))
    (call $coef_mul (global.get $rist_decomp_tmp_v) (global.get $rist_decomp_tmp_u1))
    (call $coef_add (global.get $rist_decomp_tmp_v) (global.get $rist_decomp_tmp_u2_2))
    (call $u256_sub (global.get $rist_decomp_tmp_u1) (global.get $coef) (global.get $rist_decomp_tmp_u1))

    (memory.copy (global.get $rist_decomp_tmp_i) (global.get $rist_decomp_tmp_v) (i32.const 32))
    (call $coef_mul (global.get $rist_decomp_tmp_i) (global.get $rist_decomp_tmp_u2_2))
    (call $coef_invsqrt (global.get $rist_decomp_tmp_i))

    (memory.copy (global.get $rist_decomp_tmp_dx) (global.get $rist_decomp_tmp_i) (i32.const 32))
    (call $coef_mul (global.get $rist_decomp_tmp_dx) (global.get $rist_decomp_tmp_u2))

    (memory.copy (global.get $rist_decomp_tmp_dy) (global.get $rist_decomp_tmp_i) (i32.const 32))
    (call $coef_mul (global.get $rist_decomp_tmp_dy) (global.get $rist_decomp_tmp_dx))
    (call $coef_mul (global.get $rist_decomp_tmp_dy) (global.get $rist_decomp_tmp_v))

    (memory.copy (local.get $o) (global.get $two) (i32.const 32))
    (call $coef_mul (local.get $o) (local.get $s))
    (call $coef_mul (local.get $o) (global.get $rist_decomp_tmp_dx))

    (if (i32.and (i32.load8_u (local.get $s)) (i32.const 1)) (then
      (call $u256_sub (local.get $o) (global.get $coef) (local.get $o))
    ))

    (local.tee $y (i32.add (local.get $o) (i32.const 32)))
    (memory.copy (global.get $rist_decomp_tmp_u1) (i32.const 32))
    (call $coef_mul (local.get $y) (global.get $rist_decomp_tmp_dy))

    (memory.copy (i32.add (local.get $o) (i32.const 64)) (global.get $one) (i32.const 32))

    (local.tee $t (i32.add (local.get $o) (i32.const 96)))
    (memory.copy (local.get $y) (i32.const 32))
    (call $coef_mul (local.get $t) (local.get $o))

    (if (i32.or (call $u256_eqz (local.get $y)) (i32.and (i32.load8_u (local.get $t)) (i32.const 1))) (then
      (return (i32.const 1))
    ))

    (i32.const 0)
  )
)
