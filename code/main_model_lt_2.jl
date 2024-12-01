# base_models.jl
# julia --threads=32 --project="." "honduras-css-paper/code/main_model_lt_2.jl" > "output_main_model_dist.txt"

# from preamble.jl
include("../../code/setup/environment.jl")

cr = JLD2.load_object(datapath * "cr_" * "2024-05-01" * ".jld2");
code_variables!(cr);

@subset! cr :dists_p_notinf
@subset! cr :dists_p .<= 3;

transforms = standards(cr);
applystandards!(cr, transforms); # cf. reversestandards!

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
    :coffee_cultivation
];

dropmissing!(cr, prds);

dats = let
    crt2 = dropmissing(@subset(cr, $socio), prds);
    crf2 = dropmissing(@subset(cr, .!$socio), prds);

    sort!(crt2, [:perceiver, :order]);
    sort!(crf2, [:perceiver, :order]);
    bidata(crt2, crf2)
end;

println("model start")

m = let dats = dats, fast = false
    
    fx = @formula(
        response ~ kin431 + relation + degree +
        man + age + age^2 + educated +
        religion_c +
        wealth_d1_4 +
        coffee_cultivation +
        isindigenous +
        educated_a +
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
        dists_p +
        (1|village_code) + (1|perceiver)
    );

    fx2 = @formula(
        response ~ kin431 + relation + degree +
        man + age + age^2 + educated +
        religion_c +
        wealth_d1_4 +
        coffee_cultivation +
        isindigenous +
        educated_a +
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
        dists_p +
        dists_a +
        (1|village_code) + (1|perceiver)
    );

    x = fit(MixedModel, fx2, dats[:fpr], Binomial(), LogitLink(); fast)
end

println("model finished")

save_object("interaction models/main_model_limited_dist_3a_fpr.jld2", m)

# julia --threads=32 --project="." "honduras-css-paper/code/main_model_lt_2.jl" > "output_main_model_dist.txt"; julia --threads=32 --project="." "honduras-css-paper/code/bootstrap model lt 2 fpr.jl" > "output pb fpr lt3.txt"