(define-library (request rest)
  (import (otus lisp))
  (import (cmd command))
  (import (parsers parsers))

  (export 
   GET
   build-url
   build-params
   build-params-header)

  (begin 
   
   (define CURL (get-environment-variable "CURL_DIR"))  
   
   (define (quotes what)
    (string-append "\"" what "\""))


   (define (build-params params)
     (print (length params))
     (if (> (length params) 0)
         (let* ((body (fold
                       (lambda (state a)
                         (if (= 2 (length a))
                             (if (= 0 (string-length state))
                                 (string-append (quotes (car a)) ": " (quotes (car (cdr a))))
                                 (string-append state "," (quotes (car a)) ": " (quotes (car (cdr a)))))
                             state)) "" params))
                (body-brackets (string-append "'{" body "}'")))
           (print body)
           body-brackets)
         "'{}'"))

  (define (build-params-header params)
     (if (> (length params) 0)
         (let* ((body (fold
                      (lambda (state a)
                        (if (= 2 (length a))
                            (if (= 0 (string-length state))
                                (string-append (car a) "=" (car (cdr a)))
                                (string-append state "&" (car a) "=" (car (cdr a))))
                            state))
                       "" params))
                (body-query (string-append "?" body)))
           body-query)
         ""))

  (define (build-url url params)
    (string-append url (build-params-header params)))

    (define (build-command method address params)
      (let ((headers (get params 'headers #f))
            (data (get params 'data #f)))
        (list "curl" "-s" "-X" method address (if headers "-H" "") (if headers headers "")
          (if data "--data" "") (if data data ""))
       ))

    (define GET
      (case-lambda 
        ((address params)
          (let* ((prepared-command (build-command "GET" address params))
                 (result (make-cmd CURL prepared-command parse-string)))
          result
           ))
        ((address params parser)
          (let* ((prepared-command (build-command "GET" address params))
                 (result (make-cmd CURL prepared-command parser)))
            result
          ))
      )
      )
  )
 )
