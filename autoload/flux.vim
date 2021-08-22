" auto/flux.vim
" once {

if !NVPMTEST&&exists('FLUXAUTOLOAD')|finish|else|let FLUXAUTOLOAD=1|endif

" end-once}
" priv {

let s:rgex = {}

let s:rgex.proj = {}
let s:rgex.proj.name = '^\s*\(-*\)\s*name\s*\(.*\)'
let s:rgex.proj.root = '^\s*\(-*\)\s*root\s*\(.*\)'
let s:rgex.proj.proj = '^\s*\(-*\)\s*\%(project\|proj\|pj\)\s*\(.*\)'
let s:rgex.proj.wksp = '^\s*\(-*\)\s*\%(workspace\|area\|ws\)\s*\(.*\)'
let s:rgex.proj.tabs = '^\s*\(-*\)\s*\%(tab\|slot\|tb\)\s*\(.*\)'
let s:rgex.proj.file = '^\s*\(-*\)\s*\%(file\|buff\|bf\)\s*\(.*\)'
let s:rgex.proj.term = '^\s*\(-*\)\s*\%(terminal\|term\|tm\)\s*\(.*\)'

let s:rgex.line = {}
let s:rgex.iris = {}
let s:rgex.imux = {}

" }
" publ {

" proj plugin syntax {

let s:proj = {}

fu! s:proj.init() "{

  let self.tree = {}

endf "}
fu! s:proj.load() "{

  if !self.read()|return 0|endif

  let self.tree.file = self.orig
  let self.tree.name = fnamemodify(self.tree.file,':t')
  let self.tree.root = '.'
  let self.tree.list = []
  let self.tree.last = 0

  for self.i in range(len(self.lines))

    let self.line = self.lines[self.i]

    let comment = match(self.line,'#')
    if comment + 1|let self.line = self.line[0:comment-1]|endif
    let self.line = trim(self.line)

    if !empty(matchstr(self.line,'^\s*---.*$'))|break|endif
    if  empty(self.line)|continue|endif

    " Project File 'name' {

    let self.pattern = s:rgex.proj.name
    let self.match = matchlist(self.line,self.pattern)
    let disabled  = trim(get(self.match,1)) == '-'
    if !disabled|let self.tree.name=get(self.match,2,self.tree.name)|endif

    " }
    " Project File 'root' {

    let self.pattern = s:rgex.proj.root
    let self.match = matchlist(self.line,self.pattern)
    let disabled  = trim(get(self.match,1)) == '-'
    if !disabled|let self.tree.root=get(self.match,2,self.tree.root)|endif

    " }
    " Project File 'proj' {

    let self.pattern = s:rgex.proj.proj
    let self.match = matchlist(self.line,self.pattern)
    let disabled     = trim(get(self.match,1)) == '-'

    if !disabled && !empty(self.match)|call self.proj()|endif

    " }

  endfor

  unlet self.i

  return 1

endf "}
fu! s:proj.proj() "{

  let node       = {}
  let node.list  = []
  let self.match = split(self.match[2],':')
  let node.name = (len(self.match)>=1)?trim(self.match[0]):''
  let node.root = (len(self.match)>=2)?trim(self.match[1]):''
  let node.last = 0

  for self.p in range(self.i+1,len(self.lines)-1)
    let line = self.lines[self.p]
    let self.match = matchlist(line,s:rgex.proj.wksp)
    if match(line,s:rgex.proj.proj)+1|break
    elseif !empty(self.match)
      call add(node.list,self.wksp())
    endif
  endfor

  let self.tree.list+= [node]

endf "}
fu! s:proj.wksp() "{

  let node       = {}
  let node.list  = []
  let self.match = split(self.match[2],':')
  let node.name = (len(self.match)>=1)?trim(self.match[0]):''
  let node.root = (len(self.match)>=2)?trim(self.match[1]):''
  let node.last = 0

  for self.w in range(self.p+1,len(self.lines)-1)
    let line = self.lines[self.w]
    let self.match = matchlist(line,s:rgex.proj.tabs)
    if match(line,s:rgex.proj.wksp)+1|break
    elseif !empty(self.match)
      call add(node.list,self.tabs())
    endif
  endfor

  return node

endf "}
fu! s:proj.tabs() "{

  let node       = {}
  let node.list  = []
  let self.match = split(self.match[2],':')
  let node.name = (len(self.match)>=1)?trim(self.match[0]):''
  let node.root = (len(self.match)>=2)?trim(self.match[1]):''
  let node.last = 0

  for self.t in range(self.w+1,len(self.lines)-1)
    let line = self.lines[self.t]
    let fmatch = matchlist(line,s:rgex.proj.file)
    let tmatch = matchlist(line,s:rgex.proj.term)
    if match(line,s:rgex.proj.tabs)+1|break
    elseif !empty(fmatch)
      let self.match = fmatch
      call add(node.list,self.file())
    elseif !empty(tmatch)
      let self.match = tmatch
      call add(node.list,self.term())
    endif
  endfor

  return node

endf "}
fu! s:proj.file() "{

  let node       = {}
  let self.match = split(self.match[2],':')
  let node.name  = (len(self.match)>=1)?trim(self.match[0]):''
  let node.file  = (len(self.match)>=2)?trim(self.match[1]):''

  return node

endf "}
fu! s:proj.term() "{

  let node       = {}
  let self.match = split(self.match[2],':')
  let node.name  = (len(self.match)>=1)?trim(self.match[0]):''
  let node.comm  = (len(self.match)>=2)?trim(self.match[1]):''

  return node

endf "}
fu! s:proj.show() "{

  for key in keys(self.tree)
    if type(self.tree[key]) == v:t_string
      echo "'".key."'" ':' "'".self.tree[key]."'"
    elseif key == 'list'
      echo "'".key."'" ':'
      for item in self.tree[key]
        echo ' ' item
      endfor
    else
      echo "'".key."'" ':' "'".self.tree[key]."'"
    endif
  endfor

endf "}

" }
" line plugin syntax {

let s:line = {}

" }
" iris plugin syntax {

let s:iris = {}

" }
" imux plugin syntax {

let s:imux = {}

" }

" }
" objc {

fu! flux#flux() "{

  let self = {}
  let self.proj = s:proj
  let self.line = s:line
  let self.iris = s:iris
  let self.imux = s:imux
  call extend(self.proj,file#file())
  call self.proj.init()
  return self

endf "}

" }
