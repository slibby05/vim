" Vim syntax file
" Language:            Curry
"
"
" Options-assign a value to these variables to turn the option on:
"
" cu_highlight_delimiters - Highlight delimiter characters--users
"                with a light-colored background will
"                probably want to turn this on.
" cu_highlight_boolean - Treat True and False as keywords.
" cu_highlight_types - Treat names of primitive types as keywords.
" cu_highlight_more_types - Treat names of other common types as keywords.
" cu_highlight_debug - Highlight names of debugging functions.
" cu_allow_hash_operator - Don't highlight seemingly incorrect C
"               preprocessor directives but assume them to be
"               operators
"
if version < 600
  syn clear
elseif exists("b:current_syntax")
  finish
endif

" (Qualified) identifiers (no default highlighting)
syn match ConId "\(\<[A-Z][a-zA-Z0-9_']*\.\)\=\<[A-Z][a-zA-Z0-9_']*\>"
syn match VarId "\(\<[A-Z][a-zA-Z0-9_']*\.\)\=\<[a-z][a-zA-Z0-9_']*\>"

" Infix operators--most punctuation characters and any (qualified) identifier
" enclosed in `backquotes`. An operator starting with : is a constructor,
" others are variables (e.g. functions).
syn match cuVarSym "\(\<[A-Z][a-zA-Z0-9_']*\.\)\=[-!#$%&\*\+/<=>\?@\\^|~.][-!#$%&\*\+/<=>\?@\\^|~:.]*"
syn match cuConSym "\(\<[A-Z][a-zA-Z0-9_']*\.\)\=:[-!#$%&\*\+./<=>\?@\\^|~:]*"
syn match cuVarSym "`\(\<[A-Z][a-zA-Z0-9_']*\.\)\=[a-z][a-zA-Z0-9_']*`"
syn match cuConSym "`\(\<[A-Z][a-zA-Z0-9_']*\.\)\=[A-Z][a-zA-Z0-9_']*`"

" Reserved symbols--cannot be overloaded.
syn match cuDelimiter  "(\|)\|\[\|\]\|,\|;\|_\|{\|}"

" Strings and constants
syn match   cuSpecialChar      contained "\\\([0-9]\+\|o[0-7]\+\|x[0-9a-fA-F]\+\|[\"\\'&\\abfnrtv]\|^[A-Z^_\[\\\]]\)"
syn match   cuSpecialChar      contained "\\\(NUL\|SOH\|STX\|ETX\|EOT\|ENQ\|ACK\|BEL\|BS\|HT\|LF\|VT\|FF\|CR\|SO\|SI\|DLE\|DC1\|DC2\|DC3\|DC4\|NAK\|SYN\|ETB\|CAN\|EM\|SUB\|ESC\|FS\|GS\|RS\|US\|SP\|DEL\)"
syn match   cuSpecialCharError contained "\\&\|'''\+"
syn region  cuString           start=+"+  skip=+\\\\\|\\"+  end=+"+  contains=cuSpecialChar
syn match   cuCharacter        "[^a-zA-Z0-9_']'\([^\\]\|\\[^']\+\|\\'\)'"lc=1 contains=cuSpecialChar,cuSpecialCharError
syn match   cuCharacter        "^'\([^\\]\|\\[^']\+\|\\'\)'" contains=cuSpecialChar,cuSpecialCharError
syn match   cuNumber           "\<[0-9]\+\>\|\<0[xX][0-9a-fA-F]\+\>\|\<0[oO][0-7]\+\>"
syn match   cuFloat            "\<[0-9]\+\.[0-9]\+\([eE][-+]\=[0-9]\+\)\=\>"

" Keyword definitions. These must be patters instead of keywords
" because otherwise they would match as keywords at the start of a
" "literate" comment (see lhs.vim).
syn match cuModule       "\<module\>"
syn match cuImport       "\<import\>.*"he=s+6 contains=cuImportMod,cuLineComment,cuBlockComment
syn match cuImportMod    contained "\<\(as\|qualified\|hiding\)\>"
syn match cuInfix        "\<\(infix\|infixl\|infixr\)\>"
syn match cuStructure    "\<\(class\|data\|deriving\|instance\|default\|where\|free\)\>"
syn match cuTypedef      "\<\(type\|newtype\)\>"
syn match cuStatement    "\<\(do\|case\|of\|let\|in\|success\)\>"
syn match cuConditional  "\<\(if\|then\|else\)\>"

" Not real keywords, but close.
if exists("cu_highlight_boolean")
  " Boolean constants from the standard prelude.
  syn match cuBoolean "\<\(True\|False\)\>"
endif
if exists("cu_highlight_types")
  " Primitive types from the standard prelude and libraries.
  syn match cuType "\<\(Int\|Integer\|Char\|Bool\|Float\|Double\|IO\|Void\|Addr\|Array\|String\|Success\)\>"
endif
if exists("cu_highlight_more_types")
  " Types from the standard prelude libraries.
  syn match cuType     "\<\(Maybe\|Either\|Ratio\|Complex\|Ordering\|IOError\|IOResult\|ExitCode\)\>"
  syn match cuMaybe    "\<Nothing\>"
  syn match cuExitCode "\<\(ExitSuccess\)\>"
  syn match cuOrdering "\<\(GT\|LT\|EQ\)\>"
endif
if exists("cu_highlight_debug")
  " Debugging functions from the standard prelude.
  syn match cuDebug "\<\(undefined\|error\|trace\)\>"
endif


" Comments
syn match   cuLineComment      "---*\([^-!#$%&\*\+./<=>\?@\\^|~].*\)\?$"
syn region  cuBlockComment     start="{-"  end="-}" contains=cuBlockComment
syn region  cuPragma           start="{-#" end="#-}"

" C Preprocessor directives. Shamelessly ripped from c.vim and trimmed
" First, see whether to flag directive-like lines or not
if (!exists("cu_allow_hash_operator"))
    syn match    cError        display "^\s*\(%:\|#\).*$"
endif
" Accept %: for # (C99)
syn region  cPreCondit    start="^\s*\(%:\|#\)\s*\(if\|ifdef\|ifndef\|elif\)\>" skip="\\$" end="$" end="//"me=s-1 contains=cComment,cCppString,cCommentError
syn match   cPreCondit    display "^\s*\(%:\|#\)\s*\(else\|endif\)\>"
syn region  cCppOut       start="^\s*\(%:\|#\)\s*if\s\+0\+\>" end=".\@=\|$" contains=cCppOut2
syn region  cCppOut2      contained start="0" end="^\s*\(%:\|#\)\s*\(endif\>\|else\>\|elif\>\)" contains=cCppSkip
syn region  cCppSkip      contained start="^\s*\(%:\|#\)\s*\(if\>\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*\(%:\|#\)\s*endif\>" contains=cCppSkip
syn region  cIncluded     display contained start=+"+ skip=+\\\\\|\\"+ end=+"+
syn match   cIncluded     display contained "<[^>]*>"
syn match   cInclude      display "^\s*\(%:\|#\)\s*include\>\s*["<]" contains=cIncluded
syn cluster cPreProcGroup contains=cPreCondit,cIncluded,cInclude,cDefine,cCppOut,cCppOut2,cCppSkip,cCommentStartError
syn region  cDefine       matchgroup=cPreCondit start="^\s*\(%:\|#\)\s*\(define\|undef\)\>" skip="\\$" end="$"
syn region  cPreProc      matchgroup=cPreCondit start="^\s*\(%:\|#\)\s*\(pragma\>\|line\>\|warning\>\|warn\>\|error\>\)" skip="\\$" end="$" keepend

syn    region   cComment           matchgroup=cCommentStart start="/\*" end="\*/" contains=cCommentStartError,cSpaceError contained
syntax match    cCommentError      display "\*/" contained
syntax match    cCommentStartError display "/\*"me=e-1 contained
syn    region   cCppString         start=+L\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end='$' contains=cSpecial contained

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_cu_syntax_inits")
  if version < 508
    let did_cu_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink cuModule           cuStructure
  HiLink cuImport           Include
  HiLink cuImportMod        cuImport
  HiLink cuInfix            PreProc
  HiLink cuStructure        Structure
  HiLink cuStatement        Statement
  HiLink cuConditional      Conditional
  HiLink cuSpecialChar      SpecialChar
  HiLink cuTypedef          Typedef
  HiLink cuVarSym           cuOperator
  HiLink cuConSym           cuOperator
  HiLink cuOperator         Operator
  if exists("cu_highlight_delimiters")
    " Some people find this highlighting distracting.
    HiLink cuDelimiter      Delimiter
  endif
  HiLink cuSpecialCharError Error
  HiLink cuString           String
  HiLink cuCharacter        Character
  HiLink cuNumber           Number
  HiLink cuFloat            Float
  HiLink cuConditional      Conditional
  HiLink cuLiterateComment  cuComment
  HiLink cuBlockComment     cuComment
  HiLink cuLineComment      cuComment
  HiLink cuComment          Comment
  HiLink cuPragma           SpecialComment
  HiLink cuBoolean          Boolean
  HiLink cuType             Type
  HiLink cuMaybe            cuEnumConst
  HiLink cuOrdering         cuEnumConst
  HiLink cuEnumConst        Constant
  HiLink cuDebug            Debug

  HiLink cCppString         hsString
  HiLink cCommentStart      hsComment
  HiLink cCommentError      hsError
  HiLink cCommentStartError hsError
  HiLink cInclude           Include
  HiLink cPreProc           PreProc
  HiLink cDefine            Macro
  HiLink cIncluded          hsString
  HiLink cError             Error
  HiLink cPreCondit         PreCondit
  HiLink cComment           Comment
  HiLink cCppSkip           cCppOut
  HiLink cCppOut2           cCppOut
  HiLink cCppOut            Comment

  delcommand HiLink
endif

let b:current_syntax = "curry"

" Options for vi: ts=8 sw=2 sts=2 nowrap noexpandtab ft=vim
