# 🚀 ZTURBO_V3 - High Performance Data Transfer Engine (Optimized)

![Version](https://img.shields.io/badge/version-3.0.0%20(Optimized)-blue.svg?style=flat-square)
![Platform](https://img.shields.io/badge/platform-Linux-green.svg?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-orange.svg?style=flat-square)

**ZTURBO_V3** is the next-generation, high-performance evolution of the ZTURBO toolkit. Re-engineered for maximum efficiency, it features a **RAM-Disk IPC architecture** and **Real-time Monitoring** specifically designed for massive data migrations (Cryo-EM data, Big Data) where every second and every I/O cycle counts.

---

## 🔥 Key Features (V3.0.0 Optimized & Enhanced)

### 1. ⚙️ Smart Resource & Thread Management
*   **🧠 Conservative Thread Auto-Scaling**: The thread calculation algorithm is now more "polite" toward low-specification servers.
    *   **TURBO Mode**: 2x CPU Cores (previously 4x) for maximum stability.
    *   **SAFE Mode**: 0.5x CPU Cores for lightweight background usage.
*   **🛠️ Manual Thread Override**: You can now manually edit the number of threads on the final confirmation screen by pressing **[4]**. Supports number validation and an option to return to automatic (leave input empty).
*   **💾 RAM-Aware Scaling**: RAM usage estimation per thread has been increased to 64MB to prevent *OOM (Out Of Memory)* on small VMs.

### 2. ⚡ Zero I/O Lag Architecture
*   **🧠 RAM-Disk IPC**: All Inter-Process Communication (IPC), file status monitoring, and browser UI cache are now stored in **RAM (`/dev/shm`)**.
*   **🚀 Zero Disk Overhead**: Transfer monitoring and UI navigation use 0% of your Hard Disk/SSD bandwidth, ensuring 100% of storage performance is dedicated to data transfer.

### 3. 📊 Ultra-Responsive Monitoring (ZMTURBO_V3)
*   **⏱️ 1-Second Real-time Refresh**: Progress bars and speeds are updated every second for smooth visual feedback.
*   **📡 Dual-Format Bandwidth**: Displays network speed in both **MB/s (File Size)** and **Mbps/Gbps (Network Bandwidth)**.
*   **🟢 Smooth Progress Bar**: High-precision interpolation ensures the progress bar moves smoothly.
*   **✨ Ultra-Reliable Progress Bar**: Now adaptively uses JSON output from `rsync` (if supported by your `rsync` v3.1.0+) for higher reliability and accuracy.
*   **📏 Consistent Limits**: Thread limit displays in `zmturbo` are now synchronized with the calculation logic in the main engine.

### 4. 📜 Enterprise Reconciliation & History
*   **🕵️ Detailed Audit Logs**: Reports include Start Time, End Time, Source Path, and Destination Path for full traceability.
*   **📏 Human-Readable Reports**: All file sizes in the history are automatically converted (e.g., `1.2TB` instead of `1200000000`).
*   **📂 Permanent Archive**: Although monitoring data resides in RAM, your transfer history is saved permanently on disk (`~/.zturbo_v3/reports`).
*   **⚡ Fast Post-Transfer Verification**: The file verification process after transfer completion is significantly faster by focusing checks only on the transferred items, reducing I/O load.

### 5. 🚀 Hybrid Parallel Engine
*   **🏎️ TURBO Mode**: Utilizes `fpsync` and multi-threaded `rsync` to saturate 10G/40G/100G network pipes.
*   **🛡️ SAFE Mode**: Prioritizes system stability with background priorities (`nice` and `ionice`).
*   **🔒 Enhanced Security & Reliability**: Potentially unsafe `eval` usage has been removed and replaced with modern, robust execution methods, improving code security.

### 6. 🖥️ Ultra-Responsive Directory UI (ZTURBO)
*   **💨 Instant Navigation**: Directory browsing in `zturbo` will no longer "hang" or slow down, even in large directories, thanks to a smart and efficient background file size calculation system.
*   **🧠 RAM-Disk Cache**: File and folder sizes are calculated asynchronously and cached in the RAM-disk for ultra-fast UI updates.

### 7. ⚙️ Smart Dependency Management
*   **💡 Proactive Feedback**: `zturbo` now provides helpful warnings if your `rsync` version does not support optimal features (like JSON output), allowing you to take action for the best experience.

---

## 📦 Installation

1.  **Clone the Repository**
    ```bash
    git clone https://github.com/ddt-mmt/zturbov3.git
    cd zturbov3
    ```

2.  **Run the Installer**
    ```bash
    chmod +x install.sh
    sudo ./install.sh
    ```

---

## 🚀 Getting Started

### 1. Launch Transfer Wizard
```bash
zturbo_v3
```

### 2. Monitor in Real-time
Open a new terminal session:
```bash
zmturbo_v3
```

### 3. View History
Inside `zmturbo_v3`, press **`H`** to open the enhanced history menu.

---

## 👨‍💻 Credits
*   **Original Concept**: [ddt-mmt](https://github.com/ddt-mmt)
*   **Optimized V3**: [ddt-mmt](https://github.com/ddt-mmt)

## 🤝 License
Licensed under the **MIT License**.
