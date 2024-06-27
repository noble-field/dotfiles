LOAD_PKGMGR () {
  if type apt >/dev/null 2>&1; then
    pkgmgr=apt
    echo 'apt updating...'
    sudo apt update >/dev/null 2>&1
    echo '\033[0;32m✔︎ apt update done\033[0;39m'
    pm_install () {
      sudo apt -y install $1 >/dev/null 2>&1
    }
    pm_upgrade () {
      sudo apt -y install --only-upgrade $1 >/dev/null 2>&1
    }
    pm_remove() {
      sudo apt remove $1 >/dev/null 2>&1
    }
  elif type yum >/dev/null 2>&1; then
    pkgmgr=yum
    pm_install () {
      sudo yum install -y $1 >/dev/null 2>&1
    }
    pm_upgrade () {
      sudo yum update $1 >/dev/null 2>&1
    }
    pm_remove () {
      sudo yum remove $1 >/dev/null 2>&1
    }
  elif type brew >/dev/null 2>&1; then
    pkgmgr=brew
    echo 'brew updating...'
    brew update >/dev/null 2>&1
    echo '\033[0;32m✔︎ brew update done\033[0;39m'
    pm_install () {
      yes | brew install $1 >dev/null 
    }
    pm_upgrade () {
      brew upgrade $1 >/dev/null 2>&1
    }
    pm_remove() {
      brew uninstall $1 >/dev/null 2>&1
    }
  else
    echo '\033[0;31mno package manager is found\033[0;39m'
    if [ $(uname) = 'Darwin' ]; then
      echo -n "install homebrew? [Y/n]: "
      read ans
      case $ans in
        "" | [Yy]* )
          /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
          LOAD_PKGMGR
          ;;
        * )
          echo '\033[0;31mplease install package manager\033[0;39m'
          exit 1
          ;;
      esac
    fi
  fi
}

LOAD_PKGMGR
