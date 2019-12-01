;; Melpa settings
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'package)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

;; org configuration file
(org-babel-load-file (expand-file-name "~/.emacs.d/myinit.org"))

;; Org bullets
(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (naysayer)))
 '(custom-safe-themes
   (quote
	("51f3ee2698cd86b25bfde000ab606f1ba0cd4b452ea2895a7b9a57a9c42750b7" default)))
 '(package-selected-packages
   (quote
	(org-bullets aggressive-indent htmlize company-irony irony web-mode smart-tabs-mode projectile hungry-delete beacon emmet-mode counsel auto-package-update use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
