./git_setup.sh

rm -f minesweeper.zip
cd ..

zip -r minesweeper.zip minesweeper;
mv minesweeper.zip minesweeper/;


echo ""
echo "Your zip file lives in minesweeper.zip"
