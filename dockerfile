FROM debian:bookworm-slim AS installer

RUN apt-get update && apt-get upgrade -y

# ca-certificates - needed because of wget
RUN apt-get update && \
    apt-get --no-install-recommends install -y \
        ca-certificates \ 
        perl-modules \
        liburi-encode-perl \
        gnupg \
        wget && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /install

COPY texlive.profile .

RUN wget -O - http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | tar -xzf- --strip-components=1 && \
	./install-tl -v -portable -profile texlive.profile