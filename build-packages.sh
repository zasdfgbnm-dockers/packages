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

make_package basic

git init
git remote add origin git@github.com:zasdfgbnm-dockers/packages.git
git checkout --orphan gh-pages
git add .
git commit -m "update"
git push --force -u origin gh-pages
