FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    lib32gcc-s1 wget tar curl \
    && rm -rf /var/lib/apt/lists/*

# SteamCMD wird hier in /steamcmd installiert
RUN mkdir -p /steamcmd && cd /steamcmd \
    && wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    && tar -xvzf steamcmd_linux.tar.gz \
    && rm steamcmd_linux.tar.gz

WORKDIR /ark

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# RCON Port 27020/tcp noch ergänzt
EXPOSE 7777/udp 7778/udp 27015/udp 27020/tcp

CMD ["/entrypoint.sh"]
