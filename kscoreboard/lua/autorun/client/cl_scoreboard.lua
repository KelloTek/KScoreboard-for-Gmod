surface.CreateFont("DefaultScoreboard", {
    font = "Arial",
    size = ScrH() * 0.027,
    weight = 500,
    antialiasing = true
})

surface.CreateFont("TitleScoreboard", {
    font = "Arial",
    size = ScrH() * 0.05,
    weight = 500,
    antialiasing = true
})

surface.CreateFont("NormalScoreboard", {
    font = "Arial",
    size = ScrH() * 0.02,
    weight = 500,
    antialiasing = true
})

local frame
local playerPanel

local playerCount
local playerConnected = player.GetAll()

local function Scoreboard()
    frame = vgui.Create("DFrame")
    frame:SetSize(ScrW() * 1, ScrH() * 1)
    frame:SetTitle("")
    frame:Center()
    frame:MakePopup()
    frame:ShowCloseButton(false)
    frame:SetDraggable(false)

    local maxPlayers = game.MaxPlayers()

    local scroll = vgui.Create("DScrollPanel", frame)
    scroll:SetPos(ScrW() * 0.2, frame:GetTall() * 0.2)
    scroll:SetSize(frame:GetWide(), frame:GetTall() * 0.69)

    local y = 0

    for k, v in pairs(playerConnected) do
        local name = v:Name()
        local job = v:getDarkRPVar("job")
        local rank = v:GetUserGroup()
        local ping = v:Ping()

        playerCount = table.Count(player.GetAll())

        playerPanel = vgui.Create("DPanel", scroll)
        playerPanel:SetPos(0, y)
        playerPanel:SetSize(frame:GetWide() * 1, frame:GetTall() * 0.82)

        local logo = vgui.Create("DImage", frame)
        logo:SetSize(300, 200)
        logo:SetPos(ScrW() * 0.42, ScrH() * 0.004)
        logo:SetImage("kscoreboard/logo.png")

        local pingImage = vgui.Create("DImage", playerPanel)
        pingImage:SetSize(36, 36)
        pingImage:SetPos(ScrW() * 0.55, ScrH() * 0.009)
        pingImage:SetImage("kscoreboard/ping.png")

        local playersImage = vgui.Create("DImage", frame)
        playersImage:SetSize(40, 40)
        playersImage:SetPos(ScrW() * 0.7, ScrH() * 0.035)
        playersImage:SetImage("kscoreboard/players.png")

        local timeImage = vgui.Create("DImage", frame)
        timeImage:SetSize(40, 40)
        timeImage:SetPos(ScrW() * 0.7, ScrH() * 0.08)
        timeImage:SetImage("kscoreboard/time.png")

        local button = vgui.Create("DButton", playerPanel)
        button:SetSize(ScrW() * 0.6, ScrH() * 0.05)
        button:SetPos(ScrW() * 0, ScrH() * 0)
        button:SetText("")
        button:SetFont("NormalScoreboard")
        button:SetTextColor(Color(255, 255, 255, 255))

        function button:Paint(w, h)
            surface.SetDrawColor(Color(255, 255, 255, 0))
        end

        button.DoClick = function()
            SetClipboardText(v:SteamID())
        end

        if rank == "user" then
            rank = ""
        end

        function playerPanel.Paint(w, h)
            surface.SetDrawColor(27, 27, 29, 255)
            surface.DrawRect(ScrW() * 0, ScrH() * 0, ScrW() * 0.6, ScrH() * 0.05)
            draw.RoundedBox(0, ScrW() * 0.003, ScrH() * 0.005, ScrW() * 0.002, ScrH() * 0.041, team.GetColor(v:Team()))
            draw.SimpleText(name, "NormalScoreboard", ScrW() * 0.035, ScrH() * 0.015, Color(255, 255, 255, 255))
            draw.SimpleText(job, "NormalScoreboard", ScrW() * 0.3, ScrH() * 0.015, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
            draw.SimpleText(rank, "NormalScoreboard", ScrW() * 0.45, ScrH() * 0.015, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
            draw.SimpleText(ping, "NormalScoreboard", ScrW() * 0.57, ScrH() * 0.015, Color(255, 255, 255, 255))
        end

        local avatar = vgui.Create("AvatarImage", playerPanel)
        avatar:SetSize(42, 42)
        avatar:SetPos(playerPanel:GetWide() * 0.007, playerPanel:GetTall() * 0.0068)
        avatar:SetPlayer(v, 64)

        y = y + playerPanel:GetTall() * 0.065
    end

    function frame:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
        draw.SimpleText(playerCount.. " / " ..maxPlayers, "DefaultScoreboard", ScrW() * 0.73, ScrH() * 0.04, Color(255, 255, 255, 255))
        draw.SimpleText(os.date("%H:%M"), "DefaultScoreboard", ScrW() * 0.73, ScrH() * 0.085, Color(255, 255, 255, 255))
    end
end

hook.Add("ScoreboardShow", "ScoreboardOpen", function()
    Scoreboard()
    return false
end)

hook.Add("ScoreboardHide", "ScoreboardClose", function()
    frame:Remove()
    return false
end)