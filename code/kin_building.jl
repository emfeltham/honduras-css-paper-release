# kin_building.jl

nd(cr)

rhv4 = load_object(datapath * "rhv4_" * dte * ".jld2");

rb = select(rhv4, :name, :building_id)
dropmissing!(rb)
rename!(rb, :building_id => :building_id_a1)
leftjoin!(cr, rb, on = :alter1 => :name)

rename!(rb, :building_id_a1 => :building_id_a2)
leftjoin!(cr, rb, on = :alter2 => :name)

@chain cr begin
    @transform!(:same_building_a = :building_id_a1 .== :building_id_a2)
end

@chain cr begin
    groupby(kin)
    combine(:same_building_a => mean, renamecols = false)
end

fx = @eval @formula(response ~ $socio * ($kin + same_building_a))
# mr = glm(fx, cr, Bernoulli(), LogitLink())
mr = lm(fx, cr)
vif(mr)

fx_ = @eval @formula(response ~ $socio * ($kin))
mr1 = lm(fx_, cr)

#%%

