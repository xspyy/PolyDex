-- PolyDex v1.1 || 12/02/2026
-- Written by lolxspy#0 || github.com/xspyy
-- SCAMNAPSIA: discord.gg/wXQYe4RHuk

--[[
CURRENT FEATURES;
V1.0 || 07/02/2026
- browse through the game's instances i guess (we support practically everything)
- properties list (modifiable!!)
- toggle for simplicity
- scroll up/down buttons on both Explorer page and Properties page (they dont have scrolling frames)

V1.1 || 12/02/2026
- dropdown menu
- new layout (sort of)
- search bar on explorer (beautiful, on v1.2 it would be on properties too)
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
local query = "" 

local toggleb = Instance.new("UIButton")
toggleb.PivotPoint = Vector2.New(0.5, 1)
toggleb.PositionRelative = Vector2.New(0.5, 1)
toggleb.PositionOffset = Vector2.New(0, -10)
toggleb.SizeOffset = Vector2.New(80, 30)
toggleb.Color = Color.New(0.2, 0.2, 0.2, 1)
toggleb.Text = "PDex v1.1"
toggleb.TextColor = Color.New(1, 1, 1, 1)
toggleb.FontSize = 12
toggleb.Parent = gui


local dropdownmenu = Instance.new("UIView")
dropdownmenu.PivotPoint = Vector2.New(0.5, 1)
dropdownmenu.PositionRelative = Vector2.New(0.5, 1)
dropdownmenu.PositionOffset = Vector2.New(0, -50)
dropdownmenu.SizeOffset = Vector2.New(120, 130)
dropdownmenu.Color = Color.New(0.15, 0.15, 0.15, 1)
dropdownmenu.BorderColor = Color.New(0.3, 0.3, 0.3, 1)
dropdownmenu.BorderWidth = 2
dropdownmenu.Visible = false
dropdownmenu.Parent = gui

local toplabel = Instance.new("UILabel")
toplabel.PivotPoint = Vector2.New(0, 0)
toplabel.SizeOffset = Vector2.New(116, 25)
toplabel.PositionOffset = Vector2.New(2, 2)
toplabel.PositionRelative = Vector2.New(0, 0)
toplabel.Color = Color.New(0.2, 0.2, 0.2, 1)
toplabel.Text = "lolxspy#0"
toplabel.TextColor = Color.New(1, 1, 1, 1)
toplabel.FontSize = 11
toplabel.Parent = dropdownmenu

local explorerbutton = Instance.new("UIButton")
explorerbutton.PivotPoint = Vector2.New(0, 0)
explorerbutton.SizeOffset = Vector2.New(116, 28)
explorerbutton.PositionOffset = Vector2.New(2, 30)
explorerbutton.PositionRelative = Vector2.New(0, 0)
explorerbutton.Color = Color.New(0.22, 0.22, 0.22, 1)
explorerbutton.Text = "Explorer"
explorerbutton.TextColor = Color.New(1, 1, 1, 1)
explorerbutton.FontSize = 11
explorerbutton.Parent = dropdownmenu

local propertiesbutton = Instance.new("UIButton")
propertiesbutton.PivotPoint = Vector2.New(0, 0)
propertiesbutton.SizeOffset = Vector2.New(116, 28)
propertiesbutton.PositionOffset = Vector2.New(2, 60)
propertiesbutton.PositionRelative = Vector2.New(0, 0)
propertiesbutton.Color = Color.New(0.22, 0.22, 0.22, 1)
propertiesbutton.Text = "Properties"
propertiesbutton.TextColor = Color.New(1, 1, 1, 1)
propertiesbutton.FontSize = 11
propertiesbutton.Parent = dropdownmenu

local closebutton = Instance.new("UIButton")
closebutton.PivotPoint = Vector2.New(0, 0)
closebutton.SizeOffset = Vector2.New(116, 28)
closebutton.PositionOffset = Vector2.New(2, 90)
closebutton.PositionRelative = Vector2.New(0, 0)
closebutton.Color = Color.New(0.6, 0.22, 0.22, 1)
closebutton.Text = "Close"
closebutton.TextColor = Color.New(1, 1, 1, 1)
closebutton.FontSize = 11
closebutton.Parent = dropdownmenu

local explorerw = Instance.new("UIView")
explorerw.PivotPoint = Vector2.New(1, 0)
explorerw.SizeOffset = Vector2.New(300, 350)
explorerw.PositionOffset = Vector2.New(-10, 410)
explorerw.PositionRelative = Vector2.New(1, 0)
explorerw.Color = Color.New(0.15, 0.15, 0.15, 1)
explorerw.BorderColor = Color.New(0.3, 0.3, 0.3, 1)
explorerw.BorderWidth = 2
explorerw.Parent = gui

local explorertitle = Instance.new("UILabel")
explorertitle.PivotPoint = Vector2.New(0, 0)
explorertitle.SizeOffset = Vector2.New(300, 25)
explorertitle.PositionOffset = Vector2.New(0, 0)
explorertitle.PositionRelative = Vector2.New(0, 0)
explorertitle.Color = Color.New(0.2, 0.2, 0.2, 1)
explorertitle.Text = "Explorer"
explorertitle.TextColor = Color.New(1, 1, 1, 1)
explorertitle.FontSize = 14
explorertitle.Parent = explorerw

local searchbar = Instance.new("UITextInput")
searchbar.PivotPoint = Vector2.New(0, 0)
searchbar.SizeOffset = Vector2.New(300 - 4, 25)
searchbar.PositionOffset = Vector2.New(2, 27)
searchbar.PositionRelative = Vector2.New(0, 0)
searchbar.Color = Color.New(0.12, 0.12, 0.12, 1)
searchbar.BorderColor = Color.New(0.4, 0.4, 0.4, 1)
searchbar.BorderWidth = 1
searchbar.Text = ""
searchbar.TextColor = Color.New(1, 1, 1, 1)
searchbar.FontSize = 10
searchbar.Placeholder = "Search..."
searchbar.PlaceholderColor = Color.New(0.5, 0.5, 0.5, 1)
searchbar.Parent = explorerw

searchbar.Changed:Connect(function()
	query = searchbar.Text:lower()
	refreshpage()
end)

local econtent = Instance.new("UIView")
econtent.PivotPoint = Vector2.New(0, 0)
econtent.SizeOffset = Vector2.New(300 - 4, 350 - 56)
econtent.PositionOffset = Vector2.New(2, 54)
econtent.PositionRelative = Vector2.New(0, 0)
econtent.Color = Color.New(0.1, 0.1, 0.1, 1)
econtent.ClipDescendants = true
econtent.Parent = explorerw

local propertiesw = Instance.new("UIView")
propertiesw.PivotPoint = Vector2.New(1, 0)
propertiesw.SizeOffset = Vector2.New(300, 350)
propertiesw.PositionOffset = Vector2.New(-10, 50)
propertiesw.PositionRelative = Vector2.New(1, 0)
propertiesw.Color = Color.New(0.15, 0.15, 0.15, 1)
propertiesw.BorderColor = Color.New(0.3, 0.3, 0.3, 1)
propertiesw.BorderWidth = 2
propertiesw.Parent = gui

local propertiestitle = Instance.new("UILabel")
propertiestitle.PivotPoint = Vector2.New(0, 0)
propertiestitle.SizeOffset = Vector2.New(300, 25)
propertiestitle.PositionOffset = Vector2.New(0, 0)
propertiestitle.PositionRelative = Vector2.New(0, 0)
propertiestitle.Color = Color.New(0.2, 0.2, 0.2, 1)
propertiestitle.Text = "Properties"
propertiestitle.TextColor = Color.New(1, 1, 1, 1)
propertiestitle.FontSize = 14
propertiestitle.Parent = propertiesw

local pcontent = Instance.new("UIView")
pcontent.PivotPoint = Vector2.New(0, 0)
pcontent.SizeOffset = Vector2.New(300 - 4, 300 - 29)
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
	
	local displayname = inst.Name or tostring(inst)
	local shouldshow = true
	
	if query ~= "" then
		shouldshow = displayname:lower():find(query) ~= nil
	end
	
	if shouldshow then
		local button = Instance.new("UIButton")
		button.PivotPoint = Vector2.New(0, 1)
		button.SizeOffset = Vector2.New(300 - 4 - (depth * 15), 20)
		button.PositionOffset = Vector2.New(depth * 15, -currenty + escrolloffset)
		button.PositionRelative = Vector2.New(0, 1)
		
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
	end
	
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
	namelabel.SizeOffset = Vector2.New(100, 25)
	namelabel.PositionOffset = Vector2.New(5, ypos - pscrolloffset)
	namelabel.PositionRelative = Vector2.New(0, 0)
	namelabel.Color = Color.New(0.1, 0.1, 0.1, 0)
	namelabel.Text = propertyn
	namelabel.TextColor = Color.New(0.7, 0.7, 0.7, 1)
	namelabel.FontSize = 10
	namelabel.JustifyText = 0
	namelabel.Parent = pcontent
	
	local input = Instance.new("UITextInput")
	input.PivotPoint = Vector2.New(0, 0)
	input.SizeOffset = Vector2.New(300 - 115, 25)
	input.PositionOffset = Vector2.New(110, ypos - pscrolloffset)
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
		local noselection = Instance.new("UILabel")
		noselection.PivotPoint = Vector2.New(0, 0)
		noselection.SizeOffset = Vector2.New(300 - 4, 30)
		noselection.PositionOffset = Vector2.New(0, 10 - pscrolloffset)
		noselection.PositionRelative = Vector2.New(0, 0)
		noselection.Color = Color.New(0.1, 0.1, 0.1, 0)
		noselection.Text = "no instance selected"
		noselection.TextColor = Color.New(0.6, 0.6, 0.6, 1)
		noselection.FontSize = 11
		noselection.Parent = pcontent
		return
	end
	
	local ypos = 5
	
	local namelabel = Instance.new("UILabel")
	namelabel.PivotPoint = Vector2.New(0, 0)
	namelabel.SizeOffset = Vector2.New(300 - 4, 20)
	namelabel.PositionOffset = Vector2.New(0, ypos - pscrolloffset)
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
	classlabel.SizeOffset = Vector2.New(300 - 4, 20)
	classlabel.PositionOffset = Vector2.New(0, ypos - pscrolloffset)
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
	divider.SizeOffset = Vector2.New(300 - 10, 1)
	divider.PositionOffset = Vector2.New(5, ypos - pscrolloffset)
	divider.PositionRelative = Vector2.New(0, 0)
	divider.Color = Color.New(0.3, 0.3, 0.3, 1)
	divider.Parent = pcontent
	ypos = ypos + 10
	
	local classssnameeee = selectedinst.ClassName or "Instance"
	local propstoshow = apidump[classssnameeee] or apidump["Instance"] or apidump["Default"]
	
	for _, propertyn in pairs(propstoshow) do
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

toggleb.Clicked:Connect(function()
	dropdownmenu.Visible = not dropdownmenu.Visible
end)

explorerbutton.Clicked:Connect(function()
	explorerw.Visible = not explorerw.Visible
	dropdownmenu.Visible = false
end)

propertiesbutton.Clicked:Connect(function()
	propertiesw.Visible = not propertiesw.Visible
	dropdownmenu.Visible = false
end)

closebutton.Clicked:Connect(function()
	toggleb:Destroy()
	dropdownmenu:Destroy()
	explorerw:Destroy()
	propertiesw:Destroy()
end)

refreshpage()
refreshprops()

econtent.MouseDown:Connect(function() end)
pcontent.MouseDown:Connect(function() end)

local explorerscrolldown = Instance.new("UIButton")
explorerscrolldown.PivotPoint = Vector2.New(0, 0)
explorerscrolldown.SizeOffset = Vector2.New(20, 20)
explorerscrolldown.PositionOffset = Vector2.New(300 - 22, 27)
explorerscrolldown.PositionRelative = Vector2.New(0, 0)
explorerscrolldown.Color = Color.New(0.25, 0.25, 0.25, 1)
explorerscrolldown.Text = "v"
explorerscrolldown.TextColor = Color.New(1, 1, 1, 1)
explorerscrolldown.FontSize = 12
explorerscrolldown.Parent = explorerw

explorerscrolldown.Clicked:Connect(function()
	escrolloffset = escrolloffset + 20
	if escrolloffset < 0 then escrolloffset = 0 end
	refreshpage()
end)

local explorerscrollup = Instance.new("UIButton")
explorerscrollup.PivotPoint = Vector2.New(0, 0)
explorerscrollup.SizeOffset = Vector2.New(20, 20)
explorerscrollup.PositionOffset = Vector2.New(300 - 22, 350 - 22)
explorerscrollup.PositionRelative = Vector2.New(0, 0)
explorerscrollup.Color = Color.New(0.25, 0.25, 0.25, 1)
explorerscrollup.Text = "^"
explorerscrollup.TextColor = Color.New(1, 1, 1, 1)
explorerscrollup.FontSize = 12
explorerscrollup.Parent = explorerw

explorerscrollup.Clicked:Connect(function()
	escrolloffset = escrolloffset - 20
	refreshpage()
end)

local propertiesscrolldown = Instance.new("UIButton")
propertiesscrolldown.PivotPoint = Vector2.New(0, 0)
propertiesscrolldown.SizeOffset = Vector2.New(20, 20)
propertiesscrolldown.PositionOffset = Vector2.New(300 - 22, 27)
propertiesscrolldown.PositionRelative = Vector2.New(0, 0)
propertiesscrolldown.Color = Color.New(0.25, 0.25, 0.25, 1)
propertiesscrolldown.Text = "v"
propertiesscrolldown.TextColor = Color.New(1, 1, 1, 1)
propertiesscrolldown.FontSize = 12
propertiesscrolldown.Parent = propertiesw

propertiesscrolldown.Clicked:Connect(function()
	pscrolloffset = pscrolloffset - 20
	if pscrolloffset < 0 then pscrolloffset = 0 end
	refreshprops()
end)

local propertiesscrollup = Instance.new("UIButton")
propertiesscrollup.PivotPoint = Vector2.New(0, 0)
propertiesscrollup.SizeOffset = Vector2.New(20, 20)
propertiesscrollup.PositionOffset = Vector2.New(300 - 22, 300 - 22)
propertiesscrollup.PositionRelative = Vector2.New(0, 0)
propertiesscrollup.Color = Color.New(0.25, 0.25, 0.25, 1)
propertiesscrollup.Text = "^"
propertiesscrollup.TextColor = Color.New(1, 1, 1, 1)
propertiesscrollup.FontSize = 12
propertiesscrollup.Parent = propertiesw

propertiesscrollup.Clicked:Connect(function()
	pscrolloffset = pscrolloffset + 20
	refreshprops()
end)
