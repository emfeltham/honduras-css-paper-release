# Figure 1.jl
#=
This figure (unlike all other main figures) needs to be run with input from
basically the whole dataset.

Consequently, it cannot be replicated from derivative summary data on a local machine.
=#

include("../../code/setup/analysis preamble.jl")

# data setup
css = select(
    cr, ids.vc, :perceiver, :alter1, :alter2, socio, :relation, :response
);
@subset! css :relation .== rl.ft;
dropmissing!(css, [:relation, :response, socio]);

ndf4 = let
    ndf = JLD2.load_object(datapath * "network_info_" * dte * ".jld2");
    @subset ndf :wave .== 4;
end;

#%%
fprm = figure1data(css, cr, ndf4);

@inline bsize(a) = Int(round(800^2/a; digits = 0))

#%%
figure1, layout_all, layout_main, layout_legend = make_figure1(fprm);
rowgap!(layout_all, -10)
colgap!(layout_main, -50)
resize!(figure1, 1200, 800)
resize_to_layout!(figure1)

#%%
let fg = figure1
    cap_a = "(a) Perceiver's perspective of the network for a specific relationship (e.g., _free time_), in a representative village. Rings represent geodesic distances 1 to 4."
    cap_b = "(b) Possibly perceived ties. Ties are restricted to within 4 geodesic steps from the perceiver. Solid lines represent ties that actually exist in the underlying sociocentric network, and dotted lines those that do not. The total number of possible relationships is so great that it would be infeasible to survey completely."
    cap_c = "(c) Survey responses. We present no more than 40 ties to the survey respondent, drawn from the set of possible ties in panel (b). Of the 40 ties, roughly 20 are among individuals within 2 degrees of the perceiver, 10 are 3 degrees away, and 10 are 4 degrees away, where each distance is measured in the network defined by the union of the _kin_, _personal private_, and _free time_ networks. In each case, half are ties that exist in the sociocentric network (_real_ ties), and half do not exist (_counterfactual_ ties, denoted by dashed lines). The circular rings denote the geodesic distance, \$d\$, in the underlying sociocentric network, from the perceiver, and correspond to the sampling bins. The _ground truth_ of whether \$i\$ is connected to \$j\$ is ascertained because of the near simultaneous full sociocentric mapping of the village. Individuals assess both real and fake ties, and may respond correctly or not. This process is repeated separately for each villager, and we elicit this basic data structure for each survey respondent. On average individuals were queried around " * fprm.tiemean.mean * " ties (median=" * fprm.tiemean.median * ", mode=" * fprm.tiemean.mode * ") across _free time_ and _personal private_."
    
    caption = "Outline of the sampling procedure. " *
    cap_a * " " *
    cap_b * " " *
    cap_c

    filename = "honduras-css-paper/Figures (main)/Figure 1"

    save(filename * ".png", figure1; px_per_unit = 2.0)

    figure_export(
        filename * ".svg",
        fg,
        save2;
        caption,
        outlined = true,
    )
end
