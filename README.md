# 🦖 ARK: Survival Evolved - All-in-One Docker Server

A high-performance, lightweight ARK:SE Server based on Docker. This project is designed to make server administration as easy as possible – **no manual editing of .ini files required!**

---

## 🚀 Features
* **Smart-Check Boot:** Only downloads the game if files are missing (saves time on restarts).
* **Easy-Config:** Manage all settings (Multipliers, Passwords, Maps) directly via your `docker-compose.yml`.
* **Gamma-Fix Included:** In-game Gamma commands are enabled by default for PvE and PvP.
* **Lightweight:** Based on the stable Ubuntu 24.04 LTS.

---

## 🛠️ Quick Start (Setup)

1. **Prerequisites:** Install [Docker](https://www.docker.com/) and Docker Compose.
2. **Create a File:** Create a folder and a file named `docker-compose.yml` with the following content:

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
      - ARK_PVE=False  
      
      # --- Difficulty Settings ---
      - ARK_DIFFICULTY_OFFSET=1.0
      - ARK_OVERRIDE_DIFFICULTY=5.0

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
      
      # --- Gamma Fix ---
      # WICHTIG: PvE nutzt "Disable", PvP nutzt "Enable"!
      - ARK_GameUserSettings_ServerSettings_DisablePvEGamma=False
      - ARK_GameUserSettings_ServerSettings_EnablePvPGamma=True

volumes:
  ark_data:
```
3. Start the Server:
Run this command in your terminal:
```
docker compose up -d
```
---
🔄 Updates & Maintenance                                                                                                        

⚙️ Changing Settings
To update your server configuration, simply change the values in your docker-compose.yml and run:
```
docker compose up -d
```
The script automatically updates your .ini files on the next boot.

---
🔄 Updating the Server
To update your Ark server to the latest image, follow these steps:

1. Navigate to your project folder
You must be in the directory containing your docker-compose.yml file:
```
cd ~/ark-server
```
2. Pull & Restart
Run this one-liner to download the latest image and restart the container:
```
docker-compose pull && docker-compose up -d
```
Note: Your game data and configurations will persist, as they are stored in Docker volumes.

---
🔄 Updating the Game (Steam)

To force a game update when a new version is released, delete the server binary and restart:
```
docker exec -it ark-server rm /ark/ShooterGame/Binaries/Linux/ShooterGameServer
docker restart ark-server
```
---
📂 Project Structure

entrypoint.sh: The core script handling variables and SteamCMD.

Dockerfile: Defines the environment (Ubuntu & dependencies).

docker-compose.yml: Example configuration for users.

---
Developed by DieGoldente 🦖✨
