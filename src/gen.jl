"""
    gen(...)

Sample from a generative model of a DDN.

In most cases, a simulator should use the `@gen` macro. Model implementers should implement one or more new methods of the function.

There are three versions of the function:
- The most convenient version to implement is gen(ddn::YourDDN, inputs..., rng), which should return an associative container (such as a `NamedTuple` if node ids are Symbols) mapping each node id to a sample from that node.
- Defining behavior for and sampling from individual nodes can be accomplished with `gen(::DDNNode{:x}, ddn` argument.
- A version with a `DDNOut` argument is provided by the compiler to sample multiple nodes at once.

See below for detailed documentation for each type.

---

    gen(ddn, inputs..., rng)

Convenience function for implementing the entire generative model in one function by returning an associative container (e.g. `NamedTuple`) with samples from all the nodes.

This single-function version of `gen` is the most convenient for model writers to implement. However, it should *never* be used directly by simulators or algorithms. Instead simulators should use the `@gen` macro. 

# Arguments
- `ddn`: dynamic decision network object
- `inputs`: values for each of the input chance and decision nodes of the DDN
- `rng`: a random number generator (Typically a `MersenneTwister`)

# Return
The function should return an associative container such as a [`NamedTuple`](https://docs.julialang.org/en/v1/base/base/#Core.NamedTuple). Typically, this `NamedTuple` will be `(sp=<next state>, r=<reward>)` for an `MDP` or `(sp=<next state>, o=<observation>, r=<reward>) for a `POMDP`.

---

    gen(v::DDNNode{id}, ddn, inputs..., rng::AbstractRNG)

Sample a value from a node in the dynamic decision network. 

These functions will be used within gen(::DDNOut, ...) to sample values for all outputs and their dependencies. They may be implemented directly by a problem-writer if they wish to implement a generative model for a particular node in the dynamic decision network, and may be called in algorithms to sample a value for a particular node.

# Arguments
- `v::DDNNode{id}`: which DDN node the function should sample from.
- `ddn`: dynamic decision network object
- `inputs`: values for all of the parent chance and decision nodes. Parents are determined by `parents(DDNStructure(ddn), name)`.
- `rng`: a random number generator (Typically a `MersenneTwister`)

# Return
A sampled value from the specified node.

# Examples
Let `m` be a `POMDP`, `s` and `sp` be states of `m`, `a` be an action of `m`, and `rng` be an `AbstractRNG`.
- `gen(DDNNode(:sp), m, s, a, rng)` returns the next state.
- `gen(DDNNode(:o), m, s, a, sp, rng)` returns the observation given the previous state, action, and new state.

---

    gen(t::DDNOut{X}, ddn, inputs, rng)

Sample values from several nodes in the dynamic decision network. X is a symbol or tuple of symbols indicating which nodes to output.

An implementation of this method is automatically provided by DynamicDecisionNetworks.jl if the other versions of `gen` are implemented. Algorithms and simulators should use the `@gen` macro or this version of the function. Model writers may implement it directly in special cases.

# Arguments
- `t::DDNOut`: which DDN nodes the function should sample from.
- `ddn`: dynamic decision network
- `s`: the current state
- `a`: the action
- `rng`: a random number generator (Typically a `MersenneTwister`)

# Return
If the `DDNOut` parameter, `X`, is a symbol, return a value sample from the corresponding node. If `X` is a tuple of symbols, return a `Tuple` of values sampled from the specified nodes.

# Examples
Let `m` be an `MDP` or `POMDP`, `s` be a state of `m`, `a` be an action of `m`, and `rng` be an `AbstractRNG`.
- `gen(DDNOut(:sp, :r), m, s, a, rng)` returns a `Tuple` containing the next state and reward.
- `gen(DDNOut(:sp, :o, :r), m, s, a, rng)` returns a `Tuple` containing the next state, observation, and reward.
- `gen(DDNOut(:sp), m, s, a, rng)` returns the next state.
"""
function gen end

