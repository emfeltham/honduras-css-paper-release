# distance covered

include("../../code/setup/environment.jl")

ndf = JLD2.load_object(datapath * "network_info_" * dte * ".jld2");

@subset! ndf (:wave .== 4) .& (:relation .∈ Ref(["free_time", "personal_private", "union"]));

sort!(ndf, [:relation, :village_code])

# average density
@chain ndf begin
   @rtransform(:density = density(:graph))
   groupby(:relation)
   combine(
      :density => mean,
      :density => std => :std,
      renamecols = false
   )
end
