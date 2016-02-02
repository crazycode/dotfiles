#!/bin/bash
# 更新当前目录之下的所有svn和git库，拉取远端库变更.

# 更新所有svn, 建议升级到svn 1.8后使用，1.8以下.svn目录有重复.
ALL_DOT_SVN=$(find `pwd` -name .svn -type d)

for DOT_SVN in $ALL_DOT_SVN; do
  svndir=`dirname $DOT_SVN`
  echo "svn: $svndir"
  cd $svndir
  svn up
done

ALL_DOT_GIT=$(find `pwd` -name .git -type d)

for DOT_GIT in $ALL_DOT_GIT; do
  gitdir=`dirname $DOT_GIT`
  echo "git: $gitdir"
  cd $gitdir
  # 检查是不是git svn
  if [ -d $gitdir/.git/svn/refs ]; then
      echo " -----> it's git svn"
      if  [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]];
      then
          echo "PLEASE COMMIT YOUR CHANGE FIRST!!!"
          exit 1
      fi
      git svn rebase
  else
      # 只做fetch，以避免破坏
      echo " #####> it's git root"
      git fetch
  fi
done

