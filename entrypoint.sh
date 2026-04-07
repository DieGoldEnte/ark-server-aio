#!/bin/bash

# 1. DEFINING PATHS
INSTALL_DIR="/ark"
STEAMCMD_DIR="/steamcmd"
CONFIG_DIR="$INSTALL_DIR/ShooterGame/Saved/Config/LinuxServer"

mkdir -p "$CONFIG_DIR"

echo "--- Step 1: Generating Configurations ---"
cat <<EOF > "$CONFIG_DIR/GameUserSettings.ini"
[ServerSettings]
XPMultiplier=${ARK_XP_MULTIPLIER:-2.0}
TamingSpeedMultiplier=${ARK_TAMING_MULTIPLIER:-5.0}
HarvestAmountMultiplier=${ARK_HARVEST_MULTIPLIER:-8.0}
ResourcesRespawnPeriodMultiplier=${ARK_RES_RESPAWN:-0.5}
PlayerCharacterWaterDrainMultiplier=${ARK_WATER_DRAIN:-0.6}
PlayerCharacterFoodDrainMultiplier=${ARK_FOOD_DRAIN:-0.6}
PlayerCharacterHealthRecoveryMultiplier=${ARK_HEALTH_RECOVERY:-2.0}
DifficultyOffset=1.000000
OverrideOfficialDifficulty=5.000000
ShowMapPlayerLocation=True
ServerCrosshair=True
AllowThirdPersonPlayer=True
AllowStructureCollision=True
ResourceNoReplenishRadiusStructures=0.1
ResourceNoReplenishRadiusPlayers=0.1
ServerAdminPassword=${ARK_ADMIN_PASSWORD:-CHANGE_ME}
ServerPassword=${ARK_SERVER_PASSWORD:-CHANGE_ME}
bGiveDefaultSurvivorItems=False
; GAMMA FIX
DisablePvEGamma=False
EnablePvPGamma=True
ServerPVE=${ARK_PVE:-False}

[/Script/ShooterGame.ShooterGameUserSettings]
MasterAudioVolume=1.000000
MusicAudioVolume=1.000000
SFXAudioVolume=1.000000
VoiceAudioVolume=2.000000
CharacterAudioVolume=1.000000
UIScaling=1.000000
UIQuickbarScaling=0.650000
CameraShakeScale=0.650000
bFirstPersonRiding=False
bThirdPersonPlayer=False

[SessionSettings]
SessionName=${ARK_SESSION_NAME:-Community Server}

[/Script/Engine.GameSession]
MaxPlayers=${ARK_MAX_PLAYERS:-10}
EOF

cat <<EOF > "$CONFIG_DIR/Game.ini"
[/Script/ShooterGame.ShooterGameMode]
BabyMatureSpeedMultiplier=${ARK_MATURE_SPEED:-10.0}
BabyCuddleIntervalMultiplier=${ARK_CUDDLE_INTERVAL:-0.1}
BabyImprintAmountMultiplier=1.0
bUseCorpseLocator=True
EOF

echo "--- Step 2: Checking ARK Installation ---"
if [ ! -f "$INSTALL_DIR/ShooterGame/Binaries/Linux/ShooterGameServer" ]; then
    echo "--- ARK Server files not found. Starting Installation... ---"
    $STEAMCMD_DIR/steamcmd.sh +force_install_dir $INSTALL_DIR +login anonymous +app_update 376030 validate +quit
fi

echo "--- Step 3: Starting ShooterGameServer ---"
cd "$INSTALL_DIR/ShooterGame/Binaries/Linux" || exit

# Gamma Fix
exec ./ShooterGameServer ${ARK_MAP:-Fjordur}?listen?SessionName="${ARK_SESSION_NAME}"?ServerPassword=${ARK_SERVER_PASSWORD}?ServerAdminPassword=${ARK_ADMIN_PASSWORD}?MaxPlayers=${ARK_MAX_PLAYERS:-10}?DisablePvEGamma=false?EnablePvPGamma=true -server -log -NoBattlEye
