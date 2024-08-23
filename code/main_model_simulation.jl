# main_model.jl

include("environment.jl")

println("data loaded")

dats = load_object("objects/simulated_data.jld2");

println("model start")

m1 = let dats = dats, fast = true
    trms = @formula(
        y ~ kin431 + 
        man + age + age^2 +
        dists_p_notinf +
        dists_p_notinf & dists_p
    );
    trms = trms.rhs

    re = (ConstantTerm(1) | term(:village_code)) # + (ConstantTerm(1) | term(:perceiver))
    fx = vcat(trms..., re)
    fx = term(:response) ~ reduce(+, fx)
    
    faketerms = term(:dists_a_notinf) + InteractionTerm(term.((:dists_a_notinf, :dists_a)))

    fx2 = Term(:response) ~ fx.rhs + faketerms;

    x = bifit(
        MixedModel, fx, dats[:tpr], dats[:fpr];
        dstr = Binomial(), lnk = LogitLink(),
        fx2 = fx2, fast
    )
end

println("model finished")

save_object("objects/simulated_main_model.jld2", m1)
