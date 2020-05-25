#!/bin/bash
# Copyright (c) 2020 b-data GmbH.
# Distributed under the terms of the MIT License.

set -e

# Install Code Server extension for Julia Language Supprt
if [[ $(find .local/share/code-server/extensions -type d -name "julialang.language-julia-0.15.25" | wc -l) != "0" ]]; then
  rm -r .local/share/code-server/extensions/julialang.language-julia-0.15.25
fi
if [[ ! -d ".local/share/code-server/extensions/julialang.language-julia-0.15.32" ]]; then
  code-server --install-extension /var/tmp/julialang.language-julia-0.15.32.vsix
fi

# Clone JuliaBoxTutorials
if [[ ! -d "tutorials" ]]; then
  git clone https://github.com/JuliaComputing/JuliaBoxTutorials.git tutorials
fi

# Install user-specific startup files for Julia REPL and IJulia
mkdir -p .julia/config
if [[ ! -f ".julia/config/startup_ijulia.jl" ]]; then
  echo -e 'Pkg.activate()\n\ntry\n    @eval using Revise\ncatch e\n    @warn(e.msg)\nend\n\nPkg.activate("$(ENV["HOME"])/.julia/environments/v$(VERSION.major).$(VERSION.minor)")' > \
  .julia/config/startup_ijulia.jl
fi
if [[ ! -f ".julia/config/startup.jl" ]]; then
  echo -e 'println("Executing user-specific startup file (", @__FILE__, ")...")\n\natreplinit() do repl\n    try\n        @eval using Revise\n        @async Revise.wait_steal_repl_backend()\n        println("Revise started")\n    catch\n        @warn("Could not load Revise")\n    end\n    Pkg.activate("$(ENV["HOME"])/.julia/environments/v$(VERSION.major).$(VERSION.minor)")\nend' > \
  .julia/config/startup.jl
fi

# Update Code Server settings
mv .local/share/code-server/User/settings.json \
  .local/share/code-server/User/settings.json.bak
sed -i ':a;N;$!ba;s/,\n\}/\n}/g' .local/share/code-server/User/settings.json.bak
jq -s '.[0] * .[1]' /var/tmp/settings.json \
  .local/share/code-server/User/settings.json.bak > \
  .local/share/code-server/User/settings.json

exec /usr/local/bin/start-notebook.sh "$@"
