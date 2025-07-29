#!/bin/bash

# Auto-fix: If /etc/modprobe.d/virtualbox-dkms.conf is a directory, rename it
VBOX_CONF="/etc/modprobe.d/virtualbox-dkms.conf"
if [ -d "$VBOX_CONF" ]; then
    echo "[fix] Detected directory instead of file at $VBOX_CONF"
    sudo mv "$VBOX_CONF" "${VBOX_CONF}.bak"
    echo "[fix] Renamed it to ${VBOX_CONF}.bak to prevent libkmod errors"
fi

# Auto-detect the distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "Unable to detect distribution."
    exit 1
fi

echo "Detected Distro: $DISTRO"

# Define hook/script install paths
ARCH_HOOKS_DIR="/etc/initcpio/hooks"
ARCH_SCRIPTS_DIR="/etc/initcpio/install"
DEB_HOOKS_DIR="/etc/initramfs-tools/hooks"
DEB_SCRIPTS_DIR="/etc/initramfs-tools/scripts/init-bottom"

# Function for Arch-based system
install_arch() {
    echo "[install] Setting up for Arch-based system..."

    spinner() {
        local pid=$1
        local delay=0.1
        local spinstr='|/-\'
        while kill -0 "$pid" 2>/dev/null; do
            for c in / - \\ \|; do
                printf "\r[install] Setting up for Arch-based system... [%c]" "$c"
                sleep $delay
            done
        done
        printf "\r[install] Setting up for Arch-based system... [✔]\n"
    }
    
    # Example long-running task (you can replace this with your actual install command)
    (sleep 5) &
    
    # Get PID of last background task
    spinner $!

    sudo cp hooks/failwipe $ARCH_HOOKS_DIR/
    sudo cp hooks/failwipe_encrypt $ARCH_HOOKS_DIR/
    sudo cp install/failwipe $ARCH_SCRIPTS_DIR/
    sudo cp install/failwipe_encrypt $ARCH_SCRIPTS_DIR/

    sudo chmod +x $ARCH_HOOKS_DIR/failwipe*
    sudo chmod +x $ARCH_SCRIPTS_DIR/failwipe*

    sudo mkinitcpio -P
    echo "Arch-based setup setup complete."
}

# Function for Debian-based distros
install_debian() {
    echo "[install] Setting up for Debian-based system..."

    #!/bin/bash

    spinner() {
        local pid=$1
        local delay=0.1
        local spinstr='|/-\'
        while kill -0 "$pid" 2>/dev/null; do
            for c in / - \\ \|; do
                printf "\r[install] Setting up for Arch-based system... [%c]" "$c"
                sleep $delay
            done
        done
        printf "\r[install] Setting up for Arch-based system... [✔]\n"
    }
    
    # Example long-running task (you can replace this with your actual install command)
    (sleep 5) &
    
    # Get PID of last background task
    spinner $!

    sudo cp hooks/failwipe $DEB_HOOKS_DIR/
    sudo cp hooks/failwipe_encrypt $DEB_HOOKS_DIR/
    sudo cp install/failwipe $DEB_SCRIPTS_DIR/
    sudo cp install/failwipe_encrypt $DEB_SCRIPTS_DIR/

    sudo chmod +x $DEB_HOOKS_DIR/failwipe*
    sudo chmod +x $DEB_SCRIPTS_DIR/failwipe*

    sudo update-initramfs -u
    echo "[done] Debian-based setup complete."
}

# Choose installer based on distro ID

if [ "$DISTRO" == "arch" ] || [ "$DISTRO" == "manjaro" ] || [ "$DISTRO" == "blackarch" ]; then
    install_arch
elif [ "$DISTRO" == "debian" ] || [ "$DISTRO" == "parrotos" ] || [ "$DISTRO" == "kali" ]; then
    install_debian
else
    echo "Unsupported distribution: $DISTRO"
    exit 1
fi

# Final warning message
echo
echo "!!! ⚠️  WARNING: Do not forget your password."
echo "Entering the wrong password more than five times"
echo "may trigger a destructive action and result in permanent data loss!"
echo