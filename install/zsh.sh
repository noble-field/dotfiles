deps=curl,git

install_app () {
  sh -c "$(curl -fsSL get.zshell.dev)" -- -i skip -b main
}

update_app () {
  echo "${indent}update Z-Shell"
}

remove_app () {
  pm_remove zsh
}
