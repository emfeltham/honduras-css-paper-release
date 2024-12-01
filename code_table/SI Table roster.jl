# roster_table.jl

nc = 8;

t1 = let cells = CellX[], nc = nc
    for i in 1:nc
        push!(cells, cellx(content = i, x = i, y = 0))
        push!(cells, cellx(content = i, x = 0, y = i))
    end

    for i in 1:nc, j in 1:nc
        if i >= j
            push!(cells, cellx(x = i, y = j, fill = :gray))
        end
    end

    # table
    hdr = ["columns: " * string(nc+1),
    "fill: none",
    "align: center + horizon"]

    # make string vector
    cp = vcat(hdr, print.(cells))
    cp = cp .* ", \n";

    cp = tablex(cp)
    
    cp = reduce(*, cp)
end

t3 = let cells = CellX[], nc = nc
    for i in 1:nc
        push!(cells, cellx(content = i, x = i, y = 0))
        push!(cells, cellx(content = i, x = 0, y = i))
    end

    # gray out the upper triangular and diag (symmetric example)
    for i in 1:nc, j in 1:nc
        if i >= j
            push!(cells, cellx(x = i, y = j, fill = :gray))
        end
    end

    # populate lower triangular with subject responses
    for i in 1:nc, j in 1:nc
        if i < j
            push!(cells, cellx(x = i, y = j, fill = rand([:blue, :red])))
        end
    end

    # table
    hdr = ["columns: " * string(nc+1),
    "fill: none",
    "align: center + horizon"]

    # make string vector
    cp = vcat(hdr, print.(cells))
    cp = cp .* ", \n";

    cp = tablex(cp)
    
    cp = reduce(*, cp)
end

t2 = let
    "gridx(
        columns: 1,
        align: center + horizon,
        cellx(x: 0, y: 6, align: center + horizon)[#text(size: 30pt)[⟶]],
    )"
end

subcaps = "[(a)],\n" * "[]\n," * "[(b)]\n";

caption = "[Roster method. In traditional designs, respondents are presented with a blank adjacency matrix (a), and are asked to fill it out for the possible relationships between five individuals. Subjects do not fill out the upper triangular, since they are queried about symmetric ties. Respondents state (b) whether they believe that a relationship exists (blue response), or does not exist (red response) between all possible symmetric pairs.]";

tpl = "#figure(\n kind:table,\n grid(columns: 3, row-gutter: 2mm, column-gutter: 1mm,\n";

#import "@preview/tablex:0.0.8": tablex, cellx, gridx
tb = "    "
body = vcat("\n" * t1, ",", "\n" * t2, ",", "\n" * t3, ",", "\n    " * subcaps)

out = ["#import \"@preview/tablex:0.0.8\": tablex, cellx, gridx\n",
    "#figure(
    grid(
        columns: " * string(3) * ",
        row-gutter: 2mm,
        column-gutter: 1mm,",
        body...,
    "\n),",
  "\n    caption: " * string(caption) * "\n) <roster> \n"
]
out = reduce(*, out);
textexport("model_variables/tables/roster", out; ext = ".typ");
