//Dont want to always replace random files, so this.

// Comp Mod change, alien tech tree
function AlienTeam:InitTechTree()

    PlayingTeam.InitTechTree(self)
    
    // Add special alien menus
    self.techTree:AddMenu(kTechId.MarkersMenu)
    self.techTree:AddMenu(kTechId.UpgradesMenu)
    self.techTree:AddMenu(kTechId.ShadePhantomMenu)
    self.techTree:AddMenu(kTechId.ShadePhantomStructuresMenu)
    self.techTree:AddMenu(kTechId.ShiftEcho, kTechId.ShiftHive)
    self.techTree:AddMenu(kTechId.LifeFormMenu)
    self.techTree:AddMenu(kTechId.SkulkMenu)
    self.techTree:AddMenu(kTechId.GorgeMenu)
    self.techTree:AddMenu(kTechId.LerkMenu)
    self.techTree:AddMenu(kTechId.FadeMenu)
    self.techTree:AddMenu(kTechId.OnosMenu)
    self.techTree:AddMenu(kTechId.Return)
	
    self.techTree:AddOrder(kTechId.Grow)
    self.techTree:AddAction(kTechId.FollowAlien)    
    
    self.techTree:AddPassive(kTechId.Infestation)
    self.techTree:AddPassive(kTechId.SpawnAlien)
    self.techTree:AddPassive(kTechId.CollectResources, kTechId.Harvester)
    
    // Add markers (orders)
    self.techTree:AddSpecial(kTechId.ThreatMarker, kTechId.None, kTechId.None, true)
    self.techTree:AddSpecial(kTechId.LargeThreatMarker, kTechId.None, kTechId.None, true)
    self.techTree:AddSpecial(kTechId.NeedHealingMarker, kTechId.None, kTechId.None, true)
    self.techTree:AddSpecial(kTechId.WeakMarker, kTechId.None, kTechId.None, true)
    self.techTree:AddSpecial(kTechId.ExpandingMarker, kTechId.None, kTechId.None, true)
    
    // bio mass levels (required to unlock new abilities)
    self.techTree:AddSpecial(kTechId.BioMassOne)
    self.techTree:AddSpecial(kTechId.BioMassTwo)
    self.techTree:AddSpecial(kTechId.BioMassThree)
    self.techTree:AddSpecial(kTechId.BioMassFour)
    self.techTree:AddSpecial(kTechId.BioMassFive)
    self.techTree:AddSpecial(kTechId.BioMassSix)
    self.techTree:AddSpecial(kTechId.BioMassSeven)
    self.techTree:AddSpecial(kTechId.BioMassEight)
    self.techTree:AddSpecial(kTechId.BioMassNine)
    
    // Commander abilities
    self.techTree:AddBuildNode(kTechId.Cyst)
    self.techTree:AddBuildNode(kTechId.NutrientMist)
    self.techTree:AddBuildNode(kTechId.Rupture, kTechId.BioMassTwo)
    self.techTree:AddBuildNode(kTechId.BoneWall, kTechId.BioMassThree)
    self.techTree:AddBuildNode(kTechId.Contamination, kTechId.BioMassNine)
    self.techTree:AddAction(kTechId.SelectDrifter)
    self.techTree:AddAction(kTechId.SelectHallucinations, kTechId.ShadeHive)
    self.techTree:AddAction(kTechId.SelectShift, kTechId.ShiftHive)
    
    // Drifter triggered abilities
    self.techTree:AddTargetedActivation(kTechId.EnzymeCloud,      kTechId.ShiftHive,      kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.Hallucinate,      kTechId.ShadeHive,      kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.MucousMembrane,   kTechId.CragHive,      kTechId.None)    
    //self.techTree:AddTargetedActivation(kTechId.Storm,            kTechId.ShiftHive,       kTechId.None)
    self.techTree:AddActivation(kTechId.DestroyHallucination)
    
    // Drifter passive abilities
    self.techTree:AddPassive(kTechId.DrifterCamouflage)
    self.techTree:AddPassive(kTechId.DrifterCelerity)
    self.techTree:AddPassive(kTechId.DrifterRegeneration)
           
    // Hive types
    self.techTree:AddBuildNode(kTechId.Hive,                    kTechId.None,           kTechId.None)
    self.techTree:AddPassive(kTechId.HiveHeal)
    self.techTree:AddBuildNode(kTechId.CragHive,                kTechId.Hive,                kTechId.None)
    self.techTree:AddBuildNode(kTechId.ShadeHive,               kTechId.Hive,                kTechId.None)
    self.techTree:AddBuildNode(kTechId.ShiftHive,               kTechId.Hive,                kTechId.None)
    
    self.techTree:AddTechInheritance(kTechId.Hive, kTechId.CragHive)
    self.techTree:AddTechInheritance(kTechId.Hive, kTechId.ShiftHive)
    self.techTree:AddTechInheritance(kTechId.Hive, kTechId.ShadeHive)
    
    self.techTree:AddUpgradeNode(kTechId.ResearchBioMassOne)
    self.techTree:AddUpgradeNode(kTechId.ResearchBioMassTwo)
    self.techTree:AddUpgradeNode(kTechId.ResearchBioMassThree)
    self.techTree:AddUpgradeNode(kTechId.ResearchBioMassFour)

    self.techTree:AddUpgradeNode(kTechId.UpgradeToCragHive,     kTechId.Hive,                kTechId.None)
    self.techTree:AddUpgradeNode(kTechId.UpgradeToShadeHive,    kTechId.Hive,                kTechId.None)
    self.techTree:AddUpgradeNode(kTechId.UpgradeToShiftHive,    kTechId.Hive,                kTechId.None)
    
    self.techTree:AddBuildNode(kTechId.Harvester)
    self.techTree:AddBuildNode(kTechId.DrifterEgg)
    self.techTree:AddBuildNode(kTechId.Drifter, kTechId.None, kTechId.None, true)

    // Whips
    self.techTree:AddBuildNode(kTechId.Whip,                      kTechId.None,                kTechId.None)
    self.techTree:AddUpgradeNode(kTechId.EvolveBombard,             kTechId.None,                kTechId.None)

    self.techTree:AddPassive(kTechId.WhipBombard)
    self.techTree:AddPassive(kTechId.Slap)
    self.techTree:AddActivation(kTechId.WhipUnroot)
    self.techTree:AddActivation(kTechId.WhipRoot)
    
    // Tier 1 lifeforms
    self.techTree:AddAction(kTechId.Skulk,                     kTechId.None,                kTechId.None)
    self.techTree:AddAction(kTechId.Gorge,                     kTechId.None,                kTechId.None)
    self.techTree:AddAction(kTechId.Lerk,                      kTechId.None,                kTechId.None)
    self.techTree:AddAction(kTechId.Fade,                      kTechId.None,                kTechId.None)
    self.techTree:AddAction(kTechId.Onos,                      kTechId.None,                kTechId.None)
    self.techTree:AddBuyNode(kTechId.Egg,                      kTechId.None,                kTechId.None)
    
    self.techTree:AddUpgradeNode(kTechId.GorgeEgg, kTechId.BioMassTwo)
    self.techTree:AddUpgradeNode(kTechId.LerkEgg, kTechId.BioMassTwo)
    self.techTree:AddUpgradeNode(kTechId.FadeEgg, kTechId.BioMassNine)
    self.techTree:AddUpgradeNode(kTechId.OnosEgg, kTechId.BioMassNine)
    
    // Special alien structures. These tech nodes are modified at run-time, depending when they are built, so don't modify prereqs.
    self.techTree:AddBuildNode(kTechId.Crag,                      kTechId.Hive,          kTechId.None)
    self.techTree:AddBuildNode(kTechId.Shift,                     kTechId.Hive,          kTechId.None)
    self.techTree:AddBuildNode(kTechId.Shade,                     kTechId.Hive,          kTechId.None)
    
    // Alien upgrade structure
    self.techTree:AddBuildNode(kTechId.Shell, kTechId.CragHive)
    self.techTree:AddSpecial(kTechId.TwoShells, kTechId.Shell)
    self.techTree:AddSpecial(kTechId.ThreeShells, kTechId.TwoShells)
    
    self.techTree:AddBuildNode(kTechId.Veil, kTechId.ShadeHive)
    self.techTree:AddSpecial(kTechId.TwoVeils, kTechId.Veil)
    self.techTree:AddSpecial(kTechId.ThreeVeils, kTechId.TwoVeils)
    
    self.techTree:AddBuildNode(kTechId.Spur, kTechId.ShiftHive)  
    self.techTree:AddSpecial(kTechId.TwoSpurs, kTechId.Spur)
    self.techTree:AddSpecial(kTechId.ThreeSpurs, kTechId.TwoSpurs)
    
    // personal upgrades (all alien types)
    self.techTree:AddBuyNode(kTechId.Carapace, kTechId.Shell, kTechId.None, kTechId.AllAliens)    
    self.techTree:AddBuyNode(kTechId.Regeneration, kTechId.Shell, kTechId.None, kTechId.AllAliens)
	
    self.techTree:AddBuyNode(kTechId.Aura, kTechId.Veil, kTechId.None, kTechId.AllAliens)
    self.techTree:AddBuyNode(kTechId.Silence, kTechId.Veil, kTechId.None, kTechId.AllAliens)
	self.techTree:AddBuyNode(kTechId.Camouflage, kTechId.Veil, kTechId.None, kTechId.AllAliens)
		
    self.techTree:AddBuyNode(kTechId.Celerity, kTechId.Spur, kTechId.None, kTechId.AllAliens)  
    self.techTree:AddBuyNode(kTechId.Adrenaline, kTechId.Spur, kTechId.None, kTechId.AllAliens)  

    // Crag
    self.techTree:AddPassive(kTechId.CragHeal)
    self.techTree:AddActivation(kTechId.HealWave,                kTechId.CragHive,          kTechId.None)

    // Shift    
    self.techTree:AddActivation(kTechId.ShiftHatch,               kTechId.None,         kTechId.None) 
    self.techTree:AddPassive(kTechId.ShiftEnergize,               kTechId.None,         kTechId.None)
    
    self.techTree:AddTargetedActivation(kTechId.TeleportHydra,       kTechId.ShiftHive,         kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportWhip,        kTechId.ShiftHive,         kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportTunnel,      kTechId.ShiftHive,         kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportCrag,        kTechId.ShiftHive,         kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportShade,       kTechId.ShiftHive,         kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportShift,       kTechId.ShiftHive,         kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportVeil,        kTechId.ShiftHive,         kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportSpur,        kTechId.ShiftHive,         kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportShell,       kTechId.ShiftHive,         kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportHive,        kTechId.ShiftHive,         kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportEgg,         kTechId.ShiftHive,         kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportHarvester,   kTechId.ShiftHive,         kTechId.None)

    // Shade
    self.techTree:AddPassive(kTechId.ShadeDisorient)
    self.techTree:AddPassive(kTechId.ShadeCloak)
    self.techTree:AddActivation(kTechId.ShadeInk,                 kTechId.ShadeHive,         kTechId.None) 
    
    self.techTree:AddSpecial(kTechId.TwoHives)
    self.techTree:AddSpecial(kTechId.ThreeHives)
    
    self.techTree:AddSpecial(kTechId.TwoWhips)
    self.techTree:AddSpecial(kTechId.TwoShifts)
    self.techTree:AddSpecial(kTechId.TwoShades)
    self.techTree:AddSpecial(kTechId.TwoCrags)
    
    // abilities unlocked by bio mass: 
    
    // skulk researches
    self.techTree:AddResearchNode(kTechId.Leap,              kTechId.BioMassFour, kTechId.None, kTechId.AllAliens) 
    self.techTree:AddResearchNode(kTechId.Xenocide,          kTechId.BioMassNine, kTechId.None, kTechId.AllAliens)
    
    // gorge researches
    self.techTree:AddBuyNode(kTechId.BabblerAbility,        kTechId.None)
	self.techTree:AddBuyNode(kTechId.BabblerEgg,            kTechId.None)
	self.techTree:AddBuyNode(kTechId.Web,        			kTechId.WebTech)
	//self.techTree:AddResearchNode(kTechId.BabblerTech,            	kTechId.BioMassOne, kTechId.None, kTechId.AllAliens)
    self.techTree:AddResearchNode(kTechId.BileBomb,              kTechId.BioMassThree, kTechId.None, kTechId.AllAliens)
    self.techTree:AddResearchNode(kTechId.WebTech,                   kTechId.BioMassSeven, kTechId.None, kTechId.AllAliens)
    
    // lerk researches
    self.techTree:AddResearchNode(kTechId.Umbra,               kTechId.BioMassFive, kTechId.None, kTechId.AllAliens) 
    self.techTree:AddResearchNode(kTechId.Spores,              kTechId.BioMassSeven, kTechId.None, kTechId.AllAliens)
    
    // fade researches 
    self.techTree:AddResearchNode(kTechId.MetabolizeEnergy,        kTechId.BioMassThree, kTechId.None, kTechId.AllAliens) 
    self.techTree:AddResearchNode(kTechId.MetabolizeHealth,            kTechId.BioMassFive, kTechId.MetabolizeEnergy, kTechId.AllAliens)
    self.techTree:AddResearchNode(kTechId.Stab,              kTechId.BioMassSeven, kTechId.None, kTechId.AllAliens)
    
    // onos researches
    self.techTree:AddResearchNode(kTechId.Charge,            kTechId.BioMassTwo, kTechId.None, kTechId.AllAliens)
    self.techTree:AddResearchNode(kTechId.BoneShield,        kTechId.BioMassFour, kTechId.None, kTechId.AllAliens)
    self.techTree:AddResearchNode(kTechId.Stomp,             kTechId.BioMassEight, kTechId.None, kTechId.AllAliens)    

    // gorge structures
    self.techTree:AddBuildNode(kTechId.GorgeTunnelEntrance)
	self.techTree:AddBuildNode(kTechId.GorgeTunnelExit)
    self.techTree:AddBuildNode(kTechId.Hydra)
    self.techTree:AddBuildNode(kTechId.Clog)
	
	//Add this incase other mods want to modify tech tree
	if self.ModifyTechTree then
		self:ModifyTechTree()
	end

    self.techTree:SetComplete()
    
end