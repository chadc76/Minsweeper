./git_setup.sh

rm -f minsweeper.zip
cd ..

zip -r minsweeper.zip minsweeper;
mv minsweeper.zip minsweeper/;


echo ""
echo "Your zip file lives in minsweeper.zip"
