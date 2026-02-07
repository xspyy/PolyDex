-- PolyDex v1.0
-- Written by lolxspy#0 || github.com/xspyy
-- SCAMNAPSIA: discord.gg/wXQYe4RHuk

--[[
CURRENT FEATURES;
- browse through the game's instances i guess (we support practically everything)
- properties list (modifiable!!)
- toggle for simplicity
- scroll up/down buttons on both Explorer page and Properties page (they dont have scrolling frames)
]]

local gui = nil
for i,v in pairs(game:GetChildren()) do 
	if v.Name == "PlayerGUI" then
		gui = v
		break
	end
end

local expinst = {}
local selectedinst = nil
local isvisible = true
local escrolloffset = 0
local pscrolloffset = 0

local toggleb = Instance.new("UIButton")
toggleb.PivotPoint = Vector2.New(0, 0)
toggleb.SizeOffset = Vector2.New(30, 30)
toggleb.PositionOffset = Vector2.New(10, 10)
toggleb.PositionRelative = Vector2.New(0, 0)
toggleb.Color = Color.New(0.2, 0.2, 0.2, 1)
toggleb.Text = "PDex"
toggleb.TextColor = Color.New(1, 1, 1, 1)
toggleb.FontSize = 9
toggleb.Parent = gui

local explorerw = Instance.new("UIView")
explorerw.PivotPoint = Vector2.New(0, 0)
explorerw.SizeOffset = Vector2.New(250, 400)
explorerw.PositionOffset = Vector2.New(50, 10)
explorerw.PositionRelative = Vector2.New(0, 0)
explorerw.Color = Color.New(0.15, 0.15, 0.15, 1)
explorerw.BorderColor = Color.New(0.3, 0.3, 0.3, 1)
explorerw.BorderWidth = 2
explorerw.Parent = gui

local explorertitle = Instance.new("UILabel")
explorertitle.PivotPoint = Vector2.New(0, 0)
explorertitle.SizeOffset = Vector2.New(250, 25)
explorertitle.PositionOffset = Vector2.New(0, 0)
explorertitle.PositionRelative = Vector2.New(0, 0)
explorertitle.Color = Color.New(0.2, 0.2, 0.2, 1)
explorertitle.Text = "PolyDex - lolxspy#0"
explorertitle.TextColor = Color.New(1, 1, 1, 1)
explorertitle.FontSize = 14
explorertitle.Parent = explorerw

local econtent = Instance.new("UIView")
econtent.PivotPoint = Vector2.New(0, 0)
econtent.SizeOffset = Vector2.New(250 - 4, 400 - 29)
econtent.PositionOffset = Vector2.New(2, 27)
econtent.PositionRelative = Vector2.New(0, 0)
econtent.Color = Color.New(0.1, 0.1, 0.1, 1)
econtent.ClipDescendants = true
econtent.Parent = explorerw

local propertiesw = Instance.new("UIView")
propertiesw.PivotPoint = Vector2.New(0, 0)
propertiesw.SizeOffset = Vector2.New(250, 400)
propertiesw.PositionOffset = Vector2.New(50 + 250 + 10, 10)
propertiesw.PositionRelative = Vector2.New(0, 0)
propertiesw.Color = Color.New(0.15, 0.15, 0.15, 1)
propertiesw.BorderColor = Color.New(0.3, 0.3, 0.3, 1)
propertiesw.BorderWidth = 2
propertiesw.Parent = gui

local propertiestitle = Instance.new("UILabel")
propertiestitle.PivotPoint = Vector2.New(0, 0)
propertiestitle.SizeOffset = Vector2.New(250, 25)
propertiestitle.PositionOffset = Vector2.New(0, 0)
propertiestitle.PositionRelative = Vector2.New(0, 0)
propertiestitle.Color = Color.New(0.2, 0.2, 0.2, 1)
propertiestitle.Text = "Properties"
propertiestitle.TextColor = Color.New(1, 1, 1, 1)
propertiestitle.FontSize = 14
propertiestitle.Parent = propertiesw

local pcontent = Instance.new("UIView")
pcontent.PivotPoint = Vector2.New(0, 0)
pcontent.SizeOffset = Vector2.New(250 - 4, 400 - 29)
pcontent.PositionOffset = Vector2.New(2, 27)
pcontent.PositionRelative = Vector2.New(0, 0)
pcontent.Color = Color.New(0.1, 0.1, 0.1, 1)
pcontent.ClipDescendants = true
pcontent.Parent = propertiesw

local currenty = 0

function createpageitems(inst, depth)
	local isparent = false
	local howmanychildrendoesbrotatohave = 0
	
	local success, children = pcall(function()
		return inst:GetChildren()
	end)
	
	if success and children then
		howmanychildrendoesbrotatohave = #children
		isparent = howmanychildrendoesbrotatohave > 0
	end
	
	local button = Instance.new("UIButton")
	button.PivotPoint = Vector2.New(0, 0)
	button.SizeOffset = Vector2.New(250 - 4 - (depth * 15), 20)
	button.PositionOffset = Vector2.New(depth * 15, currenty + escrolloffset)
	button.PositionRelative = Vector2.New(0, 0)
	
	if selectedinst == inst then
		button.Color = Color.New(0.3, 0.4, 0.6, 1)
	else
		button.Color = Color.New(0.12, 0.12, 0.12, 1)
	end
	
	button.TextColor = Color.New(1, 1, 1, 1)
	button.FontSize = 11
	button.JustifyText = 0
	
	local arrow = ""
	if isparent then
		arrow = expinst[inst] and "v " or "> "
	else
		arrow = "  "
	end
	
	local displayname = inst.Name or tostring(inst)
	button.Text = arrow .. displayname
	
	button.Parent = econtent
	currenty = currenty + 20
	
	button.Clicked:Connect(function()
		selectedinst = inst
		if isparent then
			expinst[inst] = not expinst[inst]
		end
		refreshpage()
		refreshprops()
	end)
	
	if expinst[inst] and isparent then
		for i, child in pairs(children) do
			createpageitems(child, depth + 1)
		end
	end
end

function refreshpage()
	for i, child in pairs(econtent:GetChildren()) do
		child:Destroy()
	end
	
	currenty = 0
	createpageitems(game, 0)
end

local apidump = {
	GUI = {"Name", "Visible"},
	PlayerGUI = {"Name", "Interactable", "Opacity"},
	UIButton = {"Text", "TextColor", "FontSize", "Font", "AutoSize", "MaxFontSize", "JustifyText", "VerticalAlign", "Interactable", "Visible", "Color", "BorderColor", "BorderWidth", "CornerRadius", "PivotPoint", "PositionOffset", "PositionRelative", "Rotation", "SizeOffset", "SizeRelative", "ClipDescendants"},
	UIField = {"Name", "PivotPoint", "PositionOffset", "PositionRelative", "Rotation", "SizeOffset", "SizeRelative", "Visible", "ClipDescendants"},
	UIHVLayout = {"Name", "ChildAlignment", "ChildControlHeight", "ChildControlWidth", "ChildForceExpandHeight", "ChildForceExpandWidth", "ChildScaleHeight", "ChildScaleWidth", "PaddingBottom", "PaddingLeft", "PaddingRight", "PaddingTop", "ReverseAlignment", "Spacing", "PivotPoint", "PositionOffset", "PositionRelative", "Rotation", "SizeOffset", "SizeRelative", "Visible", "ClipDescendants"},
	UIHorizontalLayout = {"Name", "ChildAlignment", "ChildControlHeight", "ChildControlWidth", "ChildForceExpandHeight", "ChildForceExpandWidth", "ChildScaleHeight", "ChildScaleWidth", "PaddingBottom", "PaddingLeft", "PaddingRight", "PaddingTop", "ReverseAlignment", "Spacing", "PivotPoint", "PositionOffset", "PositionRelative", "Rotation", "SizeOffset", "SizeRelative", "Visible", "ClipDescendants"},
	UIVerticalLayout = {"Name", "ChildAlignment", "ChildControlHeight", "ChildControlWidth", "ChildForceExpandHeight", "ChildForceExpandWidth", "ChildScaleHeight", "ChildScaleWidth", "PaddingBottom", "PaddingLeft", "PaddingRight", "PaddingTop", "ReverseAlignment", "Spacing", "PivotPoint", "PositionOffset", "PositionRelative", "Rotation", "SizeOffset", "SizeRelative", "Visible", "ClipDescendants"},
	UIImage = {"Name", "Color", "ImageID", "ImageType", "Loading", "Clickable", "PivotPoint", "PositionOffset", "PositionRelative", "Rotation", "SizeOffset", "SizeRelative", "Visible", "ClipDescendants"},
	UILabel = {"Text", "TextColor", "FontSize", "Font", "AutoSize", "MaxFontSize", "JustifyText", "VerticalAlign", "Visible", "Color", "BorderColor", "BorderWidth", "CornerRadius", "PivotPoint", "PositionOffset", "PositionRelative", "Rotation", "SizeOffset", "SizeRelative", "ClipDescendants"},
	UITextInput = {"Text", "Placeholder", "PlaceholderColor", "TextColor", "FontSize", "Font", "AutoSize", "MaxFontSize", "JustifyText", "VerticalAlign", "IsReadOnly", "IsMultiline", "Visible", "Color", "BorderColor", "BorderWidth", "CornerRadius", "PivotPoint", "PositionOffset", "PositionRelative", "Rotation", "SizeOffset", "SizeRelative", "ClipDescendants"},
	UIView = {"Color", "BorderColor", "BorderWidth", "CornerRadius", "Visible", "PivotPoint", "PositionOffset", "PositionRelative", "Rotation", "SizeOffset", "SizeRelative", "ClipDescendants"},
	Game = {"GameID", "InstanceCount", "LocalInstanceCount", "PlayersConnected"},
	Environment = {"AutoGenerateNavMesh", "FogColor", "FogEnabled", "FogStartDistance", "FogEndDistance", "Gravity", "PartDestroyHeight", "Skybox"},
	Lighting = {"AmbientColor", "AmbientSource", "SunBrightness", "SunColor", "Shadows"},
	Camera = {"Distance", "FOV", "FastFlySpeed", "FlySpeed", "FollowLerp", "FreeLookSensitivity", "HorizontalSpeed", "IsFirstPerson", "LerpSpeed", "MaxDistance", "MinDistance", "Mode", "Orthographic", "OrthographicSize", "PositionOffset", "RotationOffset", "ScrollSensitivity", "VerticalSpeed", "ClipThroughWalls", "SensitivityMultiplier"},
	Player = {"Name", "Anchored", "CanMove", "ChatColor", "ShirtID", "PantsID", "FaceID", "HeadColor", "Health", "IsAdmin", "IsCreator", "JumpPower", "LeftArmColor", "LeftLegColor", "MaxHealth", "MaxStamina", "RespawnTime", "RightArmColor", "RightLegColor", "SprintSpeed", "Stamina", "StaminaEnabled", "StaminaRegen", "TorsoColor", "UserID", "WalkSpeed"},
	PlayerDefaults = {"ChatColor", "JumpPower", "MaxHealth", "MaxStamina", "RespawnTime", "SprintSpeed", "Stamina", "StaminaEnabled", "StaminaRegen", "WalkSpeed"},
	Players = {"LocalPlayer", "PlayerCollisionEnabled"},
	Part = {"Name", "Anchored", "AngularDrag", "AngularVelocity", "Bounciness", "CanCollide", "CastShadows", "Color", "Drag", "Friction", "Forward", "HideStuds", "IsSpawn", "Mass", "Material", "Shape", "UseGravity", "Velocity", "Size", "Position", "Rotation", "Transparency"},
	MeshPart = {"Name", "Anchored", "AngularVelocity", "AssetID", "CanCollide", "Mass", "Material", "Shape", "Velocity", "CurrentAnimation", "IsAnimationPlaying", "PlayAnimationOnStart", "CollisionType", "Color", "Size", "Position", "Rotation", "Transparency", "CastShadows"},
	Seat = {"Name", "Occupant", "Anchored", "CanCollide", "Color", "Size", "Position", "Rotation", "Transparency", "Material", "Shape"},
	Text3D = {"Name", "Color", "FaceCamera", "Font", "FontSize", "HorizontalAlignment", "Text", "VerticalAlignment", "Position", "Rotation"},
	NPC = {"Name", "Anchored", "FaceID", "Grounded", "HeadColor", "Health", "MoveTarget", "WalkSpeed", "JumpPower", "MaxHealth", "ShirtID", "PantsID", "TorsoColor", "LeftArmColor", "RightArmColor", "LeftLegColor", "RightLegColor", "NavDestinationDistance", "NavDestinationValid", "NavDestinationReached", "Velocity", "Position", "Rotation"},
	Model = {"Name", "Position", "Rotation"},
	Tool = {"Name", "Droppable", "Position", "Rotation"},
	Truss = {"Name", "ClimbSpeed", "Anchored", "CanCollide", "Color", "Size", "Position", "Rotation"},
	Climbable = {"Name", "ClimbSpeed", "Anchored", "CanCollide", "Color", "Size", "Position", "Rotation"},
	Folder = {"Name"},
	Decal = {"Color", "ImageType", "ImageID", "TextureOffset", "TextureScale", "CastShadows", "Position", "Rotation"},
	GradientSky = {"HorizonLineColor", "HorizonLineExponent", "HorizonLineContribution", "SkyGradientTop", "SkyGradientBottom", "SkyGradientExponent", "SunDiscColor", "SunDiscMultiplier", "SunDiscExponent", "SunHaloColor", "SunHaloExponent", "SunHaloContribution"},
	ImageSky = {"BackId", "BottomId", "FrontId", "LeftId", "RightId", "TopId"},
	Particles = {"ImageID", "ImageType", "Color", "ColorMode", "Lifetime", "SizeOverLifetime", "Speed", "EmissionRate", "MaxParticles", "Gravity", "SimulationSpace", "StartRotation", "AngularVelocity", "Autoplay", "Loop", "Duration", "Shape", "ShapeRadius", "ShapeAngle", "ShapeScale", "IsPlaying", "IsPaused", "IsStopped", "ParticleCount", "Time", "TotalTime"},
	PointLight = {"Brightness", "Color", "Range", "Shadows", "Position", "Rotation"},
	SpotLight = {"Angle", "Brightness", "Color", "Range", "Shadows", "Position", "Rotation"},
	SunLight = {"Color", "Brightness", "Shadows"},
	Sound = {"Autoplay", "Loading", "Length", "Loop", "Pitch", "PlayInWorld", "MaxDistance", "Playing", "SoundID", "Time", "Volume", "Position", "Rotation"},
	Bodyposition = {"AcceptanceDistance", "Force", "TargetPosition"},
	ScriptInstance = {"Name", "Code", "Disabled"},
	LocalScript = {"Name", "Code", "Disabled"},
	ModuleScript = {"Name", "Code"},
	BaseScript = {"Name", "Code", "Disabled"},
	NetworkEvent = {"Name"},
	BoolValue = {"Name", "Value"},
	ColorValue = {"Name", "Value"},
	InstanceValue = {"Name", "Value"},
	IntValue = {"Name", "Value"},
	NumberValue = {"Name", "Value"},
	StringValue = {"Name", "Value"},
	Vector3Value = {"Name", "Value"},
	ValueBase = {"Name", "Value"},
	Instance = {"Name", "ClassName", "Parent", "CanReparent", "ClientSpawned"},
	DynamicInstance = {"Name", "Forward", "LocalPosition", "LocalRotation", "LocalSize", "Position", "Right", "Rotation", "Size", "Up", "Quaternion", "LocalQuaternion"},
	Default = {"Name"}
}

function createpropertyeditor(propertyn, currentval, ypos)
	local namelabel = Instance.new("UILabel")
	namelabel.PivotPoint = Vector2.New(0, 0)
	namelabel.SizeOffset = Vector2.New(80, 25)
	namelabel.PositionOffset = Vector2.New(5, ypos + pscrolloffset)
	namelabel.PositionRelative = Vector2.New(0, 0)
	namelabel.Color = Color.New(0.1, 0.1, 0.1, 0)
	namelabel.Text = propertyn
	namelabel.TextColor = Color.New(0.7, 0.7, 0.7, 1)
	namelabel.FontSize = 10
	namelabel.JustifyText = 0
	namelabel.Parent = pcontent
	
	local input = Instance.new("UITextInput")
	input.PivotPoint = Vector2.New(0, 0)
	input.SizeOffset = Vector2.New(250 - 95, 25)
	input.PositionOffset = Vector2.New(90, ypos + pscrolloffset)
	input.PositionRelative = Vector2.New(0, 0)
	input.Color = Color.New(0.2, 0.2, 0.2, 1)
	input.BorderColor = Color.New(0.4, 0.4, 0.4, 1)
	input.BorderWidth = 1
	input.Text = tostring(currentval)
	input.TextColor = Color.New(1, 1, 1, 1)
	input.FontSize = 10
	input.Placeholder = "Enter value..."
	input.PlaceholderColor = Color.New(0.5, 0.5, 0.5, 1)
	input.Parent = pcontent
	
	input.Submitted:Connect(function()
		local newval = input.Text
		local success, err = pcall(function()
			local propt = type(currentval) -- property type
			if newval == "" and propt == "string" then
				selectedinst[propertyn] = ""
				return
			end
			if propt == "number" or currentval == nil or currentval == "" then
				local num = tonumber(newval)
				if num then
					selectedinst[propertyn] = num
				else
					selectedinst[propertyn] = newval
				end
			elseif propt == "boolean" then
				selectedinst[propertyn] = (newval == "true" or newval == "1")
			elseif propt == "string" then
				selectedinst[propertyn] = newval
			else
				selectedinst[propertyn] = newval
			end
		end)
		
		if success then
			refreshprops()
		else
			print("cant update " .. propertyn .. ": " .. tostring(err))
		end
	end)
end

function refreshprops()
	for i, child in pairs(pcontent:GetChildren()) do
		child:Destroy()
	end
	
	if not selectedinst then
		local noSelection = Instance.new("UILabel")
		noSelection.PivotPoint = Vector2.New(0, 0)
		noSelection.SizeOffset = Vector2.New(250 - 4, 30)
		noSelection.PositionOffset = Vector2.New(0, 10 + pscrolloffset)
		noSelection.PositionRelative = Vector2.New(0, 0)
		noSelection.Color = Color.New(0.1, 0.1, 0.1, 0)
		noSelection.Text = "no instance selected"
		noSelection.TextColor = Color.New(0.6, 0.6, 0.6, 1)
		noSelection.FontSize = 11
		noSelection.Parent = pcontent
		return
	end
	
	local ypos = 5
	
	local namelabel = Instance.new("UILabel")
	namelabel.PivotPoint = Vector2.New(0, 0)
	namelabel.SizeOffset = Vector2.New(250 - 4, 20)
	namelabel.PositionOffset = Vector2.New(0, ypos + pscrolloffset)
	namelabel.PositionRelative = Vector2.New(0, 0)
	namelabel.Color = Color.New(0.1, 0.1, 0.1, 0)
	namelabel.Text = "Name: " .. (selectedinst.Name or "N/A")
	namelabel.TextColor = Color.New(1, 1, 0.5, 1)
	namelabel.FontSize = 11
	namelabel.JustifyText = 0
	namelabel.Parent = pcontent
	ypos = ypos + 22
	
	local classlabel = Instance.new("UILabel")
	classlabel.PivotPoint = Vector2.New(0, 0)
	classlabel.SizeOffset = Vector2.New(250 - 4, 20)
	classlabel.PositionOffset = Vector2.New(0, ypos + pscrolloffset)
	classlabel.PositionRelative = Vector2.New(0, 0)
	classlabel.Color = Color.New(0.1, 0.1, 0.1, 0)
	classlabel.Text = "Class: " .. (selectedinst.ClassName or "N/A")
	classlabel.TextColor = Color.New(0.5, 1, 0.5, 1)
	classlabel.FontSize = 11
	classlabel.JustifyText = 0
	classlabel.Parent = pcontent
	ypos = ypos + 30
	
	local divider = Instance.new("UIView")
	divider.PivotPoint = Vector2.New(0, 0)
	divider.SizeOffset = Vector2.New(250 - 10, 1)
	divider.PositionOffset = Vector2.New(5, ypos + pscrolloffset)
	divider.PositionRelative = Vector2.New(0, 0)
	divider.Color = Color.New(0.3, 0.3, 0.3, 1)
	divider.Parent = pcontent
	ypos = ypos + 10
	
	local classssnameeee = selectedinst.ClassName or "Instance"
	local propsToShow = apidump[classssnameeee] or apidump["Instance"] or apidump["Default"]
	
	for _, propertyn in pairs(propsToShow) do
		local success, value = pcall(function()
			return selectedinst[propertyn]
		end)
		if success then
			if value == nil then value = "" end
			createpropertyeditor(propertyn, value, ypos)
			ypos = ypos + 30
		end
	end
end

function visiblitiytoggle() -- i am very shakespearean as you can see
	isvisible = not isvisible
	explorerw.Visible = isvisible
	propertiesw.Visible = isvisible
end

toggleb.Clicked:Connect(function()
	visiblitiytoggle()
end)

refreshpage()
refreshprops()

econtent.MouseDown:Connect(function() end)
pcontent.MouseDown:Connect(function() end)

local explorerscrollup = Instance.new("UIButton")
explorerscrollup.PivotPoint = Vector2.New(0, 0)
explorerscrollup.SizeOffset = Vector2.New(20, 20)
explorerscrollup.PositionOffset = Vector2.New(250 - 22, 27)
explorerscrollup.PositionRelative = Vector2.New(0, 0)
explorerscrollup.Color = Color.New(0.25, 0.25, 0.25, 1)
explorerscrollup.Text = "^"
explorerscrollup.TextColor = Color.New(1, 1, 1, 1)
explorerscrollup.FontSize = 12
explorerscrollup.Parent = explorerw

explorerscrollup.Clicked:Connect(function()
	escrolloffset = escrolloffset + 20
	if escrolloffset > 0 then escrolloffset = 0 end
	refreshpage()
end)

local explorerscrolldown = Instance.new("UIButton")
explorerscrolldown.PivotPoint = Vector2.New(0, 0)
explorerscrolldown.SizeOffset = Vector2.New(20, 20)
explorerscrolldown.PositionOffset = Vector2.New(250 - 22, 400 - 22)
explorerscrolldown.PositionRelative = Vector2.New(0, 0)
explorerscrolldown.Color = Color.New(0.25, 0.25, 0.25, 1)
explorerscrolldown.Text = "v"
explorerscrolldown.TextColor = Color.New(1, 1, 1, 1)
explorerscrolldown.FontSize = 12
explorerscrolldown.Parent = explorerw

explorerscrolldown.Clicked:Connect(function()
	escrolloffset = escrolloffset - 20
	refreshpage()
end)

local propertiesscrollup = Instance.new("UIButton")
propertiesscrollup.PivotPoint = Vector2.New(0, 0)
propertiesscrollup.SizeOffset = Vector2.New(20, 20)
propertiesscrollup.PositionOffset = Vector2.New(250 - 22, 27)
propertiesscrollup.PositionRelative = Vector2.New(0, 0)
propertiesscrollup.Color = Color.New(0.25, 0.25, 0.25, 1)
propertiesscrollup.Text = "^"
propertiesscrollup.TextColor = Color.New(1, 1, 1, 1)
propertiesscrollup.FontSize = 12
propertiesscrollup.Parent = propertiesw

propertiesscrollup.Clicked:Connect(function()
	pscrolloffset = pscrolloffset + 20
	if pscrolloffset > 0 then pscrolloffset = 0 end
	refreshprops()
end)

local propertiesscrolldown = Instance.new("UIButton")
propertiesscrolldown.PivotPoint = Vector2.New(0, 0)
propertiesscrolldown.SizeOffset = Vector2.New(20, 20)
propertiesscrolldown.PositionOffset = Vector2.New(250 - 22, 400 - 22)
propertiesscrolldown.PositionRelative = Vector2.New(0, 0)
propertiesscrolldown.Color = Color.New(0.25, 0.25, 0.25, 1)
propertiesscrolldown.Text = "v"
propertiesscrolldown.TextColor = Color.New(1, 1, 1, 1)
propertiesscrolldown.FontSize = 12
propertiesscrolldown.Parent = propertiesw

propertiesscrolldown.Clicked:Connect(function()
	pscrolloffset = pscrolloffset - 20
	refreshprops()
end)
