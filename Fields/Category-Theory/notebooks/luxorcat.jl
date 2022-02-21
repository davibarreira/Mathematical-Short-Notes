### Helper functions for drawing Hasse Diagrams
###

using Luxor
using MathTeXEngine
using LaTeXStrings

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

"""
    morphism(dom::Point,cod::Point;label::AbstractString=L"f",linewidth=1)
Draws the morphism arrow between two objects.
"""
function morphism(dom::Point,cod::Point;morphismlabel=L"f",linewidth=1, offset=8)
    θ  = anglepoints(dom,cod)
    o1 = offset*Point(cos(θ),-sin(θ))
    o2 = offset*Point(-cos(θ),sin(θ))
    
    p1 = dom + o1
    p2 = cod + o2
    
    arrow(p1,p2,linewidth=linewidth, arrowheadlength = 0,
        arrowheadfunction = quiverarrow)
    
    if  -40 ≤ rad2deg(θ) ≤ 40 || 140 ≤ rad2deg(θ) ≤ 220 || -220 ≤ rad2deg(θ) ≤ -140
        label(morphismlabel,:N,(p1+p2)/2, offset=5)
    elseif  90 < rad2deg(θ) < 140 || -40 > rad2deg(θ) > -90
        label(morphismlabel,:NE,(p1+p2)/2, offset=5)
    elseif  40 < rad2deg(θ) < 90 || -140 < rad2deg(θ) < -90
        label(morphismlabel,:NW,(p1+p2)/2, offset=5)
    elseif rad2deg(θ) ≈ 90 || rad2deg(θ) ≈ 270 || rad2deg(θ) ≈ -90 || rad2deg(θ) ≈ -270
        label(morphismlabel,:W,(p1+p2)/2, offset=5)
    end
end

"""
    morphism(domcod::Point;label::AbstractString=L"f",linewidth=1)
Draws the morphism arrow where dom(f) = cod(f).
"""
function morphism(domcod::Point;morphismlabel::AbstractString=L"id",linewidth=1)
    arrow(domcod + Point(-8,-2),domcod + Point(-50,-50), domcod+ Point(50,-50),domcod+Point(8,-2),linewidth=1,
        arrowheadlength = 0,
        arrowheadfunction = quiverarrow)
    label(morphismlabel,:N, Point(0,-32), offset=10)
end

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
