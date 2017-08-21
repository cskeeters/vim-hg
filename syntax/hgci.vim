if exists("b:current_syntax")
   echo "finishing"
   finish
endif

syn keyword hgciKeyword contained HG

syn match hgciSep contained +:+

syn match hgciComment contained +.*+ skipwhite
syn region hgciCommentRegion start=/^HG:/ end=+$+ contains=hgciKeyword,hgciSep,hgciComment oneline

syn match hgciUser contained +.*+ skipwhite
syn match hgciUserSep contained +:+ nextgroup=hgciUser
syn match hgciUserLabel contained +user+ nextgroup=hgciUserSep skipwhite
syn region hgciUserRegion start=/\vHG: user:/ end=+$+ contains=hgciKeyword,hgciSep,hgciUserLabel oneline

syn match hgciBranch contained +[^']*+ skipwhite
syn match hgciBranchLabel contained +branch '+ nextgroup=hgciBranch skipwhite
syn region hgciBranchRegion start=/\vHG: branch '/ end=+$+ contains=hgciKeyword,hgciSep,hgciBranchLabel oneline

syn match hgciAdded contained +added .*+ skipwhite
syn region hgciAddedRegion start=/^HG: added / end=+$+ contains=hgciKeyword,hgciSep,hgciAdded oneline

syn match hgciChanged contained +changed .*+ skipwhite
syn region hgciChangedRegion start=/^HG: changed / end=+$+ contains=hgciKeyword,hgciSep,hgciChanged oneline

syn match hgciRemoved contained +removed .*+ skipwhite
syn region hgciRemovedRegion start=/^HG: removed / end=+$+ contains=hgciKeyword,hgciSep,hgciRemoved oneline

hi default link hgciComment Comment
hi default link hgciSep Comment

hi default link hgciKeyword Keyword
hi default link hgciUser String
hi default link hgciBranch Include

hi default link hgciAdded String
hi default link hgciChanged Label
hi default link hgciRemoved Identifier
