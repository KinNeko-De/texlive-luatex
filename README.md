# texlive-luatex
Docker image to execute lulatex using the Texlive distribution.
The dockerfile is optimized for usage in containerized microservice.

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