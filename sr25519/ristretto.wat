(module
  (import "host" "memory" (memory 1))

  ;; (import "log" "u32" (func $log_u32 (param i32)))
  ;; (import "log" "u64" (func $log_u64 (param i64)))
  ;; (import "log" "i32" (func $log_i32 (param i32)))
  ;; (import "log" "i64" (func $log_i64 (param i64)))
  ;; (import "log" "brk" (func $log_brk))
  ;; (func $dbg_u32 (param $v i32) (result i32) local.get $v call $log_u32 local.get $v)
  ;; (func $dbg_u64 (param $v i64) (result i64) local.get $v call $log_u64 local.get $v)
  ;; (func $dbg_i32 (param $v i32) (result i32) local.get $v call $log_i32 local.get $v)
  ;; (func $dbg_i64 (param $v i64) (result i64) local.get $v call $log_i64 local.get $v)

  ;; 32 bytes
  (export "field" (global $field))
  (global $field i32 (i32.const 192))

  ;; 32 bytes
  (export "scalar" (global $scalar))
  (global $scalar i32 (i32.const 224))

  ;; 32 bytes
  ;; u256 - field
  (export "neg_field" (global $neg_field))
  (global $neg_field i32 (i32.const 256))

  ;; 32 bytes
  ;; -scalar
  (export "neg_scalar" (global $neg_scalar))
  (global $neg_scalar i32 (i32.const 288))

  ;; 32 bytes
  ;; u256 % scalar
  (export "u256_mod_scalar" (global $u256_mod_scalar))
  (global $u256_mod_scalar i32 (i32.const 320))

  ;; 32 bytes
  ;; field - 2
  (export "field_neg_two" (global $field_neg_two))
  (global $field_neg_two i32 (i32.const 352))

  ;; 32 bytes
  ;; 1
  (global $one i32 (i32.const 384))
  (data (i32.const 384) "\01")

  ;; 32 bytes
  (global $u256_mod_tmp i32 (i32.const 416))

  ;; 64 bytes
  (global $field_mul_tmp i32 (i32.const 448))
  (global $field_mul_tmp_shr_256 i32 (i32.const 480))

  ;; 64 bytes
  (global $scalar_mul_tmp i32 (i32.const 512))
  (global $scalar_mul_tmp_shr_256 i32 (i32.const 544))

  ;; 32 bytes
  (global $field_mul_eq_tmp i32 (i32.const 576))

  (global $rist_code_tmp_s i32 (i32.const 608))
  (global $rist_code_tmp_u1 i32 (i32.const 640))
  (global $rist_code_tmp_u2 i32 (i32.const 672))
  (global $rist_code_tmp_v i32 (i32.const 704))
  (global $rist_code_tmp_i i32 (i32.const 736))
  (global $rist_code_tmp_dx i32 (i32.const 768))
  (global $rist_code_tmp_dy i32 (i32.const 800))
  (global $rist_code_tmp_u2_2 i32 (i32.const 832))

  ;; 32 bytes
  ;; 2
  (global $two i32 (i32.const 864))
  (data (i32.const 864) "\02")

  ;; 32 bytes
  ;; -121665/121666
  (export "rist_d" (global $rist_d))
  (global $rist_d i32 (i32.const 896))

  ;; 32 bytes
  ;; 3 + 7 * (field - 5) / 8
  (export "field_invsqrt_pow" (global $field_invsqrt_pow))
  (global $field_invsqrt_pow i32 (i32.const 928))

  ;; 32 bytes
  ;; sqrt(-1)
  (export "field_i" (global $field_i))
  (global $field_i i32 (i32.const 960))

  ;; 32 bytes
  ;; -sqrt(-1)
  (export "field_neg_i" (global $field_neg_i))
  (global $field_neg_i i32 (i32.const 992))

  ;; 32 bytes
  ;; field - 1
  (export "field_neg_one" (global $field_neg_one))
  (global $field_neg_one i32 (i32.const 1024))

  (global $field_invsqrt_tmp_r i32 (i32.const 1056))
  (global $field_invsqrt_tmp_c i32 (i32.const 1088))

  ;; 32 bytes
  ;; 1 / sqrt(-1 - d)
  (export "rist_inv_root_a_sub_d" (global $rist_inv_root_a_sub_d))
  (global $rist_inv_root_a_sub_d i32 (i32.const 1120))

  ;; 32 bytes
  ;; 486662
  (export "curve_a" (global $curve_a))
  (global $curve_a i32 (i32.const 1152))

  (global $curve_dbl_tmp_x_2 i32 (i32.const 1184))
  (global $curve_dbl_tmp_y_2 i32 (i32.const 1216))
  (global $curve_dbl_tmp_2z_2 i32 (i32.const 1248))
  (global $curve_dbl_tmp_x_y_2 i32 (i32.const 1280))

  (global $curve_tmp_cx i32 (i32.const 1312))
  (global $curve_tmp_cy i32 (i32.const 1344))
  (global $curve_tmp_cz i32 (i32.const 1376))
  (global $curve_tmp_ct i32 (i32.const 1408))

  (global $curve_add_tmp_pp i32 (i32.const 1440))
  (global $curve_add_tmp_mm i32 (i32.const 1472))
  (global $curve_add_tmp_zz2 i32 (i32.const 1504))
  (global $curve_add_tmp_tt2d i32 (i32.const 1536))
  (global $curve_add_tmp i32 (i32.const 1568))

  ;; 32 bytes
  ;; 2 * -121665/121666
  (export "rist_2d" (global $rist_2d))
  (global $rist_2d i32 (i32.const 1600))

  ;; 128 bytes
  (export "rist_zero" (global $rist_zero))
  (global $rist_zero i32 (i32.const 3141))

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

  (export "field_add" (func $field_add))
  (func $field_add (param $o i32) (param $x i32)
    (drop (call $_u256_add (local.get $o) (i64.const 1) (local.get $x) (i64.const 0)))
    (call $u256_mod_neg (local.get $o) (global.get $neg_field))
  )

  (export "scalar_add" (func $scalar_add))
  (func $scalar_add (param $o i32) (param $x i32)
    (drop (call $_u256_add (local.get $o) (i64.const 1) (local.get $x) (i64.const 0)))
    (call $u256_mod_neg (local.get $o) (global.get $neg_scalar))
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

  ;; o: &field; x: &field; y: &field
  ;; *x *= *y
  (export "field_mul" (func $field_mul))
  (func $field_mul (param $x i32) (param $y i32)
    (call $u256_mul_u512 (global.get $field_mul_tmp) (local.get $x) (local.get $y))
    (call $u256_mod_neg (global.get $field_mul_tmp) (global.get $neg_field))
    (call $u256_mod_neg (global.get $field_mul_tmp_shr_256) (global.get $neg_field))
    (drop (call $_u256_add (global.get $field_mul_tmp) (i64.const 0) (global.get $field_mul_tmp_shr_256)
      (call $_u256_add (global.get $field_mul_tmp) (i64.const 38) (global.get $field_mul_tmp_shr_256) (i64.const 0))
      (call $u256_mod_neg (global.get $field_mul_tmp) (global.get $neg_field))
      (i64.mul (i64.extend_i32_u) (i64.const 38))
    ))
    (call $u256_mod_neg (global.get $field_mul_tmp) (global.get $neg_field))
    (memory.copy (local.get $x) (global.get $field_mul_tmp) (i32.const 32))
    (memory.fill (global.get $field_mul_tmp) (i32.const 0) (i32.const 64))
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

  (export "u512_mod_scalar" (func $u512_mod_scalar))
  (func $u512_mod_scalar (param $x i32) (local $n i32)
    (local.set $n (i32.add (local.get $x) (i32.const 32)))
    (loop $n
      (local.tee $n (i32.sub (local.get $n) (i32.const 1)))
      (call $u256_mod_neg (global.get $neg_scalar))
      (drop (call $_u256_add
        (local.get $n)
        (i64.extend_i32_u
          (call $_u256_add
            (local.get $n)
            (i64.extend_i32_u
              (call $_u256_add
                (local.get $n)
                (i64.load8_u offset=32 (local.get $n))
                (global.get $u256_mod_scalar)
                (i64.const 0)
              )
            )
            (global.get $u256_mod_scalar)
            (i64.const 0)
          )
        )
        (global.get $u256_mod_scalar)
        (i64.const 0)
      ))
      (call $u256_mod_neg (local.get $n) (global.get $neg_scalar))
      (br_if $n (i32.gt_u (local.get $n) (local.get $x)))
    )
  )

  ;; o: &field; x: &field; y: &field
  ;; *x *= (*y)
  (export "scalar_mul" (func $scalar_mul))
  (func $scalar_mul (param $x i32) (param $y i32)
    (local $n i32)
    (call $u256_mul_u512 (global.get $scalar_mul_tmp) (local.get $x) (local.get $y))
    (call $u256_mod_neg (global.get $scalar_mul_tmp_shr_256) (global.get $neg_scalar))
    (call $u512_mod_scalar (global.get $scalar_mul_tmp))
    (memory.copy (local.get $x) (global.get $scalar_mul_tmp) (i32.const 32))
    (memory.fill (global.get $scalar_mul_tmp) (i32.const 0) (i32.const 64))
  )

  (table $fns 2 funcref)
  (elem (i32.const 0)
    $field_mul
    $curve_add
  )

  ;; <T> x: &T, y: &T
  ;; *x *= *y
  (type $mul_fn (func (param i32) (param i32)))

  ;; <T> o: &T; x: &T; e: u32; f: &mul_fn<T>
  ;; *o = *o^u32 * (*x)^e
  (func $pow_u32 (param $o i32) (param $x i32) (param $e i32) (param $mul i32)
    (local $m i32)
    (local.set $m (i32.const 0x80000000))
    (loop $m
      (call_indirect $fns (type $mul_fn) (local.get $o) (local.get $o) (local.get $mul))
      (if (i32.and (local.get $e) (local.get $m)) (then
        (call_indirect $fns (type $mul_fn) (local.get $o) (local.get $x) (local.get $mul))
      ))
      (br_if $m (local.tee $m (i32.shr_u (local.get $m) (i32.const 1))))
    )
  )

  ;; <T> o: &T; x: &T; e: &u256; f: &mul_fn<T>
  ;; *o = *o^(u256) * (*x)^(*e)
  (func $pow (param $o i32) (param $x i32) (param $e i32) (param $mul i32)
    (local $m i32)
    (local.set $m (i32.add (local.get $e) (i32.const 28)))
    (loop $m
      (call $pow_u32 (local.get $o) (local.get $x) (i32.load (local.get $m)) (local.get $mul))
      (local.tee $m (i32.sub (local.get $m) (i32.const 4)))
      (br_if $m (i32.ge_u (local.get $e)))
    )
  )

  ;; *n == 0
  (func $u256_eqz (param $n i32) (result i32)
    (i64.eqz (i64.load offset=0 (local.get $n)))
    (i32.and (i64.eqz (i64.load offset=8 (local.get $n))))
    (i32.and (i64.eqz (i64.load offset=16 (local.get $n))))
    (i32.and (i64.eqz (i64.load offset=24 (local.get $n))))
  )

  ;; *a == *b
  (func $u256_eq (param $a i32) (param $b i32) (result i32)
    (i64.eq (i64.load offset=0 (local.get $a)) (i64.load offset=0 (local.get $b)))
    (i32.and (i64.eq (i64.load offset=8 (local.get $a)) (i64.load offset=8 (local.get $b))))
    (i32.and (i64.eq (i64.load offset=16 (local.get $a)) (i64.load offset=16 (local.get $b))))
    (i32.and (i64.eq (i64.load offset=24 (local.get $a)) (i64.load offset=24 (local.get $b))))
  )

  (export "field_invsqrt" (func $field_invsqrt))
  (func $field_invsqrt (param $x i32) (result i32)
    (local $n i32)

    (memory.copy (global.get $field_invsqrt_tmp_r) (global.get $one) (i32.const 32))
    (call $pow (global.get $field_invsqrt_tmp_r) (local.get $x) (global.get $field_invsqrt_pow) (i32.const 0))

    (memory.copy (global.get $field_invsqrt_tmp_c) (global.get $field_invsqrt_tmp_r) (i32.const 32))
    (call $field_mul (global.get $field_invsqrt_tmp_c) (global.get $field_invsqrt_tmp_c))
    (call $field_mul (global.get $field_invsqrt_tmp_c) (local.get $x))

    (if (i32.or
      (local.tee $n (call $u256_eq (global.get $field_invsqrt_tmp_c) (global.get $field_neg_one)))
      (call $u256_eq (global.get $field_invsqrt_tmp_c) (global.get $field_neg_i))
    ) (then
      (call $field_mul (global.get $field_invsqrt_tmp_r) (global.get $field_i))
    ))

    (i32.or
      (call $u256_eq (global.get $field_invsqrt_tmp_c) (global.get $one))
      (local.get $n)
    )

    (if (i32.and (i32.load8_u (global.get $field_invsqrt_tmp_r)) (i32.const 1)) (then
      (call $u256_sub (global.get $field_invsqrt_tmp_r) (global.get $field) (global.get $field_invsqrt_tmp_r))
    ))

    (memory.copy (local.get $x) (global.get $field_invsqrt_tmp_r) (i32.const 32))
  )

  (export "rist_decode" (func $rist_decode))
  (func $rist_decode (param $o i32) (param $s i32) (result i32)
    (local $y i32)
    (local $t i32)

    (memory.fill (global.get $rist_code_tmp_s) (i32.const 0) (i32.const 256))

    (memory.copy (global.get $rist_code_tmp_s) (local.get $s) (i32.const 32))
    (if (call $_u256_add (global.get $rist_code_tmp_s) (i64.const 1) (global.get $neg_field) (i64.const 0)) (then
      (return (i32.const 1))
    ))
    (if (i32.and (i32.load8_u (local.get $s)) (i32.const 1)) (then
      (return (i32.const 2))
    ))

    (memory.copy (global.get $rist_code_tmp_u1) (local.get $s) (i32.const 32)) ;; u1 = s
    (call $field_mul (global.get $rist_code_tmp_u1) (global.get $rist_code_tmp_u1)) ;; u1 = s^2
    (memory.copy (global.get $rist_code_tmp_u2) (global.get $rist_code_tmp_u1) (i32.const 32)) ;; u2 = s^2
    (call $u256_sub (global.get $rist_code_tmp_u1) (global.get $field) (global.get $rist_code_tmp_u1)) ;; u1 = -s^2
    (call $field_add (global.get $rist_code_tmp_u1) (global.get $one)) ;; u1 = 1 - s^2
    (call $field_add (global.get $rist_code_tmp_u2) (global.get $one)) ;; u2 = 1 + s^2

    (memory.copy (global.get $rist_code_tmp_u2_2) (global.get $rist_code_tmp_u2) (i32.const 32)) ;; u2_2 = u2
    (call $field_mul (global.get $rist_code_tmp_u2_2) (global.get $rist_code_tmp_u2_2)) ;; u2_2 = u2^2

    (memory.copy (global.get $rist_code_tmp_v) (global.get $rist_d) (i32.const 32)) ;; v = d
    (call $field_mul (global.get $rist_code_tmp_v) (global.get $rist_code_tmp_u1)) ;; v = d u1
    (call $field_mul (global.get $rist_code_tmp_v) (global.get $rist_code_tmp_u1)) ;; v = d u1^2
    (call $field_add (global.get $rist_code_tmp_v) (global.get $rist_code_tmp_u2_2)) ;; v = d u1^2 + u2^2
    (call $u256_sub (global.get $rist_code_tmp_v) (global.get $field) (global.get $rist_code_tmp_v)) ;; v = - d u1^2 - u2^2

    (memory.copy (global.get $rist_code_tmp_i) (global.get $rist_code_tmp_v) (i32.const 32)) ;; i = v
    (call $field_mul (global.get $rist_code_tmp_i) (global.get $rist_code_tmp_u2_2)) ;; i = v u2^2
    (if (call $u256_eqz (global.get $rist_code_tmp_i)) (then
      (return (i32.const 3))
    ))
    (if (call $field_invsqrt (global.get $rist_code_tmp_i)) (then) (else
      (return (i32.const 4))
    ))
    ;; i = invsqrt(v u2^2)

    (memory.copy (global.get $rist_code_tmp_dx) (global.get $rist_code_tmp_i) (i32.const 32)) ;; dx = i
    (call $field_mul (global.get $rist_code_tmp_dx) (global.get $rist_code_tmp_u2)) ;; dx = i u2

    (memory.copy (global.get $rist_code_tmp_dy) (global.get $rist_code_tmp_i) (i32.const 32)) ;; dy = i
    (call $field_mul (global.get $rist_code_tmp_dy) (global.get $rist_code_tmp_dx)) ;; dy = i dx
    (call $field_mul (global.get $rist_code_tmp_dy) (global.get $rist_code_tmp_v)) ;; dy = i dx v

    (memory.copy (local.get $o) (global.get $two) (i32.const 32)) ;; x = 2
    (call $field_mul (local.get $o) (local.get $s)) ;; x = 2 s
    (call $field_mul (local.get $o) (global.get $rist_code_tmp_dx)) ;; x = 2 s dx

    (if (i32.and (i32.load8_u (local.get $o)) (i32.const 1)) (then
      (call $u256_sub (local.get $o) (global.get $field) (local.get $o))
    ))
    ;; x = | 2 s dx |

    (local.tee $y (i32.add (local.get $o) (i32.const 32)))
    (memory.copy (global.get $rist_code_tmp_u1) (i32.const 32)) ;; y = u1
    (call $field_mul (local.get $y) (global.get $rist_code_tmp_dy)) ;; y = u1 dy

    (memory.copy (i32.add (local.get $o) (i32.const 64)) (global.get $one) (i32.const 32))

    (local.tee $t (i32.add (local.get $o) (i32.const 96)))
    (memory.copy (local.get $y) (i32.const 32)) ;; t = y
    (call $field_mul (local.get $t) (local.get $o)) ;; t = x y

    (if (i32.or
      (call $u256_eqz (local.get $y))
      (i32.and (i32.load8_u (local.get $t)) (i32.const 1))
    ) (then
      (return (i32.const 5))
    ))

    (i32.const 0)
  )

  (export "rist_encode" (func $rist_encode))
  (func $rist_encode (param $o i32) (param $x i32)
    (local $y i32) (local $z i32) (local $t i32)

    (local.set $y (i32.add (local.get $x) (i32.const 32)))
    (local.set $z (i32.add (local.get $x) (i32.const 64)))
    (local.set $t (i32.add (local.get $x) (i32.const 96)))

    (memory.copy (global.get $rist_code_tmp_u1) (local.get $z) (i32.const 32)) ;; u1 = z
    (call $field_add (global.get $rist_code_tmp_u1) (local.get $y)) ;; u1 = z + y

    (memory.copy (global.get $rist_code_tmp_s) (local.get $y) (i32.const 32)) ;; n = y
    (call $u256_sub (global.get $rist_code_tmp_s) (global.get $field) (global.get $rist_code_tmp_s)) ;; n = -y
    (call $field_add (global.get $rist_code_tmp_s) (local.get $z)) ;; n = z - y

    (call $field_mul (global.get $rist_code_tmp_u1) (global.get $rist_code_tmp_s)) ;; u1 = (z + y) (z - y)

    (memory.copy (global.get $rist_code_tmp_u2) (local.get $x) (i32.const 32)) ;; u2 = x
    (call $field_mul (global.get $rist_code_tmp_u2) (local.get $y)) ;; u2 = x y

    (memory.copy (global.get $rist_code_tmp_i) (global.get $rist_code_tmp_u2) (i32.const 32)) ;; i = u2
    (call $field_mul (global.get $rist_code_tmp_i) (global.get $rist_code_tmp_i)) ;; i = u2^2
    (call $field_mul (global.get $rist_code_tmp_i) (global.get $rist_code_tmp_u1)) ;; i = u1 u2^2
    (drop (call $field_invsqrt (global.get $rist_code_tmp_i))) ;; i = invsqrt(u1 u2^2)

    ;; d1 = u1
    ;; d2 = u2
    (call $field_mul (global.get $rist_code_tmp_u1) (global.get $rist_code_tmp_i)) ;; d1 = u1 i
    (call $field_mul (global.get $rist_code_tmp_u2) (global.get $rist_code_tmp_i)) ;; d2 = u2 i

    (memory.copy (global.get $rist_code_tmp_v) (global.get $rist_code_tmp_u1) (i32.const 32)) ;; z_inv = d1
    (call $field_mul (global.get $rist_code_tmp_v) (global.get $rist_code_tmp_u2)) ;; z_inv = d1 d2
    (call $field_mul (global.get $rist_code_tmp_v) (local.get $t)) ;; z_inv = d1 d2 t

    (memory.copy (global.get $rist_code_tmp_s) (global.get $rist_code_tmp_v) (i32.const 32)) ;; n = z_inv
    (call $field_mul (global.get $rist_code_tmp_s) (local.get $t)) ;; n = t z_inv

    (if (i32.and (i32.load8_u (global.get $rist_code_tmp_s)) (i32.const 1)) (then
      (memory.copy (global.get $rist_code_tmp_dx) (local.get $y) (i32.const 32)) ;; dx = y
      (call $field_mul (global.get $rist_code_tmp_dx) (global.get $field_i)) ;; dx = i y

      (memory.copy (global.get $rist_code_tmp_dy) (local.get $x) (i32.const 32)) ;; dy = x
      (call $field_mul (global.get $rist_code_tmp_dy) (global.get $field_i)) ;; dy = i x

      (memory.copy (global.get $rist_code_tmp_i) (global.get $rist_code_tmp_u1) (i32.const 32)) ;; d = d1
      (call $field_mul (global.get $rist_code_tmp_i) (global.get $rist_inv_root_a_sub_d)) ;; d = d1 / sqrt(a - d)
    ) (else
      (memory.copy (global.get $rist_code_tmp_dx) (local.get $x) (i32.const 32)) ;; dx = x
      (memory.copy (global.get $rist_code_tmp_dy) (local.get $y) (i32.const 32)) ;; dy = y
      (memory.copy (global.get $rist_code_tmp_i) (global.get $rist_code_tmp_u2) (i32.const 32)) ;; d = d2
    ))

    (memory.copy (global.get $rist_code_tmp_s) (global.get $rist_code_tmp_v) (i32.const 32)) ;; n = z_inv
    (call $field_mul (global.get $rist_code_tmp_s) (global.get $rist_code_tmp_dx)) ;; n = dx z_inv

    (if (i32.and (i32.load8_u (global.get $rist_code_tmp_s)) (i32.const 1)) (then) (else
      (call $u256_sub (global.get $rist_code_tmp_dy) (global.get $field) (global.get $rist_code_tmp_dy))
    ))

    (call $field_add (global.get $rist_code_tmp_dy) (local.get $z)) ;; s = (z - dy)
    (call $field_mul (global.get $rist_code_tmp_dy) (global.get $rist_code_tmp_i)) ;; s = (z - dy)d

    (if (i32.and (i32.load8_u (global.get $rist_code_tmp_dy)) (i32.const 1)) (then
      (call $u256_sub (global.get $rist_code_tmp_dy) (global.get $field) (global.get $rist_code_tmp_dy))
    ))
    ;; s = |(z - dy)d|

    (memory.copy (local.get $o) (global.get $rist_code_tmp_dy) (i32.const 32))
  )

  (export "curve_add" (func $curve_add))
  (func $curve_add (param $ax i32) (param $bx i32)
    (local $ay i32) (local $az i32) (local $at i32)
    (local $by i32) (local $bz i32) (local $bt i32)

    (local.set $ay (i32.add (local.get $ax) (i32.const 32)))
    (local.set $az (i32.add (local.get $ax) (i32.const 64)))
    (local.set $at (i32.add (local.get $ax) (i32.const 96)))

    (local.set $by (i32.add (local.get $bx) (i32.const 32)))
    (local.set $bz (i32.add (local.get $bx) (i32.const 64)))
    (local.set $bt (i32.add (local.get $bx) (i32.const 96)))

    (memory.copy (global.get $curve_add_tmp_pp) (local.get $ax) (i32.const 32))
    (call $field_add (global.get $curve_add_tmp_pp) (local.get $ay))
    (memory.copy (global.get $curve_add_tmp) (local.get $bx) (i32.const 32))
    (call $field_add (global.get $curve_add_tmp) (local.get $by))
    (call $field_mul (global.get $curve_add_tmp_pp) (global.get $curve_add_tmp))

    (memory.copy (global.get $curve_add_tmp_mm) (local.get $ax) (i32.const 32))
    (call $u256_sub (global.get $curve_add_tmp_mm) (global.get $field) (global.get $curve_add_tmp_mm))
    (call $field_add (global.get $curve_add_tmp_mm) (local.get $ay))
    (memory.copy (global.get $curve_add_tmp) (local.get $bx) (i32.const 32))
    (call $u256_sub (global.get $curve_add_tmp) (global.get $field) (global.get $curve_add_tmp))
    (call $field_add (global.get $curve_add_tmp) (local.get $by))
    (call $field_mul (global.get $curve_add_tmp_mm) (global.get $curve_add_tmp))

    (memory.copy (global.get $curve_add_tmp_tt2d) (local.get $at) (i32.const 32))
    (call $field_mul (global.get $curve_add_tmp_tt2d) (local.get $bt))
    (call $field_mul (global.get $curve_add_tmp_tt2d) (global.get $rist_2d))

    (memory.copy (global.get $curve_add_tmp_zz2) (local.get $az) (i32.const 32))
    (call $field_mul (global.get $curve_add_tmp_zz2) (local.get $bz))
    (call $field_add (global.get $curve_add_tmp_zz2) (global.get $curve_add_tmp_zz2))

    (memory.copy (global.get $curve_tmp_cx) (global.get $curve_add_tmp_mm) (i32.const 32))
    (call $u256_sub (global.get $curve_tmp_cx) (global.get $field) (global.get $curve_tmp_cx))
    (call $field_add (global.get $curve_tmp_cx) (global.get $curve_add_tmp_pp))

    (memory.copy (global.get $curve_tmp_cy) (global.get $curve_add_tmp_mm) (i32.const 32))
    (call $field_add (global.get $curve_tmp_cy) (global.get $curve_add_tmp_pp))

    (memory.copy (global.get $curve_tmp_cz) (global.get $curve_add_tmp_tt2d) (i32.const 32))
    (call $field_add (global.get $curve_tmp_cz) (global.get $curve_add_tmp_zz2))

    (memory.copy (global.get $curve_tmp_ct) (global.get $curve_add_tmp_tt2d) (i32.const 32))
    (call $u256_sub (global.get $curve_tmp_ct) (global.get $field) (global.get $curve_tmp_ct))
    (call $field_add (global.get $curve_tmp_ct) (global.get $curve_add_tmp_zz2))

    (memory.copy (local.get $ax) (global.get $curve_tmp_cx) (i32.const 96))
    (memory.copy (local.get $at) (global.get $curve_tmp_cx) (i32.const 32))
    (call $field_mul (local.get $ax) (global.get $curve_tmp_ct))
    (call $field_mul (local.get $ay) (global.get $curve_tmp_cz))
    (call $field_mul (local.get $az) (global.get $curve_tmp_ct))
    (call $field_mul (local.get $at) (global.get $curve_tmp_cy))
  )

  (func (export "curve_pow") (param $o i32) (param $x i32) (param $e i32)
    (memory.copy (local.get $o) (global.get $rist_zero) (i32.const 128))
    (call $pow (local.get $o) (local.get $x) (local.get $e) (i32.const 1))
  )
)
