# base_models.jl
# julia --threads=32 --project="." "honduras-css-paper/code/base_models_tie_2.jl" > "output_m1_base_tie.txt"

@show pwd()

include("../../code/setup/analysis preamble.jl")

println("data loaded")

prds = [
    :response,
    :kin431, :relation,
    :age, :man,
    :educated,
    :degree,
    :dists_p_notinf, :dists_p,
    :man_a,
    :age_mean_a,
    :age_diff_a,
    :religion_c,
    :religion_c_a,
    :isindigenous_a,
    :degree_mean_a,
    :degree_diff_a,
    :wealth_d1_4, 
    :wealth_d1_4_mean_a,
    :wealth_d1_4_diff_a,
    :educated_a
];

dat = dropmissing(cr, prds);
sort!(dat, [:perceiver, :order]);

println("model start")

m3 = let dat = dat;  
    fx = @formula(
        response ~
        socio4 * (kin431 + relation + degree +
        man + age + age^2 + educated +
        religion_c +
        wealth_d1_4 +
        coffee_cultivation +
        isindigenous +
        educated_a + educated&educated_a +
        man_a + man&man_a +
        isindigenous_a + isindigenous_a&isindigenous +
        religion_c_a + religion_c&religion_c_a +
        degree_mean_a + degree_diff_a +
        degree & degree_mean_a +
        age_mean_a + age_diff_a +
        age & age_mean_a +
        wealth_d1_4_mean_a +
        wealth_d1_4 & wealth_d1_4_mean_a +
        wealth_d1_4_diff_a +
        kin431 & relation +
        dists_p_notinf +
        dists_p_notinf & dists_p) +
        (!socio4)&(dists_a_notinf + dists_a_notinf & dists_a) +
        (1|village_code) + (1|perceiver)
        # (1|building_id)
    );
    
    x = fit(
        MixedModel, fx, dat,
        Binomial(), LogitLink(),
        fast = true
    )
end

println("model finished")

# save_object("interaction models/base1_tie_3.jld2", m1)

# tpr prediction
function effgrid(dat; kinvals = [false], socio = socio)
    # separate or the same (across rates)?
    ds = dat[!, :dists_p][dat[!, :dists_p] .!= 0];
    distmean = mean(ds)

    tpr_dict = Dict{Symbol, Any}()

    tpr_dict[:dists_p] = distmean
    tpr_dict[:age] = mean(dat[!, :age])

    if !isnothing(kinvals)
        tpr_dict[:kin431] = kinvals
    end

    fpr_dict = deepcopy(tpr_dict);
    df_ = @subset(dat, .!$socio)
    adist_mean = mean(df_[df_[!, :dists_a] .!= 0, :dists_a])
    fpr_dict[:dists_a] = adist_mean
    tpr_dict[:dists_a] = adist_mean
    fpr_dict[:dists_a_notinf] = true #mean(df_[!, :dists_a_notinf])
    tpr_dict[:dists_a_notinf] = true #mean(df_[!, :dists_a_notinf])

    tpr_dict[socio] = [false, true]
    fpr_dict[socio] = false

    (tpr = tpr_dict, fpr = fpr_dict)
    return tpr_dict
end

ed = effgrid(dat; kinvals = [false])
ext = (extrema∘skipmissing)(cr[!, :degree])
#for r in rates; eds[r][:degree] = first(ext):0.1:last(ext) end
ed[:degree] = first(ext):0.01:last(ext)

rg = referencegrid(dat, ed)
effects!(rg, m3; invlink)
sort!(rg, [socio, :degree])

rgc = @chain rg begin
    groupby(:degree)
    combine([x => Ref => x for x in [:response, :err]]...; renamecols = false)
end
rgc.response = Point2f.(rgc.response);

#%%
fg = Figure()
ax = Axis(fg[1, 1], height = 250, width = 250)
scatter!(ax, rgc.response, color = [berlin[x] for x in rgc.degree])
ylims!(ax, 0, 1)
xlims!(ax, 0, 1)
lines!(ax, 0:0.01:1, 0:0.01:1, linestyle = :dot, color = :black)
fg

####

ed = effgrid(dat; kinvals = [false])
e = :degree

ed[e] = if !(eltype(dat[!, e]) <: AbstractFloat)
    sunique(dat[!, e])
else
    ext = (extrema∘skipmissing)(dat[!, e])
    ed[e] = first(ext):0.001:last(ext)
end

# ed[:dists_p_notinf] = true

rg = referencegrid(dat, ed)
effects!(rg, m3; invlink)
sort!(rg, [socio, e])

a1 = unstack(select(rg, Not(:err)), socio, :response)
rename!(a1, Symbol(true) => :tpr, Symbol(false) => :fpr)
a2 = unstack(select(rg, Not(:response)), socio, :err)
rename!(a2, Symbol(true) => :err_tpr, Symbol(false) => :err_fpr)
joins = setdiff(Symbol.(names(a1)), [:err_tpr, :err_fpr, :tpr, :fpr])
a3 = leftjoin(a1, a2, on = joins)
j_calculations!(a3, 20_000)

rgc = @chain rg begin
    groupby(e)
    combine([x => Ref => x for x in [:response, :err]]...; renamecols = false)
end
rgc.response = Point2f.(rgc.response);

et = eltype(rgc[!, e])

color = if eltype(rgc[!, e]) <: AbstractFloat
    [berlin[x] for x in rgc[!, e]]
elseif et <: Bool
    [oi[x*1+1] for x in rgc[!, e]]
elseif eltype(rgc[!, e]) <: String
    rgc[!, e] = categorical(rgc[!, e])
    lvs = levelcode.(rgc[!, e])
    [oi[x] for x in lvs]
elseif et <: CategoricalValue
    lvs = levelcode.(rgc[!, e])
    [oi[x] for x in lvs]
end

#%%
fg = Figure()
ax = Axis(fg[1, 1], height = 250, width = 250, title = string(e))
scatter!(ax, rgc.response; color, label = string.(rgc[!, e]))
ylims!(ax, 0, 1)
xlims!(ax, 0, 1)
lines!(ax, 0:0.01:1, 0:0.01:1, linestyle = :dot, color = :black)

fg

#%%

