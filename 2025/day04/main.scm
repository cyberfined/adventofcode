#! /usr/bin/env chez --script

(define-record-type point (fields x y))

(define (point<? a b)
  (or (< (point-x a) (point-x b))
      (and (= (point-x a) (point-x b))
	   (< (point-y a) (point-y b)))))

(define (point+ a b)
  (make-point
   (+ (point-x a) (point-x b))
   (+ (point-y a) (point-y b))))

(define-record-type grid (fields str width))

(define (grid-idx grid p)
  (let ([x (point-x p)]
	[y (point-y p)])
    (let ([idx (+ (* (+ 1 (grid-width grid)) y) x)])
      (if (or (< x 0)
	      (>= x (grid-width grid))
	      (< y 0)
	      (>= idx (string-length (grid-str grid))))
	  #f
	  idx))))

(define (grid-ref grid p)
  (let ([idx (grid-idx grid p)])
    (if idx
	(string-ref (grid-str grid) idx)
	#f)))

(define (grid-set! grid p v)
  (let ([idx (grid-idx grid p)])
    (if idx
	(string-set! (grid-str grid) idx v))))

(define (grid-copy grid)
  (make-grid (string-copy (grid-str grid)) (grid-width grid)))

(define (insert-ordered lt v xs)
  (let loop ([xs xs])
    (cond
     [(or (null? xs) (lt v (car xs))) (cons v xs)]
     [(and (not (null? xs)) (equal? (car xs) v)) xs]
     [else
      (let ([rest (loop (cdr xs))])
	(cons (car xs) rest))])))

(define (append-ordered lt xs ys)
  (if (null? xs)
      ys
      (append-ordered lt (cdr xs) (insert-ordered lt (car xs) ys))))

(define (get-neigh-rolls grid p)
  (let* ([neigh-dirs '((-1 . 0) (1 . 0) (0 . -1) (0 . 1)
		       (-1 . -1) (1 . -1) (1 . 1) (-1 . 1))]
	 [add-dir (lambda (d) (point+ (make-point (car d) (cdr d)) p))]
	 [neigh-coords (map add-dir neigh-dirs)]
	 [roll? (lambda (p)
		  (let ([neigh (grid-ref grid p)])
		    (and neigh (char-ci=? neigh #\@))))])
    (filter roll? neigh-coords)))

(define (loop-y grid mod-grid? y count)
  (if (not (grid-ref grid (make-point 0 y)))
      count
      (let ([zipy (lambda (x) (make-point x y))]
	    [xs (iota (grid-width grid))])
	(let* ([visit (map zipy xs)]
	       [count* (loop-x grid mod-grid? visit count)])
	  (loop-y grid mod-grid? (+ 1 y) count*)))))

(define (loop-x grid mod-grid? visit count)
  (let iter-x ([visit visit] [next-visit '()] [count count])
    (cond
     [(null? visit)
      (if (null? next-visit)
	  count
	  (iter-x next-visit '() count))]
     [(not (char-ci=? (grid-ref grid (car visit)) #\@))
      (iter-x (cdr visit) next-visit count)]
     [else
      (let ([neigh-rolls (get-neigh-rolls grid (car visit))])
	(if (>= (length neigh-rolls) 4)
	    (iter-x (cdr visit) next-visit count)
	    (let ([next-visit*
		   (if mod-grid?
		       (append-ordered point<? neigh-rolls next-visit)
		       '())])
	      (when mod-grid?
		(grid-set! grid (car visit) #\.))
	      (iter-x (cdr visit) next-visit* (+ 1 count)))))])))

(define (solution-1 grid)
  (loop-y grid #f 0 0))

(define (solution-2 grid)
  (loop-y grid #t 0 0))

(define (line-length str)
  (let loop ([i 0])
    (if (or (= i (string-length str))
	    (char-ci=? (string-ref str i) #\newline))
	i
	(loop (+ 1 i)))))

(define (read-input filename)
  (call-with-port
   (open-input-file filename)
   (lambda (ip)
     (let* ([str (get-string-all ip)]
	    [width (line-length str)])
       (make-grid str width)))))

(let ([grid (read-input "input")])
  (let ([res-1 (solution-1 (grid-copy grid))]
	[res-2 (solution-2 (grid-copy grid))])
    (printf "solution 1: ~a\n" res-1)
    (printf "solution 2: ~a\n" res-2)))
