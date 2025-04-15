FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ENV TZ Asia/Tokyo

RUN apt-get update && \
    apt-get install --no-install-recommends -y ca-certificates perl libfontconfig-dev libfreetype-dev && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /tmp/install-tl-unx && \
    curl -fL https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | \
      tar xz -C /tmp/install-tl-unx --strip-components=1 && \
    printf "%s\n" \
      "selected_scheme scheme-basic" \
      "tlpdbopt_install_docfiles 0" \
      "tlpdbopt_install_srcfiles 0" \
      > /tmp/install-tl-unx/texlive.profile && \
    /tmp/install-tl-unx/install-tl \
      --profile=/tmp/install-tl-unx/texlive.profile && \
    rm -rf /tmp/install-tl-unx

RUN /usr/local/texlive/*/bin/*/tlmgr path add

RUN tlmgr install \
      collection-latexextra \
      collection-fontsrecommended \
      collection-langjapanese \
      siunitx \
      latexmk \
      latexindent && \
    tlmgr path add

RUN mktexlsr

# Install latexindent dependencies
RUN cpan -i App::cpanminus \
    cpanm YAML::Tiny \
    cpanm File::HomeDir
