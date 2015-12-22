
#!/bin/bash
mv $1 $1.bkp
#gs -o $1 -sDEVICE=pdfwrite -sFONTPATH="$HOME/Utils/fonts/" -dNOPLATFONTS -dPDFSETTINGS=/prepress -dCompatibilityLevel=1.5 -dEmbedAllFonts=true $1.bkp
gs -o $1 -sDEVICE=pdfwrite -dNOPLATFONTS -dPDFSETTINGS=/prepress -dCompatibilityLevel=1.5 -dEmbedAllFonts=true $1.bkp

