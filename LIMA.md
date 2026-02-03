# Lima VM for Trellis

Uses [Lima](https://github.com/lima-vm/lima) as a fast, Linux-compatible replacement for Vagrant or Trellis-CLI for local development.

## 1. Prerequisites

- **Lima**: v0.20.0+ (Run `./bin/install-lima-on-ubuntu.sh` to install on Ubuntu/Debian).
- **Python**: v3.8+.
- **QEMU**: Required backend.

## 2. Installation

Run setup to create the virtualenv and install Ansible dependencies:

```bash
./bin/setup.sh
```

## 3. Usage

Use the `./bin/lima` helper script to manage the VM. It will automatically check for network configuration issues (IP, ports, hosts file) and guide you if fixes are needed.

### CLI Commands

| Command | Description |
| :--- | :--- |
| `./bin/lima init` | **Recommended:** Starts and provisions the VM in one go. |
| `./bin/lima start` | Starts (or creates) the VM. |
| `./bin/lima stop` | Stops the VM. |
| `./bin/lima restart` | Restarts the VM. |
| `./bin/lima provision` | Runs full Ansible provisioning. |
| `./bin/lima status` | Shows VM status. |
| `./bin/lima shell` | Opens a shell inside the VM. |
| `./bin/lima wp` | Runs WP-CLI commands (e.g., `./bin/lima wp plugin list`). |
| `./bin/lima url` | Prints the site URL. |
| `./bin/lima hosts` | Checks `/etc/hosts` entries. |
| `./bin/lima delete` | Destroys the VM. |
| `./bin/lima rebuild` | Destroys and rebuilds the VM. |

### Provisioning (Specific Tags)
Run specific Ansible roles (defined in `dev.yml`) to save time:

```bash
./bin/lima provision --tags nginx        # Only Nginx
./bin/lima provision --tags php,xdebug   # PHP & Xdebug
```
*Common tags:* `common`, `fail2ban`, `mariadb`, `php`, `xdebug`, `nginx`, `wordpress`

### Shell & VS Code
- **Run Command:** `./bin/lima shell ls -la`
- **WP-CLI:** `./bin/lima wp user list`
- **VS Code:** Press `Ctrl+Shift+B` to **Run Local Server** (Start/Provision) or **Stop Local Server**.

## 4. Configuration

### Updating VM Config
Changes to `lima.yaml` (e.g., `hostIP`) do not apply to existing VMs.
- **Option A (Recommended):** `./bin/lima rebuild`
- **Option B (Manual):** Stop VM -> Edit `~/.lima/<vm-name>/lima.yaml` -> Start VM.

## 5. Internals

- **`lima.yaml`**: VM Spec (Ubuntu 24.04, 4 CPUs, 4GiB RAM, virtiofs).
- **`./bin/lima`**: Main controller; parses `wordpress_sites.yml` for VM name/paths.

## 6. Helper Scripts (`bin/`)

| Script | Description |
| :--- | :--- |
| `install-lima-on-ubuntu.sh` | Installs `limactl` to `~/.local/bin` (useful for Linux users without root). |
| `lima` | Main CLI for managing the local development VM. |
| `manage` | Unified CLI for `deploy`, `provision` (remote), and `vault` operations. |
| `setup.sh` | Installs Python dependencies and Ansible roles. |
