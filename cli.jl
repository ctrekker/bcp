import YAML

include("util.jl")
include("url_checker.jl")

init_pwd = pwd()

subcommand = ARGS[1]
if length(ARGS) > 1
    option = ARGS[2]
end

if subcommand === "install"
    registry_install_package(option)
elseif subcommand === "uninstall"
    registry_remove_package(option)
elseif subcommand === "update"
    installation_source = get_installation_source(option)
    registry_remove_package(option)
    registry_install_package(installation_source)
elseif subcommand === "list"
    for (package_name, package_data) ∈ registry_get_packages()
        println(package_name)
        for command_name ∈ package_data["commands"]
            println("\t$command_name")
        end
    end
elseif subcommand === "installation_source"
    println(get_installation_source(option))
elseif subcommand === "read_registry"
    include("read_registry.jl")
end
