# SI Figure alter recognition.jl

include("../../code/setup/environment.jl")

basepath = "../";
css_path = "CSS/final_data/v1/css_edges_v1.csv";
css = CSV.read(basepath * css_path, DataFrame; missingstring = "NA");
rename!(css, :respondent_master_id => :name);

cs1 = select(
    css,
    :name, :ego_id, :knows_ego,
);

cs2 = select(
    css,
    :name, :alter_id, :knows_alter
);

rename!(cs2, :alter_id => :ego_id, :knows_alter => :knows_ego)

csx = vcat(cs1, cs2);
csx = unique(csx);
csx.tie = tieset(csx, :name, :ego_id);

#%%


ndf4 = JLD2.load_object(datapath * "network_info_" * dte * ".jld2");
@subset! ndf4 (:wave .== 4) .& (:relation .∈ Ref(["free_time", "personal_private"]));

df = DataFrame(:tie => Set{String}[]);
for i in 1:nv(g)
    for j in 1:nv(g)
        if j > i
            push!(df.tie, Set([g[i, :name], g[j, :name]]))
        end
    end
end

df = DataFrame(
    :name => String[], :dists => Vector{Float64}[],
    :alters => Vector{String}[],
    :relation => String[],
    :village_code => Int[]
);

for (i, g) in enumerate(ndf4.graph)
    dm = fill(Inf, nv(g), nv(g));
    a_ = [g[v, :name] for v in 1:nv(g)];
    for v in 1:nv(g)
        gdistances!(g, v, @views(dm[v, :]))
        push!(df, [g[v, :name], dm[v, :], a_, ndf4[i, :relation], ndf4[i,:village_code]])
    end
end

#%%

df = flatten(df, [:dists, :alters]);
df.tie = tieset(df, :name, :alters);
select!(df, :tie, :dists, :relation, :village_code)
unique!(df)

df2 = leftjoin(df, csx, on = :tie)

dropmissing!(df2)
df2.notinf = .!(isinf.(df2.dists))
df2.dists[isinf.(df2.dists)] .= 0;
df2.knows = replace(
    df2.knows_ego, "Dont_Know" => missing, "Yes" => true, "No" => false
)
df2.knows = convert(Vector{Union{Bool, Missing}}, df2.knows)
# csx.knows_ego = categorical(csx.knows_ego);
dropmissing!(df2)

fx = @formula(knows ~ notinf + (notinf & dists) + relation)
m = glm(fx, df2, Bernoulli(), LogitLink())

x = sunique(df2.dists)
x = x[x .> 0]

rx = effects(Dict(:notinf => true, :dists => x), m; invlink = logistic);

#%% number
# fg = Figure();
# ax = Axis(fg[1,1], xlabel = "Geodesic distance", ylabel = "Probability recognized");
# lines!(ax, rx.dists, rx.knows)
# band!(ax, rx.dists, rx.lower, rx.upper)
# scatter!(ax, df2.dists, df2.knows, color = (oi[1], 0.008))
# fg

#%% use category for figure
function discat(x)
    return if x == 0
        "Inf"
    elseif x > 10
        "> 10"
    elseif x ∈ 5:10
        "5:10"
    else "< 5"
    end

end

df2.distcat = categorical(discat.(df2.dists), ordered = true; levels = ["< 5", "5:10", "> 10", "Inf"])

m2 = glm(@formula(knows ~ distcat + relation), df2, Bernoulli(), LogitLink())

rx2 = effects(Dict(:distcat => unique(df2.distcat)), m2; invlink = logistic);
rx2.distcat = categorical(rx2.distcat, ordered = true; levels = ["< 5", "5:10", "> 10", "Inf"])

fg = Figure();
ax = Axis(
    fg[1,1], xlabel = "Distance category", ylabel = "Probability recognized",
    xticks = (eachindex(rx2.distcat), string.(sort(rx2.distcat)))
)
scatter!(ax, levelcode.(rx2.distcat), rx2.knows)
rangebars!(ax, levelcode.(rx2.distcat), rx2.lower, rx2.upper)
resize!(fg, 400, 400)

let fg = fg
    short_caption = "Recognition by distance"
	caption = "Recognition by distance. Survey respondents recognize individuals in displayed candidate pairs above 90% across every distance to the respondent, including those far away in the network, at more than 10 degrees of separation. Error bars represent 95% confidence intervals."

	figure_export(
		"honduras-css-paper/Figures (SI)/SI Figure alter recognition.svg",
		fg,
		save2;
		caption,
        short_caption,
		outlined = true,
	)
end
