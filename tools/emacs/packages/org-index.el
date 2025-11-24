;;; org-index.el --- Create org index list -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2025 Theia Ware
;;
;; Author: Theia Ware
;; Maintainer: Theia Ware
;; Created: November 23, 2025
;; Modified: November 23, 2025
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/theia-jane/org-index
;; Package-Requires: ((emacs "29.1"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Create org index list
;;
;;; Code:

(defun org-index-link-list (dir)
  (mapcar
   (lambda (file)
   (format "- [[file:%s][%s]]"
           file
           (or (org-get-title file) file)))
     (seq-filter
      (lambda (x) (not (string-match-p "index.org" x)))
      (directory-files dir nil "^.*\.org"))))

(defun org-index-other-indices (dir)
  (mapcar
   (lambda (dir)
     (format "- [[file:%s][%s]]"
             (f-join dir "index.org")
             (or (org-get-title (f-join dir "index.org"))
                 (format "%s Index" dir))))
   (seq-filter
    #'f-dir?
    (directory-files dir nil "^[^.]"))))

(defun org-index-insert ()
  (interactive)
  (insert
   (s-join "\n"
           (sort
           (nconc (org-index-other-indices default-directory)
            (org-index-link-list default-directory))))))

(provide 'org-index)
;;; org-index.el ends here
