# stepwise.jl

function compose(lhs::Symbol, rhs)
    trms = AbstractTerm[]
    trms = [trms..., term(1)]
    if !isempty(rhs)
        trms = [trms..., rhs...]
    end
    term(lhs) ~ reduce(+, trms)
end

function step(df, lhs::Symbol, rhs,
              forward::Bool, use_aic::Bool)
    options = forward ? setdiff(Symbol.(names(df)), [lhs; rhs]) : rhs
    options = term.(options)
    fun = use_aic ? aic : bic
    isempty(options) && return (rhs, false)
    best_fun = fun(glm(compose(lhs, rhs), df, Binomial(), LogitLink()))
    improved = false
    best_rhs = rhs
    for opt in options
        this_rhs = forward ? [rhs; opt] : setdiff(rhs, [opt])
        this_fun = fun(glm(compose(lhs, this_rhs), df, Binomial(), LogitLink()))
        if this_fun < best_fun
            best_fun = this_fun
            best_rhs = this_rhs
            improved = true
        end
    end
    (best_rhs, improved)
end

function stepwise(df, force, lhs::Symbol, forward::Bool, use_aic::Bool)
    if !isnothing(force)
        rhs = forward ? [force] : setdiff(Symbol.(names(df)), [lhs])
    else
        rhs = forward ? Symbol[] : setdiff(Symbol.(names(df)), [lhs])
    end
    while true
        rhs, improved = step(df, lhs, rhs, forward, use_aic)
        improved || return glm(compose(lhs, rhs), df, Binomial(), LogitLink())
    end
end
