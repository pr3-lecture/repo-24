;Programming 3 [Professor Schramm]
;WS 2017 @ University of Applied Sciences, Mannheim
;@Authoren: Anusan Ranja, Eugen Krizki, Johannes Lotz, Richard Vladimirskij

;EXERCISE 1 A - ROTIERE
;rotiere -> accepts a list and returns a new list with the first element in the last position
;@lst a non-nested list
(defun rotiere (lst)
(cond
  ((null lst) nil)
  ;append the first element of the list to the back of the rest of the list
  (t(append (cdr lst) (list (car lst))))
  )
  )

  ;EXERCISE 1 B - NEUES VORLETZTES
  ;Assisting method -> rvrs
  ;rvrs -> accepts a list and returns a new list where the order of the elements within is reversed
  ;@lst a non-nested list
  (defun rvrs(x)
  (cond
    ((null x) x)
    ;Recursively break down the list to the last element and append it back together
    (t(append (rvrs(cdr x)) (list(car x))))
    )
    )

    ;neues-vorletztes -> takes an element and a list and returns a new list
    ;whereby the element has been inserted into the secondLast position
    ;@elem any element (atom or cons-cell)
    ;@list any kind of list (nested or non)
    (defun neues-vorletztes(elem lst)
    (setf revLst (rvrs lst)) ;Reverse the original list
    ;Insert the element into the second position of the reversed list and reverse it back again
    (rvrs (append (list(car revLst)) (list elem) (cdr revLst)))
    )

    ;EXERCISE 1 C - MY-LENGTH
    ;my-length -> takes a list and returns its length as a number
    ;@lst a non-nested list
    (defun my-length (lst)
    (cond
      ((null lst)0)
      ;Recursively break down the list building the sum of function calls
      (t(+ 1 (my-length(cdr lst))))
      )
      )

      ;EXERCISE 1 D - MY-LENGTHR
      ;my-lengthR -> takes any list (nested or not) and returns the amount of atoms within it as a number.
      ;@lst any list
      (defun my-lengthR (lst)
      (cond
        ((null lst) 0)
        ;If a nested list is encountered as an element in the current list
        ;it needs to be processed as a "new" list apart from the rest as we don't know
        ;what comes next. This leads to forked recursion paths so the results
        ;need to be summed up
        ((listp (car lst)) (+ (my-lengthR (car lst)) (my-lengthR(cdr lst))))
        ;If the next element is an atom, sum it up
        (t(+ 1 (my-lengthR (cdr lst))))
        )
        )

        ;EXERCISE 1 E - MY-REVERSE // ANALOG TO RVRS
        ;my-reverse -> accepts a list of atoms and returns a new list with the order of elements reversed
        ;@lst a non-nested list
        (defun my-reverse(lst)
        (cond
          ((null lst) lst)
          ;Recursively break down the list to the last atom and append it back together
          (t(append (my-reverse (cdr lst)) (list (car lst))))
          )
          )

          ;EXERCISE 1 F - MY-REVERSER
          ;my-reverseR -> accespts any list (nested or not) and returns a new list with all elements reversed
          ;@lst any list
          (defun my-reverseR(lst)
          (cond
            ((null lst) lst)
            ;When a list-element is encountered the list is broken down recursively and
            ;appended back together as a new list resulting in a reversed order
            ((listp (car lst))(append (my-reverseR(cdr lst)) (list(my-reverseR(car lst)))))
            ;Same as above, just dealing with atoms.
            (t(append (my-reverseR (cdr lst)) (list (car lst))))
            )
            )

            ;Exercise 2

            ;Exercise 2 A -> What would a binary tree look like as a list (See pdf: abgabe_übung_1_schriftlich.pdf)?
            (setf binTree '(25 (15 (10 (4) (12)) (22 (18) (24))) (50 (35 (31) (44)) (70 (66) (90)))))

            ;EXERCISE 2 B -> TREE TRAVERSALS

            ;inorder -> recursively traveses a binary tree and outputs the node values as a list inorder
            ;@tree a list that conforms to the definition of the binary tree (as in exercise 2A)
            (defun inorder (tree)
            (cond
              ((null tree) tree);empty tree
              ((listp (car tree))(inorder(car tree)));encountering a branch
              ((null (cdr tree)) (append (list(car tree)))) ;encountering a leaf
              (t(append (inorder (cadr tree)) (list(car tree)) (inorder(caddr tree)))) ;encountering a node (Left / Node / Right)
              )
              )

              ;postorder -> recursively traveses a binary tree and outputs the node values in apostorder
              ;@tree -> a list that conforms to the definition of the binary tree (as in exercise 2A)
              (defun postorder (tree)
              (cond
                ((null tree) tree)
                ((listp (car tree))(postorder(cdr tree)));encountering a branch
                ((null (cdr tree)) (append (list(car tree)))) ;encountering a leaf
                (t(append (postorder (cadr tree)) (postorder(caddr tree)) (list (car tree)))) ;encountering a node (Left / Right / Node)
                )
                )

                ;preorder -> recursively traveses a binary tree and outputs the node values in a preorder
                ;@tree -> a list that conforms to the definition of the binary tree (as in exercise 2A)
                (defun preorder (tree)
                (cond
                  ((null tree) tree)
                  ((listp (car tree))(preorder(cdr tree)));encountering a branch
                  ((null (cdr tree)) (append (list(car tree)))) ;encountering a leaf
                  (t(append (list (car tree)) (preorder (cadr tree)) (preorder(caddr tree)) )) ;encountering a node (Node / Left / Right)
                  )
                  )
