#!/bin/bash
for i in $(ls); do
  if [[ -d $i ]]; then
      if [[ -f $i/pom.xml ]]; then
        cd $i
        pwd
        mvn clean
        cd ..
      fi
  fi
done
