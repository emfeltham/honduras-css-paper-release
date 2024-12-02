# Cognitive representations of social networks in isolated villages

This repository contains the demonstration code for "Cognitive representations of social networks in isolated villages".

Additionally, this package contains a small simulated and simplified dataset to demonstrate the analysis workflow for the paper results.

# System Requirements

## Hardware

Simplified analyses are expected to run on a typical computer, _e.g._, This will be a computer with at least 16 GB, and 4 cores. Analysis and testing was carried out on a system running MAC OS 17.0, with 64 Gb RAM, and an intel i9 processor @ 2.30Ghz.

However, given the large dataset studied in the paper, analyses were executed on a cluster with 30 cores. The main mixed logistic regression models were executed over several hours, and the bootstrap calculations took less than a day to run.

## Software

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

See "code_replication/install.jl" to install the necessary Julia packages.

From within a Julia session, type:

```{julia}
import Pkg; Pkg.add("https://github.com/human-nature-lab/HondurasTools.jl")
```

The packages should take approximately 1-5 minutes to install.

## Dependencies

The analysis workflow depends on several custom packages that are not on the Julia package manager. Run "code/install.jl" to install all necessary dependencies. These dependencies contain the functions needed to execute the code in the scripts contained in this repository, and each may be examined at its respective GitHub repository page.

## Code

We present all code used for the analyses presented in the manuscript.

- Main paper analyses are contained in the "code/" directory
- The demonstration code is in "code_demonstration/"
- See "code_figure/" and "code_table/" for code used to generate figures and tables

## Demonstration

To illustrate the analysis workflow, we present a simplified simulated dataset. It is contained in `objects/simulated_data.jld2` and may be used to demonstrate the estimation of the TPR and FPR logistic mixed models, which may be run with `main_model_simulation.jl`. The data is for illustrative purposes, and does not replicate the paper results.

## Main analysis

Estimate models:

1. Execute the logistic regression models of the TPR and FPR `code_demonstration/mainmodel.jl`
2. Conduct parametric bootstrap of each model `code_demonstration/bootstrap base model tpr tie.jl` and `code/bootstrap base model fpr tie.jl`

Calculate marginal effects (_e.g._, Fig. 3) of interest:

1. Execute `code_demonstration/margin_data.jl` which calculates the marginal effects and bootstraps the confidence intervals for the J statistic estimates.

## TPR vs. FPR analysis

Execute

1. `code_demonstration/stage_0.jl` to define the reference grids for the respondent-level estimates (the second stage models use individual-level accuracy estimates)
2. `code_demonstration/rates_1.jl` and `code/rates_2.jl` to estimate second-stage regressions of TPR on FPR that adjust for uncertainty in the first-stage models.
3. `code_demonstration/rates_assess.jl` to calculate the final adjusted estimates for the rates analysis.

The riddle analysis proceeds analogously.

## Riddle analysis

This analysis depends on the riddle outcomes data in addition to the data required for the TPR vs. FPR analysis above.

Additionally, instead of estimating the relationship between the two rates, we now estimate the probability of knowing the riddle separately for each accuracy metric (FPR, TPR, J), Execute

1. `code_demonstration/stage_0.jl` to define the reference grids for the respondent-level estimates (the second stage models use individual-level accuracy estimates) (repeated from above)
2. `code_demonstration/riddle_fpr.jl`, `code/riddle_tpr.jl`, `code/riddle_j.jl`
3. `code_demonstration/riddle_assess.jl` to calculate the final adjusted estimates for the riddle analysis.
