# background plot

include("../code/analysis_preamble.jl")

# data setup

css = select(
    cr, ids.vc, :perceiver, :alter1, :alter2, socio, :relation, :response
);
@subset! css :relation .== rl.ft;
dropmissing!(css, [:relation, :response, socio]);

ndf4 = let
    ndf = JLD2.load_object("../" * datapath * "network_info_" * dte * ".jld2");
    @subset ndf :wave .== 4;
end

figure1 = make_figure1(css, cr, ndf4)

# colsize!(fg_background.layout, 1, Aspect(1, 3))

@inline bsize(a) = Int(round(800^2/a; digits = 0))

a = 1100
resize!(figure1, a + 150, bsize(a))
resize_to_layout!(figure1)
figure1

save("figures/figure_1.png", figure1; px_per_unit = 2.0)
