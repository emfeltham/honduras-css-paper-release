# base_models.jl
# julia --threads=32 --project="." "honduras-css-paper/code/base_models_tie.jl" > "output_m1_base_tie.txt"

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
    :protestant_a,
    :isindigenous_a,
    :degree_mean_a,
    :degree_diff_a    
];

dats = let
    crt2 = dropmissing(crs.tpr, prds);
    crf2 = dropmissing(crs.fpr, prds);

    sort!(crt2, [:perceiver, :order]);
    sort!(crf2, [:perceiver, :order]);
    bidata(crt2, crf2)
end;

println("model start")

m1 = let dats = dats;
    
    trms = @formula(y ~ kin431 + relation + degree +
    man + age + age^2 + educated +
    protestant_a +
    # man_a + protestant_a + isindigenous_a +
    # degree_mean_a + degree_diff_a +
    # age_mean_a + age_diff_a +
    dists_p_notinf +
    dists_p_notinf&dists_p);
    trms = trms.rhs

    re = (ConstantTerm(1) | term(:village_code)) + (ConstantTerm(1) | term(:perceiver))
    fx = vcat(trms..., re...)
    fx = term(:response) ~ reduce(+, fx)
    
    faketerms = term(:dists_a_notinf) + InteractionTerm(term.((:dists_a_notinf, :dists_a)))

    fx2 = Term(:response) ~ fx.rhs + faketerms;

    x = bifit(
        MixedModel, fx, dats[:tpr], dats[:fpr];
        dstr = Binomial(), lnk = LogitLink(),
        fx2 = fx2, fast = true
    )
end

println("model finished")

save_object("interaction models/base1_tie_prot.jld2", m1)

m1 = let dats = dats;
    
    trms = @formula(y ~ kin431 + relation + degree +
    man + age + age^2 + educated +
    degree_mean_a + degree_diff_a +
    # protestant_a +
    # man_a + protestant_a + isindigenous_a +
    # degree_mean_a + degree_diff_a +
    # age_mean_a + age_diff_a +
    dists_p_notinf +
    dists_p_notinf&dists_p);
    trms = trms.rhs

    re = (ConstantTerm(1) | term(:village_code)) + (ConstantTerm(1) | term(:perceiver))
    fx = vcat(trms..., re...)
    fx = term(:response) ~ reduce(+, fx)
    
    faketerms = term(:dists_a_notinf) + InteractionTerm(term.((:dists_a_notinf, :dists_a)))

    fx2 = Term(:response) ~ fx.rhs + faketerms;

    x = bifit(
        MixedModel, fx, dats[:tpr], dats[:fpr];
        dstr = Binomial(), lnk = LogitLink(),
        fx2 = fx2, fast = false
    )
end

save_object("interaction models/base1_tie_deg.jld2", m1)

m1 = let dats = dats;
    
    trms = @formula(y ~ kin431 + relation + degree +
    man + age + age^2 + educated +
    isindigenous_a +
    # protestant_a +
    # man_a + protestant_a + isindigenous_a +
    # degree_mean_a + degree_diff_a +
    # age_mean_a + age_diff_a +
    dists_p_notinf +
    dists_p_notinf&dists_p);
    trms = trms.rhs

    re = (ConstantTerm(1) | term(:village_code)) + (ConstantTerm(1) | term(:perceiver))
    fx = vcat(trms..., re...)
    fx = term(:response) ~ reduce(+, fx)
    
    faketerms = term(:dists_a_notinf) + InteractionTerm(term.((:dists_a_notinf, :dists_a)))

    fx2 = Term(:response) ~ fx.rhs + faketerms;

    x = bifit(
        MixedModel, fx, dats[:tpr], dats[:fpr];
        dstr = Binomial(), lnk = LogitLink(),
        fx2 = fx2, fast = false
    )
end

save_object("interaction models/base1_tie_indig.jld2", m1)

##

m1_prot = load_object("interaction models/base1_tie_prot.jld2")
m1_indig = load_object("interaction models/base1_tie_indig.jld2")
m1_deg = load_object("interaction models/base1_tie_deg.jld2");
m1_tie = load_object("interaction models/base1_tie.jld2");

m1_tie.tpr
m1_prot.tpr

# %%

bpd0 = biplotdata(
    m1_tie, dats, :protestant_a;
    pbs = nothing, 
    invlink=logistic, iters = 1000,
    varname = "Gender",
    transforms
)

bpd1 = biplotdata(
    m1_prot, dats, :protestant_a;
    pbs = nothing, 
    invlink=logistic, iters = 1000,
    varname = "Gender",
    transforms
)

fg0 = Figure();
let 
    l1 = fg0[1,1] = GridLayout()
    l2 = fg0[2,1] = GridLayout()
    biplot!(
        l1,
        bpd0;
        jstat = false,
        ellipse = false,
    )
    biplot!(
        l2,
        bpd1;
        jstat = false,
        ellipse = false,
    )
    resize_to_layout!(fg0)
    fg0
end
