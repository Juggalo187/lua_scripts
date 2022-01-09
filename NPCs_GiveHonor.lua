local enabled = false -- Enable or Disable this Script.
------------------
local minlevel = 1 --Player must be at least this level to get rewards.
------------------
local guards = true -- Give when Player kills Guard.
local elite = true -- Give when Player kills Elite. (this does not apply on rare mob, unless he is also elite)
local boss = true -- Give when Player kills Dungeon Boss.
------------------
local honor = true -- Give Honor Points
local hammount = 100 -- How much Honor
------------------
local arena = true -- Give Arena Points
local aammount = 100 -- How much Arena Points
------------------
local money = true -- Give Gold
local mammount = 10 -- How much gold
------------------

function OnKill(event, player, creature)
local level = player:GetLevel()
local gold = 10000 * mammount
local entry = creature:GetEntry()

if level >= minlevel then
	if (creature:IsGuard() and guards) or (creature:IsDungeonBoss() and boss) or (creature:IsElite() and elite) then

		if honor then
		player:ModifyHonorPoints( hammount )
		player:SendBroadcastMessage("|cff5af304You received "..hammount.." Honor.|r")
		end
		
		if arena then
		player:ModifyArenaPoints( aammount )
		player:SendBroadcastMessage("|cff5af304You received "..aammount.." Arena Points.|r")
		end
		
		if money then
		player:ModifyMoney( gold  )
		player:SendBroadcastMessage("|cff5af304You received "..mammount.." Gold.|r")
		end
	end
end

end

if enabled then
RegisterPlayerEvent(7, OnKill)
end