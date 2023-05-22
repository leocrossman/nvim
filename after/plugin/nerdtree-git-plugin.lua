-- no nvim api
vim.cmd([[
let g:NERDTreeGitStatusIndicatorMapCustom = {
\ 'Modified'  :'✹',
\ 'Staged'    :'✚',
\ 'Untracked' :'✭',
\ 'Renamed'   :'➜',
\ 'Unmerged'  :'═',
\ 'Deleted'   :'✖',
\ 'Dirty'     :'✗',
\ 'Ignored'   :'☒',
\ 'Clean'     :'✔︎',
\ 'Unknown'   :'?',
\ }

let g:NERDTreeGitStatusUseNerdFonts = 1 " you should install nerdfonts by yourself. default: 0

let g:NERDTreeGitStatusShowIgnored = 0 " a heavy feature may cost much more time. default: 0

" let g:NERDTreeGitStatusUntrackedFilesMode = 'all' " a heavy feature too. default: normal

let g:NERDTreeGitStatusShowClean = 0 " default: 0

]])

