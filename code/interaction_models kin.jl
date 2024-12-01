# interaction_models.jl
# julia --threads=32 "--sysimage=JuliaSysimage_plot_mod.so" --project="." "honduras-css-paper/code/interaction_models kin.jl" > "output_interaction_kin.txt"

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
    crt2 = dropmissing(crs.tpr, prds);
    crf2 = dropmissing(crs.fpr, prds);

    sort!(crt2, [:perceiver, :order]);
    sort!(crf2, [:perceiver, :order]);
    bidata(crt2, crf2)
end;

println("model start")


m = let dats = dats;
    
    trms = @formula(y ~ (relation + degree +
    man + age + educated +
    dists_p_notinf +
    dists_p_notinf&dists_p) * kin431);
    trms = trms.rhs

    re = (ConstantTerm(1) | term(:village_code)) + (ConstantTerm(1) | term(:perceiver))
    fx = vcat(trms..., re...)
    fx = term(:response) ~ reduce(+, fx)
    
    faketerms = term(:dists_a_notinf) + InteractionTerm(term.((:dists_a_notinf, :dists_a))) + (term(:dists_a_notinf) + InteractionTerm(term.((:dists_a_notinf, :dists_a)))) & term(:kin431)
    # interaction fails when we interact with either of last two

    fx2 = Term(:response) ~ fx.rhs + faketerms;

    x = bifit(
        MixedModel, fx, dats[:tpr], dats[:fpr];
        dstr = Binomial(), lnk = LogitLink(),
        fx2 = fx2, fast = false
    )
end

println("model finished")

save_object("interaction models/interaction_kin.jld2", m)
