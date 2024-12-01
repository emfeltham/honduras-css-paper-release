# check boot

mx = load_object("interaction models/base1_age2.jld2")
let
pbx = x = load_object("interaction models/base_pb_10K_tpr.jld2")
pbx = x = load_object("interaction models/base_pb_10K_tpr.jld2")
pbx = (tpr = pbx[1], fpr = pbx[2])

bred = @chain pbx.tpr.β begin
    DataFrame()
    groupby([:coefname])
    combine(:β => mean; renamecols = false)
end;

bmodel = DataFrame(coefname = coefnames(mx.tpr), β_est = coef(mx.tpr));
bmodel.coefname = bred.coefname
leftjoin!(bred, bmodel; on = [:coefname])
