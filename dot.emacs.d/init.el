;;; init.el -- My init.el -*- coding: utf-8; lexical-binding: t -*-

;; Copyright (C) 2020  Naoya Yamashita

;; Author: Naoya Yamashita <conao3@gmail.com>

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Comentary:

;; My init.el

;;; Code:

;; this enables running method
;;	emacs -q -l =/.debug.emacs.d/{{pkg}}/init.el
(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
	  (expand-file-name
	   (file-name-directory (or load-file-name byte-compile-current-file))))))

(eval-and-compile
  (customize-set-variable
   'package-archives '(("org"   . "https://orgmode.org/elpa/")
		       ("melpa" . "https://melpa.org/packages/")
		       ("gnu"   . "https://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'lef)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
	:ensure t
	:init
	;; optional packages if you want use :bydra, :el-get, :blackout, ...
	(leaf hydra :ensure t)
	(leaf el-get: ensure t
	      :custom ((el-get-get-shallow-clone . t)))
	(leaf blackout :ensure t)

	:config
	;; initialize leaf-keywords
	(leaf-keywords-init)))

;; early-init.el の詠み込み
(leaf early-init
  :doc "emacs26以前はearly-init.elが使えないので手動で読み込む"
  :emacs< "27.1"
  :config
  (load (concat user-emacs-directory "early-init.el"))
  )

;;; ここにいっぱい設定を書く

;; leaf 用便利ツール
(leaf leaf
  :config
  (leaf leaf-convert :ensure t)
  (leaf leaf-tree
    :ensure t
    :custom ((imenu-list-size . 30)
	     (imenu-list-position . 'left))))
(leaf macrostep
  :ensure t
  :bind (("C-c e" . macrostep-expand)))

;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Kanji-code
;;;
(leaf coding-japanese
  :config
  (set-language-environment "japanese")
  (prefer-coding-system 'utf-8-unix)		; デフォルトの文字コード(UTF-8, 改行NL)
  (set-keyboard-coding-system 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-default-coding-systems 'utf-8)
  ;; ファイルのデフォルトの文字コード指定
  (set-default 'buffer-file-coding-system 'utf-8)
  )
;; ;; leimで「nn」を「ん」にする設定
;; (defvar quail-japanese-use-double-n "")


;; cus-edit.c
(leaf cus-edit
  :doc "tools for customizing Emacs and Lisp packages"
  :tag "builtin" "faces" "help"
  :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))

;; cus-start.c
(leaf cus-start
  :doc "define customization properties of builtins"
  :tag "builtin" "internal"
  :preface
  (defun c/redraw-frame nil
    (interactive)
    (redraw-frame))

  :bind (("M-ESC ESC" . c/redraw-frame))
  :custom '((user-full-name . "Yuji Suda")
	    (user-mail-address . "suda-y@yamashita-denki.co.jp")
	    ;; (user-login-name . "MSM1586")
	    (create-lockfiles . nil)
	    ;; (debug-on-error . t)	; early-init.el に移動
	    ;; (init-file-debug . t)
	    (frame-resize-pixelwise . t)
	    (enable-recursive-minibffers . t)
	    (history-length . 1000)
	    (history-delete-duplicates . t)
	    (scroll-preserve-screen-posistion . t)
	    (scroll-conservatively . 100)
	    (mouse-wheel-scroll-amount . '(1 ((control) . 5)))
	    (ring-bell-function . `ignore)
	    (text-quoting-sytle . `straight)
	    (truncate-lines . t)
	    ;; (use-dialog-box . nil)
	    ;; (use-file-dialog . nil)
	    ;; (menu-bar-mode . t)
	    ;; (tool-bar-mode . nil)
	    ;; startup 起動は静かに
	    (inhibit-startup-screen . t)
	    ;; (inhibit-startup-message . t)
	    (inhibit-startup-echo-area-message . t)
	    ;; (initial-scratch-message . nil)
	    (scroll-bar-mode . nil)
	    (indent-tabs-mode . nil))
  :config
  (defalias 'yes-or-no-p 'y-or-n-p)
  )

;; autorevert
(leaf autorevert
  :doc "revert buffers when files on disk change"
  :tag "builtin"
  :custom ((auto-revert-interval . 1))
  :global-minor-mode global-auto-revert-mode)

;; cc-mode
(leaf cc-mode
  :doc "major mode for editing C and similar languages"
  :tag "builtin"
  :defvar (c-basic-offset)
  :bind (c-mode-base-map
	 ("C-c C-c" . compile))
  :mode-hook
  (c-mode-hook . ((c-set-style "k&r")
		  (setq c-basic-offset 4)
		  (c-set-offset 'case-label '*)
		  (c-set-offset 'statement-case-intro '+)))
  (c++-mode-hook . ((c-set-style "bsd")
		    (setq c-basic-offset 4)))


  )

;; 対応する括弧を強調表示する
;; paren
(leaf paren
  :doc "highlight watching paren"
  :tag "builtin"
  :custom ((show-paren-delay . 0.1))
  :global-minor-mode show-paren-mode)

;; バックアップディレクトリの設定
;; files
(leaf files
 :doc "file input and output commands for Emacs"
 :tag "builtin"
 :custom `((auto-save-timeout . 15)
	   (auto-save-interval . 60)
           (auto-save-file-name-transforms . '((".*" ,(locate-user-emacs-file "backup/") t)))
           (backup-directory-alist . '((".*" . ,(locate-user-emacs-file "backup"))
                                       (,tramp-file-name-regexp . nil)))
	   (version-control . t)
	   (delete-old-versions . t))
 )

;; 自動保存されたファイルのリスト
;; startup
;;	.emacs.d/backup 以下にまとめて保存する
(leaf startup
  :doc "process Emacs shell arguments"
  :tag "builtin" "internal"
  :custom `((auto-save-list-file-prefix . ,(locate-user-emacs-file "backup/.saves-"))))

;; ;; flycheck
(leaf flycheck
  :doc "On-the-fly syntax checking"
  :req "dash-2.12.1" "pkg-info-0.4" "seq-1.11" "emacs-24.3"
  :tag "minor-mode " "tools" "languages" "convenience" "emacs>=24.3"
  :url "http://www.flycheck.org"
  :emacs>= 24.3
  :ensure t
  :bind (("M-n" . flycheck-next-error)
	 ("M-p" . flycheck-prev-error))
  :global-minor-mode global-flycheck-mode)


;; 日本語関連
(leaf cp5022x
  :ensure t
  :require t
  :config
  (set-charset-priority 'ascii 'japanese-jisx0208 'latin-jisx0201
			'katakana-jisx0201 'iso-8859-1 'unicode)
  (set-coding-system-priority 'utf-8 'euc-jp 'iso-2022-jp 'cp932)
  )

;; キーバインド設定
(leaf-keys (("C-h" . backward-delete-char)
	    ("C-c ;" . comment-region)
	    ("C-c M-;" . uncomment-region)
	    ("<home>" . beginning-of-buffer)
	    ("M-g" . goto-line)
	    ))

(setq quail-japanese-use-double-n t)

(provide 'init)

;; Local Variables:
;; indent-tabs-mode: t
;; End:

;; init.el ends here

