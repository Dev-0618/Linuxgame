🚨 THE PROTOCOL – Breach of Node 127.4.7.8 🚨

A Beginner-Friendly Technical Simulation Game
👁️‍🗨️ Overview

Welcome, Analyst. Node 127.4.7.8, a critical system, has been compromised. An unknown entity has breached our defenses, leaving a trail of misconfigurations, rogue processes, and data anomalies. Your mission, should you choose to accept it, is to infiltrate the system, identify the breach, and restore full operational integrity.

This 30-minute simulation is designed for beginners, blending Command Line Interface (CLI) interactions with simulated Graphical User Interface (GUI) elements, all within your Ubuntu terminal. Learn fundamental concepts in cybersecurity, Linux, DevOps, AI, and data analysis without requiring any real services or complex setups.
✨ Features

    🕵️‍♂️ 6 Engaging Missions: Each mission introduces a new technical concept:

        Infiltration: nmap & ssh basics.

        Reconnaissance: Process discovery (ps) & file system exploration (/tmp).

        DevOps: Docker log analysis (docker logs) & GUI launcher files (.desktop).

        AI Anomaly: Configuration file (.json) editing & web dashboard (.html) interaction.

        Data Leak: CSV data analysis.

        Final Fix: Executing system patch scripts.

    🤖 Simulated Environment: No real services needed! Commands like nmap, ssh, docker, ps are faked via symlinked bash scripts.

    🗣️ Human-like AI Assistant: An optional second terminal runs assistant.sh, providing indirect hints and "what NOT to do" advice in real-time.

    📜 Immersive Storyline: Dive into a realistic terminal-based narrative with logs, corrupted files, fake credentials, and step-by-step transitions.

    💻 CLI & GUI Blend: Experience both command-line exploration and simulated graphical interactions (like launching .desktop files and viewing HTML dashboards).

🚀 Getting Started
Prerequisites

    A Linux environment (specifically tested on Ubuntu).

    Basic familiarity with opening and using a terminal.

    git installed (sudo apt install git if you don't have it).

Setup Instructions

    Open your terminal.

    Clone the game repository:

    git clone https://github.com/Dev-0618/Linuxgame/

    Navigate to this specific game's directory:

    cd Linuxgame/the-protocol/ # Assuming 'the-protocol' is the directory for this game

    Make the setup script executable:

    chmod +x setup.sh

    Run the setup script:

    ./setup.sh

    This script will automatically create the ~/game directory and populate it with all the necessary game files. Follow its output carefully.

🎮 How to Play
1. Set Your Terminal's PATH (CRUCIAL!)

This is the most important step to ensure the game's simulated commands (nmap, ssh, ps, docker) work correctly. You must run this command in every new terminal session where you plan to play the game:

export PATH="$HOME/game/tools:$PATH"

2. Start the Main Game

Open your primary terminal window and run:

cd ~/game
./run.sh

    Read the game's introduction and press any key when prompted.

    The game will guide you through missions, providing objectives and hints.

3. Start the AI Assistant (Optional, Recommended)

Open a second, separate terminal window and run:

cd ~/game
./assistant.sh

    This AI will provide indirect hints and "what not to do" advice, making the experience more immersive and helpful. Keep this terminal open alongside your main game terminal.

4. Gameplay Loop

    Read: Pay close attention to the mission objectives and hints in both terminals.

    Navigate: The game will often instruct you to cd into specific mission directories (e.g., cd ~/game/mission1).

    Execute: Use standard Linux commands (and the game's fake ones) to achieve the mission objectives.

        Examples: ls, cat, nano (or gedit), mv, chmod, nmap, ssh, ps, docker logs, xdg-open.

    Progress: The game (run.sh) will automatically detect when you've completed an objective and move you to the next mission.

🗺️ Mission Overview (No Spoilers!)

Each mission builds on your understanding of different technical concepts:

    Mission 1: Infiltration - Gaining initial access.

    Mission 2: Reconnaissance - Discovering hidden threats.

    Mission 3: DevOps Anomaly - Troubleshooting containerized services and GUI launchers.

    Mission 4: AI Anomaly - Fixing configurations and using web dashboards.

    Mission 5: Data Leak - Analyzing compromised data.

    Mission 6: Final Fix - Restoring system integrity.

🐛 Troubleshooting

    command not found (e.g., nmap, docker):

        Solution: You must run export PATH="$HOME/game/tools:$PATH" in your current terminal session. This is the most common issue.

    Permission denied:

        Solution: Ensure the file you're trying to run has execute permissions (chmod +x filename).

    .desktop: command not found errors:

        Solution: Remember, .desktop files are configuration files, not direct executables. You need to cat the .desktop file, find the Exec= line, and then manually run the command specified there.

    Game is stuck "Waiting for you to...":

        Solution: Double-check that you've performed the exact action required by the mission. Ensure your fake-commands.sh file is correctly updated (especially for Mission 2's ps aux trigger). If all else fails, Ctrl+C the run.sh script and restart it (./run.sh).

🔁 Playing Again

To reset the game and play from the beginning:

rm ~/game/tools/game.env

Then, simply start the game again with cd ~/game && ./run.sh.
🌐 Repository & Future Games

This game is part of a larger project. You can find this game and future similar technical simulation games at:

https://github.com/Dev-0618/Linuxgame/

Each game will reside in its own dedicated directory within the repository, and each will have its own setup.sh script to handle its specific installation.
🤝 Credits

Developed as a technical simulation to introduce fundamental cybersecurity and Linux concepts.

Good luck, Analyst. The Protocol awaits!
