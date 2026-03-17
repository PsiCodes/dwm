#!/bin/sh

xrdb merge ~/.Xresources


export MOZ_USE_XINPUT2=1
export DISPLAY=:0
export CM_OWN_CLIPBOARD=1
export CM_SELECTIONS="clipboard secondary"
exec dwm