;
; Data types:
; - expense (type, amount, date)
; - 
;

; common functions used by the author
(load "common.arc")

(= *expenses* nil)

; Abstract away the data structures behind some functions

(def create-expense (type value date)
  (list type value date))

(def get-type (expense)
  (car expense))

(def get-value (expense)
  (cadr expense))

(def get-date (expense)
  (car:cddr expense))

(def add-expense (expense expenses)
  (cons expense expenses))

(def remove-expense (expense expenses)
  (rem1 [iso _ expense] expenses))

(def expenses-with-type (type expenses)
  (keep [iso (get-type _) type] expenses))

; APPLICATION SERVER STUFF

; Operations
(defop show req
       (showexpenses))

; Helper functions
(mac expensespage body
  `(whitepage:center (tag (table width 1000 height 600) ,@body)))

(def showexpenses ()
  (expensespage
    (tag (table width "100%" height "100%"  bgcolor (color 172 172 172))
         (row))))

(def esv ()
  (asv))

; TESTS

(def test-create ()
  (and
    (prn "starting test-create")
    (iso 1 (get-type (create-expense 1 2 3)))
    (iso 14 (get-type (create-expense 14 21 9)))
    (iso 2 (get-value (create-expense 1 2 3)))
    (iso 21 (get-value (create-expense 14 21 9)))
    (iso 3 (get-date (create-expense 1 2 3)))
    (iso 9 (get-date (create-expense 14 21 9)))
    (prn "finished test-create")))

(def test-add ()
  (and
    (prn "starting test-add")
    (iso '((1 2 3)) (add-expense '(1 2 3) ()))
    (iso '((1 2 3) (4 5 6)) (add-expense '(1 2 3) '((4 5 6))))
    (iso '((1 2 3) (1 2 3)) (add-expense '(1 2 3) '((1 2 3))))
    (prn "finished test-add")))

(def test-remove ()
  (and
    (prn "starting test-remove")
    (iso () (remove-expense '(1 2 3) '((1 2 3))))
    (iso '((4 5 6)) (remove-expense '(1 2 3) '((1 2 3) (4 5 6))))
    (iso '((1 2 3)) (remove-expense '(4 5 6) '((1 2 3) (4 5 6))))
    (prn "finished test-remove")))

(def test-type ()
  (and
    (prn "starting test-type")
    (iso () (expenses-with-type 3 '((1 2 3) (2 2 3) (4 3 6))))
    (iso '((3 1 4)) (expenses-with-type 3 '((1 2 3) (2 2 3) (3 1 4))))
    (iso '((3 1 4) (3 1 6)) (expenses-with-type 3 '((3 1 4) (2 2 3) (3 1 6))))
    (prn "finished test-type")))


(def run-tests ()
  (and (test-create)
       (test-add)
       (test-remove)
       (test-type)))
