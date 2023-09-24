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

# add non root user that can run texlive
ARG APP_UID=1001
RUN useradd -u ${USER_UID} appuser

COPY --from=installer --chown=appuser:appuser --chmod=770 /texlive /texlive

# add path
ENV PATH="${PATH}:/texlive/bin/x86_64-linux"
