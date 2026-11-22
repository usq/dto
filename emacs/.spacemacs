;; -*- mode: emacs-lisp; lexical-binding: t -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.
(defun string-contains-p (needle haystack)
  (if (string-match-p (regexp-quote needle) haystack)
      t
    nil))

(defconst user-home-directory (expand-file-name "~/"))
(defconst MIMAS-NAME "mimas")
(defconst JUPITER-NAME "jupiter")
(defconst RHEA-NAME "rhea")
(defconst RHEA-CLANGD-LOCATION "/opt/homebrew/opt/llvm/bin/clangd")
(defconst MIMAS-CLANGD-LOCATION (concat user-home-directory "dev/clangd/bin/clangd"))
(defconst JUPITER-CLANGD-LOCATION "clangd")
(defconst DROPBOX-LOCATION "~/Library/CloudStorage/Dropbox/")

(defconst is-osx (string-contains-p "darwin" (symbol-name system-type)))
(defconst is-linux (string-contains-p "linux" (symbol-name system-type)))

(defun get-host-name ()
  (string-trim-right
   (shell-command-to-string (if is-osx
                                "scutil --get LocalHostName"
                              "hostname"))))

(defconst is-mimas (string-contains-p MIMAS-NAME (downcase (get-host-name))))
(defconst is-rhea (string-contains-p RHEA-NAME (downcase (get-host-name))))
(defconst is-jupiter (string-contains-p JUPITER-NAME (downcase (get-host-name))))

(defconst mc/dot-dir "~/dot/")
(defvar mc/monospaced-font "Iosevka Nerd Font Mono")
(defvar mc/monospaced-weight 'regular)
(defvar mc/monospaced-size (if is-rhea 14.0 13.0))
(defvar mc/clangd-bin-location (cond
                                (is-rhea RHEA-CLANGD-LOCATION)
                                (is-jupiter JUPITER-CLANGD-LOCATION)
                                (t MIMAS-CLANGD-LOCATION)))

(defun dotspacemacs/layers ()
  "Layer configuration:
This function should only modify configuration layer settings."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs

   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation nil

   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation nil

   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '("~/dot/layers/")

   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(rust
     json
     docker
     multiple-cursors
     (unicode-fonts :variables
                    unicode-fonts-enable-ligatures t)
     emacs-lisp
     (tree-sitter :variables
                  tree-sitter-fold-enable t
                  tree-sitter-fold-indicators-enable nil
                  )
     (git :variables
          git-link-use-commit t
          forge-add-default-bindings nil
          magit-repository-directories '(("~/.emacs.d" . 0))
          magit-log-margin '(t "%Y-%m-%d %H:%M " magit-log-margin-width t 18)
          evil-collection-magit-visit-worktree-file-on-return nil
          )

     (compleseus :variables
                 compleseus-use-nerd-icons t
                 )
     (html :variables
           css-enable-lsp t
           html-enable-lsp t)
     pdf
     (plantuml :variables
               plantuml-exec-mode 'executable
               plantuml-executable-path "/opt/homebrew/bin/plantuml"
               plantuml-default-exec-mode 'executable
               )
     (python :variables
             python-backend 'lsp)
     (shell :variables
            shell-default-shell 'ghostel
            shell-pop-autocd-to-working-dir nil
            shell-default-position 'bottom
            ;; eshell-aliases-file (concat mc/dot-dir "eshell_alias")
            )
     themes-megapack
     theming
     (treemacs :variables
               treemacs-use-follow-mode nil
               treemacs-text-scale -1
               )
     (osx :variables
          osx-command-as 'meta
          osx-right-command-as 'none
          osx-option-as 'none)

     (lsp :variables
          lsp-navigation 'peek
          lsp-clients-clangd-args '("-j=2" "--clang-tidy")
          lsp-clients-clangd-executable mc/clangd-bin-location

          lsp-java-java-path "/opt/homebrew/opt/java/bin/java "
          lsp-inlay-hint-enable t
          lsp-idle-delay 0.5
          )
     (auto-completion :variables
                      auto-completion-enable-snippets-in-popup t
                      auto-completion-use-company-box t
                      auto-completion-tab-key-behavior 'complete

                      :disabled-for
                      org
                      shell
                      git)
     ;; evil-snipe ; replaced by flash
     cmake
     yaml
     (c-c++ :variables
            c-c++-backend 'lsp-clangd
            c-c++-enable-google-style t
            c-c++-enable-clang-format-on-save t
            c-c++-adopt-subprojects t
            c-c++-default-mode-for-headers 'c++-mode
            clang-format-executable "/opt/homebrew/opt/llvm/bin/clang-format"
            )

     (org :variables
          org-capture-templates `(("c" "TODO" entry (file+headline ,(concat DROPBOX-LOCATION "org/inbox.org") "Tasks") "* TODO  %?\n  %i\n")
                                  ("r" "Rezept" entry (file+headline ,(concat DROPBOX-LOCATION "org/recipees.org") "Inbox") "* %?\n  %i\n")
                                  ("k" "Referenze" entry (file+headline ,(concat DROPBOX-LOCATION "org/store.org") "reference") "* %?\n  %i\n")
                                  ("f" "TODO in file" entry (file+headline ,(concat DROPBOX-LOCATION "org/inbox.org") "Tasks") "* TODO  %?\n  %i\n  %a"))
          org-agenda-files `(,(concat DROPBOX-LOCATION "org/inbox.org"))
          org-todo-keywords '(
                              (sequence "STARTED(s)" "TODO(t)" "WAITING(w@/!)" "SOMEDAY(.)" "|" "DONE(x)" "CANCELLED(c)")
                              (sequence "LEARN" "TRY" "|" "COMPLETE(x)"))
          org-babel-header-args:C++ '((:flags . "-std=c++17"))
          org-babel-python-command "python3"
          org-enable-appear-support t
          org-enable-org-brain-support t
          org-hide-emphasis-markers t
          org-hide-leading-stars t
          org-pretty-entities t
          org-startup-folded 'content
          org-want-todo-bindings t
          org-agenda-skip-scheduled-if-done t
          )

     spacemacs-org
     helpful
     )


   ;; List of additional packages that will be installed without being wrapped
   ;; in a layer (generally the packages are installed only and should still be
   ;; loaded using load/require/use-package in the user-config section below in
   ;; this file). If you need some configuration for these packages, then
   ;; consider creating a layer. You can also put the configuration in
   ;; `dotspacemacs/user-config'. To use a local version of a package, use the
   ;; `:location' property: '(your-package :location "~/path/to/your-package/")
   ;; Also include the dependencies as they will not be resolved automatically.
   dotspacemacs-additional-packages '(
                                      nix-ts-mode
                                      async
                                      helm
                                      flash
                                      ;; pylint
                                      atom-one-dark-theme
                                      plantuml-mode
                                      dockerfile-mode
                                      rainbow-mode
                                      transpose-frame
                                      vlf
                                      mixed-pitch
                                      rfc-mode
                                      json-navigator
                                      bazel
                                      memoize ;; used in mc-sort
                                      python-insert-docstring
                                      bazel
                                      highlight-doxygen
                                      )

   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()

   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '(
                                    helm-posframe
                                    helm-gitignore
                                    eshell-prompt-extras
                                    evil-escape
                                    evil-exchange
                                    emmet-mode
                                    )

   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and deletes any unused
   ;; packages as well as their unused dependencies. `used-but-keep-unused'
   ;; installs only the used packages but won't delete unused ones. `all'
   ;; installs *all* packages supported by Spacemacs and never uninstalls them.
   ;; (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization:
This function is called at the very beginning of Spacemacs startup,
before layer configuration.
It should only modify the values of Spacemacs settings."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; Maximum allowed time in seconds to contact an ELPA repository.
   ;; (default 5)
   dotspacemacs-elpa-timeout 5

   ;; Set `gc-cons-threshold' and `gc-cons-percentage' when startup finishes.
   ;; This is an advanced option and should not be changed unless you suspect
   ;; performance issues due to garbage collection operations.
   ;; (default '(100000000 0.1))
   dotspacemacs-gc-cons '(100000000 0.1)

   ;; Set `read-process-output-max' when startup finishes.
   ;; This defines how much data is read from a foreign process.
   ;; Setting this >= 1 MB should increase performance for lsp servers
   ;; in emacs 27.
   ;; (default (* 1024 1024))
   dotspacemacs-read-process-output-max (* 1024 1024)

   ;; If non-nil then Spacelpa repository is the primary source to install
   ;; a locked version of packages. If nil then Spacemacs will install the
   ;; latest version of packages from MELPA. Spacelpa is currently in
   ;; experimental state please use only for testing purposes.
   ;; (default nil)
   dotspacemacs-use-spacelpa nil

   ;; If non-nil then verify the signature for downloaded Spacelpa archives.
   ;; (default t)
   dotspacemacs-verify-spacelpa-archives t

   ;; If non-nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil

   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'. (default 'emacs-version)
   dotspacemacs-elpa-subdirectory 'emacs-version

   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style 'vim

   ;; If non-nil show the version string in the Spacemacs buffer. It will
   ;; appear as (spacemacs version)@(emacs version)
   ;; (default t)
   dotspacemacs-startup-buffer-show-version t

   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'official

   ;; Scale factor controls the scaling (size) of the startup banner. Default
   ;; value is `auto' for scaling the logo automatically to fit all buffer
   ;; contents, to a maximum of the full image height and a minimum of 3 line
   ;; heights. If set to a number (int or float) it is used as a constant
   ;; scaling factor for the default logo size.
   dotspacemacs-startup-banner-scale 'auto

   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `recents-by-project' `bookmarks' `projects' `agenda' `todos'.
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   ;; The exceptional case is `recents-by-project', where list-type must be a
   ;; pair of numbers, e.g. `(recents-by-project . (7 .  5))', where the first
   ;; number is the project limit and the second the limit on the recent files
   ;; within a project.
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))

   ;; True if the home buffer should respond to resize events. (default t)
   dotspacemacs-startup-buffer-responsive t

   ;; Show numbers before the startup list lines. (default t)
   dotspacemacs-show-startup-list-numbers t

   ;; The minimum delay in seconds between number key presses. (default 0.4)
   dotspacemacs-startup-buffer-multi-digit-delay 0.4

   ;; If non-nil, show file icons for entries and headings on Spacemacs home buffer.
   ;; This has no effect in terminal or if "nerd-icons" package or the font
   ;; is not installed. (default nil)
   dotspacemacs-startup-buffer-show-icons t

   ;; Default major mode for a new empty buffer. Possible values are mode
   ;; names such as `text-mode'; and `nil' to use Fundamental mode.
   ;; (default `text-mode')
   dotspacemacs-new-empty-buffer-major-mode 'text-mode

   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode

   ;; If non-nil, *scratch* buffer will be persistent. Things you write down in
   ;; *scratch* buffer will be saved and restored automatically.
   dotspacemacs-scratch-buffer-persistent t

   ;; If non-nil, `kill-buffer' on *scratch* buffer
   ;; will bury it instead of killing.
   dotspacemacs-scratch-buffer-unkillable t

   ;; Initial message in the scratch buffer, such as "Welcome to Spacemacs!"
   ;; (default nil)
   dotspacemacs-initial-scratch-message nil

   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press `SPC T n' to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(
                         doom-vibrant
                         doom-dracula
                         sanityinc-tomorrow-night
                         doom-palenight
                         atom-one-dark
                         spacemacs-light

                         doom-gruvbox
                         solarized-gruvbox-dark
                         doom-vibrant
                         doom-spacegrey
                         doom-one-light
                         doom-gruvbox-light
                         spacemacs-dark

                         ;; medium diff
                         doom-nord-light
                         ;; bad diff
                         doom-solarized-light
                         ;; unkown diff
                         doom-monokai-pro
                         doom-gruvbox-light

                         ;;backup themes
                         doom-snazzy
                         doom-zenburn
                         ;; doom-one-light
                         doom-nord
                         )

   ;; Set the theme for the Spaceline. Supported themes are `spacemacs',
   ;; `all-the-icons', `custom', `doom', `vim-powerline' and `vanilla'. The
   ;; first three are spaceline themes. `doom' is the doom-emacs mode-line.
   ;; `vanilla' is default Emacs mode-line. `custom' is a user defined themes,
   ;; refer to the DOCUMENTATION.org for more info on how to create your own
   ;; spaceline theme. Value can be a symbol or list with additional properties.
   ;; (default '(spacemacs :separator wave :separator-scale 1.5))
   dotspacemacs-mode-line-theme '(doom)
   ;; dotspacemacs-mode-line-theme '(spacemacs :separator wave :separator-scale 1.5)

   ;; If non-nil the cursor color matches the state color in GUI Emacs.
   ;; (default t)
   dotspacemacs-colorize-cursor-according-to-state t

   ;; Default font or prioritized list of fonts. The `:size' can be specified as
   ;; a non-negative integer (pixel size), or a floating-point (point size).
   ;; Point size is recommended, because it's device independent. (default 10.0)
   dotspacemacs-default-font `(
                               ,mc/monospaced-font
                               :weight ,mc/monospaced-weight
                               :size ,mc/monospaced-size
                               )

   ;; Default icons font, it can be `all-the-icons' or `nerd-icons'.
   dotspacemacs-default-icons-font 'all-the-icons

   ;; The leader key (default "SPC")
   dotspacemacs-leader-key "SPC"

   ;; The key used for Emacs commands `M-x' (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"

   ;; The key used for Vim Ex commands (default ":")
   dotspacemacs-ex-command-key ":"

   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"

   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","

   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m" for terminal mode, "M-<return>" for GUI mode).
   ;; Thus M-RET should work as leader key in both GUI and terminal modes.
   ;; C-M-m also should work in terminal mode, but not in GUI mode.
   dotspacemacs-major-mode-emacs-leader-key (if window-system "M-<return>" "C-M-m")

   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs `C-i', `TAB' and `C-m', `RET'.
   ;; Setting it to a non-nil value, allows for separate commands under `C-i'
   ;; and TAB or `C-m' and `RET'.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil

   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"

   ;; If non-nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil

   ;; If non-nil then the last auto saved layouts are resumed automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil

   ;; If non-nil, auto-generate layout name when creating new layouts. Only has
   ;; effect when using the "jump to layout by number" commands. (default nil)
   dotspacemacs-auto-generate-layout-names nil

   ;; Size (in MB) above which spacemacs will prompt to open the large file
   ;; literally to avoid performance issues. Opening a file literally means that
   ;; no major mode or minor modes are active. (default is 1)
   dotspacemacs-large-file-size 5

   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache

   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5

   ;; If non-nil, the paste transient-state is enabled. While enabled, after you
   ;; paste something, pressing `C-j' and `C-k' several times cycles through the
   ;; elements in the `kill-ring'. (default nil)
   dotspacemacs-enable-paste-transient-state t

   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4

   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; It is also possible to use a posframe with the following cons cell
   ;; `(posframe . position)' where position can be one of `center',
   ;; `top-center', `bottom-center', `top-left-corner', `top-right-corner',
   ;; `top-right-corner', `bottom-left-corner' or `bottom-right-corner'
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom

   ;; Control where `switch-to-buffer' displays the buffer. If nil,
   ;; `switch-to-buffer' displays the buffer in the current window even if
   ;; another same-purpose window is available. If non-nil, `switch-to-buffer'
   ;; displays the buffer in a same-purpose window even if the buffer can be
   ;; displayed in the current window. (default nil)
   dotspacemacs-switch-to-buffer-prefers-purpose nil

   ;; Make consecutive tab key presses after commands such as
   ;; `spacemacs/alternate-buffer' (SPC TAB) cycle through previous
   ;; buffers/windows/etc. Please see the option's docstring for more information.
   ;; Set the option to t in order to enable cycling for all current and
   ;; future cycling commands. Alternatively, choose a subset of the currently
   ;; supported commands: '(alternate-buffer alternate-window). (default nil)
   dotspacemacs-enable-cycling nil

   ;; Whether side windows (such as those created by treemacs or neotree)
   ;; are kept or minimized by `spacemacs/toggle-maximize-window' (SPC w m).
   ;; (default t)
   dotspacemacs-maximize-window-keep-side-windows t

   ;; If nil, no load-hints enabled. If t, enable the `load-hints' which will
   ;; put the most likely path on the top of `load-path' to reduce walking
   ;; through the whole `load-path'. It's an experimental feature to speedup
   ;; Spacemacs on Windows. Refer the FAQ.org "load-hints" session for details.
   dotspacemacs-enable-load-hints nil

   ;; If t, enable the `package-quickstart' feature to avoid full package
   ;; loading, otherwise no `package-quickstart' attemption (default nil).
   ;; Refer the FAQ.org "package-quickstart" section for details.
   dotspacemacs-enable-package-quickstart nil

   ;; If non-nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t

   ;; If non-nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil

   ;; If non-nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil

   ;; If non-nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil

   ;; If non-nil the frame is undecorated when Emacs starts up. Combine this
   ;; variable with `dotspacemacs-maximized-at-startup' to obtain fullscreen
   ;; without external boxes. Also disables the internal border. (default nil)
   dotspacemacs-undecorated-at-startup nil

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 97

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 97

   ;; If non-nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t

   ;; If non-nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t

   ;; If non-nil unicode symbols are displayed in the mode line.
   ;; If you use Emacs as a daemon and wants unicode characters only in GUI set
   ;; the value to quoted `display-graphic-p'. (default t)
   dotspacemacs-mode-line-unicode-symbols t

   ;; If non-nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t

   ;; Show the scroll bar while scrolling. The auto hide time can be configured
   ;; by setting this variable to a number. (default t)
   dotspacemacs-scroll-bar-while-scrolling nil

   ;; Control line numbers activation.
   ;; If set to `t', `relative' or `visual' then line numbers are enabled in all
   ;; `prog-mode' and `text-mode' derivatives. If set to `relative', line
   ;; numbers are relative. If set to `visual', line numbers are also relative,
   ;; but only visual lines are counted. For example, folded lines will not be
   ;; counted and wrapped lines are counted as multiple lines.
   ;; This variable can also be set to a property list for finer control:
   ;; '(:relative nil
   ;;   :visual nil
   ;;   :disabled-for-modes dired-mode
   ;;                       doc-view-mode
   ;;                       markdown-mode
   ;;                       org-mode
   ;;                       pdf-view-mode
   ;;                       text-mode
   ;;   :size-limit-kb 1000)
   ;; When used in a plist, `visual' takes precedence over `relative'.
   ;; (default nil)
   dotspacemacs-line-numbers 'relative

   ;; Code folding method. Possible values are `evil', `origami' and `vimish'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil

   ;; If non-nil and `dotspacemacs-activate-smartparens-mode' is also non-nil,
   ;; `smartparens-strict-mode' will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil

   ;; If non-nil smartparens-mode will be enabled in programming modes.
   ;; (default t)
   dotspacemacs-activate-smartparens-mode t

   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc...
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis nil

   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all

   ;; If non-nil, start an Emacs server if one is not already running.
   ;; (default nil)
   dotspacemacs-enable-server t

   ;; Set the emacs server socket location.
   ;; If nil, uses whatever the Emacs default is, otherwise a directory path
   ;; like \"~/.emacs.d/server\". It has no effect if
   ;; `dotspacemacs-enable-server' is nil.
   ;; (default nil)
   dotspacemacs-server-socket-dir nil

   ;; If non-nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil

   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `rg', `ag', `ack' and `grep'.
   ;; (default '("rg" "ag" "ack" "grep"))
   dotspacemacs-search-tools '("rg" "ag" "ack" "grep")

   ;; The backend used for undo/redo functionality. Possible values are
   ;; `undo-redo', `undo-fu' and `undo-tree' see also `evil-undo-system'.
   ;; Note that saved undo history does not get transferred when changing
   ;; your undo system from or to undo-tree. (default `undo-redo')"
   dotspacemacs-undo-system 'undo-redo

   ;; Format specification for setting the frame title.
   ;; %a - the `abbreviated-file-name', or `buffer-name'
   ;; %t - `projectile-project-name'
   ;; %I - `invocation-name'
   ;; %S - `system-name'
   ;; %U - contents of $USER
   ;; %b - buffer name
   ;; %f - visited file name
   ;; %F - frame name
   ;; %s - process status
   ;; %p - percent of buffer above top of window, or Top, Bot or All
   ;; %P - percent of buffer above bottom of window, perhaps plus Top, or Bot or All
   ;; %m - mode name
   ;; %n - Narrow if appropriate
   ;; %z - mnemonics of buffer, terminal, and keyboard coding systems
   ;; %Z - like %z, but including the end-of-line format
   ;; If nil then Spacemacs uses default `frame-title-format' to avoid
   ;; performance issues, instead of calculating the frame title by
   ;; `spacemacs/title-prepare' all the time.
   ;; (default "%I@%S")
   dotspacemacs-frame-title-format "%I - %t"

   ;; Format specification for setting the icon title format
   ;; (default nil - same as frame-title-format)
   dotspacemacs-icon-title-format nil

   ;; Color highlight trailing whitespace in all prog-mode and text-mode derived
   ;; modes such as c++-mode, python-mode, emacs-lisp, html-mode, rst-mode etc.
   ;; (default t)
   dotspacemacs-show-trailing-whitespace t

   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed' to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; The variable `global-spacemacs-whitespace-cleanup-modes' controls
   ;; which major modes have whitespace cleanup enabled or disabled
   ;; by default.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup nil

   ;; If non-nil activate `clean-aindent-mode' which tries to correct
   ;; virtual indentation of simple modes. This can interfere with mode specific
   ;; indent handling like has been reported for `go-mode'.
   ;; If it does deactivate it here.
   ;; (default t)
   dotspacemacs-use-clean-aindent-mode t

   ;; Accept SPC as y for prompts if non-nil. (default nil)
   dotspacemacs-use-SPC-as-y nil

   ;; If non-nil shift your number row to match the entered keyboard layout
   ;; (only in insert state). Currently supported keyboard layouts are:
   ;; `qwerty-us', `qwertz-de' and `querty-ca-fr'.
   ;; New layouts can be added in `spacemacs-editing' layer.
   ;; (default nil)
   dotspacemacs-swap-number-row nil

   ;; Either nil or a number of seconds. If non-nil zone out after the specified
   ;; number of seconds. (default nil)
   dotspacemacs-zone-out-when-idle nil

   ;; Run `spacemacs/prettify-org-buffer' when
   ;; visiting README.org files of Spacemacs.
   ;; (default nil)
   dotspacemacs-pretty-docs nil

   ;; If nil the home buffer shows the full path of agenda items
   ;; and todos. If non-nil only the file name is shown.
   dotspacemacs-home-shorten-agenda-source nil

   ;; If non-nil then byte-compile some of Spacemacs files.
   dotspacemacs-byte-compile nil))

(defun dotspacemacs/user-env ()
  "Environment variables setup.
This function defines the environment variables for your Emacs session. By
default it calls `spacemacs/load-spacemacs-env' which loads the environment
variables declared in `~/.spacemacs.env' or `~/.spacemacs.d/.spacemacs.env'.
See the header of this file for more information."
  (spacemacs/load-spacemacs-env)
  )

(defun dotspacemacs/user-init ()
  "Initialization for user code:
This function is called immediately after `dotspacemacs/init', before layer
configuration.
It is mostly for variables that should be set before packages are loaded.
If you are unsure, try setting them in `dotspacemacs/user-config' first."

  ;; Prevent macOS BSD tar from adding AppleDouble ._ entries to Quelpa packages.
  (setenv "COPYFILE_DISABLE" "1")

  (setq
   ;; lsp-clangd-version "14.0.0"
   ;; lsp-clients-clangd-executable (concat user-home-directory "dev/clangd/bin/clangd")
   ;; lsp-clangd-binary-path (concat user-home-directory "dev/clangd/bin/clangd")
   ;; lsp-server-install-dir (concat user-home-directory "dev/clangd/bin/")
   theming-modifications '(
                           (sanityinc-tomorrow-night
                            (org-block-begin-line :foreground "#474c5e" :underline "#595f75" :extend t)
                            (org-block-end-line :foreground "#474c5e" :overline "#595f75" :underline nil :extend t)
                            (avy-goto-char-timer-face :foreground "medium spring green" :underline t)
                            (avy-goto-char-timer-face :foreground "#68c7a1" :underline t)
                            )

                           (doom-dracula
                            ;; (dracula-bg      "#0C0E0D" "unspecified-bg" "unspecified-bg") ; official background
                            ;; in ~/.emacs.d/elpa/29.1/develop/dracula-theme-20231013.821/dracula-theme.el:169

                            ;; ((bg         '("#0C0E0D" "#262626" "black"        ))
                            ;; /home/michael.conrads/.emacs.d/elpa/29.1/develop/doom-themes-20231208.2011/doom-dracula-theme.el


                            ;; (region :background "#44475a" :distant-foreground "#c6c6c1")
                            ;; (default :background "#0C0E0D")

                            ;; (org-block-begin-line :foreground "#474c5e" :underline "#595f75" :overline nil :background "#0C0E0D" :extend t)
                            ;; (org-block-end-line :foreground "#474c5e" :overline "#595f75" :underline nil :background "#0C0E0D" :extend t)

                            ;; (avy-goto-char-timer-face :foreground "medium spring green" :underline t)


                            ;; (ediff-current-diff-A :background "#222244"  :extend t)
                            ;; (ediff-fine-diff-A :background "#09537b"  :extend t)

                            ;; (org-todo :background nil :weight normal)
                            ;; (org-link :foreground "#aaf0ae" :weight normal)

                            ;; (font-lock-preprocessor-face :foreground "#8be9fd")
                            ;; (font-lock-function-name-face :foreground "#aaf0ae")
                            ;; (link :foreground "#aaf0ae")
                            ;; (web-mode-html-tag-face :foreground "#98F586")
                            ;; (font-lock-constant-face :foreground "#98F586")
                            ;; ;; (font-lock-type-face :foreground "#A8DFD0")
                            ;; (font-lock-type-face :foreground "#8be9fd")
                            ;; (font-lock-variable-name-face :foreground "#D4C4A7")
                            ;; ;; (font-lock-keyword-face :foreground "#C07E94")

                            ;; (org-level-1 :foreground "LightGray")
                            ;; (org-level-2 :foreground "LightGray")
                            ;; (org-level-3 :foreground "LightGray")
                            ;; (org-level-4 :foreground "LightGray")
                            ;; (org-level-5 :foreground "LightGray")


                            )
                           (modus-vivendi
                            (org-block-begin-line :foreground "#474c5e" :underline "#595f75" :overline nil :background "#000000" :extend t)
                            (org-block-end-line :foreground "#474c5e" :overline "#595f75" :underline nil :background "#000000" :extend t)
                            )

                           (spacemacs-light
                            (org-block-begin-line :background nil)
                            (org-block-end-line :background nil)
                            )


                           (doom-monokai-pro
                            (region :background "#111")
                            ;; (helm-ff-directory :foreground nil :inherit dired-directory)
                            (treemacs-directory-face :foreground nil :inherit dired-directory)
                            (evil-ex-lazy-highlight :foreground "#131313" :background "#ded090")

                            (ediff-current-diff-A :background "#663333")
                            (ediff-fine-diff-A  :background "#885555")

                            (ediff-current-diff-B :background "#295229")
                            (ediff-fine-diff-B :background "#3e633e" :underline t)

                            (ediff-current-diff-C :background "#333366")
                            (ediff-fine-diff-C :background "#555588")
                            )

                           (doom-monokai-machine
                            (region :background "#111")
                            ;; (helm-ff-directory :foreground nil :inherit dired-directory)
                            (treemacs-directory-face :foreground nil :inherit dired-directory)
                            (evil-ex-lazy-highlight :foreground "#131313" :background "#ded090")

                            (ediff-current-diff-A :background "#663333")
                            (ediff-fine-diff-A  :background "#885555")

                            (ediff-current-diff-B :background "#295229")
                            (ediff-fine-diff-B :background "#3e633e")
                            ;; (helm-selection :background "#005f8e")

                            (ediff-current-diff-C :background "#333366")
                            (ediff-fine-diff-C :background "#555588")

                            (magit-header-line :foreground "#273136")

                            (org-block-begin-line :foreground "DimGray" :background "#273136" :overline nil :underline "#595f75" :extend t)
                            (org-block-end-line :foreground "DimGray" :background "#273136" :overline "#595f75" :underline nil :extend t)
                            ;; (org-block-begin-line :foreground "#474c5e" :background "#273136" :overline nil :underline "#595f75" :extend t)
                            ;; (org-block-end-line :foreground "#474c5e" :background "#273136" :overline "#595f75" :underline nil :extend t)
                            (default :background "#0f1315")
                            )

                           (atom-one-dark
                            (org-block-begin-line :foreground "#474c5e" :underline "#595f75" :extend t)
                            (org-block-end-line :foreground "#474c5e" :overline "#595f75" :extend t)
                            ;; old: (org-block-end-line :foreground "#595f75" :overline "#595f75" :extend t)
                            (org-verbatim :inherit (shadow fixed-pitch) :foreground "medium spring green")

                            (term-color-blue :inherit ansi-color-blue :foreground "deep sky blue")

                            (ediff-current-diff-A :background "#663333")
                            (ediff-fine-diff-A  :background "#885555")

                            (ediff-current-diff-B :background "#295229")
                            (ediff-fine-diff-B :background "#3e633e")

                            (ediff-current-diff-C :background "#333366")
                            (ediff-fine-diff-C :background "#555588")
                            (org-imminent-deadline :foreground "#FF4500")
                            (highlight-doxygen-code-block :background unspecified)
                            (highlight-doxygen-comment :background unspecified)
                            )

                           (doom-snazzy
                            (line-number :foreground "#606580")
                            )

                           (doom-vibrant

                            (org-block-begin-line :foreground "#474c5e" :underline "#595f75" :extend t)
                            (org-block-end-line :foreground "#474c5e" :overline "#595f75" :underline nil :extend t)

                            (ediff-odd-diff-A :foreground unspecified :background "#3C435E")
                            (ediff-even-diff-A :foreground unspecified :background "#3C435E")

                            (ediff-current-diff-A :foreground unspecified :bold nil :background "#473454")
                            (ediff-current-diff-B :foreground unspecified :bold nil :background "#28403e")
                            (ediff-current-diff-C :foreground unspecified :bold nil  :background "#3a452a")

                            (ediff-fine-diff-A :foreground unspecified :bold nil :background "#7835a3")
                            (ediff-fine-diff-B :foreground unspecified :bold nil  :background "#295b54")
                            (ediff-fine-diff-C :foreground unspecified :bold nil  :background "#5b6946")

                            )

                           (doom-spacegrey
                            (ediff-current-diff-A :background ,current-diff-col)
                            (ediff-current-diff-B :background ,current-diff-col)
                            (ediff-current-diff-C :background ,current-diff-col)

                            (ediff-fine-diff-A :background ,fine-diff-col)
                            (ediff-fine-diff-B :background ,fine-diff-col)
                            (ediff-fine-diff-C :background ,fine-diff-col)
                            )

                           (doom-palenight

                            (org-block-begin-line :foreground "#595f75" :background "#292D3E")
                            (org-block-end-line :foreground "#595f75" :background "#292D3E")

                            (highlight-doxygen-comment :background unspecified)


                            (ediff-odd-diff-A :foreground "#e4e4e4" :background "#3C435E")
                            (ediff-even-diff-A :foreground "#e4e4e4" :background "#3C435E")

                            (ediff-current-diff-A :bold nil :background "#473454")
                            (ediff-current-diff-B :bold nil :background "#28403e")
                            (ediff-current-diff-C :bold nil  :background "#3a452a")

                            (ediff-fine-diff-A :bold nil :background "#7835a3")
                            (ediff-fine-diff-B :bold nil  :background "#295b54")
                            (ediff-fine-diff-C :bold nil  :background "#5b6946")

                            ))

   custom-file (concat mc/dot-dir "custom.el"))

  ;; (setq exec-path (append (list (expand-file-name "~/dev/clangd/bin")) exec-path))
  (load-file custom-file)

  (set-face-attribute 'fixed-pitch nil
                      :font mc/monospaced-font
                      :height 1.0
                      :weight mc/monospaced-weight)

  ;; more comment
  ;; Set the variable pitch face
  (set-face-attribute 'variable-pitch nil
                      :font "Iosevka Aile"
                      :height 1.0
                      :weight 'normal)

  ;; Make sure org-indent face is available
  (require 'org-indent)
  (defun mc/org-mode-setup ()
    (org-indent-mode)
    (variable-pitch-mode 1))
  (add-hook 'org-mode-hook 'mc/org-mode-setup)
  (add-hook 'smartparens-disabled-hook (lambda ()
                                         (when (eq major-mode 'c++-mode)
                                           (message "Reenabling smartparens")
                                           (smartparens-mode 1))))


  )


(defun dotspacemacs/user-load ()
  "Library to load while dumping.
This function is called only while dumping Spacemacs configuration. You can
`require' or `load' the libraries of your choice that will be included in the
dump."
  )


(defun dotspacemacs/user-config ()
  "Configuration for user code:
This function is called at the very end of Spacemacs startup, after layer
configuration.
Put your configuration code here, except for variables that should be set
before packages are loaded."


  (add-to-list 'treesit-language-source-alist
               '(nix "https://github.com/nix-community/tree-sitter-nix"))

  (add-to-list 'exec-path "~/.cargo/bin/")

  (use-package pdf-tools)

  (setq curr-file (or (buffer-file-name) load-file-name))
  (require 'org)
  (org-babel-load-file "~/dot/config.org")

  (define-key global-map [menu-bar options] nil)
  (define-key global-map [menu-bar edit] nil)
  (define-key global-map [menu-bar tools] nil)
  (define-key global-map [menu-bar file] nil)
  (define-key global-map [menu-bar buffers] nil)
  (define-key global-map [menu-bar YASnippet] nil)

  (define-key global-map [menu-bar help] nil)
  (define-key global-map [menu-bar debug] nil)
  (define-key global-map [menu-bar Emacs-Lisp] nil)

  (set-frame-parameter nil 'ns-transparent-titlebar t)

  (setenv "CC" nil)
  (setenv "LIBRARY_PATH" nil)
  )


;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
