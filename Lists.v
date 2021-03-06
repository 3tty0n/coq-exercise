Require Export Basics.

Module NatList.

Inductive natprod : Type :=
  pair : nat -> nat -> natprod.

Definition fst (p : natprod) : nat :=
  match p with
  | pair x y => x
  end.

Definition snd (p : natprod) :=
  match p with
  | pair x y => y
  end.

Notation "( x , y )" := (pair x y).

Eval simpl in (fst (3,4)).

Definition fst' (p : natprod) :=
  match p with
  | (x, y) => x
  end.

Definition snd' (p : natprod) :=
  match p with
  | (x, y) => y
  end.

Definition swap_pair (p : natprod) : natprod :=
  match p with
  | (x, y) => (y, x)
  end.

Theorem surjective_pairing' : forall (n m : nat),
    (n, m) = (fst (n, m), snd (n, m)).
Proof.
  reflexivity.
Qed.

Theorem surjective_pairing_stuck : forall (p : natprod),
    p = (fst p, snd p).
Proof.
  intros p.
  destruct p as (n, m).
  simpl.
  reflexivity.
Qed.

Theorem snd_fst_is_swap : forall (p : natprod),
    (snd p, fst p) = swap_pair p.
Proof.
  intros p.
  destruct p as (n, m).
  simpl.
  reflexivity.
Qed.

Inductive natlist : Type :=
| nil : natlist
| cons : nat -> natlist -> natlist.

Definition l_123 := cons 1 (cons 2 (cons 3 nil)).

Notation "x :: l" := (cons x l) (at level 60, right associativity).
Notation "[ ]" := nil.
Notation "[ x , .. , y ]" := (cons x .. (cons y nil) ..).

Fixpoint repeat (n count : nat) : natlist :=
  match count with
  | O => nil
  | S count' => n :: (repeat n count')
  end.

Fixpoint length (l : natlist) : nat :=
  match l with
  | nil => O
  | h :: t => S (length t)
  end.

Fixpoint app (l1 l2 : natlist) : natlist :=
  match l1 with
  | nil => l2
  | h :: t => h :: (app t l2)
  end.

Notation "x ++ y" := (app x y)
                       (right associativity, at level 60).


Definition hd (default : nat) (l : natlist) :=
  match l with
  | nil => default
  | h :: t => h
  end.

Definition tail (l : natlist) :=
  match l with
  | nil => nil
  | h :: t => t
  end.

Example test_hd1: hd 0 [1, 2, 3] = 1.
Proof. reflexivity. Qed.
Example test_hd2: hd 0 [] = 0.
Proof. reflexivity. Qed.
Example test_tail: tail [1, 2, 3] = [2, 3].
Proof. reflexivity. Qed.

Fixpoint nonzeros (l : natlist) : natlist :=
  match l with
  | [] => []
  | 0 :: tl => nonzeros (tl)
  | hd :: tl => hd :: nonzeros (tl)
  end.
Example test_nonzeros: nonzeros [0, 1, 0, 2, 3, 0, 0] = [1, 2, 3].
Proof. reflexivity. Qed.

Fixpoint oddmembers (l : natlist) : natlist :=
  match l with
  | [] => []
  | h :: t => match evenb h with
             | true => oddmembers t
             | false => h :: (oddmembers t)
             end
  end.
Example test_oddmembers: oddmembers [0, 1, 0, 2, 3, 0, 0] = [1, 3].
Proof. reflexivity. Qed.

Fixpoint countoddmembers (l : natlist) : nat :=
  match l with
  | [] => 0
  | h :: t => match evenb h with
             | true => countoddmembers t
             | false => 1 + (countoddmembers t)
             end
  end.
Example test_countoddmembers1: countoddmembers [1,0,3,1,4,5] = 4.
Proof. reflexivity. Qed.
Example test_countoddmembers2: countoddmembers [0,2,4] = 0.
Proof. reflexivity. Qed.
Example test_countoddmembers3: countoddmembers nil = 0.
Proof. reflexivity. Qed.

Fixpoint alternate (l1 l2 : natlist) : natlist :=
  match l1 with
  | [] => l2
  | h1 :: t1 => match l2 with
               | [] => l1
               | h2 :: t2 => h1 :: h2 :: (alternate t1 t2)
               end
  end.
Example test_alternate1: alternate [1,2,3] [4,5,6] = [1,4,2,5,3,6].
Proof. reflexivity. Qed.
Example test_alternate2: alternate [1] [4,5,6] = [1,4,5,6].
Proof. reflexivity. Qed.
Example test_alternate3: alternate [1,2,3] [4] = [1,4,2,3].
Proof. reflexivity. Qed.
Example test_alternate4: alternate [] [20,30] = [20,30].
Proof. reflexivity. Qed.

Definition bag := natlist.

Fixpoint count (v : nat) (s : bag) : nat :=
  match s with
  | [] => 0
  | h :: t => match beq_nat v h with
             | true => 1 + (count v t)
             | false => count v t
             end
  end.

Example test_count1: count 1 [1,2,3,1,4,1] = 3.
Proof. reflexivity. Qed.
Example test_count2: count 6 [1,2,3,1,4,1] = 0.
Proof. reflexivity. Qed.

Definition sum : bag -> bag -> bag := app.

Example test_sum1: count 1 (sum [1,2,3] [1,4,1]) = 3.
Proof. reflexivity. Qed.

Definition add (v : nat) (s : bag) : bag := v :: s.
Example test_add1: count 1 (add 1 [1,4,1]) = 3.
Proof. reflexivity. Qed.
Example test_add2: count 5 (add 1 [1,4,1]) = 0.
Proof. reflexivity. Qed.

Fixpoint eq_nat (n1 n2 : nat) : bool :=
  match n1, n2 with
  | O, O => true
  | O, S n | S n, O => false
  | S n1, S n2 => eq_nat n1 n2
  end.

Fixpoint neq_nat (n1 n2 : nat) : bool :=
  match n1, n2 with
  | O, O => false
  | O, S n | S n, O => true
  | S n1, S n2 => neq_nat n1 n2
  end.

Definition member (v : nat) (s : bag) : bool :=
  negb (eq_nat (count v s) 0).

Example test_member1: member 1 [1,4,1] = true.
Proof. reflexivity. Qed.
Example test_member2: member 2 [1,4,1] = false.
Proof. reflexivity. Qed.

Fixpoint remove_one (v : nat) (s : bag) : bag :=
  match s with
  | [] => []
  | h :: t => match eq_nat v h with
             | true => remove_one v t
             | false => h :: (remove_one v t)
             end
  end.

Example test_remove_one1: count 5 (remove_one 5 [2,1,5,4,1]) = 0.
Proof. reflexivity. Qed.
Example test_remove_one2: count 5 (remove_one 5 [2,1,4,1]) = 0.
Proof. reflexivity. Qed.
Example test_remove_one3: count 4 (remove_one 5 [2,1,4,5,1,4]) = 2.
Proof. reflexivity. Qed.
