
surface.CreateFont("sweepEm:Top_Sides", {
    font = "Courier New",
    size = 24,
    weight = 900,
    outline  = true
})

local PANEL = {}

function PANEL:Init()
    self.gameinfo = {
        sizex = 30,
        sizey = 16,
        mines = 99,
        started = CurTime(),
        minesfound = 0
    }

    self.top = vgui.Create("DPanel", self)
    self.top:Dock(TOP)
    self.top:DockMargin(0, 3, 0, 0)
    self.top:SetTall(60)

    function self.top.Paint(s, w, h)
        sweepEm.DrawInsetBox(0, 0, w, h)

        local l = math.floor(math.min(CurTime() - self.gameinfo.started, 999))
        draw.Text({
            text = ("000"):sub(1, 3 - (#tostring(l))) .. l,
            pos = {w - h / 4, h / 2},
            font = "sweepEm:Top_Sides",
            xalign = 2,
            yalign = 1
        })

        local m = math.floor(math.min(self.gameinfo.mines - self.gameinfo.minesfound, 999))
        draw.Text({
            text = ("000"):sub(1, 3 - (#tostring(m))) .. m,
            pos = {h / 4, h / 2},
            font = "sweepEm:Top_Sides",
            yalign = 1
        })
    end

    function self.top:PerformLayout(w, h)
        self.btn:SetSize(h - 20, h - 20)
        self.btn:Center()
    end

    self.top.btn = vgui.Create("DButton", self.top)

    self.sweep = vgui.Create("sweepEm:Sweep", self)
end

function PANEL:PerformLayout(w, h)
    local ww,hh = self.sweep:GetSize()
    self:SetWide(ww + 9)
    self:SetTall(hh + self.top:GetTall() + self.topbar:GetTall() + 12)
    self.sweep:SetPos(5, h - self.sweep:GetTall() - 3)

    self:Center()
end

if sweepEm.FrameCreated then
    vgui.Register("sweepEm:Game", PANEL, "sweepEm:Frame")
else
    hook.Add("sweepEm:FrameCreated", "GameRegister", function()
        vgui.Register("sweepEm:Game", PANEL, "sweepEm:Frame")
    end )
end

local grad = Material("vgui/gradient-r")
hook.Add("ContextMenuOpened", "sweepEm:SetPaint", function()
    print(123)
    if not g_ContextMenu then hook.Remove("ContextMenuOpened", "sweepEm:SetPaint") print("nope") return end

    print("Adding")
    local lo = g_ContextMenu:GetChildren()[2]

    local icon = vgui.Create("DButton", lo)
    icon:SetText("")
    icon:SetSize(80, 80)

    function icon:Paint(w, h)
        surface.SetDrawColor(sweepEm.Colors.header_from)
        surface.DrawRect(6, 6, w - 12, h - 12)

        surface.SetDrawColor(sweepEm.Colors.header_to)
        surface.SetMaterial(grad)
        surface.DrawTexturedRectRotated(w / 2, h / 2, w * 2, h * 2, 30)

        if self:IsHovered() then
            -- sweepEm.DrawBorder(0, 0, w, h)
            -- sweepEm.DrawInsetBorder(3, 3, w - 6, h - 6)
        else
            -- sweepEm.DrawInsetBorder(0, 0, w, h)
            -- sweepEm.DrawBorder(3, 3, w - 6, h - 6)
        end

        surface.SetDrawColor(255, 255, 255, 100)
        surface.SetMaterial(sweepEm.Imgur("vGk7vdC"))
        surface.DrawTexturedRect(14, 14, w - 24, h - 24)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawTexturedRect(12, 12, w - 24, h - 24)
    end

    hook.Remove("ContextMenuOpened", "sweepEm:SetPaint")
end )

-- if 1 then return end
if not GAMEMODE then return end

if TEST_PANEL then
    TEST_PANEL:Remove()
end

TEST_PANEL = vgui.Create("sweepEm:Game")
TEST_PANEL:SetSize(500, 500)
TEST_PANEL:Center()
TEST_PANEL:MakePopup()