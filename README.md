php-foldexpr.vim
============

Vim folding for PHP with `foldexpr`

Configuration
-------------

- `b:phpfold_use = 1` - Fold groups of use statements in the global scope.
- `b:phpfold_group_iftry = 0` - Fold if/elseif/else and try/catch/finally blocks as a group, rather than each part separate.
- `b:phpfold_group_args = 1` - Group function arguments split across multiple lines into their own fold.
- `b:phpfold_group_case = 1` - Fold case and default blocks inside switches.
- `b:phpfold_heredocs = 1` - Fold HEREDOCs and NOWDOCs.
- `b:phpfold_docblocks = 1` - Fold DocBlocks.
- `b:phpfold_doc_with_funcs = 1` - Fold DocBlocks. Overrides b:phpfold_docblocks.
- `b:phpfold_text = 1` - Enable the custom `foldtext` option.

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

Folding Examples
----------------

### Namespaces alias and imports
When `b:phpfold_use` is enabled, consecutive `use` statements become folded.
```
Given                                  | `b:phpfold_text = 0`                | `b:phpfold_text = 1`
---------------------------------------------------------------------------------------------------
use FooInterface;                      |  +--  3 lines: use FooInterface;--- |  - 3 lines: use FooInterface, Bar, BazClass---
use BarClass as Bar;                   |                                     |
use OtherVendor\OtherPackage\BazClass; |                                     |
```

### Classes
Classes are folded from the `class` keyword to the closing `}`.
```
Given                                          | `b:phpfold_text = 0`                                           | `b:phpfold_text = 1`
-----------------------------------------------------------------------------------------------------------------------------------
class ClassName extends ParentClass implements | +-- 7 lines: class ClassName extends ParentClass implements--- | - 7 lines: class ClassName extends ParentClass implements \ArrayAccess, \Countable, \Serializable {...}---
    \ArrayAccess,                              |                                                                |
    \Countable,                                |                                                                |
    \Serializable                              |                                                                |
{                                              |                                                                |
    // constants, properties, methods          |                                                                |
}                                              |                                                                |
```

### Methods
When `b:phpfold_doc_with_funcs` is false, methods are folded from the `function` keyword to the method's closing `}`.
```
Given                                                    | `b:phpfold_text = 0`                                                   | `b:phpfold_text = 1`
--------------------------------------------------------------------------------------------------------------------------------------------------------
class ClassName                                          | class ClassName                                                        | class ClassName
{                                                        | {                                                                      | {
    public function fooBarBaz($arg1, &$arg2, $arg3 = []) | +---  4 lines: public function fooBarBaz($arg1, &$arg2, $arg3 = [])--- | -- 4 lines: public fooBarBaz() {...}---
    {                                                    | }                                                                      | } 
        // method body                                   |                                                                        |
    }                                                    |                                                                        |
}                                                        |                                                                        |
```

See [DocBlocks] for how `b:phpfold_doc_with_funcs` works when true.

### Method Arguments
When method arguments are listed on multiple lines and `b:phpfold_group_args` is true, the argument list is folded an additional level.
```
Given                                                    | `b:phpfold_text = 0`                       | `b:phpfold_text = 1`
----------------------------------------------------------------------------------------------------------------------------
class ClassName                                          | class ClassName                            | class ClassName 
{                                                        | {                                          | {
    public function aVeryLongMethodName(                 |     public fucntion aVeryLongMethodName(   |     public fucntion aVeryLongMethodName(
        ClassTypeHint $arg1,                             | +----  3 lines: ClassTypeHint $arg1,------ | --- 3 lines: ClassTypeHint $arg1, &$arg2, array $arg3 = []---
        &$arg2,                                          |     ) {                                    |     ) {
        array $arg3 = []                                 |         // method body                     |         // method body 
) {                                                      |     }                                      |     }
        // method body                                   | }                                          | }
}                                                        |                                            |
```

### Method and Function Calls
When arguments passed to a method or functionc all are listed on multiple lines, the list is folded from the method name to the closing `)`.
```
Given                   | `b:phpfold_text = 0`        | `b:phpfold_text = 1`
--------------------------------------------------------------------------------------------------------------------------------------------------------
$foo->bar(              | +--  5 lines: $foo->bar(--- | - 5 lines:  $foo->bar(...)---
    $longArgument,      |                             |
    $longerArgument,    |                             |
    $muchLongerArgument |                             |
);                      |                             |
```

### If...Elseif...Else Statements
When `b:phpfold_group_iftry` is false, `if`, `elseif`, and `else` statements are folded individually.
```
Given                                  | `b:phpfold_text = 0`               | `b:phpfold_text = 1`
--------------------------------------------------------------------------------------------------
if ($expr1) {                          | +--  2 lines: if (expr1) {-------- | - 2 lines: if (expr1) {...}--------
    // if body                         | +--  2 lines: elseif ($expr2) {--- | - 2 lines: elseif ($expr2) {...}---
} elseif ($expr2) {                    | +--  3 lines: else {-------------- | - 3 lines: else {...}--------------
    // elseif body                     |                                    |
} else {                               |                                    |
    // else body;                      |                                    |
}                                      |                                    |
```

When `b:phpfold_group_iftry` is true, `if`, `elseif`, and `else` statements are folded as a group.
```
Given                                  | `b:phpfold_text = 0`          | `b:phpfold_text = 1`
---------------------------------------------------------------------------------------------
if ($expr1) {                          | +--  7 lines: if (expr1) {--- | - 7 lines: if (expr1) {...}---
    // if body                         |                               |
} elseif ($expr2) {                    |                               |
    // elseif body                     |                               |
} else {                               |                               |
    // else body;                      |                               |
}                                      |                               |
```

### Switch Statements

The `switch` statement is folded as a whole, with each `case` block in its own fold.  Empty `case` blocks will be folded with the following blocks.

**Fold level 0:**
```
Given                                               | `b:phpfold_text = 0`               | `b:phpfold_text = 1`
---------------------------------------------------------------------------------------------------------------
switch ($expr) {                                    | +--  17 lines: switch ($expr) {--- | - 17 lines: switch ($expr) {...}---
    case 0:                                         |                                    |
    ¦   echo 'First case, with a break';            |                                    |
    ¦   break;                                      |                                    |
    case 0.5:                                       |                                    |
    case 1:                                         |                                    |
    ¦   echo 'Second case, which falls through';    |                                    |
    ¦   // no break                                 |                                    |
    case 2:                                         |                                    |
    case 3:                                         |                                    |
    case 4:                                         |                                    |
    ¦   echo 'Third case, return instead of break'; |                                    |
    ¦   return;                                     |                                    |
    default:                                        |                                    |
    ¦   echo 'Default case';                        |                                    |
    ¦   break;                                      |                                    |
}                                                   |                                    |
```

**Fold level 1:**
```
Given                                               | `b:phpfold_text = 0`          | `b:phpfold_text = 1`
----------------------------------------------------------------------------------------------------------
switch ($expr) {                                    | switch ($expr) {              | switch ($expr) {
    case 0:                                         | +---  3 lines: case 0: ------ | -- 3 lines: case 0:-------------------
    ¦   echo 'First case, with a break';            | +---  4 lines: case 0.5: ---- | -- 4 lines: case 0.5: case 1:---------
    ¦   break;                                      | +---  5 lines: case 2: ------ | -- 5 lines: case 2: case 3: case 4:---
    case 0.5:                                       | +---  3 lines: default: ----- | -- 3 lines: default:------------------
    case 1:                                         | }                             | }
    ¦   echo 'Second case, which falls through';    |                               |
    ¦   // no break                                 |                               |
    case 2:                                         |                               |
    case 3:                                         |                               |
    case 4:                                         |                               |
    ¦   echo 'Third case, return instead of break'; |                               |
    ¦   return;                                     |                               |
    default:                                        |                               |
    ¦   echo 'Default case';                        |                               |
    ¦   break;                                      |                               |
}                                                   |                               |
```

### While, Do While
```
Given                  | `b:phpfold_text = 0`             | `b:phpfold_text = 1`
--------------------------------------------------------------------------------
while ($expr) {        | +--  3 lines: while ($expr) {--- | - 3 lines: while ($expr) {...}-------
    // structure body  |                                  |
}                      |                                  |
                       |                                  |
do {                   | +-- 3 lines: do {--------------- | - 3 lines: do {...} while ($expr);---
    // structure body; |                                  |
} while ($expr);       |                                  |
```

### For
```
Given                         | `b:phpfold_text = 0`                          | `b:phpfold_text = 1`
----------------------------------------------------------------------------------------------------
for ($i = 0; $i < 10; $i++) { | +-- 3 lines: for ($i = 0; $i < 10; $i++) {--- | - 3 lines: for ($i = 0; $i < 10; $i++) {...}---
    // for body               |                                               |
}                             |                                               |
```

### Foreach
```
Given                                   | `b:phpfold_text = 0`                                    | `b:phpfold_text = 1`
------------------------------------------------------------------------------------------------------------------------
foreach ($iterable as $key => $value) { | +-- 3 lines: foreach ($iterable as $key => $value) {--- | - 3 lines: foreach ($iterable as $key => $value) {...}---
    // for body                         |                                                         |
}                                       |                                                         |
```

### Try, Catch
When `b:phpfold_group_iftry` is false, `try`, `catch`, and `finally` statements are folded individually.
```
Given                             | `b:phpfold_text = 0`                              | `b:phpfold_text = 1`
------------------------------------------------------------------------------------------------------------
try {                             | +--  2 lines: try { ----------------------------- | - 2 lines: try {...}------------------------------
    // try body                   | +--  2 lines: catch (FirstExceptionType $e) { --- | - 2 lines: catch (FirstExceptionType $e) {...}----
} catch (FirstExceptionType $e) { | +--  3 lines: catch (OtherExceptionType $e) { --- | - 3 lines: catch (OtherExceptionType $e) {...}----
    // catch body                 | +--  3 lines: finally {-------------------------- | - 3 lines: finally {...}--------------------------
} catch (OtherExceptionType $e) { |                                                   |
    // catch body                 |                                                   |
} finally {                       |                                                   |
    // finally body               |                                                   |
}                                 |                                                   |
```

When `b:phpfold_group_iftry` is true, `try`, `catch`, and `finally` statements are folded as a group.
```
Given                             | `b:phpfold_text = 0`   | `b:phpfold_text = 1`
---------------------------------------------------------------------------------
try {                             | +-- 7 lines: try { --- | - 7 lines: try {...} ---
    // try body                   |                        |
} catch (FirstExceptionType $e) { |                        |
    // catch body                 |                        |
} catch (OtherExceptionType $e) { |                        |
    // catch body                 |                        |
} finally {                       |                        |
    // finally body               |                        |
}                                 |                        |
```

### Closures
Closures are folded from the `function` keyword to the closing `}`.
```
Given                                                    | `b:phpfold_text = 0`                                                      | `b:phpfold_text = 1`
-----------------------------------------------------------------------------------------------------------------------------------------------------------
$closureWithNoArgs = function () {                       | +-- 3 lines: $closureWithNoArgs = function () {-------------------------- | - 3 lines: $closureWithNoArgs = function () {...};-------------------------
    // body                                              |                                                                           |
};                                                       |                                                                           |
                                                         |                                                                           |
$closureWithArgs = function ($arg1, $arg2) {             | +-- 3 lines: $closureWithArgs = fucntion ($arg1, $arg2) {---------------- | - 3 lines: $closureWithArgs = function ($arg1, $arg2) {...};---------------
    // body                                              |                                                                           |
};                                                       |                                                                           |
                                                         |                                                                           |
$closureWithArgsAndVars = function ($arg1) use ($var1) { | +--  3 lines: $closureWithArgsAndVars = function ($arg1) use ($var1) {--- | - 3 lines: $closureWithArgsAndVars = function ($arg1) use ($var1) {...};---
    // body                                              |                                                                           |
};                                                       |                                                                           |
```

### Closure Arguments and Variables
If `b:phpfold_group_args` is true, then when argument and variable lists are split across multiple lines they are folded an additional level individually.
```
Given                                       | `b:phpfold_text = 0`                                        | `b:phpfold_text = 1`
--------------------------------------------------------------------------------------------------------------------------------
$longArgs_noVars = function (               | +-- 7 lines: $longArgss_noVars = function (---------------- | - 7 lines: $longArgs_noVars = function (...) {...};------------------
    $longArgument,                          |                                                             |
    $longerArgument,                        |                                                             |
    $muchLongerArgument                     |                                                             |
) {                                         |                                                             |
   // body                                  |                                                             |
};                                          |                                                             |
                                            |                                                             |
$noArgs_longVars = function () use (        | +-- 7 lines: $lnoArgs_longVars = function () use (--------- | - 7 lines: $noArgs_longVars = function () use (...) {...};-----------
    $longVar1,                              |                                                             |
    $longerVar2,                            |                                                             |
    $muchLongerVar3                         |                                                             |
) {                                         |                                                             |
   // body                                  |                                                             |
};                                          |                                                             |
                                            |                                                             |
$longArgs_longVars = function (             | +-- 11 lines: $longArgs_longVars = function (-------------- | - 11 lines: $longArgs_longVars = function (...) use (...) {...};-----
    $longArgument,                          |                                                             |
    $longerArgument,                        |                                                             |
    $muchLongerArgument                     |                                                             |
) use (                                     |                                                             |
    $longVar1,                              |                                                             |
    $longerVar2,                            |                                                             |
    $muchLongerVar3                         |                                                             |
) {                                         |                                                             |
   // body                                  |                                                             |
};                                          |                                                             |
                                            |                                                             |
$longArgs_shortVars = function (            | +-- 7 lines: $longArgs_shortVars = function (-------------- | - 7 lines: $longArgs_shortVars = function (...) use ($var1) {...};---
    $longArgument,                          |                                                             |
    $longerArgument,                        |                                                             |
    $muchLongerArgument                     |                                                             |
) use ($var1) {                             |                                                             |
   // body                                  |                                                             |
};                                          |                                                             |
                                            |                                                             |
$shortArgs_longVars = function ($arg) use ( | +-- 7 lines: $shortArgs_longVars = function ($arg) use (--- | - 7 lines: $shortArgs_longVars = function ($arg) use (...) {...};----
    $longVar1,                              |                                                             |
    $longerVar2,                            |                                                             |
    $muchLongerVar3                         |                                                             |
) {                                         |                                                             |
   // body                                  |                                                             |
};                                          |                                                             |
```

### Arrays
Arrays are folded from the opening `array(` or `[` to the closing `)` or `]`.
```
Given           | `b:phpfold_text = 0`             | `b:phpfold_text = 1`
-------------------------------------------------------------------------
$array = array( | +--  4 lines: $array = array(--- | - 4 lines: $array = array(...);---
    'item'1,    |                                  |
    'item2'     |                                  |
);              |                                  |
                |                                  |
$array = [      | +--  4 lines: $array = [-------- | - 4 lines: $array = [...]----------
    'item1',    |                                  |
    'item2'     |                                  |
];              |                                  |
```

### DockBlocks
When `b:phpfold_docblocks` is enabled and `b:phpfold_doc_with_funcs` is disabled `/** */` comment blocks are folded from the `/**` to the `*/`.
```
Given                    | `b:phpfold_text = 0`  | `b:phpfold_text = 1`
---------------------------------------------------------------------
/**                      | +--  3 lines: /**---- | - 3 lines: Summary information.---
 * Summary information.  |                       |
 */                      |                       |
                         |                       |
/**                      | +--  4 lines: /**---- | - 4 lines: DocBlock Summary that spans multiple lines.---
 * DocBlock Summary that |                       |
 * spans multiple lines. |                       |
 */                      |                       |
```

If `b:phpfold_doc_with_funcs` is enabled, the fold begins with `/**` and ends with the function's `}`.
```
Given                                                    | `b:phpfold_text = 0` | `b:phpfold_text = 1`
------------------------------------------------------------------------------------------------------
class ClassName                                          | class ClassName      | class ClassName
{                                                        | {                    | {
    /**                                                  | +-- 7 lines: /**---- | - 7 lines: public fooBarBaz() {...} - Summary information.---
     * Summary information.                              | }                    | }
     */                                                  |                      |
    public function fooBarBaz($arg1, &$arg2, $arg3 = []) |                      |
    {                                                    |                      |
        // method body                                   |                      |
    }                                                    |                      |
}                                                        |                      |
```

### HEREDOCs and NOWDOCs
HEREDOCs and NOWDOCs are folded from the `<<<` to the closing keyword.
```
Given             | `b:phpfold_text = 0`               | `b:phpfold_text = 1`
-----------------------------------------------------------------------------
$heredoc = <<<EOF | +--  4 lines: $heredoc = <<<EOF--- | - 4 lines: $heredoc = <<<EOF...---
heredoc           |                                    |
text              |                                    |
EOF;              |                                    |
```
