# vimwiki-sum

A lightweight, high-performance Vim9 script plugin that allows you to quickly
sum numbers inside your Vimwiki tables. Whether you select a column, a row, or
a specific block of numbers, vimwiki-sum calculates the total and copies it
directly to your system clipboard.

---

## Features

* **Visual Block Summing**: Select a specific column slice of numbers using
  Visual Block mode (`Ctrl-V`), run the command, and get the total of that
  column.
* **Row Summing**: Select a full line or multiple lines using Visual Line mode
  (`V`), and the plugin automatically extracts and adds up all valid numbers
  across those rows.
* **Clipboard Integration**: Automatically copies the formatted result to both
  your `+` and `*` system clipboard registers for instant pasting into other
  applications.
* **Pure Vim9 Script**: Built from the ground up using Vim9 script syntax for
  optimal performance and compilation safety.

---

## Installation

### Method 1: Using Vim's Native Package Manager
Vim includes a built-in package manager that automatically loads plugins. You
can place this repository directly into your package directory.

Run the following commands in your terminal:
```bash
mkdir -p ~/.vim/pack/plugins/start/vimwiki-sum
cp -r autoload plugin ~/.vim/pack/plugins/start/vimwiki-sum/
```

### Method 2: Using a Plugin Manager (e.g., vim-plug)

If you manage your plugins via vim-plug, point it directly to your local
development directory or GitHub repository inside your configuration file:

```vim
call plug#begin('~/.vim/plugged')

" For a local development directory
Plug '/path/to/your/development/vimwiki-sum'

" For a hosted GitHub repository
" Plug 'yourusername/vimwiki-sum'

call plug#end()
```

After updating your configuration, restart Vim and run `:PlugInstall`.

---

## Usage

### The Command
The plugin exposes a single user command `:VimwikiAddCells` that operates on
visual selections:

```
:VimwikiAddCells
```

### Recommended Key Mapping

To make the plugin effortless to use, add a visual-mode mapping to your
configuration file (such as `~/.vimrc`). The following example binds the
operation to your local leader key followed by `s`:

```vim
vmap <leader>s :VimwikiAddCells<CR>
```

### Step-by-Step Examples

Given the following Vimwiki table:

```
| Item      | Qty | Price |
|-----------|-----|-------|
| Widgets   | 3   | 4.50  |
| Gadgets   | 2   | 7.00  |
```
* To sum a column: Enter Visual Block mode (`Ctrl-V`), highlight the numbers
  `4.50` and `7.00` in the Price column, and execute your mapping or command. The
  value `11.5` will be copied to your clipboard.
* To sum a row: Enter Visual Line mode (`V`), highlight the entire row for
  Widgets, and execute the command. The plugin ignores the text, extracts `3`
  and `4.5`, and copies the sum `7.5` to your clipboard.

## License

This project is licensed under the GPLv3 License.
