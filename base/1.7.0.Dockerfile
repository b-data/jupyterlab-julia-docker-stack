ARG BASE_IMAGE=debian:bullseye
ARG GIT_VERSION=2.34.1

FROM registry.gitlab.b-data.ch/git/gsi/${GIT_VERSION}/${BASE_IMAGE} as gsi

FROM registry.gitlab.b-data.ch/julia/ver:1.7.0

LABEL org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.source="https://gitlab.b-data.ch/jupyterlab/julia/docker-stack" \
      org.opencontainers.image.vendor="b-data GmbH" \
      org.opencontainers.image.authors="Olivier Benz <olivier.benz@b-data.ch>"

ARG DEBIAN_FRONTEND=noninteractive

ARG NB_USER=jovyan
ARG NB_UID=1000
ARG NB_GID=100
ARG JUPYTERHUB_VERSION=1.5.0
ARG JUPYTERLAB_VERSION=3.2.5
ARG CODE_SERVER_RELEASE=3.12.0
ARG GIT_VERSION=2.34.1
ARG PANDOC_VERSION=2.16.2
ARG CODE_WORKDIR

ENV NB_USER=${NB_USER} \
    NB_UID=${NB_UID} \
    NB_GID=${NB_GID} \
    JUPYTERHUB_VERSION=${JUPYTERHUB_VERSION} \
    JUPYTERLAB_VERSION=${JUPYTERLAB_VERSION} \
    CODE_SERVER_RELEASE=${CODE_SERVER_RELEASE} \
    GIT_VERSION=${GIT_VERSION} \
    PANDOC_VERSION=${PANDOC_VERSION} \
    SERVICE_URL=https://open-vsx.org/vscode/gallery \
    ITEM_URL=https://open-vsx.org/vscode/item

COPY --from=gsi /usr/local /usr/local

USER root

RUN apt-get update \
  && apt-get -y install --no-install-recommends \
    file \
    fontconfig \
    gnupg \
    info \
    jq \
    libclang-dev \
    lsb-release \
    man-db \
    nano \
    procps \
    psmisc \
    python3-venv \
    python3-virtualenv \
    screen \
    sudo \
    tmux \
    vim \
    wget \
    zsh \
    ## Additional git runtime dependencies
    libcurl3-gnutls \
    liberror-perl \
    ## Additional git runtime recommendations
    less \
    ssh-client \
  ## Clean up
  && rm -rf /var/lib/apt/lists/* \
  ## Install font MesloLGS NF
  && mkdir -p /usr/share/fonts/truetype/meslo \
  && curl -sL https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -o /usr/share/fonts/truetype/meslo/MesloLGS\ NF\ Regular.ttf \
  && curl -sL https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -o /usr/share/fonts/truetype/meslo/MesloLGS\ NF\ Bold.ttf \
  && curl -sL https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -o /usr/share/fonts/truetype/meslo/MesloLGS\ NF\ Italic.ttf \
  && curl -sL https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -o /usr/share/fonts/truetype/meslo/MesloLGS\ NF\ Bold\ Italic.ttf \
  && fc-cache -fv \
  ## Install pandoc
  && curl -sLO https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-1-$(dpkg --print-architecture).deb \
  && dpkg -i pandoc-${PANDOC_VERSION}-1-$(dpkg --print-architecture).deb \
  && rm pandoc-${PANDOC_VERSION}-1-$(dpkg --print-architecture).deb \
  ## Set default branch name to main
  && git config --system init.defaultBranch main \
  ## Store passwords for one hour in memory
  && git config --system credential.helper "cache --timeout=3600" \
  ## Merge the default branch from the default remote when "git pull" is run
  && git config --system pull.rebase false \
  ## Add user
  && useradd -m -s /bin/bash -N -u ${NB_UID} ${NB_USER}

## Install code-server
RUN mkdir /opt/code-server \
  && cd /opt/code-server \
  && curl -sL https://github.com/cdr/code-server/releases/download/v${CODE_SERVER_RELEASE}/code-server-${CODE_SERVER_RELEASE}-linux-$(dpkg --print-architecture).tar.gz | tar zxf - --strip-components=1 \
  && curl -sL https://upload.wikimedia.org/wikipedia/commons/9/9a/Visual_Studio_Code_1.35_icon.svg -o vscode.svg \
  ## Include custom fonts
  && sed -i 's|</head>|  <link rel="preload" href="{{CS_STATIC_BASE}}/src/browser/assets/fonts/MesloLGS-NF-Regular.woff2" as="font" type="font/woff2" crossorigin="anonymous">\n  </head>|g' /opt/code-server/src/browser/pages/vscode.html \
  && sed -i 's|</head>|  <link rel="preload" href="{{CS_STATIC_BASE}}/src/browser/assets/fonts/MesloLGS-NF-Italic.woff2" as="font" type="font/woff2" crossorigin="anonymous">\n  </head>|g' /opt/code-server/src/browser/pages/vscode.html \
  && sed -i 's|</head>|  <link rel="preload" href="{{CS_STATIC_BASE}}/src/browser/assets/fonts/MesloLGS-NF-Bold.woff2" as="font" type="font/woff2" crossorigin="anonymous">\n  </head>|g' /opt/code-server/src/browser/pages/vscode.html \
  && sed -i 's|</head>|  <link rel="preload" href="{{CS_STATIC_BASE}}/src/browser/assets/fonts/MesloLGS-NF-Bold-Italic.woff2" as="font" type="font/woff2" crossorigin="anonymous">\n  </head>|g' /opt/code-server/src/browser/pages/vscode.html \
  && sed -i 's|</head>|  <link rel="stylesheet" type="text/css" href="{{CS_STATIC_BASE}}/src/browser/assets/css/fonts.css">\n  </head>|g' /opt/code-server/src/browser/pages/vscode.html \
  && cd /

ENV PATH=/opt/code-server/bin:$PATH

## Install JupyterLab
RUN export CODE_BUILTIN_EXTENSIONS_DIR=/opt/code-server/vendor/modules/code-oss-dev/extensions \
  && dpkgArch="$(dpkg --print-architecture)" \
  && curl -sLO https://bootstrap.pypa.io/get-pip.py \
  && python3 get-pip.py \
  && rm get-pip.py \
  ## Install gcc and python3-dev to build wheels
  && DEPS="gcc python3-dev" \
  && apt-get update \
  && apt-get install -y --no-install-recommends $DEPS \
  ## Install Python packages
  && pip3 install \
    jupyter-server-proxy \
    jupyterhub==${JUPYTERHUB_VERSION} \
    jupyterlab==${JUPYTERLAB_VERSION} \
    jupyterlab-git \
    notebook \
    nbconvert \
  # Remove gcc and python3-dev
  && apt-get remove --purge -y $DEPS \
  ## Set JupyterLab Dark theme
  && mkdir -p /usr/local/share/jupyter/lab/settings \
  && echo '{\n  "@jupyterlab/apputils-extension:themes": {\n    "theme": "JupyterLab Dark"\n  },\n  "@jupyterlab/terminal-extension:plugin": {\n    "fontFamily": "MesloLGS NF"\n  }\n}' > /usr/local/share/jupyter/lab/settings/overrides.json \
  ## Include custom fonts
  && sed -i 's|</head>|<link rel="preload" href="{{page_config.fullStaticUrl}}/assets/fonts/MesloLGS-NF-Regular.woff2" as="font" type="font/woff2" crossorigin="anonymous"></head>|g' /usr/local/share/jupyter/lab/static/index.html \
  && sed -i 's|</head>|<link rel="preload" href="{{page_config.fullStaticUrl}}/assets/fonts/MesloLGS-NF-Italic.woff2" as="font" type="font/woff2" crossorigin="anonymous"></head>|g' /usr/local/share/jupyter/lab/static/index.html \
  && sed -i 's|</head>|<link rel="preload" href="{{page_config.fullStaticUrl}}/assets/fonts/MesloLGS-NF-Bold.woff2" as="font" type="font/woff2" crossorigin="anonymous"></head>|g' /usr/local/share/jupyter/lab/static/index.html \
  && sed -i 's|</head>|<link rel="preload" href="{{page_config.fullStaticUrl}}/assets/fonts/MesloLGS-NF-Bold-Italic.woff2" as="font" type="font/woff2" crossorigin="anonymous"></head>|g' /usr/local/share/jupyter/lab/static/index.html \
  && sed -i 's|</head>|<link rel="stylesheet" type="text/css" href="{{page_config.fullStaticUrl}}/assets/css/fonts.css"></head>|g' /usr/local/share/jupyter/lab/static/index.html \
  ## Install code-server extensions
  && cd /tmp \
  && curl -sLO https://dl.b-data.ch/vsix/alefragnani.project-manager-12.4.0.vsix \
  && code-server --extensions-dir ${CODE_BUILTIN_EXTENSIONS_DIR} --install-extension alefragnani.project-manager-12.4.0.vsix \
  && curl -sLO https://dl.b-data.ch/vsix/piotrpalarz.vscode-gitignore-generator-1.0.3.vsix \
  && code-server --extensions-dir ${CODE_BUILTIN_EXTENSIONS_DIR} --install-extension piotrpalarz.vscode-gitignore-generator-1.0.3.vsix \
  && code-server --extensions-dir ${CODE_BUILTIN_EXTENSIONS_DIR} --install-extension GitLab.gitlab-workflow \
  && code-server --extensions-dir ${CODE_BUILTIN_EXTENSIONS_DIR} --install-extension ms-python.python \
  && code-server --extensions-dir ${CODE_BUILTIN_EXTENSIONS_DIR} --install-extension christian-kohler.path-intellisense \
  && code-server --extensions-dir ${CODE_BUILTIN_EXTENSIONS_DIR} --install-extension eamodio.gitlens \
  && code-server --extensions-dir ${CODE_BUILTIN_EXTENSIONS_DIR} --install-extension redhat.vscode-yaml \
  && code-server --extensions-dir ${CODE_BUILTIN_EXTENSIONS_DIR} --install-extension grapecity.gc-excelviewer \
  && cd /var/tmp/ \
  && curl -sLO https://open-vsx.org/api/julialang/language-julia/1.4.0/file/julialang.language-julia-1.4.0.vsix \
  && mkdir -p /usr/local/bin/start-notebook.d \
  && mkdir -p /usr/local/bin/before-notebook.d \
  && cd / \
  ## Clean up
  && rm -rf /tmp/* \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* \
    /root/.cache \
    /root/.config

## Install the Julia kernel for JupyterLab
RUN export JULIA_DEPOT_PATH=${JULIA_PATH}/local/share/julia \
  && julia -e "using Pkg; pkg\"add IJulia Revise\"; pkg\"precompile\"" \
  && chmod -R ugo+rx ${JULIA_DEPOT_PATH} \
  && unset JULIA_DEPOT_PATH \
  && mv $HOME/.local/share/jupyter/kernels/julia* /usr/local/share/jupyter/kernels/ \
  && rm -rf $HOME/.local

## Install Tini
RUN curl -sL https://github.com/krallin/tini/releases/download/v0.19.0/tini-$(dpkg --print-architecture) -o /usr/local/bin/tini \
  && chmod +x /usr/local/bin/tini

## Switch back to ${NB_USER} to avoid accidental container runs as root
USER ${NB_USER}

ENV HOME=/home/${NB_USER} \
    CODE_WORKDIR=${CODE_WORKDIR:-/home/${NB_USER}/projects} \
    SHELL=/usr/bin/zsh \
    TERM=xterm-256color

WORKDIR ${HOME}

RUN mkdir -p .local/share/code-server/User \
  && echo '{\n    "editor.tabSize": 2,\n    "telemetry.enableTelemetry": false,\n    "gitlens.advanced.telemetry.enabled": false,\n    "julia.enableCrashReporter": false,\n    "julia.enableTelemetry": false,\n    "julia.format.indent": 2,\n    "workbench.colorTheme": "Default Dark+",\n    "terminal.integrated.fontFamily": "MesloLGS NF"\n}' > .local/share/code-server/User/settings.json \
  && cp .local/share/code-server/User/settings.json /var/tmp \
  && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended \
  && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git .oh-my-zsh/custom/themes/powerlevel10k \
  && sed -i 's/ZSH="\/home\/jovyan\/.oh-my-zsh"/ZSH="$HOME\/.oh-my-zsh"/g' .zshrc \
  && sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' .zshrc \
  && echo "\n# set PATH so it includes user's private bin if it exists\nif [ -d "\$HOME/bin" ] ; then\n    PATH="\$HOME/bin:\$PATH"\nfi" | tee -a .bashrc .zshrc \
  && echo "\n# set PATH so it includes user's private bin if it exists\nif [ -d "\$HOME/.local/bin" ] ; then\n    PATH="\$HOME/.local/bin:\$PATH"\nfi" | tee -a .bashrc .zshrc \
  && echo "\n# To customize prompt, run \`p10k configure\` or edit ~/.p10k.zsh." >> .zshrc \
  && echo "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" >> .zshrc \
  && cp -a $HOME /var/tmp

## Copy local files as late as possible to avoid cache busting
COPY assets/. /
COPY scripts/. /
COPY --chown=${NB_UID}:${NB_GID} .p10k.zsh ${HOME}/.p10k.zsh
COPY --chown=${NB_UID}:${NB_GID} .p10k.zsh /var/tmp/${NB_USER}/.p10k.zsh
COPY startup.jl ${JULIA_PATH}/etc/julia/startup.jl

EXPOSE 8888

## Configure container startup
ENTRYPOINT ["tini", "-g", "--"]
CMD ["start-notebook.sh"]
