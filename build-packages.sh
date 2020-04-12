#!/usr/bin/bash

WORKSPACE=$PWD
DIR=$(mktemp -d)

echo generating packages at $DIR
cd $DIR

make_package() {
    cp $WORKSPACE/$1 $1
    makepkg -d -p $1
    rm -rf pkg src $1
}

yaourt_package() {
    yaourt -G $1
    cd $1
    makepkg -s
    cp $1*.pkg.* ..
    cd ..
    rm -rf $1
}

make_package basic
yaourt_package mkinitcpio-docker-hooks
yaourt_package fkill

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
