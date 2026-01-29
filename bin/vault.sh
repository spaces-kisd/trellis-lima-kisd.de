#!/bin/bash

show_usage() {
echo "Usage: vault <command> [<options>...]
Just a proxy of ansible-vault with all files named vault.yml under the group_vars folder.
See 'ansible-vault --help' for more information.
See 'ansible-vault <command> --help' for more information on a specific command.
If you have problems with ansible execute this command in your VM ( cd ~/trellis && ./bin/vault.sh ).

Examples:
  vault encrypt
  vault view
  vault decrypt
  vault --help
"
}

# Number of arguments passed is less than (lt) 1 show usage and exit with "command not found" (127).
[[ $# -lt 1 ]] && { show_usage; exit 127; }

# If one of the arguments is -h show the usage and exit with "success" (0).
for arg
do
  [[ $arg = -h ]] && { show_usage; exit 0; }
done

dir="group_vars/"
# If the dirctory does not exits you are probably in the /bin directory.
[[ ! -d "$dir" ]] && {
  echo "You are executing this script from the wrong directory.
Try: './bin/vault.sh $1' in the trellis directory."
  exit 127;
}

VAULT_CMD="find $dir -name vault.yml -exec ansible-vault $1 {} +"

echo "Executing: $VAULT_CMD"

$VAULT_CMD
