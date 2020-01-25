# BCP - BurnsCoding Package management
## Basic installation
As of now, functionality is limited to linux-based operating systems. Also, julia does not come packaged so it needs to be installed seperately.

Clone the git repository somewhere safe

`git clone https://github.com/ctrekker/bcp.git`

Move into the repository directory

`cd bcp`

Execute the installation script

`julia install.jl`

Restart the current terminal and the command `bcp` will be added

## Package configuration
To configure a package to be installable via bcp, create a `config.yaml` file in the root of the project. Ensure it is included in your VCS if applicable. Below is an example `config.yaml`

```
commands:
    - name: fibb          # name of command which will execute the script
      file: fibonacci.js  # file in which to execute
      executor: node      # command used to execute the program
    - name: count
      file: counter.jl
      executor: julia
    - name: backup
      file: backup.sh
      executor: bash
      directory: /home/ctrekker/backup_save_dir  # working directory to run script in
```

## Package installation
After each installation the current terminal needs to be reset. To avoid this, one may execute (on linux) `source ~/.bcp/base` which reloads the package commands.

To install a local bcp-configured project:

`bcp install <PROJECT-PATH>`

Where `<PROJECT-PATH>` is the local or absolute path to the desired project to be installed

To install from a git repository:

`bcp install <GIT-REPO-URL>`

Where `<GIT-REPO-URL>` is the URL of the desired bcp-configured git repository to be installed. For example, to install `ExampleBCP`, one can use the command

`bcp install https://github.com/ctrekker/ExampleBCP.git`

## Other commands
### `bcp read_registry`
Used for debugging the package registry file. Prints the registry in a more human-readable format. For advanced users only.