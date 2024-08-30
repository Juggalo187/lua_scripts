local enabled = true
local allkills = true -- If True then any kill will give random stat
local minmoblevel = 1
local elites = true
local dungeonbosses = true
local worldbosses = true
local guards = true
local minstat = 1
local maxstat = 10
local statchance = 100
local mailchance = 20
local mailitemid = {23162, 40896,40897,40899,40900,40901,40902,40903,40906,40908,40909,40912,40913,40914,40915,40916,40919,40920,40921,40922,40923,40924,41092,41094,41095,41096,41097,41098,41099,41100,41101,41102,41103,41104,41105,41106,41107,41108,41109,41110,41517,41518,41524,41526,41527,41529,41530,41531,41532,41533,41534,41535,41536,41537,41538,41539,41540,41541,41542,41547,41552,42396,42397,42398,42399,42400,42401,42402,42403,42404,42405,42406,42407,42408,42409,42410,42411,42412,42414,42415,42416,42417,42453,42454,42455,42456,42457,42458,42459,42460,42461,42462,42463,42464,42465,42466,42467,42468,42469,42470,42471,42472,42473,42734,42735,42736,42737,42738,42739,42740,42741,42742,42743,42744,42745,42746,42747,42748,42749,42750,42751,42752,42753,42754,42897,42898,42899,42900,42901,42902,42903,42904,42905,42906,42907,42908,42909,42910,42911,42912,42913,42914,42915,42916,42917,42954,42955,42956,42957,42958,42959,42960,42961,42962,42963,42964,42965,42966,42967,42968,42969,42970,42971,42972,42973,42974,43316,43331,43332,43334,43335,43338,43339,43340,43342,43343,43344,43350,43351,43354,43355,43356,43357,43359,43360,43361,43364,43365,43366,43367,43368,43369,43370,43371,43372,43373,43374,43376,43377,43378,43379,43380,43381,43385,43386,43388,43389,43390,43391,43392,43393,43394,43395,43396,43397,43398,43399,43400,43412,43413,43414,43415,43416,43417,43418,43419,43420,43421,43422,43423,43424,43425,43426,43427,43428,43429,43430,43431,43432,43533,43534,43535,43536,43537,43538,43539,43541,43542,43543,43544,43545,43546,43547,43548,43549,43550,43551,43552,43553,43554,43671,43672,43673,43674,43725,43825,43826,43827,43867,43868,43869,44684,44920,44922,44923,44928,44955,45601,45602,45603,45604,45622,45623,45625,45731,45732,45733,45734,45735,45736,45737,45738,45739,45740,45741,45742,45743,45744,45745,45746,45747,45753,45755,45756,45757,45758,45760,45761,45762,45764,45766,45767,45768,45769,45770,45771,45772,45775,45776,45777,45778,45779,45780,45781,45782,45783,45785,45789,45790,45792,45793,45794,45795,45797,45799,45800,45803,45804,45805,45806,46372,48720,49084,50045,50077,50125}
local Q = nil
local command = "ds"

local DSSQL = [[ CREATE TABLE IF NOT EXISTS Dungeon_Stats ( `CharID` int(10) unsigned, `Strength` int(10) unsigned, `Agility` int(10) unsigned, `Stamina` int(10) unsigned, `Intellect` int(10) unsigned, `Spirit` int(10) unsigned NOT NULL DEFAULT 1) ENGINE=InnoDB DEFAULT CHARSET=utf8;]]
WorldDBExecute(DSSQL)

function randomChance (player, chance)
local rand = math.random(1,100)
		if  rand <= chance then
			return true
			else
			return false
		end                                    
end

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
		player:SendBroadcastMessage(string.format("|cff5af304Dungeons Stat Totals: Str("..Strength..") Agility("..Agility..") Stam("..Stamina..") Int("..Intellect..") Spirit("..Spirit..")|r"))
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

local function HandleplayerRewarding(player, creature)
local r = math.random(minstat,maxstat)
local randomstatval = 0
local statval = nil
local myTable = { 'Strength', 'Agility', 'Stamina', 'Intellect', 'Spirit' }
local randomstat = myTable[ math.random( #myTable ) ]
local PUID = getPlayerCharacterGUID(player)

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
		player:SendBroadcastMessage("|cffe9b518You recived".."|r |cff5af304"..r.."|r |cffe9b518"..randomstat.." for killing "..creature:GetName().."|r")
		updatestat(player, statval, r )
		end
end




end


local function HandleplayerMailing(player, creature)
	player:SendBroadcastMessage("|cffe9b518You recived a reward for killing".."|r |cff5af304"..creature:GetName().."|r(You've Got Mail!)")
	local receiver = GetGUIDLow(GetPlayerByName(player:GetName()):GetGUID());
	local chosenmailitemid = mailitemid[math.random(1, #mailitemid)]
	SendMail( "Dungeon Reward", "You killed "..creature:GetName()..", here is a random reward.", tonumber(receiver), 1, 61, 1, 0, 0, chosenmailitemid, 1 )
end


local function BossKilled (event, killer, killed)
	if (allkills == true) or (worldbosses == true and killed:IsWorldBoss() == true) or (dungeonbosses == true and killed:IsDungeonBoss() == true) or (elites == true and killed:IsElite() == true) or (guards == true and killed:IsGuard() == true) and (killed:GetLevel() >= minmoblevel) then 
		if randomChance(killer, statchance) then	
			if killer:IsInGroup() then
				local group = killer:GetGroup()
				local groupPlayers = group:GetMembers()
				
				for k,v in pairs(groupPlayers) do
					HandleplayerRewarding (v, killed)
					
					if randomChance(v, mailchance) then
						HandleplayerMailing(v, killed)
					end
				end
			else
					HandleplayerRewarding (killer, killed)
					if randomChance(killer, mailchance) then
						HandleplayerMailing(killer, killed)
					end
			end
			
			
			
		end
			
	end
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
		player:SendBroadcastMessage(string.format("|cff5af304Dungeon Stats Totals: Str("..Strength..") Agility("..Agility..") Stam("..Stamina..") Int("..Intellect..") Spirit("..Spirit..")|r"))
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
	player:SendBroadcastMessage(string.format("|cff5af304Dungeon Stats Reset"))
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