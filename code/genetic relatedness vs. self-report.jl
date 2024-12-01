# genetic relatedness vs. self-report.jl

# construct kinship distance from kinship network without spouses

include("../../code/setup/environment.jl")

cx = load_object("clean_data/connections_data_2024-02-18.jld2");

basepath = "../" # "/WORKAREA/work/HONDURAS_GATES/E_FELTHAM/";
writepath = datapath;
waves = [1, 2, 3, 4];

#%%

# create new network variable for related by 
cx_ar = @subset cx (:relationship .== "are_related") .& (:kintype .!= "Partners")
sunique(cx_ar[!, :kintype])
cx_ar.relationship .= "are_related_gen";
cx = vcat(cx, cx_ar);

#%%
@time ndf = networkinfo(
    cx;
    waves,
    relnames = [
        "free_time", "personal_private", "are_related", "are_related_gen",
        "union", "any"
    ]
);

ndfr = @subset ndf :relation .== "are_related_gen";

# preallocate distances
ndfr.dists  = [fill(Inf, nv(g), nv(g)) for g in ndfr.graph];

"""
        cx_dists!(dm, g)

## Description

Calculate network distances over vector of graphs `g`, fill vector of distance matrices, `dm`.
"""
function cx_dists!(dm, g)
    for j in 1:nv(g)
        gdistances!(g, j, @views(dm[:, j])) # unweighted only
        # dm[:, j] = dijkstra_shortest_paths(g, j).dists
    end
end

cx_dists!.(ndfr.dists, ndfr.graph)

function DataFrame2(gr::T; type = :node) where T <:AbstractMetaGraph
    fl, prps, en, nu = if type == :node
        :node => Int[], gr.vprops, vertices, nv
    else
        :edge => Edge[], gr.eprops, edges, ne
    end

    dx = DataFrame(fl)

    # this block only applies if there are defined properties
    # on the MetaGraph object `gr`
    if length(values(prps)) > 0
        x = unique(reduce(vcat, values(prps)))
        for y in x
            for (k, v) in y
                if typeof(v) != Missing # update if there are non-missing entries
                    dx[!, k] = typeof(v)[]
                end
                if string(k) ∈ names(dx)
                    allowmissing!(dx, k)
                end
            end
        end
    end
    
    dx = similar(dx, nu(gr))

    for (i, e) in (enumerate∘en)(gr)

        dx[i, type] = e
        pr = props(gr, e)
        for (nme, val) in pr
            dx[i, nme] = val
        end
    end
    
    for v in Symbol.(names(dx))
        if !any(ismissing.(dx[!, v]))
            disallowmissing!(dx, v)
        end
    end
    return dx
end

function extract_lower(M)
    M[tril!(trues(size(M)), -1)]
end

function extract_upper(M)
    M[triu!(trues(size(M)), 1)]
end

function uppernum(M)
    vv = Tuple{Int, Int}[]
    for i in 1:size(M, 1)
        for j in 1:size(M, 2)
            if i < j
                push!(vv, (i, j))
            end
        end
    end
    return vv
end

dist_df = DataFrame();
for (i, g) in enumerate(ndfr.graph)    
    d_ = @views ndfr.dists[i]
    dfx = DataFrame(idx = uppernum(d_), dist = extract_upper(d_))
    dfx.src .= ""
    dfx.dst .= ""
    for (j, e) in enumerate(dfx.idx)
        dfx[j, :src] = get_prop(g, e[1], :name)
        dfx[j, :dst] = get_prop(g, e[2], :name)
    end
    dfx.village_code .= ndfr.village_code[i]
    dfx.wave .= ndfr.wave[i]
    append!(dist_df, dfx)
end

dist_df.tie = tieset(dist_df, :src, :dst);

@subset! dist_df :wave .== 4
length(unique(dist_df.village_code))

grel = CSV.read("/WORKAREA/work/HONDURAS_MICROBIOME/E_FELTHAM/kin/merged_filter_hwe_maf_new_names.kin0", DataFrame);
rename!(grel, "#IID1" => "alter1", "IID2" => "alter2", "KINSHIP" => "kinship");

grel.tie = tieset(grel, :alter1, :alter2);

leftjoin!(grel, dist_df, on = :tie)
dropmissing!(grel, :dist)

fgd = Figure();
let fg = fgd
    ax1 = Axis(fg[1,1]; title = "kinship")
    ax2 = Axis(fg[2,1]; title = "distance")
    ax3 = Axis(fg[3,1]; title = "kinship | distance = 1")
    hist!(ax1, grel.kinship, bins = 50)
    hist!(ax2, grel.dist[grel.dist .< Inf], bins = 25)
    hist!(ax3, grel.kinship[grel.dist .== 1])
end
fgd


grel.notinf .= grel.dist .< Inf
grel.dmod .= ifelse.(grel.dist .== Inf, 0, grel.dist)

grel_ = @subset grel :dist .< Inf;

fx = @formula(kinship ~ notinf + (dmod & notinf))
m1 = lm(fx, grel)

fx1 = @formula(kinship ~ dist)
m2 = lm(fx1, grel_)

grel_1 = @subset grel_ :dist .== 1;
hist(grel_1.kinship)


dsn = Dict(
    :notinf => true,
    :dmod => sunique(grel.dmod[grel.dmod .> 0])
);

ef = effects(dsn, m1);

fg = Figure();
ax = Axis(
    fg[1, 1];
    xlabel = "kinship network distance", ylabel = "relatedness"
);
lines!(ax, ef.dmod, ef.kinship);
scatter!(ax, grel.dist, grel.kinship, color = (oi[1], 0.1))
fg

#%%

crk = dropmissing(cr, :kinship);
#crk2 = @subset crk :are_related_dists_a .!= 0;
crk2 = crk
crk2 = unique(crk2, [:alter1, :alter2, :are_related_dists_a, :kinship])

fx2 = @formula(kinship ~ are_related_dists_a_notinf + are_related_dists_a & are_related_dists_a_notinf )
m3 = lm(fx2, crk2)

#%%

dsn = Dict(
    :are_related_dists_a_notinf => true,
    :are_related_dists_a => sunique(crk2.are_related_dists_a[crk2.are_related_dists_a .> 0])
);

ef = effects(dsn, m3);

fg = Figure();
ax = Axis(
    fg[1, 1];
    xlabel = "kinship network distance", ylabel = "relatedness"
);
lines!(ax, ef.are_related_dists_a, ef.kinship);
scatter!(ax, crk2.are_related_dists_a, crk2.kinship, color = (oi[1], 0.1))
fg

#%% con

c4 = @subset con :wave .== 4 :relationship .== "are_related";
HondurasTools.sortedges!(c4.ego, c4.alter)

cons4 = conns[end];

sunique(cons4.relationship)
kns = ["child_over12_other_house", "father", "mother", "sibling"]
cons4k = @subset cons4 :relationship .∈ Ref(kns)
select!(cons4k, :ego, :alter, :relationship, :village_code)
cons4k.tie = [Set([a, b]) for (a,b) in zip(cons4k.ego, cons4k.alter)];

gen = select(grel, :alter1, :alter2, :kinship)
gen.tie = [Set([a, b]) for (a,b) in zip(gen.alter1, gen.alter2)];

ck4 = leftjoin(cons4k, gen; on = :tie);
dropmissing!(ck4, :kinship);

using AlgebraOfGraphics

plt = data(ck4) * mapping(:kinship, layout=:relationship) * histogram(bins = 25)
draw(plt)

yx = DataFrame(village_code = sunique(ck4.village_code))
yx.g = [MetaGraph(ck4[ck4.village_code .== v, :], :ego, :alter; edge_attributes = :relationship) for v in yx.village_code]
yx.dm = Vector{Matrix{Float64}}(undef, nrow(yx))

for i in eachindex(yx.g)
    mg = yx.g[i]
    yx.dm[i] = fill(Inf, nv(mg), nv(mg));
    for (i, c) in (enumerate∘eachcol)(yx.dm[i])
        gdistances!(mg, i, c)
    end
end

dist_df = DataFrame();
for (i, g) in enumerate(yx.g)
    d_ = @views yx.dm[i]
    dfx = DataFrame(idx = uppernum(d_), dist = extract_upper(d_))
    dfx.src .= ""
    dfx.dst .= ""
    for (j, e) in enumerate(dfx.idx)
        dfx[j, :src] = get_prop(g, e[1], :name)
        dfx[j, :dst] = get_prop(g, e[2], :name)
    end
    dfx.village_code .= yx.village_code[i]
    #dfx.wave .= ndfr.wave[i]
    append!(dist_df, dfx)
end

graphplot(mg)

xx = dist_df[dist_df.dist .< Inf, :]
xx.tie = [Set([a, b]) for (a,b) in zip(xx.src, xx.dst)];
leftjoin!(xx, gen, on = :tie)
hist(xx.dist)
scatter(xx.dist, xx.kinship; color = (oi[1], 0.01))

lm(@formula(kinship ~ dist), xx)

graphplot(yx.g[1])