
sweepEm = sweepEm or {}
sweepEm.Colors = {
    light = Color(255, 255, 255),
    dark = Color(123, 123, 123),
    mid = Color(189, 189, 189),

    header_from = Color(9, 33, 123),
    header_to = Color(96, 117, 194),

    numbers = {
        [1] = Color(0, 0, 255),
        [2] = Color(0, 123, 0),
        [3] = Color(255, 0, 0),
        [4] = Color(0, 0, 123),
        [5] = Color(123, 0, 0),
        [6] = Color(0, 123, 123),
        [7] = Color(0, 0, 0),
        [8] = Color(123, 123, 123)
    }
}

local function loadDirectory(dir)
    local fil, fol = file.Find(dir .. "/*", "LUA")

    for k,v in ipairs(fil) do
        local dirs = dir .. "/" .. v

        if v:StartWith("cl_") then
            if SERVER then AddCSLuaFile(dirs)
            else include(dirs) end
        elseif v:StartWith("sh_") then
            AddCSLuaFile(dirs)
            include(dirs)
        else
            if SERVER then include(dirs) end
        end
    end

    for k,v in pairs(fol) do
        loadDirectory(dir .. "/" .. v)
    end
end

loadDirectory("sweepem")
