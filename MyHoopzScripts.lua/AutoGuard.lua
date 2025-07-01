local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local autoGuardButton = script.Parent:WaitForChild("MenuFrame"):WaitForChild("AutoGuardButton")
local isAutoGuardEnabled = false

-- Distance you want to keep from the target while guarding
local GUARD_DISTANCE = 5

-- Store the current target you are guarding
local currentTarget = nil

-- Toggle Auto Guard function
local function toggleAutoGuard()
	isAutoGuardEnabled = not isAutoGuardEnabled

	if isAutoGuardEnabled then
		autoGuardButton.Text = "Auto Guard: ON"
		print("Auto Guard Enabled")
	else
		autoGuardButton.Text = "Auto Guard: OFF"
		print("Auto Guard Disabled")
		currentTarget = nil
	end
end

-- Function to find nearest opponent
local function findNearestOpponent()
	local nearestPlayer = nil
	local shortestDistance = math.huge

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local targetHRP = player.Character.HumanoidRootPart
			local dist = (humanoidRootPart.Position - targetHRP.Position).Magnitude
			if dist < shortestDistance then
				shortestDistance = dist
				nearestPlayer = player
			end
		end
	end

	return nearestPlayer, shortestDistance
end

-- Update loop: runs every frame
RunService.Heartbeat:Connect(function()
	if isAutoGuardEnabled then
		-- Find nearest opponent
		local target, dist = findNearestOpponent()
		if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			currentTarget = target

			local targetPos = target.Character.HumanoidRootPart.Position
			local direction = (targetPos - humanoidRootPart.Position).Unit
			local guardPos = targetPos - direction * GUARD_DISTANCE

			-- Move local player close to guard position
			localPlayer.Character.Humanoid:MoveTo(guardPos)
		end
	else
		-- Auto guard off, stop moving automatically
		currentTarget = nil
		-- Optional: stop moving by moving to current position
		localPlayer.Character.Humanoid:MoveTo(humanoidRootPart.Position)
	end
end)

-- Keybind U toggles Auto Guard
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.U then
		toggleAutoGuard()
	end
end)

-- Button click toggles Auto Guard too
autoGuardButton.MouseButton1Click:Connect(toggleAutoGuard)
