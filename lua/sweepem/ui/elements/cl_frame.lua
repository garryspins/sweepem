
local grad = Material("vgui/gradient-r")
local PANEL = {}

function PANEL:Init()
    self:DockPadding(5, 5, 5, 5)

    self.topbar = vgui.Create("DPanel", self)
    self.topbar:Dock(TOP)
    self.topbar:SetTall(30)
    self.focus = true

    function self.topbar:Paint(w, h)
        sweepEm.DrawInsetBox(0, 0, w, h)

        surface.SetDrawColor(sweepEm.Colors.header_from)
        surface.DrawRect(3,3,w - 6,h - 6)

        surface.SetMaterial(grad)
        surface.SetDrawColor(sweepEm.Colors.header_to)
        surface.DrawTexturedRect(3,3,w - 6,h - 6)

        draw.Text({
            text = "sweepEm",
            pos = {h, h / 2},
            xalign = 0,
            yalign = 1,
            font = "TargetID"
        })

        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(sweepEm.Imgur("vGk7vdC"))
        surface.DrawTexturedRect(6, 6, h - 12, h - 12)
    end

    function self.topbar:PerformLayout(w, h)
        self.close:SetPos(w - h + 6, 6)
        self.close:SetSize(h - 12, h - 12)
    end

    self.topbar.close = vgui.Create("DButton", self.topbar)
    self.topbar.close:SetText("")

    function self.topbar.close.DoClick()
        self:Remove()
    end

    function self.topbar.close:Paint(w, h)
        sweepEm.DrawBox(0, 0, w, h)

        draw.NoTexture()
        surface.SetDrawColor(0, 0, 0)
        surface.DrawTexturedRectRotated(w / 2, h / 2, w * 0.6, 2, 45)
        surface.DrawTexturedRectRotated(w / 2, h / 2, w * 0.6, 2, -45)
    end

    function self.topbar.Think(s)
        if not self.focus then
            if gui.IsGameUIVisible() then
                self:Focus(true)
                gui.HideGameUI()
            end
            return
        end

        local md = input.IsMouseDown(MOUSE_LEFT)
        local hv = self:IsHovered() or self:IsChildHovered()
        if s.draginfo and md then
            self:SetPos(
                gui.MouseX() - s.draginfo.x,
                gui.MouseY() - s.draginfo.y
            )
        elseif not md then
            s.draginfo = false
        elseif not hv then
            self:Focus(false)
        elseif hv then
            self:Focus(true)
        end
    end

    function self.topbar.OnMousePressed(s, m)
        if m ~= MOUSE_LEFT then return end
        local x,y = self:LocalCursorPos()
        s.draginfo = {
            x = x,
            y = y
        }
    end

    function self.topbar.OnMouseReleased(s, m)
        s.draginfo = false
    end
end

function PANEL:Paint(w,h)
    sweepEm.DrawBox(0, 0, w, h)
end

function PANEL:PaintOver(w, h)
    if self.focus then return end

    surface.SetDrawColor(0, 0, 0)
    surface.DrawRect(0,0,w,h)
end

function PANEL:Focus(f)
    if self.focus == f then return end
    self.focus = f

    if f then
        self:MakePopup()
        self:SetAlpha(255)
        self:SetCursor("none")
    else
        self:KillFocus()
        self:SetMouseInputEnabled(false)
        self:SetKeyboardInputEnabled(false)
        self:SetAlpha(100)
    end
end

vgui.Register("sweepEm:Frame", PANEL, "Panel")
hook.Run("sweepEm:FrameCreated")
sweepEm.FrameCreated = true

if not GAMEMODE then return end

if TEST_PANEL then
    TEST_PANEL:Remove()
end

TEST_PANEL = vgui.Create("sweepEm:Frame")
TEST_PANEL:SetSize(400, 500)
TEST_PANEL:Center()
TEST_PANEL:MakePopup()