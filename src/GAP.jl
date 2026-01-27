push!(LOAD_PATH, "src/modules/")

__precompile__()

using Pkg
Pkg.activate(".")

using JuMP
using Gurobi
using CPUTime
using DelimitedFiles

#import Data
#import Formulation
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
    
end

main(ARGS)