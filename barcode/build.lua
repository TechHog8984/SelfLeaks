-- a build of barcode from March 25th 2023
-- I had nothing to do with the "extras" tab (that was handled by the owners), so the autofarm you see never went into production
-- and nothing in the extras tab will be in here

-- the build file is a result of taking the main.lua file and replacing `require` calls with the source of the module file

if game:GetService("CoreGui"):FindFirstChild("BC_Loading") then
    game:GetService("CoreGui").BC_Loading:Destroy();
end;

local OldBarcodeC = shared.BarcodeC;
if OldBarcodeC then
    shared.BarcodeC = nil;
    repeat task.wait() until OldBarcodeC.Loaded or OldBarcodeC.Failed;
    OldBarcodeC:Stop();
    repeat task.wait() until OldBarcodeC.Stopped;
end;

local game = game;
local PlaceId = game.PlaceId;
local FFC = game.FindFirstChild;
local FFCWhichIsA = game.FindFirstChildWhichIsA;
local function WFC(Parent, Name, MaxTime)
    MaxTime = MaxTime or 5;
    local TimeElapsed = 0;
    local Child;
    while not Child do
        TimeElapsed += 1;
        Child = FFC(Parent, Name);
        if TimeElapsed >= MaxTime then return Child;end;
        wait(1);
    end;
    return Child;
end;

local RunService = game:GetService("RunService");
local RenderStepped = RunService.RenderStepped;
local Heartbeat = RunService.Heartbeat;

local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;
local GetPlayers = Players.GetPlayers;

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Remotes = ReplicatedStorage.Remotes;
local ThrowKnife = Remotes.ThrowKnife;
local HideTarget = Remotes.HideTarget;
local UpdateTarget = Remotes.UpdateTarget;
local KnifeCountdown = Remotes.KnifeCountdown;

local BACFolder = ReplicatedStorage.BAC;
local NetworkModule = BACFolder.Network;
local CharacterModule = BACFolder.Characters;

local ReeScript = LocalPlayer.PlayerScripts.reeeee;
local LocalKnifeHandler = LocalPlayer.PlayerScripts.localknifehandler;
local FindPartOnRayWithIgnoreList = workspace.FindPartOnRayWithIgnoreList;

local KnifeHost = workspace.KnifeHost;

local UIS = game:GetService("UserInputService");
local GML = UIS.GetMouseLocation;

local Camera = workspace.CurrentCamera;
local WorldToViewportPoint = Camera.WorldToViewportPoint;

local Vector2New = Vector2.new;

local function SpaceToVector2(Space)
    local Pos, IsVisible = WorldToViewportPoint(Camera, Space);

    return Vector2New(Pos.X, Pos.Y), IsVisible, Pos.Z;
end;

local TargetObject = LocalPlayer:WaitForChild("PlayerGui").ScreenGui.UI.Target;
local TargetText = TargetObject.TargetText;

local VotePad = workspace.Lobby.VoteStation.pad3;

local DefaultConfig = {
    SilentAim = false,
    SilentAimEnemy = "ClosestPlayerToMouse",

    HBE = false,
    HBE_Size = Vector3.new(3,3,3),
    HBE_Transparency = 0.75,
    HBE_Color = Color3.new(163, 162, 165),
    HBE_Target = false,
    HBE_TargetSize = Vector3.new(3,3,3),
    HBE_TargetTransparency = 0.75,
    HBE_TargetColor = Color3.new(163, 162, 165),

    AutoEquip = false,
    AutoThrow = false,
    AutoThrowEnemy = "Target/Bounty",

    ChatColor = Color3.new(1,1,1),
    ChatVipTag = false,
    ChatText = "Coconut on top!",
    ChatSpam = false,

    BaseEspColor = Color3.new(1,1,1),
    TargetEspColor = Color3.new(1, 0, 0),
    EspKnives = false;
};

local function Clone(t)
    local c = {};

    for k,v in next, t do
        c[k] = v;
    end;

    return c;
end;

local BarcodeC = {
    OLD = OldBarcodeC,
    IsFreeplay = PlaceId == 5006801542,
    IsClassic = PlaceId == 379614936,

    Active = true,
    Loaded = false,
    
    UseDebugURL = true,
    Debug = true,

    Connections = {},
    DefaultConfig = DefaultConfig,
    AutoFarmStabCooldowns = {},
    
    RunService = RunService,
    RenderStepped = RenderStepped,
    Heartbeat = Heartbeat,

    FFC = FFC,
    FFCWhichIsA = FFCWhichIsA,
    WFC = WFC,
    Players = Players,
    LocalPlayer = LocalPlayer,
    LocalCharacter = LocalPlayer.Character,
    GetPlayers = GetPlayers,

    Remotes = Remotes,
    ThrowKnife = ThrowKnife,
    HideTarget = HideTarget,
    UpdateTarget = UpdateTarget,
    KnifeCountdown = KnifeCountdown,

    BACFolder = BACFolder,
    NetworkModule = NetworkModule,
    CharacterModule = CharacterModule,

    ReeScript = ReeScript,
    LocalKnifeHandler = LocalKnifeHandler,
    FindPartOnRayWithIgnoreList = FindPartOnRayWithIgnoreList,

    KnifeHost = KnifeHost,

    UIS = UIS,
    GML = GML,

    Camera = Camera,
    WorldToViewportPoint = WorldToViewportPoint,
    Vectro2New = Vector2New,
    SpaceToVector2 = SpaceToVector2,

    TargetObject = TargetObject,
    TargetText = TargetText,

    VotePad = VotePad.Position,

    Stop = function(BarcodeC)
        BarcodeC.Active = false;
        if BarcodeC.wrapFunc and BarcodeC.CoroutineIndex then
            debug.setconstant(BarcodeC.wrapFunc, BarcodeC.CoroutineIndex, "coroutine");
            getfenv(BarcodeC.wrapFunc)[BarcodeC.coroutineName] = nil;
        end;

        if BarcodeC.UIWindow then
            BarcodeC.UIWindow:Destroy();
            BarcodeC.UIWindow = nil;
        end;

        if BarcodeC.Esp then
            BarcodeC.Esp.Destroy();
            BarcodeC.Esp = nil;
        end;

        BarcodeC.Config.HBE=false;
        if BarcodeC.HBE_StatusChanged then 
            BarcodeC.HBE_StatusChanged();
            BarcodeC.HBE_StatusChanged = nil;
        end;

        for I, Con in next, BarcodeC.Connections do
            pcall(Con.Disconnect, Con);
        end;

        BarcodeC.Stopped = true;
    end,
    Clone = Clone,
    scall = function(func, ...)
        local args = {...};
        local results = {};

        task.spawn(function()
            syn.set_thread_identity(2);
            results = {func(table.unpack(args))};
        end);

        repeat task.wait() until results;
        return table.unpack(results);
    end;
};
shared.BarcodeC = BarcodeC;
table.insert(BarcodeC.Connections, LocalPlayer.CharacterAdded:Connect(function(Character)
    if BarcodeC.Fly then BarcodeC.Fly.Disable();end;
    BarcodeC.LocalCharacter = Character;
end));
table.insert(BarcodeC.Connections, LocalPlayer.CharacterRemoving:Connect(function()
    BarcodeC.LocalCharacter = nil
end));


local HttpService = game:GetService("HttpService");
local UrlEncode = HttpService.UrlEncode;

local BaseModuleURL = "http://195.201.235.194:8082/modules/";
if BarcodeC.UseDebugURL then
    warn("USING DEBUG URL");
    BaseModuleURL = "http://localhost:3222/modules/";
end;

local function Encode(str)
    return UrlEncode(HttpService, str);
end;

local HttpGet = game.HttpGet;
local function fetchModule(module)
    if type(BarcodeC) ~= "table" or not BarcodeC.Active then return;end;
    local url = BaseModuleURL .. Encode(module);

    local Suc, Res = pcall(HttpGet, game, url);
    local ValidRes = type(Res) == "string" and #Res > 0;
    if Suc and ValidRes then
        if (Res:match("%[Errno")) then
            return false, "[HttpGet]: " .. Res;
        end;
        return true, Res;
    elseif ValidRes then
        return false, "[HttpGet]: " .. Res;
    else
        return false, "[HttpGet]: Unknown(likely invalid url. CHECK IF SERVER IS RUNNING)";
    end;
end;
BarcodeC.fetchModule = fetchModule;
local function require2(module)
    if type(BarcodeC) ~= "table" or not BarcodeC.Active then return;end;
    if BarcodeC.Debug then
        print("requiring " .. module);
    end;
    local Suc, Suc2, Res = pcall(fetchModule, module);
    if Suc then
        local ValidRes = type(Res) == "string" and #Res > 0;
        if Suc2 and ValidRes then
            Suc, Res, Res2 = pcall(loadstring, Res);
            if Suc and type(Res) == "function" then
                getfenv(Res)["BarcodeC"] = BarcodeC;

                local Results = {pcall(Res)};
                if Results[1] then
                    return select(2, unpack(Results));
                else
                    BarcodeC.Failed = true;
                    return error("[chunk from loadstring]: " .. tostring(Results[2]));
                end;
            else
                BarcodeC.Failed = true;
                return error("[loadstring]: " .. tostring(Res2 or Res));
            end;
        elseif ValidRes then
            BarcodeC.Failed = true;
            return error("[fetchModule]: " .. tostring(Res));
        else
            BarcodeC.Failed = true;
            return error("[fetchModule]: Unknown");
        end;
    elseif type(Suc2) == "string" and #Suc2 > 0 then
        BarcodeC.Failed = true;
        return error("[fetchModule]: " .. Suc2);
    else
        BarcodeC.Failed = true;
        return error("[fetchModule]: Unknown");
    end;
end;
BarcodeC.require = require;

local OldTime = os.time();

BarcodeC.SelectConfig = --[[config.lua]](function()
	local GetConfig = shared.GetConfig or loadstring(game:HttpGet"https://gitlab.com/te4224/Scripts/-/raw/main/Chrysalism/V1/confighandler.lua")();
	assert(type(GetConfig) == "function", "Failed to get GetConfig.");
	
	local function ApplyDefaultsToConfig(Config)
	
	    for k,v in next, BarcodeC.DefaultConfig do
	        local t = typeof(v);
	        local t2 = typeof(Config[k]);
	
	        if t ~= t2 then
	            Config[k] = v;
	        end;
	    end;
	
	    return Config;
	
	end;
	-- local function LoadConfig(Path)
	--     if type(Path) ~= "string" then return;end;
	
	--     local Config = GetConfig("BarcodeC/configs/" .. Path);
	--     BarcodeC.Config = Config;
	
	--     return Config;
	-- end;
	
	-- local function SaveConfig(Path)
	
	--     if type(Path) ~= "string" then return;end;
	
	--     --get config, creating if it doesn't exist
	--     local c = GetConfig("BarcodeC/configs/" .. Path);
	--     --save to config
	--     for k,v in next, BarcodeC.Config.__iter do
	--         c[k] = v;
	--     end;
	
	--     return Config;
	
	-- end;
	
	-- local function SelectConfig(Path)
	
	--     if type(Path) ~= "string" then return;end;
	
	--     --get config, creating if it doesn't exist
	--     local c = GetConfig("BarcodeC/configs/" .. Path);
	--     ApplyDefaultsToConfig(c);
	--     BarcodeC.Config = c;
	
	--     for K, V in next, c do
	
	--         if BarcodeC.DefaultConfig[K] == V then continue;end;
	
	--         if K == "SilentAim" then
	--             BarcodeC.SilentAimToggle:UpdateStatus(V);
	--         elseif K == "SilentAimEnemy" then
	--             BarcodeC.SilentAimEnemyDropdown:SelectItem(V);
	        
	--         elseif K == "HBE" then
	--             BarcodeC.HBE_EnabledToggle:UpdateStatus(V);
	--         elseif K == "HBE_Size" then
	--             BarcodeC.HBE_SizeSlider:Update
	--         end;
	
	--     end;
	
	--     return c;
	    
	-- end;
	
	-- local Config, ChangedEvent = GetConfig("BarcodeC/main.config");
	-- ApplyDefaultsToConfig(Config);
	-- BarcodeC.Config = Config;
	-- BarcodeC.ConfigChanged = ChangedEvent;
	
	BarcodeC.Config = BarcodeC.Clone(BarcodeC.DefaultConfig);
	return SelectConfig--[[LoadConfig, SaveConfig]];
	
end)();

BarcodeC.Collection = getgc(false);

BarcodeC.loadingUI = --[[loadingUI.lua]](function()
	--GuiToLua V3
	
	--objects
	local Loader = Instance.new'ScreenGui'
	
	local Main = Instance.new'Frame'
	local MainCorner = Instance.new'UICorner'
	local MainHeader = Instance.new'Frame'
	local headerCover = Instance.new'UICorner'
	local coverup = Instance.new'Frame'
	local title = Instance.new'TextLabel'
	local close = Instance.new'ImageButton'
	local body = Instance.new'TextLabel'
	
	--properties
	Loader.IgnoreGuiInset = true
	Loader.Name = "BC_Loading"
	syn.protect_gui(Loader);
	Loader.Parent = game:GetService("CoreGui")
	Loader.ResetOnSpawn = false
	Loader.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	
	Main.BackgroundColor3 = Color3.fromRGB(10.000000353902578, 10.000000353902578, 10.000000353902578)
	Main.Name = "Main"
	Main.Parent = Loader
	Main.Position = UDim2.new(0.5, -127, 0.5, -77)
	Main.Size = UDim2.new(0, 254, 0, 154)
	Main.ClipsDescendants = true
	
	MainCorner.CornerRadius = UDim.new(0, 4)
	MainCorner.Name = "MainCorner"
	MainCorner.Parent = Main
	
	MainHeader.BackgroundColor3 = Color3.fromRGB(5.000000176951289, 5.000000176951289, 5.000000176951289)
	MainHeader.Name = "MainHeader"
	MainHeader.Parent = Main
	MainHeader.Size = UDim2.new(1, 0, 0, 29)
	
	headerCover.CornerRadius = UDim.new(0, 4)
	headerCover.Name = "headerCover"
	headerCover.Parent = MainHeader
	
	coverup.BackgroundColor3 = Color3.fromRGB(5.000000176951289, 5.000000176951289, 5.000000176951289)
	coverup.BorderSizePixel = 0
	coverup.Name = "coverup"
	coverup.Parent = MainHeader
	coverup.Position = UDim2.new(0, 0, 0.7586206793785095, 0)
	coverup.Size = UDim2.new(1, 0, 0, 7)
	
	title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	title.BackgroundTransparency = 1
	title.BorderSizePixel = 0
	title.Name = "title"
	title.Parent = MainHeader
	title.Position = UDim2.new(0.028953973203897476, 0, 0.13793103396892548, 0)
	title.Size = UDim2.new(0, 204, 0, 22)
	title.Font = Enum.Font.Gotham
	title.RichText = true
	title.Text = "Barcode[+] X Coconut"
	title.TextColor3 = Color3.fromRGB(245.00000059604645, 245.00000059604645, 245.00000059604645)
	title.TextSize = 16
	title.TextXAlignment = Enum.TextXAlignment.Left
	
	close.BackgroundTransparency = 1
	close.Name = "close"
	close.Parent = MainHeader
	close.Position = UDim2.new(1, -26, 0, 5)
	close.Size = UDim2.new(0, 21, 0, 21)
	close.ZIndex = 2
	close.Image = "rbxassetid://3926305904"
	close.ImageRectOffset = Vector2.new(284, 4)
	close.ImageRectSize = Vector2.new(24, 24)
	
	body.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	body.BackgroundTransparency = 1
	body.BorderSizePixel = 0
	body.Name = "body"
	body.Parent = Main
	body.Position = UDim2.new(0.09588310122489929, 0, 0.4236453175544739, 0)
	body.Size = UDim2.new(0, 204, 0, 22)
	body.Font = Enum.Font.Gotham
	body.RichText = true
	body.Text = "Loading..."
	body.TextColor3 = Color3.fromRGB(245.00000059604645, 245.00000059604645, 245.00000059604645)
	body.TextSize = 16
	
	local function round(n)
	    local s = tostring(n);
	    local split = s:split(".");
	    if split and split[2] then
	        if #split[2] > 4 then
	            return s:sub(1, -3);
	        end;
	    end;
	    return s;
	end;
	
	task.spawn(function()
	    local Dots = 0;
	    while not BarcodeC.LoadingTimeTaken and not BarcodeC.Loaded and Loader and Loader.Parent and body and body.Parent do
	        Dots += 1;
	        if Dots > 3 then
	            Dots = 1;
	        end;
	
	        body.Text = "Loading".. ("."):rep(Dots);
	
	        wait(1);
	    end;
	    body.Text = "Loaded! Time taken: " .. round(BarcodeC.LoadingTimeTaken) .. "s";
	end);
	
	return Loader;
	
end)();
BarcodeC.getCharacter = --[[getCharacter.lua]](function()
	local workspace = workspace;
	
	return function(Value)
	    local Name;
	    if typeof(Value) == "Instance" then
	        if Value.ClassName == "Model" then
	            return Value;
	        elseif Value.ClassName == "Player" then
	            Name = Value.Name;
	        end;
	    end;
	    if type(Value) == "string" then
	        Name = Value;
	    end;
	
	    return Name and BarcodeC.FFC(workspace, Name);
	end;
	
end)();

BarcodeC.getKnifeFromCharacter, BarcodeC.getKnifeFromBackpack, BarcodeC.getKnife, BarcodeC.equipKnife = --[[knife.lua]](function()
	local function getKnifeFromCharacter(Character)
	    local Char = Character or BarcodeC.LocalCharacter;
	    if Char then
	        local Knife = BarcodeC.FFC(Char, "Knife");
	        if Knife then return Knife; end;
	    end;
	end;
	
	local function getKnifeFromBackpack()
	    local Backpack = BarcodeC.FFC(BarcodeC.LocalPlayer, "Backpack");
	    if Backpack then
	        local Knife = BarcodeC.FFC(Backpack, "Knife");
	        if Knife then return Knife; end;
	    end;
	end;
	
	local function getKnife(Character, CheckBackpack)
	    return getKnifeFromCharacter(Character) or getKnifeFromBackpack();
	end;
	
	local function equipKnife()
	    local BKnife = getKnifeFromBackpack();if BKnife then
	        BarcodeC.FFC(BarcodeC.LocalCharacter, "Humanoid"):EquipTool(BKnife);
	    end;
	end;
	
	return getKnifeFromCharacter, getKnifeFromBackpack, getKnife, equipKnife;
	
end)();
BarcodeC.checkKnife = --[[checkKnife.lua]](function()
	local function checkKnife()
	    local CKnife = BarcodeC.getKnifeFromCharacter();
	    local Handle = CKnife and BarcodeC.FFC(CKnife, "Handle");
	    local DecorationHandle = Handle and BarcodeC.FFC(Handle, "KnifeDecorationHandle");
	    return typeof(DecorationHandle) == "Instance" and DecorationHandle.Transparency == 0;
	end;
	
	-- table.insert(BarcodeC.Connections, BarcodeC.Heartbeat:Connect(function()
	--     if type(BarcodeC) == "table" then
	--         local LocalHRP = BarcodeC.LocalCharacter and BarcodeC.FFC(BarcodeC.LocalCharacter, "HumanoidRootPart");if typeof(LocalHRP) == "Instance" then
	--             BarcodeC.ValidKnife = checkKnife();
	--         end;
	--     end;
	-- end));
	
	local function knifeAdded(Knife)
	    local DecHandle = Knife:WaitForChild("Handle"):WaitForChild("KnifeDecorationHandle");
	    BarcodeC.ValidKnife = DecHandle.Transparency == 0;
	    DecHandle:GetPropertyChangedSignal("Transparency"):Connect(function()
	        BarcodeC.ValidKnife = DecHandle.Transparency == 0;
	    end);
	end;
	
	local function CharacterAdded(Character)
	    if typeof(Character) ~= "Instance" then return;end;
	    local ChildAddedCon; ChildAddedCon = Character.ChildAdded:Connect(function(Child)
	        if Child.Name ~= "Knife" then
	            return;
	        end;
	
	        knifeAdded(Child);
	        ChildAddedCon:Disconnect();
	    end);
	end;
	CharacterAdded(BarcodeC.LocalCharacter);
	table.insert(BarcodeC.Connections, BarcodeC.LocalPlayer.CharacterAdded:Connect(CharacterAdded));
	
	return checkKnife;
	
end)();
BarcodeC.fireRemote = --[[fireRemote.lua]](function()
	local scall = BarcodeC.scall;
	
	local Network = require(BarcodeC.NetworkModule);
	local NetworkMT = getrawmetatable(Network);
	local NetworkMT__Index = NetworkMT.__index;
	
	local FireServer = scall(NetworkMT__Index, BarcodeC.NetworkModule, Network, "FireServer") -- same as "Network.FireServer"
	local function fireRemote(...)
	    return scall(FireServer, BarcodeC.NetworkModule, ...);   -- same as "Network.FireServer(...)"
	end;
	
	return fireRemote;
	
end)();
BarcodeC.throwAt = --[[throwAt.lua]](function()
	local OFFSET = Vector3.new(0, 2, 0);
	local SpeedCFrame = CFrame.new(0, 0, 0, 1e8, 1e8, 1e8, 1e8, 1e8, 1e8, 1e8, 1e8, 1e8);
	
	return function(Player, IsAutoThrow)
	    if Player == BarcodeC.LocalPlayer then return;end;
	    local LocalHRP = BarcodeC.LocalCharacter and BarcodeC.FFC(BarcodeC.LocalCharacter, "HumanoidRootPart");
	    if LocalHRP then
	        local Character = BarcodeC.getCharacter(Player);
	        local Hitbox = Character and BarcodeC.FFC(Character, "baseHitbox");
	        if Hitbox then
	            if IsAutoThrow and BarcodeC.AutoThrowCooldown then return;end;
	            BarcodeC.ThrowKnife:FireServer(Hitbox.Position + OFFSET, 0, SpeedCFrame);
	            return Hitbox;
	        end;
	    end;
	end;
	
end)();
BarcodeC.killPlayer = --[[killPlayer.lua]](function()
	local OFFSET = Vector3.new(0, 2, 0);
	local COOLDOWN = false;
	
	return function(Player, IsAutoThrow)
	    if COOLDOWN then
	        return;
	    end;
	    local Hitbox = BarcodeC.throwAt(Player, IsAutoThrow);if Hitbox then
	        -- task.spawn(function()
	            repeat wait() until BarcodeC.KillKnife;
	            COOLDOWN = true;
	            local KillKnife = BarcodeC.KillKnife;
	            -- KillKnife.Position = Hitbox.Position - OFFSET;
	            BarcodeC.fireRemote("kill", Player, newproxy(), KillKnife.Name, "throw", (KillKnife.Position - Hitbox.Position).Magnitude, "baseHitbox", Hitbox.Size, Hitbox.Position - OFFSET);
	            BarcodeC.KillKnife = nil;
	            task.wait(1.5);
	            COOLDOWN = false;
	        -- end);
	    end;
	end;
	
end)();
BarcodeC.stabPlayer = --[[stabPlayer.lua]](function()
	local COOLDOWN = false;
	
	return function(Player)
	    if COOLDOWN then
	        return;
	    end;
	    COOLDOWN = true;
	    pcall(BarcodeC.fireRemote, "kill", Player, newproxy(), nil, "stab");
	    task.wait(1);
	    COOLDOWN = false;
	end;
	
end)();

BarcodeC.playTween, BarcodeC.createTween = --[[tween.lua]](function()
	local TweenService = game:GetService("TweenService");
	local Create = TweenService.Create;
	local Play;
	local p=Instance.new("Part");local t=Create(TweenService, p, TweenInfo.new(0), {Transparency=1});Play=t.Play;p:Destroy();
	
	local function createTween(...)
	    return Create(TweenService, ...);
	end;
	local function playTween(...)
	    local tween;
	    if #{...} == 1 then 
	        tween = (...); 
	    else
	        tween = createTween(...);
	    end;
	    Play(tween);
	end;
	
	return playTween, createTween;
	
end)();

--[[closestPlayerToMouse.lua]](function()
	table.insert(BarcodeC.Connections, BarcodeC.RenderStepped:Connect(function()
	    BarcodeC.ClosestPlayerToMouseDistance = math.huge;
	    local MouseLocation = BarcodeC.GML(BarcodeC.UIS);
	    for I, Player in next, BarcodeC.GetPlayers(BarcodeC.Players) do
	        if typeof(Player) == "Instance" and Player ~= BarcodeC.LocalPlayer then
	            local C = BarcodeC.getCharacter(Player);
	            local HRP = C and BarcodeC.FFC(C, "HumanoidRootPart");
	
	            if typeof(HRP) == "Instance" then
	                if BarcodeC.FFCWhichIsA(C, "ForceField") --[[or (BarcodeC.IsFreeplay and BarcodeC.FFC(C, "powerup_forcefield"))]] then continue;end;
	                
	                local Distance = (BarcodeC.VotePad - HRP.Position).Magnitude;
	                if Distance > 300 then
	                    if BarcodeC.ClosestPlayerToMouse then
	                        local V2 = BarcodeC.SpaceToVector2(HRP.Position);
	                        local Distance = (MouseLocation - V2).Magnitude;
	                        if Distance < BarcodeC.ClosestPlayerToMouseDistance then
	                            BarcodeC.ClosestPlayerToMouseDistance = Distance;
	                            BarcodeC.ClosestPlayerToMouse = Player;
	                        end;
	                    else
	                        BarcodeC.ClosestPlayerToMouse = Player;
	                    end;
	                end;
	            end;
	        end;
	    end;
	end));
	
end)();
--[[target.lua]](function()
	table.insert(BarcodeC.Connections, BarcodeC.HideTarget.OnClientEvent:Connect(function()
	    BarcodeC.Target = nil;
	    if BarcodeC.HBE_StatusChanged then
	        BarcodeC.HBE_StatusChanged();
	    end;
	end));
	table.insert(BarcodeC.Connections, BarcodeC.UpdateTarget.OnClientEvent:Connect(function(T)
	    BarcodeC.Target = T;
	    if BarcodeC.HBE_StatusChanged then
	        BarcodeC.HBE_StatusChanged();
	    end;
	end));
	-- KnifeCountdown.OnClientEvent:Connect(function()
	--     CanKillPlayers = false;
	--     wait(5);
	--     CanKillPlayers = true;
	-- end);
	do
	    local T = BarcodeC.TargetText.Text;
	    local V = BarcodeC.TargetText.Visible;
	    local V2 = BarcodeC.TargetObject.Visible;
	
	    if V and V2 then
	        if T and #T > 1 then
	            BarcodeC.Target = BarcodeC.FFC(BarcodeC.Players, T);
	            -- CanKillPlayers = true;
	        end;
	    end;
	end;
	
end)();
--[[autoEquip.lua]](function()
	table.insert(BarcodeC.Connections, BarcodeC.Heartbeat:Connect(function()
	    if type(BarcodeC) == "table" then
	        local LocalHRP = BarcodeC.LocalCharacter and BarcodeC.FFC(BarcodeC.LocalCharacter, "HumanoidRootPart");if typeof(LocalHRP) == "Instance" then
	            if not BarcodeC.Config.AutoEquip then return;end;
	            
	            BarcodeC.equipKnife();
	        end;
	    end;
	end));
	
end)();
--[[autoThrow.lua]](function()
	table.insert(BarcodeC.Connections, BarcodeC.Heartbeat:Connect(function()
	    if type(BarcodeC) == "table" then
	        local LocalHRP = BarcodeC.LocalCharacter and BarcodeC.FFC(BarcodeC.LocalCharacter, "HumanoidRootPart");if typeof(LocalHRP) == "Instance" then
	            if BarcodeC.AutoThrowCooldown or not BarcodeC.Config.AutoThrow then return;end;
	            
	            BarcodeC.equipKnife();
	            if BarcodeC.ValidKnife then
	                local TargetC = BarcodeC.Target and BarcodeC.getCharacter(BarcodeC.Target);
	                local TargetHRP = TargetC and BarcodeC.FFC(TargetC, "HumanoidRootPart");if typeof(TargetHRP) == "Instance" then
	                    task.spawn(BarcodeC.killPlayer, (BarcodeC.Config.AutoThrowEnemy == "Target/Bounty" and BarcodeC.Target) or BarcodeC.ClosestPlayerToMouse, true);
	                    BarcodeC.AutoThrowCooldown = true;
	                    task.wait(1);
	                    BarcodeC.AutoThrowCooldown = false;
	                end;
	            end;
	        end;
	    end;
	end));
	
end)();
--[[silentAim.lua]](function()
	local FindPartOnRayWithIgnoreList = BarcodeC.FindPartOnRayWithIgnoreList;
	local function BarcodeCRay(...)
	    if type(BarcodeC) == "table" and BarcodeC.Active and BarcodeC.Config.SilentAim then
	        local Enemy = (BarcodeC.Config.SilentAimEnemy == "ClosestPlayerToMouse" and BarcodeC.ClosestPlayerToMouse) or BarcodeC.Target;
	        local Char = Enemy and BarcodeC.getCharacter(Enemy);
	        local HRP = Char and BarcodeC.FFC(Char, "HumanoidRootPart");
	        if HRP then
	            return HRP, HRP.Position, HRP.Position, HRP.Material;
	        end;
	    end;
	
	    return FindPartOnRayWithIgnoreList(...);
	end;
	BarcodeC.BarcodeCRay = BarcodeCRay;
	
	local fakeWorkspace = newproxy(true);
	local fakeWorkspaceMT = getmetatable(fakeWorkspace);
	for i,v in next, getrawmetatable(workspace) do
	    fakeWorkspaceMT[i] = newcclosure(function(self, ...)
	        return v(workspace, ...);
	    end);
	end;
	BarcodeC.fakeWorkspace = fakeWorkspace;
	BarcodeC.workspaceNC = fakeWorkspaceMT.__namecall;
	BarcodeC.workspaceHook = newcclosure(function(...)
	    if BarcodeC.BarcodeCRay and getnamecallmethod() == "FindPartOnRayWithIgnoreList" then
	        return BarcodeC.BarcodeCRay(...);
	    end;
	    return BarcodeC.workspaceNC(...);
	end);
	
	fakeWorkspaceMT.__namecall = newcclosure(function(self, ...)
	    if BarcodeC.workspaceHook then
	        return BarcodeC.workspaceHook(workspace, ...);
	    end;
	    return BarcodeC.workspaceNC(...);
	end);
	
end)();
--[[hitboxExtender.lua]](function()
	local baseSize;do
	    local HRP = BarcodeC.LocalCharacer and BarcodeC.FFC(BarcodeC.LocalCharacer, "HumanoidRootPart");
	    baseSize = HRP and HRP.Size or Vector3.new(2,2,1);
	end;
	BarcodeC.baseSize = baseSize;
	
	local old; old = hookmetamethod(game, "__index", newcclosure(function(...)
	    if type(BarcodeC) ~= "table" or not BarcodeC.Active or not BarcodeC.Config or not BarcodeC.Config.HBE then return old(...);end;
	
	    local Self, Key = ...;    
	    if typeof(Self) == "Instance" and type(Key) == "string" and tostring(Self) == "HumanoidRootPart" and Key == "Size" then
	        return baseSize;
	    end;
	
	    return old(...);
	end));
	
	local Players = BarcodeC.Players;
	local LocalPlayer = BarcodeC.LocalPlayer;
	local LocalName = LocalPlayer.Name;
	
	local DefaultColor = Color3.fromRGB(163, 162, 165);
	local Plastic = Enum.Material.Plastic;
	-- local ForceField = Enum.Material.Neon;
	local ForceField = Enum.Material.ForceField;
	local function Apply(Hitbox, IsTarget, ShouldBe)
	    local Value = BarcodeC.Config.HBE;
	    if ShouldBe then
	        Value = Value and IsTarget;
	        Hitbox.Size = (Value and BarcodeC.Config.HBE_TargetSize) or baseSize;
	        Hitbox.Transparency = (Value and BarcodeC.Config.HBE_TargetTransparency) or 1;
	        Hitbox.Color = (Value and BarcodeC.Config.HBE_TargetColor) or DefaultColor;
	        -- Hitbox.Material = (Value and ForceField) or Plastic;
	    else
	        local ApplyTarget = IsTarget and BarcodeC.Config.HBE_Target;
	        local Size = (ApplyTarget and BarcodeC.Config.HBE_TargetSize) or BarcodeC.Config.HBE_Size;
	        local Transparency = (ApplyTarget and BarcodeC.Config.HBE_TargetTransparency) or BarcodeC.Config.HBE_Transparency;
	        local Color = (ApplyTarget and BarcodeC.Config.HBE_TargetColor) or BarcodeC.Config.HBE_Color;
	
	        Hitbox.Size = (Value and Size) or baseSize;
	        Hitbox.Transparency = (Value and Transparency) or 1;
	        Hitbox.Color = (Value and Color) or DefaultColor;
	        -- Hitbox.Material = (Value and ForceField) or Plastic;
	    end;
	end;
	
	local HRPS = {};
	local function ObjAdded(Obj, O2)
	    if typeof(Obj) == "Instance" then
	        if Obj.ClassName == "Model" and BarcodeC.FFC(Players, Obj.Name) and Obj.Name ~= LocalName then
	            if not HRPS[Obj] then
	                HRPS[Obj] = O2 or BarcodeC.WFC(Obj, "HumanoidRootPart");
	            end;
	            if HRPS[Obj] then
	                task.spawn(Apply, HRPS[Obj]);
	            end;
	        elseif Obj.ClassName == "Part" and Obj.Name == "HumanoidRootPart" then
	            task.spawn(ObjAdded, Obj.Parent, Obj);
	        end;
	    end;
	end;
	local function ModelAdded(Model)
	    if not HRPS[Model] and typeof(Model) == "Instance" and Model.ClassName == "Model" and BarcodeC.FFC(Players, Model.Name) and Model.Name ~= LocalName then
	        HRPS[Model] = BarcodeC.WFC(Model, "HumanoidRootPart");
	    end;
	    if HRPS[Model] then
	        task.spawn(Apply, HRPS[Model]);
	    end;
	end;
	
	for I, Parent in next, workspace:GetChildren() do
	    for I, Obj in next, Parent:GetChildren() do
	        task.spawn(ObjAdded, Obj);
	    end;
	end;
	
	table.insert(BarcodeC.Connections, workspace.DescendantAdded:Connect(ObjAdded));
	BarcodeC.HBE_StatusChanged = function()
	    for Model, HRP in next, HRPS do
	        if Model and Model.Parent and HRP and HRP.Parent == Model then
	            task.spawn(Apply, HRP, BarcodeC.Target and Model.Name == BarcodeC.Target.Name, BarcodeC.Config.HBE_Target and BarcodeC.Config.HBE_TargetOnly);
	        end;
	    end;
	end;
	
end)();

--[[acBypass2.lua]](function()
	--return if the anticheat already ran
	if shared.AnticheatBypass2Success then return;end;
	local done = false;
	(function()
	    --loop through garbage collection
	    for I, Func in next, BarcodeC.Collection do
	        if done or type(BarcodeC) ~= "table" or not BarcodeC.Active then return;end;
	        pcall(coroutine.wrap(function()
	            --if barcode is in-active, return, moving on to the next item in the collection
	            if type(BarcodeC) ~= "table" or not BarcodeC.Active then return;end;
	            --if the current item isn't a function, return
	            if type(Func) ~= "function" then return end;
	            --if the current item isn't a lua function, return (if it is a C function)
	            if not islclosure(Func) then return end;
	            
	            --this is a workaround to getfenv(Func).script, which triggers the game's anticheat(god knows how)
	            local env = getfenv(Func);
	            local scr;
	            if type(env) == "table" then
	                for i,v in next, env do
	                    if type(i) == "string" and i == "script" then
	                        scr = v;
	                        break;
	                    end;
	                end;
	            end;
	            
	            --if there is no script or script has no parent, return
	            --OR if the script isn't the "reeeee" script, return
	            if typeof(scr) ~= "Instance" then return;end;
	            if not scr.Parent or (scr and scr ~= BarcodeC.ReeScript) then return end;
	
	            --get the constants of Func, which basically has its strings and other values
	            local Constants = debug.getconstants(Func);
	            --find 'BodyMover' in the constants list
	            local BodyMoverIndex = table.find(Constants, 'BodyMover');
	            --if 'BodyMover' is found in constants, then set it to 'game'.
	            --in the script, whenever something is added to your character, it will check if it is a BodyMover
	            if BodyMoverIndex then
	                --change it to 'game' so that it will check if a game is added, instead of a BodyMover
	                debug.setconstant(Func, BodyMoverIndex, 'game');
	
	                --set 'FireServer' to 'GetDebugId' so instead of firing the kick remote, we do something useless
	                debug.setconstant(Func, table.find(Constants, 'FireServer'), 'GetDebugId');
	
	                --set 'Health' to 'HipHeight' so instead of setting the Health to 0, set the HipHeight to 0 (the default value anyways)
	                debug.setconstant(Func, table.find(Constants, 'Health'), 'HipHeight');
	
	                done = true;
	                shared.AnticheatBypass2Success = true;
	                return;
	            end;
	        end));
	    end;
	end)();
	
end)();
BarcodeC.Fly = --[[fly.lua]](function()
	local Fly = {};
	Fly.Speed = 0;
	Fly.MaxSpeed = 20;
	Fly.Left = 0;
	Fly.Right = 0;
	Fly.Forward = 0;
	Fly.Backward = 0;
	
	Fly.LastLeft = 0;
	Fly.LastRight = 0;
	Fly.LastForward = 0;
	Fly.LastBackward = 0;
	
	local Cam = workspace.CurrentCamera;
	
	function Fly.Enable()
	    local Torso = BarcodeC.LocalCharacter and BarcodeC.FFC(BarcodeC.LocalCharacter, "HumanoidRootPart");
	    local Humanoid = Torso and BarcodeC.FFC(BarcodeC.LocalCharacter, "Humanoid");if Humanoid then
	        Fly.Flying = true;
	
	        local Gyro = Instance.new("BodyGyro", Torso);
	        Gyro.P = 9e4;
	        Gyro.MaxTorque = Vector3.new(9e9,9e9,9e9);
	        Gyro.CFrame = Torso.CFrame;
	
	        local BVel = Instance.new("BodyVelocity", Torso)
	        BVel.Velocity = Vector3.new(0,0.1,0);
	        BVel.MaxForce = Vector3.new(9e9,9e9,9e9);
	
	        Fly.Gyro = Gyro;
	        Fly.BVel = BVel;
	
	        while Fly.Flying and Torso and Torso.Parent and Humanoid and Humanoid.Parent do
	            wait();
	            Humanoid.PlatformStand = true;
	            
	            -- if Fly.Left + Fly.Right ~= 0 or Fly.Forward + Fly.Backward ~= 0 then
	            --     Fly.Speed = Fly.Speed + 0.5 + (Fly.Speed/Fly.MaxSpeed)
	            --     if Fly.Speed > Fly.MaxSpeed then
	            --         Fly.Speed = Fly.MaxSpeed
	            --     end
	            -- elseif not (Fly.Left + Fly.Right ~= 0 or Fly.Forward + Fly.Backward ~= 0) and Fly.Speed ~= 0 then
	            --     Fly.Speed -= 1;
	            --     if Fly.Speed < 0 then
	            --         Fly.Speed = 0
	            --     end
	            -- end
	            -- if (Fly.Left + Fly.Right) ~= 0 or (Fly.Forward + Fly.Backward) ~= 0 then
	            --     BVel.velocity = ((Cam.CoordinateFrame.lookVector * (Fly.Forward+Fly.Backward)) + ((Cam.CoordinateFrame * CFrame.new(Fly.Left+Fly.Right, (Fly.Forward+Fly.Backward)*0.2, 0).Position) - Cam.CoordinateFrame.Position))*Fly.Speed
	            --     Fly.LastLeft = Fly.Left;
	            --     Fly.LastRight = Fly.Right;
	            --     Fly.LastForward = Fly.Forward;
	            --     Fly.LastBackward = Fly.Backward;
	            -- elseif (Fly.Left + Fly.Right) == 0 and (Fly.Forward + Fly.Backward) == 0 and Fly.Speed ~= 0 then
	            --     BVel.velocity = ((Cam.CoordinateFrame.lookVector * (Fly.LastForward+Fly.LastBackward)) + ((Cam.CoordinateFrame * CFrame.new(Fly.LastLeft + Fly.LastRight, (Fly.LastForward + Fly.LastBackward)*0.2,0).Position) - Cam.CoordinateFrame.Position))*Fly.Speed
	            -- else
	            --     BVel.velocity = Vector3.new(0,0.1,0)
	            -- end
	            -- Gyro.CFrame = Cam.CoordinateFrame * CFrame.Angles(-math.rad((Fly.Forward+Fly.Backward)*50*Fly.Speed/Fly.MaxSpeed),0,0)
	        end;
	
	        Fly.Left = 0;
	        Fly.Right = 0;
	        Fly.Forward = 0;
	        Fly.Backward = 0;
	        
	        Fly.LastLeft = 0;
	        Fly.LastRight = 0;
	        Fly.LastForward = 0;
	        Fly.LastBackward = 0;
	
	        Fly.Speed = 0;
	
	        Gyro:Destroy();
	        BVel:Destroy();
	
	        if Humanoid then
	            Humanoid.PlatformStand = false;
	        end;
	    end;
	end;
	
	function Fly.Disable()
	    Fly.Flying = false;
	end;
	
	return Fly;
	
end)();
--[[autoFarm.lua]](function()
	local TInfo = TweenInfo.new(1, 8);
	local OFFSET = Vector3.new(2, 0, 2);
	local V = 22;
	
	table.insert(BarcodeC.Connections, BarcodeC.Heartbeat:Connect(function()
	    local LocalHRP = BarcodeC.LocalCharacter and BarcodeC.FFC(BarcodeC.LocalCharacter, "HumanoidRootPart");if typeof(LocalHRP) == "Instance" then
	        -- LocalHRP.Anchored = false;
	        if not BarcodeC.Config.AutoFarm then
	            if BarcodeC.Fly and BarcodeC.Fly.Flying then BarcodeC.Fly.Disable();end;
	            return;
	        end;
	        
	        local BKnife = BarcodeC.getKnifeFromBackpack();if BKnife then
	            BarcodeC.FFC(BarcodeC.LocalCharacter, "Humanoid"):EquipTool(BKnife);
	        end;
	
	        local CKnife = BarcodeC.getKnifeFromCharacter();if CKnife then
	            local Target = BarcodeC.Target;
	            local TargetC = Target and BarcodeC.getCharacter(Target);
	            local TargetHRP = TargetC and BarcodeC.FFC(TargetC, "HumanoidRootPart");if typeof(TargetHRP) == "Instance" and (BarcodeC.VotePad - TargetHRP.Position).Magnitude > 300 then
	                if (LocalHRP.Position - TargetHRP.Position).Magnitude < 10 and not BarcodeC.AutoFarmStabCooldowns[Target] and not TargetC:FindFirstChild("ForceField") then
	                    task.spawn(function()
	                        BarcodeC.AutoFarmStabCooldowns[Target] = true;
	                        -- for i = 1, 3 do
	                        --     repeat task.wait() until not TargetC:FindFirstChild"ForceField" or (Target ~= BarcodeC.Target or not TargetC or not TargetC.Parent or not TargetHRP.Parent or (LocalHRP.Position - TargetHRP.Position).Magnitude > 10);
	                        --     if Target ~= BarcodeC.Target or not TargetC or not TargetC.Parent or not TargetHRP.Parent or (LocalHRP.Position - TargetHRP.Position).Magnitude > 10 then break;end;
	                        --     pcall(BarcodeC.fireRemote, "kill", Target, newproxy(), nil, "stab");
	                        --     task.wait(1/3);
	                        -- end;
	                        local tries = 0;
	                        while tries < 3 and type(BarcodeC) == "table" and BarcodeC.Active and Target == BarcodeC.Target and TargetC and TargetC.Parent and TargetHRP.Parent and (LocalHRP.Position - TargetHRP.Position).Magnitude < 10 do
	                            pcall(BarcodeC.fireRemote, "kill", Target, newproxy(), nil, "stab");
	
	                            tries += 1;
	                            task.wait(1/3);
	                        end;
	                        -- task.wait(1);
	                        BarcodeC.AutoFarmStabCooldowns[Target] = false;
	                    end);
	                end;
	                
	                LocalHRP.CFrame = CFrame.new(LocalHRP.CFrame.Position, TargetHRP.CFrame.Position);
	
	                if not BarcodeC.Fly.Flying then BarcodeC.Fly.Enable(); end;
	                local Values = {};
	                local Difference = (LocalHRP.Position - TargetHRP.Position);
	
	                if math.abs(Difference.X) ~= Difference.X then --is negative
	                    Values[1] = V;
	                else
	                    Values[1] = -V;
	                end;
	
	                if math.abs(Difference.Y) ~= Difference.Y then --is negative
	                    Values[2] = V;
	                else
	                    Values[2] = -V;
	                end;
	
	                if math.abs(Difference.Z) ~= Difference.Z then --is negative
	                    Values[3] = V;
	                else
	                    Values[3] = -V;
	                end;
	
	                BarcodeC.Fly.BVel.Velocity = Vector3.new(table.unpack(Values));
	            elseif BarcodeC.Fly.Flying then
	                BarcodeC.Fly.BVel.Velocity = Vector3.zero;
	            end;
	        end;
	    end;
	end));
	
	local function DoIt2(yeah)
	    pcall(function()
	        yeah.CanQuery = true;
	        local o = yeah.CanCollide;
	        yeah.Touched:Connect(function(a)
	            if not BarcodeC.Config.AutoFarm or not BarcodeC.Fly.Flying then return;end;
	            if not a or not BarcodeC.LocalCharacter or not a:IsDescendantOf(BarcodeC.LocalCharacter) then return;end;
	            pcall(function()
	                yeah.CanCollide = false;
	                wait(1);
	                yeah.CanCollide = o;
	            end);
	        end);
	    end);
	end;
	
	local function DoIt(stuffs)
	    for i,v in next, stuffs do
	        DoIt2(v);
	    end;
	end;
	
	workspace.DescendantAdded:Connect(function(c)
	    if workspace:FindFirstChild("GameMap") and c:IsDescendantOf(workspace.GameMap) then
	        DoIt2(c);
	    end;
	end);
	if workspace:FindFirstChild("GameMap") then
	    DoIt(workspace.GameMap:GetDescendants());
	end;
	
end)();

BarcodeC.fakeWrap = --[[fakeWrap.lua]](function()
	local wrap = coroutine.wrap;
	local renv = getrenv();
	
	--skin changer stuff
	-- local Items = require(game:GetService("ReplicatedStorage").Modules.Items);
	
	-- local Slugger = Items:GetAllKnives().Slugger;
	-- local Mesh = Items.GetMesh("Slugger");
	-- local Texture = Items.GetTexture("Slugger");
	
	return function(Func)
	    if type(BarcodeC) ~= "table" or not BarcodeC.Active then return wrap(Func);end;
	    
	    -- if not shared.seventy then
	    --     shared.seventy = Func;
	    --     print("GOT FUNC");
	    -- end;
	
	    local Upvalues = debug.getupvalues(Func);
	    local KnifeName = Upvalues[1];
	    local Player = Upvalues[4];
	    -- local PlayerKnife = Upvalues[5];
	    -- local Direction = Upvalues[14];
	    
	    local Knife = BarcodeC.FFC(BarcodeC.KnifeHost, KnifeName);if Knife then
	        if Player == BarcodeC.LocalPlayer then
	
	            BarcodeC.KillKnife = Knife;
	
	            local Constants = debug.getconstants(Func);
	            
	            local o = getfenv(Func);
	            if not o.hoooooked then
	                local new = {};
	                for i,v in next, renv do
	                    new[i] = v;
	                end;
	                for i,v in next, o do
	                    new[i] = v;
	                end;
	
	                new.workspace = BarcodeC.fakeWorkspace;
	                new.hoooooked = true;
	                setfenv(Func, new);
	            end;
	        end;
	    end;
	
	    return wrap(Func);
	end;
	
end)();
BarcodeC.wrapFunc = --[[wrapFunc.lua]](function()
	repeat wait() until BarcodeC.fakeWrap;
	
	local coroutineName = "BarcodeCcoroutine";
	BarcodeC.coroutineName = coroutineName;
	local wrapFunc;
	local CoroutineIndex;
	
	local DONE = false;
	
	(function()
	    for I, Func in next, BarcodeC.Collection do
	        if DONE or type(BarcodeC) ~= "table" or not BarcodeC.Active then return;end;
	        pcall(coroutine.wrap(function()
	            if type(Func) ~= "function" then return end;
	            if not islclosure(Func) then return end;
	                
	            local env = getfenv(Func);
	            local scr;
	            if type(env) == "table" then
	                for i,v in next, env do
	                    if type(i) == "string" and i == "script" then
	                        scr = v;
	                        break;
	                    end;
	                end;
	            end;
	            
	            if typeof(scr) ~= "Instance" then return;end;
	            if not scr.Parent then return end;
	            if scr == BarcodeC.LocalKnifeHandler then 
	                local Constants = debug.getconstants(Func);
	                local WrapIndex = (table.find(Constants, "wrap"));
	                if WrapIndex and Constants[WrapIndex - 1] == "coroutine" then
	                    wrapFunc = Func;
	                    CoroutineIndex = WrapIndex - 1;
	                    DONE = true;
	                end;
	            end;
	        end));
	    end;
	end)();
	if wrapFunc and CoroutineIndex then
	    BarcodeC.CoroutineIndex = CoroutineIndex;
	
	    local fenv = getfenv(wrapFunc);
	    fenv[coroutineName] = {["wrap"] = BarcodeC.fakeWrap};
	    debug.setconstant(wrapFunc, CoroutineIndex, coroutineName);
	end;
	return wrapFunc;
	
end)();

BarcodeC.ChatFunction, BarcodeC.SetChatColor, BarcodeC.SetChatTag = --[[chat.lua]](function()
	local ChattedSignal = BarcodeC.LocalPlayer.Chatted;
	
	local ChatFunction;
	for I, Con in next, getconnections(ChattedSignal) do
	    local Func = Con and Con.Function;
	    if type(Func) ~= "function" or not islclosure(Func) then continue;end;
	    local env = getfenv(Func);
	    if type(env) ~= "table" then continue;end;
	    local scr;
	    for i,v in next, env do
	        if type(i) == "string" and i == "script" then
	            scr = v;
	            break;
	        end;
	    end;
	    if typeof(scr) ~= "Instance" then continue;end;
	
	
	    if tostring(scr) == "localchat" then
	        ChatFunction = debug.getupvalue(Func, 1);
	        break;
	    end;
	end;
	
	if not ChatFunction then return error("Failed to get chat function.");end;
	local function SetColor(Color)
	    debug.setupvalue(ChatFunction, 4, Color);
	end;
	local function SetTag(Tag)
	    debug.setupvalue(ChatFunction, 5, Tag);
	end;
	
	task.spawn(function()
	    while type(BarcodeC) == "table" and BarcodeC.Active do
	        if BarcodeC.Config.ChatSpam then
	            --for one second delay, chat 7 then wait 9
	            
	            for i = 1, 3 do
	                ChatFunction(BarcodeC.Config.ChatText);
	                task.wait(0.2);
	            end;
	            task.wait(5);
	        end;
	        task.wait();
	    end;
	end);
	
	return ChatFunction, SetColor, SetTag;
	
end)();

--[[killAllAutofarmV1.lua]](function()
	local Autofarm = {};
	local ENABLED = false;
	
	local FLY_VELOCITY = 4;
	table.insert(BarcodeC.Connections, BarcodeC.Heartbeat:Connect(function()
	    local LocalCharacter = BarcodeC.LocalCharacter;
	    local LocalHRP = LocalCharacter and BarcodeC.FFC(LocalCharacter, "HumanoidRootPart");if typeof(LocalHRP) == "Instance" then
	
	        if not BarcodeC.Fly then
	            return;
	        end;
	        if not ENABLED then
	            -- if BarcodeC.Fly.Flying then BarcodeC.Fly.Disable();end;
	            return;
	        end;
	
	        local BKnife = BarcodeC.getKnifeFromBackpack();if BKnife then
	            BarcodeC.FFC(BarcodeC.LocalCharacter, "Humanoid"):EquipTool(BKnife);
	        end;
	
	        local CKnife = BarcodeC.getKnifeFromCharacter();if CKnife then
	            -- if not BarcodeC.Fly.Flying then BarcodeC.Fly.Enable(); end;
	            local Target = BarcodeC.Target;
	            local TargetC = Target and BarcodeC.getCharacter(Target);
	            local TargetHRP = TargetC and BarcodeC.FFC(TargetC, "HumanoidRootPart");if typeof(TargetHRP) == "Instance" and (BarcodeC.VotePad - TargetHRP.Position).Magnitude > 300 then
	                -- LocalHRP.Anchored = true;
	                task.spawn(function()
	                    BarcodeC.stabPlayer(Target);
	                    -- task.wait(1); -- stabPlayer waits
	                    if not (BarcodeC and BarcodeC.Active) or not ENABLED then
	                        return;
	                    end;
	                    -- if BarcodeC.Target == Target then -- still the same target
	                    --     BarcodeC.killPlayer(Target);
	                    -- end;
	                end);
	                -- BarcodeC.playTween(LocalHRP, TweenInfo.new(1, 8), {Position = TargetHRP.Position - Vector3.new(0,0,5)});
	                -- LocalCharacter:MoveTo(LocalHRP.Position);
	                
	                local Values = {};
	                local Difference = (LocalHRP.Position - TargetHRP.Position);
	                
	                if math.abs(Difference.X) ~= Difference.X then --is negative
	                    Values[1] = FLY_VELOCITY;
	                else
	                    Values[1] = -FLY_VELOCITY;
	                end;
	                
	                if math.abs(Difference.Y) ~= Difference.Y then --is negative
	                    Values[2] = FLY_VELOCITY;
	                else
	                    Values[2] = -FLY_VELOCITY;
	                end;
	                -- Values[2] -= 5;
	                
	                if math.abs(Difference.Z) ~= Difference.Z then --is negative
	                    Values[3] = FLY_VELOCITY;
	                else
	                    Values[3] = -FLY_VELOCITY;
	                end;
	
	                -- BarcodeC.Fly.BVel.Velocity = Vector3.new(table.unpack(Values));
	                LocalHRP.CFrame = CFrame.new(LocalHRP.CFrame.Position + Vector3.new(table.unpack(Values)), TargetHRP.CFrame.Position);
	                -- LocalCharacter:MoveTo(LocalHRP.Position);
	            else
	                -- BarcodeC.Fly.BVel.Velocity = Vector3.new(0, 5, 0);
	            end;
	        end;
	
	        if LocalHRP.Position.Y < 2000 then
	            LocalHRP.CFrame += Vector3.new(0, 3, 0);
	        end;
	    end;
	end));
	function Autofarm.Enable()
	    ENABLED = true;
	end;
	function Autofarm.Disable()
	    ENABLED = false;
	    -- local LocalCharacter = BarcodeC.LocalCharacter;
	    -- local LocalHRP = LocalCharacter and BarcodeC.FFC(LocalCharacter, "HumanoidRootPart");if typeof(LocalHRP) == "Instance" then
	    --     LocalHRP.Anchored = false;
	    -- end;
	end;
	
	BarcodeC.killAllAutofarmV1 = function(state)
	    (state and Autofarm.Enable or Autofarm.Disable)();
	end;
	
	
	
	local function DoIt2(yeah)
	    pcall(function()
	        yeah.CanQuery = true;
	        local o = yeah.CanCollide;
	        local Con; Con = yeah.Touched:Connect(function(a)
	            if not BarcodeC.Active then
	                Con:Disconnect();
	                return;
	            end;
	            if not ENABLED or not a or not BarcodeC.LocalCharacter or not a:IsDescendantOf(BarcodeC.LocalCharacter) --[[or not (BarcodeC.FFC(BarcodeC.LocalCharacter, "HumanoidRootPart") and BarcodeC.LocalCharacter.HumanoidRootPart.Anchored)]] then return;end;
	            pcall(function()
	                yeah.CanCollide = false;
	                task.wait(1);
	                yeah.CanCollide = o;
	            end);
	        end);
	    end);
	end;
	
	local function DoIt(stuffs)
	    for i,v in next, stuffs do
	        DoIt2(v);
	    end;
	end;
	
	workspace.DescendantAdded:Connect(function(c)
	    if workspace:FindFirstChild("GameMap") and c:IsDescendantOf(workspace.GameMap) then
	        DoIt2(c);
	    end;
	end);
	if workspace:FindFirstChild("GameMap") then
	    DoIt(workspace.GameMap:GetDescendants());
	end;
	
end)();
BarcodeC.Esp = --[[Esp.lua]](function()
	local Esp = shared.EspLib or loadstring(game:HttpGet"https://gitlab.com/te4224/Scripts/-/raw/main/EspLib/src.lua")();
	
	local CharactersModule = require(BarcodeC.CharacterModule);
	local CharactersModule__index = getrawmetatable(CharactersModule).__index;
	
	local GetCharRemoving = BarcodeC.scall(CharactersModule__index, CharactersModule, "GetCharRemoving");
	
	Esp.GetCharacterFromPlayer = BarcodeC.getCharacter;
	Esp.GetCharacterRemovingSignal = function(Player)
	    -- return BarcodeC.CharacterModule:WaitForChild(Player.Name.."_Connection").Event;
	    return GetCharRemoving(Player);
	end;
	
	repeat task.wait() until Esp.Active;
	Esp:ApplyConfig("BarcodeC/esp_config.txt");
	Esp.Config.Enabled = false;
	
	-- local Custom = {};do
	--     Custom.__index = Custom;
	
	--     function Custom.init(self, Player)
	--         self.Object = shared.DrawingApi2.new{"Image", Data = game:HttpGet("https://images.pexels.com/photos/4226864/pexels-photo-4226864.jpeg?cs=tinysrgb&w=50&h=50"), Size = Vector2.new(50,50), Visible = false};
	--     end;
	--     function Custom.Update(self, Player)
	--         self.Object.Visible = false;
	--         if type(self) ~= "table" or type(Player) ~= "table" or typeof(Player.Player) ~= "Instance" or type(Esp) ~= "table" or not Esp.Active or type(BarcodeC) ~= "table" or not BarcodeC.Active or not BarcodeC.Config.EspKnives then return;end;
	
	--         local Character = BarcodeC.getCharacter(Player.Player);
	--         local Knife = Character and BarcodeC.FFC(Character, "Knife");if typeof(Knife) == "Instance" then
	--             local Pos, IsVisible, Dist = Esp.SpaceToVector2(Knife.Handle.Position);
	--             if IsVisible then
	--                 self.Object.Size = Vector2.new(math.clamp(Dist, 10, 35));
	--                 self.Object.Position = Pos;
	--                 self.Object.Visible = true;
	--             end;
	--         end;
	--     end;
	--     function Custom.Destroy(self)
	--         self.Active = false;
	--         self.Object:Destroy();
	--     end;
	-- end;
	
	local function newPlayerObject(Player)
	    -- local CustomKnife = setmetatable({}, Custom);
	    local PlayerObject = Esp.PlayerObject.new(Player--[[, {CustomKnife}]]);
	    task.spawn(function()
	        while Esp and Esp.Active and PlayerObject and PlayerObject.Active do
	            PlayerObject.Color = (Player == BarcodeC.Target and BarcodeC.Config.TargetEspColor) or BarcodeC.Config.BaseEspColor;
	            task.wait();
	        end;
	    end);
	end;
	
	for I, Player in next, BarcodeC.GetPlayers(BarcodeC.Players) do
	    if Player and Player ~= BarcodeC.LocalPlayer then
	        -- PlayerObject.new(Player);
	        newPlayerObject(Player);
	    end;
	end;
	
	table.insert(BarcodeC.Connections, BarcodeC.Players.PlayerAdded:Connect(newPlayerObject));
	table.insert(BarcodeC.Connections, BarcodeC.Players.PlayerRemoving:Connect(function(Player)
	    if Esp.PlayerObjects[Player] then
	        Esp.PlayerObjects[Player]:Destroy();
	    end;
	end));
	
	return Esp;
	
end)();
task.spawn(function()
    BarcodeC.Loaded = true;
    BarcodeC.LoadingTimeTaken = os.time() - OldTime;
    task.wait(0.5);
    BarcodeC.loadingUI:Destroy();

    
    --[[ui2.lua]](function()
	local Lib = loadstring(game:HttpGet"https://gitlab.com/te4224/Scripts/-/raw/main/Pulse/UILIB/V1/main.lua")();
	
	local Window = Lib.new("Barcode[+] X Coconut", UDim2.fromOffset(460, 442), true);
	BarcodeC.UIWindow = Window;
	Window.OnClose:Connect(function(ButtonClicked)
	    BarcodeC.UIWindow = nil;
	    if ButtonClicked then
	        BarcodeC:Stop();
	    end;
	end);
	local MainTab = Window:NewTab("Main");
	
	
	BarcodeC.SilentAimToggle = MainTab:NewToggle("Silent Aim", function(s)BarcodeC.Config.SilentAim=s;end);
	BarcodeC.SilentAimEnemyDropdown = MainTab:NewDropdown("Silent Aim Enemy", function(o)BarcodeC.Config.SilentAimEnemy=o;end, {"Target/Bounty", "ClosestPlayerToMouse"}):SelectItem(BarcodeC.Config.SilentAimEnemy);
	
	
	-- MainTab:NewSection("Auto Farm"):NewToggle("Enabled", "[WIP]", function(s)BarcodeC.Config.AutoFarm=s;end);
	
	local function sc()
	    if BarcodeC.HBE_StatusChanged then 
	        BarcodeC.HBE_StatusChanged();
	    end;
	end;
	local HBE_Tab = Window:NewTab("Hitbox Extender");
	
	BarcodeC.HBE_EnabledToggle = HBE_Tab:NewToggle("Enabled", --[["Modifies players' hitboxes.",]] function(s)BarcodeC.Config.HBE=s;sc();end);
	BarcodeC.HBE_SizeSlider = HBE_Tab:NewSlider("Size", --[["Size of hitboxes when expanded.",]] function(v)BarcodeC.Config.HBE_Size=Vector3.new(v,v,v);sc();end, 3, 30);
	BarcodeC.HBE_TransparencySlider = HBE_Tab:NewSlider("Transparency", --[["Transparency of hitboxes when expanded, divided by 100.",]] function(v)BarcodeC.Config.HBE_Transparency=v/100;sc();end, 0, 100);
	BarcodeC.HBE_ColorPicker = HBE_Tab:NewColorPicker("Color", --[["Color of hitboxes when expanded.", BarcodeC.Config.HBE_Color,]] function(c)BarcodeC.Config.HBE_Color=c;sc();end);
	
	BarcodeC.HBE_TargetEnabledToggle = HBE_Tab:NewToggle("Target Enabled", --[["Modifies your target's hitbox differently than other players.",]] function(s)BarcodeC.Config.HBE_Target=s;sc();end);
	BarcodeC.HBE_TargetOnlyToggle = HBE_Tab:NewToggle("Target Only", --[["Will only modify your target's hitbox.",]] function(s)BarcodeC.Config.HBE_TargetOnly=s;sc();end);
	BarcodeC.HBE_TargetSizeSlider = HBE_Tab:NewSlider("Target Size", --[["Size of your target's hitbox when expanded.",]] function(v)BarcodeC.Config.HBE_TargetSize=Vector3.new(v,v,v);sc();end, 3, 30);
	BarcodeC.HBE_TargetTransparencySlider = HBE_Tab:NewSlider("Target Transparency", --[["Transparency of your target's hitbox when expanded, divided by 100.",]] function(v)BarcodeC.Config.HBE_TargetTransparency=v/100;sc();end, 0, 100);
	BarcodeC.HBE_TargetColorPicker = HBE_Tab:NewColorPicker("Target Color", --[["Color of your target's hitbox when expanded.", BarcodeC.Config.HBE_TargetColor,]] function(c)BarcodeC.Config.HBE_TargetColor=c;sc();end);
	
	
	local KnifeTab = Window:NewTab("Knife");
	-- local AutoSection = KnifeTab:NewSection("Auto");
	-- local KillPlayersSection = KnifeTab:NewSection("Kill Players");
	-- -- local KnifeMiscSection = KnifeTab:NewSection("Misc");
	
	BarcodeC.AutoThrowToggle = KnifeTab:NewToggle("Auto Throw", --[["Automatically throws knife at target."]] function(s)BarcodeC.Config.AutoThrow=s;end);
	BarcodeC.AutoThrowEnemyDropdown = KnifeTab:NewDropdown("Enemy", --[["Who Auto Throw will try to kill."]] function(o)BarcodeC.Config.AutoThrowEnemy=o;end, {"Target/Bounty", "ClosestPlayerToMouse"});
	BarcodeC.AutoEquipToggle = KnifeTab:NewToggle("Auto Equip", --[["Automatically equips your knife."]] function(s)BarcodeC.Config.AutoEquip=s;end);
	
	KnifeTab:NewButton("Kill Target", --[["Attempts to kill your target."]] function()
	    if BarcodeC.Target then
	        BarcodeC.equipKnife();
	        if not BarcodeC.checkKnife() then return;end;
	        BarcodeC.killPlayer(BarcodeC.Target);
	    end;
	end):AddKeybind(Enum.KeyCode.F);
	KnifeTab:NewButton("Kill Closest Player To Mouse", --[["Attempts to kill the closest player to your mouse.",]] function()
	    if BarcodeC.ClosestPlayerToMouse then
	        BarcodeC.equipKnife();
	        if not BarcodeC.checkKnife() then return;end;
	        BarcodeC.killPlayer(BarcodeC.ClosestPlayerToMouse);
	    end;
	end):AddKeybind(Enum.KeyCode.R);
	local KPDropdown = KnifeTab:NewDropdown("Player", --[["The player that the keybind below will try to kill.",]] function(o)BarcodeC.KP_Enemy=o;end, {unpack(BarcodeC.GetPlayers(BarcodeC.Players))});
	KnifeTab:NewButton("Kill Player", --[["Attempts to kill the player in the dropdown above."]] function()
	    if BarcodeC.KP_Enemy then
	        BarcodeC.equipKnife();
	        if not BarcodeC.checkKnife() then return;end;
	        BarcodeC.killPlayer(BarcodeC.KP_Enemy);
	    end;
	end):AddKeybind(Enum.KeyCode.V);
	table.insert(BarcodeC.Connections, BarcodeC.Players.PlayerAdded:Connect(function()
	    KPDropdown:UpdateItems{unpack(BarcodeC.GetPlayers(BarcodeC.Players))};
	end));
	table.insert(BarcodeC.Connections, BarcodeC.Players.PlayerRemoving:Connect(function()
	    KPDropdown:UpdateItems{unpack(BarcodeC.GetPlayers(BarcodeC.Players))};
	end));
	
	-- -- KnifeMiscSection:NewToggle("No Curve", "Makes your knife not curve downards.", function(s)BarcodeC.Config.NoKnifeCurve=s;end);
	-- -- KnifeMiscSection:NewToggle("Funny", "IDK.", function(s)BarcodeC.Config.KniveFunny=s;end);
	
	
	local ChatTab = Window:NewTab("Chat");
	
	BarcodeC.ChatColorPicker = ChatTab:NewColorPicker("Color", --[["Color of your messages in chat.", BarcodeC.Config.ChatColor,]] function(c)BarcodeC.Config.ChatColor=c;BarcodeC.SetChatColor(c);end);
	BarcodeC.ChatVipTagToggle = ChatTab:NewToggle("VIP Tag", --[["Gives you the VIP tag.",]] function(s)BarcodeC.Config.ChatVipTag=s;if s then BarcodeC.SetChatTag("[VIP]"); else BarcodeC.SetChatTag("");end;end);
	BarcodeC.ChatTextBox = ChatTab:NewBox("Text", --[["The text that will be chatted.",]] function(t)BarcodeC.Config.ChatText=t or"";end);
	BarcodeC.ChatButton = ChatTab:NewButton("Chat <text>", --[["Chats the text from the box above.",]] function()BarcodeC.ChatFunction(BarcodeC.Config.ChatText)end);
	BarcodeC.ChatSpamToggle = ChatTab:NewToggle("Spam chat <text>", --[["Chats text from the box above a ton.",]] function(s)BarcodeC.Config.ChatSpam=s;end);
	
	-- local ConfigsTab = Window:NewTab("Configs");
	
	-- BarcodeC.ConfigBox = ConfigsTab:NewBox("Config", --[["Name of config to save.",]] function(t)BarcodeC.ConfigToSave=t;end);
	-- BarcodeC.ConfigButton = ConfigsTab:NewButton("Select Config", --[["Selects config.",]] function()BarcodeC.SelectConfig(BarcodeC.ConfigToSave);end);
	
	local AutofarmTab = Window:NewTab("[BETA] Autofarm");
	
	AutofarmTab:NewToggle("killAllAutofarmV1", function(s)BarcodeC.Config.killAllAutofarmV1=s;BarcodeC.killAllAutofarmV1(s);end);
	
	repeat task.wait() until BarcodeC.Esp and BarcodeC.Esp.Active;
	local EspTab = Window:NewTab("Esp");
	
	BarcodeC.EspEnabledToggle = EspTab:NewToggle("Enabled", --[["Esp",]] function(s)BarcodeC.Esp.Config.Enabled=s;end):UpdateStatus(BarcodeC.Esp.Config.Enabled);
	BarcodeC.EspNameTagsToggle = EspTab:NewToggle("NameTags", --[["Renders NameTags above players' heads.",]] function(s)BarcodeC.Esp.Config.NameTags=s;end):UpdateStatus(BarcodeC.Esp.Config.NameTags);
	BarcodeC.EspBoxesToggle = EspTab:NewToggle("Boxes", --[["Renders Boxes over players.",]] function(s)BarcodeC.Esp.Config.Boxes=s;end):UpdateStatus(BarcodeC.Esp.Config.Boxes);
	BarcodeC.EspTracersToggle = EspTab:NewToggle("Tracers", --[["Renders Tracers to players' heads.",]] function(s)BarcodeC.Esp.Config.Tracers=s;end):UpdateStatus(BarcodeC.Esp.Config.Tracers);
	BarcodeC.EspSkeletonsToggle = EspTab:NewToggle("Skeletons", --[["Renders Skeletons on players.",]] function(s)BarcodeC.Esp.Config.Skeletons=s;end):UpdateStatus(BarcodeC.Esp.Config.Skeletons);
	-- BarcodeC.EspKnivesToggle = EspTogglesSection:NewToggle("Knives", "Renders a picture of a knife on players' knives.", function(s)BarcodeC.Config.EspKnives=s;end);
	
	BarcodeC.EspColorPicker = EspTab:NewColorPicker("Base Color", --[["Color of all players except your target.", BarcodeC.Config.BaseEspColor,]] function(c)BarcodeC.Config.BaseEspColor=c;end);
	BarcodeC.EspColorTargetPicker = EspTab:NewColorPicker("Target Color", --[["Color of your target.", BarcodeC.Config.TargetEspColor,]] function(c)BarcodeC.Config.TargetEspColor=c;end);
	
end)();
    
    --[[extras.lua]](function()
	return "extras";
	
end)();
end);
