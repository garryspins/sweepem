
function sweepEm.Generate(sizex, sizey, mines)
    local map = {}

    for x = 1,sizex do
        map[x] = {}

        for y = 1,sizey do
            map[x][y] = 0
        end
    end

    for m = 1, mines do
        local kmax = 0

        while true do
            kmax = kmax + 1
            if kmax > 100 then
                ErrorNoHaltWithStack("[Stack Overflow][2] If you see this make a ticket please")
                break
            end

            local posx = math.random(1, sizex)
            local posy = math.random(1, sizey)

            if map[posx][posy] != "mine" then
                map[posx][posy] = "mine"
                break
            end
        end
    end

    for x, xm in ipairs(map) do
        for y, v in ipairs(xm) do
            if v == "mine" then
                local function loc(offx, offy)
                    if map[x + offx] and map[x + offx][y + offy] and isnumber(map[x + offx][y + offy]) then
                        map[x + offx][y + offy] = map[x + offx][y + offy] + 1
                    end
                end

                loc(1, -1)  -- TR
                loc(1, 0)   -- R
                loc(1, 1)   -- BR

                loc(0, -1)  -- T
                loc(0, 1)   -- B

                loc(-1, -1) -- TL
                loc(-1, 0)  -- L
                loc(-1, 1)  -- BL
            end
        end
    end

    return map
end

function sweepEm.ValidBoard(sizex, sizey, mines)
    return (sizex * sizey) > (mines * 1.25)
end

function sweepEm.DebugPrint(map)
    for x, xm in ipairs(map) do
        Msg(" ")
        for y, v in ipairs(xm) do
            Msg(
                (v == 0 and "[ ]") or
                (v == "mine" and "[F]") or
                ("[" .. v .. "]")
            )
        end
        MsgN()
    end
end