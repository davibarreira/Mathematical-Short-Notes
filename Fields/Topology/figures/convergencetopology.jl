# From https://github.com/lazarusA/100daysOfMakie

using CairoMakie, Makie.GeometryBasics
n = 20
function ngonShape(h, k, r, n)
    Polygon([Point2f(h .+ r * sin.(m * 2π / n), k .+ r * cos.(m * 2π / n)) for m in 1:n])
end
polysCentric = [ngonShape(0, 0, 3 / i^1.5, i) for i in 3:n]
polysCircular = [ngonShape(√2 / 2 * sin(θ), √2 / 2 * cos(θ), 0.15 / √idx, idx + 2) 
    for (idx, θ) in enumerate(LinRange(0, 2π * (1 - 1 / (n - 2)), n - 2))]
cmap = to_colormap(:linear_protanopic_deuteranopic_kbw_5_98_c40_n256)[3:end]
cmap = :grays

with_theme(theme_minimal()) do
    fig, ax, = poly(polysCentric;
        color=:white,
        # color=1:n - 2, colormap=cmap,
        strokecolor=:black, strokewidth=1,
        axis=(;aspect=DataAspect()), figure=(;resolution=(600, 400)))
    poly!(polysCircular; 
        color=:white,
        # color=1:n - 2, colormap=cmap,
        strokecolor=:black, strokewidth=1,
        )
    hidedecorations!(ax; grid=false)
    hidespines!(ax)
    save("convergencetopologyfig.pdf", fig)
    display(fig)
end
