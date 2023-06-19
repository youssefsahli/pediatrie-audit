#lang br/quicklang

(require json
         racket/pretty
         json/format/simple)

(provide (rename-out [module-begin #%module-begin])
         cfg
         topic
         title
         checkbox-label
         line-edit-label)

(define-syntax-rule
  (module-begin stx)
  (#%module-begin stx))

; cfg . expr ::= jsexpr -> jsexpr
(define (cfg . expr)
  (with-output-to-file "out.json"
    (λ ()
      (if (jsexpr? expr)
        (write-json expr)
        (begin
          (pretty-display expr (current-error-port))
          (error "not a jsexpr"))))
    #:exists 'replace))

; topic ::= String . jsexpr -> jsexpr
(define (topic str . expr)
  (list "topic" str expr))

; title ::= String . jsexpr -> jsexpr
(define (title str . expr)
  (list "title" str expr))

; checkbox-label ::= jsexpr -> jsexpr
(define (checkbox-label str)
  (list "cb" str))

; line-edit-label ::= String -> jsexpr
(define (line-edit-label str)
  (list "le" str))