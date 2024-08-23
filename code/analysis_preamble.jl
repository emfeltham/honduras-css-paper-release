# preamble.jl

include("environment.jl")

# N.B. the main datasets here are imputed (subject to constraints)
# cf. "make_data.jl" for more details
cr = JLD2.load_object("../" * datapath * "cr_" * "2024-05-01" * ".jld2");

code_variables!(cr);

transforms = standards(cr);
applystandards!(cr, transforms); # cf. reversestandards!

save_object("objects/variable_transforms.jld2", transforms)

# wealth d1 4 is already on 0,1: don't alter the range
# don't alter range
cr.wealth_d1_4_diff_pa = cr.wealth_d1_4 - cr.wealth_d1_4_mean_a;

# outcomes
# otc = load_object(datapath * "outcomes_" * dte * ".jld2");

# N.B., below not standardized by default
# rhv4 = load_object(datapath * "rhv4_" * dte * ".jld2");
