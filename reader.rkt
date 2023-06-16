#lang racket

(provide read-syntax)

(require brag/support
         "lexer.rkt"
         "parser.rkt")

(define (read-syntax path port)
  (define parse-tree
    (parse path (make-tokenizer port)))
  (define module-datum `(module cfg-mod pedia/expander
                          ,parse-tree))
  (datum->syntax #f module-datum))