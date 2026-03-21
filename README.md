# 🚀 ZTURBO_V2 - High Performance Data Transfer Engine

![Version](https://img.shields.io/badge/version-1.3.5%20(Refined)-blue.svg?style=flat-square)
![Platform](https://img.shields.io/badge/platform-Linux-green.svg?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-orange.svg?style=flat-square)

**ZTURBO_V2** is an enterprise-grade Command Line Interface (CLI) toolkit designed for large-scale data migration (Big Data) on high-performance infrastructure, such as Mikrotik CCR1072 routers and 10G/40G server environments.

This toolkit leverages the reliability of `rsync` and the speed of `fpsync` within a *Hybrid Parallelism* architecture, providing a modern interface with multi-layered security mechanisms.

---

## 🔥 Key Features (V1.3.5 Refined)

### 1. Robust & Resilient
*   **🛡️ Auto-Retry Mechanism**: Automatically retries transfers (up to 3 times) in case of packet loss or transient network interruptions.
*   **⏱️ Smart Timeout**: Detects "zombie" connections and resets them automatically to prevent resource exhaustion on network routers.
*   **💾 Pre-Flight Check**: Calculates source data size against destination disk availability before execution to prevent "Disk Full" errors.
*   **📂 Persistent Logs**: Job history and reports are securely stored in `~/.zturbo_v2/reports`, safe from reboots or tool updates.
*   **⌨️ Smart Input**: Full *Readline* support (Backspace/Arrow keys) in all interactive menus for a seamless user experience.
*   **🔩 SMB/CIFS Compatibility**: Includes special `rsync` flags (`--no-p`, `--no-t`) and increased timeouts to ensure reliable transfers to Windows SMB/CIFS shares.


### 2. Hybrid Parallel Engine
*   **🚀 File Parallelism**: Executes individual files in the **background (Parallel)** to saturate network bandwidth instantly.
*   **📂 Folder Partitioning**: Utilizes `fpsync` for multi-threaded folder synchronization.
*   **🏎️ Optimized Flags**: Pre-configured with `--sparse` (optimized for VM images), `-W` (Whole-File mode), and `--inplace` for maximum throughput.

### 3. Advanced Monitoring (ZMTURBO)
*   **📊 Real-time Dashboard**: Elegant, modern dashboard with robust `du`-based real-time progress, speed, and ETA updates.
*   **📡 Network Traffic**: Real-time RX (Down) and TX (Up) speed monitoring.
*   **🧵 Thread Counter**: Live tracking of active process threads per job.
*   **⚡ Anti-Flicker Rendering**: Smooth screen updates using cursor-reset techniques (stable like `htop`).
*   **📉 Resource Guard**: Real-time monitoring of CPU Load and RAM usage to ensure system stability.
*   **💾 Smart Storage Status**: Dynamic disk usage display with intelligent color-coding for alerts.
*   **📜 Refined History View**: Clean, summarized reports focusing on key transfer and reconciliation data.

---

## 📝 Changelog

### V1.3.5 (Modular & Refined)
*   **⚙️ Architectural Refinement**: Modularized `zturbo_v2` into `config.sh`, `utils.sh`, `ui.sh`, and `engine.sh` for improved maintainability and scalability.
*   **✅ Robust Monitoring**: Reverted `zmturbo_v2`'s progress tracking to reliable asynchronous `du`-based calculations, ensuring accurate real-time updates for speed and ETA.
*   **✨ Enhanced UI**: Implemented elegant Unicode box-drawing characters, consistent enterprise-grade English terminology, and improved status messages in `zmturbo_v2`.
*   **🐛 Bug Fixes**: Addressed `main_execution` command not found error due to incorrect shell quoting and race condition in `zmturbo_v2` cleanup logic.
*   **🔧 SMB/CIFS Compatibility**: Added `--no-p`, `--no-t`, `--omit-dir-times` flags and increased timeout to 600s for `rsync` to prevent common errors when transferring to SMB shares.
*   **🗑️ Feature Removal**: Removed the "Remote SSH Source" feature for simplification and security hardening.

### V1.3.4 (Stable Release)
*   **🛠️ Monitor Fix**: Resolved critical UI freeze issue by moving size calculation (`du`) to background process.
*   **📜 History Fixed**: Disabled auto-deletion of logs; transfer history is now preserved indefinitely.
*   **🌐 Remote Source**: Added support for Remote SSH Source (TrueNAS/Direct).
*   **🔍 SSH Pre-Check**: Integrated automated connection testing for remote sources.
*   **📊 Remote Scaling**: Support for `du` and size calculation over SSH.

### V1.3.3
*   **📡 Network Monitor**: Added real-time Download (RX) and Upload (TX) speed indicators.
*   **🧵 Thread Tracking**: Added live active thread/process counter per job.
*   **📂 Persistent History**: Reports are now saved to `~/.zturbo_v2/reports` to survive reboots and updates.
*   **✨ UX Polish**: Implemented Smart Input buffering and strict Anti-Flicker cursor management.
*   **🐛 Critical Fix**: Resolved an issue where the transfer process would not start (infinite loop) after confirming with "OK" in the final review screen.

---

## 🆚 Operational Modes

ZTURBO_V2 offers two distinct modes tailored for different operational requirements:

| Feature | 🛡️ SAFE MODE (Default) | 🚀 TURBO MODE |
| :--- | :--- | :--- |
| **Philosophy** | "Reliability & System Stability" | "Maximum Performance" |
| **Execution** | Sequential (One by one) | Hybrid Parallel (Multi-Threaded) |
| **Priority** | Low Priority (`nice`/`ionice`) | High Priority (Max Resources) |
| **Write Method** | Atomic (Temp File -> Rename) | In-Place (Direct Write) |
| **CPU Usage** | Moderate (Delta/Checksum calculation) | Low (Whole-File Streaming) |
| **Best For** | **Business Hours**, Daily Syncs | **Initial Migration**, Maintenance Windows |
| **Resume** | Supported (via Partial Directory) | Supported (via In-Place Verification) |

---

## 📦 Installation

1.  **Clone the Repository**
    ```bash
    git clone https://github.com/ddt-mmt/zturbo_v2.git
    cd zturbo_v2
    ```

2.  **Universal Installer**
    ```bash
    chmod +x install.sh
    sudo ./install.sh
    ```
    *The script automatically detects your OS (Ubuntu, CentOS, RHEL, Fedora, Arch) and installs required dependencies (`rsync`, `fpart`).*

### Alternative: Install via .DEB Package
For Debian/Ubuntu-based systems:
```bash
sudo dpkg -i dist/zturbo_v2.deb
```

---

## 🚀 Getting Started

### 1. Running Transfers (ZTURBO_V2)
Launch the interactive wizard by typing:
```bash
zturbo_v2
```

### 2. Real-time Monitoring (ZMTURBO)
Open a new terminal session and type:
```bash
zmturbo_v2
```

---

## 👨‍💻 Credits
*   **Original Idea & Concept**: [ddt-mmt](https://github.com/ddt-mmt)
*   **Developer**: [ddt-mmt](https://github.com/ddt-mmt)

## 🤝 License
Licensed under the **MIT License**.