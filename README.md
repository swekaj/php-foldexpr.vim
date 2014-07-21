php-fold.vim
============

Vim folding for PHP with foldexpr

Configuration
-------------

- `b:phpfold_use = 1` : Fold groups of use statements in the global scope.
- `b:phpfold_group_iftry = 0` : Fold if/elseif/else and try/catch/finally blocks as a group, rather than each part separate.
- `b:phpfold_group_args = 1` : Group function arguments split across multiple lines into their own fold.
- `b:phpfold_group_case = 1` : Fold case and default blocks inside switches.

Installation
------------

- Manual installation:
  - Copy the files to your `.vim` directory (`_vimfiles` on Windows).
- [Pathogen](https://github.com/tpope/vim-pathogen)
  - `cd ~/.vim/bundle && git clone git://github.com/swekaj/php-foldexpr.vim`
- [Vundle](https://github.com/gmarik/vundle)
  1. Add `Bundle 'swekaj/php-foldexpr.vim'` to .vimrc
  2. Run `:BundleInstall`
- [NeoBundle](https://github.com/Shougo/neobundle.vim)
  1. Add `NeoBundle 'swekaj/php-foldexpr.vim'` to .vimrc
  2. Run `:NeoBundleInstall`
- [vim-plug](https://github.com/junegunn/vim-plug)
  1. Add `Plug 'swekaj/php-foldexpr.vim'` to .vimrc
  2. Run `:PlugInstall`

