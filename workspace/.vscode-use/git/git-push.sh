#!/usr/bin/env bash

__git_push() {
    git rm -r --cached /config
    git add /config
    git commit -m "init"
    git branch -M main
    git push -f -u origin main
}

__git_push
