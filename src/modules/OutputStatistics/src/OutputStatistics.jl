module OutputStatistics

#using Data
using Parameters
using Dates

Base.@kwdef mutable struct StatisticsData

    date::String = string(Dates.today())
    approach::String = ""
    best_LB::Float64 = -1e12
    best_UB::Float64 = 1e12
    gap::Float64 = 100
    total_time::Float64 = 0.0
    sol_status = 0
end

export StatisticsData, setup_stats_file

function setup_stats_file(params::ExperimentParameters, inputlist_file::String, parameters_file::String)

    inputlist_file = split(inputlist_file, "/")
    params_file = split(parameters_file, "/")
    params_file = "_" * params_file[end]   
    output_file_path = "src/outputFiles/tables/"

    output_file_path = output_file_path * "/$(Int64(params.total_time_limit))s/"

    mkpath(output_file_path)

    date_time = Dates.now()
    time_stamp = string(Dates.today(), "-",
        Dates.hour(date_time), "h",
        Dates.minute(date_time), "m",
        Dates.second(date_time), "s")
    output_file = output_file_path * time_stamp * params_file

    out = open(output_file,"w")

    println(out, "Statistics for GAP")
    println(out, "Date: ", string(Dates.today()))

    if params.approach == "MIP_solver" 
        println(out, "Approach: Formulation with MIP solver")
        println(out, "Time limit: ", params.total_time_limit)
        println(out, "MIP gap tolerance: ", params.MIP_gap_tolerance)
        println(out, "Integer feasibility tolerance: ", params.integer_feasibility_tolerance)
        println(out, "Number of threads: ", params.number_of_threads)
        println(out, "Screen output: ", params.screen_output)

        print(out, "\nInstance & NI & NM  & LB & UB & gap & status & total_time \\\\")
    

    end

    close(out)

    return output_file
end

end
