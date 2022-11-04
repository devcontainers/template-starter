FROM mcr.microsoft.com/devcontainers/base:${templateOption:imageVariant}

RUN mkdir -p /usr/local/etc \
    && echo "${templateOption:greeting}" > /usr/local/etc/greeting.txt