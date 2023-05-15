(module
  (import "sr25519" "memory" (memory 1))

  (import "log" "u32" (func $log_u32 (param i32)))
  (import "log" "u64" (func $log_u64 (param i64)))
  (import "log" "brk" (func $log_brk))
  (func $dbg_u32 (param $v i32) (result i32) local.get $v call $log_u32 local.get $v)
  (func $dbg_u64 (param $v i64) (result i64) local.get $v call $log_u64 local.get $v)

  (func (export "main")
    (call $keccak_f1600 (i32.const 0))
  )

  (global $keccak_rc_adr i32 (i32.const 1024))
  (global $keccak_rc_end i32 (i32.const 1216))
  (data (i32.const 1024)
    "\01\00\00\00\00\00\00\00"
    "\82\80\00\00\00\00\00\00"
    "\8a\80\00\00\00\00\00\80"
    "\00\80\00\80\00\00\00\80"
    "\8b\80\00\00\00\00\00\00"
    "\01\00\00\80\00\00\00\00"
    "\81\80\00\80\00\00\00\80"
    "\09\80\00\00\00\00\00\80"
    "\8a\00\00\00\00\00\00\00"
    "\88\00\00\00\00\00\00\00"
    "\09\80\00\80\00\00\00\00"
    "\0a\00\00\80\00\00\00\00"
    "\8b\80\00\80\00\00\00\00"
    "\8b\00\00\00\00\00\00\80"
    "\89\80\00\00\00\00\00\80"
    "\03\80\00\00\00\00\00\80"
    "\02\80\00\00\00\00\00\80"
    "\80\00\00\00\00\00\00\80"
    "\0a\80\00\00\00\00\00\00"
    "\0a\00\00\80\00\00\00\80"
    "\81\80\00\80\00\00\00\80"
    "\80\80\00\00\00\00\00\80"
    "\01\00\00\80\00\00\00\00"
    "\08\80\00\80\00\00\00\80"
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
)
