import YAML

include("util.jl")
include("url_checker.jl")

init_pwd = pwd()

subcommand = ARGS[1]
if length(ARGS) > 1
    option = ARGS[2]
end

if subcommand === "install"
    if is_url(option)
        repo_home = "$(homedir())/.bcp/repositories"
        before = readdir(repo_home)

        pre_pwd = pwd()
        cd("$(homedir())/.bcp/repositories")
        run(`git clone $option`)

        after = readdir(repo_home)
        filter!(x->!(x in before), after)
        repo_name = after[1]
        println()

        cd(repo_name)
        registry_add_package(pwd())
    else
        cd(option)
        registry_add_package(pwd())
    end
elseif subcommand === "uninstall"
    registry_remove_package(option)
elseif subcommand === "list"
    for (package_name, package_data) ∈ registry_get_packages()
        println(package_name)
        for command_name ∈ package_data["commands"]
            println("\t$command_name")
        end
    end
elseif subcommand === "read_registry"
    include("read_registry.jl")
end
