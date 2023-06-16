#lang racket

(provide make-tokenizer)

(require brag/support)

(define (make-tokenizer ip)
  (port-count-lines! ip)
  (define trim string-trim)
  (define (next-token)
    (define cfg-lexer
      (lexer-src-pos
       [(from/to "[" "]")
        (token 'TITLE (trim (trim-ends "[" lexeme "]")))]
       [(from/to "//" "\n")
        (token 'TOPIC (trim (trim-ends "//" lexeme "\n")))]
       [whitespace
        (token 'WHITESPACE lexeme #:skip? #t)]
       [(repetition 1 +inf.0 (:~ "\n"))
        (let ([lex (trim lexeme)])
          (if (string-suffix? lex ":")
              (token 'LINE-EDIT-LABEL lex)
              (token 'CHECKBOX-LABEL lex)))]))
    (cfg-lexer ip))
  next-token)

