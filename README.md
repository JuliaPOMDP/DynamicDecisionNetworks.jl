# DynamicDecisionNetworks

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://zsunberg.github.io/DynamicDecisionNetworks.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://zsunberg.github.io/DynamicDecisionNetworks.jl/dev)
[![Build Status](https://travis-ci.com/zsunberg/DynamicDecisionNetworks.jl.svg?branch=master)](https://travis-ci.com/zsunberg/DynamicDecisionNetworks.jl)
[![Codecov](https://codecov.io/gh/zsunberg/DynamicDecisionNetworks.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/zsunberg/DynamicDecisionNetworks.jl)

This package provides an interface for representing Dynamic Decision Networks (DDNs) in Julia. In order to promote better compatibility with other packages, it does not export abstract types, but is instead built around the `DDNStructure` trait, which can make any type look and function like a DDN.

Note that Dynamic Bayesian Networks (DBNs) are a subset of DDNs, so this package should be suitable for representing DBNs as well.

## Development

During the development of this package, the space below will be used to sketch out ideas.

### POMDP DDN

```julia
function DDNStructure(::Type{<:POMDP})
    return BasicDDN( :s => InputNode(1, observable=false),
                     :a => DecisionNode(2),
                    :sp => ChanceNode((:s,:a), next=:s, observable=false),
                     :o => ChanceNode((:s,:a,:sp), observable=true),
                     :r => UtilityNode((:s,:a,:sp,:o)))
end
```
