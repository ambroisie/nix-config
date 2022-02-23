" Initialise light-line setting structure
let g:lightline={}

" Use the wombat colorscheme
let g:lightline.colorscheme='wombat'

" Status-line for active buffer
let g:lightline.active={
  \     'left': [
  \         [ 'mode', 'paste' ],
  \         [ 'gitbranch', 'readonly', 'filename', 'modified' ],
  \         [ 'spell' ],
  \     ],
  \     'right': [
  \         [ 'lineinfo' ],
  \         [ 'percent' ],
  \         [ 'fileformat', 'fileencoding', 'filetype' ],
  \         [ 'ctags_status' ],
  \     ]
  \ }

" Status-line for inactive buffer
let g:lightline.inactive={
  \     'left': [
  \         [ 'filename' ],
  \     ],
  \     'right': [
  \         [ 'lineinfo' ],
  \         [ 'percent' ],
  \     ],
  \ }

" Which component should be written using which function
let g:lightline.component_function={
  \     'readonly': 'LightlineReadonly',
  \     'modified': 'LightlineModified',
  \     'gitbranch': 'LightlineFugitive',
  \ }

" How to color custom components
let g:lightline.component_type={
  \   'readonly': 'error',
  \ }

" Show a lock icon when editing a read-only file when it makes sense
function! LightlineReadonly()
    return &ft!~?'help\|vimfiler\|netrw' && &readonly ? '🔒' : ''
endfunction

" Show a '+' when the buffer is modified, '-' if not, when it makes sense
function! LightlineModified()
    return &ft=~'help\|vimfiler\|netrw' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

" Show branch name with nice icon in status line, when it makes sense
function! LightlineFugitive()
    if &ft!~?'help\|vimfiler\|netrw' && exists('*fugitive#head')
            let branch=fugitive#head()
            return branch!=#'' ? ' '.branch : ''
    endif
    return ''
endfunction
