# interaction_models.jl
# ~/.juliaup/bin/julia --threads=60 "--sysimage=JuliaSysimage_plot_mod.so" --project="." "honduras-css-paper/code/interaction_models full.jl" > "output_m1i_age2.txt"

@show pwd()

include("../../code/setup/analysis preamble.jl")

println("data loaded")

prds = [
    :response,
    :kin431, :relation,
    :age, :man,
    :educated,
    :degree,
    :dists_p_notinf, :dists_p
];

dats = let
    crt2 = dropmissing(crt, prds);
    crf2 = dropmissing(crf, prds);

    sort!(crt2, [:perceiver, :order]);
    sort!(crf2, [:perceiver, :order]);
    bidata(crt2, crf2)
end;

println("model start")


m1i = let dats = dats;
    
    trms = @formula(y ~ kin431 + relation + degree +
    man + age + age^2 + educated +
    dists_p_notinf +
    dists_p_notinf&dists_p);
    trms = trms.rhs

    re = (ConstantTerm(1) | term(:village_code)) + (ConstantTerm(1) | term(:perceiver))
    fx = vcat(trms..., interactpairwise(trms), re...)
    fx = term(:response) ~ reduce(+, fx)
    
    faketerms = term(:dists_a_notinf) + InteractionTerm(term.((:dists_a_notinf, :dists_a))) + (term(:dists_a_notinf) + InteractionTerm(term.((:dists_a_notinf, :dists_a)))) & trms[1:(end-2)]
    # interaction fails when we interact with either of last two

    fx2 = Term(:response) ~ fx.rhs + faketerms;

    x = bifit(
        MixedModel, fx, dats[:tpr], dats[:fpr];
        dstr = Binomial(), lnk = LogitLink(),
        fx2 = fx2, fast = false
    )
end

println("model finished")

save_object("interaction models/interaction1_age2.jld2", m1i)
