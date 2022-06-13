println("Executing user-specific startup file (", @__FILE__, ")...")

try
    using Revise
    println("Revise started")
catch e
    @warn "Error initializing Revise" exception=(e, catch_backtrace())
end

if isfile("Project.toml") && isfile("Manifest.toml")
    Pkg.activate(".")
else
    Pkg.activate("$(ENV["HOME"])/.julia/environments/v$(VERSION.major).$(VERSION.minor)")
end
