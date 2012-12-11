syn clear gnuplotComment

syn region gnuplotComment   start="#" end="$"
syn region gnuplotString   start=+"+ skip=+\\"+ end=+"+
syn region gnuplotString   start=+'+        end=+'+

hi link gnuplotString  Special





