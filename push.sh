#!/bin/sh

date="$(date +%Y-%m-%d %H:%M:%S)"
# npm install textlint --global
# npm install textlint-rule-ja-space-between-half-and-full-width --global
cd ./content/posts/ || exit
textlint --fix .
cd ../..
git add *
git commit -m "$date update"
git push
