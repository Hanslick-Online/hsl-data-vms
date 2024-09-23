# bin/bash

rm -rf ./data/tmp
rm -rf ./data/pre-process
wget https://github.com/Hanslick-Online/hsl-transkribus-export/archive/refs/heads/main.zip
unzip main
mkdir ./data/pre-process
mkdir ./data/tmp
mv hsl-transkribus-export-main/tei/284592/*.xml ./data/pre-process
mv hsl-transkribus-export-main/mets/284592/*.xml ./data/facs
rm -rf hsl-transkribus-export-main
rm main.zip
