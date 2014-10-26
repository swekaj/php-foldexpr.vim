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
- `b:phpfold_doc_with_funcs = 1` - Fold DocBlocks. Overrides `b:phpfold_docblocks`.
- `b:phpfold_text = 1` - Enable the custom `foldtext` option.
- `b:phpfold_text_right_lines = 1` - Display the line count on the right instead of the left.
- `b:phpfold_text_percent = 0` - Display the percentage of lines the fold represents.

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

Option Effects
--------------
There are two options for customizing how the fold text displays: `b:phpfold_text_right_lines` and `b:phpfold_text_percent`.

When `b:phpfold_text_right_lines` is true, the number of lines folded along with the dashes that indicate the fold level are aligned on the right side of the screen.
*`b:phpfold_text_right_lines = 0`:*
```
class ClassName
{
+--  4 lines: public foo() {...}-------------------------------------------
+--  6 lines: public bar() {...}-------------------------------------------
+-- 12 lines: public baz() {...}-------------------------------------------
}
```

*`b:phpfold_text_right_lines = 1`:*
```
class ClassName
{
    public foo() {...}----------------------------------------  4 lines +--
    public bar() {...}----------------------------------------  6 lines +--
    public baz() {...}---------------------------------------- 12 lines +--
}
```

When `b:phpfold_text_percent` is true, the percentage of the total lines the fold represents is displayed alongside the line count:
*`b:phpfold_text_right_lines = 0`:*
```
class ClassName
{
+--  2 lines [ 8%]: public foo() {...}-------------------------------------
+--  8 lines [32%]: public bar() {...}-------------------------------------
+-- 12 lines [48%]: public baz() {...}-------------------------------------
}
```

*`b:phpfold_text_right_lines = 1`:*
```
class ClassName
{
    public foo() {...}----------------------------------  2 lines [ 8%] +--
    public bar() {...}----------------------------------  8 lines [32%] +--
    public baz() {...}---------------------------------- 12 lines [48%] +--
}
```


Folding Examples
----------------

### Namespaces alias and imports
When `b:phpfold_use` is enabled, consecutive `use` statements become folded.

*Given:*
```
use FooInterface;
use BarClass as Bar;
use OtherVendor\OtherPackage\BazClass;
```

*With the default fold text:*
```
+--  3 lines: use FooInterface;---
```

*With the plugin's fold text:*
```
+- 3 lines: use FooInterface, Bar, BazClass---
```

### Classes
Classes are folded from the `class` keyword to the closing `}`.

*Given:*
```
class ClassName extends ParentClass implements
    \ArrayAccess,
    \Countable,
    \Serializable
{
    // constants, properties, methods
}
```

*With the default fold text:*
```
+--  7 lines: class ClassName extends ParentClass implements---
```

*With the plugin's fold text:*
```
+- 7 lines: class ClassName extends ParentClass implements \ArrayAccess, \Countable, \Serializable {...}---
```

### Methods
When `b:phpfold_doc_with_funcs` is false, methods are folded from the `function` keyword to the method's closing `}`.

*Given:*
```
class ClassName
{
    public function fooBarBaz($arg1, &$arg2, $arg3 = [])
    {
        // method body
    }
}
```

*With the default fold text:*
```
class ClassName
{
+---  4 lines: public function fooBarBaz($arg1, &$arg2, $arg3 = [])---
}
```

*With the plugin's fold text:*
```
class ClassName
{
+-- 4 lines: public fooBarBaz() {...}---
}
```

See [DocBlocks] for how `b:phpfold_doc_with_funcs` works when true.

### Method Arguments
When method arguments are listed on multiple lines and `b:phpfold_group_args` is true, the argument list is folded an additional level.

*Given:*
```
class ClassName
{
    public function aVeryLongMethodName(
        ClassTypeHint $arg1,
        &$arg2,
        array $arg3 = []
) {
        // method body
}
```

*With the default fold text:*
```
class ClassName
{
    public function aVeryLongMethodName(
+----  3 lines: ClassTypeHint $arg1,------
    ) {
        // method body
    }
}
```

*With the plugin's fold text:*
```
class ClassName
{
    public function aVeryLongMethodName(
+--- 3 lines: ClassTypeHint $arg1, &$arg2, array $arg3 = []---
    ) {
        // method body
    }
}
```

### Method and Function Calls
When arguments passed to a method or functionc all are listed on multiple lines, the list is folded from the method name to the closing `)`.

*Given:*
```
$foo->bar(
    $longArgument,
    $longerArgument,
    $muchLongerArgument
);
```

*With the default fold text:*
```
+--  5 lines: $foo->bar(---
```

*With the plugin's fold text:*
```
+- 5 lines:  $foo->bar(...)---
```

### If...Elseif...Else Statements
When `b:phpfold_group_iftry` is false, `if`, `elseif`, and `else` statements are folded individually.

*Given:*
```
if ($expr1) {
    // if body
} elseif ($expr2) {
    // elseif body
} else {
    // else body;
}
```

*With the default fold text:*
```
+--  2 lines: if (expr1) {--------
+--  2 lines: elseif ($expr2) {---
+--  3 lines: else {--------------
```

*With the plugin's fold text:*
```
+- 2 lines: if (expr1) {...}--------
+- 2 lines: elseif ($expr2) {...}---
+- 3 lines: else {...}--------------
```

When `b:phpfold_group_iftry` is true, `if`, `elseif`, and `else` statements are folded as a group.

*Given:*
```
if ($expr1) {
    // if body
} elseif ($expr2) {
    // elseif body
} else {
    // else body;
}
```

*With the default fold text:*
```
+--  7 lines: if (expr1) {---
```

*With the plugin's fold text:*
```
+- 7 lines: if (expr1) {...}---
```

### Switch Statements

The `switch` statement is folded as a whole, with each `case` block in its own fold.  Empty `case` blocks will be folded with the following blocks.

**Fold level 0:**

*Given:*
```
switch ($expr) {
    case 0:
        echo 'First case, with a break';
        break;
    case 0.5:
    case 1:
        echo 'Second case, which falls through';
        // no break
    case 2:
    case 3:
    case 4:
        echo 'Third case, return instead of break';
        return;
    default:
        echo 'Default case';
        break;
}
```

*With the default fold text:*
```
+--  17 lines: switch ($expr) {---
```

*With the plugin's fold text:*
```
+- 17 lines: switch ($expr) {...}---
```

**Fold level 1:**

*Given:*
```
switch ($expr) {                                    
    case 0:                                         
        echo 'First case, with a break';            
        break;                                      
    case 0.5:                                       
    case 1:                                         
        echo 'Second case, which falls through';    
        // no break                                 
    case 2:                                         
    case 3:                                         
    case 4:                                         
        echo 'Third case, return instead of break'; 
        return;                                     
    default:                                        
        echo 'Default case';                        
        break;                                      
}                                                   
```

*With the default fold text:*
```
switch ($expr) {             
+---  3 lines: case 0: ------
+---  4 lines: case 0.5: ----
+---  5 lines: case 2: ------
+---  3 lines: default: -----
}                            
```

*With the plugin's fold text:*
```
switch ($expr) {
+-- 3 lines: case 0:-------------------
+-- 4 lines: case 0.5: case 1:---------
+-- 5 lines: case 2: case 3: case 4:---
+-- 3 lines: default:------------------
}
```

### While, Do While

*Given:*
```
while ($expr) {
    // structure body
}

do {
    // structure body;
} while ($expr);
```

*With the default fold text:*
```
+--  3 lines: while ($expr) {---

+--  3 lines: do {---------------
```

*With the plugin's fold text:*
```
+- 3 lines: while ($expr) {...}-------

+- 3 lines: do {...} while ($expr);---
```

### For

*Given:*
```
for ($i = 0; $i < 10; $i++) {
    // for body
}
```

*With the default fold text:*
```
+--  3 lines: for ($i = 0; $i < 10; $i++) {---
```

*With the plugin's fold text:*
```
+- 3 lines: for ($i = 0; $i < 10; $i++) {...}---
```

### Foreach

*Given:*
```
foreach ($iterable as $key => $value) {
    // for body
}
```

*With the default fold text:*
```
+--  3 lines: foreach ($iterable as $key => $value) {---
```

*With the plugin's fold text:*
```
+- 3 lines: foreach ($iterable as $key => $value) {...}---
```

### Try, Catch
When `b:phpfold_group_iftry` is false, `try`, `catch`, and `finally` statements are folded individually.

*Given:*
```
try {
    // try body
} catch (FirstExceptionType $e) {
    // catch body
} catch (OtherExceptionType $e) {
    // catch body
} finally {
    // finally body
}
```

*With the default fold text:*
```
+--  2 lines: try { -----------------------------
+--  2 lines: catch (FirstExceptionType $e) { ---
+--  3 lines: catch (OtherExceptionType $e) { ---
+--  3 lines: finally {--------------------------
```

*With the plugin's fold text:*
```
+- 2 lines: try {...}------------------------------
+- 2 lines: catch (FirstExceptionType $e) {...}----
+- 3 lines: catch (OtherExceptionType $e) {...}----
+- 3 lines: finally {...}--------------------------
```

When `b:phpfold_group_iftry` is true, `try`, `catch`, and `finally` statements are folded as a group.

*Given:*
```
try {
    // try body
} catch (FirstExceptionType $e) {
    // catch body
} catch (OtherExceptionType $e) {
    // catch body
} finally {
    // finally body
}
```

*With the default fold text:*
```
+--  7 lines: try { ---
```

*With the plugin's fold text:*
```
+- 7 lines: try {...} ---
```

### Closures
Closures are folded from the `function` keyword to the closing `}`.

*Given:*
```
$closureWithNoArgs = function () {
    // body
};

$closureWithArgs = function ($arg1, $arg2) {
    // body
};

$closureWithArgsAndVars = function ($arg1) use ($var1) {
    // body
};
```

*With the default fold text:*
```
+--  3 lines: $closureWithNoArgs = function () {-------------------------

+--  3 lines: $closureWithArgs = function ($arg1, $arg2) {---------------

+--  3 lines: $closureWithArgsAndVars = function ($arg1) use ($var1) {---
```

*With the plugin's fold text:*
```
+- 3 lines: $closureWithNoArgs = function () {...};-------------------------

+- 3 lines: $closureWithArgs = function ($arg1, $arg2) {...};---------------

+- 3 lines: $closureWithArgsAndVars = function ($arg1) use ($var1) {...};---
```

### Closure Arguments and Variables
If `b:phpfold_group_args` is true, then when argument and variable lists are split across multiple lines they are folded an additional level individually.

*Given:*
```
$longArgs_noVars = function (
    $longArgument,
    $longerArgument,
    $muchLongerArgument
) {
   // body
};

$noArgs_longVars = function () use (
    $longVar1,
    $longerVar2,
    $muchLongerVar3
) {
   // body
};

$longArgs_longVars = function (
    $longArgument,
    $longerArgument,
    $muchLongerArgument
) use (
    $longVar1,
    $longerVar2,
    $muchLongerVar3
) {
   // body
};

$longArgs_shortVars = function (
    $longArgument,
    $longerArgument,
    $muchLongerArgument
) use ($var1) {
   // body
};

$shortArgs_longVars = function ($arg) use (
    $longVar1,
    $longerVar2,
    $muchLongerVar3
) {
   // body
};
```

*With the default fold text:*
```
+--  7 lines: $longArgss_noVars = function (----------------

+--  7 lines: $lnoArgs_longVars = function () use (---------

+-- 11 lines: $longArgs_longVars = function (---------------

+--  7 lines: $longArgs_shortVars = function (--------------

+--  7 lines: $shortArgs_longVars = function ($arg) use (---
```

*With the plugin's fold text:*
```
+-  7 lines: $longArgs_noVars = function (...) {...};------------------
-
+-  7 lines: $noArgs_longVars = function () use (...) {...};-----------

+- 11 lines: $longArgs_longVars = function (...) use (...) {...};------

+-  7 lines: $longArgs_shortVars = function (...) use ($var1) {...};---

+-  7 lines: $shortArgs_longVars = function ($arg) use (...) {...};----
```

### Arrays
Arrays are folded from the opening `array(` or `[` to the closing `)` or `]`.

*Given:*
```
$array = array(
    'item'1,
    'item2'
);

$array = [
    'item1',
    'item2'
];
```

*With the default fold text:*
```
+--  4 lines: $array = array(---

+--  4 lines: $array = [--------
```

*With the plugin's fold text:*
```
+- 4 lines: $array = array(...);---

+- 4 lines: $array = [...]----------
```

### DockBlocks
When `b:phpfold_docblocks` is enabled and `b:phpfold_doc_with_funcs` is disabled `/** */` comment blocks are folded from the `/**` to the `*/`.

*Given:*
```
/**
 * Summary information.
 */

/**
 * DocBlock Summary that
 * spans multiple lines.
 */
```

*With the default fold text:*
```
+--  3 lines: /**----

+--  4 lines: /**----
```

*With the plugin's fold text:*
```
+- 3 lines: Summary information.--------------------------

+- 4 lines: DocBlock Summary that spans multiple lines.---
```

If `b:phpfold_doc_with_funcs` is enabled, the fold begins with `/**` and ends with the function's `}`.

*Given:*
```
class ClassName
{
    /**
     * Summary information.
     */
    public function fooBarBaz($arg1, &$arg2, $arg3 = [])
    {
        // method body
    }
}
```

*With the default fold text:*
```
class ClassName
{
+--  7 lines: /**----
}
```

*With the plugin's fold text:*
```
class ClassName
{
+- 7 lines: public fooBarBaz() {...} - Summary information.---
}
```

### HEREDOCs and NOWDOCs
HEREDOCs and NOWDOCs are folded from the `<<<` to the closing keyword.

*Given:*
```
$heredoc = <<<EOF
heredoc
text
EOF;
```

*With the default fold text:*
```
+--  4 lines: $heredoc = <<<EOF---
```

*With the plugin's fold text:*
```
+- 4 lines: $heredoc = <<<EOF...---
```

