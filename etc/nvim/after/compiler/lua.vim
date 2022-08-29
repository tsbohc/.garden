if exists("current_compiler")
  finish
endif
let current_compiler = "lua"

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo&vim

CompilerSet makeprg=love\ .

CompilerSet errorformat=
                       \Error:\ %.%#:\ %m,
                       \%-G%\t[love%.%#,
                       \%-G%\t[C]:%.%#,
                       \%f:%l:%m,
                       \%-Gstack\ traceback%.%#

                       " \Error:\ %f:%l:%m,
" Error:%*[^:]:\ %f:%l:%m,

let &cpo = s:cpo_save
unlet s:cpo_save
