
file.CreateDir("sweepem")

local err = Material("icon16/anchor.png")
local imgs = {}
function sweepEm.Imgur(id)
    if imgs[id] then
        return imgs[id]
    end

    if file.Exists("sweepem/" .. id .. ".png", "DATA") then
        imgs[id] = Material("../data/sweepem/" .. id .. ".png")
        return imgs[id]
    end

    imgs[id] = err

    http.Fetch("https://i.imgur.com/" .. id .. ".png", function(bod)
        file.Write("sweepem/" .. id .. ".png", bod)
        imgs[id] = Material("../data/sweepem/" .. id .. ".png")
    end )

    return err
end