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
import Master
import Pricing
import Parameters
