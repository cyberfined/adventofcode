#! /usr/bin/env chez --script

(define (split-string-by-char str chr)
  (let loop ([s 0] [e 0] [toks '()])
    (if (= e (string-length str))
      (if (or (not (= s e)) (null? toks))
        (cons (substring str s e) toks)
        toks)
      (if (char-ci=? (string-ref str e) chr)
        (let ([new-toks (cons (substring str s e) toks)]
              [next-idx (+ 1 e)])
          (loop next-idx next-idx new-toks))
        (loop s (+ 1 e) toks)))))

(define (strip-string str chars)
  (letrec ([loop (lambda (str i s)
                   (cond
                     [(= i (string-length str)) i]
                     [(< i 0) (+ 1 i)]
                     [(member (string-ref str i) chars) (loop str (+ i s) s)]
                     [else i]))])
    (let* ([from (loop str 0 1)]
           [lstrip (substring str from (string-length str))])
      (let ([to (+ 1 (loop lstrip (- (string-length lstrip) 1) -1))])
        (substring lstrip 0 to)))))

(define (read-input filename)
  (call-with-port
    (open-input-file filename)
    (lambda (ip)
      (let* ([content (strip-string (get-string-all ip) (string->list " \n"))]
             [ranges (split-string-by-char content #\,)])
        (let ([go (lambda (x)
                    (let* ([toks (split-string-by-char x #\-)]
                           [from (string->number (cadr toks))]
                           [to (string->number (car toks))])
                      (cons from to)))])
          (map go ranges))))))

(define (all? pred xs)
  (if (null? xs)
    #t
    (if (pred (car xs))
      (all? pred (cdr xs))
      #f)))

(define (string->chunks str len)
  (let loop ([i 0] [chunks '()])
    (if (>= i (string-length str))
      chunks
      (let* ([to (min (string-length str) (+ i len))]
             [chunk (substring str i to)])
        (loop to (cons chunk chunks))))))

(define (invalid-in-range-1 start end)
  (let ([pow (if (< start 10) 0 (flonum->fixnum (log start 10)))])
    (let loop ([sum 0] [pow pow] [start start])
      (if (> start end)
        sum
        (let ([start-str (number->string start)])
          (let-values ([(half-len rem) (div-and-mod (string-length start-str) 2)])
            (if (not (= rem 0))
              (let ([next-pow (+ 1 pow)])
                (loop sum next-pow (expt 10 next-pow)))
              (let ([first-half (substring start-str 0 half-len)]
                    [second-half (substring start-str half-len (string-length start-str))])
                (if (string-ci=? first-half second-half)
                  (loop (+ start sum) pow (+ 1 start))
                  (loop sum pow (+ 1 start)))))))))))

(define (invalid-2 str)
  (let loop ([f 0] [t 1])
    (if (= t (string-length str))
      #f
      (let ([sub (substring str f t)]
            [half-len (div (string-length str) 2)])
        (cond
          [(> (string-length sub) half-len) #f]
          [(not (= (mod (string-length str) (string-length sub)) 0)) (loop f (+ 1 t))]
          [else
            (let ([chunks (string->chunks str (string-length sub))])
              (if (all? (lambda (c) (string-ci=? c sub)) chunks)
                #t
                (loop f (+ 1 t))))])))))

(define (invalid-in-range-2 start end)
  (let loop ([i start] [sum 0])
    (cond
      [(> i end) sum]
      [(invalid-2 (number->string i)) (loop (+ 1 i) (+ i sum))]
      [else (loop (+ 1 i) sum)])))

(define (solution f ranges)
  (let loop ([xs ranges] [res 0])
    (if (null? xs)
      res
      (let ([range (car xs)]
            [rest (cdr xs)])
        (loop rest (+ res (f (car range) (cdr range))))))))

(let ([ranges (read-input "input")])
  (let ([res-1 (solution invalid-in-range-1 ranges)]
        [res-2 (solution invalid-in-range-2 ranges)])
    (printf "solution 1: ~a\n" res-1)
    (printf "solution 2: ~a\n" res-2)))
