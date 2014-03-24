#!/bin/bash

# necessario colocar a chave publica no .ssh/authorized_keys da Manaus e da Cajarana

PAGE_PATH="/home/phd/maxiwell/public_html/cursos/mc911"

svn up /home/max/academico/doutorado/PedC_MC911_1s2014/page-mc911-1s2014/
ssh manaus "cp $PAGE_PATH/mc911.html $PAGE_PATH/.mc911.html.tmp"
rsync -razp --delete -e ssh  /home/max/academico/doutorado/PedC_MC911_1s2014/page-mc911-1s2014/* manaus:/home/phd/maxiwell/public_html/cursos/mc911

#Try ssh -t -t to force pseudo-tty allocation even if stdin isn't a terminal.
ssh  manaus PAGE_PATH=$PAGE_PATH 'bash -s' << 'ENDSSH'
if [ 0 -ne `diff $PAGE_PATH/mc911.html $PAGE_PATH/.mc911.html.tmp | wc -l` ]; then
	echo "Backing up the mc911.html..."
	cp $PAGE_PATH/.mc911.html.tmp $PAGE_PATH/.mc911.html.old
fi
rm $PAGE_PATH/.mc911.html.tmp
cd $HOME/public_html
git add -A
git commit -a -m "update cursos/mc911"
git push
ENDSSH


