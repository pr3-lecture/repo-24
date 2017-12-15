;Aus Aufgabenblatt 1
(defun inorder(tree) (cond
                         ((null tree) nil)
                         (t (append (inorder (cadr tree)) (list (car tree)) (inorder (caddr tree))))
                      )
    )
;Preorder: Element Linker-Tilbaum Rechter-Teilbaum
(defun preorder(tree) (cond
                         ((null tree) nil)
                         (t (append (list (car tree)) (preorder (cadr tree)) (preorder (caddr tree))))
                      )
    )
;Postorder: Linker-Tilbaum Rechter-Teilbaum Element
(defun postorder(tree) (cond
                         ((null tree) nil)
                         (t (append (postorder (cadr tree)) (postorder (caddr tree)) (list (car tree))))
                      )
    )

(setf tree '(50 (25 () (35 () ())) (75 (65 () ()) ())))

;Aufgabenblatt 2
(setf tree2 '(64 (16 () (32 () ())) (256 (128 () ()) ())))

;insert liefert einen Baum zurueck. Dieser enthaelt die Werte des uebergebenen Baums und den uebergebenen Wert.
;Wenn der uebergebene Wert berits im uebergebene Baum vorhanden ist wird der Baum unveraendert zurueckgegeben.
(defun insert (tree value) (cond
						((null tree) (list value '() '()))
						((> value (car tree)) (cond
											((null (caddr tree)) (append (list (car tree)) (list (cadr tree)) (list (list value '() '()))))	;Der Wert ist groesser wie die aktuelle Wurzel. Es gibt keinen rechten Teilbaum deshalb wird der Wert als rechter Teilbaum angehaengt.
											(t (append (list (car tree)) (list (cadr tree)) (list (insert (caddr tree) value))))	;Der Wert ist groesser wie die aktuelle Wurzel. Deshalb wird im rechten Teilbaum weiter nach der passenden Stelle fuer den Wert gesucht.
										   )
						)
						((< value (car tree)) (cond
											((null (cadr tree)) (append (list (car tree)) (list (list value '() '())) (list (caddr tree))))	;Der Wert ist kleiner wie die aktuelle Wurzel. Es gibt keinen linken Teilbaum deshalb wird der Wert als linker Teilbaum angehaengt.
											(t (append (list (car tree)) (list (insert (cadr tree) value)) (list (caddr tree))))	;Der Wert ist kleiner wie die aktuelle Wurzel. Deshalb wird im linken Teilbaum weiter nach der passenden Stelle fuer den Wert gesucht.
										    )
						)
						(t tree)	;Der Wert ist bereits im Baum vorhanden.
					 )
)

;insert_from_file liefert einen Baum zurueck. Dieser enthaelt die Werte des uebergebenen Baums und alle Werte die in der angegebenen Datei stehen.
;Wenn der angegeben Dateiname nicht exsistiert wird der uebergebene Baum zurueckgegeben.
(defun insert_from_file (tree filename) (setf file (open filename :if-does-not-exist nil))
							   (setf new_tree tree)
								(when file		;wird nur ausgefuehrt wenn die angegebene Datei exsistiert.
									(loop for value = (read file nil)		;Wert wird von der Datei gelesen. Ist kein Wert mehr vorhanden wird nil zurueckgegeben.
										while value do (setf new_tree (insert new_tree value))	;Solange der Wert nicht nil ist wird er in den Baum eingefuegt.
									)
									(close file)
								)
							   new_tree
)

;contains liefert 'T' zurueck, wenn der uebergebene Wert im Baum vorhanden ist. Ist dies nicht der Fall wird nil zurueckgegeben.
(defun contains (tree value) (cond
                                 ((null tree) nil)
                                 ((eq (car tree) value) t)
                                 ((> value (car tree)) (contains (caddr tree) value))
                                 ((< value (car tree)) (contains (cadr tree) value))
                                )
)

;size liefert eine Zahl zurueck, die angibt wie viele Koten der Baum hat.
(defun size (tree) (cond
                    ((null tree) 0)
                    ((listp (car tree)) (+ (size (car tree)) (size (cdr tree))))
                    (t (+ 1 (size (cdr tree))))
                   )
)

;height liefert eine Zahl zurueck, die angibt wie hoch der Baum ist.
(defun height (tree) (cond
                       ((null tree) 0)
                       (t (+ 1 ((lambda (value1 value2) (cond
                                                            ((< value1 value2) value2)
                                                            (t value1)
                                                        )
                                )
                                (height (cadr tree)) (height (caddr tree))
                               )
                          )
                       )
                      )
)

;getMax liefert den groessten im Baum vorhandenen Wert zurueck.
(defun getMax (tree) (cond
                      ((null tree) nil)
                      ((null (caddr tree)) (car tree))
                      (t (getMax (caddr tree)))
                     )
)

;getMin liefert den kleinsten im Baum vorhandenen Wert zurueck.
(defun getMin (tree) (cond
                      ((null tree) nil)
                      ((null (cadr tree)) (car tree))
                      (t (getMin (cadr tree)))
                     )
)

;remove_val liefert einen Baum zurueck. Dieser enthaelt alle Werte des uebergebenen Baums ausser dem uebergebenen Wert.
;Ist der uebergebene Wert ein Innerer Knoten wird dieser durch den kleinsten Wert im rechten Teilbaum ersetzt.
;Ist kein rechter Teilbaum vorhanden wird er durch den groessten Wert im linken Teilbaum ersetzt.
(defun remove_val (tree value) (cond
							((null tree) nil)
							((> value (car tree)) (append (list (car tree)) (list (cadr tree)) (list (remove_val (caddr tree) value))))	;Ist der Wert groesser als die Wurzel wird im rechten Teilbaum weiter gesucht.
							((< value (car tree)) (append (list (car tree)) (list (remove_val (cadr tree) value)) (list (caddr tree))))	;Ist der Wert kleiner als die Wurzel wird im linken Teilbaum weiter gesucht.
							(t (cond	;Wert gefunden
								((and (null (cadr tree)) (null (caddr tree))) nil)	;Der Wert steht in einem Blatt und kann somit einfach geloescht werden.
								((null (caddr tree)) (append (list (getMax (cadr tree))) (list (remove_val (cadr tree) (getMax (cadr tree)))) (list (caddr tree))))	;Es ist kein rechter Teilbaum vorhanden. Der Wert wird ersetzt durch den groessten Wert aus dem linken Teilbaum.
								(t (append (list (getMin (caddr tree))) (list(cadr tree)) (list (remove_val (caddr tree) (getMin (caddr tree))))))	;Der Wert wird ersetzt durch den kleinsten Wert aus dem rechten Teilbaum.
							    )
							)
						  )
)

;isEmpty liefert 'T' zurueck wenn ein leerer Baum uebergeben wird, ansonsten wird nil zurueckgegeben.
(defun isEmpty (tree) (cond
					((null tree) t)
				   )
)

;addAll liefert einen Baum zurueck. Dieser enthaelt die Werte der beiden uebergebenen Baeume.
;Wobei die Werte des zweiten Baums in den ersten eingefuegt werden.
(defun addAll (tree otherTree) (cond
							((null tree) (cond
										((null otherTree) nil)
										(t otherTree)	;Ist der erste Baum leer wird der zweite zurueckgegeben.
									  )
							)
							((null otherTree) tree)
							(t (addAll	;wird solange aufgerufen bis der zweite Baum leer ist.
								(insert tree (car otherTree))	;erster Baum in den der Wurzelwert des zweiten Baums eingefuegt wurde.
								(remove_val otherTree (car otherTree))	;zweiter Baum in dem die urspruengliche Wurzel geloescht wurde.
							    )
							)
						)
)

(setf binTree '(25 (15 (10 (4) (12)) (22 (18) (24))) (50 (35 (31 () ()) (44 () ())) (70 (66 () (68 () ())) (90 () ())))))
(setf lii '(10 (5 nil nil) (20 (15 (12 nil (13 nil nil)) nil) nil)))
(setf tree3 '(64 (16 () (32 () ())) (256 (128 () ()) ())))
(setf tree4 '(64 nil (256 (128 () ()) ())))

;Hilfsmethode printLevelorder
(defun getChildren (tree)
  (cond
    ((equal '(nil nil) (cdr tree)) ;sub tree has no children
      nil
    )
    ((null (cadr tree)) ;sub tree only has a right child
      (list (caddr tree)) ;has to be wrapped inside a list because the append function on a list with a list unwrapps the list
    )
    ((null (caddr tree)) ;sub tree only has a left child
      (list (cadr tree)) ;has to be wrapped inside a list because the append function on a list with a list unwrapps the list
    )
    (t
      (cdr tree)
    )
  )
)

;Hilfsmethode printLevelorder
(defun getNextList (li)
  (setf children_list li) ;the list, that contains the lists inside of li as a list. The children_list contains the unprocessed children
  (setf numeric_list '()) ;the list, that contains the numeric values of li. The numeric_list contains the already processed node values in levelorder
  (loop while (numberp (car children_list))
    do (setf numeric_list (append numeric_list (list (car children_list))))
    (setf children_list (cdr children_list))
  )
  (cond
    ((null children_list) ;no unprocessed children -> numeric_list equals li. Levelorder finished
      li
    )
    (t
      (cond
        ((null (car children_list)) ; filter empty left sub trees
          (append numeric_list (cdr children_list))
        )
        (t
          (append numeric_list (list (caar children_list)) (cdr children_list) (getChildren (car children_list)))
        )
      )
    )
  )
)

;printLevelorder liefert eine Liste zurueck. Diese Liste enthaelt die Werte des Baums sortiert anhand der Level des Baumes.
(defun printLevelorder (tree)
  (do ((prev_levelorder nil (append '() levelorder)) ;cache to check, if levelorder changed since last iteration
       (levelorder tree (getNextList levelorder)) ; a list containing the tree in levelorer
       (i 0 (+ i 1))
      )
      ((equal prev_levelorder levelorder) levelorder) ;check, if anything changed since last iteration
  )
)

;Menue
(setf a 0)
(setf run t)
(setf working_tree 0)
(setf tree_list '(() () ()))
(loop while run
		do (format t "~%")

	(format t "------------------- Menue -------------------~%")
	(format t "1: Print tree Inorder~%")
	(format t "2: Print tree Preorder~%")
	(format t "3: Print tree Postorder~%")
	(format t "4: Print tree Levelorder~%")
	(format t "5: Print size of the tree~%")
	(format t "6: Print height of the tree~%")
	(format t "7: insert(value)~%")
	(format t "8: insert(filname)~%")
	(format t "9: contains(value)~%")
	(format t "10: getMin()~%")
	(format t "11: getMax()~%")
	(format t "12: remove(value)~%")
	(format t "13: addAll(BinaryTree)~%")
	(format t "14: isempty()~%")
	(format t "15: change working tree~%")
	(format t "16: add tree to tree_list~%")
	(format t "17: show trees~%")
	(format t "18: exit~%")
	(setf a (read))
	(format t "---------------------------------------------~%")
	(cond
		((eq a 1) (format t "~S~%" (inorder (nth working_tree tree_list))))
		((eq a 2) (format t "~S~%" (preorder (nth working_tree tree_list))))
		((eq a 3) (format t "~S~%" (postorder (nth working_tree tree_list))))
		((eq a 4) (format t "~S~%" (printLevelorder (nth working_tree tree_list))))
		((eq a 5) (format t "~S~%" (size (nth working_tree tree_list))))
		((eq a 6) (format t "~S~%" (height (nth working_tree tree_list))))
		((eq a 7) (format t "Bitte geben sie einen Wert ein den sie in den Baum einfuegen moechten:~%")
				(format t "~S~%" (setf (nth working_tree tree_list) (insert (nth working_tree tree_list) (read))))
		)
		((eq a 8) (format t "Bitte geben sie einen Dateinamen an von dem sie die Werte in den Baum einfuegen moechten:~%")
				(format t "~S~%" (setf (nth working_tree tree_list) (insert_from_file (nth working_tree tree_list) (read))))
				(format t "---------------------------------------------~%")
		)
		((eq a 9) (format t "Bitte geben sie den Wert bei dem sie pruefen moechten ob er im Baum vorhanden ist:~%")
				(format t "~S~%" (contains (nth working_tree tree_list) (read)))
		)
		((eq a 10) (format t "~S~%" (getMin (nth working_tree tree_list))))
		((eq a 11) (format t "~S~%" (getMax (nth working_tree tree_list))))
		((eq a 12) (format t "Bitte geben sie den Wert ein den sie aus den Baum loeschen moechten:~%")
				(format t "~S~%" (setf (nth working_tree tree_list) (remove_val (nth working_tree tree_list) (read))))
		)
		((eq a 13) (format t "Bitte geben sie den Baum an, den sie in den aktuellen Baum einfuegen moechten:~%")
				(format t "~S~%" (setf (nth working_tree tree_list) (addAll (nth working_tree tree_list) (nth (read) tree_list))))
				(format t "---------------------------------------------~%")
		)
		((eq a 14) (format t "~S~%" (isEmpty (nth working_tree tree_list))))
		((eq a 15) (format t "Sie arbeiten im Moment auf dem ~S. Baum.~%" working_tree)
				(format t "Es gibt im Moment die Baeume:~%")
				(loop for i from 0 to (- (length tree_list) 1) do (format t "~S. Baum: ~S~%" i (nth i tree_list)))
				(format t "Bitte geben sie die Nummer des Baumes ein mit dem sie arbeiten moechten:~%")
				(format t "~S~%" (setf working_tree (read)))
				(format t "---------------------------------------------~%")
		)
		((eq a 16) (setf tree_list (append tree_list '(()))))
		((eq a 17) (format t "Es gibt im Moment die Baeume:~%")
				(loop for i from 0 to (- (length tree_list) 1) do (format t "~S. Baum: ~S~%" i (nth i tree_list)))
		)
		((eq a 18) (setf run nil))
    (t (format t "Ungueltige Eingabe. Es gibt keine Funktion mit dieser Nummer."))
	)
)
