#!/bin/sh

set -e

stack exec sigkill clean
stack exec sigkill build
stack exec sigkill deploy
git push
