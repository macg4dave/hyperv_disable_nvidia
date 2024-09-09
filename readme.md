# HyperV Disable Nvidia

This repository contains scripts to manage Nvidia and Hyper-V specific configurations for a Debian system. It ensures the system uses the appropriate Xorg configuration depending on whether it is running on bare metal with Nvidia drivers or within a Microsoft Hyper-V environment.

## Overview

The scripts detect the running environment and adjust the Xorg configuration accordingly to avoid issues that may arise from incorrect driver usage in different virtualization contexts. This is particularly useful for systems that dual-boot into different hypervisors or directly on hardware.

## Installation

### Prerequisites

- A Debian-based system with Nvidia drivers installed for bare metal operations.
- Hyper-V for virtualized environments.
- Root or sudo access on the system to move and execute scripts.

### Setup Guide

1. **Clone the Repository:**
   Clone this repository to a location on your system:
   ```
   git clone https://github.com/macg4dave/hyperv_disable_nvidia.git
   cd hyperv_disable_nvidia
   ```

2. **Script Placement:**
   Move the scripts to appropriate directories:
   ```
   sudo cp modlistfiles/hyperv-xorg.sh /usr/local/bin/hyperv-xorg
   sudo cp modlistfiles/hyperv-modblock.sh /usr/local/bin/hyperv-modblock
   sudo cp modlistfiles/hyperv-xorg-changes.sh /usr/local/share/hyperv-disable-nvidia/bin/
   ```

3. **Set Executable Permissions:**
   Ensure the scripts are executable:
   ```
   sudo chmod +x /usr/local/bin/hyperv-xorg
   sudo chmod +x /usr/local/bin/hyperv-modblock
   sudo chmod +x /usr/local/share/hyperv-disable-nvidia/bin/hyperv-xorg-changes.sh
   ```

4. **Configure Systemd Services:**
   Setup systemd services to handle the scripts at boot and shutdown:
   ```
   sudo cp systemd/hyperv-xorg-setup.service /etc/systemd/system/
   sudo cp systemd/hyperv-xorg-changes.service /etc/systemd/system/
   sudo systemctl daemon-reload
   sudo systemctl enable hyperv-xorg-setup.service
   sudo systemctl enable hyperv-xorg-changes.service
   ```

5. **Reboot:**
   Reboot your system to apply the changes and verify that the scripts are functioning correctly:
   ```
   sudo reboot
   ```

## Usage

- **Hyperv-xorg.sh** and **Hyperv-modblock.sh** are automatically triggered by systemd services at boot to configure the system based on its environment.
- **Hyperv-xorg-changes.sh** runs at system shutdown to back up and track changes to the Xorg configuration made during runtime on bare metal.

## Contributions

Contributions are welcome! Please create a pull request or open an issue if you have suggestions or find a bug.

## License

This project is open-sourced under the MIT License. See the LICENSE file for more information.
