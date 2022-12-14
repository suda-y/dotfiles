;;; early-init.el --            -*- coding: utf-8; lexical-binding: t -*-
;; Author: suda <suda-y@yamashita-denki.co.jp>
;; URL:
;; Version: 1.00

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

;;; Code:

;; init処理中に問題があれば気を付けるように
(setq debug-on-error t)
(setq init-file-debug t)

;; splash screen を無効にする
(setq inhibit-splash-screen t)
(setq gc-cons-threshold most-positive-fixnum)

;; ツールバーを表示しない
(tool-bar-mode 0)
;; スクロールバーは保留
; (set-scroll-bar-mode nil)

;; native-compのワーニング抑制
;; (custom-set-variables '(warning-suppress-types '((comp))))
;; カスタムファイル
(custom-set-variables '(custom-file (expand-file-name "custom.el" user-emacs-directory)))

(provide 'early-init)
;; early-init.el ends here
