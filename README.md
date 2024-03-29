# QuadraticAberrationCorrector

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://syoshida1983.github.io/QuadraticAberrationCorrector.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://syoshida1983.github.io/QuadraticAberrationCorrector.jl/dev/)
[![Build Status](https://github.com/syoshida1983/QuadraticAberrationCorrector.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/syoshida1983/QuadraticAberrationCorrector.jl/actions/workflows/CI.yml?query=branch%3Amaster)

This package provides the functions to correct quadratic phase aberration.

# Installation

To install this package, open the Julia REPL and run

```julia
julia> ]add QuadraticAberrationCorrector
```

or

```julia
julia> using Pkg
julia> Pkg.add("QuadraticAberrationCorrector")
```

# Usage

Import the package first.

```julia
julia> using QuadraticAberrationCorrector
```

When the following code is executed, the phase `ϕ` is corrected by the least squares algorithm and stored in `ψ`.

```julia
julia> ψ = CorrectAberration(ϕ)
```

When using the weighted least square algorithm, use the following function.

```julia
julia> ψ = WeightedCorrectAberration(ϕ, 10, 10)
```

<p>
    <img src="https://github.com/syoshida1983/QuadraticAberrationCorrector.jl/blob/images/phase.svg" width="400px">
    <img src="https://github.com/syoshida1983/QuadraticAberrationCorrector.jl/blob/images/aberration.svg" width="400px">
    <img src="https://github.com/syoshida1983/QuadraticAberrationCorrector.jl/blob/images/aberrated.svg" width="400px">
    <img src="https://github.com/syoshida1983/QuadraticAberrationCorrector.jl/blob/images/least-squares.svg" width="400px">
    <img src="https://github.com/syoshida1983/QuadraticAberrationCorrector.jl/blob/images/weighted-least-squares.svg" width="400px">
</p>

For more information on the algorithm, please refer to the following reference.

> [Zhenkai Chen, Wenjing Zhou, Lian Duan, Hongbo Zhang, Huadong Zheng, Xinxing Xia, Yingjie Yu, and Ting-chung Poon, "Automatic elimination of phase aberrations in digital holography based on Gaussian 1σ- criterion and histogram segmentation," Opt. Express **31**, 13627-13639 (2023)](https://doi.org/10.1364/OE.486890)
