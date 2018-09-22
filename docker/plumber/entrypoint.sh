#!/usr/bin/env bash

AGAVE_VARS="$(env | grep '^AGAVE_')"

export AGAVE_CACHE_DIR=${AGAVE_CACHE_DIR:-$HOME/.agave}

# ensure cache dir is present
mkdir -p "$AGAVE_CACHE_DIR"

touch "$AGAVE_CACHE_DIR/current"


# if there are Agave environment variables set,
# clear all Agave environment variables from the
# current ~/.Renviron file and add the ones
# from the current environment
if [ -n "$AGAVE_VARS" ]; then
  # if the file exists, clear out the old vars, add the new
  if [ -e "/etc/opencpu/Renviron" ]; then
    sed -i 's/^AGAVE.*//g' $HOME/.Renviron
  fi

  for i in `env | grep '^AGAVE_'`; do
    echo "export $i"
    echo "$i" >> $HOME/.Renviron
  done

fi

# if the client needs bootstraped, do so here
if [[ -n "$BOOTSTRAP_AGAVE_CLIENT" ]]; then

  R -f /AgaveBootstrap.r

fi


# Startup the plumber server passing in the given command
R -e "pr <- plumber::plumb('$@')" \
  -e "pr\$run(host='0.0.0.0', port=9300)"
