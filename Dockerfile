FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

ENV TZ Asia/Tokyo

RUN apt-get update && \
    apt-get install --no-install-recommends -y perl libfontconfig-dev libfreetype-dev && \
    rm -rf /var/lib/apt/lists/*

ARG TEXLIVE_VERSION=2023

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

ENV PATH=/usr/local/texlive/${TEXLIVE_VERSION}/bin/x86_64-linux:$PATH

RUN tlmgr install \
      collection-latexextra \
      collection-fontsrecommended \
      collection-langjapanese \
      siunitx \
      latexmk

# Install latexindent
RUN curl -fLo /usr/local/bin/latexindent https://github.com/cmhughes/latexindent.pl/releases/download/V3.21/latexindent-linux && \
    chmod +x /usr/local/bin/latexindent

RUN mktexlsr

# Install Node.js
ENV VOLTA_HOME=/usr/local/volta
ENV PATH=${VOLTA_HOME}/bin:${PATH}
RUN curl https://get.volta.sh | bash -s -- --skip-setup
RUN volta install node@20

# Install textlint
RUN npm install -g prh@^5.4.4 textlint@^13.4.1 textlint-filter-rule-comments@^1.2.2 textlint-plugin-latex2e@^1.2.1 textlint-rule-preset-ja-engineering-paper@^1.0.4 textlint-rule-preset-ja-spacing@^2.3.0 textlint-rule-preset-ja-technical-writing@^10.0.1 textlint-rule-preset-jtf-style@^2.3.14 textlint-rule-prh@^5.3.0 textlint-rule-spellcheck-tech-word@^5.0.0
