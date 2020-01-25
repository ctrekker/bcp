import YAML
import JLD

registry_path = "$(homedir())/.bcp/registry.jld"

function get_config(path)
    return YAML.load(open("$path/config.yaml"))
end
function get_registry()
    return JLD.load(registry_path)
end
function save_registry(registry)
    JLD.save(registry_path, registry)
end

function registry_add_command(command_entry, package_name)
    i = "commands"
    registry = get_registry()
    if !haskey(registry["commands"], command_entry["name"])
        registry["commands"][command_entry["name"]] = package_name
    else
        return registry["commands"][command_entry["name"]]
    end
    save_registry(registry)
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
    registry = get_registry()
    if haskey(registry["packages"], package_name)
        println("ERROR: Package \"$package_name\" already installed")
        return false
    end
    config = get_config(root)
    println("Installing package \"$package_name\"...")

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
    save_registry(registry);
    println("Installed package \"$package_name\"")
end
function registry_install_package(package_name)
    if is_url(package_name)
        repo_home = "$(homedir())/.bcp/repositories"
        before = readdir(repo_home)

        pre_pwd = pwd()
        cd("$(homedir())/.bcp/repositories")
        run(`git clone $package_name`)

        after = readdir(repo_home)
        filter!(x->!(x in before), after)
        repo_name = after[1]
        println()

        cd(repo_name)
        registry_add_package(pwd())
    else
        cd(package_name)
        registry_add_package(pwd())
    end
end
function registry_remove_package(package_name)
    println("Uninstalling package \"$package_name\"...")
    
    registry = get_registry()
    package_data = registry["packages"][package_name]
    for command_name ∈ package_data["commands"]
        try
            rm("$(homedir())/.bcp/commands/$command_name")
        catch x
            println(x)
        end
        delete!(registry["commands"], command_name)
    end
    if package_data["linked"] === 0
        try
            rm("$(homedir())/.bcp/repositories/$package_name", recursive=true)
        catch x
            println(x)
        end
    end
    delete!(registry["packages"], package_name)
    save_registry(registry)
    println("Uninstalled package \"$package_name\"")
end
function registry_get_packages()
    registry = get_registry()
    return registry["packages"]
end

function get_installation_source(package_name)
    registry = get_registry()
    package_data = registry["packages"][package_name]
    if package_data["linked"] === 1
        return package_data["root"]
    else
        pre_pwd = pwd()
        cd(package_data["root"])
        git_url = read(`git remote get-url --all origin`, String)
        git_url = git_url[1:length(git_url)-1]
        cd(pre_pwd)

        return git_url
    end
end
