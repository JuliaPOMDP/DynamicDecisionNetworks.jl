# DynamicDecisionNetworks

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://zsunberg.github.io/DynamicDecisionNetworks.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://zsunberg.github.io/DynamicDecisionNetworks.jl/dev)
[![Build Status](https://travis-ci.com/zsunberg/DynamicDecisionNetworks.jl.svg?branch=master)](https://travis-ci.com/zsunberg/DynamicDecisionNetworks.jl)
[![Codecov](https://codecov.io/gh/zsunberg/DynamicDecisionNetworks.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/zsunberg/DynamicDecisionNetworks.jl)

This package provides an interface for representing Dynamic Decision Networks (DDNs) in Julia. In order to promote better compatibility with other packages, it does **not** export abstract types, but is instead built around the `DDNStructure` trait, which can make any type look and function like a DDN.

Note that Dynamic Bayesian Networks (DBNs) are a subset of DDNs, so this package should be suitable for representing DBNs as well.

## Minimum Initial Implementation

The initial use of this package will be to provide the generative interface for POMDPs.jl. We will first implement the minimum requirements for this. At this stage, the only requirement is to be able to sample values for selected nodes from the network.

### Interface for programmers *using* a DDN created by someone else

To generate samples from nodes `sp` and `r` from a DDN with inputs `s` and `a` (e.g. an MDP DDN), use
```julia
@gen(:sp, :r)(ddn, s, a, rng)
```

### Interface for programmers *creating* a DDN to be used in an algorithm

Sampling behavior is implemented with the `gen` function.<sup>1</sup> There are two versions of the `gen` function:
1. If it is desirable to sample from all of the nodes in one function, you can implement `gen(ddn::YourDDNType, input1, input2, ..., rng)`, which should return an associative data structure mapping node ids to sampled values (if the node ids are symbols, a `NamedTuple` would be appropriate. The input arguments are values for the input nodes of the entire network.
2. If it is more convenient to implement each node separately, sampling from an individual node can be defined with `gen(::DDNNode{:x}, ddn::YourDDNType, input1, input2, ..., rng)`.

The `DDNStructure` trait defines the direct dependencies of DDN nodes. Any type that acts as a DDN should have a corresponding method of the `DDNStructure` function:
```julia
DDNStructure(::Type{YourDDNType})
```

Conceptually, each node in the DDN structure has
1. an id (this could be an integer or a symbol, for example. This must be valid for use as a type parameter)
3. a list of parents

As such, the initial interface for a DDN will consist only of
```
parents(ddnstructure, id) # returns an iterable of parent ids
```

<sup>1</sup>The function name `gen` is used instead of `rand` or `sample` because of the use of the phrase "Generative Model" in the MDP/POMDP literature, and because it does not use the convention of having the rng as an optional first argument.

### POMDP Sketch

Since the only information currently encoded in the DDN structure is the list of parents, the POMDP DDN structure would look like this:

```julia
function DDNStructure(::Type{<:POMDP})
    DDNGraph(:s,
             :a,
             (:s,:a) => :sp,
             (:s,:a,:sp) => :o,
             (:s,:a,:sp,:o) => :r
            )
end
```

## Future

In the future, this package may be greatly expanded, possibly including:
- Ways to access the explicit conditional distributions of nodes.
- Additional information about each of the nodes
    - the type of node (chance, decision, utility)
    - whether the node is observable
    - which nodes correspond to state nodes at the next timestep

### POMDP Sketch

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
