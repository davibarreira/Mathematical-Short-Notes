### Helper functions for drawing Hasse Diagrams
###
using Librsvg_jll
using Luxor
using MathTeXEngine
using LaTeXStrings

function bbarrow(startpoint, endpoint, linewidth=0.8)
    r = 7
    @layer begin
        shaftangle = anglepoints(startpoint,endpoint)
        setlinecap("round")
        translate(endpoint)
        rotate(shaftangle-π)
        setline(linewidth)
        
        c1  = Point(0,-r)
        p1 = c1 + r*Point(cos(π/10), sin(π/10))
        p2 = O
        
        move(p1)
        arc2r(c1,p1,p2,:stroke)

        c2  = Point(0,r)
        p3 = c2 + r*Point(cos(-π/10), sin(-π/10))
        arc2r(c2,p2,p3,:stroke)
    end
        
    @layer begin
        setline(linewidth)
        c  = Point(0,-r)
        p = c + r*Point(cos(π/4), sin(π/4))
        line(startpoint-Point(0,p.y),endpoint-p,:stroke)
        
        c  = Point(0,r)
        p = c + r*Point(cos(-π/4), sin(-π/4))
        line(startpoint-Point(0,p.y),endpoint-p,:stroke)
    end
end

function quiverarrow(shaftendpoint, endpoint, shaftangle)
    @layer begin
        r = 6
        setlinecap("round")
        translate(endpoint)
        rotate(shaftangle-π)
        # setline(1)
        
        c1  = Point(0,-r)
        p1 = c1 + r*Point(cos(π/10), sin(π/10))
        p2 = O
        
        arc2r(c1,p1,p2,:stroke)

        c2  = Point(0,r)
        p3 = c2 + r*Point(cos(-π/10), sin(-π/10))
        arc2r(c2,p2,p3,:stroke)
    end
end

function anglepoints(pt1::Point, pt2::Point)
    atan(-pt2.y + pt1.y, pt2.x-pt1.x)
end

# function labelmorphism(l::AbstractString, pos::Symbol, pt::Point; offset=5)
#     if occursin("⨟", l)
#         label(l,pos,pt, offset=offset)
#     else
#     end
# end

"""
    morphism(dom::Point,cod::Point, morphismlabel=L"f", pos=:N,;linewidth=1, offset=8, curve=0)
Draws the morphism arrow between two objects. Set `curve = :N` or `curve = :S` to make
the morphism curve.
"""
function morphism(dom::Point,cod::Point, morphismlabel=L"f", pos=:N,;linewidth=1, offset=8, curve=0)
    θ  = anglepoints(dom,cod)
    o1 = offset*Point(cos(θ),-sin(θ))
    o2 = offset*Point(-cos(θ),sin(θ))
    
    p1 = dom + o1
    p2 = cod + o2
    
    if curve == 0
        arrow(p1,p2,linewidth=linewidth, arrowheadlength = 0,
            arrowheadfunction = quiverarrow)
    else curve
        pcurve = (p1+p2)/2 + curve*Point(sin(θ), cos(θ))
        arrow(p1+Point(0,8),pcurve,pcurve,p2+Point(0,8),linewidth=linewidth, arrowheadlength = 0,
            arrowheadfunction = quiverarrow)
    end
    
    if  -40 ≤ rad2deg(θ) ≤ 40 || 140 ≤ rad2deg(θ) ≤ 220 || -220 ≤ rad2deg(θ) ≤ -140
        # label(morphismlabel,:N,(p1+p2)/2, offset=5-1.3curve)
        label(morphismlabel,pos,(p1+p2)/2, offset=5-1.3curve)
    elseif  90 < rad2deg(θ) < 140 || -40 > rad2deg(θ) > -90
        # label(morphismlabel,:NE,(p1+p2)/2, offset=5)
        label(morphismlabel,pos,(p1+p2)/2, offset=5)
    elseif  40 < rad2deg(θ) < 90 || -140 < rad2deg(θ) < -90
        # label(morphismlabel,:NW,(p1+p2)/2, offset=5)
        label(morphismlabel,pos,(p1+p2)/2, offset=5)
    elseif rad2deg(θ) ≈ 90 || rad2deg(θ) ≈ 270 || rad2deg(θ) ≈ -90 || rad2deg(θ) ≈ -270
        # label(morphismlabel,:W,(p1+p2)/2, offset=5)
        label(morphismlabel,pos,(p1+p2)/2, offset=5)
    end
end

"""
    morphism(domcod::Point;label::AbstractString=L"f",linewidth=1)
Draws the morphism arrow where dom(f) = cod(f).
"""
function morphism(domcod::Point, morphismlabel::AbstractString=L"id"; linewidth=1)
    adjx = 6
    adjy = -2
    loopx = 30
    loopy = 40
    labely= 16
    arrow(domcod + Point(-adjx,adjy),domcod + Point(-loopx,-loopy), domcod+ Point(loopx,-loopy),domcod+Point(adjx,adjy),linewidth=1,
        arrowheadlength = 0,
        arrowheadfunction = quiverarrow)

    label(morphismlabel,:N, domcod+Point(0,-loopy + labely), offset=10)
end

"""
    savediagram(d::Drawing, output::String)
Saves the diagram as as pdf.
Example: 

```julia
d = Drawing(100,120,:svg)
origin()
translate(Point(0,20))
circle(O, 5,:fill)
fontsize(12)
label(L"a",:S, offset=10)
morphism(O)
finish()

savediagram(d, "mydiagram.pdf")
```
"""
function savediagram(d::Drawing, output::String)
    fname = tempname()
    open(fname,"w") do f
        write(f, String(copy(d.bufferdata)))
    end
    # Convert svg to pdf
    figurepdf = output
    rsvg_convert() do cmd
       run(`$cmd $fname -f pdf -o $figurepdf`)
    end
end
;

## EXAMPLES
# d = Drawing(300,300,:svg)
#
# origin()
# circle(O, 5,:fill)
# fontsize(12)
#
# p = Point(100,0)
# circle(p, 5,:fill)
# morphism(O, p)
#
# p = Point(-100,0)
# circle(p, 5,:fill)
# morphism(O, p)
#
# p = Point(0,100)
# circle(p, 5,:fill)
# morphism(O, p)
#
# p = Point(0,-100)
# circle(p, 5,:fill)
# morphism(O, p)
#
# p = Point(100,100)
# circle(p, 5,:fill)
# morphism(O, p)
#
# p = Point(-100,100)
# circle(p, 5,:fill)
# morphism(O, p)
#
# p = Point(100,-100)
# circle(p, 5,:fill)
# morphism(O, p)
#
# p = Point(-100,-100)
# circle(p, 5,:fill)
# morphism(O, p)
#
# finish()
# d

# d = Drawing(100,120,:svg)
# origin()
# translate(Point(0,20))
# circle(O, 5,:fill)
# fontsize(12)
# label(L"a",:S, offset=10)
# morphism(O)
# finish()
# d
