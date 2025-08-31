
-- This LocalScript should be placed in StarterPlayerScripts.
-- It waits for the local player's character to load, then fetches and prints
-- all the important visual properties from its HumanoidDescription.

local Players = game:GetService("Players")

-- Get the local player and wait for their character to be added
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- It's good practice to wait a brief moment to ensure all assets have loaded on the character
task.wait(2)

-- Function to fetch and print the character's description
local function printCharacterDescription()
	print(`Fetching HumanoidDescription for {player.Name} (UserId: {player.UserId})...`)

	-- Use a pcall (protected call) in case the service fails to get the description
	local success, humanoidDescription = pcall(function()
		return Players:GetHumanoidDescriptionFromUserId(player.UserId)
	end)

	if not success or not humanoidDescription then
		warn("Could not fetch HumanoidDescription. Error:", tostring(humanoidDescription))
		return
	end

	print("--- CHARACTER DESCRIPTION LOADED ---")

	-- 1. Body Parts (the mesh/package for each limb)
	print("\n--- Body Parts (Asset IDs) ---")
	print("Head:", humanoidDescription.Head)
	print("Torso:", humanoidDescription.Torso)
	print("Left Arm:", humanoidDescription.LeftArm)
	print("Right Arm:", humanoidDescription.RightArm)
	print("Left Leg:", humanoidDescription.LeftLeg)
	print("Right Leg:", humanoidDescription.RightLeg)

	-- 2. Body Colors
	print("\n--- Body Colors (Color3) ---")
	print("Head Color:", humanoidDescription.HeadColor)
	print("Torso Color:", humanoidDescription.TorsoColor)
	print("Left Arm Color:", humanoidDescription.LeftArmColor)
	print("Right Arm Color:", humanoidDescription.RightArmColor)
	print("Left Leg Color:", humanoidDescription.LeftLegColor)
	print("Right Leg Color:", humanoidDescription.RightLegColor)

	-- 3. Clothing and Face
	print("\n--- Clothing & Face (Asset IDs) ---")
	print("Shirt:", humanoidDescription.Shirt)
	print("Pants:", humanoidDescription.Pants)
	print("Graphic T-Shirt:", humanoidDescription.GraphicTShirt)
	print("Face:", humanoidDescription.Face)

	-- 4. Scaling (determines the shape and proportions of the character)
	print("\n--- Scaling Values ---")
	print("BodyTypeScale:", humanoidDescription.BodyTypeScale)
	print("ProportionScale:", humanoidDescription.ProportionScale)
	print("HeadScale:", humanoidDescription.HeadScale)
	print("HeightScale:", humanoidDescription.HeightScale)
	print("WidthScale:", humanoidDescription.WidthScale)
	print("DepthScale:", humanoidDescription.DepthScale)

	-- 5. Accessories (Hats, Hair, Glasses, etc.)
	-- The GetAccessories method is the best way to get a clean list of ALL accessories,
	-- including both classic (rigid) and layered clothing.
	print("\n--- Accessories ---")
	local accessories = humanoidDescription:GetAccessories(true) -- 'true' includes rigid accessories
	if #accessories > 0 then
		for i, accessoryInfo in ipairs(accessories) do
			print(string.format(
				"  [%d] AssetId: %d, Type: %s, IsLayered: %s",
				i,
				accessoryInfo.AssetId,
				accessoryInfo.AccessoryType.Name,
				tostring(accessoryInfo.IsLayered)
				))
		end
	else
		print("  No accessories found.")
	end

	print("\n--- MIMIC DATA COMPLETE ---")
end

-- Run the function
printCharacterDescription()
