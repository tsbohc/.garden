--
-- Built with,
--
--        ,gggg,
--       d8" "8I                         ,dPYb,
--       88  ,dP                         IP'`Yb
--    8888888P"                          I8  8I
--       88                              I8  8'
--       88        gg      gg    ,g,     I8 dPgg,
--  ,aa,_88        I8      8I   ,8'8,    I8dP" "8I
-- dP" "88P        I8,    ,8I  ,8'  Yb   I8P    I8
-- Yb,_,d88b,,_   ,d8b,  ,d8b,,8'_   8) ,d8     I8,
--  "Y8P"  "Y888888P'"Y88P"`Y8P' "YY8P8P88P     `Y8
--

local lush = require('lush')
local hsl = lush.hsl
local p = {}

--p.pure = hsl(215, 74, 85)
p.test = hsl(306, 100, 63)

--p.pure = hsl(0, 0, 100)
--p.snow = hsl(0, 0, 69)
--p.foam = hsl(0, 0, 55)
--p.ash = hsl(0, 0, 41)

p.green = hsl(122, 32, 74)
p.green_bg = hsl(122, 4, 19)

p.yellow = hsl(40, 93, 68)
p.yellow_bg = hsl(35, 8, 19)

p.red = hsl(345, 100, 70)
p.red_bg = hsl(345, 10, 19)
p.pure = hsl(213, 60, 85)
p.pure_bg = hsl(213, 10, 21)
p.snow = hsl(0, 0, 85)

p.chalk = hsl(48, 0, 77) -- gruv 88
p.ash = hsl(30, 0, 48) -- gruv 51
p.coal = hsl(0, 0, 33)
p.raven = hsl(0, 0, 29)
p.abyss = hsl(0, 0, 16) -- gruv 16

p.func = p.pure
p.keyword = p.ash
p.var = p.chalk

local theme = lush(function()
 return {
    Comment      { fg = p.raven, gui = 'italic' }, -- any comment
    -- ColorColumn  { }, -- used for the columns set with 'colorcolumn'
    Conceal      { fg = p.raven}, -- placeholder characters substituted for concealed text (see 'conceallevel')
    -- Cursor       { }, -- character under the cursor
    -- lCursor      { }, -- the character under the cursor when |language-mapping| is used (see 'guicursor')
    -- CursorIM     { }, -- like Cursor, but used when in IME mode |CursorIM|
    CursorColumn { bg = p.abyss.li(4) }, -- Screen-column at the cursor, when 'cursorcolumn' is set.
    CursorLine   { bg = p.abyss.li(4) }, -- Screen-line at the cursor, when 'cursorline' is set.  Low-priority if foreground (ctermfg OR guifg) is not set.
    Directory    { fg = p.chalk }, -- directory names (and other special names in listings)
    DiffAdd      { fg = p.green, bg = p.green_bg}, -- diff mode: Added line |diff.txt|
    DiffChange   { fg = p.yellow, bg = p.yellow_bg}, -- diff mode: Changed line |diff.txt|
    DiffDelete   { fg = p.red, bg = p.red_bg }, -- diff mode: Deleted line |diff.txt|

    DiffText     { DiffChange }, -- diff mode: Changed text within a changed line |diff.txt|
    EndOfBuffer  { fg = p.abyss }, -- filler lines (~) after the end of the buffer.  By default, this is highlighted like |hl-NonText|.
    -- TermCursor   { }, -- cursor in a focused terminal
    -- TermCursorNC { }, -- cursor in an unfocused terminal
    ErrorMsg     { fg = p.red, bg = p.red_bg }, -- error messages on the command line
    VertSplit    { fg = p.abyss.li(8) }, -- the column separating vertically split windows
    Folded       { fg = p.ash }, -- line used for closed folds
    -- FoldColumn   { fg = p.raven }, -- 'foldcolumn'
    -- SignColumn   { fg = p.raven }, -- column where |signs| are displayed
    IncSearch    { fg = p.abyss, bg = p.yellow }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
    -- Substitute   { }, -- |:substitute| replacement text highlighting
    LineNr       { fg = p.raven }, -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
    CursorLineNr { fg = p.chalk }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
    MatchParen   { fg = p.red, bg = p.red_bg, gui = "bold" }, -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
    ModeMsg      { fg = p.coal }, -- 'showmode' message (e.g., "-- INSERT -- ")
    -- MsgArea      { }, -- Area for messages and cmdline
    -- MsgSeparator { }, -- Separator for scrolled messages, `msgsep` flag of 'display'
    MoreMsg      { fg = p.green }, -- |more-prompt|
    NonText      { fg = p.coal }, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
    Normal       { fg = p.chalk, bg = p.abyss }, -- normal text
    NormalFloat  { Normal }, -- Normal text in floating windows.
    NormalNC     { Normal }, -- normal text in non-current windows
    Pmenu        { fg = p.ash.li(33), bg = p.abyss.li(5)}, -- Popup menu: normal item.
    PmenuSel     { fg = p.pure, bg = p.pure_bg }, -- Popup menu: selected item.
    PmenuSbar    { bg = p.abyss }, -- Popup menu: scrollbar.
    PmenuThumb   { bg = p.abyss }, -- Popup menu: Thumb of the scrollbar.
    Question     { fg = p.green }, -- |hit-enter| prompt and yes/no questions
    -- QuickFixLine { }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
    Search       { IncSearch }, -- Last search pattern highlighting (see 'hlsearch').  Also used for similar items that need to stand out.
    -- SpecialKey   { }, -- Unprintable characters: text displayed differently from what it really is.  But not 'listchars' whitespace. |hl-Whitespace|
    -- SpellBad     { }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise. 
    -- SpellCap     { }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
    -- SpellLocal   { }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
    -- SpellRare    { }, -- Word that is recognized by the spellchecker as one that is hardly ever used.  |spell| Combined with the highlighting used otherwise.
    -- StatusLine   { }, -- status line of current window
    -- StatusLineNC { }, -- status lines of not-current windows Note: if this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
    -- TabLine      { }, -- tab pages line, not active tab page label
    -- TabLineFill  { }, -- tab pages line, where there are no labels
    -- TabLineSel   { }, -- tab pages line, active tab page label
    Title        { fg = p.pure }, -- titles for output from ":set all", ":autocmd" etc.
    Visual       { bg = p.abyss.li(6) }, -- Visual mode selection
    -- VisualNOS    { }, -- Visual mode selection when vim is "Not Owning the Selection".
    WarningMsg   { fg = p.red }, -- warning messages
    Whitespace   { fg = p.abyss.li(7) }, -- "nbsp", "space", "tab" and "trail" in 'listchars'
    -- WildMenu     { }, -- current match in 'wildmenu' completion    

    -- These groups are not listed as default vim groups,
    -- but they are defacto standard group names for syntax highlighting.
    -- commented out groups should chain up to their "preferred" group by
    -- default,
    -- Uncomment and edit if you want more specific syntax highlighting.

    Constant       { fg = p.var }, -- (preferred) any constant
    String         { fg = p.ash }, --   a string constant: "this is a string"
    -- Character      { }, --  a character constant: 'c', '\n'
    -- Number         { }, --   a number constant: 234, 0xff
    -- Boolean        { }, --  a boolean constant: TRUE, false
    -- Float          { }, --    a floating point constant: 2.3e10

    Xdefaultspunct  { fg = p.ash },
    Xdefaultsvalue  { fg = p.ash },
    Vimoption       { fg = p.chalk },

    Netrwclassify   { fg = p.ash },
    NetrwPlain      { fg = p.ash },

    Identifier     { fg = p.var }, -- (preferred) any variable name
    Function       { fg = p.pure }, -- function name (also: methods for classes)

    Statement      { fg = p.ash, gui = 'italic' }, -- (preferred) any statement
    Conditional    { Statement }, --  if, then, else, endif, switch, etc.
    Repeat         { Statement }, --   for, do, while, etc.
    Label          { Statement }, --    case, default, etc.
    Operator       { Statement }, -- "sizeof", "+", "*", etc.
    Keyword        { Statement }, --  any other keyword
    Exception      { Statement }, --  try, catch, throw

    -- PreProc        { }, -- (preferred) generic Preprocessor
    -- Include        { }, --  preprocessor #include
    -- Define         { }, --   preprocessor #define
    -- Macro          { }, --    same as Define
    -- PreCondit      { }, --  preprocessor #if, #else, #endif, etc.

    Type           { fg = p.chalk }, -- (preferred) int, long, char, etc.
    -- StorageClass   { }, -- static, register, volatile, etc.
    -- Structure      { }, --  struct, union, enum, etc.
    -- Typedef        { }, --  A typedef

    Special        { }, -- (preferred) any special symbol
    -- SpecialChar    { }, --  special character in a constant
    -- Tag            { }, --    you can use CTRL-] on this
    -- Delimiter      { }, --  character that needs attention
    -- SpecialComment { }, -- special things inside a comment
    -- Debug          { }, --    debugging statements

    -- Underlined { gui = "underline" }, -- (preferred) text that stands out, HTML links
    -- Bold       { gui = "bold" },
    -- Italic     { ui = "italic" },

    -- ("Ignore", below, may be invisible...)
    -- Ignore         { }, -- (preferred) left blank, hidden  |hl-Ignore|

    Error          { ErrorMsg }, -- (preferred) any erroneous construct

    Todo           { fg = p.yellow }, -- (preferred) anything that needs extra attention; mostly the keywords TODO FIXME and XXX

    -- These groups are for the native LSP client. Some other LSP clients may
    -- use these groups, or use their own. Consult your LSP client's
    -- documentation.

    -- {{{
    -- LspReferenceText                     { }, -- used for highlighting "text" references
    -- LspReferenceRead                     { }, -- used for highlighting "read" references
    -- LspReferenceWrite                    { }, -- used for highlighting "write" references

    -- LspDiagnosticsDefaultError           { }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
    -- LspDiagnosticsDefaultWarning         { }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
    -- LspDiagnosticsDefaultInformation     { }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
    -- LspDiagnosticsDefaultHint            { }, -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)

    -- LspDiagnosticsVirtualTextError       { }, -- Used for "Error" diagnostic virtual text
    -- LspDiagnosticsVirtualTextWarning     { }, -- Used for "Warning" diagnostic virtual text
    -- LspDiagnosticsVirtualTextInformation { }, -- Used for "Information" diagnostic virtual text
    -- LspDiagnosticsVirtualTextHint        { }, -- Used for "Hint" diagnostic virtual text

    -- LspDiagnosticsUnderlineError         { }, -- Used to underline "Error" diagnostics
    -- LspDiagnosticsUnderlineWarning       { }, -- Used to underline "Warning" diagnostics
    -- LspDiagnosticsUnderlineInformation   { }, -- Used to underline "Information" diagnostics
    -- LspDiagnosticsUnderlineHint          { }, -- Used to underline "Hint" diagnostics

    -- LspDiagnosticsFloatingError          { }, -- Used to color "Error" diagnostic messages in diagnostics float
    -- LspDiagnosticsFloatingWarning        { }, -- Used to color "Warning" diagnostic messages in diagnostics float
    -- LspDiagnosticsFloatingInformation    { }, -- Used to color "Information" diagnostic messages in diagnostics float
    -- LspDiagnosticsFloatingHint           { }, -- Used to color "Hint" diagnostic messages in diagnostics float

    -- LspDiagnosticsSignError              { }, -- Used for "Error" signs in sign column
    -- LspDiagnosticsSignWarning            { }, -- Used for "Warning" signs in sign column
    -- LspDiagnosticsSignInformation        { }, -- Used for "Information" signs in sign column
    -- LspDiagnosticsSignHint               { }, -- Used for "Hint" signs in sign column
    -- }}}

    -- These groups are for the neovim tree-sitter highlights.
    -- As of writing, tree-sitter support is a WIP, group names may change.
    -- By default, most of these groups link to an appropriate Vim group,
    -- TSError -> Error for example, so you do not have to define these unless
    -- you explicitly want to support Treesitter's improved syntax awareness.

    -- TSAnnotation         { };    -- For C++/Dart attributes, annotations that can be attached to the code to denote some kind of meta information.
    -- TSAttribute          { };    -- (unstable) TODO: docs
    -- TSBoolean            { };    -- For booleans.
    -- TSCharacter          { };    -- For characters.
    -- TSComment            { };    -- For comment blocks.
    -- TSConstructor        { };    -- For constructor calls and definitions: ` { }` in Lua, and Java constructors.
    TSConditional        { Statement };    -- For keywords related to conditionnals.
    -- TSConstant           { };    -- For constants
    -- TSConstBuiltin       { };    -- For constant that are built in the language: `nil` in Lua.
    -- TSConstMacro         { };    -- For constants that are defined by macros: `NULL` in C.
    -- TSError              { fg = p.red };    -- For syntax/parser errors.
    -- TSException          { };    -- For exception related keywords.
    -- TSField              { fg = p.var };    -- For fields.
    -- TSFloat              { };    -- For floats.
    -- TSFunction           { Function };    -- For function (calls and definitions).
    TSFuncBuiltin        { fg = p.snow };    -- For builtin functions: `table.insert` in Lua.
    -- TSFuncMacro          { };    -- For macro defined fuctions (calls and definitions): each `macro_rules` in Rust.
    -- TSInclude            { };    -- For includes: `#include` in C, `use` or `extern crate` in Rust, or `require` in Lua.
    -- TSKeyword            { Statement };    -- For keywords that don't fall in previous categories.
     TSKeywordOperator      { Statement };    -- keywords "in"
    -- TSKeywordFunction    { };    -- For keywords used to define a fuction.
    -- TSLabel              { };    -- For labels: `label:` in C and `:label:` in Lua.
    -- TSMethod             { };    -- For method calls and definitions.
    -- TSNamespace          { };    -- For identifiers referring to modules and namespaces.
    TSNone               { fg = p.ash };    -- TODO: docs
    -- TSNumber             { };    -- For all numbers
    TSOperator           { fg = p.ash };    -- For any operator: `+`, but also `->` and `*` in C.
    -- TSParameter          { };    -- For parameters of a function.
    -- TSParameterReference { };    -- For references to parameters of a function.
    -- TSProperty           { Identifier };    -- Same as `TSField`.
    TSPunctDelimiter     { fg = p.ash };    -- For delimiters ie: `.`
    TSPunctBracket       { fg = p.coal.li(6) };    -- For brackets and parens.
    TSPunctSpecial       { fg = p.coal.li(6) };    -- For special punctutation that does not fall in the catagories before.
    TSRepeat             { Statement };    -- For keywords related to loops.
    -- TSString             { };    -- For strings.
    -- TSStringRegex        { };    -- For regexes.
    -- TSStringEscape       { };    -- For escape characters within a string.
    -- TSSymbol             { };    -- For identifiers referring to symbols or atoms.
    -- TSType               { };    -- For types.
    -- TSTypeBuiltin        { };    -- For builtin types.
    TSVariable           { fg = p.chalk };    -- Any variable name that does not have another highlight.
    -- TSVariableBuiltin    { };    -- Variable names that are defined by the languages, like `this` or `self`.

    -- TSTag                { };    -- Tags like html tag names.
    -- TSTagDelimiter       { };    -- Tag delimiter like `<` `>` `/`
    -- TSText               { };    -- For strings considered text in a markup language.
    -- TSEmphasis           { };    -- For text to be represented with emphasis.
    -- TSUnderline          { };    -- For text to be represented with an underline.
    -- TSStrike             { };    -- For strikethrough text.
    -- TSTitle              { };    -- Text that is part of a title.
    -- TSLiteral            { };    -- Literal text.
    -- TSURI                { };    -- Any URI like a link or email.

  }
end)

-- return our parsed theme for extension or use else where.
return theme

-- vi:nowrap
