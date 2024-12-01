# environment.jl

import Pkg; Pkg.activate("..");

using AbbreviatedStackTraces

#Pkg.develop(path = "../HondurasTools.jl"); # general functions, definitions
#Pkg.develop(path = "../NiceDisplay.jl"); # tables, figures, quarto
#Pkg.develop(path = "../HondurasCSS.jl");
#Pkg.develop(path = "../Typst.jl");

using HondurasTools
using NiceDisplay
using HondurasCSS
using Typst

grid_theme = Theme(
    Axis = (ygridvisible = false, xgridvisible = false),
    backgroundcolor = :transparent,
);
set_theme!(grid_theme);

