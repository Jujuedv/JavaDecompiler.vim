" File:         procyon.vim
" Purpose:      Vim plugin for viewing decompiled class files using 'procyon' decompiler.
" Ideas:        Allow for a default to be set in the vimrc
"               - map a keystroke to decompile and edit, or decompile and view in split window
" Date Created: 10-14-2002
" Last Modified:10-22-2002
" Version:      1.3

if exists("loaded_procyon") || &cp || exists("#BufReadPre#*.class")
  finish
endif
let loaded_procyon = 1

augroup class
  " Remove all procyon autocommands
  au!
  " Enable editing of procyoned files
  " set binary mode before reading the file
  " add your preferable flags after "procyon" (for instance "procyon -f -dead -ff -a")
  autocmd BufReadPre,FileReadPre	*.class  set bin
  autocmd BufReadPost,FileReadPost	*.class  call s:read("procyon-decompiler -ln")
augroup END

" After reading decompiled file: Decompiled text in buffer with "cmd"
fun s:read(cmd)
  " make 'patchmode' empty, we don't want a copy of the written file
  let pm_save = &pm
  set pm      =
  " set 'modifiable'
  set ma
  " when filtering the whole buffer, it will become empty
  let empty   = line("'[") == 1 && line("']") == line("$")
  let procyonfile = expand("<afile>:r") . ".procyon"
  let orig    = expand("<afile>")
  " now we have no binary file, so set 'nobinary'
  set nobin
  "Split and show code in a new window
  g/.*/d
  execute "silent r !" a:cmd . " " . orig
  1
  " set file name, type and file syntax to java
  execute ":file " . procyonfile
  set ft      =java
  set syntax  =java
  " recover global variables
  let &pm     = pm_save
endfun
