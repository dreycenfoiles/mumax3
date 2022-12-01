module mumax3

using NPZ
using Glob
using CSV 
using DataFrames

export run_mumax3

function run_mumax3(script)
    # Run mumax3

    name = "tmp"
    scriptname = name * ".mx3"
    outputdir = name * ".out"

    write(scriptname, script)

    # The > nul is to suppress the output
    run(`mumax3 -f $scriptname`)
    run(`mumax3-convert -numpy $outputdir/"*.ovf"`) # Convert OVF to NPY 

    data_array = [] 

    # Read in all the NPY files and store them in a single array
    for file in glob(outputdir * "/m*.npy")
        push!(data_array, npzread(file))
    end

    fields = cat(data_array..., dims=5)

    table = CSV.File(outputdir * "/table.txt") |> DataFrame

    rm(outputdir, recursive=true) # Remove output directory
    rm(scriptname) # Remove script file

    data = Dict("fields" => fields, "table" => table)

    return data 

end
    
end # module mumax3
