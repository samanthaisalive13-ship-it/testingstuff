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

    -- Create a table to store output for clipboard
    local output = {"--- CHARACTER DESCRIPTION LOADED ---"}

    -- 1. Body Parts (the mesh/package for each limb)
    table.insert(output, "\n--- Body Parts (Asset IDs) ---")
    table.insert(output, "Head: " .. tostring(humanoidDescription.Head))
    table.insert(output, "Torso: " .. tostring(humanoidDescription.Torso))
    table.insert(output, "Left Arm: " .. tostring(humanoidDescription.LeftArm))
    table.insert(output, "Right Arm: " .. tostring(humanoidDescription.RightArm))
    table.insert(output, "Left Leg: " .. tostring(humanoidDescription.LeftLeg))
    table.insert(output, "Right Leg: " .. tostring(humanoidDescription.RightLeg))
    print(table.concat(output, "\n"))

    -- 2. Body Colors
    table.insert(output, "\n--- Body Colors (Color3) ---")
    table.insert(output, "Head Color: " .. tostring(humanoidDescription.HeadColor))
    table.insert(output, "Torso Color: " .. tostring(humanoidDescription.TorsoColor))
    table.insert(output, "Left Arm Color: " .. tostring(humanoidDescription.LeftArmColor))
    table.insert(output, "Right Arm Color: " .. tostring(humanoidDescription.RightArmColor))
    table.insert(output, "Left Leg Color: " .. tostring(humanoidDescription.LeftLegColor))
    table.insert(output, "Right Leg Color: " .. tostring(humanoidDescription.RightLegColor))
    print(table.concat(output, "\n"))

    -- 3. Clothing and Face
    table.insert(output, "\n--- Clothing & Face (Asset IDs) ---")
    table.insert(output, "Shirt: " .. tostring(humanoidDescription.Shirt))
    table.insert(output, "Pants: " .. tostring(humanoidDescription.Pants))
    table.insert(output, "Graphic T-Shirt: " .. tostring(humanoidDescription.GraphicTShirt))
    table.insert(output, "Face: " .. tostring(humanoidDescription.Face))
    print(table.concat(output, "\n"))

    -- 4. Scaling (determines the shape and proportions of the character)
    table.insert(output, "\n--- Scaling Values ---")
    table.insert(output, "BodyTypeScale: " .. tostring(humanoidDescription.BodyTypeScale))
    table.insert(output, "ProportionScale: " .. tostring(humanoidDescription.ProportionScale))
    table.insert(output, "HeadScale: " .. tostring(humanoidDescription.HeadScale))
    table.insert(output, "HeightScale: " .. tostring(humanoidDescription.HeightScale))
    table.insert(output, "WidthScale: " .. tostring(humanoidDescription.WidthScale))
    table.insert(output, "DepthScale: " .. tostring(humanoidDescription.DepthScale))
    print(table.concat(output, "\n"))

    -- 5. Accessories (Hats, Hair, Glasses, etc.)
    table.insert(output, "\n--- Accessories ---")
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
            table.insert(output, accessoryStr)
            print(accessoryStr)
        end
    else
        table.insert(output, "  No accessories found.")
        print("  No accessories found.")
    end

    table.insert(output, "\n--- MIMIC DATA COMPLETE ---")
    print("\n--- MIMIC DATA COMPLETE ---")

    -- Copy to clipboard
    if setclipboard then
        setclipboard(table.concat(output, "\n"))
        print("Character description copied to clipboard!")
    else
        warn("setclipboard is not supported by this executor.")
    end
end

-- Run the function
printCharacterDescription()
