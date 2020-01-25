using JLD

function config_init()
    if isfile("config.jld")
        save("config.jld", "wd", "")
    end
end

config_init()
