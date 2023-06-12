(module
  (import "host" "memory" (memory 1))
  (import "keccak" "keccak_f1600" (func $keccak_f1600 (param i32)))
  (import "ristretto" "u512_mod_scalar" (func $u512_mod_scalar (param i32)))
  (import "ristretto" "curve_pow" (func $curve_pow (param i32) (param i32) (param i32)))
  (import "ristretto" "rist_encode" (func $rist_encode (param i32) (param i32)))
  (import "ristretto" "scalar_mul" (func $scalar_mul (param i32) (param i32)))
  (import "ristretto" "scalar_add" (func $scalar_add (param i32) (param i32)))

  ;; (import "log" "u32" (func $log_u32 (param i32)))
  ;; (import "log" "u64" (func $log_u64 (param i64)))
  ;; (import "log" "i32" (func $log_i32 (param i32)))
  ;; (import "log" "i64" (func $log_i64 (param i64)))
  ;; (import "log" "brk" (func $log_brk))
  ;; (func $dbg_u32 (param $v i32) (result i32) local.get $v call $log_u32 local.get $v)
  ;; (func $dbg_u64 (param $v i64) (result i64) local.get $v call $log_u64 local.get $v)
  ;; (func $dbg_i32 (param $v i32) (result i32) local.get $v call $log_i32 local.get $v)
  ;; (func $dbg_i64 (param $v i64) (result i64) local.get $v call $log_i64 local.get $v)

  (global $merlin_proto_label_adr i32 (i32.const 1632))
  (global $merlin_proto_label_len i32 (i32.const 11))
  (data (i32.const 1632) "Merlin v1.0")

  ;; 4 bytes
  (global $merlin_len_tmp i32 (i32.const 1643))

  ;; 7 bytes
  (global $str_dom_sep_adr i32 (i32.const 1647))
  (global $str_dom_sep_len i32 (i32.const 7))
  (data (i32.const 1647) "dom-sep")

  ;; 14 bytes
  (global $str_signing_context_adr i32 (i32.const 1654))
  (global $str_signing_context_len i32 (i32.const 14))
  (data (i32.const 1654) "SigningContext")

  ;; 10 bytes
  (global $str_sign_bytes_adr i32 (i32.const 1668))
  (global $str_sign_bytes_len i32 (i32.const 10))
  (data (i32.const 1668) "sign-bytes")

  ;; 10 bytes
  (global $str_proto_name_adr i32 (i32.const 1678))
  (global $str_proto_name_len i32 (i32.const 10))
  (data (i32.const 1678) "proto-name")

  ;; 11 bytes
  (global $str_schnorr_sig_adr i32 (i32.const 1688))
  (global $str_schnorr_sig_len i32 (i32.const 11))
  (data (i32.const 1688) "Schnorr-sig")

  ;; 3 bytes gap

  ;; 7 bytes
  (global $str_signing_adr i32 (i32.const 1702))
  (global $str_signing_len i32 (i32.const 7))
  (data (i32.const 1702) "signing")

  ;; 6 bytes
  (global $str_sign_r_adr i32 (i32.const 1709))
  (global $str_sign_r_len i32 (i32.const 6))
  (data (i32.const 1709) "sign:R")

  ;; 6 bytes
  (global $str_sign_c_adr i32 (i32.const 1715))
  (global $str_sign_c_len i32 (i32.const 6))
  (data (i32.const 1715) "sign:c")

  ;; 9 bytes gap

  ;; 3 bytes
  (global $str_rng_adr i32 (i32.const 1730))
  (global $str_rng_len i32 (i32.const 3))
  (data (i32.const 1730) "rng")

  ;; 512 bytes
  (global $sign_tmp_k i32 (i32.const 1733))

  ;; 256 bytes
  (global $sign_tmp_r i32 (i32.const 2245))

  ;; 256 bytes
  (global $sign_tmp_strobe0 i32 (i32.const 2501))

  ;; 256 bytes
  (global $sign_tmp_strobe1 i32 (i32.const 2757))

  ;; 128 bytes
  (export "rist_basepoint" (global $rist_basepoint))
  (global $rist_basepoint i32 (i32.const 3013))

  ;; 7 bytes
  (global $str_sign_pk_adr i32 (i32.const 3269))
  (global $str_sign_pk_len i32 (i32.const 7))
  (data (i32.const 3269) "sign:pk")

  ;; 512 bytes
  (global $sign_tmp_e i32 (i32.const 3276))

  (global (export "free_adr") i32 (i32.const 4000))

  (global $strobe_i i32 (i32.const 0x01))
  (global $strobe_a i32 (i32.const 0x02))
  (global $strobe_c i32 (i32.const 0x04))
  (global $strobe_t i32 (i32.const 0x08))
  (global $strobe_m i32 (i32.const 0x10))
  (global $strobe_k i32 (i32.const 0x20))

  (global $strobe_ck i32 (i32.const 0x24))
  (global $strobe_ma i32 (i32.const 0x12))
  (global $strobe_ac i32 (i32.const 0x06))
  (global $strobe_iac i32 (i32.const 0x07))

  (func $merlin_append_message (param $strobe i32)
    (param $label_adr i32)
    (param $label_len i32)
    (param $message_adr i32)
    (param $message_len i32)

    (call $strobe_begin_op (local.get $strobe) (global.get $strobe_ma))
    (if (local.get $label_len) (then
      (call $strobe_absorb (local.get $strobe) (local.get $label_adr) (local.get $label_len))
    ))
    (i32.store (global.get $merlin_len_tmp) (local.get $message_len))
    (call $strobe_absorb (local.get $strobe) (global.get $merlin_len_tmp) (i32.const 4))
    (call $strobe_begin_op (local.get $strobe) (global.get $strobe_a))
    (call $strobe_absorb (local.get $strobe) (local.get $message_adr) (local.get $message_len))
  )

  (func $merlin_rekey (param $strobe i32)
    (param $label_adr i32)
    (param $label_len i32)
    (param $witness_adr i32)
    (param $witness_len i32)

    (call $strobe_begin_op (local.get $strobe) (global.get $strobe_ma))
    (call $strobe_absorb (local.get $strobe) (local.get $label_adr) (local.get $label_len))
    (i32.store (global.get $merlin_len_tmp) (local.get $witness_len))
    (call $strobe_absorb (local.get $strobe) (global.get $merlin_len_tmp) (i32.const 4))
    (call $strobe_begin_op (local.get $strobe) (global.get $strobe_ac))
    (call $strobe_overwrite (local.get $strobe) (local.get $witness_adr) (local.get $witness_len))
  )

  (func $merlin_challenge_bytes (param $strobe i32)
    (param $label_adr i32)
    (param $label_len i32)
    (param $dest_adr i32)
    (param $dest_len i32)

    (call $strobe_begin_op (local.get $strobe) (global.get $strobe_ma))
    (if (local.get $label_len) (then
      (call $strobe_absorb (local.get $strobe) (local.get $label_adr) (local.get $label_len))
    ))
    (i32.store (global.get $merlin_len_tmp) (local.get $dest_len))
    (call $strobe_absorb (local.get $strobe) (global.get $merlin_len_tmp) (i32.const 4))
    (call $strobe_begin_op (local.get $strobe) (global.get $strobe_iac))
    (call $strobe_squeeze (local.get $strobe) (local.get $dest_adr) (local.get $dest_len))
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
    (if (i32.or
      (i32.eq (global.get $strobe_r))
      (i32.and (local.get $flags) (global.get $strobe_ck))
    ) (then
      (call $strobe_run_f (local.get $strobe) (local.get $pos))
      (local.set $pos (i32.const 0))
    ))
    (i32.store8 offset=200 (local.get $strobe) (local.get $pos))
  )

  ;; <-- form.wat bug?

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

  (func $strobe_squeeze (param $strobe i32) (param $write_adr i32) (param $write_len i32)
    (local $write_end i32)
    (local $pos i32)

    (local.set $write_end (i32.add (local.get $write_adr) (local.get $write_len)))
    (local.set $pos (i32.load8_u offset=200 (local.get $strobe)))

    (loop $read
      (i32.store8 (local.get $write_adr) (i32.load8_u (i32.add (local.get $pos) (local.get $strobe))))
      (i32.store8 (i32.add (local.get $pos) (local.get $strobe)) (i32.const 0))
      (local.tee $pos (i32.add (local.get $pos) (i32.const 1)))
      (if (i32.eq (global.get $strobe_r)) (then
        (call $strobe_run_f (local.get $strobe) (local.get $pos))
        (local.set $pos (i32.const 0))
      ))
      (local.tee $write_adr (i32.add (local.get $write_adr) (i32.const 1)))
      (br_if $read (i32.lt_u (local.get $write_end)))
    )
    (i32.store8 offset=200 (local.get $strobe) (local.get $pos))
  )

  (func $strobe_run_f (param $strobe i32) (param $pos i32)
    (local $adr i32)
    (local.tee $adr (i32.add (local.get $strobe) (local.get $pos)))
    (i32.store16 (i32.xor (i32.load16_u (local.get $adr)) (i32.or (i32.load16_u offset=201 (local.get $strobe)) (i32.const 0x0400))))
    (i32.store8 offset=167 (local.get $strobe) (i32.xor (i32.load8_u offset=167 (local.get $strobe)) (i32.const 0x80)))
    (call $keccak_f1600 (local.get $strobe))
    (i32.store16 offset=200 (local.get $strobe) (i32.const 0))
  )

  (data $strobe_init_data "\01\a8\01\00\01\60STROBEv1.0.2")
  (func $signing_init (param $strobe i32)
    (param $ctx_adr i32) (param $ctx_len i32)
    (param $msg_adr i32) (param $msg_len i32)
    (param $pub_adr i32)

    (memory.init $strobe_init_data (local.get $strobe) (i32.const 0) (i32.const 18))
    (call $keccak_f1600 (local.get $strobe))

    (call $strobe_begin_op (local.get $strobe) (global.get $strobe_ma))
    (call $strobe_absorb (local.get $strobe) (global.get $merlin_proto_label_adr) (global.get $merlin_proto_label_len))

    (call $merlin_append_message (local.get $strobe)
      (global.get $str_dom_sep_adr) (global.get $str_dom_sep_len)
      (global.get $str_signing_context_adr) (global.get $str_signing_context_len)
    )

    (call $merlin_append_message (local.get $strobe)
      (i32.const 0) (i32.const 0)
      (local.get $ctx_adr) (local.get $ctx_len)
    )

    (call $merlin_append_message (local.get $strobe)
      (global.get $str_sign_bytes_adr) (global.get $str_sign_bytes_len)
      (local.get $msg_adr) (local.get $msg_len)
    )

    (call $merlin_append_message (local.get $strobe)
      (global.get $str_proto_name_adr) (global.get $str_proto_name_len)
      (global.get $str_schnorr_sig_adr) (global.get $str_schnorr_sig_len)
    )

    (call $merlin_append_message (local.get $strobe)
      (global.get $str_sign_pk_adr) (global.get $str_sign_pk_len)
      (local.get $pub_adr) (i32.const 32)
    )
  )

  (func $u256_shr_3 (param $n i32) (local $x i64)
    (i64.store offset=24
      (local.get $n)
      (i64.shr_u (local.tee $x (i64.load offset=24 (local.get $n))) (i64.const 3))
    )
    (i64.store offset=16
      (local.get $n)
      (i64.or
        (i64.shl (local.get $x) (i64.const 61))
        (i64.shr_u (local.tee $x (i64.load offset=16 (local.get $n))) (i64.const 3))
      )
    )
    (i64.store offset=8
      (local.get $n)
      (i64.or
        (i64.shl (local.get $x) (i64.const 61))
        (i64.shr_u (local.tee $x (i64.load offset=8 (local.get $n))) (i64.const 3))
      )
    )
    (i64.store offset=0
      (local.get $n)
      (i64.or
        (i64.shl (local.get $x) (i64.const 61))
        (i64.shr_u (local.tee $x (i64.load offset=0 (local.get $n))) (i64.const 3))
      )
    )
  )

  (func (export "sign")
    (param $ctx_adr i32) (param $ctx_len i32)
    (param $msg_adr i32) (param $msg_len i32)
    (param $pub_adr i32)
    (param $key_adr i32)
    (param $rng_adr i32)
    (param $r i32)
    (local $s i32)

    (call $u256_shr_3 (local.get $key_adr))

    (local.set $s (i32.add (local.get $r) (i32.const 32)))

    (call $signing_init
      (global.get $sign_tmp_strobe0)
      (local.get $ctx_adr) (local.get $ctx_len)
      (local.get $msg_adr) (local.get $msg_len)
      (local.get $pub_adr)
    )

    (memory.copy (global.get $sign_tmp_strobe1) (global.get $sign_tmp_strobe0) (i32.const 256))
    (call $merlin_rekey (global.get $sign_tmp_strobe1)
      (global.get $str_signing_adr) (global.get $str_signing_len)
      (i32.add (local.get $key_adr) (i32.const 32)) (i32.const 32)
    )

    (call $strobe_begin_op (global.get $sign_tmp_strobe1) (global.get $strobe_ma))
    (call $strobe_absorb (global.get $sign_tmp_strobe1) (global.get $str_rng_adr) (global.get $str_rng_len))
    (call $strobe_begin_op (global.get $sign_tmp_strobe1) (global.get $strobe_ac))
    (call $strobe_overwrite (global.get $sign_tmp_strobe1) (local.get $rng_adr) (i32.const 32))

    (call $merlin_challenge_bytes (global.get $sign_tmp_strobe1)
      (i32.const 0) (i32.const 0)
      (global.get $sign_tmp_k) (i32.const 64)
    )
    (call $u512_mod_scalar (global.get $sign_tmp_k))

    (call $curve_pow (global.get $sign_tmp_r) (global.get $rist_basepoint) (global.get $sign_tmp_k))
    (call $rist_encode (local.get $r) (global.get $sign_tmp_r))

    (call $merlin_append_message (global.get $sign_tmp_strobe0)
      (global.get $str_sign_r_adr) (global.get $str_sign_r_len)
      (local.get $r) (i32.const 32)
    )

    (call $merlin_challenge_bytes (global.get $sign_tmp_strobe0)
      (global.get $str_sign_c_adr) (global.get $str_sign_c_len)
      (global.get $sign_tmp_e) (i32.const 64)
    )
    (call $u512_mod_scalar (global.get $sign_tmp_e))
    (memory.copy (local.get $s) (global.get $sign_tmp_e) (i32.const 32))
    (call $scalar_mul (local.get $s) (local.get $key_adr))
    (call $scalar_add (local.get $s) (global.get $sign_tmp_k))

    (i32.store8 offset=63 (local.get $r) (i32.or (i32.load8_u offset=63 (local.get $r)) (i32.const 128)))
    (memory.fill (global.get $sign_tmp_k) (i32.const 0) (i32.const 1280))
  )

  (func (export "get_pub") (param $key_adr i32) (param $pub_adr i32)
    (call $u256_shr_3 (local.get $key_adr))
    (call $curve_pow (global.get $sign_tmp_r) (global.get $rist_basepoint) (local.get $key_adr))
    (call $rist_encode (local.get $pub_adr) (global.get $sign_tmp_r))
  )
)
