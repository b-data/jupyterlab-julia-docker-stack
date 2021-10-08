#!/bin/bash
# Copyright (c) 2020 b-data GmbH.
# Distributed under the terms of the MIT License.

set -e

if [ $(id -u) == 0 ] ; then
    # Install Code Server extension for Julia Language Supprt
    if [[ $(find .local/share/code-server/extensions -type d -name "julialang.language-julia-1.2.8" | wc -l) != "0" ]]; then
      su $NB_USER -c "rm -r .local/share/code-server/extensions/julialang.language-julia-1.2.8"
    fi
    if [[ ! -d ".local/share/code-server/extensions/julialang.language-julia-1.4.0" ]]; then
      su $NB_USER -c "code-server --install-extension /var/tmp/julialang.language-julia-1.4.0.vsix"
    fi

    # Clone JuliaBoxTutorials
    if [[ ! -d "tutorials" ]]; then
      su $NB_USER -c "git clone https://github.com/JuliaComputing/JuliaBoxTutorials.git tutorials"
    fi

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

    # Update Code Server settings
    su $NB_USER -c "mv .local/share/code-server/User/settings.json \
      .local/share/code-server/User/settings.json.bak"
    su $NB_USER -c "sed -i ':a;N;$!ba;s/,\n\}/\n}/g' \
      .local/share/code-server/User/settings.json.bak"
    su $NB_USER -c "jq -s '.[0] * .[1]' /var/tmp/settings.json \
      .local/share/code-server/User/settings.json.bak > \
      .local/share/code-server/User/settings.json"
else
    # Install Code Server extension for Julia Language Supprt
    if [[ $(find .local/share/code-server/extensions -type d -name "julialang.language-julia-1.2.8" | wc -l) != "0" ]]; then
      rm -r .local/share/code-server/extensions/julialang.language-julia-1.2.8
    fi
    if [[ ! -d ".local/share/code-server/extensions/julialang.language-julia-1.4.0" ]]; then
      code-server --install-extension /var/tmp/julialang.language-julia-1.4.0.vsix
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
      echo -e 'println("Executing user-specific startup file (", @__FILE__, ")...")\n\ntry\n    using Revise\n    println("Revise started")\ncatch\n    @warn("Could not load Revise")\nend\n\nPkg.activate("$(ENV["HOME"])/.julia/environments/v$(VERSION.major).$(VERSION.minor)")' > \
      .julia/config/startup.jl
    fi

    # Update Code Server settings
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
