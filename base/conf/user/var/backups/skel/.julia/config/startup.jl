println("Executing user-specific startup file (", @__FILE__, ")...")

Pkg.activate(; io=devnull)

try
    using Revise
    println("Revise started")
catch e
    @warn "Error initializing Revise" exception=(e, catch_backtrace())
end

if isfile(joinpath(pwd(), "Project.toml")) &&
    isfile(joinpath(pwd(), "Manifest.toml"))

    Pkg.activate(pwd())
else
    Pkg.activate(joinpath("$(ENV["HOME"])", ".julia", "environments",
            "v$(VERSION.major).$(VERSION.minor)"))
end
if "TERM_PROGRAM" in keys(ENV)
    println("  → Overrides the environment set by the Code Julia extension!")
end
