;;; lsp-next-ls.el --- NextLS client for lsp-mode -*- lexical-binding: t; -*-

;; Copyright (C) 2023 Wilhelm H Kirschbaum

;; Author           : Wilhelm H Kirschbaum
;; Version          : 1.0
;; URL              : https://github.com/wkirschbaum/lsp-next-ls
;; Package-Requires : ((emacs "29.1") (lsp-mode "8.0.1"))
;; Created          : November 2023
;; Keywords         : elixir languages

;;  This program is free software: you can redistribute it and/or modify
;;  it under the terms of the GNU General Public License as published by
;;  the Free Software Foundation, either version 3 of the License, or
;;  (at your option) any later version.

;;  This program is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;  GNU General Public License for more details.

;;  You should have received a copy of the GNU General Public License
;;  along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; LSP Client for the Elixir NextLS language server.

;;; Code:

(require 'lsp-mode)

(defgroup lsp-next-ls nil
  "Settings for NextLS."
  :group 'lsp-mode
  :link '(url-link "https://github.com/elixir-tools/next-ls"))

(defcustom lsp-next-ls-binary-name
  (pcase system-type
    ('gnu/linux "next_ls_linux_amd64")
    ('darwin (if (string-match "^aarch64-.*" system-configuration)
                 "next_ls_darwin_arm64"
                "next_ls_darwin_amd64"))
    ('windows-nt "next_ls_windows_amd64.exe"))
  "The binary name for next-ls."
  :type 'string
  :group 'lsp-next-ls
  :package-version '(lsp-mode . "8.0.1"))

(defcustom lsp-next-ls-command
  `(,(f-join lsp-server-install-dir "next_ls"
             lsp-next-ls-binary-name)
    "--stdio=true")
  "The command that starts next-ls."
  :type '(repeat :tag "List of string values" string)
  :group 'lsp-next-ls
  :package-version '(lsp-mode . "8.0.1"))

(defcustom lsp-next-ls-version "0.15.0"
  "NextLS language server version to download.
It has to be set before `lsp-next-ls.el' is loaded and it has to
be available here: https://github.com/elixir-tools/next-ls/releases."
  :type 'string
  :group 'lsp-next-ls)

(defcustom lsp-next-ls-download-url
  (format "https://github.com/elixir-tools/next-ls/releases/download/v%s/%s"
          lsp-next-ls-version
          lsp-next-ls-binary-name)
  "Automatic download url for `next-ls'."
  :type 'string
  :group 'lsp-next-ls
  :package-version '(lsp-mode . "8.0.1"))

(defcustom lsp-next-ls-binary-path
  (f-join lsp-server-install-dir "next_ls" lsp-next-ls-binary-name)
  "The path to the `next-ls' binary."
  :type 'file
  :group 'lsp-next-ls)

(lsp-dependency
 'next-ls
 `(:download :url lsp-next-ls-download-url
             :store-path lsp-next-ls-binary-path
             :set-executable? t))

(lsp-register-client
 (make-lsp-client
  :new-connection (lsp-stdio-connection
                   (lambda ()
                     `(,(or (executable-find
                             (cl-first lsp-next-ls-command))
                            (lsp-package-path 'next-ls))
                       ,@(cl-rest lsp-next-ls-command))))
  :activation-fn (lsp-activate-on "elixir")
  :priority 0
  :add-on? nil
  :multi-root t
  :server-id 'next-ls
  :download-server-fn
  (lambda (_client callback error-callback _update?)
    (lsp-package-ensure 'next-ls callback error-callback))))

(lsp-consistency-check lsp-next-ls)

(provide 'lsp-next-ls)

;;; lsp-next-ls.el ends here
