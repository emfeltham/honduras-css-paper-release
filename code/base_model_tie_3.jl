# base_models.jl
# julia --threads=32 --project="." "honduras-css-paper/code/base_model_tie_3.jl" > "output_base_tie_3.txt"

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

dropmissing!(cr, prds);
sort!(cr, [:perceiver, :order]);

println("model start")

m3 = let dat = cr;
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
        (1|village_code) + (1|perceiver) + (1|building_id) +
        (1|alter1) + (1|alter2)
    );
    
    x = fit(
        MixedModel, fx, dat,
        Binomial(), LogitLink(),
        fast = false
    )
end

println("model finished")

save_object("interaction models/base_tie_3.jld2", m1)
