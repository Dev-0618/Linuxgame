#!/bin/bash

# This script sets up the entire "THE PROTOCOL" game environment.
# It creates directories, empty files, and populates them with initial content.

# Define the main game data directory as the current directory where setup.sh is run.
# This makes the game self-contained within its cloned repository folder.
GAME_DIR="$(pwd)"
TOOLS_DIR="$GAME_DIR/tools"

echo "====================================================="
echo "  Starting setup for THE PROTOCOL – Breach of Node 127.4.7.8"
echo "====================================================="
echo ""

# 1. Create the main game directory (if it doesn't exist, though it should be current pwd)
mkdir -p "$GAME_DIR"
echo "✅ Game data will be installed in: $GAME_DIR"

# 2. Create the tools directory
mkdir -p "$TOOLS_DIR"
echo "✅ Created tools directory: $TOOLS_DIR"

# 3. Create fake-commands.sh with corrected logic
cat << 'EOF_FAKE_COMMANDS' > "$TOOLS_DIR/fake-commands.sh"
#!/bin/bash

# Get the name of the command used to invoke this script (e.g., nmap, ssh, ps, docker)
COMMAND_NAME=$(basename "$0")

# Simulate nmap
if [[ "$COMMAND_NAME" == "nmap" ]]; then
    echo "Starting Nmap 7.80 ( https://nmap.org ) at 2025-07-08 14:00 IST"
    echo "Nmap scan report for 127.0.0.1"
    echo "Host is up (0.000020s latency)."
    echo "Not shown: 998 closed ports"
    echo "PORT     STATE SERVICE"
    echo "22/tcp   open  ssh"
    echo "80/tcp   open  http"
    echo "443/tcp  open  https"
    echo "Nmap done: 1 IP address (1 host up) scanned in 0.08 seconds"
    exit 0
fi

# Simulate ssh
if [[ "$COMMAND_NAME" == "ssh" ]]; then
    if [[ "$1" == "admin@127.0.0.1" ]]; then
        echo "The authenticity of host '127.0.0.1 (127.0.0.1)' can't be established."
        echo "ECDSA key fingerprint is SHA256:FAKE_SSH_FINGERPRINT."
        echo "Are you sure you want to continue connecting (yes/no/[fingerprint])?"
        read -r CONFIRMATION
        if [[ "$CONFIRMATION" == "yes" ]]; then
            echo "Warning: Permanently added '127.0.0.1' (ECDSA) to the list of known hosts."
            echo "admin@127.0.0.1's password:"
            read -s PASSWORD
            if [[ "$PASSWORD" == "protocol_breach_2025" ]]; then
                echo "Welcome to Node 127.4.7.8."
                echo "Last login: Tue Jul  8 14:05:00 2025 from 192.168.1.100"
                echo "You have successfully gained access to the system."
                echo "--- MISSION 1 COMPLETE ---"
                echo "Please proceed to Mission 2."
                # Signal mission completion for run.sh to pick up
                touch "$(dirname "$0")/../mission1_complete" # Path relative to fake-commands.sh
            else
                echo "Permission denied, please try again."
            fi
        else
            echo "Connection aborted."
        fi
    else
        echo "ssh: Could not resolve hostname $2: Name or service not known"
    fi
    exit 0
fi

# Simulate ps
if [[ "$COMMAND_NAME" == "ps" && "$1" == "aux" ]]; then
    echo "USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND"
    echo "root           1  0.0  0.0 100000  6000 ?        Ss   Jul01   0:01 /sbin/init"
    echo "admin        500  0.1  0.5 500000 20000 ?        Sl   Jul08   0:15 /usr/bin/python3 /tmp/rogue_process.py"
    echo "guest          1000  0.0  0.1 200000  4000 ?        S    Jul01   0:00 /usr/bin/gnome-shell"
    # --- FIX FOR MISSION 2 PROGRESSION ---
    touch "$(dirname "$0")/../mission2_complete" # Path relative to fake-commands.sh
    echo "--- Rogue process detected and neutralized! ---" # Added for clarity
    exit 0
fi

# Simulate docker logs
if [[ "$COMMAND_NAME" == "docker" && "$1" == "logs" && "$2" == "ai-core-service" ]]; then
    cat "$(dirname "$0")/../mission3/docker_logs.txt" # Path relative to fake-commands.sh
    exit 0
fi

# Fallback for unknown commands
echo "Fake command: $COMMAND_NAME $@"
EOF_FAKE_COMMANDS
chmod +x "$TOOLS_DIR/fake-commands.sh"
echo "✅ Created fake-commands.sh with corrected logic."

# 4. Create run.sh
cat << 'EOF_RUN_SH' > "$GAME_DIR/run.sh"
#!/bin/bash

GAME_DIR="$(pwd)" # This script runs from the game's root directory
TOOLS_DIR="$GAME_DIR/tools"
GAME_ENV_FILE="$TOOLS_DIR/game.env"

# IMPORTANT: This PATH export only affects THIS script's subshell.
# For interactive commands, you MUST run 'export PATH="./tools:$PATH"' in your main terminal.
export PATH="$TOOLS_DIR:$PATH"

# Initialize game environment
if [[ ! -f "$GAME_ENV_FILE" ]]; then
    echo "LEVEL=0" > "$GAME_ENV_FILE"
fi

get_mission_level() {
    source "$GAME_ENV_FILE"
    echo "$LEVEL"
}

set_mission_level() {
    echo "LEVEL=$1" > "$GAME_ENV_FILE"
}

clear_screen() {
    printf "\033c"
}

press_any_key() {
    echo ""
    read -n 1 -s -r -p "Press any key to continue..."
    echo ""
}

# --- Mission Definitions ---

mission0_intro() {
    clear_screen
    echo "====================================================="
    echo "          THE PROTOCOL – Breach of Node 127.4.7.8"
    echo "====================================================="
    echo ""
    echo "You are a cybersecurity analyst. A critical server, Node 127.4.7.8,"
    echo "has been compromised. Initial reports indicate an unknown entity has"
    echo "breached the system. Your objective is to infiltrate, identify the"
    echo "breach, and restore the system to full operational status."
    echo ""
    echo "Your journey begins now."
    echo "Before you start, please enter this command below in your terminal:"
    echo "export PATH=\"./tools:\$PATH\"" # Corrected PATH instruction
    press_any_key
    set_mission_level 1
}

mission1_infiltration() {
    clear_screen
    echo "--- MISSION 1: INFILTRATION ---"
    echo "Objective: Gain access to Node 127.4.7.8."
    echo "A preliminary scan suggests port 22 (SSH) might be open."
    echo ""
    echo "Hint: Use 'nmap' to scan for open ports, then 'ssh' to connect."
    echo "The target IP is 127.0.0.1 (simulated Node 127.4.7.8)."
    echo "Default admin credentials might be in './mission1/creds.txt'."
    echo ""
    echo "Navigate to the mission directory: cd ./mission1"
    echo ""
    # Check for mission completion by fake ssh
    while [[ ! -f "./mission1_complete" ]]; do
        sleep 1 # Wait for fake ssh to create this file
    done
    rm "./mission1_complete" # Clean up
    set_mission_level 2
    echo "Mission 1 complete. Proceeding to Mission 2."
    press_any_key
}

mission2_recon() {
    clear_screen
    echo "--- MISSION 2: RECONNAISSANCE ---"
    echo "Objective: Identify suspicious processes running on the compromised node."
    echo "You've successfully gained SSH access. Now, you need to find anomalies."
    echo ""
    echo "Hint: Look for unusual processes. The /tmp directory is a common place"
    echo "for temporary files, sometimes exploited by attackers."
    echo "Try listing processes and inspecting the /tmp directory."
    echo ""
    echo "Navigate to the mission directory: cd ./mission2"
    echo ""

    # Create rogue process file
    mkdir -p "./mission2"
    cat << 'EOF_M2_ROGUE_PROCESS' > "./mission2/rogue_process.py"
#!/usr/bin/env python3
# This is a simulated rogue process.
# It doesn't do anything real, just exists for the game.
import time
import os
# Simulate some activity
with open("/tmp/system_log_corrupt.txt", "w") as f:
    f.write("Corrupted log entry: [CRITICAL] Data integrity breach detected.\n")
time.sleep(1)
EOF_M2_ROGUE_PROCESS
    chmod +x "./mission2/rogue_process.py"

    # Create a fake /tmp for the game context
    mkdir -p "./mission2/tmp"
    ln -s "./mission2/rogue_process.py" "./mission2/tmp/rogue_process.py"


    while [[ ! -f "./mission2_complete" ]]; do
        echo "Waiting for you to discover the rogue process by running 'ps aux'..."
        sleep 2
    done
    rm "./mission2_complete"
    set_mission_level 3
    echo "Mission 2 complete. Proceeding to Mission 3."
    press_any_key
}

mission3_devops() {
    clear_screen
    echo "--- MISSION 3: DEVOPS ANOMALY ---"
    echo "Objective: Investigate a misconfigured AI core service running in Docker."
    echo "Reports indicate unusual behavior from the AI system. It's managed via Docker."
    echo ""
    echo "Hint 1: Check Docker logs for the 'ai-core-service'. Use 'docker logs ai-core-service'."
    echo "Hint 2: A desktop shortcut for a critical runner seems to be missing."
    echo "        Find 'critical_runner_template', rename it to '.desktop', make it executable,"
    echo "        and then run the command specified in its 'Exec=' line."
    echo ""
    echo "Navigate to the mission directory: cd ./mission3"
    echo ""

    mkdir -p "./mission3"
    cat << 'EOF_M3_DOCKER_LOGS' > "./mission3/docker_logs.txt"
[2025-07-08 10:00:01] AI-CORE: Initializing...
[2025-07-08 10:00:05] AI-CORE: Loading models...
[2025-07-08 10:00:10] AI-CORE: ERROR - Failed to load 'anomaly_detection_module'. Config mismatch.
[2025-07-08 10:00:11] AI-CORE: Warning: Running in degraded mode.
[2025-07-08 10:00:15] AI-CORE: Processing data stream...
[2025-07-08 10:00:20] AI-CORE: ERROR - Malformed input detected. Skipping.
EOF_M3_DOCKER_LOGS

    cat << 'EOF_M3_CRITICAL_RUNNER_TEMPLATE' > "./mission3/critical_runner.desktop.template"
[Desktop Entry]
Version=1.0
Type=Application
Name=Critical System Runner
Comment=Launches the critical system runner for AI integration
Exec=/bin/bash -c "echo 'Critical Runner Launched! AI System re-synced.' && touch $(pwd)/mission3_complete" # Use $(pwd) for absolute path
Icon=system-run
Terminal=false
Categories=System;
EOF_M3_CRITICAL_RUNNER_TEMPLATE
    # Remove the .desktop extension to simulate it being "missing"
    mv "./mission3/critical_runner.desktop.template" "./mission3/critical_runner_template"


    while [[ ! -f "./mission3_complete" ]]; do
        echo "Waiting for you to fix the Docker issue and launch the runner..."
        sleep 2
    done
    rm "./mission3_complete"
    set_mission_level 4
    echo "Mission 3 complete. Proceeding to Mission 4."
    press_any_key
}

mission4_ai_anomaly() {
    clear_screen
    echo "--- MISSION 4: AI ANOMALY ---"
    echo "Objective: Rectify a broken AI configuration and check its status."
    echo "The AI core is behaving erratically. Its configuration file seems corrupted."
    echo "There's also a web-based dashboard for AI status."
    echo ""
    echo "Hint: Find and fix the AI configuration file. Then, open the HTML dashboard."
    echo "The configuration might be in './mission4/ai_config.json'."
    echo "The dashboard is at './mission4/www/index.html'."
    echo "You can open HTML files in your browser using 'xdg-open'."
    echo ""
    echo "Navigate to the mission directory: cd ./mission4"
    echo ""

    mkdir -p "./mission4/www"
    cat << 'EOF_M4_AI_CONFIG_JSON' > "./mission4/ai_config.json"
{
    "ai_modules": [
        "core_logic",
        "data_parser",
        "anomaly_detector_DISABLED"
    ],
    "debug_mode": true,
    "thresholds": {
        "critical": 0.9,
        "warning": 0.5
    }
}
EOF_M4_AI_CONFIG_JSON

    cat << 'EOF_M4_INDEX_HTML' > "./mission4/www/index.html"
<!DOCTYPE html>
<html>
<head>
    <title>AI System Dashboard</title>
    <style>
        body { font-family: monospace; background-color: #1a1a2e; color: #e0e0e0; margin: 20px; }
        .container { background-color: #0f3460; padding: 20px; border-radius: 8px; }
        h1 { color: #e94560; }
        .status-ok { color: #7FFF00; font-weight: bold; }
        .status-warn { color: #FFA500; font-weight: bold; }
        .status-critical { color: #FF0000; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <h1>AI System Status</h1>
        <p>AI Core Status: <span class="status-critical">DEGRADED (Anomaly Detection Offline)</span></p>
        <p>Data Stream: Active</p>
        <p>Last Sync: 2025-07-08 14:30:00</p>
        <p>Module Status:</p>
        <ul>
            <li>Core Logic: <span class="status-ok">Online</span></li>
            <li>Data Parser: <span class="status-ok">Online</span></li>
            <li>Anomaly Detector: <span class="status-critical">OFFLINE (Config Error)</span></li>
        </ul>
        <p><i>Refresh this page after fixing the configuration.</i></p>
    </div>
</body>
</html>
EOF_M4_INDEX_HTML

    # Updated HTML after config fix
    cat << 'EOF_M4_INDEX_FIXED_HTML' > "./mission4/www/index_fixed.html"
<!DOCTYPE html>
<html>
<head>
    <title>AI System Dashboard</title>
    <style>
        body { font-family: monospace; background-color: #1a1a2e; color: #e0e0e0; margin: 20px; }
        .container { background-color: #0f3460; padding: 20px; border-radius: 8px; }
        h1 { color: #e94560; }
        .status-ok { color: #7FFF00; font-weight: bold; }
        .status-warn { color: #FFA500; font-weight: bold; }
        .status-critical { color: #FF0000; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <h1>AI System Status</h1>
        <p>AI Core Status: <span class="status-ok">OPERATIONAL</span></p>
        <p>Data Stream: Active</p>
        <p>Last Sync: 2025-07-08 14:35:00</p>
        <p>Module Status:</p>
        <ul>
            <li>Core Logic: <span class="status-ok">Online</span></li>
            <li>Data Parser: <span class="status-ok">Online</span></li>
            <li>Anomaly Detector: <span class="status-ok">Online</span></li>
        </ul>
        <p><i>System operating at full capacity.</i></p>
    </div>
</body>
</html>
EOF_M4_INDEX_FIXED_HTML


    while grep -q "anomaly_detector_DISABLED" "./mission4/ai_config.json"; do
        echo "Waiting for you to fix 'ai_config.json'..."
        sleep 2
    done
    echo "AI configuration fixed! Check the dashboard."
    # Replace the original index.html with the fixed one
    mv "./mission4/www/index_fixed.html" "./mission4/www/index.html"
    # Player needs to manually open and confirm
    press_any_key # Player presses key after seeing fixed dashboard
    set_mission_level 5
    echo "Mission 4 complete. Proceeding to Mission 5."
    press_any_key
}

mission5_data_leak() {
    clear_screen
    echo "--- MISSION 5: DATA LEAK ---"
    echo "Objective: Analyze a suspicious data leak and identify its source."
    echo "Investigation points to an unauthorized data transfer. A CSV file"
    echo "was found with unusual entries."
    echo ""
    echo "Hint: Examine './mission5/leaked_data.csv'. Look for anomalies."
    echo "The source might be indicated by unusual entries or timestamps."
    echo "You might need to use 'cat' or 'less' to view the file content."
    echo ""
    echo "Navigate to the mission directory: cd ./mission5"
    echo ""

    mkdir -p "./mission5"
    cat << 'EOF_M5_LEAKED_DATA_CSV' > "./mission5/leaked_data.csv"
Timestamp,UserID,Action,DataSizeKB,SourceIP
2025-07-07 10:01:05,user123,login,0.5,192.168.1.10
2025-07-07 10:05:30,admin,report_gen,1.2,192.168.1.15
2025-07-08 13:58:12,guest456,file_read,0.1,192.168.1.20
2025-07-08 14:15:00,SYSTEM_ROGUE,data_exfil,1024.0,203.0.113.42
2025-07-08 14:15:01,SYSTEM_ROGUE,data_exfil,2048.0,203.0.113.42
2025-07-08 14:16:00,user789,logout,0.2,192.168.1.25
EOF_M5_LEAKED_DATA_CSV

    # Player needs to find "SYSTEM_ROGUE" and "203.0.113.42"
    echo "Identify the rogue user and IP address from the CSV. Type them when ready."
    echo "Rogue User ID:"
    read -r ROGUE_USER
    echo "Rogue IP Address:"
    read -r ROGUE_IP

    if [[ "$ROGUE_USER" == "SYSTEM_ROGUE" && "$ROGUE_IP" == "203.0.113.42" ]]; then
        echo "Correct! You've identified the data leak source."
        set_mission_level 6
        echo "Mission 5 complete. Proceeding to Mission 6."
    else
        echo "Incorrect. Re-examine 'leaked_data.csv' carefully."
        press_any_key
        mission5_data_leak # Loop back if incorrect
    fi
    press_any_key
}

mission6_final_fix() {
    clear_screen
    echo "--- MISSION 6: FINAL FIX ---"
    echo "Objective: Apply the final patch to restore all services and secure Node 127.4.7.8."
    echo "You've identified and mitigated several issues. Now, it's time for the final cleanup."
    echo "A patch script has been prepared to restore all compromised settings."
    echo ""
    echo "Hint: Execute './mission6/patch_script.sh'."
    echo "This script will simulate full system restoration."
    echo ""
    echo "Navigate to the mission directory: cd ./mission6"
    echo ""

    mkdir -p "./mission6"
    cat << 'EOF_M6_PATCH_SCRIPT' > "./mission6/patch_script.sh"
#!/bin/bash
echo "Applying security patch..."
sleep 1
echo "Restoring critical system files..."
sleep 1
echo "Restarting services..."
sleep 1
echo "Clearing temporary anomalies..."
sleep 1
echo "System integrity check: OK"
echo "Node 127.4.7.8 is now fully restored and secured."
echo "--- GAME OVER: MISSION ACCOMPLISHED! ---"
# Signal game completion
touch "$(pwd)/mission6_complete" # Use $(pwd) for absolute path
EOF_M6_PATCH_SCRIPT
    chmod +x "./mission6/patch_script.sh"

    while [[ ! -f "./mission6_complete" ]]; do
        echo "Waiting for you to run the patch script..."
        sleep 2
    done
    rm "./mission6_complete"
    set_mission_level 7
    echo "Congratulations! You have successfully completed THE PROTOCOL."
    press_any_key
}

mission7_complete() {
    clear_screen
    echo "====================================================="
    echo "          THE PROTOCOL – Breach of Node 127.4.7.8"
    echo "                MISSION ACCOMPLISHED!"
    echo "====================================================="
    echo ""
    echo "You have successfully neutralized the threat and restored Node 127.4.7.8."
    echo "Thank you for playing!"
    echo ""
    echo "To play again, delete the 'game.env' file: rm ./tools/game.env"
    echo ""
    press_any_key
}

# --- Game Loop ---
CURRENT_LEVEL=$(get_mission_level)

case "$CURRENT_LEVEL" in
    0) mission0_intro ;;
    1) mission1_infiltration ;;
    2) mission2_recon ;;
    3) mission3_devops ;;
    4) mission4_ai_anomaly ;;
    5) mission5_data_leak ;;
    6) mission6_final_fix ;;
    7) mission7_complete ;;
    *) echo "Unknown game level: $CURRENT_LEVEL" ;;
esac
EOF_RUN_SH
chmod +x "$GAME_DIR/run.sh"
echo "✅ Created run.sh."

# 5. Create assistant.sh
cat << 'EOF_ASSISTANT_SH' > "$GAME_DIR/assistant.sh"
#!/bin/bash

GAME_DIR="$(pwd)" # This script runs from the game's root directory
GAME_ENV_FILE="$GAME_DIR/tools/game.env"

# Function to get the current mission level
get_mission_level() {
    if [[ -f "$GAME_ENV_FILE" ]]; then
        source "$GAME_ENV_FILE"
        echo "$LEVEL"
    else
        echo "0" # Default to level 0 if game.env doesn't exist yet
    fi
}

echo "========================================="
echo "  AI Assistant: Node 127.4.7.8 Support"
echo "========================================="
echo "Hello, Analyst! I'm here to provide guidance and insights as you navigate"
echo "THE PROTOCOL. I'll try to keep you on track without giving away too much."
echo "Remember to always 'cd' into the game's root directory before running commands."
echo ""

PREV_LEVEL=-1 # Initialize with a level that won't match immediately

while true; do
    CURRENT_LEVEL=$(get_mission_level)

    if [[ "$CURRENT_LEVEL" -ne "$PREV_LEVEL" ]]; then
        echo ""
        echo "--- AI Assistant Update (Mission Level: $CURRENT_LEVEL) ---"
        case "$CURRENT_LEVEL" in
            0)
                echo "Alright, Analyst, system boot-up complete. The main 'run.sh' script"
                echo "should be starting the game introduction now. Get ready!"
                echo "What NOT to do: Don't panic! Take a deep breath. This is a simulation."
                ;;
            1)
                echo "Mission 1: Infiltration. Your first challenge is to get inside Node 127.4.7.8."
                echo "Think about how you'd normally discover open doors on a network."
                echo "Hint: There's a common tool for network scanning, and another for secure remote access."
                echo "Check the './mission1' directory for any clues, like 'creds.txt'."
                echo "What NOT to do: Don't try to brute-force passwords! We're looking for a specific, provided credential here."
                echo "Also, don't try to connect to real external IPs; stick to 127.0.0.1."
                ;;
            2)
                echo "Mission 2: Reconnaissance. You're in! Excellent work."
                echo "Now, it's time to survey the landscape. We suspect a rogue process is running."
                echo "Hint: How do you list all running programs on a Linux system? And where do attackers often drop temporary, malicious files?"
                echo "Look around in the '/tmp' area (simulated in './mission2/tmp')."
                echo "What NOT to do: Don't delete files blindly! Always inspect first. You might remove a crucial clue."
                ;;
            3)
                echo "Mission 3: DevOps Anomaly. The AI core service is acting up, and it's containerized."
                echo "When a Docker container misbehaves, the first place to check is its output."
                echo "Hint: How do you view the logs of a Docker container? The service name is 'ai-core-service'."
                echo "Also, a critical GUI runner seems to be missing. Desktop shortcuts often have a specific file extension."
                echo "What NOT to do: Don't try to restart or stop the Docker container. Just inspect its logs for now. And be careful when moving files; ensure you use the correct extension for desktop launchers."
                ;;
            4)
                echo "Mission 4: AI Anomaly. You've identified some issues with the AI. Its configuration is likely the culprit."
                echo "Configuration files are usually plain text. You'll need to open and edit it."
                echo "Hint: Look for 'ai_config.json' in 'mission4'. There's a specific module that needs to be re-enabled."
                echo "Once you've made the change, there's a web dashboard to confirm the fix. You'll need a web browser for that."
                echo "What NOT to do: Don't introduce syntax errors into JSON files! A missing comma or bracket can break everything. Use a text editor carefully."
                ;;
            5)
                echo "Mission 5: Data Leak. A serious breach has occurred, and we have a suspicious data file."
                echo "Your task is to analyze it and pinpoint the source of the leak."
                echo "Hint: This file is a CSV. Open it up and look for unusual entries, especially large data transfers or strange user IDs/IP addresses."
                echo "What NOT to do: Don't just skim the file. Pay close attention to every column, especially the timestamps, user IDs, and data sizes. The devil is in the details."
                ;;
            6)
                echo "Mission 6: Final Fix. Excellent work, Analyst! You've uncovered and addressed multiple vulnerabilities."
                echo "Now, it's time for the final sweep – a comprehensive patch to restore the system's integrity."
                echo "Hint: There's a specific script prepared for this in the 'mission6' directory. You just need to execute it."
                echo "What NOT to do: Don't forget to make the script executable before running it! A common oversight."
                ;;
            7)
                echo "Congratulations, Analyst! Mission Accomplished!"
                echo "Node 127.4.7.8 is secure, thanks to your diligent work. You've successfully navigated THE PROTOCOL."
                echo "What NOT to do: Don't forget what you've learned! These concepts are fundamental in cybersecurity."
                echo "If you want to play again, just delete the 'game.env' file in './tools/'."
                ;;
            *)
                echo "Assistant is online, standing by for your next move. Current level: Unknown. Are you sure you're running 'run.sh'?"
                ;;
        </case>
        echo "-----------------------------------------"
        echo ""
        PREV_LEVEL="$CURRENT_LEVEL"
    fi
    sleep 5 # Check every 5 seconds
done
EOF_ASSISTANT_SH
chmod +x "$GAME_DIR/assistant.sh"
echo "✅ Created assistant.sh."

# 6. Create mission directories and files
echo "Creating mission directories and files..."

mkdir -p "$GAME_DIR/mission1"
cat << 'EOF_M1_CREDS' > "$GAME_DIR/mission1/creds.txt"
username: admin
password: protocol_breach_2025
EOF_M1_CREDS
echo "✅ Created mission1/creds.txt"

mkdir -p "$GAME_DIR/mission2"
# rogue_process.py and its symlink are created by run.sh during mission2_recon
echo "✅ Created mission2 directory."

mkdir -p "$GAME_DIR/mission3"
# docker_logs.txt and critical_runner_template are created by run.sh during mission3_devops
echo "✅ Created mission3 directory."

mkdir -p "$GAME_DIR/mission4/www"
# ai_config.json, index.html, and index_fixed.html are created by run.sh during mission4_ai_anomaly
echo "✅ Created mission4/www directory."

mkdir -p "$GAME_DIR/mission5"
# leaked_data.csv is created by run.sh during mission5_data_leak
echo "✅ Created mission5 directory."

mkdir -p "$GAME_DIR/mission6"
# patch_script.sh is created by run.sh during mission6_final_fix
echo "✅ Created mission6 directory."

# 7. Symlink fake commands in tools directory
echo "Creating symlinks for fake commands..."
(
    cd "$TOOLS_DIR" || exit 1 # Exit if cd fails
    ln -sf fake-commands.sh nmap    # -f to force overwrite if symlink exists
    ln -sf fake-commands.sh ssh
    ln -sf fake-commands.sh ps
    ln -sf fake-commands.sh docker
)
echo "✅ Created symlinks in tools directory."

echo ""
echo "====================================================="
echo "          THE PROTOCOL GAME SETUP COMPLETE!"
echo "====================================================="
echo ""
echo "🔥 IMPORTANT: Before playing, you MUST run the following command"
echo "   in EACH terminal session where you will interact with the game:"
echo ""
echo "   export PATH=\"./tools:\$PATH\"" # Updated PATH instruction for current directory
echo ""
echo "   This tells your terminal where to find the game's fake commands."
echo ""
echo "▶️ To start the game (main terminal):"
echo "   ./run.sh" # No need to 'cd' if already in the game's directory
echo ""
echo "🤖 To start the AI assistant (optional, in a separate terminal):"
echo "   ./assistant.sh" # No need to 'cd' if already in the game's directory
echo ""
echo "Good luck, Analyst! The Protocol awaits."
echo "====================================================="
