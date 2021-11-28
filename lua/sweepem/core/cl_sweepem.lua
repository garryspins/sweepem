
sweepEm.CurrentGame = false
sweepEm.NumberIcons = {
    [1] = "G7CygSw",
    [2] = "Ukenffw",
    [3] = "czKEg8u",
    [4] = "9w3f9rl",
    [5] = "cqShFYS",
    [6] = "pztvcfO",
    [7] = "8V5HTWR",
    [8] = "zoRzb0H"
}

local size = 23
local PANEL = {}

function PANEL:Init()
    self:SetMap(9, 9, 10)
end

function PANEL:SetMap(x, y, mines)
    self.opened = {}
    self.sizex = x
    self.sizey = y

    self:SetSize(x * size + 6, y * size + 6)

    self.map = sweepEm.Generate(x, y, mines)
end

function PANEL:Paint(w, h)
    sweepEm.DrawInsetBox(0, 0, w, h)
    local xx,yy = self:LocalCursorPos()
    local o = self.opened

    for x = 0, self.sizex - 1 do
        for y = 0, self.sizey - 1 do
            local bx, by = 3 + x * size, 3 + y * size

            if o[x] and o[x][y] then
                surface.SetDrawColor(sweepEm.Colors.dark)
                if x ~= self.sizex - 1 then
                    surface.DrawRect(bx + size, by, 1, size)
                end
                if y ~= self.sizey - 1 then
                    surface.DrawRect(bx, by + size, size, 1)
                end

                if o[x][y] == 0 then
                    continue
                end

                surface.SetDrawColor(255, 255, 255)
                if o[x][y] == "mine" then
                    surface.SetMaterial(sweepEm.Imgur("vGk7vdC"))
                    surface.DrawTexturedRect(bx + 2, by + 2, size - 4, size - 4)
                elseif o[x][y] == "marked_mine" then
                    sweepEm.DrawBox(bx, by, size, size)
                    surface.SetDrawColor(255, 255, 255)
                    surface.SetMaterial(sweepEm.Imgur("ji6tDx8"))
                    surface.DrawTexturedRect(bx + 2, by + 2, size - 4, size - 4)
                else
                    surface.SetMaterial(sweepEm.Imgur(sweepEm.NumberIcons[o[x][y]]))
                    surface.DrawTexturedRect(bx + 2, by + 2, size - 4, size - 4)
                end
            else
                sweepEm.DrawBox(bx, by, size, size)
            end

            if (xx >= bx and xx <= bx + size) and (yy >= by and yy <= by + size) then
                self.hovering = {x, y}
            end
        end
    end
end

function PANEL:OnMousePressed(m)
    if not self.hovering then return end

    if input.IsMouseDown(MOUSE_LEFT) and input.IsMouseDown(MOUSE_RIGHT) then
        self:Chord(self.hovering[1], self.hovering[2])
        return
    end

    if m == MOUSE_LEFT then
        self:CalculateOpen(self.hovering[1], self.hovering[2])
    elseif m == MOUSE_RIGHT then
        self:Mark(self.hovering[1], self.hovering[2])
    end
end

function PANEL:Mark(x, y)
    local o = self.opened
    o[x] = o[x] or {}

    self.marked_mines = self.marked_mines or 0

    if o[x][y] == "marked_mine" then
        o[x][y] = false
        self.marked_mines = self.marked_mines - 1
    elseif not o[x][y] then
        o[x][y] = "marked_mine"
        self.marked_mines = self.marked_mines + 1
    end
end

function PANEL:CalculateOpen(x, y, from_empty)
    if not self.map then
        return
    end
    local mapx = self.map[x + 1]
    local mapy = (self.map[x + 1] or {})[y + 1]

    if not mapx or not mapy then return end

    local o = self.opened

    o[x] = o[x] or {}

    if o[x][y] then
        return
    end

    o[x][y] = mapy
    if mapy == 0 then
        self:CalculateOpen(x - 1,   y - 1,      true)
        self:CalculateOpen(x,       y - 1,      true)
        self:CalculateOpen(x + 1,   y - 1,      true)
        self:CalculateOpen(x - 1,   y + 1,      true)
        self:CalculateOpen(x,       y + 1,      true)
        self:CalculateOpen(x + 1,   y + 1,      true)
        self:CalculateOpen(x + 1,   y,          true)
        self:CalculateOpen(x - 1,   y,          true)
    elseif mapy == "mine" then
        if from_empty then
            return
        end
        chat.AddText("Failed!")
    else

    end
end

vgui.Register("sweepEm:Sweep", PANEL, "DPanel")

if not GAMEMODE then return end

if TEST_PANEL then
    TEST_PANEL:Remove()
end

TEST_PANEL = vgui.Create("sweepEm:Game")
TEST_PANEL:SetSize(500, 500)
TEST_PANEL:Center()
TEST_PANEL:CenterHorizontal()
TEST_PANEL:MakePopup()