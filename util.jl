import YAML
import JLD

registry_path = "$(homedir())/.bcp/registry.jld"

function get_config(path)
    return YAML.load(open("$path/config.yaml"))
end

function registry_add_command(command_entry, package_name)
    i = "commands"
    registry = JLD.load(registry_path)
    if !haskey(registry["commands"], command_entry["name"])
        registry["commands"][command_entry["name"]] = package_name
    else
        return registry["commands"][command_entry["name"]]
    end
    JLD.save(registry_path, registry)
    return true
end
function system_add_command(command, root)
    cd("$root")
    name = command["name"]
    filename = command["file"]
    executor = command["executor"]
    cd_command = ""
    if haskey(command, "directory")
        working_dir = command["directory"]
        abs_working_dir = pwd()
        cd_command = "cd $abs_working_dir && "
        cd("$init_pwd")
        cd("$root")
    end

    fullpath = abspath("$filename")
    
    alias_str_command = "alias $name='$(cd_command)$executor $fullpath'\n"
    io = open("$(homedir())/.bcp/commands/$name", "a")
    write(io, alias_str_command)
    close(io);
end
function registry_add_package(root)
    package_name = basename(abspath(root))
    registry = JLD.load(registry_path)
    if haskey(registry["packages"], package_name)
        println("ERROR: Package \"$package_name\" already installed")
        return false
    end
    config = get_config(root)
    println("Installing package \"$package_name\"")

    commands = config["commands"]
    for command ∈ commands
        registered_command_pkg = registry_add_command(command, package_name)
        if registered_command_pkg !== true
            println("ERROR: Command \"$(command["name"])\" already registered for package \"$registered_command_pkg\"")
        else
            system_add_command(command, root)
            println("Command added: $(command["name"])")
        end
    end
    registry = JLD.load(registry_path)
    registry["packages"][package_name] = Dict(
        "root" => root,
        "commands" => map(x->x["name"], commands),
        "linked" => !occursin(".bcp", root) ? 1 : 0
    )
    JLD.save(registry_path, registry);
end
