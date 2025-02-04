# SI Table contrasts riddle differences.jl

include("../../code/setup/environment.jl")

pdigits = 5;

_, xf = load_object("objects/riddle_riddle_data.jld2");

rename!(xf, "knows" => "Riddle knowledge")

xf[!, "Riddle knowledge"] = round.(xf[!, "Riddle knowledge"]; digits = 3)
xf[!, :ci] = round.(xf[!, :ci]; digits = 3)
xf[!, "Pr(>|z|)"] = round.(xf[!, "Pr(>|z|)"], digits = pdigits);

xf2 = @chain xf begin
    stack([Symbol("Riddle knowledge"), :ci, Symbol("Pr(>|z|)")], value_name = "Riddle knowledge")
    sort([:rate, :Contrast]; rev = true)
    select(Not(:err, :variable))
end

for i in 1:3:25
    @views(xf2.Contrast[(i+1):(i+2)]) .= ""
end

for e in unique(xf2.rate)
    @views(xf2.rate[xf2.rate .== e][2:end]) .= ""
end

rename!(xf2, :rate => :Rate)

xf2.Rate = uppercase.(xf2.Rate)

xf2[2, 2] =  "#text(fill: lbg)[95% CI]"
xf2[3, 2] = "#text(fill: lbg)[_P_]"

superheader = (content = [
    cellx(; colspan = 3),
    cellx(; content = "Difference", colspan = 3, align = :center),
    hlinex(; start_ = 3, stroke = Symbol("gray + 0.01em"))
], rownum = 1);

tbx = tablex(
    xf2;
    superheader = nothing, scientificnotation = false,
    numberrows = true, rounddigits = 5
);

#%%
filepathname = "honduras-css-paper/tables_si/SI Table contrasts riddle differences"
caption = "Contrasts for riddle knowledge on social network accuracy, for each riddle, with the population average accuracy measure. Each accuracy measure represents the difference between the predicted value for each level of the contrast. 95% confidence intervals are presented in parentheses below the mean estimates. The corresponding p-values are presented below the intervals, and are rounded to 5 digits."

short_caption = Typst.Caption("Contrasts riddle knowledge on social network accuracy")

supplement = "Supplementary Table"

caption = Typst.Caption(caption)

fgt = figuret(tbx; caption, short_caption, supplement, kind = Symbol("table-si"))

imp = "#import" * "\"" * "@preview/tablex:0.0.8\": tablex, gridx, hlinex, vlinex, colspanx, rowspanx, cellx" * "\n \n";

extra = Typst.shortcapfunction * "\n" * "#let lbg = rgb(\"#63aaff\")\n#let org = rgb(\"#6d5319\")\n"

fnp = split(filepathname, ".")[1] # remove extension
fnp * "\"" * fnp * "\""

# label is filename
label = Typst.getname(filepathname; ext = false) |> Typst.makelabel

textexport(filepathname, imp * extra * print(fgt) * label)
