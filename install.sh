#!/bin/bash

# Check for Root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: This script must be run as root."
    echo "Please run with: sudo $0"
    exit 1
fi

# Update and install dependencies
echo "Installing system dependencies (gcc-14, headers, build-essential)..."
apt-get update -q
apt-get install -y build-essential linux-headers-$(uname -r) gcc gcc-14

# Switch USB Mode (Activates the device)
echo "Switching USB mode..."
/usr/sbin/usb_modeswitch -KQ -v a69c -p 5723 || echo "Mode switch warning (Device might already be active or unplugged)."

echo "Creating temporary workspace..."
mkdir -p tmp_ugreen_wifi
cd tmp_ugreen_wifi

# Download the driver
# (Renaming output to 'driver.zip' to handle Chinese characters in the URL safely)
echo "Downloading driver files..."
wget -c "https://download.lulian.cn/2025-drive/UGREEN-CM762-35264_USB%E6%97%A0%E7%BA%BF%E7%BD%91%E5%8D%A1%E9%A9%B1%E5%8A%A8_V1.4.zip" -O driver.zip

# Unzip
echo "file Unzipping..."
unzip -o driver.zip -d CM762

# Run the manufacturer install script
echo "Running manufacturer setup script..."
chmod +x CM762/Linux/aic8800_linux_driver/install_setup.sh
./CM762/Linux/aic8800_linux_driver/install_setup.sh

# Install the .deb package
echo "Installing Debian package..."
dpkg -i CM762/Linux/linux_driver_package/aic8800d80fdrvpackage.deb

# Cleanup
echo "Cleaning up temporary files..."
cd ..
rm -rf tmp_ugreen_wifi

echo "-----------------------------------------------------"
echo "Please reboot your system now to apply changes."
echo "-----------------------------------------------------"