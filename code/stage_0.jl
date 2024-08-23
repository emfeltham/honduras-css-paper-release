# stage_0.jl
# boot data

include("../code/environment.jl")

#%%
bimodel = load_object("interaction models/base1_tie_2.jld2");

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
    :isindigenous,
    :isindigenous_a,
    :degree_mean_a,
    :degree_diff_a,
    :wealth_d1_4, 
    :wealth_d1_4_mean_a,
    :wealth_d1_4_diff_a,
    :educated_a
];

dat = dropmissing(cr, prds);

#%%
#=
Formula for second stage model

fx = @formula(
    tpr ~ fpr + relation + degree + age + age^2 + man + religion_c +
    wealth_d1_4 + isindigenous +
    (1|perceiver) + (1|village_code)
)
=#

ed = standarddict(dat; kinvals = false)
variables = [
    :village_code, :perceiver,
    :relation, :degree, # (these are repeated w/in a respondent)
    :age, :man, :educated, :religion_c, :isindigenous, :wealth_d1_4
]
rgx = referencegridunit(dat, variables, ed)

estimaterates!(rgx, bimodel; iters = 20_000)
ci_rates!(rgx)

save_object("interaction models/tpr_fpr_boot_data_rg.jld2", rgx)

save_object("interaction models/riddle_boot_data_rg.jld2", rgx)
