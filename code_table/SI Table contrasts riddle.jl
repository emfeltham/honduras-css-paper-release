# SI Table contrasts riddle.jl

include("../../code/setup/environment.jl")

pdigits = 5;

_, xf = load_object("objects/riddle_data.jld2");

xf[!, "Pr(>|z|)"] = pvalue.(xf.knows, xf.err);
rename!(xf, "knows" => "Riddle knowledge")

xf[!, "Riddle knowledge"] = round.(xf[!, "Riddle knowledge"]; digits = 3)
xf[!, :ci] = round.(xf[!, :ci]; digits = 3)
xf[!, "Pr(>|z|)"] = round.(xf[!, "Pr(>|z|)"], digits = 5);

xf2 = @chain xf begin
    stack([Symbol("Riddle knowledge"), :ci, Symbol("Pr(>|z|)")], value_name = "Riddle knowledge")
    sort(:rate; rev = true)
    select(Not(:err, :variable))
end

for e in unique(xf2.Contrast)
    @views(xf2.Contrast[xf2.Contrast .== e][2:end]) .= ""
end

for e in unique(xf2.rate)
    @views(xf2.rate[xf2.rate .== e][2:end]) .= ""
end

xf2
rename!(xf2, :rate => :Rate)

xf2.Rate = uppercase.(xf2.Rate)

xf2[2, 1] =  "#text(fill: lbg)[95% CI]"
xf2[3,1] = "#text(fill: lbg)[_P_]"

superheader = (content = [
    cellx(; colspan = 3),
    cellx(; content = "Difference", colspan = 3, align = :center),
    hlinex(; start_ = 3, stroke = Symbol("gray + 0.01em"))
], rownum = 1);

tbx = tablex(
    xf2;
    superheader = nothing, scientificnotation = false,
    numberrows = true, rounddigits = pdigits
);

#%%
filepathname = "honduras-css-paper/tables_si/SI Table contrasts riddle"
caption = "Contrasts for riddle knowledge on social network accuracy. Each accuracy measure represents the difference between the predicted value for each level of the contrast. 95% confidence intervals are presented in parentheses below the mean estimates. The corresponding p-values are presented below the intervals, and are rounded to 5 digits."
supplement = "Supplementary Table"

caption = Typst.Caption(caption)
short_caption = Typst.Caption("Contrasts for riddle knowledge on social network accuracy.")

fgt = figuret(tbx; caption, short_caption, supplement, kind = Symbol("table-si"))

imp = "#import" * "\"" * "@preview/tablex:0.0.8\": tablex, gridx, hlinex, vlinex, colspanx, rowspanx, cellx" * "\n \n";

extra = Typst.shortcapfunction * "\n" * "#let lbg = rgb(\"#63aaff\")\n#let org = rgb(\"#6d5319\")\n"

fnp = split(filepathname, ".")[1] # remove extension
fnp * "\"" * fnp * "\""

# label is filename
label = Typst.getname(filepathname; ext = false) |> Typst.makelabel

textexport(filepathname, imp * extra * print(fgt) * label)
