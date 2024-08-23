# Humans possess systematically distorted cognitive representations of their social networks

This repository contains the replication code for "Humans possess systematically distorted cognitive representations of their social networks".

Additionally, this package contains a small simulated and simplified dataset to demonstrate the analysis workflow for the paper results.

# System Requirements

## Hardware Requirements

This program has been tested on a standard computer, with sufficient RAM and processing power to support the size of the dataset analyzed by the user. This will be a computer with at least 16 GB, and 4 cores. Analysis and testing was carried out on a system running MAC OS 17.0, with 64 Gb RAM, and an intel i9 processor @ 2.30Ghz.

## Software Requirements

While analysis was executed on a MAC OSX system, all of the underlying dependencies are compatible with Windows, Mac, and Linux systems. This package has been tested on Julia 1.10.2.

**Julia system information and platform details**

```
Julia Version 1.10.2
Commit bd47eca2c8a (2024-03-01 10:14 UTC)
Build Info:
  Official https://julialang.org/ release
Platform Info:
  OS: Linux (x86_64-linux-gnu)
  CPU: 64 × Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz
  WORD_SIZE: 64
  LIBM: libopenlibm
  LLVM: libLLVM-15.0.7 (ORCJIT, icelake-server)
Threads: 20 default, 0 interactive, 10 GC (on 64 virtual cores)
Environment:
  JULIA_NUM_THREADS = 20
  JULIA_EDITOR = code
```

## Dependencies

### Programming languages

* [Julia](https://julialang.org) version 1.10.2 (2024-03-01)

### Language installation

Julia may be installed on Mac OSX using [homebrew](https://brew.sh) by executing:

```shell
brew install julia
```

Otherwise, consult the [Julia Language download page](https://julialang.org/downloads/) for installation on your system.

### Package installation

See "code/install.jl" to install the necessary Julia packages.

From within a Julia session, type:

```{julia}
import Pkg; Pkg.add("https://github.com/human-nature-lab/HondurasTools.jl")
```

The packages should take approximately 1-5 minutes to install.

## Dependencies

The analysis workflow depends on several custom packages that are not on the Julia package manager. Run "code/install.jl" to install all necessary dependencies. These dependencies contain the functions needed to execute the code in the scripts contained in this repository, and each may be examined at its respective GitHub repository page.

## Code

We present all code used for the analyses presented in the manuscript. Code is contained in the "code/" directory.

## Demonstration

To illustrate the analysis workflow, we present a simplified simulated dataset. It is contained in `objects/simulated_data.jld2` and may be used to demonstrate the estimation of the TPR and FPR logistic mixed models, which may be run with `main_model_simulation.jl`. The data is for illustrative purposes, and does not replicate the paper results.

## Main analysis

Estimate models:
1. Execute the logistic regression models of the TPR and FPR `code/mainmodel.jl`
2. Conduct parametric bootstrap of each model `code/bootstrap base model tpr tie.jl` and `code/bootstrap base model fpr tie.jl`

Calculate marginal effects (_e.g._, Figs. 2 and 3) of interest:
1. Execute `code/margin_data.jl` which calculates the marginal effects and bootstraps the confidence intervals for the J statistic estimates.

## TPR vs. FPR analysis

1. Execute `code/stage_0.jl` to define the reference grids for the respondent-level estimates (the second stage models use individual-level accuracy estimates)
2. Execute `code/rates_1.jl` and `code/rates_2.jl` to estimate second-stage regressions of TPR on FPR that adjust for uncertainty in the first-stage models.
3. Execute `code/rates_assess.jl` to calculate the final adjusted estimates for the rates analysis.

The riddle analysis proceeds analogously.

## Riddle analysis

This analysis depends on the riddle outcomes data in addition to the data required for the TPR vs. FPR analysis above.

Additionally, instead of estimating the relationship between the two rates, we now estimate the probability of knowing the riddle separately for each accuracy metric (FPR, TPR, J)

1. Execute `code/stage_0.jl` to define the reference grids for the respondent-level estimates (the second stage models use individual-level accuracy estimates) (repeated from above)
2. Execute `code/riddle_fpr.jl`, `code/riddle_tpr.jl`, `code/riddle_j.jl`
3. Execute `code/riddle_assess.jl` to calculate the final adjusted estimates for the riddle analysis.
