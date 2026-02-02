push!(LOAD_PATH, "src/modules/")

__precompile__()

using Pkg
Pkg.activate(".")

using JuMP
using Gurobi
using CPUTime
using DelimitedFiles

import Data
import Formulation
#import Master
#import Pricing
import Parameters
import OutputStatistics

# >>>>> INSTRUCTIONS <<<<<
# Args:                        [1]              [2]             [3]                           
# To run the code: julia gap.jl <input_files> <parameters_files>
#
# EXAMP
# julia src/GAP.jl src/input_files/inputList_test.txt src/parameters_file/parameters

function main(ARGS)

    #Read inputList files
    inputlist_file = String(ARGS[1])
    input = readdlm(inputlist_file)

    #Read parameters files
    parameters_file = String(ARGS[2])
    params = Parameters.read_parameters(parameters_file)
    
    #Set Gurobi environment
    GRB_ENV = Gurobi.Env()

    #Setup statistics output files
    output_file = OutputStatistics.setup_stats_file(params,inputlist_file,parameters_file)

    num_inst = input[1] 

    for inst in 1:num_inst
        stats = OutputStatistics.StatisticsData()

        #caminho da instância
        instance_file = String(input[inst + 1])
        instance_file_split = split(instance_file, "/")
        tipo_data = instance_file_split[3]
        if tipo_data == "STD" || tipo_data == "gap_e"
            data = Data.read_instance(instance_file)
        elseif tipo_data == "gap_a" || tipo_data == "gap_b" || tipo_data == "gap_c" || tipo_data == "gap_d"
            data = Data.read_instance_abcd(instance_file)        
        end   

        model = Model(() -> Gurobi.Optimizer(GRB_ENV))

        solution = OutputStatistics.init_std_form_solution(data)

        if params.approach == "MIP_solver"
            Formulation.create_model!(data, model)
            #write_to_file(model, "model.lp")

            Parameters.set_MIP_solver_parameters(model,params)

            start_time = time_ns()

            Formulation.solve_stdform_model!(model, data, solution, stats)

            finish_time = time_ns()
            total_time = (finish_time - start_time) * 1e-9
            stats.total_time = total_time

            for m in 1:data.NM
                for j in 1: data.NJ
                    if solution.x[m,j] > 0
                        println("x[$m,$j] = ",solution.x[m,j] )
                    end
                end
            end

        elseif params.approach == "col_gen"
         println("wip")
        end

        OutputStatistics.print_stats(data, params, stats, output_file)
    end
    
    
end

main(ARGS)