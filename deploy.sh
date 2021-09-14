#!/bin/sh

set -e

cabal run sigkill clean
cabal run sigkill build
cabal run sigkill deploy
git push
