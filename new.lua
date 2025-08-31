-- This LocalScript should be placed in StarterPlayerScripts.
-- It waits for the local player's character to load, then fetches and prints
-- all the important visual properties from its HumanoidDescription.
-- Updated to copy the output to the system clipboard.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Get the local player and wait for their character to be added
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- It's good practice to wait a brief moment to ensure all assets have loaded on the character
task.wait(2)

-- Function to fetch and print the character's description
local function printCharacterDescription()
	local output = {} -- Table to collect output for clipboard
	local function addLine(line) -- Helper to add to output and print
		table.insert(output, line)
		print(line)
	end

	addLine(`Fetching HumanoidDescription for {player.Name} (UserId: {player.UserId})...`)

	-- Use a pcall (protected call) in case the service fails to get the description
	local success, humanoidDescription = pcall(function()
		return Players:GetHumanoidDescriptionFromUserId(player.UserId)
	end)

	if not success or not humanoidDescription then
		addLine("Could not fetch HumanoidDescription. Error: " .. tostring(humanoidDescription))
		return
	end

	addLine("--- CHARACTER DESCRIPTION LOADED ---")

	-- 1. Body Parts (the mesh/package for each limb)
	addLine("\n--- Body Parts (Asset IDs) ---")
	addLine("Head: " .. humanoidDescription.Head)
	addLine("Torso: " .. humanoidDescription.Torso)
	addLine("Left Arm: " .. humanoidDescription.LeftArm)
	addLine("Right Arm: " .. humanoidDescription.RightArm)
	addLine("Left Leg: " .. humanoidDescription.LeftLeg)
	addLine("Right Leg: " .. humanoidDescription.RightLeg)

	-- 2. Body Colors
	addLine("\n--- Body Colors (Color3) ---")
	addLine("Head Color: " .. tostring(humanoidDescription.HeadColor))
	addLine("Torso Color: " .. tostring(humanoidDescription.TorsoColor))
	addLine("Left Arm Color: " .. tostring(humanoidDescription.LeftArmColor))
	addLine("Right Arm Color: " .. tostring(humanoidDescription.RightArmColor))
	addLine("Left Leg Color: " .. tostring(humanoidDescription.LeftLegColor))
	addLine("Right Leg Color: " .. tostring(humanoidDescription.RightLegColor))

	-- 3. Clothing and Face
	addLine("\n--- Clothing & Face (Asset IDs) ---")
	addLine("Shirt: " .. humanoidDescription.Shirt)
	addLine("Pants: " .. humanoidDescription.Pants)
	addLine("Graphic T-Shirt: " .. humanoidDescription.GraphicTShirt)
	addLine("Face: " .. humanoidDescription.Face)

	-- 4. Scaling (determines the shape and proportions of the character)
	addLine("\n--- Scaling Values ---")
	addLine("BodyTypeScale: " .. humanoidDescription.BodyTypeScale)
	addLine("ProportionScale: " .. humanoidDescription.ProportionScale)
	addLine("HeadScale: " .. humanoidDescription.HeadScale)
	addLine("HeightScale: " .. humanoidDescription.HeightScale)
	addLine("WidthScale: " .. humanoidDescription.WidthScale)
	addLine("DepthScale: " .. humanoidDescription.DepthScale)

	-- 5. Accessories (Hats, Hair, Glasses, etc.)
	addLine("\n--- Accessories ---")
	local accessories = humanoidDescription:GetAccessories(true) -- 'true' includes rigid accessories
	if #accessories > 0 then
		for i, accessoryInfo in ipairs(accessories) do
			addLine(string.format(
				"  [%d] AssetId: %d, Type: %s, IsLayered: %s",
				i,
				accessoryInfo.AssetId,
				accessoryInfo.AccessoryType.Name,
				tostring(accessoryInfo.IsLayered)
			))
		end
	else
		addLine("  No accessories found.")
	end

	addLine("\n--- MIMIC DATA COMPLETE ---")

	-- Copy to clipboard
	local success, err = pcall(function()
		local text = table.concat(output, "\n")
		local screenGui = Instance.new("ScreenGui", player.PlayerGui)
		local textBox = Instance.new("TextBox", screenGui)
		textBox.Size = UDim2.new(0, 100, 0, 50)
		textBox.Position = UDim2.new(0, 0, 0, 0)
		textBox.Text = text
		textBox.Visible = false
		textBox:CaptureFocus()
		UserInputService.InputBegan:Connect(function(input)
			if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
				UserInputService.InputBegan:Connect(function(input2)
					if input2.KeyCode == Enum.KeyCode.C then
						textBox.Text = text
						addLine("Character description copied to clipboard!")
						screenGui:Destroy()
					end
				end)
			end
		end)
	end)

	if not success then
		addLine("Failed to copy to clipboard: " .. tostring(err))
	end
end

-- Run the function
printCharacterDescription()
