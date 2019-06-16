"TODO:
"1. Rename window
"2. Kill by pid
"mark for killing (special column or syntax highligh)
"3. Cycle window by cursor and move window_manager with it
"4. Move window to desktop (increasing,decreasing the desktop number)
"xdotool get_num_desktops
"set_desktop_for_window [window_ID] desktop_number-1
"5. Select windows for actions

"Rename started window manager window
silent !wmctrl -r :ACTIVE: -T window_manager

"vimwmctrl#ActivateWindow activate window under cursor
function! vimwmctrl#ActivateWindow()
	let l:curline=getline('.')
	let l:sp=split(l:curline,'\t\t\t\t')
	let l:mvmanager='wmctrl -r :ACTIVE: -t ' . l:sp[0]
	"exe system(l:mvmanager)
	let l:mvdesktop='wmctrl -s' . l:sp[0]
	"exe system(l:mvdesktop)
	"let l:activatewindow='wmctrl -a' . l:sp[1]
	let l:activatewindow='xdotool windowactivate ' . l:sp[1]
	"echo l:activatewindow
	exe system(l:activatewindow)
endfunction

function vimwmctrl#ActivateWindowKillManager()
	let l:curline=getline('.')
	exe vimwmctrl#ActivateWindow()
	:q!
endfunction
nnoremap <buffer> <CR> :call vimwmctrl#ActivateWindowKillManager()<CR>

function vimwmctrl#MakeList()
	"Substitute double spaces
	let l:cmda="wmctrl -lpx | sed -E 's/[ ]+/ /g'"
	" Quotes must be escaped \"\t\"
	"Substitute spaces with tabs, only for first 5 fields
	let l:cmdb= " | perl -pe '\$count = 0; s/ /(++\$count < 6)?\"\t\":\$&/ge'"
	"Select and format fields
	"let l:cmdc=" | awk -F '\t' '{gsub(\".*\\.\", \"\" ,$4); printf \"\%2d \%5d \%s \\\"%s\\\" \\n\",$2,$3,$4,$6}'"
	let l:cmdc=" | awk -F '\t' '{gsub(\".*\\.\", \"\" ,$4); printf \"\%2d \%5d \%s \\\"%s\\\" \t\t\t\t\%s \\n\",$2,$3,$4,$6,$1}'"
	"Run the command and put output to list
	let l:cmdo=systemlist(l:cmda .  l:cmdb . l:cmdc)
	set nowrap
	0put=l:cmdo
	2,$! sort

	"Color the output
	syn match programtype "\(^..\s\+\S\+\)\zs.*" contains=pname
	hi programtype ctermfg=Red
	"syn match pname "\(\S\+\)\zs.\+ " contained
	syn match pname "\(\S\+\)\zs.\+ \ze\t" contained
	hi pname ctermfg=Green

endfunction
silent exe vimwmctrl#MakeList()

nnoremap <buffer> l :call vimwmctrl#ActivateWindow()<CR>
nnoremap <buffer> q :q!<CR>


