import tkinter as tk
from tkinter import ttk
import time

def binary_split(byte):
    b = format(byte, '08b')
    version = b[0:2]
    frame_type = b[2:4]
    subtype = b[4:8]
    return version, frame_type, subtype, b

# Simulation steps with dynamic logs
simulation_steps = [
    {
        "step": "Monitor Mode Enabled",
        "attacker": "Interface set to monitor mode",
        "client": "",
        "ap": ""
    },
    {
        "step": "Tuning wireless adapter to AP channel",
        "attacker": "Adapter tuned to channel 6",
        "client": "",
        "ap": ""
    },
    {
        "step": "Capturing target MAC addresses",
        "attacker": "Captured MACs - Client: {client_mac}, AP: {ap_mac}",
        "client": "",
        "ap": ""
    },
    {
        "step": "Crafting 802.11 Deauthentication Frame...",
        "attacker": "",
        "client": "",
        "ap": ""
    },
    {
        "step": "Injecting frame over air...",
        "attacker": "Deauth frame injected",
        "client": "Received frame: verifying...",
        "ap": ""
    },
    {
        "step": "Client disconnects instantly",
        "attacker": "",
        "client": "Frame accepted. Disconnecting from AP",
        "ap": "Client {client_mac} disconnected"
    },
    {
        "step": "Client tries to reconnect (WPA2 Handshake)",
        "attacker": "Listening for EAPOL frames",
        "client": "Initiating reconnection...",
        "ap": "Starting WPA2 handshake with {client_mac}"
    },
    {
        "step": "Attacker captures EAPOL packets",
        "attacker": "Handshake captured (EAPOL frames)",
        "client": "",
        "ap": ""
    }
]

def run_simulation(target_mac, ap_mac, attacker_log, client_log, ap_log, progress):
    attacker_log.delete("1.0", tk.END)
    client_log.delete("1.0", tk.END)
    ap_log.delete("1.0", tk.END)

    for i, entry in enumerate(simulation_steps):
        step = entry["step"]

        if step == "Crafting 802.11 Deauthentication Frame...":
            frame_byte = 0xC0
            version, frame_type, subtype, bin_str = binary_split(frame_byte)
            attacker_text = (
                f"Deauth frame created with spoofed AP MAC\n"
                f"Frame Control Byte: 0xC0\n"
                f"Binary: {bin_str}\n"
                f" - Version (bits 0-1): {version} → 00 = IEEE 802.11\n"
                f" - Type (bits 2-3): {frame_type} → 00 = Management\n"
                f" - Subtype (bits 4-7): {subtype} → 1100 = Deauthentication"
            )
            client_text = "Binary received: validating frame...\nHeader confirms Management Deauthentication"
            ap_text = ""
        else:
            attacker_text = entry["attacker"].replace("{client_mac}", target_mac).replace("{ap_mac}", ap_mac)
            client_text = entry["client"].replace("{client_mac}", target_mac)
            ap_text = entry["ap"].replace("{client_mac}", target_mac)

        if attacker_text:
            attacker_log.insert(tk.END, f"{attacker_text}\n\n")
        if client_text:
            client_log.insert(tk.END, f"{client_text}\n\n")
        if ap_text:
            ap_log.insert(tk.END, f"{ap_text}\n\n")

        progress["value"] = int((i + 1) / len(simulation_steps) * 100)
        attacker_log.update()
        client_log.update()
        ap_log.update()
        time.sleep(0.8)

def start_gui():
    root = tk.Tk()
    root.title("Bit-Level Wi-Fi Deauthentication Simulator")
    root.geometry("1100x650")
    root.configure(bg="#1a1a1a")

    tk.Label(root, text="Wi-Fi Deauth Attack Visual Simulator", fg="#00FFAA", bg="#1a1a1a", font=("Arial", 16, "bold")).pack(pady=10)

    input_frame = tk.Frame(root, bg="#1a1a1a")
    input_frame.pack()

    tk.Label(input_frame, text="Target Client MAC:", fg="white", bg="#1a1a1a").grid(row=0, column=0, padx=5, pady=5)
    client_entry = tk.Entry(input_frame, width=20)
    client_entry.insert(0, "00:00:00:00:00:00")
    client_entry.grid(row=0, column=1, padx=5)

    tk.Label(input_frame, text="AP MAC:", fg="white", bg="#1a1a1a").grid(row=0, column=2, padx=5, pady=5)
    ap_entry = tk.Entry(input_frame, width=20)
    ap_entry.insert(0, "11:11:11:11:11:11")
    ap_entry.grid(row=0, column=3, padx=5)

    log_frame = tk.Frame(root, bg="#1a1a1a")
    log_frame.pack(padx=10, pady=10, expand=True, fill="both")

    def create_log_panel(title, color):
        panel = tk.Frame(log_frame, bg=color, bd=2)
        label = tk.Label(panel, text=title, bg=color, fg="black", font=("Arial", 10, "bold"))
        label.pack()
        text = tk.Text(panel, height=20, bg="black", fg="lime", font=("Consolas", 10))
        text.pack(expand=True, fill="both")
        return panel, text

    attacker_panel, attacker_log = create_log_panel("Attacker Log", "#ffcccc")
    client_panel, client_log = create_log_panel("Client Log", "#cce5ff")
    ap_panel, ap_log = create_log_panel("Access Point Log", "#ccffcc")

    attacker_panel.pack(side="left", expand=True, fill="both", padx=5)
    client_panel.pack(side="left", expand=True, fill="both", padx=5)
    ap_panel.pack(side="left", expand=True, fill="both", padx=5)

    progress = ttk.Progressbar(root, length=400, mode="determinate")
    progress.pack(pady=10)

    def on_start():
        run_simulation(client_entry.get(), ap_entry.get(), attacker_log, client_log, ap_log, progress)

    tk.Button(root, text="Start Simulation", command=on_start, bg="#00aa00", fg="white", font=("Arial", 11, "bold")).pack(pady=5)

    root.mainloop()

start_gui()
