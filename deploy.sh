#!/bin/sh

set -e

cabal exec sigkill clean
cabal exec sigkill build
cabal exec sigkill deploy
git push
