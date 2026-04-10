# 🚀 ZTURBO_V3 - High Performance Data Transfer Engine (Optimized)

![Version](https://img.shields.io/badge/version-3.0.0%20(Optimized)-blue.svg?style=flat-square)
![Platform](https://img.shields.io/badge/platform-Linux-green.svg?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-orange.svg?style=flat-square)

**ZTURBO_V3** is the next-generation, high-performance evolution of the ZTURBO toolkit. Re-engineered for maximum efficiency, it features a **RAM-Disk IPC architecture**, **Real-time Monitoring**, and **URL Download Support** specifically designed for massive data migrations where every second and every I/O cycle counts.

---

## 🔥 Key Features (V3.0.0 Optimized & Enhanced)

### 1. 🌐 URL Download Wizard (New!)
*   **High-Speed URL Downloads**: Integrated support for downloading files directly from URLs using `aria2c` (multistream) or `wget` (single stream).
*   **Real-time Monitoring**: Just like local transfers, URL downloads are fully integrated into the `zmturbo_v3` monitoring dashboard.
*   **Automatic Reconciliation**: Generates detailed reports for downloads, verifying file integrity and calculating average speeds.

### 2. 📊 Ultra-Responsive Monitoring (ZMTURBO_V3)
*   **⏱️ 1-Second Real-time Refresh**: Progress bars and speeds are updated every second for smooth visual feedback.
*   **📡 Dual-Format Bandwidth**: Displays network speed in both **MB/s (File Size)** and **Mbps/Gbps (Network Bandwidth)** in real-time.
*   **🟢 Smooth Progress Bar**: High-precision interpolation ensures the progress bar moves smoothly.
*   **✨ Ultra-Reliable Progress Bar**: Now adaptively uses JSON output from `rsync` (v3.1.0+) for higher reliability and accuracy.
*   **📏 Consistent Limits**: Thread limit displays in `zmturbo` are now synchronized with the calculation logic in the main engine.

### 3. 📜 Enterprise Reconciliation & History
*   **🕵️ Detailed Audit Logs**: Reports include Start Time, End Time, Source Path, and Destination Path for full traceability.
*   **⚡ Dual-Format Speed Reports**: Average speed in reports now shows both file transfer rate (**MB/s**) and network bandwidth (**Mbps/Gbps**) for easier reading.
*   **📏 Human-Readable Reports**: All file sizes in the history are automatically converted (e.g., `1.2TB` instead of `1200000000`).
*   **📂 Permanent Archive**: Although monitoring data resides in RAM, your transfer history is saved permanently on disk (`~/.zturbo_v3/reports`).
*   **🧹 Auto-Cleanup Dashboard**: Monitoring data is automatically cleared from the dashboard once you exit the job, keeping your monitor clean.

### 4. ⚙️ Smart Resource & Thread Management
*   **🧠 Conservative Thread Auto-Scaling**: The thread calculation algorithm is now more "polite" toward low-specification servers.
    *   **TURBO Mode**: 2x CPU Cores (previously 4x) for maximum stability.
    *   **SAFE Mode**: 0.5x CPU Cores for lightweight background usage.
*   **🛠️ Manual Thread Override**: You can now manually edit the number of threads on the final confirmation screen by pressing **[4]**.
*   **💾 RAM-Aware Scaling**: RAM usage estimation per thread has been increased to 64MB to prevent *OOM (Out Of Memory)* on small VMs.

### 5. ⚡ Zero I/O Lag Architecture
*   **🧠 RAM-Disk IPC**: All Inter-Process Communication (IPC), file status monitoring, and browser UI cache are now stored in **RAM (`/dev/shm`)**.
*   **🚀 Zero Disk Overhead**: Transfer monitoring and UI navigation use 0% of your Hard Disk/SSD bandwidth, ensuring 100% of storage performance is dedicated to data transfer.

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
