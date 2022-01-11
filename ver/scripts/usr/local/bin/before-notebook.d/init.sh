#!/bin/bash
# Copyright (c) 2020 b-data GmbH.
# Distributed under the terms of the MIT License.

set -e

# Set defaults for environment variables in case they are undefined
LANG=${LANG:=en_US.UTF-8}
TZ=${TZ:=Etc/UTC}

if [ "$(id -u)" == 0 ] ; then
  # Update timezone if needed
  if [ "$TZ" != "Etc/UTC" ]; then
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
      && echo $TZ > /etc/timezone
  fi

  # Add/Update locale if needed
  if [ ! -z "$LANGS" ]; then
    for i in $LANGS; do
      sed -i "s/# $i/$i/g" /etc/locale.gen
    done
  fi
  if [ "$LANG" != "en_US.UTF-8" ]; then
    sed -i "s/# $LANG/$LANG/g" /etc/locale.gen
  fi
  if [[ "$LANG" != "en_US.UTF-8" || ! -z "$LANGS" ]]; then
    locale-gen
  fi
  update-locale --reset LANG=$LANG

  # Install user-specific startup files for Julia REPL and IJulia
  su $NB_USER -c "mkdir -p .julia/config"
  if [[ ! -f ".julia/config/startup_ijulia.jl" ]]; then
    su $NB_USER -c "echo -e 'Pkg.activate()\n\ntry\n    @eval using Revise\ncatch e\n    @warn(e.msg)\nend\n\nPkg.activate(\"\$(ENV[\"HOME\"])/.julia/environments/v\$(VERSION.major).\$(VERSION.minor)\")' > \
    .julia/config/startup_ijulia.jl"
  fi
  if [[ ! -f ".julia/config/startup.jl" ]]; then
    su $NB_USER -c "echo -e 'println(\"Executing user-specific startup file (\", @__FILE__, \")...\")\n\ntry\n    using Revise\n    println(\"Revise started\")\ncatch\n    @warn(\"Could not load Revise\")\nend\n\nPkg.activate(\"\$(ENV[\"HOME\"])/.julia/environments/v\$(VERSION.major).\$(VERSION.minor)\")' > \
    .julia/config/startup.jl"
  fi

  # Update code-server settings
  su $NB_USER -c "mv .local/share/code-server/User/settings.json \
    .local/share/code-server/User/settings.json.bak"
  su $NB_USER -c "sed -i ':a;N;$!ba;s/,\n\}/\n}/g' \
    .local/share/code-server/User/settings.json.bak"
  su $NB_USER -c "jq -s '.[0] * .[1]' /var/tmp/settings.json \
    .local/share/code-server/User/settings.json.bak > \
    .local/share/code-server/User/settings.json"
else
  # Warn if the user wants to change the timezone but hasn't run the container
  # as root.
  if [ "$TZ" != "Etc/UTC" ]; then
    echo "Container must be run as root to change timezone"
  fi

  # Warn if the user wants to change the timezone but hasn't run the container
  # as root.
  if [[ "$LANG" != "en_US.UTF-8" || ! -z "$LANGS" ]]; then
    echo "Container must be run as root to update or add locale"
  fi

  # Install user-specific startup files for Julia REPL and IJulia
  mkdir -p .julia/config
  if [[ ! -f ".julia/config/startup_ijulia.jl" ]]; then
    echo -e 'Pkg.activate()\n\ntry\n    @eval using Revise\ncatch e\n    @warn(e.msg)\nend\n\nPkg.activate("$(ENV["HOME"])/.julia/environments/v$(VERSION.major).$(VERSION.minor)")' > \
    .julia/config/startup_ijulia.jl
  fi
  if [[ ! -f ".julia/config/startup.jl" ]]; then
    echo -e 'println("Executing user-specific startup file (", @__FILE__, ")...")\n\ntry\n    using Revise\n    println("Revise started")\ncatch\n    @warn("Could not load Revise")\nend\n\nPkg.activate("$(ENV["HOME"])/.julia/environments/v$(VERSION.major).$(VERSION.minor)")' > \
    .julia/config/startup.jl
  fi

  # Update code-server settings
  mv .local/share/code-server/User/settings.json \
    .local/share/code-server/User/settings.json.bak
  sed -i ':a;N;$!ba;s/,\n\}/\n}/g' \
    .local/share/code-server/User/settings.json.bak
  jq -s '.[0] * .[1]' /var/tmp/settings.json \
    .local/share/code-server/User/settings.json.bak > \
    .local/share/code-server/User/settings.json
fi

# Remove old .zcompdump files
rm -f .zcompdump*
