;;; org-index.el --- Create org index list -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2025 Theia Ware
;;
;; Author: Theia Ware
;; Maintainer: Theia Ware
;; Created: November 23, 2025
;; Modified: November 23, 2025
;; Version: 0.1.0
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/msmushmoon/dotfiles
;; Package-Requires: ((emacs "30.1"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;  Create org index list of links and update it
;;
;; Things to come:
;; - TODO(msmushmoon): Extract link naming to central function
;; - TODO(msmushmoon): Add contents of #+DESCRIPTION: to link
;; - TODO(msmushmoon): Add ability to add/update index to arbiratry file
;; - TODO(msmushmoon): Add ability recursively add / update indices
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
  (save-excursion
    (goto-char (pos-bol))
    (insert
      "#+NAME: Index\n"
      (s-join "\n"
        (sort
          (nconc (org-index-other-indices default-directory)
            (org-index-link-list default-directory))))
      "\n\n"))
  (save-buffer))

(defun org-index-element ()
  (org-element-map
      (org-element-parse-buffer)
      'plain-list
    '(when (string= "Index"
                    (org-element-property :name node))
      node)
  nil
  t))

(defun org-index-delete ()
  (let ((node (org-index-element)))
  (delete-region
    (org-element-begin node)
    (org-element-end node))))

(defun org-index-update ()
  (interactive)
  (when-let* ((node (org-index-element))
              (index-loc (org-element-begin node)))
    (save-excursion
      (goto-char index-loc)
      (org-index-delete)
      (org-index-insert)))
  (save-buffer))


(provide 'org-index)
;;; org-index.el ends here
