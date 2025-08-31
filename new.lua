--!/usr/bin/env lua
-- This LocalScript MANUALLY INSPECTS the live character model to build an accurate HumanoidDescription.
-- This avoids issues where GetAppliedDescription() might return outdated or cached data.

local Players = game:GetService("Players")

-- Get the local player and wait for their character to be added
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Wait for the character to be fully assembled by game scripts
task.wait(3)

local function manuallyInspectCharacter()
    print("--- Starting Manual Inspection of Current Character Model ---")

    -- This table will hold all the data we find
    local mimicData = {}

    -- Step 1: Get the base description to source the Body Part IDs, which are hard to find manually.
    -- We will overwrite everything else with our manually inspected, more accurate data.
    local baseDescription = humanoid:GetAppliedDescription()
    mimicData.BodyParts = {
        Head = baseDescription.Head,
        Torso = baseDescription.Torso,
        LeftArm = baseDescription.LeftArm,
        RightArm = baseDescription.RightArm,
        LeftLeg = baseDescription.LeftLeg,
        RightLeg = baseDescription.RightLeg,
    }

    -- Step 2: Manually inspect BodyColors
    mimicData.BodyColors = {}
    local bodyColors = character:FindFirstChild("BodyColors")
    if bodyColors then
        mimicData.BodyColors.Head = bodyColors.HeadColor3
        mimicData.BodyColors.Torso = bodyColors.TorsoColor3
        mimicData.BodyColors.LeftArm = bodyColors.LeftArmColor3
        mimicData.BodyColors.RightArm = bodyColors.RightArmColor3
        mimicData.BodyColors.LeftLeg = bodyColors.LeftLegColor3
        mimicData.BodyColors.RightLeg = bodyColors.RightLegColor3
    end

    -- Step 3: Manually inspect Clothing and Face
    mimicData.Clothing = {}
    local shirt = character:FindFirstChildOfClass("Shirt")
    mimicData.Clothing.Shirt = shirt and shirt.ShirtTemplate or 0

    local pants = character:FindFirstChildOfClass("Pants")
    mimicData.Clothing.Pants = pants and pants.PantsTemplate or 0

    local shirtGraphic = character:FindFirstChildOfClass("ShirtGraphic")
    mimicData.Clothing.TShirt = shirtGraphic and shirtGraphic.Graphic or 0
    
    local face = character.Head:FindFirstChild("Face")
    if face and face:IsA("Decal") and face.Texture:match("rbxassetid://") then
        mimicData.Clothing.Face = tonumber(face.Texture:match("%d+")) or 0
    else
        mimicData.Clothing.Face = 0
    end

    -- Step 4: Manually inspect Scaling Values from the Humanoid
    mimicData.Scaling = {}
    local function getScaleValue(scaleName, default)
        local scaleInstance = humanoid:FindFirstChild(scaleName)
        return (scaleInstance and scaleInstance:IsA("NumberValue")) and scaleInstance.Value or default
    end
    mimicData.Scaling.HeadScale = getScaleValue("HeadScale", 1)
    mimicData.Scaling.BodyDepthScale = getScaleValue("BodyDepthScale", 1)
    mimicData.Scaling.BodyHeightScale = getScaleValue("BodyHeightScale", 1)
    mimicData.Scaling.BodyWidthScale = getScaleValue("BodyWidthScale", 1)
    mimicData.Scaling.BodyTypeScale = getScaleValue("BodyTypeScale", 0)
    mimicData.Scaling.ProportionScale = getScaleValue("BodyProportionScale", 0)

    -- Step 5: Get the CURRENT accessories using the reliable GetAccessories() method
    mimicData.Accessories = humanoid:GetAccessories()

    -- Step 6: Format and Print the gathered data
    local outputLines = {}
    local function log(text) table.insert(outputLines, text) end
    
    log("--- MANUAL INSPECTION DATA COMPLETE ---")
    
    log("\n--- Body Parts (Asset IDs) ---")
    log("Head: " .. tostring(mimicData.BodyParts.Head))
    log("Torso: " .. tostring(mimicData.BodyParts.Torso))
    log("Left Arm: " .. tostring(mimicData.BodyParts.LeftArm))
    log("Right Arm: " .. tostring(mimicData.BodyParts.RightArm))
    log("Left Leg: " .. tostring(mimicData.BodyParts.LeftLeg))
    log("Right Leg: " .. tostring(mimicData.BodyParts.RightLeg))

    if mimicData.BodyColors then
        log("\n--- Body Colors (Color3) ---")
        log("Head Color: " .. tostring(mimicData.BodyColors.Head))
        log("Torso Color: " .. tostring(mimicData.BodyColors.Torso))
        log("Left Arm Color: " .. tostring(mimicData.BodyColors.LeftArm))
        log("Right Arm Color: " .. tostring(mimicData.BodyColors.RightArm))
        log("Left Leg Color: " .. tostring(mimicData.BodyColors.LeftLeg))
        log("Right Leg Color: " .. tostring(mimicData.BodyColors.RightLeg))
    end
    
    log("\n--- Clothing & Face (Asset IDs) ---")
    log("Shirt: " .. tostring(mimicData.Clothing.Shirt))
    log("Pants: " .. tostring(mimicData.Clothing.Pants))
    log("Graphic T-Shirt: " .. tostring(mimicData.Clothing.TShirt))
    log("Face: " .. tostring(mimicData.Clothing.Face))
    
    log("\n--- Scaling Values ---")
    log("BodyTypeScale: " .. tostring(mimicData.Scaling.BodyTypeScale))
    log("ProportionScale: " .. tostring(mimicData.Scaling.ProportionScale))
    log("HeadScale: " .. tostring(mimicData.Scaling.HeadScale))
    log("HeightScale: " .. tostring(mimicData.Scaling.BodyHeightScale))
    log("WidthScale: " .. tostring(mimicData.Scaling.BodyWidthScale))
    log("DepthScale: " .. tostring(mimicData.Scaling.BodyDepthScale))
    
    log("\n--- Accessories ---")
    if #mimicData.Accessories > 0 then
        for i, accInfo in ipairs(mimicData.Accessories) do
            log(string.format("  [%d] AssetId: %d, Type: %s, IsLayered: %s", i, accInfo.AssetId, accInfo.AccessoryType.Name, tostring(accInfo.IsLayered)))
        end
    else
        log("  No accessories found.")
    end

    -- Print and copy to clipboard
    local fullOutput = table.concat(outputLines, "\n")
    print(fullOutput)
    
    if setclipboard then
        setclipboard(fullOutput)
        print("\n--- Manually inspected character data copied to clipboard! ---")
    else
        warn("\nsetclipboard is not available.")
    end
end

manuallyInspectCharacter()
