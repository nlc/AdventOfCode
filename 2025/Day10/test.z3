(set-logic QF_BV)
(set-info :smt-lib-version 2.0)
(set-info :status sat)
; (set-option :produce-unsat-cores true)

(declare-fun a () (_ BitVec 4))
(assert (or (= a (_ bv0 4)) (= a (_ bv1 4))))
(declare-fun b () (_ BitVec 4))
(assert (or (= b (_ bv0 4)) (= b (_ bv1 4))))
(declare-fun c () (_ BitVec 4))
(assert (or (= c (_ bv0 4)) (= c (_ bv1 4))))
(declare-fun d () (_ BitVec 4))
(assert (or (= d (_ bv0 4)) (= d (_ bv1 4))))

(declare-fun r () (_ BitVec 4))
(assert (= r (_ bv6 4)))

(assert-soft (bvult (bvadd a b c d) (_ bv4 4)))
(assert-soft (bvult (bvadd a b c d) (_ bv3 4)))
(assert-soft (bvult (bvadd a b c d) (_ bv2 4)))

(assert (= r (bvxor (bvmul a (_ bv12 4)) (bvmul b (_ bv7 4)) (bvmul c (_ bv11 4)) (bvmul d (_ bv1 4)))))

(check-sat)
(get-value (a b c d))
(exit)
