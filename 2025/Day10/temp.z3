(set-logic QF_BV)
(set-info :smt-lib-version 2.0)
(set-info :status sat)

; BEGIN inject declares
(declare-fun btnasdf0 () (_ BitVec 6))
(assert (bvult btnasdf0 (_ bv2 6)))
(declare-fun btnasdf1 () (_ BitVec 6))
(assert (bvult btnasdf1 (_ bv2 6)))
(declare-fun btnasdf2 () (_ BitVec 6))
(assert (bvult btnasdf2 (_ bv2 6)))
(declare-fun btnasdf3 () (_ BitVec 6))
(assert (bvult btnasdf3 (_ bv2 6)))
; END inject declares

; BEGIN inject result
; [.###.#]
(declare-fun resasdf () (_ BitVec 6))}
(assert (= resasdf 46))
; END inject result

; BEGIN inject soft assertions
(assert-soft (bvult (bvadd btnasdf0 btnasdf1 btnasdf2 btnasdf3) (_ bv1 6)))
(assert-soft (bvult (bvadd btnasdf0 btnasdf1 btnasdf2 btnasdf3) (_ bv2 6)))
(assert-soft (bvult (bvadd btnasdf0 btnasdf1 btnasdf2 btnasdf3) (_ bv3 6)))
(assert-soft (bvult (bvadd btnasdf0 btnasdf1 btnasdf2 btnasdf3) (_ bv4 6)))
; END inject soft assertions

; BEGIN inject combine numbers
(assert (= resasdf (bvxor (bvmul btnasdf0 (_ bv31 6)) (bvmul btnasdf1 (_ bv25 6)) (bvmul btnasdf2 (_ bv55 6)) (bvmul btnasdf3 (_ bv6 6)))))
; END inject combine numbers

(assert (= r (bvxor (bvmul a (_ bv12 4)) (bvmul b (_ bv7 4)) (bvmul c (_ bv11 4)) (bvmul d (_ bv1 4)))))

(check-sat)

; BEGIN inject get value
(get-value (btnasdf0 btnasdf1 btnasdf2 btnasdf3))
; END inject get value
(get-value (a b c d))
(exit)
