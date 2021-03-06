// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Server\PhaseGateAdjustments.lua
// - Dragon

local oldPhaseGateUpdate = PhaseGate.Update
function PhaseGate:Update()
	self.phasepossible = (self.timeOfLastPhase == nil) or (Shared.GetTime() > (self.timeOfLastPhase + kPhaseGateDepartureRate))
	return oldPhaseGateUpdate(self)
end

function PhaseGateUserMixin:OnUpdate(deltaTime)
end