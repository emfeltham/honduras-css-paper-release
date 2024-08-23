# figure 2 science
# relation-truth-subject-level TPR and FPR (model based)

include("../code/analysis_preamble.jl")

sbar = load_object("objects/bivar_data.jld2");
bpd = load_object("objects/base1_tie2_relatedness_margins_bs_out.jld2")
bpd = (rg = bpd[:kinship].rg, margvar = :kinship, margvarname = "Relatedness")
md = load_object("objects/base1_tie2_margins_bs_out.jld2");
transforms = load_object("objects/variable_transforms.jld2");

bpd.rg[findmax(bpd.rg.j)[2], [:kinship, :j, :ci_j]];

vars = [:age, :wealth_d1_4, :degree];

for e in [:age, :degree]
	md[e].rg[!, e] = reversestandard(md[e].rg, e, transforms)
end

#%%
# resize_to_layout!(figure2)
fg = Figure();
nlevels = 10;
colormap = berlin;

let
    l = fg[1, 1] = GridLayout();
    lla = l[1:2, 1] = GridLayout();
    l1_ = lla[1, :] = GridLayout();
    l2_ = lla[2, :] = GridLayout();
    l3 = l[1:2, 2] = GridLayout();
    
    perceivercontour!(
        l1_, sbar; kin, nlevels, colormap, axsz = 325
    );

    ellipsecolor = (yale.grays[end-1], 0.3)
    dropkin_eff = true
    tnr = true
    kinlegend = false

    l1 = l2_[1, 1] = GridLayout();
    ll = l2_[1, 2] = GridLayout();
	l2 = l2_[1, 3] = GridLayout();

    rocplot!(
        l1,
        bpd.rg, bpd.margvar, bpd.margvarname;
        ellipsecolor,
        markeropacity = 0.8,
        kinlegend,
        dolegend = false,
        axsz = 300
    )

    ll1 = ll[1, 1] = GridLayout()
    ll2 = ll[2, 1] = GridLayout()
    rowsize!(ll, 1, Relative(2.2/3))

    HondurasCSS.roclegend!(
        ll1, bpd.rg[!, bpd.margvar], bpd.margvarname, true, ellipsecolor, true;
        kinlegend = false,
    )

    HondurasCSS.effectsplot!(
        l2, bpd.rg, bpd.margvar, bpd.margvarname, tnr;
        dropkin = dropkin_eff,
        dolegend = false,
        axh = 300, axw = 300
    )

    HondurasCSS.effectslegend!(ll2[1, 1], true, true, false; tr = 0.6)
    #     colsize!(l, 2, Auto(0.2))
    #     colgap!(l, 20)

    l3s = [GridLayout(l3[i, 1])  for i in 1:3]
    ellipsecolor = (yale.grays[end-1], 0.3)
    for (i, e) in enumerate(vars)
		rg, margvarname = md[e]
		tp = (
			rg = rg, margvar = e, margvarname = margvarname,
			tnr = true, jstat = true
		);

        HondurasCSS.rocplot!(
            l3s[i],
            tp.rg, tp.margvar, tp.margvarname;
            axsz = 325,
            ellipsecolor,
            markeropacity = 0.8,
            kinlegend = true,
            dolegend = true
        )

        # HondurasCSS.effectsplot!(
        #     l3s[i], tp.rg, tp.margvar, tp.margvarname, tp.tnr;
        #     dropkin = dropkin_eff,
        #     dolegend = true
        # )
		#biplot!(los[i], tp)
	end

    labelpanels!([l1_, l2_, l3])
    
    #rowsize!(l, 1, Relative(2/3))
    colgap!(l, 1, -100)
    rowgap!(lla, 1, -100)
end

figure2 = fg;
resize!(figure2, 1500, 1300) # w,h
resize_to_layout!(figure2)
figure2

#%%

save("figures/figure_2.png", figure2; px_per_unit = 2)
