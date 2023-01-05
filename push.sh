#!/bin/sh

# to install textlint, run the following command
# npm install textlint --global
# npm install textlint-rule-ja-space-between-half-and-full-width --global
cd ./content/posts/ || exit
textlint --fix .
cd ../..

date=$(date "+%Y-%m-%d %H:%m")
git add *
git commit -m "$date update"
git push
