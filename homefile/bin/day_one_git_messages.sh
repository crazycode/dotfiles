#!/usr/bin/env sh
repos='/Users/tanglq/adxage/adxplatform /Users/tanglq/space/hyshi'

for repoPath in $repos
do
    cd $repoPath
    logs=`git log --since=6am`
    if [ -n "$logs" ]; then
        echo "Found logs @ $repoPath"
        echo "Commits for $repoPath\\n $logs" # | dayone -d="today" new
    fi
done
