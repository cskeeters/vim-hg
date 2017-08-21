if exists("loaded_hg")
  finish
endif
let loaded_hg = 1


function! s:HgParLineNo(lineno)
    let curr_diff = 0
    let in_diff = 0
    let in_line = 0
    call system("hg diff ".shellescape(expand("%"))." > /tmp/hg_annotate_diff")

    for line in readfile("/tmp/hg_annotate_diff")
        if in_diff == 0
            let m = matchlist(line, '\v\@\@ -([0-9]+),([0-9]+) +\+([0-9]+),([0-9]+) \@\@')
            if len(m) > 0
                let diff_start = m[3]
                let diff_end = m[3] + m[4] - 1

                if a:lineno < l:diff_start
                    "echom a:lineno." less than start:".l:diff_start
                    break
                endif
                if a:lineno <= l:diff_end
                    "echom a:lineno." less than end:".l:diff_end
                    let in_diff=1
                    let in_line=l:diff_start
                endif

                if a:lineno > l:diff_end
                    let hunk_diff = m[4] - m[2]
                    let curr_diff += hunk_diff
                    "echom "Hunk has diff".hunk_diff.' cur:'.curr_diff
                endif
            endif
        else
            "echo "line ".in_line." ".curr_diff
            let m = matchlist(line, '\v^([\-\+]).*')
            if len(m) > 0
                if m[1] == "+"
                    let curr_diff += 1
                    "echo "found add ".curr_diff
                endif
                if m[1] == "-"
                    let curr_diff -= 1
                    let in_line -= 1
                    "echo "found sub ".curr_diff
                endif
                if in_line == a:lineno
                    "not known for sure where this line came from
                    return 0
                endif
            else
                "echo "no line match ".in_line." ".curr_diff
                if in_line == a:lineno
                    break
                endif
            endif
            let in_line += 1
        endif
    endfor

    call system("rm /tmp/hg_annotate_diff")
    return a:lineno - curr_diff
endfunction

function! s:HgAnnotate()
    let lineno = line('.')
    let par_line_no = s:HgParLineNo(lineno)
    "echo lineno."->".par_line_no

    if par_line_no == 0
        echo "That line has been modified in the current directory"
    else
        let annotated_line = split(system("hg blame ".shellescape(expand("%"))." | sed -ne '".par_line_no." p'"), '\n')[0]
        if v:shell_error != 0
            echo "Error running blame"
        else
            let m = matchlist(annotated_line, '\v^[ ]*([0-9]+):[ \t]*(.*)')
            if len(m) > 0
                let rev = m[1]
                let text = m[2]

                let output = [text, '']
                "echo output

                " this is nice because it doesn't rely on chad_text, but the
                " add/modified file list won't be nice
                "let log = split(system("hg --config defaults.log= log --template '{rev} - {date|shortdate} - {author|user} - {desc|firstline|strip}\\n' -r ".rev), '\n')

                "echo output
                let log = split(system("hg --config defaults.log=  log --style=chad_text -vr ".rev), '\n')
                let output += log

                let output += ['', '']
                let diff = split(system("hg --config defaults.diff=  diff -c ".rev." ".shellescape(expand("%"))), '\n')
                let output += diff

                let output += ['', '']
                let log = split(system("hg --config defaults.log=  log --style=chad_text ".shellescape(expand("%"))), '\n')
                let output += log

                "botright split __HG__
                botright edit __HG__
                setl modifiable
                call setline(1, output)
                call cursor(3, 1)
                normal mr
                setl buftype=nofile
                setl noswapfile
                setl nomodifiable
                setl filetype=hg
                nmap <buffer> gd <Plug>HgDiff
            else
                echo "error matching output of blame: ".annotated_line
            endif
        endif
    endif
endfunction

function! s:HgDiff()
    let line = getline('.')
    let m = matchlist(line, '\v^([0-9]+)')
    if len(m) > 0
        let rev = m[1]

        let diff = split(system("hg --config defaults.diff=  diff --color=never -c ".rev), '\n')
        only
        botright edit __DIFF__
        setl modifiable
        call setline(1, diff)
        norm gg
        setl buftype=nofile
        setl noswapfile
        setl nomodifiable
        setf diff
    else
        echo "ERROR: Could not get revision for diff from line: ".line
    endif
endfunction

noremap <unique> <script> <Plug>HgAnnotate  <SID>HgAnnotate
noremap <SID>HgAnnotate :call <SID>HgAnnotate()<cr>
noremenu <script> Plugin.HgAnnotate <SID>HgAnnotate
command! -nargs=0 HgAnnotate call s:HgAnnotate()

noremap <unique> <script> <Plug>HgDiff  <SID>HgDiff
noremap <SID>HgDiff :call <SID>HgDiff()<cr>
noremenu <script> Plugin.HgDiff <SID>HgDiff
command! -nargs=0 HgDiff call s:HgDiff()
