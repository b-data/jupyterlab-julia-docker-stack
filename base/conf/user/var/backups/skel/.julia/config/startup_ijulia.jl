if !in(MIME("application/pdf"), IJulia.ijulia_mime_types)
    IJulia.register_mime(MIME("application/pdf"))
end

if ispath(joinpath(ENV["HOME"], "bin")) && ENV["SHLVL"] == "0"
    ENV["PATH"] =
        joinpath(ENV["HOME"], "bin") *
        (Sys.iswindows() ? ';' : ':') *
        ENV["PATH"]
end

if ispath(joinpath(ENV["HOME"], ".local/bin")) && ENV["SHLVL"] == "0"
    ENV["PATH"] =
        joinpath(ENV["HOME"], ".local/bin") *
        (Sys.iswindows() ? ';' : ':') *
        ENV["PATH"]
end
