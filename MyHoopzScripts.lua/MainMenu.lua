local UserInputService = game:GetService("UserInputService")

local menuGui = script.Parent -- If LocalScript is inside MenuGui
local menuFrame = menuGui:WaitForChild("MenuFrame")

-- Start with UI visible (optional)
menuFrame.Visible = true

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.K then
		menuFrame.Visible = not menuFrame.Visible
	end
end)
