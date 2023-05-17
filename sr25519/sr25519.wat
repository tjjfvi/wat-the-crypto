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
  ;; exp - (u256 % exp)
  (export "neg_u256_mod_exp" (global $neg_u256_mod_exp))
  (global $neg_u256_mod_exp i32 (i32.const 256))

  ;; 32 bytes
  (global $u256_mod_tmp i32 (i32.const 288))

  ;; 64 bytes
  (global $coef_mul_tmp i32 (i32.const 320))
  (global $coef_mul_tmp_shr_256 i32 (i32.const 352))

  ;; 64 bytes
  (global $exp_mul_tmp i32 (i32.const 384))
  (global $exp_mul_tmp_shr_256 i32 (i32.const 416))

  ;; 32 bytes
  (global $_exp_mul_compact_tmp i32 (i32.const 448))

  ;; 32 bytes
  ;; u256 - coef
  (export "neg_coef" (global $neg_coef))
  (global $neg_coef i32 (i32.const 480))

  ;; 32 bytes
  ;; -exp
  (export "neg_exp" (global $neg_exp))
  (global $neg_exp i32 (i32.const 512))

  (global (export "free_adr") i32 (i32.const 544))

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
      (local.set $x0
        (i64.load offset=0 (local.get $adr))
        (i64.xor (i64.load offset=40 (local.get $adr)))
        (i64.xor (i64.load offset=80 (local.get $adr)))
        (i64.xor (i64.load offset=120 (local.get $adr)))
        (i64.xor (i64.load offset=160 (local.get $adr)))
      )

      (local.set $x1
        (i64.load offset=8 (local.get $adr))
        (i64.xor (i64.load offset=48 (local.get $adr)))
        (i64.xor (i64.load offset=88 (local.get $adr)))
        (i64.xor (i64.load offset=128 (local.get $adr)))
        (i64.xor (i64.load offset=168 (local.get $adr)))
      )

      (local.set $x2
        (i64.load offset=16 (local.get $adr))
        (i64.xor (i64.load offset=56 (local.get $adr)))
        (i64.xor (i64.load offset=96 (local.get $adr)))
        (i64.xor (i64.load offset=136 (local.get $adr)))
        (i64.xor (i64.load offset=176 (local.get $adr)))
      )

      (local.set $x3
        (i64.load offset=24 (local.get $adr))
        (i64.xor (i64.load offset=64 (local.get $adr)))
        (i64.xor (i64.load offset=104 (local.get $adr)))
        (i64.xor (i64.load offset=144 (local.get $adr)))
        (i64.xor (i64.load offset=184 (local.get $adr)))
      )

      (local.set $x4
        (i64.load offset=32 (local.get $adr))
        (i64.xor (i64.load offset=72 (local.get $adr)))
        (i64.xor (i64.load offset=112 (local.get $adr)))
        (i64.xor (i64.load offset=152 (local.get $adr)))
        (i64.xor (i64.load offset=192 (local.get $adr)))
      )

      (local.set $n (local.get $x4) (i64.xor (i64.rotl (local.get $x1) (i64.const 1))))
      (i64.store offset=0 (local.get $adr) (i64.load offset=0 (local.get $adr)) (i64.xor (local.get $n)))
      (i64.store offset=40 (local.get $adr) (i64.load offset=40 (local.get $adr)) (i64.xor (local.get $n)))
      (i64.store offset=80 (local.get $adr) (i64.load offset=80 (local.get $adr)) (i64.xor (local.get $n)))
      (i64.store offset=120 (local.get $adr) (i64.load offset=120 (local.get $adr)) (i64.xor (local.get $n)))
      (i64.store offset=160 (local.get $adr) (i64.load offset=160 (local.get $adr)) (i64.xor (local.get $n)))

      (local.set $n (local.get $x0) (i64.xor (i64.rotl (local.get $x2) (i64.const 1))))
      (i64.store offset=8 (local.get $adr) (i64.load offset=8 (local.get $adr)) (i64.xor (local.get $n)))
      (i64.store offset=48 (local.get $adr) (i64.load offset=48 (local.get $adr)) (i64.xor (local.get $n)))
      (i64.store offset=88 (local.get $adr) (i64.load offset=88 (local.get $adr)) (i64.xor (local.get $n)))
      (i64.store offset=128 (local.get $adr) (i64.load offset=128 (local.get $adr)) (i64.xor (local.get $n)))
      (i64.store offset=168 (local.get $adr) (i64.load offset=168 (local.get $adr)) (i64.xor (local.get $n)))

      (local.set $n (local.get $x1) (i64.xor (i64.rotl (local.get $x3) (i64.const 1))))
      (i64.store offset=16 (local.get $adr) (i64.load offset=16 (local.get $adr)) (i64.xor (local.get $n)))
      (i64.store offset=56 (local.get $adr) (i64.load offset=56 (local.get $adr)) (i64.xor (local.get $n)))
      (i64.store offset=96 (local.get $adr) (i64.load offset=96 (local.get $adr)) (i64.xor (local.get $n)))
      (i64.store offset=136 (local.get $adr) (i64.load offset=136 (local.get $adr)) (i64.xor (local.get $n)))
      (i64.store offset=176 (local.get $adr) (i64.load offset=176 (local.get $adr)) (i64.xor (local.get $n)))

      (local.set $n (local.get $x2) (i64.xor (i64.rotl (local.get $x4) (i64.const 1))))
      (i64.store offset=24 (local.get $adr) (i64.load offset=24 (local.get $adr)) (i64.xor (local.get $n)))
      (i64.store offset=64 (local.get $adr) (i64.load offset=64 (local.get $adr)) (i64.xor (local.get $n)))
      (i64.store offset=104 (local.get $adr) (i64.load offset=104 (local.get $adr)) (i64.xor (local.get $n)))
      (i64.store offset=144 (local.get $adr) (i64.load offset=144 (local.get $adr)) (i64.xor (local.get $n)))
      (i64.store offset=184 (local.get $adr) (i64.load offset=184 (local.get $adr)) (i64.xor (local.get $n)))

      (local.set $n (local.get $x3) (i64.xor (i64.rotl (local.get $x0) (i64.const 1))))
      (i64.store offset=32 (local.get $adr) (i64.load offset=32 (local.get $adr)) (i64.xor (local.get $n)))
      (i64.store offset=72 (local.get $adr) (i64.load offset=72 (local.get $adr)) (i64.xor (local.get $n)))
      (i64.store offset=112 (local.get $adr) (i64.load offset=112 (local.get $adr)) (i64.xor (local.get $n)))
      (i64.store offset=152 (local.get $adr) (i64.load offset=152 (local.get $adr)) (i64.xor (local.get $n)))
      (i64.store offset=192 (local.get $adr) (i64.load offset=192 (local.get $adr)) (i64.xor (local.get $n)))

      (local.set $x0 (i64.load offset=8 (local.get $adr)))

      (local.set $n (i64.load offset=80 (local.get $adr)))
      (i64.store offset=80 (local.get $adr) (i64.rotl (local.get $x0) (i64.const 1)))
      (local.set $x0 (i64.load offset=56 (local.get $adr)))
      (i64.store offset=56 (local.get $adr) (i64.rotl (local.get $n) (i64.const 3)))

      (local.set $n (i64.load offset=88 (local.get $adr)))
      (i64.store offset=88 (local.get $adr) (i64.rotl (local.get $x0) (i64.const 6)))
      (local.set $x0 (i64.load offset=136 (local.get $adr)))
      (i64.store offset=136 (local.get $adr) (i64.rotl (local.get $n) (i64.const 10)))

      (local.set $n (i64.load offset=144 (local.get $adr)))
      (i64.store offset=144 (local.get $adr) (i64.rotl (local.get $x0) (i64.const 15)))
      (local.set $x0 (i64.load offset=24 (local.get $adr)))
      (i64.store offset=24 (local.get $adr) (i64.rotl (local.get $n) (i64.const 21)))

      (local.set $n (i64.load offset=40 (local.get $adr)))
      (i64.store offset=40 (local.get $adr) (i64.rotl (local.get $x0) (i64.const 28)))
      (local.set $x0 (i64.load offset=128 (local.get $adr)))
      (i64.store offset=128 (local.get $adr) (i64.rotl (local.get $n) (i64.const 36)))

      (local.set $n (i64.load offset=64 (local.get $adr)))
      (i64.store offset=64 (local.get $adr) (i64.rotl (local.get $x0) (i64.const 45)))
      (local.set $x0 (i64.load offset=168 (local.get $adr)))
      (i64.store offset=168 (local.get $adr) (i64.rotl (local.get $n) (i64.const 55)))

      (local.set $n (i64.load offset=192 (local.get $adr)))
      (i64.store offset=192 (local.get $adr) (i64.rotl (local.get $x0) (i64.const 2)))
      (local.set $x0 (i64.load offset=32 (local.get $adr)))
      (i64.store offset=32 (local.get $adr) (i64.rotl (local.get $n) (i64.const 14)))

      (local.set $n (i64.load offset=120 (local.get $adr)))
      (i64.store offset=120 (local.get $adr) (i64.rotl (local.get $x0) (i64.const 27)))
      (local.set $x0 (i64.load offset=184 (local.get $adr)))
      (i64.store offset=184 (local.get $adr) (i64.rotl (local.get $n) (i64.const 41)))

      (local.set $n (i64.load offset=152 (local.get $adr)))
      (i64.store offset=152 (local.get $adr) (i64.rotl (local.get $x0) (i64.const 56)))
      (local.set $x0 (i64.load offset=104 (local.get $adr)))
      (i64.store offset=104 (local.get $adr) (i64.rotl (local.get $n) (i64.const 8)))

      (local.set $n (i64.load offset=96 (local.get $adr)))
      (i64.store offset=96 (local.get $adr) (i64.rotl (local.get $x0) (i64.const 25)))
      (local.set $x0 (i64.load offset=16 (local.get $adr)))
      (i64.store offset=16 (local.get $adr) (i64.rotl (local.get $n) (i64.const 43)))

      (local.set $n (i64.load offset=160 (local.get $adr)))
      (i64.store offset=160 (local.get $adr) (i64.rotl (local.get $x0) (i64.const 62)))
      (local.set $x0 (i64.load offset=112 (local.get $adr)))
      (i64.store offset=112 (local.get $adr) (i64.rotl (local.get $n) (i64.const 18)))

      (local.set $n (i64.load offset=176 (local.get $adr)))
      (i64.store offset=176 (local.get $adr) (i64.rotl (local.get $x0) (i64.const 39)))
      (local.set $x0 (i64.load offset=72 (local.get $adr)))
      (i64.store offset=72 (local.get $adr) (i64.rotl (local.get $n) (i64.const 61)))

      (local.set $n (i64.load offset=48 (local.get $adr)))
      (i64.store offset=48 (local.get $adr) (i64.rotl (local.get $x0) (i64.const 20)))
      (local.set $x0 (i64.load offset=8 (local.get $adr)))
      (i64.store offset=8 (local.get $adr) (i64.rotl (local.get $n) (i64.const 44)))

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

      (local.set $x0 (i64.load offset=40 (local.get $adr)))
      (local.set $x1 (i64.load offset=48 (local.get $adr)))
      (local.set $x2 (i64.load offset=56 (local.get $adr)))
      (local.set $x3 (i64.load offset=64 (local.get $adr)))
      (local.set $x4 (i64.load offset=72 (local.get $adr)))
      (i64.store offset=40 (local.get $adr) (local.get $x0) (i64.xor (i64.and (local.get $x2) (i64.xor (local.get $x1) (i64.const -1)))))
      (i64.store offset=48 (local.get $adr) (local.get $x1) (i64.xor (i64.and (local.get $x3) (i64.xor (local.get $x2) (i64.const -1)))))
      (i64.store offset=56 (local.get $adr) (local.get $x2) (i64.xor (i64.and (local.get $x4) (i64.xor (local.get $x3) (i64.const -1)))))
      (i64.store offset=64 (local.get $adr) (local.get $x3) (i64.xor (i64.and (local.get $x0) (i64.xor (local.get $x4) (i64.const -1)))))
      (i64.store offset=72 (local.get $adr) (local.get $x4) (i64.xor (i64.and (local.get $x1) (i64.xor (local.get $x0) (i64.const -1)))))

      (local.set $x0 (i64.load offset=80 (local.get $adr)))
      (local.set $x1 (i64.load offset=88 (local.get $adr)))
      (local.set $x2 (i64.load offset=96 (local.get $adr)))
      (local.set $x3 (i64.load offset=104 (local.get $adr)))
      (local.set $x4 (i64.load offset=112 (local.get $adr)))
      (i64.store offset=80 (local.get $adr) (local.get $x0) (i64.xor (i64.and (local.get $x2) (i64.xor (local.get $x1) (i64.const -1)))))
      (i64.store offset=88 (local.get $adr) (local.get $x1) (i64.xor (i64.and (local.get $x3) (i64.xor (local.get $x2) (i64.const -1)))))
      (i64.store offset=96 (local.get $adr) (local.get $x2) (i64.xor (i64.and (local.get $x4) (i64.xor (local.get $x3) (i64.const -1)))))
      (i64.store offset=104 (local.get $adr) (local.get $x3) (i64.xor (i64.and (local.get $x0) (i64.xor (local.get $x4) (i64.const -1)))))
      (i64.store offset=112 (local.get $adr) (local.get $x4) (i64.xor (i64.and (local.get $x1) (i64.xor (local.get $x0) (i64.const -1)))))

      (local.set $x0 (i64.load offset=120 (local.get $adr)))
      (local.set $x1 (i64.load offset=128 (local.get $adr)))
      (local.set $x2 (i64.load offset=136 (local.get $adr)))
      (local.set $x3 (i64.load offset=144 (local.get $adr)))
      (local.set $x4 (i64.load offset=152 (local.get $adr)))
      (i64.store offset=120 (local.get $adr) (local.get $x0) (i64.xor (i64.and (local.get $x2) (i64.xor (local.get $x1) (i64.const -1)))))
      (i64.store offset=128 (local.get $adr) (local.get $x1) (i64.xor (i64.and (local.get $x3) (i64.xor (local.get $x2) (i64.const -1)))))
      (i64.store offset=136 (local.get $adr) (local.get $x2) (i64.xor (i64.and (local.get $x4) (i64.xor (local.get $x3) (i64.const -1)))))
      (i64.store offset=144 (local.get $adr) (local.get $x3) (i64.xor (i64.and (local.get $x0) (i64.xor (local.get $x4) (i64.const -1)))))
      (i64.store offset=152 (local.get $adr) (local.get $x4) (i64.xor (i64.and (local.get $x1) (i64.xor (local.get $x0) (i64.const -1)))))

      (local.set $x0 (i64.load offset=160 (local.get $adr)))
      (local.set $x1 (i64.load offset=168 (local.get $adr)))
      (local.set $x2 (i64.load offset=176 (local.get $adr)))
      (local.set $x3 (i64.load offset=184 (local.get $adr)))
      (local.set $x4 (i64.load offset=192 (local.get $adr)))
      (i64.store offset=160 (local.get $adr) (local.get $x0) (i64.xor (i64.and (local.get $x2) (i64.xor (local.get $x1) (i64.const -1)))))
      (i64.store offset=168 (local.get $adr) (local.get $x1) (i64.xor (i64.and (local.get $x3) (i64.xor (local.get $x2) (i64.const -1)))))
      (i64.store offset=176 (local.get $adr) (local.get $x2) (i64.xor (i64.and (local.get $x4) (i64.xor (local.get $x3) (i64.const -1)))))
      (i64.store offset=184 (local.get $adr) (local.get $x3) (i64.xor (i64.and (local.get $x0) (i64.xor (local.get $x4) (i64.const -1)))))
      (i64.store offset=192 (local.get $adr) (local.get $x4) (i64.xor (i64.and (local.get $x1) (i64.xor (local.get $x0) (i64.const -1)))))

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

  ;; *o += (s as u32) * (*x) + n
  ;; returns overflow
  (export "_u256_add" (func $_u256_add))
  (func $_u256_add (param $o i32) (param $s i64) (param $x i32) (param $n i64) (result i32)
    (local $t i64)

    (local.set $t (local.get $s) (i64.shr_s (i64.const 32)) (i64.and (i64.const 0xffff0000)))

    (i64.store32 offset=0 (local.get $o) (local.tee $n
      (local.get $n)
      (i64.add (i64.load32_u offset=0 (local.get $o)))
      (i64.add (i64.mul (local.get $s) (i64.load32_u offset=0 (local.get $x))))
    ))

    (i64.store32 offset=4 (local.get $o) (local.tee $n
      (i64.or (local.get $t) (i64.shr_u (local.get $n) (i64.const 32)))
      (i64.add (i64.load32_u offset=4 (local.get $o)))
      (i64.add (i64.mul (local.get $s) (i64.load32_u offset=4 (local.get $x))))
    ))

    (i64.store32 offset=8 (local.get $o) (local.tee $n
      (i64.or (local.get $t) (i64.shr_u (local.get $n) (i64.const 32)))
      (i64.add (i64.load32_u offset=8 (local.get $o)))
      (i64.add (i64.mul (local.get $s) (i64.load32_u offset=8 (local.get $x))))
    ))

    (i64.store32 offset=12 (local.get $o) (local.tee $n
      (i64.or (local.get $t) (i64.shr_u (local.get $n) (i64.const 32)))
      (i64.add (i64.load32_u offset=12 (local.get $o)))
      (i64.add (i64.mul (local.get $s) (i64.load32_u offset=12 (local.get $x))))
    ))

    (i64.store32 offset=16 (local.get $o) (local.tee $n
      (i64.or (local.get $t) (i64.shr_u (local.get $n) (i64.const 32)))
      (i64.add (i64.load32_u offset=16 (local.get $o)))
      (i64.add (i64.mul (local.get $s) (i64.load32_u offset=16 (local.get $x))))
    ))

    (i64.store32 offset=20 (local.get $o) (local.tee $n
      (i64.or (local.get $t) (i64.shr_u (local.get $n) (i64.const 32)))
      (i64.add (i64.load32_u offset=20 (local.get $o)))
      (i64.add (i64.mul (local.get $s) (i64.load32_u offset=20 (local.get $x))))
    ))

    (i64.store32 offset=24 (local.get $o) (local.tee $n
      (i64.or (local.get $t) (i64.shr_u (local.get $n) (i64.const 32)))
      (i64.add (i64.load32_u offset=24 (local.get $o)))
      (i64.add (i64.mul (local.get $s) (i64.load32_u offset=24 (local.get $x))))
    ))

    (i64.store32 offset=28 (local.get $o) (local.tee $n
      (i64.or (local.get $t) (i64.shr_u (local.get $n) (i64.const 32)))
      (i64.add (i64.load32_u offset=28 (local.get $o)))
      (i64.add (i64.mul (local.get $s) (i64.load32_u offset=28 (local.get $x))))
    ))

    (i32.wrap_i64 (i64.shr_u (local.get $n) (i64.const 32)))
  )

  ;; *o %= -(*x)
  (func $u256_mod_neg (param $o i32) (param $x i32)
    (memory.copy (global.get $u256_mod_tmp) (local.get $o) (i32.const 32))
    (if (call $_u256_add (global.get $u256_mod_tmp) (i64.const 1) (local.get $x) (i64.const 0)) (then
      (memory.copy (local.get $o) (global.get $u256_mod_tmp) (i32.const 32))
    ))
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
  ;; *o = (*x) * (*y)
  (export "coef_mul" (func $coef_mul))
  (func $coef_mul (param $o i32) (param $x i32) (param $y i32)
    (call $u256_mul_u512 (global.get $coef_mul_tmp) (local.get $x) (local.get $y))
    (call $u256_mod_neg (global.get $coef_mul_tmp) (global.get $neg_coef))
    (call $u256_mod_neg (global.get $coef_mul_tmp_shr_256) (global.get $neg_coef))
    (drop (call $_u256_add (global.get $coef_mul_tmp) (i64.const 0) (global.get $coef_mul_tmp_shr_256)
      (call $_u256_add (global.get $coef_mul_tmp) (i64.const 38) (global.get $coef_mul_tmp_shr_256) (i64.const 0))
      (call $u256_mod_neg (global.get $coef_mul_tmp) (global.get $neg_coef))
      (i64.mul (i64.extend_i32_u) (i64.const 38))
    ))
    (call $u256_mod_neg (global.get $coef_mul_tmp) (global.get $neg_coef))
    (memory.copy (local.get $o) (global.get $coef_mul_tmp) (i32.const 32))
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

  ;; (func $_exp_mul_compact
  ;;   (memory.copy (global.get $_exp_mul_compact_tmp) (global.get $exp_mul_tmp_shr_256) (i32.const 32))
  ;;   (call $u256_mul_u512 (global.get $exp_mul_tmp) (global.get $_exp_mul_compact_tmp) (global.get $u256_order_mod_exp_order))
  ;; )

  ;; ;; o: &coef; x: &coef; y: &coef
  ;; ;; *o = (*x) * (*y)
  ;; (func $exp_mul (param $o i32) (param $x i32) (param $y i32)
  ;;   (call $u256_mul_u512 (global.get $exp_mul_tmp) (local.get $x) (local.get $y))
  ;;   (call $u256_mod (global.get $exp_mul_tmp) (global.get $exp_order))
  ;;   (call $u256_mod (global.get $exp_mul_tmp_shr_256) (global.get $exp_order))
  ;;   (call $_u256_add (global.get $coef_mul_tmp) (i64.const 38) (global.get $coef_mul_tmp_shr_256))
  ;;   (memory.copy (local.get $o) (global.get $coef_mul_tmp) (i32.const 32))
  ;;   (memory.fill (global.get $coef_mul_tmp) (i32.const 0) (i32.const 64))
  ;; )
)
