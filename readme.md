# HyperV Disable Nvidia

HyperV Disable Nvidia manages Nvidia and Hyper-V configurations on Debian-based systems with Nvidia GPUs. It ensures the system uses the appropriate Xorg configuration depending on whether it is running on bare metal with Nvidia drivers or within a Microsoft Hyper-V environment.

## Overview

The scripts detect the running environment and adjust the Xorg configuration accordingly to avoid issues that may arise from incorrect driver usage in different virtualization contexts. This is particularly useful for systems that dual-boot into different hypervisors or operate directly on hardware.

### Prerequisites

- A Debian-based system with Nvidia drivers installed for bare metal operations.
- Hyper-V for virtualized environments.
- Root or sudo access on the system to move and execute scripts.

## Installation

1. **Clone the Repository:**
   Clone this repository to a location on your system:
   ```
   git clone https://github.com/macg4dave/hyperv_disable_nvidia.git
   cd hyperv_disable_nvidia
   git submodule init
   git submodule update
   ```

2. **Script Placement:**
   Move the scripts to appropriate directories:
   ```
   sudo cp -r ./modlistfiles /usr/local/share/
   ```

3. **Set Executable Permissions:**
   Ensure the scripts are executable:
   ```
   sudo chmod +x /usr/local/share/modlistfiles/bin/hyperv-xorg.sh
   sudo chmod +x /usr/local/share/modlistfiles/bin/hyperv-xorg-changes.sh
   sudo chmod +x /usr/local/share/modlistfiles/bin/hyperv-modblock.sh
   sudo chmod +x /usr/local/share/modlistfiles/bin/hyperv-detect-runner.sh
   sudo chmod +x /usr/local/share/modlistfiles/bin/error-logging/error-logging.sh
   ```

4. **Configure Systemd Services:**
   Setup systemd services to handle the scripts at boot and shutdown:
   ```
   sudo cp hyperv-xorg-setup.service /etc/systemd/system/
   sudo cp hyperv-xorg-changes.service /etc/systemd/system/
   sudo systemctl daemon-reload
   sudo systemctl enable hyperv-xorg-setup.service
   sudo systemctl enable hyperv-xorg-changes.service
   ```

5. **Copy your existing /etc/X11/xorg.conf:**
   Ensuring that your current Nvidia xorg.conf is saved:
   ```
   sudo cp /etc/X11/xorg.conf /usr/local/share/modlistfiles/nvidia/xorg.conf
   ```

6. **Reboot:**
   Reboot your system to apply the changes and verify that the scripts are functioning correctly:
   ```
   sudo reboot
   ```

## Usage

- All logs are stored in /var/log/hyperv_disable_nvidia/
- **Hyperv-xorg.sh** and **Hyperv-modblock.sh** are automatically triggered by systemd services at boot to configure the system based on its environment.
- **Hyperv-xorg-changes.sh** runs at system shutdown to back up and track changes to the Xorg configuration made during runtime on bare metal.

## Contributions

Contributions are welcome! Please create a pull request or open an issue if you have suggestions or find a bug.

## License

This project is open-sourced under the MIT License. See the LICENSE file for more information.
