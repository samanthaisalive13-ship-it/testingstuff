-- This script inspects the local player's character as it appears in-game
-- and prints a comprehensive list of all the visual assets and properties
-- required to replicate its appearance. It correctly sources this information
-- from the live Humanoid, ensuring it captures the current in-game look.

-- Services
local Players = game:GetService("Players")

-- Player and Character
local localPlayer = Players.LocalPlayer

-- This function will process the character and print its description
local function printCharacterDescription(character)
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		warn("Character for " .. localPlayer.Name .. " spawned without a Humanoid.")
		return
	end

	-- Humanoid:GetAppliedDescription() is the key function.
	-- It creates a new HumanoidDescription object based on the Humanoid's
	-- current appearance in the game, which is exactly what is needed.
	local humanoidDescription = humanoid:GetAppliedDescription()

	print("------------------------------------------------------")
	print("MIMIC DATA FOR: " .. localPlayer.Name .. " (In-Game Appearance)")
	print("------------------------------------------------------")

	--[[
		BODY PARTS
		These are the asset IDs for the character's mesh package (e.g., Robloxian 2.0, specific bundles).
		A value of 0 typically means the default blocky part is being used.
	]]
	print("\n--- BODY PARTS (Package Asset IDs) ---")
	print("Head: " .. humanoidDescription.Head)
	print("Torso: " .. humanoidDescription.Torso)
	print("Left Arm: " .. humanoidDescription.LeftArm)
	print("Right Arm: " .. humanoidDescription.RightArm)
	print("Left Leg: " .. humanoidDescription.LeftLeg)
	print("Right Leg: " .. humanoidDescription.RightLeg)

	--[[
		BODY COLORS
		The actual BrickColor or Color3 values for each body part.
	]]
	print("\n--- BODY COLORS ---")
	print("Head Color: " .. tostring(humanoidDescription.HeadColor))
	print("Torso Color: " .. tostring(humanoidDescription.TorsoColor))
	print("Left Arm Color: " .. tostring(humanoidDescription.LeftArmColor))
	print("Right Arm Color: " .. tostring(humanoidDescription.RightArmColor))
	print("Left Leg Color: " .. tostring(humanoidDescription.LeftLegColor))
	print("Right Leg Color: " .. tostring(humanoidDescription.RightLegColor))

	--[[
		BODY SCALING
		These numeric values define the character's proportions for R15 rigs.
	]]
	print("\n--- BODY SCALING ---")
	print("Height Scale: " .. humanoidDescription.HeightScale)
	print("Width Scale: " .. humanoidDescription.WidthScale)
	print("Depth Scale: " .. humanoidDescription.DepthScale)
	print("Proportion Scale: " .. humanoidDescription.ProportionScale)
	print("Body Type Scale: " .. humanoidDescription.BodyTypeScale)
	print("Head Scale: " .. humanoidDescription.HeadScale)

	--[[
		CLASSIC CLOTHING
		Asset IDs for the classic Shirt, Pants, and T-Shirt instances.
	]]
	print("\n--- CLASSIC CLOTHING (Asset IDs) ---")
	print("Shirt: " .. humanoidDescription.Shirt)
	print("Pants: " .. humanoidDescription.Pants)
	print("T-Shirt (Graphic): " .. humanoidDescription.GraphicTShirt)
	
	--[[
		FACE DECAL
		The asset ID for the decal applied to the character's head.
	]]
	print("\n--- FACE (Asset ID) ---")
	print("Face: " .. humanoidDescription.Face)

	--[[
		ACCESSORIES (Rigid and Layered)
		Using GetAccessories(true) is the modern and correct way to get a list
		of all worn accessories, including both classic rigid hats/gear and
		new layered clothing items.
	]]
	print("\n--- ACCESSORIES (All Types) ---")
	local accessories = humanoidDescription:GetAccessories(true) -- 'true' includes rigid accessories
	if #accessories > 0 then
		for i, accessoryInfo in ipairs(accessories) do
			local accessoryType = accessoryInfo.AccessoryType.Name
			local assetId = accessoryInfo.AssetId
			local isLayered = accessoryInfo.IsLayered
			print(string.format("[%d] ID: %d, Type: %s, Layered: %s", i, assetId, accessoryType, tostring(isLayered)))
		end
	else
		print("No accessories worn.")
	end
	
	print("\n------------------ END OF DATA ------------------\n")
end

-- Function to connect the character loading events
local function onPlayerReady()
	-- Run for the character if it already exists
	if localPlayer.Character then
		printCharacterDescription(localPlayer.Character)
	end

	-- Connect to the CharacterAdded event to run every time the character spawns/respawns
	localPlayer.CharacterAdded:Connect(function(character)
		-- The character's appearance is loaded shortly after it's parented to the workspace.
		-- A small wait ensures all assets have had time to be applied.
		task.wait(1) 
		printCharacterDescription(character)
	end)
end

onPlayerReady()
