
set backspace=indent,eol,start
set history=50                  " keep 50 lines of command line history
set ruler                       " show the cursor position all the time
set showcmd                     " display incomplete commands
set incsearch                   " do incremental searching
set browsedir=buffer            " To get the File / Open dialog box to default to the current file's directory
set number                      " nie wy.wietlaj nr linii
setlocal number                 " pierwszy odpalony bufor ma nrki
set wildmenu                    " wy.wietlaj linie z menu podczas dope.niania
set showmatch                   " pokaz otwieraj.cy nawias gdy wpisze zamykaj.cy
set so=5                        " przewijaj juz na 5 linii przed ko.cem
set statusline=%y[%{&ff}]\ \ ASCII=\%03.3b,HEX=\%02.2B\ %=%m%r%h%w\ %1*%F%*\ %l:%v\ (%p%%)
set laststatus=2                " zawsze pokazuj lini. statusu
set fo=tcrqn                    " opcje wklejania (jak maja by. tworzone wci.cia itp.)
set hidden                      " nie wymagaj zapisu gdy przechodzisz do nowego bufora
set tags+=./stl_tags            " tip 931
set foldtext=MojFoldText()      " tekst po zwini.ciu zak.adki
set foldminlines=3              " minimum 3 linie aby powsta. fold

set ts=4
set expandtab
set shiftwidth=4
set nosmartindent
