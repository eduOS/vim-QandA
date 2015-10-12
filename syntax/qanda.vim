if exists("b:current_syntax")
  finish
endif

syntax match Presenter "\v^TONY JONES:.*$"
highlight link Presenter Identifier

syntax match QuestionNum /\v^q\d{1,2}$/ nextgroup=Question skipwhite
syntax match Question /\v\n[A-Z ]*:.*$/ contained skipwhite
" how to match between lines
highlight link QuestionNum Keyword
highlight link Question Underlined

let b:current_syntax = "qanda"
