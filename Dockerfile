FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

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

ARG TEXLIVE_VERSION=2024
ENV PATH=/usr/local/texlive/${TEXLIVE_VERSION}/bin/x86_64-linux:$PATH

RUN tlmgr install \
      collection-latexextra \
      collection-fontsrecommended \
      collection-langjapanese \
      siunitx \
      latexmk

RUN mktexlsr

# Install latexindent
RUN curl -sSfLo /usr/local/bin/latexindent https://github.com/cmhughes/latexindent.pl/releases/download/V3.23.9/latexindent-linux && \
    chmod +x /usr/local/bin/latexindent
