#!/usr/bin/bash

WORKSPACE=$PWD
DIR=$(mktemp -d)

echo generating packages at $DIR
cd $DIR

sudo pacman -Sy

yaourt_package() {
    yaourt -G $1
    cd $1
    makepkg -s --noconfirm
    cp $1*.pkg.* ..
    cd ..
    rm -rf $1
}

make_package() {
    cp $WORKSPACE/$1 $1
    makepkg -d -p $1
    rm -rf pkg src

    deps=$(makepkg -p $1 --printsrcinfo | grep -oP '(?<=depends = ).*')
    for d in $deps; do
        if [[ $(pacman -Ss ^$d$) == "" ]]; then
            yaourt_package $d
        fi
    done

    rm $1
}

make_package basic

ls -lah

repo-add zasdfgbnmsystem.db.tar.gz *.pkg.*
tree -H '.' -L 1 --noreport --charset utf-8 > index.html

git init
git remote add origin git@github.com:zasdfgbnm-dockers/packages.git
git checkout --orphan gh-pages
git add .
git status
git commit -m "update"
git push --force -u origin gh-pages
