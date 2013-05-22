if exists("loaded_find")
    finish
endif
let loaded_find = 1

" Line continuation used here
let s:cpo_save = &cpo
set cpo&vim

function! s:Find(...)
  let path="."
  if a:0==2
    let path=a:2
  endif
  let l:list=system("find ".path. " -name '".a:1."' | grep -v .svn ")
  let l:num=strlen(substitute(l:list, "[^\n]", "", "g"))
  if l:num < 1
    echo "'".a:1."' not found"
    return
  endif
  if l:num == 1
    exe "open " . substitute(l:list, "\n", "", "g")
  else
    let tmpfile = tempname()
    exe "redir! > " . tmpfile
    silent echon l:list
    redir END
    let old_efm = &efm
    set efm=%f

    if exists(":cgetfile")
        execute "silent! cgetfile " . tmpfile
    else
        execute "silent! cfile " . tmpfile
    endif

    let &efm = old_efm

    " Open the quickfix window below the current window
    botright copen

    call delete(tmpfile)
  endif
endfunction

command! -nargs=* Find :call s:Find(<f-args>)

" restore 'cpo'
let &cpo = s:cpo_save
unlet s:cpo_save

