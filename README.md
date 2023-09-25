# texlive-luatex
Docker image to execute [LuaTeX](https://www.luatex.org/) using the [TeX Live distribution](https://tug.org/texlive/).
The dockerfile is optimized for usage in containerized microservice. Inspired and copied from the [TeX Live docker image](https://hub.docker.com/r/texlive/texlive)

## Usage
```bash
FROM kinnekode/texlive-luatex:bookworm-slim  AS base

RUN apt-get update && apt-get upgrade -y

EXPOSE 3110

WORKDIR /app

COPY /bin/app .

USER $APP_UID:$APP_GID
CMD ["/app/app"]
```