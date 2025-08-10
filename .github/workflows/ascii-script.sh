#/bin/sh
sudo apt-get install cowsay -y
cowsay -f dragon "Run you fools" >> dragon.txt
grep -i "fools" dragon.txt
cat dragon.txt
ls -ltra