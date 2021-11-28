
function sweepEm.DrawBox(x, y, w, h, l, d)
    draw.NoTexture()

    sweepEm.DrawBorder(x, y, w, h, l, d)
    surface.SetDrawColor(sweepEm.Colors.mid)
    surface.DrawRect(x + 3, y + 3, w - 6, h - 6)
end

function sweepEm.DrawBorder(x, y, w, h, l, d)
    surface.SetDrawColor(l or sweepEm.Colors.light)
    surface.DrawRect(x,y,w,3)
    surface.DrawRect(x,y,3,h)

    surface.SetDrawColor(d or sweepEm.Colors.dark)
    -- Cancer, but better than polygons!
    surface.DrawRect(x + w - 3, y + 3, 3, h - 3)
    surface.DrawRect(x + w - 2, y + 2, 1, 1)
    surface.DrawRect(x + w - 1, y + 1, 1, 2)
    surface.DrawRect(x + 3, y + h - 3, w - 6, 1)
    surface.DrawRect(x + 2, y + h - 2, w - 5, 1)
    surface.DrawRect(x + 1, y + h - 1, w - 4, 1)
end

function sweepEm.DrawInsetBorder(x, y, w, h)
    sweepEm.DrawBorder(x, y, w, h, sweepEm.Colors.dark, sweepEm.Colors.light)
end

function sweepEm.DrawInsetBox(x, y, w, h)
    sweepEm.DrawBox(x, y, w, h, sweepEm.Colors.dark, sweepEm.Colors.light)
end