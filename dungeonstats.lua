local enabled = true
local elites = true
local maxstat = 10
local Q = nil
local command = "ds"

local DSSQL = [[ CREATE TABLE IF NOT EXISTS Dungeon_Stats ( `CharID` int(10) unsigned, `Strength` int(10) unsigned, `Agility` int(10) unsigned, `Stamina` int(10) unsigned, `Intellect` int(10) unsigned, `Spirit` int(10) unsigned NOT NULL DEFAULT 1) ENGINE=InnoDB DEFAULT CHARSET=utf8;]]
WorldDBExecute(DSSQL)


local function getPlayerCharacterGUID(player)
	if player ~= nil then
    query = CharDBQuery(string.format("SELECT guid FROM characters WHERE name='%s'", player:GetName()))
	end

    if query then 
      local row = query:GetRow()

      return tonumber(row["guid"])
    end

    return nil
  end
  
 local function updatestat(player, stat, value)
player:HandleStatModifier( stat, 2, value, true )

end
  
local function SKULY(eventid, delay, repeats, player)
    local PUID = getPlayerCharacterGUID(player)
	if PUID ~= nil then
	Q = WorldDBQuery(string.format("SELECT * FROM Dungeon_Stats WHERE CharID=%i", PUID))
	end
	
	if Q then
	local CharID, Strength, Agility, Stamina, Intellect, Spirit = Q:GetUInt32(0), Q:GetUInt32(1), Q:GetUInt32(2), Q:GetUInt32(3), Q:GetUInt32(4), Q:GetUInt32(5)
		player:SendBroadcastMessage(string.format("|cff5af304Dungeon Stat Totals: Str("..Strength..") Agility("..Agility..") Stam("..Stamina..") Int("..Intellect..") Spirit("..Spirit..")|r"))
		player:HandleStatModifier( 0, 2, Strength, true )
		player:HandleStatModifier( 1, 2, Agility, true )
		player:HandleStatModifier( 2, 2, Stamina, true )
		player:HandleStatModifier( 3, 2, Intellect, true )
		player:HandleStatModifier( 4, 2, Spirit, true )
		
	return false
	else 
	WorldDBExecute(string.format("DELETE FROM Dungeon_Stats WHERE CharID = %i", PUID))
	WorldDBExecute(string.format("INSERT INTO Dungeon_Stats VALUES (%i, 0, 0, 0, 0, 0)", PUID))
	return false
	end
end

local function OnLogin(event, player)

player:RegisterEvent(SKULY, 5000, 1, player)
	
end 

local function BossKilled (event, killer, killed)
local r = math.random(1,maxstat)
local randomstatval = 0
local statval = nil
local myTable = { 'Strength', 'Agility', 'Stamina', 'Intellect', 'Spirit' }
local randomstat = myTable[ math.random( #myTable ) ]
local PUID = getPlayerCharacterGUID(killer)
	--if (killed:IsWorldBoss() == true) or (elites == true and killed:IsElite() == true) then 
		if PUID ~= nil then
		Q = WorldDBQuery(string.format("SELECT * FROM Dungeon_Stats WHERE CharID=%i", PUID))
		if Q then
			local CharID, Strength, Agility, Stamina, Intellect, Spirit = Q:GetUInt32(0), Q:GetUInt32(1), Q:GetUInt32(2), Q:GetUInt32(3), Q:GetUInt32(4), Q:GetUInt32(5)
			
			if randomstat == "Strength" then
				randomstatval = Strength
				statval = 0
				elseif randomstat == "Agility" then
					randomstatval = Agility
					statval = 1
				elseif randomstat == "Stamina" then
					randomstatval = Stamina
					statval = 2
				elseif randomstat == "Intellect" then
					randomstatval = Intellect
					statval = 3
				elseif randomstat == "Spirit" then
					randomstatval = Spirit
					statval = 4
			end
			
			WorldDBExecute(string.format("UPDATE Dungeon_Stats SET "..randomstat.."=%i WHERE CharID=%i", randomstatval + r, PUID))
			--killer:HandleStatModifier( statval, 2, randomstatval, false )
			killer:SendBroadcastMessage("|cffe9b518You recived".."|r |cff5af304"..r.."|r |cffe9b518"..randomstat.." for killing "..killed:GetName().."|r")
			updatestat(killer, statval, r )
			end
		end
	--end
end

local function Hello(event, player)
player:GossipClearMenu()
	player:GossipMenuAddItem(0, "View Dungeon Stats", 0, 1)
	player:GossipMenuAddItem(0, "Reset Dungeon Stats", 0, 2, false, "Dungeon Stats will be Reset!")
	
	player:GossipSendMenu(1, player, 1979)
end

local function OnSelect(event, player, _, sender, intid, code)
player:GossipClearMenu()

if(intid== 1) then
local PUID = getPlayerCharacterGUID(player)
	if PUID ~= nil then
	Q = WorldDBQuery(string.format("SELECT * FROM Dungeon_Stats WHERE CharID=%i", PUID))
	end
	
	if Q then
	local CharID, Strength, Agility, Stamina, Intellect, Spirit = Q:GetUInt32(0), Q:GetUInt32(1), Q:GetUInt32(2), Q:GetUInt32(3), Q:GetUInt32(4), Q:GetUInt32(5)
		player:SendBroadcastMessage(string.format("|cff5af304Dungeon Stat Totals: Str("..Strength..") Agility("..Agility..") Stam("..Stamina..") Int("..Intellect..") Spirit("..Spirit..")|r"))
		Hello(event, player)
	return false
	end
	
end

if(intid== 2) then
local PUID = getPlayerCharacterGUID(player)
	if PUID ~= nil then
	Q = WorldDBQuery(string.format("SELECT * FROM Dungeon_Stats WHERE CharID=%i", PUID))
	if Q then
	local CharID, Strength, Agility, Stamina, Intellect, Spirit = Q:GetUInt32(0), Q:GetUInt32(1), Q:GetUInt32(2), Q:GetUInt32(3), Q:GetUInt32(4), Q:GetUInt32(5)
	player:HandleStatModifier( 0, 2, Strength, false )
	player:HandleStatModifier( 1, 2, Agility, false )
	player:HandleStatModifier( 2, 2, Stamina, false )
	player:HandleStatModifier( 3, 2, Intellect, false )
	player:HandleStatModifier( 4, 2, Spirit, false )
	
	WorldDBExecute(string.format("UPDATE Dungeon_Stats SET Strength=0 WHERE CharID=%i", PUID))
	WorldDBExecute(string.format("UPDATE Dungeon_Stats SET Agility=0 WHERE CharID=%i", PUID))
	WorldDBExecute(string.format("UPDATE Dungeon_Stats SET Stamina=0 WHERE CharID=%i", PUID))
	WorldDBExecute(string.format("UPDATE Dungeon_Stats SET Intellect=0 WHERE CharID=%i", PUID))
	WorldDBExecute(string.format("UPDATE Dungeon_Stats SET Spirit=0 WHERE CharID=%i", PUID))
	end


	Hello(event, player)
	end
end

end

local function PlrMenu(event, player, message)
	
	if (message:lower() == command) then
		Hello(event, player)
		return false
	end
end

if enabled then
RegisterPlayerEvent(42, PlrMenu)
RegisterPlayerEvent(3, OnLogin)
RegisterPlayerEvent(7, BossKilled)
RegisterPlayerGossipEvent(1979, 2, OnSelect)
end