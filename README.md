# 🚀 ZTURBO_V2 - High Performance Data Transfer Engine (Optimized)

![Version](https://img.shields.io/badge/version-2.0.0%20(Optimized)-blue.svg?style=flat-square)
![Platform](https://img.shields.io/badge/platform-Linux-green.svg?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-orange.svg?style=flat-square)

**ZTURBO_V2** is the next-generation, high-performance evolution of the original ZTURBO toolkit. Re-engineered for maximum efficiency, it features a **RAM-Disk IPC architecture** and **Real-time Monitoring** specifically designed for massive data migrations (Cryo-EM data, Big Data) where every second and every I/O cycle counts.

---

## 🔥 Key Features (V2.0.0 Optimized)

### 1. ⚡ Zero I/O Lag Architecture (New!)
*   **🧠 RAM-Disk IPC**: All Inter-Process Communication (IPC) and monitoring status files are now stored in **RAM (`/dev/shm`)**.
*   **🚀 Zero Disk Overhead**: Monitoring the transfer uses 0% of your Hardisk/SSD bandwidth, ensuring 100% of your storage performance is dedicated solely to the data transfer.

### 2. 📊 Ultra-Responsive Monitoring (ZMTURBO_V2)
*   **⏱️ 1-Second Real-time Refresh**: Progress bars and speeds now update every single second (mulus) instead of the old 5-second interval.
*   **📡 Dual-Format Bandwidth**: Displays network speed in both **MB/s (File size)** and **Mbps/Gbps (Network Bandwidth)** to easily match your ISP/Switch specs.
*   **🟢 Smooth Progress Bar**: High-precision interpolation ensures the progress bar moves smoothly across the screen.

### 3. 📜 Enterprise Reconciliation & History
*   **🕵️ Detailed Audit Logs**: Reports now include **Started Time, Finished Time, Source Path, and Destination Path** for full traceability.
*   **📏 Human-Readable Reports**: All file sizes in history are automatically converted (e.g., `1.2TB` instead of `1200000000`).
*   **📂 Permanent Archive**: While monitoring data is in RAM, your **transfer history is permanently saved** on disk in `~/.zturbo_v2/reports`.

### 4. 🚀 Hybrid Parallel Engine
*   **🏎️ TURBO Mode**: Leverages `fpsync` and multi-threaded `rsync` to saturate 10G/40G/100G network pipes.
*   **🛡️ SAFE Mode**: Prioritizes system stability with `nice` and `ionice` background priorities.

---

## 📦 Installation

1.  **Clone the Repository**
    ```bash
    git clone https://github.com/ddt-mmt/zturbov2.git
    cd zturbov2
    ```

2.  **Run the Installer**
    ```bash
    chmod +x install.sh
    sudo ./install.sh
    ```
    *Note: This version installs as `zturbo_v2` and `zmturbo_v2` to allow side-by-side usage with older versions.*

---

## 🚀 Getting Started

### 1. Launch Transfer Wizard
```bash
zturbo_v2
```

### 2. Monitor in Real-time
Open a new terminal session:
```bash
zmturbo_v2
```

### 3. View History
Inside `zmturbo_v2`, press **`H`** to open the enhanced history menu.

---

## 👨‍💻 Credits
*   **Original Concept**: [ddt-mmt](https://github.com/ddt-mmt)
*   **Optimized V2**: [ddt-mmt](https://github.com/ddt-mmt)

## 🤝 License
Licensed under the **MIT License**.