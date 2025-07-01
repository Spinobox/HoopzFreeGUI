local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local menuFrame = script.Parent:WaitForChild("MenuFrame")
local reachButton = menuFrame:WaitForChild("ReachButton")

local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local isReachEnabled = false
local NORMAL_REACH = 5
local EXTENDED_REACH = 10
local currentReachDistance = NORMAL_REACH

-- The ball object in workspace
local ball = workspace:WaitForChild("Ball")

-- Function to check if ball is within reach
local function isBallInReach()
	local dist = (humanoidRootPart.Position - ball.Position).Magnitude
	return dist <= currentReachDistance
end

-- Function to “steal” or pick up the ball
local function stealBall()
	-- Replace the following logic with your actual ball stealing/pickup code!
	-- Example: set ball’s CFrame to your hand or attach it to your character
	ball.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, -2)
	ball.Velocity = Vector3.new(0, 0, 0)
	ball.Anchored = false  -- Make sure it’s not anchored if it shouldn’t be

	-- Example print for debugging
	print("Ball stolen!")
end

-- Toggle Reach function
local function toggleReach()
	isReachEnabled = not isReachEnabled
	if isReachEnabled then
		currentReachDistance = EXTENDED_REACH
		reachButton.Text = "Reach: ON"
		print("Reach Enabled")
	else
		currentReachDistance = NORMAL_REACH
		reachButton.Text = "Reach: OFF"
		print("Reach Disabled")
	end
end

-- RunService loop to check ball position constantly
RunService.Heartbeat:Connect(function()
	if isReachEnabled then
		if isBallInReach() then
			stealBall()
		end
	end
end)

-- Button click toggles Reach ON/OFF
reachButton.MouseButton1Click:Connect(toggleReach)

-- Keybind R toggles Reach ON/OFF, G tries grab (optional)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.R then
		toggleReach()
	end
end)
