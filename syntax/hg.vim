if exists("b:current_syntax")
   echo "finishing"
   finish
endif

syn keyword fileChanges Modified Added Removed Copied

syn match addLine /\v^\+.*/
syn match subLine /\v^\-.*/
syn match diffAt /\v^\@\@ .* \@\@/

syn match graphCi contained /o/
syn match graphCur contained /@/

syn match sha contained /\v\i{12}/
syn match rev contained /[0-9]/

syn match description contained /\v.*/
syn match username contained /\v[a-zA-Z]+/ nextgroup=description skipwhite
syn match date contained /\v[0-9]+-[0-9]+-[0-9]+/ nextgroup=username skipwhite

syn match hgTag contained /\v[a-zA-Z0-9_\.]+/ nextgroup=tagSep
syn match branch contained /\v[a-zA-Z0-9_]+/ nextgroup=branchSep
syn match branchSep contained +/+ nextgroup=hgTag
syn match tagSep contained +,+ nextgroup=hgTag

syn region logPre start=/\v^/ end=+:+ contains=graphCi,graphCur,rev keepend oneline nextgroup=logPost
" Used contained on logPost so that it won't match unless logPre finishes matching
syn region logPost start=+.+ end=+$+ contained contains=sha,tags keepend oneline
syn region tags contained start=+\[+ skip=+t+ end=+\]+ contains=branch,hgTag nextgroup=date skipwhite
"syn region diff start=+^diff+ end=+RHEOIWNFLDSNFDOIWQQNLKLFD+ contains=addLine,subLine
syn region fileMod start=/\v^  M / end=+$+ oneline
syn region fileAdd start=/\v^  A / end=+$+ oneline
syn region fileDel start=/\v^  R / end=+$+ oneline

hi default link fileMod Directory
hi default link fileAdd String
hi default link fileDel Character

hi default link addLine String
hi default link subLine Character
hi default link diffAt Conditional

hi default link fileChanges Include
hi default link hgTag Include
hi default link branch Keyword
hi default link rev Identifier
hi default link sha String
hi default link description Label
hi default link date Comment
hi default link username String
hi default link graphCi Directory
hi default link graphCur Keyword
