" Vim indent file
" Language: Typescript
" Acknowledgement: Almost direct copy from https://github.com/pangloss/vim-javascript

" Only load this indent file when no other was loaded.
if exists('b:did_indent') || get(g:, 'typescript_indent_disable', 0)
  finish
endif
let b:did_indent = 1

" Now, set up our indentation expression and keys that trigger it.
setlocal indentexpr=GetTypescriptIndent()
setlocal autoindent nolisp nosmartindent
setlocal indentkeys+=0],0)

let b:undo_indent = 'setlocal indentexpr< smartindent< autoindent< indentkeys<'

" Only define the function once.
if exists('*GetTypescriptIndent')
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" Get shiftwidth value
if exists('*shiftwidth')
  function s:sw()
    return shiftwidth()
  endfunction
else
  function s:sw()
    return &sw
  endfunction
endif

" searchpair() wrapper
if has('reltime')
  function s:GetPair(start,end,flags,skip,time,...)
    return searchpair('\m'.a:start,'','\m'.a:end,a:flags,a:skip,max([prevnonblank(v:lnum) - 2000,0] + a:000),a:time)
  endfunction
else
  function s:GetPair(start,end,flags,skip,...)
    return searchpair('\m'.a:start,'','\m'.a:end,a:flags,a:skip,max([prevnonblank(v:lnum) - 1000,get(a:000,1)]))
  endfunction
endif

" Regex of syntax group names that are or delimit string or are comments.
let s:syng_strcom = 'string\|comment\|regex\|special\|doc\|template\%(braces\)\@!'
let s:syng_str = 'string\|template\|special'
let s:syng_com = 'comment\|doc'
" Expression used to check whether we should skip a match with searchpair().
let s:skip_expr = "synIDattr(synID(line('.'),col('.'),0),'name') =~? '".s:syng_strcom."'"

function s:skip_func()
  if !s:free || search('\m`\|\${\|\*\/','nW',s:looksyn)
    let s:free = !eval(s:skip_expr)
    let s:looksyn = line('.')
    return !s:free
  endif
  let s:looksyn = line('.')
  return getline('.') =~ '\%<'.col('.').'c\/.\{-}\/\|\%>'.col('.').'c[''"]\|\\$' &&
        \ eval(s:skip_expr)
endfunction

function s:alternatePair(stop)
  let pos = getpos('.')[1:2]
  while search('\m[][(){}]','bW',a:stop)
    if !s:skip_func()
      let idx = stridx('])}',s:looking_at())
      if idx + 1
        if s:GetPair(['\[','(','{'][idx], '])}'[idx],'bW','s:skip_func()',2000,a:stop) <= 0
          break
        endif
      else
        return
      endif
    endif
  endwhile
  call call('cursor',pos)
endfunction

function s:save_pos(f,...)
  let l:pos = getpos('.')[1:2]
  let ret = call(a:f,a:000)
  call call('cursor',l:pos)
  return ret
endfunction

function s:syn_at(l,c)
  return synIDattr(synID(a:l,a:c,0),'name')
endfunction

function s:looking_at()
  return getline('.')[col('.')-1]
endfunction

function s:token()
  return s:looking_at() =~ '\k' ? expand('<cword>') : s:looking_at()
endfunction

function s:previous_token()
  let l:n = line('.')
  if (s:looking_at() !~ '\k' || search('\m\<','cbW')) && search('\m\S','bW')
    if (getline('.')[col('.')-2:col('.')-1] == '*/' || line('.') != l:n &&
          \ getline('.') =~ '\%<'.col('.').'c\/\/') && s:syn_at(line('.'),col('.')) =~? s:syng_com
      while search('\m\/\ze[/*]','cbW')
        if !search('\m\S','bW')
          break
        elseif s:syn_at(line('.'),col('.')) !~? s:syng_com
          return s:token()
        endif
      endwhile
    else
      return s:token()
    endif
  endif
  return ''
endfunction

function s:others(p)
  return "((line2byte(line('.')) + col('.')) <= ".(line2byte(a:p[0]) + a:p[1]).") || ".s:skip_expr
endfunction

function s:tern_skip(p)
  return s:GetPair('{','}','nbW',s:others(a:p),200,a:p[0]) > 0
endfunction

function s:tern_col(p)
  return s:GetPair('?',':\@<!::\@!','nbW',s:others(a:p)
        \ .' || s:tern_skip('.string(a:p).')',200,a:p[0]) > 0
endfunction

function s:label_col()
  let pos = getpos('.')[1:2]
  let [s:looksyn,s:free] = pos
  call s:alternatePair(0)
  if s:save_pos('s:IsBlock')
    let poss = getpos('.')[1:2]
    return call('cursor',pos) || !s:tern_col(poss)
  elseif s:looking_at() == ':'
    return !s:tern_col([0,0])
  endif
endfunction

" configurable regexes that define continuation lines, not including (, {, or [.
let s:opfirst = '^' . get(g:,'typescript_opfirst',
      \ '\%([<>=,?^%|*/&]\|\([-.:+]\)\1\@!\|!=\|in\%(stanceof\)\=\>\)')
let s:continuation = get(g:,'typescript_continuation',
      \ '\%([-+<>=,.~!?/*^%|&:]\|\<\%(typeof\|delete\|void\|in\|instanceof\)\)') . '$'

function s:continues(ln,con)
  return !cursor(a:ln, match(' '.a:con,s:continuation)) &&
        \ eval( (['s:syn_at(line("."),col(".")) !~? "regex"'] +
        \ repeat(['getline(".")[col(".")-2] != tr(s:looking_at(),">","=")'],3) +
        \ repeat(['s:previous_token() != "."'],5) + [1])[
        \ index(split('/ > - + typeof in instanceof void delete'),s:token())])
endfunction

" get the line of code stripped of comments and move cursor to the last
" non-comment char.
function s:Trim(ln)
  call cursor(a:ln+1,1)
  call s:previous_token()
  return strpart(getline('.'),0,col('.'))
endfunction

" Find line above 'lnum' that isn't empty or in a comment
function s:PrevCodeLine(lnum)
  let l:n = prevnonblank(a:lnum)
  while l:n
    if getline(l:n) =~ '^\s*\/[/*]' 
      if (stridx(getline(l:n),'`') > 0 || getline(l:n-1)[-1:] == '\') &&
            \ s:syn_at(l:n,1) =~? s:syng_str
        return l:n
      endif
      let l:n = prevnonblank(l:n-1)
    elseif getline(l:n) =~ '\([/*]\)\1\@![/*]' && s:syn_at(l:n,1) =~? s:syng_com
      let l:n = s:save_pos('eval',
            \ 'cursor('.l:n.',1) + search(''\m\/\*'',"bW")')
    else
      return l:n
    endif
  endwhile
endfunction

" Check if line 'lnum' has a balanced amount of parentheses.
function s:Balanced(lnum)
  let l:open = 0
  let l:line = getline(a:lnum)
  let pos = match(l:line, '[][(){}]', 0)
  while pos != -1
    if s:syn_at(a:lnum,pos + 1) !~? s:syng_strcom
      let l:open += match(' ' . l:line[pos],'[[({]')
      if l:open < 0
        return
      endif
    endif
    let pos = match(l:line, '[][(){}]', pos + 1)
  endwhile
  return !l:open
endfunction

function s:OneScope(lnum)
  let pline = s:Trim(a:lnum)
  let kw = 'else do'
  if pline[-1:] == ')' && s:GetPair('(', ')', 'bW', s:skip_expr, 100) > 0
    call s:previous_token()
    let kw = 'for if let while with'
    if index(split('await each'),s:token()) + 1
      call s:previous_token()
      let kw = 'for'
    endif
  endif
  return pline[-2:] == '=>' || index(split(kw),s:token()) + 1 &&
        \ s:save_pos('s:previous_token') != '.'
endfunction

" returns braceless levels started by 'i' and above lines * &sw. 'num' is the
" lineNr which encloses the entire context, 'cont' if whether line 'i' + 1 is
" a continued expression, which could have started in a braceless context
function s:iscontOne(i,num,cont)
  let [l:i, l:num, bL] = [a:i, a:num + !a:num, 0]
  let pind = a:num ? indent(l:num) + s:W : 0
  let ind = indent(l:i) + (a:cont ? 0 : s:W)
  while l:i >= l:num && (ind > pind || l:i == l:num)
    if indent(l:i) < ind && s:OneScope(l:i)
      let bL += s:W
      let l:i = line('.')
    elseif !a:cont || bL || ind < indent(a:i)
      break
    endif
    let ind = min([ind, indent(l:i)])
    let l:i = s:PrevCodeLine(l:i - 1)
  endwhile
  return bL
endfunction

" https://github.com/sweet-js/sweet.js/wiki/design#give-lookbehind-to-the-reader
function s:IsBlock()
  if s:looking_at() == '{'
    let l:n = line('.')
    let char = s:previous_token()
    if match(s:stack,'xml\|jsx') + 1 && s:syn_at(line('.'),col('.')-1) =~? 'xml\|jsx'
      return char != '{'
    elseif char =~ '\k'
      return index(split('return const let import export yield default delete var await void typeof throw case new in instanceof')
            \ ,char) < (line('.') != l:n) || s:previous_token() == '.'
    elseif char == '>'
      return getline('.')[col('.')-2] == '=' || s:syn_at(line('.'),col('.')) =~? '^jsflow'
    elseif char == ':'
      return getline('.')[col('.')-2] != ':' && s:label_col()
    elseif char == '/'
      return s:syn_at(line('.'),col('.')) =~? 'regex'
    endif
    return char !~ '[=~!<*,?^%|&([]' &&
          \ (char !~ '[-+]' || l:n != line('.') && getline('.')[col('.')-2] == char)
  endif
endfunction

function GetTypescriptIndent()
  let b:js_cache = get(b:,'js_cache',[0,0,0])
  " Get the current line.
  call cursor(v:lnum,1)
  let l:line = getline('.')
  " use synstack as it validates syn state and works in an empty line
  let s:stack = synstack(v:lnum,1)
  let syns = synIDattr(get(s:stack,-1),'name')

  " start with strings,comments,etc.
  if syns =~? s:syng_com
    if l:line =~ '^\s*\*'
      return cindent(v:lnum)
    elseif l:line !~ '^\s*\/[/*]'
      return -1
    endif
  elseif syns =~? s:syng_str && l:line !~ '^[''"]'
    if b:js_cache[0] == v:lnum - 1 && s:Balanced(v:lnum-1)
      let b:js_cache[0] = v:lnum
    endif
    return -1
  endif
  let l:lnum = s:PrevCodeLine(v:lnum - 1)
  if !l:lnum
    return
  endif

  let l:line = substitute(l:line,'^\s*','','')
  if l:line[:1] == '/*'
    let l:line = substitute(l:line,'^\%(\/\*.\{-}\*\/\s*\)*','','')
  endif
  if l:line =~ '^\/[/*]'
    let l:line = ''
  endif

  " the containing paren, bracket, or curly. Many hacks for performance
  let idx = index([']',')','}'],l:line[0])
  if b:js_cache[0] >= l:lnum && b:js_cache[0] < v:lnum &&
        \ (b:js_cache[0] > l:lnum || s:Balanced(l:lnum))
    call call('cursor',b:js_cache[1:])
  else
    let [s:looksyn, s:free, top] = [v:lnum - 1, 1, (!indent(l:lnum) &&
          \ s:syn_at(l:lnum,1) !~? s:syng_str) * l:lnum]
    if idx + 1
      call s:GetPair(['\[','(','{'][idx],'])}'[idx],'bW','s:skip_func()',2000,top)
    elseif getline(v:lnum) !~ '^\S' && syns =~? 'block'
      call s:GetPair('{','}','bW','s:skip_func()',2000,top)
    else
      call s:alternatePair(top)
    endif
  endif

  let b:js_cache = [v:lnum] + (line('.') == v:lnum ? [0,0] : getpos('.')[1:2])
  let num = b:js_cache[1]

  let [s:W, isOp, bL, switch_offset] = [s:sw(),0,0,0]
  if !num || s:IsBlock()
    let ilnum = line('.')
    let pline = s:save_pos('s:Trim',l:lnum)
    if num && s:looking_at() == ')' && s:GetPair('(', ')', 'bW', s:skip_expr, 100) > 0
      let num = ilnum == num ? line('.') : num
      if idx < 0 && s:previous_token() ==# 'switch' && s:previous_token() != '.'
        if &cino !~ ':'
          let switch_offset = s:W
        else
          let cinc = matchlist(&cino,'.*:\zs\(-\)\=\(\d*\)\(\.\d\+\)\=\(s\)\=\C')
          let switch_offset = max([cinc[0] is '' ? 0 : (cinc[1].1) *
                \ ((strlen(cinc[2].cinc[3]) ? str2nr(cinc[2].str2nr(cinc[3][1])) : 10) *
                \ (cinc[4] is '' ? 1 : s:W)) / 10, -indent(num)])
        endif
        if pline[-1:] != '.' && l:line =~# '^\%(default\|case\)\>'
          return indent(num) + switch_offset
        endif
      endif
    endif
    if idx < 0 && pline !~ '[{;]$'
      if pline =~# ':\@<!:$'
        call cursor(l:lnum,strlen(pline))
        let isOp = s:tern_col(b:js_cache[1:2]) * s:W
      else
        let isOp = (l:line =~# s:opfirst || s:continues(l:lnum,pline)) * s:W
      endif
      let bL = s:iscontOne(l:lnum,b:js_cache[1],isOp)
      let bL -= (bL && l:line[0] == '{') * s:W
    endif
  endif

  " main return
  if idx + 1 || l:line[:1] == '|}'
    return indent(num)
  elseif num
    return indent(num) + s:W + switch_offset + bL + isOp
  endif
  return bL + isOp
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save

