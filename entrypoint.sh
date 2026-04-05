#!/bin/bash

# --- KONFIGURATION ---
INSTALL_DIR="/home/lukas/arkserver"
MAP="Fjordur"
SESSION_NAME="Lukas_Fjordur_Proxmox"
ADMIN_PASSWORD="DeinPasswortHier" # <-- PASSWORT EINTRAGEN!
MAX_PLAYERS=10

echo "--- 0. Festplatten-Check ---"
# Prüft, ob im Home-Verzeichnis mindestens 30 GB (30000 MB) frei sind
FREE_SPACE=$(df -m "$HOME" | awk 'NR==2 {print $4}')
if [ "$FREE_SPACE" -lt 30000 ]; then
    echo "FEHLER: Zu wenig Speicherplatz! Du hast nur $((FREE_SPACE/1024)) GB frei."
    echo "ARK benötigt mindestens 30 GB freien Speicher. Bitte erweitere deine Proxmox-VM!"
    exit 1
fi
echo "Speicherplatz okay ($((FREE_SPACE/1024)) GB frei)."

echo "--- 1. System-Optimierung ---"
if ! grep -q "fs.file-max=100000" /etc/sysctl.conf; then
    sudo sh -c 'echo "fs.file-max=100000" >> /etc/sysctl.conf'
    sudo sysctl -p
fi

echo "--- 2. Ordner anlegen ---"
mkdir -p "$INSTALL_DIR/ShooterGame/Binaries/Linux"
mkdir -p "$INSTALL_DIR/ShooterGame/Saved/Config/LinuxServer"
mkdir -p "$HOME/steamcmd"

echo "--- 3. SteamCMD herunterladen ---"
cd "$HOME/steamcmd" || exit
if [ ! -f "steamcmd.sh" ]; then
    wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
    tar -xvzf steamcmd_linux.tar.gz
fi

echo "--- 4. ARK Server Download ---"
# Mit der korrekten Server-App-ID (376030)
./steamcmd.sh +force_install_dir "$INSTALL_DIR" +login anonymous +app_update 376030 validate +quit

echo "--- 5. GameUserSettings.ini schreiben ---"
cat <<EOF > "$INSTALL_DIR/ShooterGame/Saved/Config/LinuxServer/GameUserSettings.ini"
[ServerSettings]
XPMultiplier=1.5
HarvestAmountMultiplier=8.0
TamingSpeedMultiplier=5.0
DifficultyOffset=1.0
OverrideOfficialDifficulty=5.0
GlobalSpoilingTimeMultiplier=2.0
ShowMapPlayerLocation=True
ServerCrosshair=True
ShowFloatingDamageText=True
GiveDefaultLauncherItems=False
AllowStructureCollision=True
AlwaysAllowStructurePickup=True
ResourceNoReplenishRadiusPlayers=0.1
ResourceNoReplenishRadiusStructures=0.1
DayTimeSpeedScale=0.5
NightTimeSpeedScale=2.0
ServerAdminPassword=$ADMIN_PASSWORD

[SessionSettings]
SessionName=$SESSION_NAME

[/Script/Engine.GameSession]
MaxPlayers=$MAX_PLAYERS
EOF

echo "--- 6. Game.ini schreiben ---"
cat <<EOF > "$INSTALL_DIR/ShooterGame/Saved/Config/LinuxServer/Game.ini"
[/Script/ShooterGame.ShooterGameMode]
BabyMatureSpeedMultiplier=10.0
BabyCuddleIntervalMultiplier=0.1
BabyImprintAmountMultiplier=10.0
PerLevelStatsMultiplier_Player[7]=5.0
PerLevelStatsMultiplier_DinoTamed[7]=5.0
EOF

echo "--- 7. Start-Skript erstellen ---"
cat <<EOF > "$INSTALL_DIR/ShooterGame/Binaries/Linux/start_ark.sh"
#!/bin/bash
./ShooterGameServer $MAP?listen?SessionName=$SESSION_NAME?MaxPlayers=$MAX_PLAYERS -server -log -NoBattlEye
EOF

chmod +x "$INSTALL_DIR/ShooterGame/Binaries/Linux/start_ark.sh"

echo "--------------------------------------------------"
echo "---               SETUP FERTIG!                ---"
echo "--------------------------------------------------"
