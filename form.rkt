#lang racket

(provide GuiApp%)

(require racket/gui)

(define GuiApp%
  (class object%
    (super-new)

    (define/public (get-current-topic)
      (send topic-tabs get-selection))

    (define/public (get-topic-name idx)
      (send topic-tabs get-item-label idx))
    
    (define frame
      (new frame%
           [label "Pédiatrie: Résultats Audit"]
           [width 500]
           [height 500]))

    (define/public (get-frame) frame)

    (define vbox
      (new vertical-panel%
           [parent frame]))

    (define/public (get-vbox) vbox)
    
    (define topic-tabs
      (new tab-panel%
           [parent vbox]
           [callback (λ (o ce)
                       (let* ([idx (get-current-topic)]
                              [topic (get-topic-name idx)])
                         (topic-tab-changed topic)))]
                         
           [choices '()]))

    (define hash-panels (make-hash))

    (define/public (get-hash-panels)
      hash-panels)

    (define/public (get-topic-panel topic)
      (hash-ref hash-panels topic #f))

    (define/public (get-current-panel)
      (let ([N (get-topic-name (get-current-topic))])
        (hash-ref hash-panels N)))

    (define/public (show [visible #t])
      (send frame show visible))

    (define/public (set-topics lot)
      (send topic-tabs set lot))

    (define/public (add-topic str)
      (send topic-tabs append str)
      (add-panel str))

    (define/public (add-panel key)
      (define P (new vertical-panel%
                     [parent vbox]))
      (hash-set! hash-panels key P)
      P)

    (define/public (topic-tab-changed topic)
      (println topic)
      (send topic-tabs change-children
            (hash-ref hash-panels topic)))

    (define/public (add-title title [panel #f])
      (let ([target (or panel (get-current-panel))])
        (new group-box-panel%
             [label title]
             [parent panel])))
        
    ))