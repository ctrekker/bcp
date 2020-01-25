import YAML
import JLD

home_path = "$(homedir())/.bcp"
if !isdir(home_path)
    mkdir(home_path)
    mkdir("$home_path/commands")
    mkdir("$home_path/repositories")
end

io = open("$(homedir())/.profile", "a")
write(io, "\n# bcp script inclusion\n")
write(io, "PATH=\"\$HOME/.bcp/commands:\$PATH\"")
close(io);

io = open("$(homedir())/.bcp/commands/bcp", "a")
cli_script_path = "$(pwd())/cli.jl"
write(io, "julia $cli_script_path \$@\n")
close(io);
run(`chmod +x $(homedir())/.bcp/commands/bcp`)

registry_path = "$(homedir())/.bcp/registry.jld"
commands = Dict()
packages = Dict()
JLD.save(registry_path, Dict(
    "commands" => commands,
    "packages" => packages
))

println("Installed successfully")
