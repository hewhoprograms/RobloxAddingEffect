local AcidSpill = script.Parent
local touchingHumanoids = {}
local DAMAGE = 1;
local INTERVAL = 1/30

local Players = game:GetService("Players")

local function onCharacterAdded(character)
	-- Give them sparkles on their head if they don't have them yet
	if not character:FindFirstChild("Sparkles") then
		local sparkles = Instance.new("Sparkles")
		sparkles.Parent = character:WaitForChild("Head")
	end
end

local function onPlayerAdded(player)
	-- Check if they already spawned in
	if player.Character then
		onCharacterAdded(player.Character)
	end
	-- Listen for the player (re)spawning 
	player.CharacterAdded:Connect(onCharacterAdded)
end

-- Iterate over each player already connected
-- to the game using a generic for-loop
for i, player in pairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end
-- Listen for newly connected players
Players.PlayerAdded:Connect(onPlayerAdded)


function damagePlayer(otherPart)
	local partParent = otherPart.Parent or nil
	local humanoid = partParent:FindFirstChildWhichIsA("Humanoid")
	if not humanoid or humanoid.RootPart == otherPart then return end
	if touchingHumanoids[humanoid] then
		touchingHumanoids[humanoid] += 1
	else
		touchingHumanoids[humanoid] = 1
	end
end

function leavePlayer(otherPart)
	local  partParent = otherPart.Parent
	local  humanoid = partParent:FindFirstChildWhichIsA("Humanoid")
	if not humanoid or humanoid.RootPart == hit then return end
	if touchingHumanoids[humanoid] then
		touchingHumanoids[humanoid] -= 1
		if touchingHumanoids[humanoid] == 0 then
			touchingHumanoids[humanoid] = nil
		end
	end
end

AcidSpill.Touched:Connect(damagePlayer)
AcidSpill.TouchEnded:Connect(leavePlayer)

while true do
	for humanoid in pairs(touchingHumanoids) do
		-- if the humanoid is destroyed, remove it from the loop
		if not humanoid:IsDescendantOf(game) then
			touchingHumanoids[humanoid] = nil
			continue
		end
		humanoid:TakeDamage(DAMAGE)
	end
	task.wait(INTERVAL)
end
