#!/usr/bin/xonsh
import contextlib
import os

WORKSPACE = $PWD
DIR = os.path.join(WORKSPACE, 'tmp')
installed = set()
sudo pacman -Sy


@contextlib.contextmanager
def yaourt_guard():
    """yaourt uses $ARGS, we must delete it temporarily to avoid collision"""
    save = $ARGS
    del $ARGS
    yield
    $ARGS = save


@contextlib.contextmanager
def enter_once(directory):
    """enter a directory, when done, delete it"""
    save = $PWD
    mkdir -p @(directory)
    cd @(directory)
    yield
    cd @(save)
    rm -rf @(directory)


def list_packages():
    l = $(ls *.pkg.tar.zst).strip().split()
    result = set()
    for p in l:
        try:
            i = len(p)
            for _ in range(3):
                i -= 1
                while p[i] != '-':
                    i -= 1
            result.add(p[:i])
        except IndexError:
            pass
    return result


def yaourt_package(pkgname, stack):
    print(f"==> Building {pkgname}")
    with yaourt_guard():
        yaourt -G @(pkgname)

    with enter_once(pkgname):
        yaourt_deps('PKGBUILD', stack)
        if pkgname in installed:
            return
        makepkg -s --noconfirm
        sudo pacman -U --noconfirm *.pkg.*
        cp *.pkg.* @(DIR)
        for p in list_packages():
            installed.add(p)


def yaourt_deps(filename, stack):
    deps=$(makepkg -p @(filename) --printsrcinfo | awk '{$1=$1};1' | grep -oP '(?<=^depends = ).*')
    for d in deps.strip().split():
        blacklist = ['>=', '>', '<=', '<', '==']
        for b in blacklist:
            if b in d:
                d = d.split(b)[0]
        d = d.strip()
        if $(pacman -Ss @(f"^{d}$")).strip() == "" and d not in installed and d not in stack:
            print(f"==> Recursively building {d}")
            stack.add(d)
            yaourt_package(d, stack)


def make_package(pkgname):
    print(f"==> Building {pkgname}")
    cp -r @(f"{WORKSPACE}/{pkgname}") @(pkgname)
    with enter_once(pkgname):
        makepkg -d
        rm -rf pkg src
        cp *.pkg.* @(DIR)
        yaourt_deps('PKGBUILD', set())


def upload():
    git init
    git remote add origin git@github.com:zasdfgbnm-dockers/packages.git
    git checkout --orphan gh-pages
    git add .
    git status
    git commit -m "update"
    git push --force -u origin gh-pages


with enter_once(DIR):
    print(f"==> Generating packages at {DIR}")

    make_package("basic")
    make_package("desktop-small")
    make_package("desktop")

    repo-add zasdfgbnmsystem.db.tar.gz *.pkg.*
    tree -H '.' -L 1 --noreport --charset utf-8 > index.html

    ls -lah

    upload()
