# ZTURBO Architecture Blueprint (V1.3.5 Modular & Refined)

## 1. High-Level Overview

ZTURBO is a modular shell-based application that leverages native Linux tools (`rsync`, `fpsync`, `du`, `find`) for high-performance data transfers. It now features a robust asynchronous `du`-based monitoring system for real-time progress updates.

```mermaid
graph TD
    User([User]) -->|Interact| ZTURBO[ZTURBO CLI]
    User -->|Monitor| ZMTURBO[ZMTURBO Monitor]
    
    subgraph Source Selection
        ZTURBO -->|Local| LocalFiles[Local FS / Mounts]
    end

    subgraph Core Engine
        LocalFiles --> ModeSelect{Select Mode}
        ModeSelect -->|Safe Mode| Sequential[Sequential Rsync]
        ModeSelect -->|Turbo Mode| Hybrid[Hybrid Parallel Engine]
        
        Sequential -->|Exec| TransferProcess[Transfer Process]
        Hybrid -->|Exec| BackgroundJobs[Background Jobs & Fpsync]
    end
    
    subgraph Data Flow
        TransferProcess -->|Write| DestStorage[(Destination Storage)]
        BackgroundJobs -->|Write| DestStorage
    end
    
    subgraph Monitoring System
        ZTURBO -->|Create Job Dir| JobDir[Job Directory]
        JobDir -->|Write Info/Status| JobFiles[Monitor Files]
        ZMTURBO -->|Read JobFiles| JobFiles
        ZMTURBO -->|Display| TUI[Terminal UI]
    end
```

## 2. Transfer Execution Flow (Main Logic)

The core logic of `zturbo` handles user input, path selection, and mode switching before initiating the actual data movement.

```mermaid
sequenceDiagram
    participant User
    participant Menu as Menu System
    participant Utils as Utility Functions
    participant Engine as Transfer Engine
    participant Log as Report Generator

    User->>Menu: Select Source (Local FS / Mounts)
    User->>Menu: Select Destination Path
    
    Menu->>Utils: Calculate Total Source Size
    Utils-->>Menu: Return Total Size
    
    User->>Menu: Select Mode (SAFE/TURBO)
    User->>Menu: Confirm (Type 'OK')
    
    Note over Menu, Engine: Initialize Job & Handover
    
    Menu->>Engine: Initialize Transfer
    Engine->>Log: Create Start Report
    Engine->>Utils: Start Dynamic Governor
    
    alt SAFE MODE
        Engine->>Engine: Run Single Rsync (Blocking)
    else TURBO MODE
        loop For Each Source
            alt Is Directory
                Engine->>Engine: Run Fpsync (Parallel Threads)
            else Is File
                Engine->>Engine: Run Rsync Background Job (&)
            end
        end
        Engine->>Engine: Wait for All PIDs
    end
    
    Engine->>Utils: Post-Execution Verification
    Utils-->>Log: Write Reconciliation Report
    Utils-->>User: Show Final Status
```


## 4. Directory Structure & Components

```mermaid
classDiagram
    class ZTURBO_Package {
        +install.sh
        +uninstall.sh
        +README.md
    }
    
    class Modular_Scripts {
        +zturbo (Main Launcher)
        +zmturbo (Monitor)
        +lib/
        +-- config.sh
        +-- utils.sh
        +-- ui.sh
        +-- engine.sh
    }
    
    class Job_Management {
        +/dev/shm/zturbo_v3_dashboard/JOB_ID/
        +-- pid
        +-- info
        +-- status
        +-- du.res
        +-- du.lock
        +-- zmturbo_cache
        +-- zmturbo_meta
        +$HOME/.zturbo_v3/reports/*.txt
    }
    
    ZTURBO_Package *-- Modular_Scripts
    Modular_Scripts --> Job_Management : Manages
```
