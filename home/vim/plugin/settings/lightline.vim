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
  \         [ 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_hints', 'linter_ok' ],
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

" Which component can be expanded by using which function
let g:lightline.component_expand={
  \    'linter_hints': 'lightline#lsp#hints',
  \    'linter_infos': 'lightline#lsp#infos',
  \    'linter_warnings': 'lightline#lsp#warnings',
  \    'linter_errors': 'lightline#lsp#errors',
  \    'linter_ok': 'lightline#lsp#ok',
  \ }

" How to color custom components
let g:lightline.component_type={
  \   'readonly': 'error',
  \   'linter_hints': 'right',
  \   'linter_infos': 'right',
  \   'linter_warnings': 'warning',
  \   'linter_errors': 'error',
  \   'linter_ok': 'right',
  \ }

" Show pretty icons instead of text for linting status
let g:lightline#lsp#indicator_hints='🔍'
let g:lightline#lsp#indicator_infos='ℹ'
let g:lightline#lsp#indicator_warnings='◆'
let g:lightline#lsp#indicator_errors='✗'
let g:lightline#lsp#indicator_ok='✓'


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
