module Parameters

using JuMP
#using Data
using DelimitedFiles

Base.@kwdef mutable struct ExperimentParameters
    approach::String = MIP_solver # {MIP_solver, col_gen, cg_heur_fo}
    total_time_limit::Float64 = 1e6 # Total time limit for approach in seconds
    MIP_gap_tolerance::Float64 = 1e8
    integer_feasibility_tolerance::Float64 = 1e6
    number_of_threads::Int64 = 1
    screen_output::Int64 = 1
    
end

export ExperimentParameters, read_parameters,set_MIP_solver_parameters, set_rf_parameters, set_fo_parameters, set_empty_cg_parameters

function read_parameters(parameters_file::String)
    param_data = readdlm(parameters_file)

    approach = param_data[1,2]
    total_time_limit = param_data[2,2]
    MIP_gap_tolerance = param_data[3,2]
    integer_feasibility_tolerance = param_data[4,2]
    number_of_threads = param_data[5,2]
    screen_output = param_data[6,2]

    parameters = ExperimentParameters(
        approach,
        total_time_limit,
        MIP_gap_tolerance,
        integer_feasibility_tolerance,
        number_of_threads,
        screen_output
    )

    return parameters
end

function set_MIP_solver_parameters(model::Model, params::ExperimentParameters)
    
    
    set_optimizer_attributes(model,
                            "TimeLimit" => params.total_time_limit,
                            "MIPGap" => params.MIP_gap_tolerance,
                            "IntFeasTol" => params.integer_feasibility_tolerance,
                            "Threads" => params.number_of_threads,
                            "LogToConsole" => params.screen_output)
   
end



end
