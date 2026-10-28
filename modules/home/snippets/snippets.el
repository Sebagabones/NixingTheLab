;;; snippets.el --- Collection of yasnippet snippets
;;; Code:
;; Yoinked from https://discourse.nixos.org/t/package-my-emacs-snippets/21874/10

(require 'yasnippet)

;; Points to the current directory
(defconst snippets-dir
  (expand-file-name
   "snippets"
   (file-name-directory
    ;; Copied from  ‘f-this-file’ from f.el.
    (cond
     (load-in-progress load-file-name)
     ((and (boundp 'byte-compile-current-file) byte-compile-current-file)
      byte-compile-current-file)
     (:else (buffer-file-name))))))

;;;###autoload
(defun snippets-initialize ()
  "Load the `snippets' snippets directory."
  ;; NOTE: we add the symbol `snippets-dir' rather than its
  ;; value, so that yasnippet will automatically find the directory
  ;; after this package is updated (i.e., moves directory).
  (add-to-list 'yas-snippet-dirs 'snippets-dir t)
  (yas--load-snippet-dirs))

;;;###autoload
(eval-after-load 'yasnippet
  '(snippets-initialize))


(provide 'snippets)
