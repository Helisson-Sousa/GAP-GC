module Formulation

using JuMP
using Gurobi
using Data
using OutputStatistics

export create_model!

function create_model!(data::InstanceData, model::Model)
    M = 1:data.NM
    J = 1:data.NJ

    #create variables
    @variable(model, x[m in M, j in J], Bin)

    #create objective function
    @objective(model, Min, sum(data.cost[m, j] * x[m, j] for m in M, j in J)  )

    #create Constraints
    @constraint(model, assingment_constrant[j in J], sum(x[m, j] for m in M ) == 1 )
    @constraint(model, capacity_constrant[m in M], sum(data.w[m, j] * x[m, j] for j in J) <= data.cap[m])

    return
end

function solve_stdform_model!(model::Model, data::InstanceData, sol::StdFormModelSolution,
    stats::StatisticsData) 

    M = 1:data.NM 
    J = 1:data.NJ

    optimize!(model)

    sol.status = termination_status(model)
    sol.primal_bound = 1e8
    sol.dual_bound = -1e8

    fill!(sol.x, 0.0)
   
    stats.sol_status = sol.status

    if has_values(model)

        sol.primal_bound = objective_value(model)
        sol.dual_bound = objective_bound(model)

        stats.total_time = solve_time(model)
        stats.best_LB = sol.dual_bound
        stats.best_UB = sol.primal_bound
        stats.gap = 100 * ((stats.best_UB - stats.best_LB) / stats.best_UB)
        
        for m in M, j in J
            if value(model[:x][m,j]) > 0.0001
                sol.x[m, j] = value(model[:x][m, j]) 
            end
        end

       
    end

end
end #end module