#!/usr/bin/env sh

run_script () {
  local script=$1
  eval $(head -n1 $script)
  filename="${script##*/}"
  appname="${filename%.*}"
  echo "${indent}${appname}:"
  indent="$indent  "
  if type $appname >/dev/null 2>&1; then
    echo "\033[0;36m${indent}${appname} is already installed.\033[0;39m"
    echo -n "${indent}clean install? [y/N]: "
    read ans
    case $ans in
      [Yy]* )
        . $script
        echo "${indent}clean installing ${appname}..."
        remove_app
        install_app
        res=$?
        ;;
      * )
        res=0
        ;;
    esac
    indent=$(echo $indent | sed 's/  //')
    return $res
  fi
  echo -n "${indent}install ${appname}? [Y/n]: "
  read ans
  case $ans in
    "" | [Yy]* )
      ;;
    * )
      return 0
      ;;
  esac
  for dep in $(echo $deps | tr ',' ' '); do
    run_script "install/${dep}.sh"
    if [ $? -ne 0 ]; then
      echo "${indent}\033[0;31mfailed to install ${dep}\033[0;39m"
      return 1
    fi
    echo "${indent}\033[0;32m✔︎ install ${dep} done\033[0;39m"
  done
  . $script
  echo "${indent}installing ${appname}..."
  indent=$(echo $indent | sed 's/  //')
  install_app
  return $?
}

MAIN () {
  . ./pkgmgr.sh
  indent=''
  for script in install/*.sh; do
    echo '--------------------------------------------'
    run_script $script
    if [ $? -ne 0 ]; then
      echo "${indent}\033[0;31mFailed :(\033[0;39m"
    else
      echo "${indent}\033[0;32mDone :)\033[0;39m"
    fi
  done
}

MAIN
