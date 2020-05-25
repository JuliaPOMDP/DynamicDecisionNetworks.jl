# DynamicDecisionNetworks

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://zsunberg.github.io/DynamicDecisionNetworks.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://zsunberg.github.io/DynamicDecisionNetworks.jl/dev)
[![Build Status](https://travis-ci.com/zsunberg/DynamicDecisionNetworks.jl.svg?branch=master)](https://travis-ci.com/zsunberg/DynamicDecisionNetworks.jl)
[![Codecov](https://codecov.io/gh/zsunberg/DynamicDecisionNetworks.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/zsunberg/DynamicDecisionNetworks.jl)

This package provides an interface for representing Dynamic Decision Networks (DDNs) in Julia. In order to promote better compatibility with other packages, it does **not** export abstract types, but is instead built around the `DDNStructure` trait, which can make any type look and function like a DDN.

Note that Dynamic Bayesian Networks (DBNs) are a subset of DDNs, so this package should be suitable for representing DBNs as well.

## Development

### Minimum Initial Requirements

The initial use of this package will be to provide the generative interface for POMDPs.jl. We will first implement the minimum requirements for this. At this stage, the only requirement is to be able to sample values for selected nodes from the network.

A sample from the network can be drawn with the `@gen` macro, and the sampling behavior is implemented with the `gen` function. There are two versions of the `gen` function:
1. If it is desirable to sample from all of the nodes in one function, you can implement `gen(ddn::YourDDNType, input1, input2, ..., rng)`, which should return an associative data structure mapping node ids to sampled values (if the node ids are symbols, a `NamedTuple` would be appropriate. The input arguments are values for the input nodes.
2. If it is more convenient to implement each node separately

In order to allow efficient sampling with the @gen macro, DDN structure trait. A method for the `DDNStructure` function should be implemented for a type that acts as a DDN:
```julia
DDNStructure(::Type{MyDDNType})
```

Conceptually, each node in the DDN structure has
1. an id (this could be an integer or a symbol, for example. This must be valid for use as a type parameter)
3. a list of parents

As such, the initial interface for a DDN will consist only of
```
parents(ddnstructure, id) # returns an iterable of parent ids
```

#### POMDP Sketch

Since the only information currently encoded in the DDN structure is the list of parents, the POMDP DDN structure m

```julia
function DDNStructure(::Type{<:POMDP})
    DDNDiGraph(:s,
               :a,
               (:s,:a) => :sp,
               (:s,:a,:sp) => :o,
               (:s,:a,:sp,:o) => :r
              )
end
```

### Future

In the future, this package may be greatly expanded, possibly including:
- Ways to access the explicit conditional distributions of nodes.
- Additional information about each of the nodes
    - the type of node (chance, decision, utility)
    - whether the node is observable
    - which nodes correspond to state nodes at the next timestep

#### POMDP Sketch

Eventually, when these additional features are implemented, a POMDP DDN Structure might look like this:

```julia
function DDNStructure(::Type{<:POMDP})
    return DDNStructure( :s => InputNode(1, observable=false),
                         :a => DecisionNode(2),
                        :sp => ChanceNode(parents=(:s,:a), next=:s, observable=false),
                         :o => ChanceNode(parents=(:s,:a,:sp), observable=true),
                         :r => UtilityNode(parents=(:s,:a,:sp,:o)))
end
```
