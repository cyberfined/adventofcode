#! /usr/bin/env chez --script

(define (process-input filename handler ini)
  (call-with-port
    (open-input-file filename)
    (lambda (ip)
      (letrec ([run (lambda (acc)
                      (let ([line (get-line ip)])
                        (if (eof-object? line)
                          acc
                          (let* ([count-str (substring line 1 (string-length line))]
                                 [count (string->number  count-str)]
                                 [dir (if (char=? (string-ref line 0) #\L) 'left 'right)]
                                 [step (cons dir count)])
                            (run (handler acc step))))))])
        (run ini)))))

(define (solution1 acc step)
  (let* ([dir (car step)]
         [count (cdr step)]
         [pos (car acc)]
         [res (cdr acc)]
         [diff (+ pos (if (eq? dir 'left) (- count) count))]
         [new-pos (mod diff 100)])
    (if (= new-pos 0)
      (cons new-pos (+ 1 res))
      (cons new-pos res))))

(define (solution2 acc step)
  (let* ([dir (car step)]
         [count (cdr step)]
         [pos (car acc)]
         [res (cdr acc)]
         [diff (+ pos (if (eq? dir 'left) (- count) count))]
         [new-pos (mod diff 100)]
         [res-diff (if (eq? dir 'left)
                     (+ (div count 100) (if (and (not (= 0 pos)) (>= (mod count 100) pos)) 1 0))
                     (+ (div count 100) (if (>= (mod count 100) (- 100 pos)) 1 0)))]
         [new-res (+ res res-diff)])
    (cons new-pos new-res)))

(let* ([ini (cons 50 0)]
       [res1 (cdr (process-input "input" solution1 ini))]
       [res2 (cdr (process-input "input" solution2 ini))])
  (printf "solution 1: ~s\n" res1)
  (printf "solution 2: ~s\n" res2))
