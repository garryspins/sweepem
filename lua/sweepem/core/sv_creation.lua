
util.AddNetworkString("sweepem_create")
util.AddNetworkString("sweepem_error")
util.AddNetworkString("sweepem_click")
util.AddNetworkString("sweepem_request")

sweepEm.ActiveGames = sweepEm.ActiveGames or {}

net.Receive("sweepem_create", function(_, ply)
    if sweepEm.ActiveGames[ply:SteamID64()] then
        net.Start("sweepem_error")
        net.WriteString("Already Playing")
        net.Send(ply)
    end

    local sizex = net.ReadInt(16)
    local sizey = net.ReadInt(16)
    local mines = net.ReadInt(16)

    local posx = net.ReadInt(16)
    local posy = net.ReadInt(16)

    if not sweepEm.ValidBoard(sizex, sizey, mines) then
        net.Start("sweepem_error")
        net.WriteString("Invalid Board")
        net.Send(ply)
    end

    if posx > sizex or posy > sizey then
        net.Start("sweepem_error")
        net.WriteString("Bad Click Pos, Stop Cheating")
        net.Send(ply)
    end

    local final_board = false
    local iter = 0
    while true do
        if iter >= 4 then
            ErrorNoHaltWithStack("[Stack Overflow][1] If you see this make a ticket please")

            net.Start("sweepem_error")
            net.WriteString("Youre extremely unlucky")
            net.Send(ply)
            break
        end
        iter = iter + 1

        local board = sweepEm.Generate(sizex, sizey, mines)

        if board[posx][posy] ~= "bomb" then
            final_board = board
            break
        end
    end

    sweepEm.ActiveGames[ply:SteamID64()] = {
        board = final_board,
        opened = {}
    }

    net.Start("sweepem_create")
    net.Send(ply)
end )

net.Receive("sweepem_request", function(_, ply)
    if sweepEm.ActiveGames[ply:SteamID64()] then
        net.Start("sweepem_request")
        net.WriteBool(true)
        net.WriteTable(sweepEm.ActiveGames[ply:SteamID64()].opened)
        net.Send(ply)
    else
        net.Start("sweepem_request")
        net.WriteBool(false)
        net.Send(ply)
    end
end )