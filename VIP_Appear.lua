local command = "vip appear"


local function Appear(player)
local Target = player:GetSelectedPlayer()

if not player:IsInGroup() then
player:SendBroadcastMessage("|cff5af304 You must be in a group.|r")
else
if Target == nil then
player:SendBroadcastMessage("|cff5af304 Please select a player in your group.|r")
else
if Target:IsInGroup() then

local Playergroup = player:GetGroup()
local Targetgroup = Target:GetGroup()

if (Playergroup == Targetgroup) then
local x = Target:GetX()
local y = Target:GetY()
local z = Target:GetZ()
local o = Target:GetO()
local map = Target:GetMap()
local mapID = map:GetMapId()
local areaId = map:GetAreaId( x, y, z )

player:Teleport( mapID, x, y, z, o ) 
else
player:SendBroadcastMessage("|cff5af304 The target is not a Player in your Group.|r")
end
else
player:SendBroadcastMessage("|cff5af304 The target is not a Player in your Group.|r")

end

end
end

end



local function PlrMenu(event, player, message, Type, lang)

    if (message:lower() == command) then
        local mingmrank = 3	
        if (player:GetGMRank() < mingmrank) then
        player:SendBroadcastMessage("|cff5af304Only a GM can use this command.|r")
        return false
        else
        Appear(player)
        return false
    end
    end
end

RegisterPlayerEvent(42, PlrMenu)