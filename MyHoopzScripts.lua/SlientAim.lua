local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local hoop = workspace:WaitForChild("Hoop") -- Your hoop part
local hoopPosition = hoop.Position

local SILENT_AIM_RANGE = 63 -- studs around the hoop for auto targeting
local HIGHLIGHT_COLOR = Color3.new(0, 1, 0) -- green glow or similar
local SHOOT_SUCCESS_CHANCE = 0.9 -- 90%
-- Table to keep track of highlights
local highlights = {}

local function createHighlight(player)
	if highlights[player] then return end
	local highlight = Instance.new("Highlight")
	highlight.Adornee = player.Character
	highlight.FillColor = HIGHLIGHT_COLOR
	highlight.OutlineColor = Color3.new(0, 0, 0)
	highlight.Parent = workspace
	highlights[player] = highlight
end

local function removeHighlight(player)
	if highlights[player] then
		highlights[player]:Destroy()
		highlights[player] = nil
	end
end

local function isPlayerInRange(player)
	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
		return false
	end
	local dist = (player.Character.HumanoidRootPart.Position - hoopPosition).Magnitude
	return dist <= SILENT_AIM_RANGE
end

local function playerHasBall(player)
	-- Replace this with your actual logic to detect ball possession
	-- Example: player.Character has a child named "Ball" or a BoolValue "HasBall"
	local hasBallValue = player:FindFirstChild("HasBall")
	if hasBallValue and hasBallValue.Value then
		return true
	end
	-- Or if ball is parented to player.Character
	if player.Character and player.Character:FindFirstChild("Ball") then
		return true
	end
	return false
end

-- Update highlights on all players around the hoop with ball
local function updateHighlights()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character then
			if isPlayerInRange(player) and playerHasBall(player) then
				createHighlight(player)
			else
				removeHighlight(player)
			end
		else
			removeHighlight(player)
		end
	end
end
local function calculateShotPower(distance)
	-- Simple linear mapping, adjust as needed
	-- E.g., power max is 100 at 0 studs, min 50 at SILENT_AIM_RANGE
	local maxPower = 85
	local minPower = 50
	local power = maxPower - ((distance / SILENT_AIM_RANGE) * (maxPower - minPower))
	return math.clamp(power, minPower, maxPower)
end
local function attemptSilentAimShot()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			if isPlayerInRange(player) and playerHasBall(player) then
				local dist = (player.Character.HumanoidRootPart.Position - hoopPosition).Magnitude
				local power = calculateShotPower(dist)

				-- Random chance check for success
				if math.random() <= SHOOT_SUCCESS_CHANCE then
					print("Silent Aim Shot SUCCESS for player:", player.Name, "Power:", power)
					-- Call your shooting function here, 
					-- e.g., RemoteEvent to server with target player and power

					-- Example: fire a remote event:
					-- yourRemoteEvent:FireServer(player, power)

				else
					print("Silent Aim Shot FAILED for player:", player.Name)
				end
			end
		end
	end
end

-- Connect to local player's jump event
humanoid.Jumping:Connect(function(active)
	if active then
		attemptSilentAimShot()
	end
end)
RunService.Heartbeat:Connect(function()
	updateHighlights()
end)
