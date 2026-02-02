module Data

using DelimitedFiles

struct InstanceData
    instance_name::String
    NM::Int64             #Number of Machines
    NJ::Int64             #Number of jobs
    cap::Array{Int64}     #capacity
    cost::Array{Int64}    # cost
    w::Array{Int64}       # Weights of the jobs
end

export InstanceData, read_instance

function read_instance(instance_file::String)
    data = readdlm(instance_file)
    instance_name = instance_file
    
    NM = data[1, 1]
    println(NM)

    NJ = data[1, 2]
    println(NJ)

    cap = Array{Int64}(undef, NM)
    for i in 1:NM
        cap[i] = data[2, i]
    end
    println(cap)

    cost = Array{Int64}(undef, NM, NJ)
    for i in 1:NM
        for j in 1:NJ
            cost[i,j] = data[i + 2, j]
        end
    end
    println(cost)

    w = Array{Int64}(undef, NM, NJ)
     for i in 1:NM
        for j in 1:NJ
            w[i,j] = data[i + 5, j]
        end
    end
    println(w)
    
    instance_data = InstanceData(instance_name, NM, NJ, cap, cost, w)

    return instance_data
end
function read_instance_abcd(instance_file::String)
    file = open(instance_file)
    fileText = read(file, String)
    data = split(fileText)
    instance_name = instance_file
    
    NM = parse(Int64, data[1])

    NJ = parse(Int64, data[2])

    cost = Array{Int64}(undef, NM, NJ)
    for i in 1:NM
        for j in 1:NJ
            cost[i,j] = parse(Int64, data[j + 2 + ((i-1)*NJ)])
        end
    end

    w = Array{Int64}(undef, NM, NJ)
    for i in 1:NM
        for j in 1:NJ
            w[i,j] = parse(Int64, data[j + 2 + (NM * NJ) + ((i-1)*NJ)])
        end
    end

    cap = Array{Int64}(undef, NM)
    for i in 1:NM
        cap[i] = parse(Int64, data[i + 2 + (2 * NM * NJ)])
    end
    
    instance_data = InstanceData(instance_name, NM, NJ, cap, cost, w)

    return instance_data
end

end