module OutputStatistics

using Data
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
    inputclass = "_" * inputlist_file[end]
    params_file = split(parameters_file, "/")
    params_file = "_" * params_file[end]   
    formulation = "_" *params.formulation
    output_file_path = "src/outputFiles/tables/"
    if params.approach == "MIP_solver" || params.approach == "rffo" || params.approach == "rfvfo"  || params.approach == "rfo" || params.approach == "rfifo"  
        
        output_file_path = output_file_path * "$(params.approach)/$(params.formulation)/$(params.MIP_model)"
        if params.capacity_violation_variables == true
            output_file_path = output_file_path * "+capacity_violation_variables/$(params.solver)/$(Int64(params.total_time_limit))s/"
        else
            if params.relaxation == 0
                output_file_path = output_file_path * "/$(params.solver)/$(Int64(params.total_time_limit))s/"
            else
                output_file_path = output_file_path * "/$(params.solver)/relaxation/"
            end
        end
    elseif params.approach == "cg"  || params.approach == "cgsc"
       
        output_file_path = output_file_path * "/$(params.approach)/$(params.solver)/$(Int64(params.total_time_limit))s/"
        
    end

    mkpath(output_file_path)

    date_time = Dates.now()
    time_stamp = string(Dates.today(), "-",
        Dates.hour(date_time), "h",
        Dates.minute(date_time), "m",
        Dates.second(date_time), "s")
    output_file = output_file_path * time_stamp * formulation * params_file

    out = open(output_file,"w")

    println(out, "Statistics for CLSP with setup carryover")
    println(out, "Date: ", string(Dates.today()))

    if params.approach == "MIP_solver" || params.approach == "cg" || params.approach == "cgsc"
        println(out, "Approach: Formulation with MIP solver")
        println(out, "MIP model: ", params.MIP_model)
        println(out, "Formulation: ", params.formulation)
        println(out, "Capacity violation variables: ", params.capacity_violation_variables)
        println(out, "Solver: ", params.solver)
        println(out, "Time limit: ", params.total_time_limit)
        println(out, "MIP gap tolerance: ", params.MIP_gap_tolerance)
        println(out, "Integer feasibility tolerance: ", params.integer_feasibility_tolerance)
        println(out, "Number of threads: ", params.number_of_threads)
        println(out, "Screen output: ", params.screen_output)

        print(out, "\nInstance & NI & NM & NT & LB & UB & gap & status & total_time \\\\")
    elseif params.approach == "rf"|| params.approach == "rf0" || params.approach == "rf1"|| params.approach == "rfv"
        println(out, "Approach: Relax-and-fix")
        println(out, "MIP model: ", params.MIP_model)
        println(out, "Capacity violation variables: ", params.capacity_violation_variables)
        println(out, "Solver: ", params.solver)
        println(out, "Relax-and-fix time limit: ", params.rf_max_time)
        println(out, "Restricted model time limit: ", params.rf_restricted_model_max_time)
        println(out, "RF window size factor: ",  params.rf_window_size_factor)
        println(out, "RF step size factor: ", params.rf_step_size_factor)
        println(out, "RF window size: ",  20/params.rf_window_size_factor)
        println(out, "RF step size: ", 20/params.rf_step_size_factor)

        print(out, "\nInstance & NI & NM & NT & rf_UB & rf_iter & rf_BT & rf_time & status & total_time \\\\")
    elseif params.approach == "rffo" || params.approach == "rfvfo" || params.approach == "rfo" || params.approach == "rfifo"
        println(out, "Approach: Relax-and-fix with fix-and-optimize")
        println(out, "MIP model: ", params.MIP_model)
        println(out, "Capacity violation variables: ", params.capacity_violation_variables)
        println(out, "Solver: ", params.solver)
        println(out, "RF time limit: ", params.rf_max_time)
        println(out, "RF restricted model time limit: ", params.rf_restricted_model_max_time)
        println(out, "RF window size factor: ",  params.rf_window_size_factor)
        println(out, "RF step size factor: ", params.rf_step_size_factor)
        println(out, "FO time limit: ", params.fo_max_time)
        println(out, "FO restricted model time limit: ", params.fo_restricted_model_max_time)
        println(out, "FO window size factor: ", params.fo_window_size_factor)
        println(out, "FO step size factor: ", params.fo_step_size_factor)
        println(out, "FO theta: ", params.fo_theta)
        println(out, "FO max window size factor: ", params.fo_max_window_size_factor)
        println(out, "FO max rounds without improvement: ", params.fo_max_rounds_without_improvement)

        println(out, "MIP gap tolerance: ", params.MIP_gap_tolerance)
        println(out, "Integer feasibility tolerance: ", params.integer_feasibility_tolerance)
        println(out, "Number of threads: ", params.number_of_threads)
        println(out, "Screen output: ", params.screen_output)

        print(out, "\nInstance & NI & NT & rf_UB & rf_iter & rf_BT & rf_BT_Int & rf_time & fo_UB & fo_improv & fo_iter & fo_rnds & fo_time & status & total_time \\\\")

    elseif params.approach == "cg" || params.approach == "cgsc"
        println(out, "Approach: Column generation")
        println(out, "MIP model: ", params.MIP_model)
        println(out, "Formulation: ", params.formulation)
        println(out, "Solver: ", params.solver)
        println(out, "Time limit: ", params.total_time_limit)
        println(out, "MIP gap tolerance: ", params.MIP_gap_tolerance)
        println(out, "Integer feasibility tolerance: ", params.integer_feasibility_tolerance)
        println(out, "Number of threads: ", params.number_of_threads)
        println(out, "Screen output: ", params.screen_output)
        println(out, "integer method: ", params.relaxation)

        print(out, "\nInstance & NI & NT & LB & UB & gap & status & total_time \\\\")

    end

    close(out)

    return output_file
end

end
