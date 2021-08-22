" auto/file.vim
" once {

if !NVPMTEST&&exists('FILEAUTOLOAD')|finish|else|let FILEAUTOLOAD=1|endif

" end-once}
" priv {

" }
" publ {

fu! s:read() dict "{

  if !filereadable(self.orig)|return 0|endif
  let self.lines = readfile(self.orig)
  return 1

endf "}
fu! s:copy() dict "{

  if !self.read() |return 0|endif
  call writefile(self.lines,self.dest)
  return 1

endf "}

" }
" objc {

fu! file#file() "{

  let self = {}

  let self.read = function("s:read")
  let self.copy = function("s:copy")

  "let len = len(a:000)
  "if len == 1
    "let self.orig = a:000[0]
  "elseif len == 2
    "let self.orig = a:000[0]
    "let self.dest = a:000[1]
  "else
    "let self.orig = ''
    "let self.dest = ''
  "endif

  let self.orig = ''
  let self.dest = ''

  let self.lines = []

  return self

endf "}

" }
