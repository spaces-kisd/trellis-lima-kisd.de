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

Use the `./bin/task vm` helper commands to manage the VM. It will automatically check for network configuration issues (IP, ports, hosts file) and guide you if fixes are needed.

### CLI Commands

| Command | Description |
| :--- | :--- |
| `./bin/task vm start` | Starts (or creates) the VM and checks `/etc/hosts`. |
| `./bin/task vm provision` | Runs full Ansible provisioning (starts VM if needed). |
| `./bin/task vm stop` | Stops the VM. |
| `./bin/task vm restart` | Restarts the VM. |
| `./bin/task vm shell` | Opens a shell inside the VM. |
| `./bin/task vm wp` | Runs WP-CLI commands (e.g., `./bin/task vm wp plugin list`). |
| `./bin/task vm delete` | Destroys the VM. |

### Provisioning (Specific Tags)
Run specific Ansible roles (defined in `dev.yml`) to save time:

```bash
./bin/task vm provision --tags nginx        # Only Nginx
./bin/task vm provision --tags php,xdebug   # PHP & Xdebug
```
*Common tags:* `common`, `fail2ban`, `mariadb`, `php`, `xdebug`, `nginx`, `wordpress`

### Shell & VS Code
- **Run Command:** `./bin/task vm shell ls -la`
- **WP-CLI:** `./bin/task vm wp user list`
- **VS Code:** Press `Ctrl+Shift+B` to **Run Local Server** (Start/Provision) or **Stop Local Server**.

## 4. Configuration

### Updating VM Config
Changes to `lima.yaml` (e.g., `hostIP`) do not apply to existing VMs.
- **Update:** `./bin/task vm delete && ./bin/task vm start`
- **Manual:** Stop VM -> Edit `~/.lima/<vm-name>/lima.yaml` -> Start VM.

## 5. Internals

- **`lima.yaml`**: VM Spec (Ubuntu 24.04, 4 CPUs, 4GiB RAM, virtiofs).
- **`./bin/task`**: Main controller; parses `wordpress_sites.yml` for VM name/paths.

## 6. Helper Scripts (`bin/`)

| Script | Description |
| :--- | :--- |
| `install-lima-on-ubuntu.sh` | Installs `limactl` to `~/.local/bin` (useful for Linux users without root). |
| `task` | Unified CLI for local VM (`vm`), remote (`remote`), and `vault` operations. |
| `setup.sh` | Installs Python dependencies and Ansible roles. |
