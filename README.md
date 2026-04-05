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

Ein performanter, leichtgewichtiger ARK:SE Server auf Docker-Basis. Dieses Projekt wurde entwickelt, um die Server-Administration so einfach wie möglich zu machen – **kein manuelles Editieren von `.ini`-Dateien nötig!**

---

## 🛠️ Schnellstart (Setup)

1. **Voraussetzungen:** Installiere [Docker](https://www.docker.com/) und Docker Compose.
2. **Datei erstellen:** Erstelle einen Ordner und lege eine `docker-compose.yml` mit folgendem Inhalt an:

```
services:
  ark:
    # Enter the image and tag here:
    image: diegoldente/ark-aio-server:latest
    container_name: ark-server
    
    # Restart policy (keeps the server running after crashes or reboots):
    restart: unless-stopped
    
    ports:
      - "7777:7777/udp"
      - "7778:7778/udp"
      - "27015:27015/udp"
      - "27020:27020/tcp"
      
    volumes:
      - ark_data:/ark
      
    environment:
      # --- General Server Settings ---
      - ARK_MAP=Fjordur
      - ARK_SESSION_NAME=My_ARK_Server
      - ARK_MAX_PLAYERS=10
      - ARK_SERVER_PASSWORD=yourpassword
      - ARK_ADMIN_PASSWORD=youradminpassword
      
      # --- Multipliers & Survival ---
      - ARK_XP_MULTIPLIER=2.0
      - ARK_TAMING_MULTIPLIER=5.0
      - ARK_HARVEST_MULTIPLIER=8.0
      - ARK_RES_RESPAWN=0.5
      - ARK_WATER_DRAIN=0.6
      - ARK_FOOD_DRAIN=0.6
      - ARK_HEALTH_RECOVERY=2.0
      - ARK_MATURE_SPEED=10.0
      - ARK_CUDDLE_INTERVAL=0.1
      
      # --- Gamma Fix (Enable in-game gamma commands) ---
      - ARK_GameUserSettings_ServerSettings_DisablePvEGamma=False
      - ARK_GameUserSettings_ServerSettings_DisablePvPGamma=False

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
```
docker compose up -d
```

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
