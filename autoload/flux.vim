" auto/flux.vim
" once {

if !NVPMTEST&&exists('FLUXAUTOLOAD')|finish|else|let FLUXAUTOLOAD=1|endif

" end-once}
" priv {

" }
" publ {

fu! s:flux() dict  "{

  call self.read()

  for line in self.lines
    if self.stop(line)|break|endif
    echo line
  endfor

  return {}
  
endf "}

" }
" objc {

fu! flux#flux(...) "{

  let self = {}
  let self.flux = function("s:flux")
  call extend(self,file#file())
  call extend(self,rgex#rgex())

  if len(a:000) == 1
    let self.file = a:000[0]
    call self.read()
  endif

  unlet self.copy
  unlet self.make

  return self

endf "}

" }
" save {

"fu! s:flux.init() "{

  "let self.type = ''
  "let self.data = s:data.strc

"endf "}
"fu! s:flux.flux() "{

  "if s:patt.flux()|return|endif

  "let self.name = self.content
  "let self.data[self.name]      = {}
  "let self.data[self.name].vars = {}
  "let self.data[self.name].dict = {}

  "while !s:patt.iend() && !s:patt.endf()
    "call self.vars()
    "call self.dict()
    "call s:file.next()
  "endwhile

"endf "}
"fu! s:flux.vars() "{

  "if s:patt.vars()|return|endif
  "let self.type = 'vars'
  "call self.remv()
  "call self.eval()
  "call extend(self.data[self.name].vars,self.content)

"endf "}
"fu! s:flux.dict() "{

  "if s:patt.dict()|return|endif
  "let self.type = 'dict'
  "call self.remv()
  "call self.eval()
  "call self.extd()

"endf "}
"fu! s:flux.remv() "{

  "for type in keys(self.data[self.name])
    "if type == self.type|continue|endif
    "let dict = self.data[self.name][type]
    "for key in keys(self.content)
      "if has_key(dict,key)|call remove(dict,key)|endif
    "endfor
  "endfor

"endf "}
"fu! s:flux.extd() "{

  "let key = keys(self.content)
  "let key = len(key) == 1 ? key[0] : ''
  "if has_key(self.data[self.name].dict,key) && !empty(key)
    "call extend(self.data[self.name].dict[key],self.content[key])
  "else
    "call extend(self.data[self.name].dict,self.content)
  "endif

  "" [TODO-mdep]: multi-depth extend

"endf "}
"fu! s:flux.eval() "{

  "" loop over content values
  "" check if value is a variable reference
  "" find variable in s:data.strc for self.name
  "" get value of variable
  "" replace that value into self.content for that key

  "let s:data.dbug = 1

  ""if self.type == 'vars'
    ""for pair in items(self.content)
      ""echo matchstr(pair[1],'^\$\('.'[a-zA-Z0-9_]\+'.'\)')
    ""endfor
  ""endif

  ""for entry in keys(self.content)
    ""echo self.type entry self.content[entry]
  ""endfor
  ""echo '------------------'
  ""let s:dbug._show = 1

"endf "}

"" guards    {


"let s:name = 'nvpmflux'

"" }
"" classes   {

"let s:patt = {}
"let s:flux = {}
"let s:file = {}
"let s:data = {}
"let g:flux = {}
""   s:data  "{

"fu! s:data.init() "{
  "let self.strc = {}
  "let self.dbug = 0
"endf "}
"fu! s:data.show() "{

  "if !self.dbug|return|endif

  "let d = self.strc

  "for k1 in keys(self.strc)
    "echo k1
    "echo repeat(' ',len(k1)).'vars'
    "for k2 in keys(d[k1].vars) " over vars {
      "let s   = repeat(' ',len(k1)+len('vars'))
      "let key = string(k2)
      "let val = string(d[k1].vars[k2])
      "echo s.key.' = '.val
    "endfor "}
    "echo repeat(' ',len(k1)).'dict'
    "for pair in items(d[k1].dict) " over dict {
      "let s   = repeat(' ',len(k1))
      "let key = string(pair[0])
      "let val = string(pair[1])
      "echo s .s.key ':' val
    "endfor "}
  "endfor

"endf "}

""}
""   s:patt  "{

"fu! s:patt.init() "{

  "" common patterns {

    "let eq = '='
    "let bl = '\['
    "let br = '\]'
    "let cm = ',*'
    "let pl = '\('
    "let pr = '\)*'
    "let s  = '\s*'
    "let b  = '^'
    "let e  = '$'

  ""}
  "" middle patterns {

    "let n1  = '[a-zA-Z0-9_]\+'
    "let n2  = '[a-zA-Z0-9_.]\+'
    "let v1  = '[a-zA-Z0-9_.#]\+'
    "let s   = '\s*'
    "let d   = '\$\='
    "let v   = d.v1

    "" TODO: see it for this case 'var = [fg=abg=a,md=a]'
    "let vars1 = pl. s.n1.s . eq . s.v.s . cm .pr
    "let vars2 =     s.n2.s . eq . s.bl.s. vars1 . s. br

  "" }
  "" object patterns {

    "let self._flux = b. 'flux'.s. '\(' .n1. '\).*' .e
    "let self._vars = b. vars1                      .e
    "let self._dict = b. vars2                      .e
    "let self._end  = b. '\s*end.*'                 .e
    "let self._endf = '---'
    "let self.n1 = n1
    "let self.n2 = n2
    "let self.v1 = v1

  "" }

"endf "}
"fu! s:patt.flux() "{

  "let match = matchlist(s:file.line,self._flux)
  "if empty(match)|return 1|endif
  "let s:flux.content = match[1]
  "return 0

"endf "}
"fu! s:patt.vars() "{

  "let match = matchstr(s:file.line,self._vars)
  "if empty(match)|return 1|endif
  "let s:flux.content = match
  "call self.brac()
  "return 0

"endf "}
"fu! s:patt.dict() "{

  "let match = matchstr(s:file.line,self._dict)
  "if empty(match)|return 1|endif

  "let match = split(match,'\s*=\s*[\s*')
  "let name  = trim(match[0])
  "if  name[0] == '.'|return 1|endif
  "let s:flux.content = substitute(match[1],']','','')
  "call self.brac()

  "let sname = split(name,'\.')
  "if  sname[0] != name
    "let s = '{'
    "let l = len(sname)
    "while !empty(sname)
      "let n = remove(sname,0)
      "let s .= "'".n ."':{"
    "endwhile
    "let s = s[:-2]
    "let s.= string(s:flux.content)
    "let s.= repeat('}',l) " }
    "exec 'let s:flux.content = '.s
  "else
    "let s:flux.content = {name:s:flux.content}
  "endif
  "return 0

"endf "}
"fu! s:patt.brac() "{

  "let pair = split(s:flux.content,',')
  "let dict = {}
  "for item in pair
    "let item = split(item,'=')
    "let  key = len(item) >= 1 ? trim(item[0]) : ''
    "let  val = len(item) == 2 ? trim(item[1]) : ''
    "if empty(key)|continue|endif
    "let dict[key] = val
  "endfor

  "let s:flux.content = dict
"endf "}
"fu! s:patt.iend() "{
  "return !empty(matchstr(s:file.line,self._end))
"endf "}
"fu! s:patt.endf() "{
  "return !empty(matchstr(s:file.line,'^\s*'.self._endf.'\s*$'))
"endf "}

""}
""   s:flux  "{

"fu! s:flux.init() "{

  "let self.type = ''
  "let self.data = s:data.strc

"endf "}
"fu! s:flux.flux() "{

  "if s:patt.flux()|return|endif

  "let self.name = self.content
  "let self.data[self.name]      = {}
  "let self.data[self.name].vars = {}
  "let self.data[self.name].dict = {}

  "while !s:patt.iend() && !s:patt.endf()
    "call self.vars()
    "call self.dict()
    "call s:file.next()
  "endwhile

"endf "}
"fu! s:flux.vars() "{

  "if s:patt.vars()|return|endif
  "let self.type = 'vars'
  "call self.remv()
  "call self.eval()
  "call extend(self.data[self.name].vars,self.content)

"endf "}
"fu! s:flux.dict() "{

  "if s:patt.dict()|return|endif
  "let self.type = 'dict'
  "call self.remv()
  "call self.eval()
  "call self.extd()

"endf "}
"fu! s:flux.remv() "{

  "for type in keys(self.data[self.name])
    "if type == self.type|continue|endif
    "let dict = self.data[self.name][type]
    "for key in keys(self.content)
      "if has_key(dict,key)|call remove(dict,key)|endif
    "endfor
  "endfor

"endf "}
"fu! s:flux.extd() "{

  "let key = keys(self.content)
  "let key = len(key) == 1 ? key[0] : ''
  "if has_key(self.data[self.name].dict,key) && !empty(key)
    "call extend(self.data[self.name].dict[key],self.content[key])
  "else
    "call extend(self.data[self.name].dict,self.content)
  "endif

  "" [TODO-mdep]: multi-depth extend

"endf "}
"fu! s:flux.eval() "{

  "" loop over content values
  "" check if value is a variable reference
  "" find variable in s:data.strc for self.name
  "" get value of variable
  "" replace that value into self.content for that key

  "let s:data.dbug = 1

  ""if self.type == 'vars'
    ""for pair in items(self.content)
      ""echo matchstr(pair[1],'^\$\('.'[a-zA-Z0-9_]\+'.'\)')
    ""endfor
  ""endif

  ""for entry in keys(self.content)
    ""echo self.type entry self.content[entry]
  ""endfor
  ""echo '------------------'
  ""let s:dbug._show = 1

"endf "}

""}
""   s:file  "{

"fu! s:file.init() "{

  "let self.path    = ''
  "let self.line    = ''
  "let self.lines   = []

"endf "}
"fu! s:file.read() "{

  "if filereadable(self.path)
    "let self.lines = readfile(self.path)
    "let self.lines+= [s:patt._endf]
  "else
    "call s:mesg()
    "return 1
  "endif
  "return empty(self.lines)

"endf "}
"fu! s:file.next() "{
  "let self.line = trim(remove(self.lines,0))
  "return 1
"endf "}

""}

""}
"" interface {

"fu! g:flux.init() "{
  "let self.path = ''
  "let self.data = s:flux.data
  "let self.vers = 'v0.0.0'
"endf "}
"fu! g:flux.read() "{

  "let s:file.path = self.path
  "if  s:file.read()|return|endif

  "while !s:patt.endf()
    "call s:file.next()
    "call s:flux.flux()
  "endwhile

"endf "}
"fu! g:flux.test() "{

  "execute 'source '.expand("<sfile>:p:h").'/plug/'.s:name.'.vim'
  "let g:flux.path = 'inpt/flux.inp'
  "call g:flux.read()
  "call s:data.show()
  
"endf "}

""}
"" helpers   {

"fu! s:mesg() "{

  "echohl NVPMFluxTitle
  "echon 'NVPM FLUX'
  "echohl None
  "echon ': Unable to read file '
  "echohl SpellBad
  "echon s:file.path
  "echohl None

"endf "}

"" }
"" inits     {

"call s:data.init()
"call s:file.init()
"call s:patt.init()
"call s:flux.init()
"call g:flux.init()

"" }
"" debuging  {

"let s:dbug = {}

"fu! s:dbug.test() "{

  "execute 'source '.expand("<sfile>:p:h").'/plug/'.s:name.'.vim'
  "let g:flux.path = 'inpt/flux.inp'
  "call g:flux.read()
  "call s:data.show()

"endf "}


"" }
"" commands  {

"command! NVPMFluxVers echo g:flux.vers
""command! NVPMTest call s:dbug.test()

"" }

" }
