(require 'cl)
(defvar *emacs-load-start* (current-time))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

(require 'color-theme)
(load "~/.color-theme-tango.el")
(color-theme-tango)

;; line numbers mode
(require 'linum)
(global-linum-mode 1)
(setq linum-format "%d ")

(require 'git)
(require 'git-blame)
(require 'vc-git)


(require 'tramp)
(setq tramp-chunksize 500)
(setq tramp-default-method "scp")

(require 'ido)
(ido-mode t)

;; I hate tabs!
(setq c-basic-indent 2)
(setq tab-width 4)
(setq indent-tabs-mode nil)

(setq
 time-stamp-active t
 time-stamp-line-limit 10
 time-stamp-format "%04y%02m%02d%02H%02M%02S")


;;CSS mode
(autoload 'css-mode "css-mode")
(add-to-list 'auto-mode-alist '("\\.css\\'" . css-mode))
(setq cssm-indent-function #'cssm-c-style-indenter)
(setq cssm-indent-level '2)

;; PHP mode
(autoload 'php-mode "php-mode" "PHP editing mode" t)
(add-to-list 'auto-mode-alist '("\\.php\\'" . php-mode))
(add-to-list 'auto-mode-alist '("\\.php5\\'" . php-mode))
(add-to-list 'auto-mode-alist '("\\.php4\\'" . php-mode))
(add-to-list 'auto-mode-alist '("\\.php3\\'" . php-mode))
(add-hook 'php-mode-user-hook 'turn-on-font-lock)

;; Ruby mode tweaks
(autoload 'ruby-mode "ruby-mode" "Major mode for editing ruby scripts" t)
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rhtml$" . html-mode))
(add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))

(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby" "Set local key defs for inf-ruby in ruby-mode")

(add-hook 'ruby-mode-hook
	  (lambda()
	    (add-hook 'local-write-file-hooks
		      '(lambda()
			 (save-excursion
			   (untabify (point-min) (point-max))
			   (delete-trailing-whitespace)
			   )))
	    (set (make-local-variable 'indent-tabs-mode) 'nil)
	    (set (make-local-variable 'tab-width) 4)
	    (imenu-add-to-menubar "IMENU")
	    (define-key ruby-mode-map "\C-m" 'newline-and-indent) ;Not sure if this line is 100% right!
	    (require 'ruby-electric);
	    (ruby-electric-mode t)
	    ))

;;HTML deluxe mode
;;TODO: Properly configure
(require 'mmm-mode)
(setq mmm-global-mode 'maybe)
(mmm-add-group
     'fancy-html
     '(
             (html-php-tagged
                    :submode php-mode
                    :face mmm-code-submode-face
                    :front "<[?]php"
                    :back "[?]>")
             (html-css-attribute
                    :submode css-mode
                    :face mmm-declaration-submode-face
                    :front "styleREMOVEME=\""
                    :back "\"")))



;; LUA mode
(autoload 'lua-mode "lua-mode" "Lua editing mode" t)
(add-to-list 'auto-mode-alist '("\\.lua\\'" . lua-mode))

;;Haskell mode
(load "/usr/share/emacs23/site-lisp/haskell-mode/haskell-site-file")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

;; clojure-mode
(add-to-list 'load-path "~/opt/clojure-mode")
(autoload 'clojure-mode "clojure-mode" nil t) 
;;(require 'clojure-mode)

(defun clojure-slime-config  ()
  (autoload 'swank-clojure-init "swank-clojure") 
  (autoload 'swank-clojure-slime-mode-hook "swank-clojure")
  (autoload 'swank-clojure-cmd "swank-clojure") 
  (autoload 'swank-clojure-project "swank-clojure")
  (add-to-list 'load-path "~/opt/swank-clojure")
 
  (setq swank-clojure-classpath (list
				 "~/.clojure/clojure.jar"
				 "~/opt/swank-clojure/src"				 
				 "~/.clojure/clojure-contrib.jar"))
  (eval-after-load "slime" 
    '(progn 
       (require 'swank-clojure)
       (setq slime-net-coding-system 'utf-8-unix)
       (setq slime-lisp-implementations
	     (cons `(clojure ,(swank-clojure-cmd) :init swank-clojure-init) 
		   (remove-if #'(lambda (x) (eq (car x) 'clojure)) slime-lisp-implementations)))
       (remove-if #'(lambda(x) (equal (car x) "sbcl")) slime-lisp-implementations)
       (slime-setup '(slime-repl)))))

(defun sbcl-slime-config ()
  (eval-after-load 'slime
    '(progn
       (add-to-list 'slime-lisp-implementations
		    '(sbcl ("/usr/bin/sbcl")))
       (slime-setup '(
                    slime-asdf
                    slime-autodoc
                    slime-editing-commands
                    slime-fancy-inspector
                    slime-fontifying-fu
                    slime-fuzzy
                    slime-indentation
                    slime-mdot-fu
                    slime-package-fu
                    slime-references
                    slime-repl
                    slime-sbcl-exts
                    slime-scratch
                    slime-xref-browser
                    ))
       (slime-autodoc-mode)
       (setq slime-complete-symbol*-fancy t)
       (setq slime-complete-symbol-function 'slime-fuzzy-complete-symbol))))

;; swank-clojure
;; it took me 1 week to find out that I needed these two lines
(add-to-list 'load-path "~/opt/swank-clojure/")
(autoload 'swank-clojure-slime-mode-hook "swank-clojure")

;; the following is for the case in which slime-connect is used
(eval-after-load "slime" 
  '(progn 
     (setq slime-net-coding-system 'utf-8-unix)
     (slime-setup '(slime-repl))))

(require 'slime)
(slime-setup)

(defun pre-slime-clojure ()
  "Stuff to do before SLIME runs"
  (clojure-slime-config)
  (slime-setup))

(defun pre-slime-sbcl ()
  "Stuff to do before SLIME runs"
  (sbcl-slime-config)
  (slime-setup))

(defun run-clojure ()
  "Starts clojure in Slime"
  (interactive)
  (pre-slime-clojure)
  (slime 'clojure))

(defun run-sbcl ()
  "Starts SBCL in Slime"
  (interactive)
  (pre-slime-sbcl)
  (slime 'sbcl)) 

;; for browsing through the hyperspec
(setq browse-url-browser-function 'w3m-browse-url-other-window)
(require 'w3m-load)

(defun w3m-browse-url-other-window (url &optional newwin) 
  (interactive
   (browse-url-interactive-arg "w3m URL: "))
  (let ((pop-up-frames nil))
    (switch-to-buffer-other-window 
     (w3m-get-buffer-create "*w3m*"))
    (w3m-browse-url url)))


(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ecb-layout-name "left13")
 '(ecb-layout-window-sizes (quote (("left13" (ecb-directories-buffer-name 0.25396825396825395 . 0.98)))))
 '(ecb-options-version "2.40")
 '(ecb-primary-secondary-mouse-buttons (quote mouse-1--C-mouse-1))
 '(ecb-source-path (quote ("~/workspace")))
 '(ecb-tip-of-the-day nil)
 '(inhibit-startup-screen t))
(message "My .emacs loaded in %ds" (destructuring-bind (hi lo ms) (current-time)
                           (- (+ hi lo) (+ (first *emacs-load-start*) (second *emacs-load-start*)))))
