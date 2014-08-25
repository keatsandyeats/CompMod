//Dont want to always replace random files, so this.

function PulseGrenade:OnUpdate(deltaTime)
    
	PredictedProjectile.OnUpdate(self, deltaTime)

	for _, enemy in ipairs( GetEntitiesForTeamWithinRange("Alien", GetEnemyTeamNumber(self:GetTeamNumber()), self:GetOrigin(), kPulseGrenadeAutoDetonateRange) ) do
	
		if enemy:GetIsAlive() then
			self:Detonate()
			break
		end
	
	end

end

local function IgniteNearbyPlayers(self, range)
	local hitEntities = GetEntitiesWithMixinWithinRange("Fire", self:GetOrigin(), range)
	local player = self:GetOwner()
    table.removevalue(hitEntities, self)
	if player then
		for _, hitEnt in ipairs(hitEntities) do
			hitEnt:SetOnFire(player, self)
		end
	end
end

local oldClusterGrenadeDetonate = ClusterGrenade.Detonate
function ClusterGrenade:Detonate(targetHit)
	IgniteNearbyPlayers(self, kClusterGrenadeDamageRadius)
	oldClusterGrenadeDetonate(self, targetHit)
end