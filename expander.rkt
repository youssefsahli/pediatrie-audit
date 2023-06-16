#lang br/quicklang

(require canvas-list
         racket/class
         racket/gui)

(provide (rename-out [module-begin #%module-begin])
         cfg
         topic
         title
         checkbox-label
         line-edit-label)

(define-syntax-rule
  (module-begin expr)
  (#%module-begin expr))

; Main Window
(define F
    (new frame%
         [width 500]
         [height 500]
         [label "Audit Window"]))

; Main Tab Bar
(define (tab-cb tp ev)
  (let*
      ([idx (send tp get-selection)]
       [iname (send tp get-item-label idx)]
       [vp (hash-ref H iname #f)]
       [childvp (send tp get-children)])

    (for ([vp childvp])
      (send vp reparent IW))
              
    (when vp
      (send vp reparent T))))

(define T
    (new tab-panel%
         [parent F]
         [choices '()]
         [callback tab-cb]))

; Panels Hash
(define H (make-hash))

; Invisible Window
(define IW
  (new frame%
       [label "Invisible"]))

; cfg ::= (List of vertical-panel%) -> frame%
(define (cfg . lo-vp)
  (send T set-selection 0)
  (tab-cb T #f)
  (send F show #t))

; topic ::= String (List of group-box%) -> #hash(String, vertical-panel%)
(define (topic str . lo-gp)
  (send T append str)
  
  (define VP
    (new vertical-panel%
         [stretchable-height #t]
         [stretchable-width #t]
         [style '(auto-hscroll auto-vscroll)]
         [parent IW]))
  
  (new message%
       [parent VP]
       [label str])
  
  (for ([gp lo-gp])
    (send gp reparent VP))
  
  (hash-set! H str VP)

  H)

; title ::= String (List of check-box%) -> group-box%
(define (title str . lo-cb)
  (define GP
    (new group-box-panel%
         [stretchable-width #f]
         [stretchable-height #f]
         [min-width 500]
         [min-height 150]
         [label ""]
         [parent IW]))

  (define EdCv (new editor-canvas%
                    [style '(transparent
                             no-border
                             auto-hscroll
                             auto-vscroll)]
                    [enabled #t]
                    [parent GP]
                    [editor (new text%)]))

  (send* (send EdCv get-editor)
    (insert str)
    (auto-wrap #t))
  
  (for ([cb lo-cb])
    (send cb reparent GP))
  GP)

; checkbox-label ::= String -> check-box%
(define (checkbox-label str)
  (new check-box%
       [parent IW]
       [label str]))

; line-edit-label ::= String -> line-edit%
(define (line-edit-label str)
  (new text-field%
       [stretchable-width #f]
       [label str]
       [parent IW]))