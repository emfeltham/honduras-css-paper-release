# figure_village_scratch.jl

#%%
fgd["non-kin"] = Figure();

let fg = fgd["non-kin"], mg = mg
    fg = Figure();
    l1 = GridLayout(fg[1, 1])
    l2 = GridLayout(fg[1, 2])
    ec = []
    @eachrow mg_edf begin
        x = if (.!:kin431) .& (:socio4)
            (yale.grays[3], 0.5)
        else :kin431
            (Symbol("transparent"), 0.5)
        end
        push!(ec, x)
    end

    ax = Axis(l1[1,1], aspect = 1);
    graphplot!(ax, mg; edge_color = ec, layout)
    hidedecorations!(ax)

    cs = []
    @eachrow mg_edf begin
        x = if (.!:kin431) .& (:sim)
            (yale.grays[3], 0.2)
        else
            (Symbol("transparent"), 0.5)
        end
        push!(cs, x)
    end

    ax2 = Axis(l2[1,1], aspect = 1);
    graphplot!(ax2, mg; edge_color = cs, layout)
    hidedecorations!(ax2)

    labelpanels!([l1, l2])
    resize!(fg, 800, 400)
    resize_to_layout!(fg)
    fg
end

#%%
@chain mg_edf begin
    groupby([:sim, kin, socio])
    combine(nrow => :n)
end
