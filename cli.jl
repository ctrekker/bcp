import YAML

include("util.jl")
include("url_checker.jl")

init_pwd = pwd()

subcommand = ARGS[1]
if length(ARGS) > 1
    option = ARGS[2]
end

if subcommand === "clone"
    clone = `git clone $option`
    # run(clone)
elseif subcommand === "install"
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
elseif subcommand === "read_registry"
    include("read_registry.jl")
end
