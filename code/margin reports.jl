# margin reports.jl

include("../../code/setup/environment.jl");

# assist reporting in text
@inline textreport(x) = round(100 .* x; digits = 1)

#%% main model

md = load_object("objects/base1_tie2_margins_bs_out.jld2")
transforms = load_object("objects/variable_transforms.jld2")

# age

df = md[:age].rg
v, loc = findmax(df.j)

# report in-text
textreport(df[loc, :j])
textreport(df[loc, :tpr])
textreport(df[loc, :fpr])

textreport(df[loc, :ci_j])
textreport(df[loc, :ci_tpr])
textreport(df[loc, :ci_fpr])

#%% genetic relatedness kinship

kn = load_object("interaction models/base1_tie2_relatedness_margins_bs.jld2");

df = @subset kn[:kinship].rg .!($kin);

v, loc = findmax(df.j)
df[loc, :]

# report in-text
textreport(df[loc, :j])
textreport(df[loc, :tpr])
textreport(df[loc, :fpr])

textreport(df[loc, :ci_j])
textreport(df[loc, :ci_tpr])
textreport(df[loc, :ci_fpr])

#%% contrasts
cts = load_object("objects/_contrast_df.jld2")

#
x = @subset(cts, :Variable .== "Relation")[1, :]

a, b = x[[:tpr, :ci_tpr]]
textreport.([a,b])

a, b = x[[:fpr, :ci_fpr]];
textreport.([a,b])

# 
x = @subset(cts, :Variable .== "Age")

a, b = x[[:tpr, :ci_tpr]]
textreport.([a,b])

a, b = x[[:fpr, :ci_fpr]];
textreport.([a,b])
