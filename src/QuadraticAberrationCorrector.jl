module QuadraticAberrationCorrector

using LinearAlgebra
using Statistics

export CorrectAberration
export WeightedCorrectAberration

function MMASD(ϕ)
    return maximum(ϕ) - minimum(ϕ) - mean(ϕ) - std(ϕ);
end

function MakeCoefficientMatrix(ϕ)
    S = Array{eltype(ϕ), 2}(undef, length(ϕ), 6);
    S[:,1] .= 1;
    S[:,2] = repeat(Vector(1:size(ϕ, 2)), inner=size(ϕ, 1));
    S[:,3] = repeat(Vector(1:size(ϕ, 1)), size(ϕ, 2));
    S[:,4] = S[:,2].*S[:,3];
    S[:,5] = S[:,2].^2;
    S[:,6] = S[:,3].^2;
    return S;
end

function MakeGridPhase(ϕ, ρx, ρy)
    ψ = Array{eltype(ϕ), 2}(undef, size(ϕ));
    for j in 1:ρx
        jrange = round(Int, (j - 1)size(ϕ, 2)/ρx + 1) : round(Int, j*size(ϕ, 2)/ρx);
        for i in 1:ρy
            irange = round(Int, (i - 1)size(ϕ, 1)/ρy + 1) : round(Int, i*size(ϕ, 1)/ρy);
            ψ[irange, jrange] .= MMASD(@view ϕ[irange, jrange]);
        end
    end
    return ψ;
end

function FitCoefficients(ϕ)
    S = MakeCoefficientMatrix(ϕ);
    return inv(S'*S)*S'*ϕ[:];
end

function FitCoefficients(ϕ, S)
    return inv(S'*S)*S'*ϕ[:];
end

"""
    CorrectAberration(ϕ)

Returns the corrected phase map of `ϕ` using the least squares algorithm.
Argument `ϕ` must be an unwrapped phase.
"""
function CorrectAberration(ϕ)
    S = MakeCoefficientMatrix(ϕ);
    return reshape(ϕ[:] - S*(inv(S'*S)*S'*ϕ[:]), size(ϕ));
end

function CorrectAberration(ϕ, S)
    return reshape(ϕ[:] - S*(inv(S'*S)*S'*ϕ[:]), size(ϕ));
end

function MakePreCompensatedPhase(ϕ, ρx, ρy)
    S = MakeCoefficientMatrix(ϕ);
    ψ = CorrectAberration(ϕ, S);
    U = FitCoefficients(MakeGridPhase(ψ, ρx, ρy), S);
    return reshape(ψ[:] .+ S*U, size(ϕ));
end

function MakePreCompensatedPhase(ϕ, S, ρx, ρy)
    ψ = CorrectAberration(ϕ, S);
    U = FitCoefficients(MakeGridPhase(ψ, ρx, ρy), S);
    return reshape(ψ[:] .+ S*U, size(ϕ));
end

function MakeWeightedMatrix(ϕ, ρx, ρy)
    ψ = MakePreCompensatedPhase(ϕ, ρx, ρy);
    μ = mean(ψ);
    σ = std(ψ);
    return abs.(ψ .- μ) .< σ;
end

function MakeWeightedMatrix(ϕ, S, ρx, ρy)
    ψ = MakePreCompensatedPhase(ϕ, S, ρx, ρy);
    μ = mean(ψ);
    σ = std(ψ);
    return abs.(ψ .- μ) .< σ;
end

"""
    WeightedCorrectAberration(ϕ, ρx, ρy)

Returns the corrected phase map of `ϕ` using the weighted least squares algorithm.
Argument `ρx` and `ρy` are division numbers. The input phase map `ϕ` is divided into a ``\\rho_{x}\\times\\rho_{y}`` grid to obtain a weighted matrix based on the maximum-minimum-average-standard deviation (MMASD) metric.
See the following reference for details.

[Zhenkai Chen, Wenjing Zhou, Lian Duan, Hongbo Zhang, Huadong Zheng, Xinxing Xia, Yingjie Yu, and Ting-chung Poon, "Automatic elimination of phase aberrations in digital holography based on Gaussian 1σ- criterion and histogram segmentation," Opt. Express 31, 13627-13639 (2023)](https://doi.org/10.1364/OE.486890)
"""
function WeightedCorrectAberration(ϕ, ρx, ρy)
    S = MakeCoefficientMatrix(ϕ);
    ω = MakeWeightedMatrix(ϕ, S, ρx, ρy);
    U = inv(S'*Diagonal(ω[:])*S)*S'*Diagonal(ω[:])*ϕ[:];
    return reshape(ϕ[:] .- S*U, size(ϕ));
end

end
