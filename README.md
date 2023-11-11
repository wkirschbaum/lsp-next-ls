# NextLS client for lsp-mode

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

## Installation

```elisp
(use-package lsp-mode
  :ensure t
  :hook ((elixir-ts-mode . lsp-deferred)
         (heex-ts-mode . lsp-deferred)
         (elixir-mode . lsp-deferred))
  :commands (lsp lsp-deferred)
  :config
  (load "~/[path to repo]/lsp-next-ls.el"))
```

Install the server by running `M-x lsp-install-server` and choose
`next-ls`.

To update the next-ls version you can run `M-x customize-group`
and select `lsp-next-ls`.  After updating the version ensure to re-run
the server installation command.

It is also possible to set the binary path or the download link via the
customization group.
