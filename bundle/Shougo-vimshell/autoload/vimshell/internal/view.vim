"=============================================================================
" FILE: view.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu@gmail.com>
" Last Modified: 26 Feb 2010
" Usage: Just source this file.
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
" Version: 1.6, for Vim 7.0
"-----------------------------------------------------------------------------
" ChangeLog: "{{{
"   1.6:
"     - Print lines if one screen.
"     - Fixed nomodifiable error.
"
"   1.5:
"     - Catch error.
"
"   1.4:
"     - Extend current directory.
"
"   1.3:
"     - Ignore directory.
"
"   1.2:
"     - Improved error.
"
"   1.1:
"     - Split nicely.
"
"   1.0:
"     - Initial version.
""}}}
"-----------------------------------------------------------------------------
" TODO: "{{{
"     - Nothing.
""}}}
" Bugs"{{{
"     -
""}}}
"=============================================================================

function! vimshell#internal#view#execute(program, args, fd, other_info)
  " View file.

  if empty(a:args)
    if a:fd.stdin == ''
      vimshell#error_line(a:fd, 'Filename required.')
      return 0
    endif
    
    " Read from stdin.
    let l:filename = a:fd.stdin
  else
    let l:filename = a:args[0]
  endif

  if isdirectory(l:filename)
    " Ignore.
    return 0
  endif

  let l:lines = readfile(l:filename)
  if len(l:lines) < winheight(0)
    " Print lines if one screen.
    for l:line in l:lines
      call vimshell#print_line(a:fd, l:line)
    endfor
    
    return 0
  endif
  
  call vimshell#print_prompt()
  
  " Save current directiory.
  let l:cwd = getcwd()

  " Split nicely.
  call vimshell#split_nicely()

  try
    edit `=l:filename`
  catch /^.*/
    echohl Error | echomsg v:errmsg | echohl None
  endtry

  lcd `=l:cwd`
  setlocal nomodifiable
  return 1
endfunction
