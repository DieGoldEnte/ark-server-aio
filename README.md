# ark-server-aio
ARK | Smart-Check Fast Boot | Fully Customizable | Ubuntu 24.04
Markdown
# 🦖 ARK: Survival Evolved - All-in-One Docker Server

Ein performanter, leichtgewichtiger ARK:SE Server auf Docker-Basis. Dieses Projekt wurde entwickelt, um die Server-Administration so einfach wie möglich zu machen – **kein manuelles Editieren von `.ini`-Dateien nötig!**

## 🚀 Features
* **Smart-Check Boot:** Lädt das Spiel nur herunter, wenn es fehlt (spart Zeit beim Neustart).
* **Easy-Config:** Alle wichtigen Einstellungen (Multiplikatoren, Passwörter, Map) direkt über die `docker-compose.yml`.
* **Gamma-Fix inklusive:** In-Game Gamma-Befehle sind standardmäßig aktiviert.
* **Leichtgewichtig:** Basierend auf Ubuntu 24.04 LTS.

---

## 🛠️ Schnellstart (Setup)

1. **Voraussetzungen:** Installiere [Docker](https://www.docker.com/) und Docker Compose.
2. **Datei erstellen:** Erstelle einen Ordner und lege eine `docker-compose.yml` mit folgendem Inhalt an:
# 🦖 ARK: Survival Evolved - All-in-One Docker Server

Ein performanter, leichtgewichtiger ARK:SE Server auf Docker-Basis. Dieses Projekt wurde entwickelt, um die Server-Administration so einfach wie möglich zu machen – **kein manuelles Editieren von `.ini`-Dateien nötig!**

## 🚀 Features
* **Smart-Check Boot:** Lädt das Spiel nur herunter, wenn es fehlt (spart Zeit beim Neustart).
* **Easy-Config:** Alle wichtigen Einstellungen (Multiplikatoren, Passwörter, Map) direkt über die `docker-compose.yml`.
* **Gamma-Fix inklusive:** In-Game Gamma-Befehle sind standardmäßig aktiviert.
* **Leichtgewichtig:** Basierend auf Ubuntu 24.04 LTS.

---

## 🛠️ Schnellstart (Setup)

1. **Voraussetzungen:** Installiere [Docker](https://www.docker.com/) und Docker Compose.
2. **Datei erstellen:** Erstelle einen Ordner und lege eine `docker-compose.yml` mit folgendem Inhalt an:

```
services:
  ark:
    image: diegoldente/ark-aio-server:latest
    container_name: ark-server
    restart: unless-stopped
    ports:
      - "7777:7777/udp"
      - "7778:7778/udp"
      - "27015:27015/udp"
    volumes:
      - ark_data:/ark
    environment:
      - ARK_MAP=Fjordur
      - ARK_SESSION_NAME=Mein_Cooler_Server
      - ARK_MAX_PLAYERS=10
      - ARK_SERVER_PASSWORD=deinpasswort
      - ARK_ADMIN_PASSWORD=deinadminpasswort
      - ARK_XP_MULTIPLIER=2.0
      - ARK_TAMING_MULTIPLIER=5.0

volumes:
  ark_data:
````
3. Server starten:
```
docker compose up -d
```

🔄 Updates & Wartung
Einstellungen ändern
Ändere einfach die Werte in der docker-compose.yml und führe diesen Befehl aus:

Bash
docker compose up -d
Spiel-Update erzwingen (Steam)
Wenn Wildcard ein Update veröffentlicht, lösche die Server-Binary und starte neu:
```
docker exec -it ark-server rm /ark/ShooterGame/Binaries/Linux/ShooterGameServer
docker restart ark-server
```

📂 Projekt-Struktur
entrypoint.sh: Das Herzstück – verarbeitet Variablen und steuert SteamCMD.

Dockerfile: Definiert die Umgebung (Ubuntu, SteamCMD, Abhängigkeiten).

docker-compose.yml: Beispiel-Konfiguration für Nutzer.

Entwickelt von DieGoldEnte 🦖✨
