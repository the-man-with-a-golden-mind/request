(define *path* (cons "../"  *path*))

(import (owl parse))
(import (request rest))
(import (otus lisp))
(import (owl ff))
(import (parsers parsers))

(define test-rest-get
  (display "Testing REST GET without params...")
  (let* ((response (REST "GET" "https://dummyjson.com/products/1" #empty get-json)))
    (assert (> (size (car response)) 0) ===> #true)
    (display "ok \n")))

(define test-rest-get-with-query-string
  (display "Testing REST GET without params, with query string...")
  (let* ((url (build-url "https://dummyjson.com/products/search" (list (list "q" "Laptop"))))
         (response (REST "GET" url #empty get-json)))
    (assert (> (size (car response)) 0) ===> #true)
    (display "ok \n")))


(define test-build-params-header 
  (display "Testing budiling params for header...")
  (let* ((result (build-params-header (list (list "param1" "param1_1") (list "param2" "param2_2")))))
    (assert result ===> "?param1=param1_1&param2=param2_2")
    (display "ok \n")))


(define test-build-params 
  (display "Testing budiling params for header...")
  (let* ((result (build-params (list (list "param1" "param1_1") (list "param2" "param2_2")))))
    (assert result ===> "'{\"param1\": \"param1_1\",\"param2\": \"param2_2\"}'")
    (display "ok \n")))


(define tests 
 (list 
  test-rest-get
  test-build-params
  test-build-params-header
  test-rest-get-with-query-string))

(await (map (lambda (test) (async (lambda () test))) tests))
