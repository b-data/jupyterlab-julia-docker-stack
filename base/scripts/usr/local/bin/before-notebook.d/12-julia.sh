#!/bin/bash
# Copyright (c) 2020 b-data GmbH.
# Distributed under the terms of the MIT License.

set -e

if [ "$(id -u)" == 0 ] ; then
  # Create default environment folder for Julia
  run_user_group mkdir -p "/home/$NB_USER${DOMAIN:+@$DOMAIN}/.julia/environments/v${JULIA_VERSION%.*}"

  # Install user-specific startup files for Julia and IJulia
  run_user_group mkdir -p "/home/$NB_USER${DOMAIN:+@$DOMAIN}/.julia/config"
  if [[ ! -f "/home/$NB_USER${DOMAIN:+@$DOMAIN}/.julia/config/startup_ijulia.jl" ]]; then
    run_user_group cp -a --no-preserve=ownership /var/backups/skel/.julia/config/startup_ijulia.jl \
      "/home/$NB_USER${DOMAIN:+@$DOMAIN}/.julia/config/startup_ijulia.jl"
  fi
  if [[ ! -f "/home/$NB_USER${DOMAIN:+@$DOMAIN}/.julia/config/startup.jl" ]]; then
    run_user_group cp -a --no-preserve=ownership /var/backups/skel/.julia/config/startup.jl \
      "/home/$NB_USER${DOMAIN:+@$DOMAIN}/.julia/config/startup.jl"
  fi
else
  # Create default environment folder for Julia
  mkdir -p "$HOME/.julia/environments/v${JULIA_VERSION%.*}"

  # Install user-specific startup files for Julia and IJulia
  mkdir -p "$HOME/.julia/config"
  if [[ ! -f "$HOME/.julia/config/startup_ijulia.jl" ]]; then
    cp -a /var/backups/skel/.julia/config/startup_ijulia.jl \
      "$HOME/.julia/config/startup_ijulia.jl"
  fi
  if [[ ! -f "$HOME/.julia/config/startup.jl" ]]; then
    cp -a /var/backups/skel/.julia/config/startup.jl \
      "$HOME/.julia/config/startup.jl"
  fi
fi
