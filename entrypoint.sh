#!/bin/bash

# 1. DEFINE PATHS
INSTALL_DIR="/ark"
STEAMCMD_DIR="/steamcmd"
CONFIG_DIR="$INSTALL_DIR/ShooterGame/Saved/Config/LinuxServer"

# Ensure the config directory exists
mkdir -p "$CONFIG_DIR"

echo "--- Step 1: Generating Configurations ---"

# Generate GameUserSettings.ini using environment variables from Docker
cat <<EOF > "$CONFIG_DIR/GameUserSettings.ini"
[ServerSettings]
XPMultiplier=${ARK_XP_MULTIPLIER:-2.0}
TamingSpeedMultiplier=${ARK_TAMING_MULTIPLIER:-5.0}
HarvestAmountMultiplier=${ARK_HARVEST_MULTIPLIER:-8.0}
ResourcesRespawnPeriodMultiplier=${ARK_RES_RESPAWN:-0.5}
PlayerCharacterWaterDrainMultiplier=${ARK_WATER_DRAIN:-0.6}
PlayerCharacterFoodDrainMultiplier=${ARK_FOOD_DRAIN:-0.6}
PlayerCharacterHealthRecoveryMultiplier=${ARK_HEALTH_RECOVERY:-2.0}

# DIFFICULTY SETTINGS
DifficultyOffset=${ARK_DIFFICULTY_OFFSET:-1.0}
OverrideOfficialDifficulty=${ARK_OVERRIDE_DIFFICULTY:-5.0}

ShowMapPlayerLocation=True
ServerCrosshair=True
AllowThirdPersonPlayer=True
AllowStructureCollision=True
ResourceNoReplenishRadiusStructures=0.1
ResourceNoReplenishRadiusPlayers=0.1
ServerAdminPassword=${ARK_ADMIN_PASSWORD:-CHANGE_ME}
ServerPassword=${ARK_SERVER_PASSWORD:-CHANGE_ME}
bGiveDefaultSurvivorItems=False
ServerPVE=${ARK_PVE:-False}

# GAMMA SETTINGS (Corrected for ARK Engine logic)
DisablePvEGamma=${ARK_GameUserSettings_ServerSettings_DisablePvEGamma:-False}
EnablePvPGamma=${ARK_GameUserSettings_ServerSettings_EnablePvPGamma:-True}

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

# Generate Game.ini for Breeding and Survival settings
cat <<EOF > "$CONFIG_DIR/Game.ini"
[/Script/ShooterGame.ShooterGameMode]
BabyMatureSpeedMultiplier=${ARK_MATURE_SPEED:-10.0}
BabyCuddleIntervalMultiplier=${ARK_CUDDLE_INTERVAL:-0.1}
BabyImprintAmountMultiplier=1.0
bUseCorpseLocator=True
EOF

echo "--- Step 2: Checking ARK Installation ---"

# Install or update ARK via SteamCMD if the binary is missing
if [ ! -f "$INSTALL_DIR/ShooterGame/Binaries/Linux/ShooterGameServer" ]; then
    echo "--- ARK Server files not found. Starting Installation... ---"
    $STEAMCMD_DIR/steamcmd.sh +force_install_dir $INSTALL_DIR +login anonymous +app_update 376030 validate +quit
fi

echo "--- Step 3: Starting ShooterGameServer ---"

# Navigate to the binary directory
cd "$INSTALL_DIR/ShooterGame/Binaries/Linux" || exit

# EXECUTE SERVER: Fixed Gamma parameters (DisablePvEGamma and EnablePvPGamma)
exec ./ShooterGameServer ${ARK_MAP:-Fjordur}?listen?SessionName="${ARK_SESSION_NAME}"?ServerPassword=${ARK_SERVER_PASSWORD}?ServerAdminPassword=${ARK_ADMIN_PASSWORD}?MaxPlayers=${ARK_MAX_PLAYERS:-10}?DifficultyOffset=${ARK_DIFFICULTY_OFFSET:-1.0}?OverrideOfficialDifficulty=${ARK_OVERRIDE_DIFFICULTY:-5.0}?XPMultiplier=${ARK_XP_MULTIPLIER:-2.0}?TamingSpeedMultiplier=${ARK_TAMING_MULTIPLIER:-5.0}?HarvestAmountMultiplier=${ARK_HARVEST_MULTIPLIER:-8.0}?DisablePvEGamma=${ARK_GameUserSettings_ServerSettings_DisablePvEGamma:-False}?EnablePvPGamma=${ARK_GameUserSettings_ServerSettings_EnablePvPGamma:-True} -server -log -NoBattlEye
