// ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
//
// lua\Fade.lua
//
//    Created by:   Charlie Cleveland (charlie@unknownworlds.com) and
//                  Max McGuire (max@unknownworlds.com)
//
// Role: Surgical striker, harassment
//
// The Fade should be a fragile, deadly-sharp knife. Wielded properly, it's force is undeniable. But
// used clumsily or without care will only hurt the user. Make sure Fade isn't better than the Skulk 
// in every way (notably, vs. Structures). To harass, he must be able to stay out in the field
// without continually healing at base, and needs to be able to use blink often.
//
// ========= For more information, visit us at http://www.unknownworlds.com =====================

Script.Load("lua/Utility.lua")
Script.Load("lua/Weapons/Alien/SwipeBlink.lua")
Script.Load("lua/Weapons/Alien/StabBlink.lua")
Script.Load("lua/Weapons/Alien/Vortex.lua")
Script.Load("lua/Weapons/Alien/Metabolize.lua")
Script.Load("lua/Alien.lua")
Script.Load("lua/Mixins/BaseMoveMixin.lua")
Script.Load("lua/Mixins/GroundMoveMixin.lua")
Script.Load("lua/CelerityMixin.lua")
Script.Load("lua/Mixins/JumpMoveMixin.lua")
Script.Load("lua/Mixins/CrouchMoveMixin.lua")
Script.Load("lua/Mixins/CameraHolderMixin.lua")
Script.Load("lua/DissolveMixin.lua")
Script.Load("lua/TunnelUserMixin.lua")
Script.Load("lua/BabblerClingMixin.lua")
Script.Load("lua/RailgunTargetMixin.lua")
Script.Load("lua/IdleMixin.lua")

class 'Fade' (Alien)

Fade.kMapName = "fade"

Fade.kModelName = PrecacheAsset("models/alien/fade/fade.model")
local kViewModelName = PrecacheAsset("models/alien/fade/fade_view.model")
local kFadeAnimationGraph = PrecacheAsset("models/alien/fade/fade.animation_graph")

Shared.PrecacheSurfaceShader("models/alien/fade/fade.surface_shader")

local kViewOffsetHeight = 1.7
Fade.XZExtents = 0.4
Fade.YExtents = 1.05
Fade.kHealth = kFadeHealth
Fade.kArmor = kFadeArmor
// ~350 pounds.
local kMass = 158
local kJumpHeight = 1.4

local kFadeScanDuration = 4

local kMaxSpeed = 6.2
local kBlinkSpeed = 14
local kBlinkAcceleration = 40
local kBlinkAddAcceleration = 1
local kStabSpeed = 3

// Delay before you can blink again after a blink.
local kMinEnterEtherealTime = 0.4

local kFadeGravityMod = 1.0

if Server then
    Script.Load("lua/Fade_Server.lua")
elseif Client then    
    Script.Load("lua/Fade_Client.lua")
end

local networkVars =
{
    isScanned = "boolean",
    timeMetabolize = "private compensated time",
    
    etherealStartTime = "private time",
    etherealEndTime = "private time",
    
    // True when we're moving quickly "through the ether"
    ethereal = "boolean",
    
    landedAfterBlink = "private compensated boolean",  
    
    timeOfLastPhase = "time",
    hasEtherealGate = "boolean"
    
}

AddMixinNetworkVars(BaseMoveMixin, networkVars)
AddMixinNetworkVars(GroundMoveMixin, networkVars)
AddMixinNetworkVars(JumpMoveMixin, networkVars)
AddMixinNetworkVars(CrouchMoveMixin, networkVars)
AddMixinNetworkVars(CelerityMixin, networkVars)
AddMixinNetworkVars(CameraHolderMixin, networkVars)
AddMixinNetworkVars(DissolveMixin, networkVars)
AddMixinNetworkVars(TunnelUserMixin, networkVars)
AddMixinNetworkVars(BabblerClingMixin, networkVars)
AddMixinNetworkVars(IdleMixin, networkVars)

function Fade:OnCreate()

    InitMixin(self, BaseMoveMixin, { kGravity = Player.kGravity * kFadeGravityMod })
    InitMixin(self, GroundMoveMixin)
    InitMixin(self, JumpMoveMixin)
    InitMixin(self, CrouchMoveMixin)
    InitMixin(self, CelerityMixin)
    InitMixin(self, CameraHolderMixin, { kFov = kFadeFov })
    
    Alien.OnCreate(self)
    
    InitMixin(self, DissolveMixin)
    InitMixin(self, TunnelUserMixin)
    InitMixin(self, BabblerClingMixin)
    
    if Client then
        InitMixin(self, RailgunTargetMixin)
    end
    
    if Server then
    
        self.timeLastScan = 0
        self.isBlinking = false
        self.timeMetabolize = 0
        
    end
    
    self.etherealStartTime = 0
    self.etherealEndTime = 0
    self.ethereal = false
    self.landedAfterBlink = true
    
end

function Fade:OnInitialized()

    Alien.OnInitialized(self)
    
    self:SetModel(Fade.kModelName, kFadeAnimationGraph)
    
    if Client then
    
        self.blinkDissolve = 0
        
        self:AddHelpWidget("GUIFadeBlinkHelp", 2)
        self:AddHelpWidget("GUITunnelEntranceHelp", 1)
        
    end
    
    InitMixin(self, IdleMixin)
    
end

function Fade:GetShowElectrifyEffect()
    return self.hasEtherealGate or self.electrified
end

function Fade:ModifyJump(input, velocity, jumpVelocity)
    jumpVelocity:Scale(kFadeGravityMod)
end

function Fade:OnDestroy()

    Alien.OnDestroy(self)
    
    if Client then
        self:DestroyTrailCinematic()
    end
    
end

function Fade:GetControllerPhysicsGroup()

    if self.isHallucination then
        return PhysicsGroup.SmallStructuresGroup
    end

    return PhysicsGroup.BigPlayerControllersGroup  
  
end

function Fade:GetInfestationBonus()
    return kFadeInfestationSpeedBonus
end

function Fade:GetCarapaceSpeedReduction()
    return kFadeCarapaceSpeedReduction
end

function Fade:MovementModifierChanged(newMovementModifierState, input)

    if newMovementModifierState then
		//Just for Rantology
		local weaponMapName = self:GetActiveWeapon():GetMapName()
		local metabweapon = self:GetWeapon(Metabolize.kMapName)
		if metabweapon and not metabweapon:GetHasAttackDelay() then
			self:SetActiveWeapon(Metabolize.kMapName)
			self:PrimaryAttack()
			if weaponMapName ~= Metabolize.kMapName then
				metabweapon:SetAttackedFromShift(weaponMapName)
			end
		end
    end
    
end

function Fade:ModifyCrouchAnimation(crouchAmount)    
    return Clamp(crouchAmount * (1 - ( (self:GetVelocityLength() - kMaxSpeed) / (kMaxSpeed * 0.5))), 0, 1)
end

function Fade:GetHeadAttachpointName()
    return "fade_tongue2"
end

// Prevents reseting of celerity.
function Fade:OnSecondaryAttack()
end

function Fade:GetBaseArmor()
    return Fade.kArmor
end

function Fade:GetBaseHealth()
    return Fade.kHealth
end

function Fade:GetHealthPerBioMass()
    return kFadeHealthPerBioMass
end

function Fade:GetArmorFullyUpgradedAmount()
    return kFadeArmorFullyUpgradedAmount
end

function Fade:GetMaxViewOffsetHeight()
    return kViewOffsetHeight
end

function Fade:GetViewModelName()
    return kViewModelName
end

function Fade:GetCanStep()
    return not self:GetIsBlinking()
end

function Fade:ModifyGravityForce(gravityTable)

    if self:GetIsBlinking() or self:GetIsOnGround() then
        gravityTable.gravity = 0
    end

end

function Fade:GetPerformsVerticalMove()
    return self:GetIsBlinking()
end

function Fade:GetAcceleration()
    return 11
end

function Fade:GetGroundFriction()
    return 9
end  

function Fade:GetAirControl()
    return 40
end   

function Fade:GetAirFriction()
    return self:GetIsBlinking() and 0 or kFadeAirFriction
end 

function Fade:ModifyVelocity(input, velocity, deltaTime)

    if self:GetIsBlinking() then
    
        local wishDir = self:GetViewCoords().zAxis
        local maxSpeedTable = { maxSpeed = kBlinkSpeed }
        self:ModifyMaxSpeed(maxSpeedTable, input)  
        local prevSpeed = velocity:GetLength()
        local maxSpeed = math.max(prevSpeed, maxSpeedTable.maxSpeed)
        local maxSpeed = math.min(25, maxSpeed)    
        
        velocity:Add(wishDir * kBlinkAcceleration * deltaTime)
        
        if velocity:GetLength() > maxSpeed then

            velocity:Normalize()
            velocity:Scale(maxSpeed)
            
        end 
        
        // additional acceleration when holding down blink to exceed max speed
        velocity:Add(wishDir * kBlinkAddAcceleration * deltaTime)
        
    end

end

local function GetIsStabbing(self)

    local stabWeapon = self:GetWeapon(StabBlink.kMapName)
    return stabWeapon ~= nil and stabWeapon:GetIsStabbing()    

end

function Fade:GetCanJump()
    return self:GetIsOnGround() and not self:GetIsBlinking() and not GetIsStabbing(self)
end

function Fade:GetIsShadowStepping()
    return false
end

function Fade:GetMaxSpeed(possible)

    if possible then
        return kMaxSpeed
    end
    
    if self:GetIsBlinking() then
        return kBlinkSpeed
    elseif GetIsStabbing(self) then
        return kStabSpeed
    end
    
    // Take into account crouching.
    return kMaxSpeed
    
end

function Fade:GetMass()
    return kMass
end

function Fade:GetJumpHeight()
    return kJumpHeight
end

function Fade:GetIsBlinking()
    return self.ethereal and self:GetIsAlive()
end

function Fade:GetRecentlyBlinked(player)
    return Shared.GetTime() - self.etherealEndTime < kMinEnterEtherealTime
end

function Fade:GetHasShadowStepAbility()
    return false
end

function Fade:GetMetabolized()
    return self.timeMetabolize + 0.1 > Shared.GetTime()
end

function Fade:GetHasMetabolizeCooldown()
    return self.timeMetabolize + kMetabolizeDelay > Shared.GetTime()
end

function Fade:GetMovementSpecialTechId()
    return kTechId.MetabolizeEnergy
end

function Fade:GetCanMetabolizeHealth()
    return self:GetHasTwoHives()
end

function Fade:GetHasMovementSpecial()
    return self:GetHasOneHive() or self:GetTeamNumber() == kTeamReadyRoom
end

function Fade:GetMovementSpecialEnergyCost()
	local metabweapon = self:GetWeapon(Metabolize.kMapName)
	if metabweapon and metabweapon:GetHasAttackDelay() then
		return 101
	end
    return kMetabolizeEnergyCost
end

function Fade:GetCollisionSlowdownFraction()
    return 0.05
end

function Fade:OverrideInput(input)

    Alien.OverrideInput(self, input)
    
    if self:GetIsBlinking() then
    
        input.move.z = 1
        input.move.x = 0
        
    end
    
    return input
    
end

function Fade:OnProcessMove(input)

    Alien.OnProcessMove(self, input)
    
    if Server then
    
        if self.isScanned and self.timeLastScan + kFadeScanDuration < Shared.GetTime() then
            self.isScanned = false
        end

    end
    
end

function Fade:GetBlinkAllowed()

    local weapons = self:GetWeapons()
    for i = 1, #weapons do
    
        if not weapons[i]:GetBlinkAllowed() then
            return false
        end
        
    end

    return true

end

function Fade:OnScan()

    if Server then
    
        self.timeLastScan = Shared.GetTime()
        self.isScanned = true
        
    end
    
end

function Fade:GetStepHeight()

    if self:GetIsBlinking() then
        return 2
    end
    
    return Player.GetStepHeight()
    
end

function Fade:SetDetected(state)

    if Server then
    
        if state then
        
            self.timeLastScan = Shared.GetTime()
            self.isScanned = true
            
        else
            self.isScanned = false
        end
        
    end
    
end

function Fade:OnUpdateAnimationInput(modelMixin)

    Alien.OnUpdateAnimationInput(self, modelMixin)

    if self.timeOfLastPhase + 0.5 > Shared.GetTime() then
        modelMixin:SetAnimationInput("move", "teleport")
    end

end

function Fade:TriggerBlink()
    self.ethereal = true
    self.landedAfterBlink = false
end

function Fade:OnBlinkEnd()
    self.ethereal = false
end

/*
function Fade:ModifyAttackSpeed(attackSpeedTable)
    attackSpeedTable.attackSpeed = attackSpeedTable.attackSpeed * 1.06
end
*/
function Fade:GetEngagementPointOverride()
    return self:GetOrigin() + Vector(0, 0.8, 0)
end

/*
function Fade:ModifyHeal(healTable)
    Alien.ModifyHeal(self, healTable)
    healTable.health = healTable.health * 1.7
end
*/

function Fade:OverrideVelocityGoal(velocityGoal)
    
    if not self:GetIsOnGround() and self:GetCrouching() then
        velocityGoal:Scale(0)
    end
    
end
/*
function Fade:HandleButtons(input)

    Alien.HandleButtons(self, input)
    
    if self:GetIsBlinking() then 
        input.commands = bit.bor(input.commands, Move.Crouch)    
    end

end
*/
function Fade:OnGroundChanged(onGround, impactForce, normal, velocity)

    Alien.OnGroundChanged(self, onGround, impactForce, normal, velocity)

    if onGround then
        self.landedAfterBlink = true
    end
    
end

Shared.LinkClassToMap("Fade", Fade.kMapName, networkVars, true)