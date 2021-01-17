" I map X in vimrc to close windows/vim. This makes it work with NerdTree.
" It's important to put this file in ~/.vim/nerdtree_plugin even if that dir
" doesn't yet exist and even if you use a plugin manager.
"
" I create 2 maps, since I need an explict 'DirNode' map in order
" for this to work if my cursor is on a directory line. 
" 'scope': 'all' doesn't work for directories.

fun! s:CloseNT()
    " Avoid "Cannot close last window"
    if len(getbufinfo({'buflisted':1})) == 1
        :q
    else
        NERDTreeClose
    endif
endfun

fun! MYNTCB(dirnode) 
    call s:CloseNT()
endfun

fun! MYNTCB2() 
    call s:CloseNT()
endfun

call NERDTreeAddKeyMap({
       \ 'key': 'X',
       \ 'callback': "MYNTCB",
       \ 'scope': 'DirNode',
       \ 'override': 1,
       \ 'quickhelpText': 'close NerdTree' })

call NERDTreeAddKeyMap({
       \ 'key': 'X',
       \ 'callback': "MYNTCB2",
       \ 'scope': 'all',
       \ 'override': 1,
       \ 'quickhelpText': 'close NerdTree' })
