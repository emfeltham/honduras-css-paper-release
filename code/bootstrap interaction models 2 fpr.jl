# bootstrap interaction models 2
# ~/.juliaup/bin/julia --threads=60 "--sysimage=JuliaSysimage_plot_mod.so" --project="." "honduras-css-paper/code/bootstrap interaction models 2 fpr.jl" > "output_mi2_pb_age2_fpr.txt"

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

m1i = load_object("interaction models/interaction2_age2.jld2")

# pbt = parametricbootstrap(1000, m1i.tpr); 
pbf = parametricbootstrap(1000, m1i.fpr);

save_object("interaction models/interaction_2_pb_age2_fpr.jld2", pbf)
