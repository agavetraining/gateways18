#!/usr/bin/env bash

AGAVE_VARS="$(env | grep '^AGAVE_')"

export AGAVE_CACHE_DIR=${AGAVE_CACHE_DIR:-/home/opencpu/work/.agave}

# ensure cache dir is present
mkdir -p "$AGAVE_CACHE_DIR"

touch "$AGAVE_CACHE_DIR/current"

chown -R opencpu:www-data $AGAVE_CACHE_DIR


# if there are Agave environment variables set,
# clear all Agave environment variables from the
# current ~/.Renviron file and add the ones
# from the current environment
if [ -n "$AGAVE_VARS" ]; then
  # if the file exists, clear out the old vars, add the new
  if [ -e "/etc/opencpu/Renviron" ]; then
    sed -i 's/^AGAVE.*//g' /etc/opencpu/Renviron
    sed -i 's/^AGAVE.*//g' /home/opencpu/.Renviron
  fi

  for i in `env | grep '^AGAVE_'`; do
    echo "export $i"
    echo "$i" >> /etc/opencpu/Renviron
    echo "$i" >> /home/opencpu/.Renviron
  done

fi

# if the client needs bootstraped, do so here
if [[ -n "$BOOTSTRAP_AGAVE_CLIENT" ]]; then

  su - opencpu -c "R -f /AgaveBootstrap.r"

fi


# RUn the given command, or start apache if no command was given
if [[ -n "$@" ]]; then

  eval "$@"

else

  # start cron & apache
  service cron start && apachectl -DFOREGROUND

fi