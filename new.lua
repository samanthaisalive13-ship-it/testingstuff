-- LocalScript: place in StarterPlayer.StarterPlayerScripts

-- This script generates a ModuleScript-compatible Lua table representing the
-- local player's current in-game appearance and copies it to the clipboard.

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- Helper function to format Color3 values for the module
local function formatColor3(c3)
	return string.format("Color3.fromRGB(%d, %d, %d)", c3.R * 255, c3.G * 255, c3.B * 255)
end

-- This function does the main work of inspecting the character and building the module string
local function generateAndCopyAppearanceModule(character)
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	-- Get the description from the live, in-game humanoid model
	local humanoidDescription = humanoid:GetAppliedDescription()

	local lines = {}
	table.insert(lines, "-- Appearance data generated on " .. os.date())
	table.insert(lines, "return {")

	-- Body Parts and Face
	table.insert(lines, "\t-- Body Parts (Asset IDs)")
	table.insert(lines, string.format('\tHead = %d,', humanoidDescription.Head))
	table.insert(lines, string.format('\tTorso = %d,', humanoidDescription.Torso))
	table.insert(lines, string.format('\tLeftArm = %d,', humanoidDescription.LeftArm))
	table.insert(lines, string.format('\tRightArm = %d,', humanoidDescription.RightArm))
	table.insert(lines, string.format('\tLeftLeg = %d,', humanoidDescription.LeftLeg))
	table.insert(lines, string.format('\tRightLeg = %d,', humanoidDescription.RightLeg))
	table.insert(lines, string.format('\tFace = %d,', humanoidDescription.Face))

	-- Body Colors
	table.insert(lines, "\n\t-- Body Colors")
	table.insert(lines, string.format('\tHeadColor = %s,', formatColor3(humanoidDescription.HeadColor)))
	table.insert(lines, string.format('\tTorsoColor = %s,', formatColor3(humanoidDescription.TorsoColor)))
	table.insert(lines, string.format('\tLeftArmColor = %s,', formatColor3(humanoidDescription.LeftArmColor)))
	table.insert(lines, string.format('\tRightArmColor = %s,', formatColor3(humanoidDescription.RightArmColor)))
	table.insert(lines, string.format('\tLeftLegColor = %s,', formatColor3(humanoidDescription.LeftLegColor)))
	table.insert(lines, string.format('\tRightLegColor = %s,', formatColor3(humanoidDescription.RightLegColor)))
	
	-- Classic Clothing
	table.insert(lines, "\n\t-- Classic Clothing (Asset IDs)")
	table.insert(lines, string.format('\tShirt = %d,', humanoidDescription.Shirt))
	table.insert(lines, string.format('\tPants = %d,', humanoidDescription.Pants))
	table.insert(lines, string.format('\tGraphicTShirt = %d,', humanoidDescription.GraphicTShirt))

	-- Body Scaling
	table.insert(lines, "\n\t-- Body Scaling")
	table.insert(lines, string.format('\tBodyTypeScale = %f,', humanoidDescription.BodyTypeScale))
	table.insert(lines, string.format('\tDepthScale = %f,', humanoidDescription.DepthScale))
	table.insert(lines, string.format('\tHeightScale = %f,', humanoidDescription.HeightScale))
	table.insert(lines, string.format('\tHeadScale = %f,', humanoidDescription.HeadScale))
	table.insert(lines, string.format('\tProportionScale = %f,', humanoidDescription.ProportionScale))
	table.insert(lines, string.format('\tWidthScale = %f,', humanoidDescription.WidthScale))

	-- Animations (Added as requested)
	table.insert(lines, "\n\t-- Animations (Asset IDs)")
	table.insert(lines, string.format('\tClimbAnimation = %d,', humanoidDescription.ClimbAnimation))
	table.insert(lines, string.format('\tFallAnimation = %d,', humanoidDescription.FallAnimation))
	table.insert(lines, string.format('\tIdleAnimation = %d,', humanoidDescription.IdleAnimation))
	table.insert(lines, string.format('\tJumpAnimation = %d,', humanoidDescription.JumpAnimation))
	table.insert(lines, string.format('\tRunAnimation = %d,', humanoidDescription.RunAnimation))
	table.insert(lines, string.format('\tSwimAnimation = %d,', humanoidDescription.SwimAnimation))
	table.insert(lines, string.format('\tWalkAnimation = %d,', humanoidDescription.WalkAnimation))
	
	-- Accessories (Both Rigid and Layered)
	table.insert(lines, "\n\t-- Accessories (Rigid and Layered)")
	table.insert(lines, "\tAccessories = {")
	local accessories = humanoidDescription:GetAccessories(true)
	for _, accessoryInfo in ipairs(accessories) do
		local puffiness = accessoryInfo.Puffiness and string.format("Puffiness = %f, ", accessoryInfo.Puffiness) or ""
		local order = accessoryInfo.Order and string.format("Order = %d, ", accessoryInfo.Order) or ""
		local isLayered = accessoryInfo.IsLayered and string.format("IsLayered = %s, ", tostring(accessoryInfo.IsLayered)) or ""
		
		local accessoryLine = string.format(
			'\t\t{ AssetId = %d, AccessoryType = Enum.AccessoryType.%s, %s%s%s},',
			accessoryInfo.AssetId,
			accessoryInfo.AccessoryType.Name,
			order,
			isLayered,
			puffiness
		)
		-- Remove trailing comma and space if they exist
		accessoryLine = accessoryLine:gsub(", }", " }")
		table.insert(lines, accessoryLine)
	end
	table.insert(lines, "\t},")

	table.insert(lines, "}")
	
	local moduleString = table.concat(lines, "\n")
	
	-- Set clipboard
	if not setclipboard then
		warn("setclipboard is not enabled. Please enable it in Studio settings to use this script.")
		print("--- BEGIN CHARACTER MODULE ---")
		print(moduleString)
		print("--- END CHARACTER MODULE ---")
	else
		setclipboard(moduleString)
		print("SUCCESS: Character appearance module has been copied to your clipboard.")
	end
end

-- Wait for the character to load its appearance fully
local function onCharacterAdded(character)
	task.wait(2) -- A brief wait ensures all assets have been applied before we read them
	generateAndCopyAppearanceModule(character)
end

if localPlayer.Character then
	onCharacterAdded(localPlayer.Character)
end
localPlayer.CharacterAdded:Connect(onCharacterAdded)
