#!/bin/bash

# Auto-detect the distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "Unable to detect distribution."
    exit 1
fi

echo "Detected Distro: $DISTRO"

# Variables for both cases
ARCH_HOOKS_DIR="/etc/initcpio/hooks"
ARCH_SCRIPTS_DIR="/etc/initcpio/install"
DEB_HOOKS_DIR="/etc/initramfs-tools/hooks"
DEB_SCRIPTS_DIR="/etc/initramfs-tools/scripts/init-bottom"

# Function to install on Arch-based distros
install_arch() {
    sudo cp hooks/failwipe $ARCH_HOOKS_DIR/
    sudo cp hooks/failwipe_encrypt $ARCH_HOOKS_DIR/
    sudo cp install/failwipe $ARCH_SCRIPTS_DIR/
    sudo cp install/failwipe_encrypt $ARCH_SCRIPTS_DIR/

    sudo chmod +x $ARCH_HOOKS_DIR/failwipe*
    sudo chmod +x $ARCH_SCRIPTS_DIR/failwipe*

    sudo mkinitcpio -P
    echo "Arch-based system setup complete."
}

# Function to install on Debian-based distros
install_debian() {
    sudo cp hooks/failwipe $DEB_HOOKS_DIR/
    sudo cp hooks/failwipe_encrypt $DEB_HOOKS_DIR/
    sudo cp install/failwipe $DEB_SCRIPTS_DIR/
    sudo cp install/failwipe_encrypt $DEB_SCRIPTS_DIR/

    sudo chmod +x $DEB_HOOKS_DIR/failwipe*
    sudo chmod +x $DEB_SCRIPTS_DIR/failwipe*

    sudo update-initramfs -u
    echo "Debian-based system setup complete."
}

# Run the appropriate install function based on distro
if [ "$DISTRO" == "arch" ] || [ "$DISTRO" == "manjaro" ] || [ "$DISTRO" == "blackarch" ]; then
    install_arch
elif [ "$DISTRO" == "debian" ] || [ "$DISTRO" == "parrotos" ] || [ "$DISTRO" == "kali" ]; then
    install_debian
else
    echo "Unsupported distribution: $DISTRO"
    exit 1
fi

# Display final warning
echo "!!! ⚠️ Warning: Do not forget your password. Entering the wrong password more than five times may trigger a destructive action and result in permanent data loss !!!"

