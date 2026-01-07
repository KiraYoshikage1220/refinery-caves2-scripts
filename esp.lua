local ORE_FOLDER_NAME = "Ores"
local CHECK_INTERVAL = 1
local ESP_COLOR = Color3.fromRGB(255, 0, 0)
local TEXT_COLOR = Color3.fromRGB(255, 255, 255) 
local TEXT_SIZE = 18 -- Размер текста
local TEXT_OFFSET = Vector3.new(0, 3, 0) 

local oresFolder = game.Workspace:FindFirstChild("WorldSpawn")
if not oresFolder then
    warn("WorldSpawn folder not found!")
    return
end

oresFolder = oresFolder:FindFirstChild(ORE_FOLDER_NAME)
if not oresFolder then
    warn("Ores folder not found!")
    return
end

local processedOres = {}

local function createESP(part, oreName)
    if processedOres[part] then return end
    
    local highlight = Instance.new("Highlight")
    highlight.FillColor = ESP_COLOR
    highlight.FillTransparency = 0.7
    highlight.OutlineColor = ESP_COLOR
    highlight.OutlineTransparency = 0.5
    highlight.Enabled = true
    highlight.Adornee = part
    highlight.Parent = part

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = part
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = TEXT_OFFSET
    billboard.AlwaysOnTop = true
    billboard.Parent = part

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = TEXT_COLOR
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextSize = TEXT_SIZE
    textLabel.Text = oreName
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Parent = billboard

    processedOres[part] = {
        highlight = highlight,
        billboard = billboard
    }
end

local function cleanupRemovedOres()
    for part, objects in pairs(processedOres) do
        if not part or not part.Parent then
            if objects.highlight and objects.highlight.Parent then
                objects.highlight:Destroy()
            end
            if objects.billboard and objects.billboard.Parent then
                objects.billboard:Destroy()
            end
            processedOres[part] = nil
        end
    end
end

spawn(function()
    while true do
        pcall(function()
            cleanupRemovedOres()

            for _, ore in pairs(oresFolder:GetChildren()) do
                local hittable = ore:FindFirstChild("Hittable")
                if hittable then
                    local part = hittable:FindFirstChild("Part")
                    if part and part:IsA("BasePart") then
                        createESP(part, ore.Name)
                    end
                end
            end
        end)
        
        wait(CHECK_INTERVAL)
    end
end)

function removeAllESP()
    for part, objects in pairs(processedOres) do
        if objects.highlight and objects.highlight.Parent then
            objects.highlight:Destroy()
        end
        if objects.billboard and objects.billboard.Parent then
            objects.billboard:Destroy()
        end
    end
    table.clear(processedOres)
    print("all ess on")
end
print("esp for ores on")