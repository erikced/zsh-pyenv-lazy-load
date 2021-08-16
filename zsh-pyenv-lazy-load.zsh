if type pyenv &> /dev/null; then
  return
fi

_init_pyenv() {
  unset -f pyenv _pyenv_chpwd_hook _init_pyenv
  chpwd_functions[$chpwd_functions[(i)_pyenv_chpwd_hook]]=()

  if [[ ! "$PATH" == */.pyenv/bin* ]]; then
    export PATH="$HOME/.pyenv/bin:$PATH"
  fi
  eval "$(pyenv init --path)"
  eval "$(pyenv virtualenv-init -)"
}

pyenv() {
  _init_pyenv
  pyenv "$@"
}

_pyenv_chpwd_hook() {
  local DIR=$PWD
  while [ "$DIR" != "/" ]; do
    if [ -f "$DIR/.python-version" ]; then
      _init_pyenv
      break
    fi
    DIR=$DIR:h
  done
}

export chpwd_functions=($chpwd_functions _pyenv_chpwd_hook)
