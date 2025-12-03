#! /usr/bin/env chez --script

(define (process-input filename f ini)
  (call-with-port (open-input-file filename)
    (lambda (ip)
      (let loop ([acc ini])
	(let ([line (get-line ip)])
	  (if (eof-object? line)
	      acc
	      (loop (f acc line))))))))

(define (max-joltage-pow i n bank)
  (if (= 0 n)
      (values 0 1)
      (let loop ([i i] [f #f])
	(if (> i (- (string-length bank) n))
	    (let-values ([(rest pow) (max-joltage-pow (+ 1 f) (- n 1) bank)])
	      (let ([digit (* (char- (string-ref bank f) #\0) pow)])
		(values (+ digit rest) (* 10 pow))))
	    (if (or (not f) (char-ci>? (string-ref bank i) (string-ref bank f)))
		(loop (+ 1 i) i)
		(loop (+ 1 i) f))))))

(define (max-joltage-1 bank)
  (let-values ([(res pow) (max-joltage-pow 0 2 bank)])
    res))

(define (max-joltage-2 bank)
  (let-values ([(res pow) (max-joltage-pow 0 12 bank)])
    res))

(define (solution filename f)
  (let ([it (lambda (sum line) (+ sum (f line)))])
    (process-input filename it 0)))

(let ([filename "input"])
  (let ([res-1 (solution filename max-joltage-1)]
	[res-2 (solution filename max-joltage-2)])
    (printf "solution 1: ~a\n" res-1)
    (printf "solution 2: ~a\n" res-2)))
