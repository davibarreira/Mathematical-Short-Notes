using Distributions
using Plots


d = Gumbel
t = range(0, 10, 100)
p = pdf.(d(1), t)
S = 1 .- cdf.(d(1), t)
h = p ./ S
plot(t, S)
plot!(t, h)
