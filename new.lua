-- This LocalScript grabs the description from the player's CURRENT IN-GAME character model.
local Players = game:GetService("Players")

-- Get the local player and wait for their character to be added
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- It's good practice to wait a brief moment to ensure all assets have loaded on the character
task.wait(2)

-- Function to fetch and print the character's description
local function printCharacterDescription()
    print(`Fetching HumanoidDescription for {player.Name}'s current in-game character...`)

    -- This is the key change: GetAppliedDescription() reads the current character model.
    local humanoidDescription = humanoid:GetAppliedDescription()

    -- Create a table to store all output lines
    local outputLines = {}
    local function logAndStore(text)
        print(text)
        table.insert(outputLines, text)
    end
    
    logAndStore("--- CHARACTER DESCRIPTION LOADED ---")

    -- 1. Body Parts (the mesh/package for each limb)
    logAndStore("\n--- Body Parts (Asset IDs) ---")
    logAndStore("Head: " .. tostring(humanoidDescription.Head))
    logAndStore("Torso: " .. tostring(humanoidDescription.Torso))
    logAndStore("Left Arm: " .. tostring(humanoidDescription.LeftArm))
    logAndStore("Right Arm: " .. tostring(humanoidDescription.RightArm))
    logAndStore("Left Leg: " .. tostring(humanoidDescription.LeftLeg))
    logAndStore("Right Leg: " .. tostring(humanoidDescription.RightLeg))

    -- 2. Body Colors
    logAndStore("\n--- Body Colors (Color3) ---")
    logAndStore("Head Color: " .. tostring(humanoidDescription.HeadColor))
    logAndStore("Torso Color: " .. tostring(humanoidDescription.TorsoColor))
    logAndStore("Left Arm Color: " .. tostring(humanoidDescription.LeftArmColor))
    logAndStore("Right Arm Color: " .. tostring(humanoidDescription.RightArmColor))
    logAndStore("Left Leg Color: " .. tostring(humanoidDescription.LeftLegColor))
    logAndStore("Right Leg Color: " .. tostring(humanoidDescription.RightLegColor))

    -- 3. Clothing and Face
    logAndStore("\n--- Clothing & Face (Asset IDs) ---")
    logAndStore("Shirt: " .. tostring(humanoidDescription.Shirt))
    logAndStore("Pants: " .. tostring(humanoidDescription.Pants))
    logAndStore("Graphic T-Shirt: " .. tostring(humanoidDescription.GraphicTShirt))
    logAndStore("Face: " .. tostring(humanoidDescription.Face))

    -- 4. Scaling (determines the shape and proportions of the character)
    logAndStore("\n--- Scaling Values ---")
    logAndStore("BodyTypeScale: " .. tostring(humanoidDescription.BodyTypeScale))
    logAndStore("ProportionScale: " .. tostring(humanoidDescription.ProportionScale))
    logAndStore("HeadScale: " .. tostring(humanoidDescription.HeadScale))
    logAndStore("HeightScale: " .. tostring(humanoidDescription.HeightScale))
    logAndStore("WidthScale: " .. tostring(humanoidDescription.WidthScale))
    logAndStore("DepthScale: " .. tostring(humanoidDescription.DepthScale))

    -- 5. Accessories (Hats, Hair, Glasses, etc.)
    logAndStore("\n--- Accessories ---")
    local accessories = humanoidDescription:GetAccessories(true) -- 'true' includes rigid accessories
    if #accessories > 0 then
        for i, accessoryInfo in ipairs(accessories) do
            local accessoryStr = string.format(
                "  [%d] AssetId: %d, Type: %s, IsLayered: %s",
                i,
                accessoryInfo.AssetId,
                accessoryInfo.AccessoryType.Name,
                tostring(accessoryInfo.IsLayered)
            )
            logAndStore(accessoryStr)
        end
    else
        logAndStore("  No accessories found.")
    end

    logAndStore("\n--- MIMIC DATA COMPLETE ---")
    
    -- (I've cleaned up your original print logic to be more efficient)
    -- Now, copy the final concatenated string to the clipboard
    local fullOutput = table.concat(outputLines, "\n")
    if setclipboard then
        setclipboard(fullOutput)
        print("\nCharacter description copied to clipboard!")
    else
        warn("\nsetclipboard is not available. To copy, select the text in the output window.")
    end
end

-- Run the function
printCharacterDescription()
