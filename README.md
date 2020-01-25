# BCP - BurnsCoding Package management
## Basic installation
As of now, functionality is limited to linux-based operating systems. Also, julia does not come packaged so it needs to be installed seperately.

Clone the git repository somewhere safe

`git clone https://github.com/ctrekker/bcp.git`

Move into the repository directory

`cd bcp`

Execute the installation script

`julia install.jl`

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

