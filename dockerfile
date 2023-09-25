ARG IMAGE=debian:bookworm-slim

FROM ${IMAGE} AS installer

RUN apt-get update && apt-get upgrade -y && \
  apt-get --no-install-recommends install -y \
    perl-modules \
    liburi-encode-perl \
    # at this point also install gpg and gpg-agent to allow tlmgr's
    # key subcommand to work correctly (see #21 in texlive/texlive gitlab)
    gpg gpg-agent \
    # needed because of wget for the texlive installation program
    ca-certificates \
    wget

WORKDIR /install

COPY texlive.profile .

RUN wget -O - http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | tar -xzf- --strip-components=1 && \
	./install-tl -v -portable -profile texlive.profile

FROM ${IMAGE} AS runner

# non root user that can run texlive
ARG APP_UID=64311
ARG APP_GID=101
# add non root user that can run texlive
RUN groupadd \
      -g ${APP_GID} \
      --system \
      app \
    && useradd \
      -u ${APP_UID} \
      -g ${APP_GID} \
      --shell /bin/false \
      --system \
      app 

COPY --from=installer --chown=app:app --chmod=770 /texlive /texlive

ENV \
  # ADD texlive binaries TO PATH
  PATH="${PATH}:/texlive/bin/x86_64-linux" \
  # UID of the non-root user 'app'
  APP_UID=${APP_UID} \
  # GID of the non-root group 'app'
  APP_GID=${APP_GID}

