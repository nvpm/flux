" auto/flux.vim
" once {

if !NVPMTEST&&exists('FLUXAUTOLOAD')|finish|else|let FLUXAUTOLOAD=1|endif

" end-once}
" priv {

let s:rgex = {}

let s:rgex.proj = {}
let s:rgex.proj.name = '^\s*name\s*\(.*\)'
let s:rgex.proj.root = '^\s*root\s*\(.*\)'
let s:rgex.proj.proj = '^\s*\%(project\|proj\|pj\)\s*\(.*\)'
let s:rgex.proj.area = '^\s*\%(workspace\|area\|ws\)\s*\(.*\)'
let s:rgex.proj.slot = '^\s*\%(tab\|slot\|tb\)\s*\(.*\)'
let s:rgex.proj.file = '^\s*\%(file\|buff\|bf\)\s*\(.*\)'
let s:rgex.proj.term = '^\s*\%(terminal\|term\|tm\)\s*\(.*\)'

let s:rgex.line = {}
let s:rgex.iris = {}
let s:rgex.imux = {}
" }
" publ {

" proj plugin syntax {

let s:proj = {}

fu! s:proj.init() "{

  let self.tree = {}
  let self.type = 'random'

endf "}
fu! s:proj.eval() "{

  let read = self.read()

  let self.tree.file = self.orig
  let self.tree.name = fnamemodify(self.tree.file,':t')
  let self.tree.root = '.'
  let self.tree.list = []

  for self.line in self.lines

    let comment = match(self.line,'#')
    if comment + 1|let self.line = self.line[0:comment-1]|endif
    let self.line = trim(self.line)

    if !empty(matchstr(self.line,'^\s*---.*$'))|break|endif
    if  empty(self.line)|continue|endif

    " Project File 'name' {

    let self.pattern = s:rgex.proj.name
    let self.matches = matchlist(self.line,self.pattern)
    let self.tree.name = get(self.matches,1,self.tree.name)

    " }
    " Project File 'root' {

    let self.pattern = s:rgex.proj.root
    let self.matches = matchlist(self.line,self.pattern)
    let self.tree.root = get(self.matches,1,self.tree.root)

    " }
    " Project File 'proj' {

    let self.pattern = s:rgex.proj.proj
    let self.matches = matchlist(self.line,self.pattern)

    if !empty(self.matches)
      let self.type = 'proj'
      call self.proj()
    endif

    " }

  endfor

  return read

endf "}
fu! s:proj.proj() "{

  if self.type != 'proj'|return|endif
  let proj = {}

  let self.tree.list+= [proj]

endf "}
fu! s:proj.show() "{

  for key in keys(self.tree)
    if type(self.tree[key]) == v:t_string
      echo "'".key."'" ':' "'".self.tree[key]."'"
    elseif type(self.tree[key]) == v:t_list
      echo "'".key."'" ':' self.tree[key]
    endif
  endfor

endf "}

" }
" line plugin syntax {

" }
" iris plugin syntax {

" }
" imux plugin syntax {

" }

" }
" objc {

fu! flux#flux() "{

  let self = {}
  let self.proj = s:proj
  call extend(self.proj,file#file())
  call self.proj.init()
  return self

endf "}

" }
