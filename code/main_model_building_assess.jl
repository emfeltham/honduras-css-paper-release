# main_model_building_assess.jl

#%%
include("../../code/setup/analysis preamble.jl")
invlink = logistic;

function ct_compare(m0, m1, r; pthresh = 0.05)
    ct1 = DataFrame(coeftable(m0[r]))
    ct1.model .= "m0"
    ct1.vif .= NaN
    ct1.vif[2:end] = vif(m0[r])
    ct1[!, "p05"] = ct1[!, "Pr(>|z|)"] .< pthresh
    
    ct2 = DataFrame(coeftable(m1[r]))
    ct2.model .= "m1"
    ct2.vif .= NaN
    ct2.vif[2:end] = vif(m1[r])
    ct2[!, "p05"] = ct2[!, "Pr(>|z|)"] .<pthresh
    
    vb = ["Coef.", "Std. Error", "z", "Pr(>|z|)", "vif", "p05"]
    @chain vcat(ct1, ct2) begin
        groupby(:Name)
        combine([x => Ref => x for x in vb]...)
    end
end

#%%

# m = load_object("interaction models/main_model.jld2")
# m = load_object("interaction models/base1_tie_2.jld2")
msb = load_object("interaction models/main_model_same_building.jld2");
pbssb = (
    tpr = load_object("interaction models/main_model_same_building_pb_10K_tpr.jld2"),
    fpr = load_object("interaction models/main_model_same_building_pb_10K_fpr.jld2")
);

println("data loaded")

prds = [
    :response,
    :kin431, :relation,
    :age, :man,
    :educated,
    :educated_a,
    :degree,
    :dists_p_notinf, :dists_p,
    :man_a,
    :age_mean_a,
    :age_diff_a,
    :religion_c,
    :religion_c_a,
    :isindigenous,
    :isindigenous_a,
    :degree_mean_a,
    :degree_diff_a,
    :wealth_d1_4, 
    :wealth_d1_4_mean_a,
    :wealth_d1_4_diff_a,
    :coffee_cultivation,
    :same_building_a
];

dats = let cr = cr
    crt2 = @subset(cr, $socio);
    crf2 = @subset(cr, .!$socio);
    dropmissing!(crt2, prds)
    dropmissing!(crf2, prds)

    sort!(crt2, [:perceiver, :order]);
    sort!(crf2, [:perceiver, :order]);
    bidata(crt2, crf2)
end;

dat = let cr = cr
    d = dropmissing(cr, prds)
    sort!(d, [:perceiver, :order]);
end;

#%%
ct_tpr = ct_compare(m0, m1, :tpr)
ct_fpr = ct_compare(m0, m1, :fpr)

#%%
margindict = Dict{Symbol, @NamedTuple{rg::DataFrame, name::String}}();
vbldict = [:same_building_a => "Same building", kin => "Kin", :coffee_cultivation => "Coffee cultivation"];

addmargins!(
    margindict, vbldict, msb, pbssb, dat, length(pbssb.tpr), invlink;
    margresolution = 0.001, allvalues = false,
)

save_object("interaction models/margindict_same_building.jld2", margindict)

#%%

e = :coffee_cultivation;
rg = deepcopy(margindict[e].rg);
ename = margindict[e].name;
# rg = @subset rg .!($kin);
# dropmissing!(rg);

cts = eltype(rg[!, e]) <: AbstractFloat

fg = Figure();
ll = fg[1, 1:3] = GridLayout();
ll1 = ll[1, 1] = GridLayout();
lll = ll[1:2, 2] = GridLayout();
ll2 = ll[1, 3] = GridLayout();

ellipsecolor = (yale.grays[end-1], 0.3)
dropkin_eff = true
tnr = true
kinlegend = false

rocplot!(
    ll1,
    rg, e, ename;
    ellipsecolor,
    markeropacity = 0.8,
    kinlegend,
    dolegend = false,
    axsz = 300
)

HondurasCSS.roclegend!(
    lll[1, 1], rg[!, e], ename, true, ellipsecolor, cts;
    kinlegend = false,
    framevisible = false
)

HondurasCSS.effectsplot!(
    ll2, rg, e, ename, tnr;
    dropkin = dropkin_eff,
    dolegend = false,
    axh = 300, axw = 300
)

HondurasCSS.effectslegend!(lll[2, 1], true, true, false; tr = 0.6)
resize_to_layout!(fg)
resize!(fg, 925, 400)

# rowsize!(lll, 1, Relative(2/3.5))

rowgap!(lll, -100)
fg
