local HttpService = game:GetService("HttpService")

-- CONFIG: Services to include
local TARGET_SERVICE_NAMES = {
	"ReplicatedFirst",
	"Workspace",
	"ReplicatedStorage",
	"ServerScriptService",
	"ServerStorage",
	"StarterGui",
	"StarterPack",
	"StarterPlayer",
}

-- Collect data
local outputLines = {}

local function append(line)
	table.insert(outputLines, line)
end

local function sanitizeTabs(str)
	return str:gsub("\t", "    ")
end

local function traverse(instance, indent)
	append(string.format("%s- %s [%s]", indent, instance.Name, instance.ClassName))

	if instance:IsA("LuaSourceContainer") then
		local ok, source = pcall(function() return instance.Source end)
		if ok and source and source:match("%S") then
			append(indent .. "  ```lua")
			for _, line in ipairs(source:split("\n")) do
				append(indent .. "  " .. sanitizeTabs(line))
			end
			append(indent .. "  ```")
		elseif not ok then
			append(indent .. "  --[[ Error: " .. tostring(source) .. " ]]--")
		else
			append(indent .. "  --[[ Empty script ]]--")
		end
	end

	local children = instance:GetChildren()
	table.sort(children, function(a, b) return a.Name < b.Name end)
	for _, child in ipairs(children) do
		traverse(child, indent .. "  ")
	end
end

-- Build output
append("--- HIERARCHY EXPORT START ---")
append("Timestamp: " .. os.date("!%Y-%m-%d %H:%M:%S (UTC)"))
append("Scanning: " .. table.concat(TARGET_SERVICE_NAMES, ", "))
append("")

for _, serviceName in ipairs(TARGET_SERVICE_NAMES) do
	local service = game:FindFirstChild(serviceName)
	if service then
		append("\n--- " .. serviceName .. " ---")
		local ok, err = pcall(traverse, service, "")
		if not ok then
			append("-- Error traversing " .. serviceName .. ": " .. tostring(err))
		end
	else
		append("\n--- " .. serviceName .. " (Not Found) ---")
	end
end

append("\n--- HIERARCHY EXPORT END ---")

-- Prepare multipart/form-data
local boundary = "----WebKitFormBoundary" .. HttpService:GenerateGUID(false)
local content = "--" .. boundary .. "\r\n"
	.. 'Content-Disposition: form-data; name="file"; filename="hierarchy.txt"\r\n'
	.. "Content-Type: text/plain\r\n\r\n"
	.. table.concat(outputLines, "\n") .. "\r\n"
	.. "--" .. boundary .. "--"

-- Send to 0x0.st using RequestAsync
local response
local success, err = pcall(function()
	response = HttpService:RequestAsync({
		Url = "https://0x0.st",
		Method = "POST",
		Headers = {
			["Content-Type"] = "multipart/form-data; boundary=" .. boundary
		},
		Body = content
	})
end)

-- Handle result
if success and response and response.Success then
	print("✅ Upload successful! Link:\n" .. response.Body)
else
	warn("❌ Upload failed: " .. (err or (response and response.StatusMessage) or "Unknown error"))
end
