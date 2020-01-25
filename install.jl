import YAML
import JLD

home_path = "$(homedir())/.bcp"
if !isdir(home_path)
    mkdir(home_path)
    mkdir("$home_path/commands")
    mkdir("$home_path/repositories")
end

io = open("$(homedir())/.bashrc", "a")
write(io, "\n# bcp alias script inclusion\n")
write(io, "source ~/.bcp/base")
close(io);

io = open("$(homedir())/.bcp/base", "a")
cli_script_path = "$(pwd())/cli.jl"
write(io, "alias bcp='julia $cli_script_path'\n")
write(io, "for FILE in ~/.bcp/commands/* ; do source \$FILE ; done\n")
close(io);

registry_path = "$(homedir())/.bcp/registry.jld"
commands = Dict()
packages = Dict()
JLD.save(registry_path, Dict(
    "commands" => commands,
    "packages" => packages
))

println("Installed successfully")
