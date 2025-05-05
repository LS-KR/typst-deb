#!/bin/bash

curl -s https://api.github.com/repos/typst/typst/releases/latest \
    | grep "https://.*x86_64.*linux.*.tar.xz" \
    | cut -d : -f 2,3 \
    | tr -d \" \
    | wget -qi -

fileName=$(curl -s https://api.github.com/repos/typst/typst/releases/latest | grep ".*x86_64.*linux.*.tar.xz\"," | cut -d : -f 2,3 | tr -d \" | tr -d ,)
printf "found release file: %s\n" $fileName

tar --xz -xvf $fileName

name=${fileName%.tar.xz}
name=$(echo $name | tr -d " ")
echo $name

mkdir typst
mkdir -p typst/usr/bin
mkdir -p typst/usr/share/doc/typst
mkdir -p typst/DEBIAN

cp -f "./${name}/typst" typst/usr/bin/typst
cp -f "./${name}/LICENSE" "./${name}/NOTICE" "./${name}/README.md" "typst/usr/share/doc/typst"
cp -f "DEBIAN/control" "typst/DEBIAN/control"

sudo dpkg -b ./typst

bash ./clean.sh