#!/bin/bash

# 更新所有svn
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
  if [ -d $gitdir/.git/svn/refs ]; then
      echo " -----> it's git svn"
      if  [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]];
      then
          echo "PLEASE COMMIT YOUR CHANGE FIRST!!!"
          exit 1
      fi
      git svn rebase
  else
      echo " #####> it's git root"
      git fetch
  fi
  # 检查是不是git svn
done

# 检查svn版本
#$ ls .svn  v1.8.x
#entries  format  pristine  tmp  wc.db
#$ ls src/.svn  v1.7
#all-wcprops  entries  prop-base  props  text-base  tmp
