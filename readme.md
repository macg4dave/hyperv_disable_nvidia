<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HyperV Disable Nvidia - Installation Guide</title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; }
        h1, h2 { color: #333; }
        p, li { color: #555; }
    </style>
</head>
<body>
    <h1>HyperV Disable Nvidia</h1>
    <p>This repository contains scripts to manage Nvidia and Hyper-V specific configurations for a Debian system. It ensures the system uses the appropriate Xorg configuration depending on whether it is running on bare metal with Nvidia drivers or within a Microsoft Hyper-V environment.</p>

    <h2>Overview</h2>
    <p>The scripts detect the running environment and adjust the Xorg configuration accordingly to avoid issues that may arise from incorrect driver usage in different virtualization contexts. This is particularly useful for systems that dual-boot into different hypervisors or directly on hardware.</p>

    <h2>Installation</h2>
    <h3>Prerequisites</h3>
    <ul>
        <li>A Debian-based system with Nvidia drivers installed for bare metal operations.</li>
        <li>Hyper-V for virtualized environments.</li>
        <li>Root or sudo access on the system to move and execute scripts.</li>
    </ul>

    <h3>Setup Guide</h3>
    <ol>
        <li><strong>Clone the Repository:</strong>
            <p>Clone this repository to a location on your system:</p>
            <pre><code>git clone https://github.com/macg4dave/hyperv_disable_nvidia.git
cd hyperv_disable_nvidia</code></pre>
        </li>
        <li><strong>Script Placement:</strong>
            <p>Move the scripts to appropriate directories:</p>
            <pre><code>sudo cp modlistfiles/hyperv-xorg.sh /usr/local/bin/hyperv-xorg
sudo cp modlistfiles/hyperv-modblock.sh /usr/local/bin/hyperv-modblock
sudo cp modlistfiles/hyperv-xorg-changes.sh /usr/local/share/hyperv-disable-nvidia/bin/</code></pre>
        </li>
        <li><strong>Set Executable Permissions:</strong>
            <p>Ensure the scripts are executable:</p>
            <pre><code>sudo chmod +x /usr/local/bin/hyperv-xorg
sudo chmod +x /usr/local/bin/hyperv-modblock
sudo chmod +x /usr/local/share/hyperv-disable-nvidia/bin/hyperv-xorg-changes.sh</code></pre>
        </li>
        <li><strong>Configure Systemd Services:</strong>
            <p>Setup systemd services to handle the scripts at boot and shutdown:</p>
            <pre><code>sudo cp systemd/hyperv-xorg-setup.service /etc/systemd/system/
sudo cp systemd/hyperv-xorg-changes.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable hyperv-xorg-setup.service
sudo systemctl enable hyperv-xorg-changes.service</code></pre>
        </li>
        <li><strong>Reboot:</strong>
            <p>Reboot your system to apply the changes and verify that the scripts are functioning correctly:</p>
            <pre><code>sudo reboot</code></pre>
        </li>
    </ol>

    <h2>Usage</h2>
    <ul>
        <li><strong>Hyperv-xorg.sh</strong> and <strong>Hyperv-modblock.sh</strong> are automatically triggered by systemd services at boot to configure the system based on its environment.</li>
        <li><strong>Hyperv-xorg-changes.sh</strong> runs at system shutdown to back up and track changes to the Xorg configuration made during runtime on bare metal.</li>
    </ul>

    <h2>Contributions</h2>
    <p>Contributions are welcome! Please create a pull request or open an issue if you have suggestions or find a bug.</p>

    <h2>License</h2>
    <p>This project is open-sourced under the MIT License. See the LICENSE file for more information.</p>

</body>
</html>