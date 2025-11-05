--[=[
    THIS SCRIPT IS NOT INTENDED TO BE A FINAL PRODUCT!!
    There are many places in this script that could be aproved on, however this is just a project that I am using to gain experience!
    There are also many things that I would implement differently if this weren't a private script.

    Version: CLEAN
]=]

--[=[ 2025 notes

this is Coconut, my first assassin script. there are some videos of it on youtube-- it's the one with the skinny gray ui things that looked like kiriot hub a little.
anyway yeah enjoy this for learning. don't expect the ac bypass to work at all.

reach out to me @techhog on discord if you have any questions
    
]=]

--Check is Assassin
local HttpLoad = shared.HttpLoad or nil;if HttpLoad == nil then do
    local HttpGet = game.HttpGet;
    HttpLoad = function(URL)
        return loadstring(HttpGet(game, URL))();
    end;
    shared.HttpLoad = HttpLoad;
end;end;
local GrayedLib = HttpLoad"https://gitlab.com/te4224/Scripts/-/raw/main/GrayedLib/src.lua";

--[[stop old script]]
local OldCoconut = shared.CoconutAssassin;
if OldCoconut then
    OldCoconut.stop();
    shared.CoconutAssassin = nil;
end;

--[[stuff you should have]]
local scall = syn and syn.secure_call or secure_call or securecall;
assert(scall, "secure_call not found, that's tough");

--[[variables teehee]]
local tspawn = task.spawn;
local twait = task.wait;

local tinsert = table.insert;

--[game variables]
local game = game;
local FFC = game.FindFirstChild;
local WFC = game.WaitForChild;

local Players = game:GetService("Players");
local GetPlayers = Players.GetPlayers;
local LocalPlayer = Players.LocalPlayer;
local function FindFirstPlayer(Name)
    return FFC(Players, Name);
end;

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local BACFolder = ReplicatedStorage.BAC;
local NetworkModule = BACFolder.Network;
local CharacterModule = BACFolder.Characters;

local Remotes = ReplicatedStorage.Remotes;
local ThrowKnife = Remotes.ThrowKnife;
local HideTarget = Remotes.HideTarget;
local UpdateTarget = Remotes.UpdateTarget;
local KnifeCountdown = Remotes.KnifeCountdown;

local Lobby = workspace.Lobby;
local Lighting = game:GetService("Lighting");

local UIS = game:GetService("UserInputService");
local GML = UIS.GetMouseLocation;

local Camera = workspace.CurrentCamera;
local WorldToViewportPoint = Camera.WorldToViewportPoint;

local Vector2New = Vector2.new;

local function SpaceToVector2(Space)
    local Pos, IsVisible = WorldToViewportPoint(Camera, Space);

    return Vector2New(Pos.X, Pos.Y), IsVisible, Pos.Z;
end;

--[other]
local Coconut = {Loaded = false, Active = false, 
    Connections = {}, 
    ControlDeleteHistory = (OldCoconut and OldCoconut.ControlDeleteHistory) or {Len = 1},

    SilentAimTarget = "Target / Bounty",
};
local ClosestPlayerToMouse;
local ClosestPlayerToMouseDistance;

local TargetObject = LocalPlayer:WaitForChild("PlayerGui").ScreenGui.UI.Target;
local TargetText = TargetObject.TargetText;
local StabTarget;
local Target;

--[[get the target]]
HideTarget.OnClientEvent:Connect(function()
    Target = nil;
end);
UpdateTarget.OnClientEvent:Connect(function(T)
    Target = T;
end);
do
    local T = TargetText.Text;
    local V = TargetText.Visible;
    local V2 = TargetObject.Visible;

    if V and V2 then
        if T and #T > 1 then
            Target = FindFirstPlayer(T);
        end;
    end;
end;

--[[bypass the AC]]
GrayedLib:Notification{"Bypassing anticheat...", "step1", 1.3, 0.75};
(function()
    if shared.FunnyPingNumber or true then
        return GrayedLib:Notification{"Success!", "Already bypassed! [step1]", 1.3, 0.75};
    end;
    local Suc, Res = pcall(function()
        --ping
        -- local scall = syn.secure_call;

        -- local ReplicatedStorage = game:GetService("ReplicatedStorage");
        -- local BACFolder = ReplicatedStorage.BAC;
        -- local NetworkModule = BACFolder.Network;

        local Network = require(NetworkModule);
        local NetworkMT = getrawmetatable(Network);
        local NetworkMT__Index = NetworkMT.__index;

        local FireServer = scall(NetworkMT__Index, NetworkModule, Network, "FireServer")
        local FireServerMT = getrawmetatable(FireServer);

        local NUMBER = shared.FunnyPingNumber;
        if not NUMBER then
            local call = FireServerMT.__call;
            FireServerMT.__call = function(self, ...)
                if NUMBER then return call(self, ...);end;
                local Arguments = {...};
                if table.find(Arguments, "Ping") then
                    NUMBER = Arguments[3];
                    shared.FunnyPingNumber = NUMBER;
                end;
                
                return call(self, ...);
            end;

            repeat wait() until NUMBER;
            task.spawn(function()
                while task.wait(3.5) do
                    scall(FireServer, NetworkModule, "BAC", "Ping", NUMBER);
                end;
            end)
        end;

        --get all of the scripts
        local BAC, C, _;
        for I, Script in next, game:GetDescendants() do
            if typeof(Script) == "Instance" and Script.ClassName == "LocalScript" then
                local Name = Script.Name;
                if Name:match("B%.A%.C") then
                    BAC = Script;
                elseif Name:match("%[C%]") then
                    C = Script;
                elseif Name:match("\n") or Name:match("_") then
                    _ = Script;
                end;
            end;
        end;

        local collection = getgc(false);

        local ContentProvider = game:GetService("ContentProvider");

        local SUC1, SUC2;
        --find function in BAC with ContentProvider and make it have funny error
        -- (function()
            for I, Func in next, collection do
                if SUC1 and SUC2 then return "SUCCESS" end;
                if type(Func) ~= "function" then continue end;
                if not islclosure(Func) then continue end;
                
                local env = getfenv(Func);
                local scr = env and env.script;
                
                if not scr or not scr.Parent then continue end;
                
                if scr == BAC then
                    local upvalues = debug.getupvalues(Func);
                    
                    for I, V in next, upvalues do
                        if typeof(V) == "Instance" then
                            if V == ContentProvider then
                                debug.setupvalue(Func, I, {PreloadAsync = function()while true do end;end});
                                -- return "SUCCESS";
                                SUC1 = true;
                            -- elseif tostring(V):lower() == "game" then
                            --     debug.setupvalue(Func, I, a());
                            end;
                        end;
                    end;
                elseif scr == _ then
                    local constants = debug.getconstants(Func);
                    if table.find(constants, "game") then
                        local upvalues = debug.getupvalues(Func);
                        if upvalues[2] then
                            hookfunction(upvalues[2], function(...)
                                while true do end;
                            end);
                            SUC2 = true;
                        end;
                    end;
                end;
            end;
        -- end)();
    end);

    if Suc and Res == "SUCCESS" then
        GrayedLib:Notification{"Success!", "Bypassed anticheat [step1]", 1.3, 0.75};
        return;
    end;
    GrayedLib:Notification{"Failed!", "Failed to bypass anticheat [step1]", 1.3, 0.75};
    return;
end)();

GrayedLib:Notification{"Bypassing anticheat...", "step2", 1.3, 0.75};
(function()
    local Suc, Res = pcall(WFC, LocalPlayer.PlayerScripts, "reeeee");
    if Suc and Res then
        local Script = Res;
        Suc, Res = pcall(getgc);
        if Suc and Res then
            local GC = Res;
            Suc, Res = pcall(function()
                for I, Function in next, GC do
                    --check if 'Function' is a function, it is a lua function, and that its script is reeeee
                    if type(Function) == 'function' and islclosure(Function) and getfenv(Function).script == Script then
                        --get the constants of Function, which basically has its strings and other values
                        local constants = getconstants(Function);
                        --find 'BodyMover' in the constants list
                        local BodyMoverIndex = table.find(constants, 'BodyMover');
                        --if 'BodyMover' is found in constants, then set it to 'game'.
                        --in the reeeee script, whenever something is added to your character, it will check if it is a BodyMover
                        --here, we will change it to 'game' so that it will check if a game is added, instead of a BodyMover
                        if BodyMoverIndex then
                            setconstant(Function, BodyMoverIndex, 'game');
            
                            --since we have the function we want, we can do other things
            
                            --like set 'FireServer' to 'GetDebugId' so instead of firing the kick remote, we do something useless
                            setconstant(Function, table.find(constants, 'FireServer'), 'GetDebugId');
            
                            --and set 'Health' to 'HipHeight' so instead of setting the Health to 0, set the HipHeight to 0 (the default value, anyway)
                            setconstant(Function, table.find(constants, 'Health'), 'HipHeight');
            
                            --return, stopping the loop
                            return "Bypassed anticheat [step2]";
                        elseif table.find(constants, "GetDebugId") and table.find(constants, "HipHeight") then
                            return "Already bypassed! [step2]";
                        end;
                    end;
                end;
            end);
            if not Suc then
                GrayedLib:Notification{"Failed to loop through\ngarbage collection!", tostring(Res or "[Unknown Error Occured]"), 1.3, 0.75};
                return;
            elseif Suc and Res then
                GrayedLib:Notification{"Success!", Res, 1.3, 0.75};
                return;
            end;
        else
            GrayedLib:Notification{"Failed to get\ngarbage collection!", tostring(Res or "[Unknown Error Occured]"), 1.3, 0.75};
            return;
        end;
    else
        GrayedLib:Notification{"Failed to get\n'reeeee' script!", tostring(Res or "[Unknown Error Occured]"), 1.3, 0.75};
        return;
    end;
    GrayedLib:Notification{"Failed!", "Failed to bypass anticheat [step2]", 1.3, 0.75};
end)();

--[[bypass some spooky stuff]]
--The game has checks that verify if function calls are coming from valid game modules.
--If this check fails, a crash will occur.
--Luckily, there is the secure_call function which allows us to tell the game that we are
--calling a function from a certain script / environment.

--[get the network module so we can fire remotes used for killing people]
local Network = require(NetworkModule);
local NetworkMT = getrawmetatable(Network);
local NetworkMT__Index = NetworkMT.__index;

local FireServer = scall(NetworkMT__Index, NetworkModule, Network, "FireServer") -- same as "Network.FireServer"
-- local FireServerMT = getrawmetatable(FireServer);
local function FireRemote(...)
    return scall(FireServer, NetworkModule, ...);   -- same as "Network.FireServer(...)"
end;

--[get the characters module used to actually get players' characters since the game hides them]
local Characters = require(CharacterModule);
local CharacterMT = getrawmetatable(Characters);
local CharacterMT__Index = CharacterMT.__index;

local getcharacter = scall(CharacterMT__Index, CharacterModule, Characters, "GetCharacter"); -- same as "Characters.GetCharacter"
local getplayerfromcharacter = scall(CharacterMT__Index, CharacterModule, Characters, "GetPlayerFromCharacter"); -- same as "Characters.GetPlayerFromCharacter"
local getcharacter__call = getrawmetatable(getcharacter).__call;
local CharactersTable = getupvalue(getcharacter__call, 1);

local function GetCharacter(Player)
    if Player == LocalPlayer then
        return LocalPlayer.Character;
    end;
    return workspace:FindFirstChild(Player.Name);
end;

local function GetPlayerFromCharacter(Character)
    return scall(GetPlayerFromCharacter, CharacterModule, Character); -- same as "Characters.GetPlayerFromCharacter(Character)"
end;

--[[kill people]]
local function StabPlayer(Player)
    return FireRemote("kill", Player, newproxy(), nil, "stab"); --just like in the localknifehandler
end;

local KillQueue = {};
local KillKnife;
local OFFSET = Vector3.new(0, 2, 0);
local SpeedCFrame = CFrame.new(0, 0, 0, 1e8, 1e8, 1e8, 1e8, 1e8, 1e8, 1e8, 1e8, 1e8);
local function KillPlayer(Player)
    local Character = GetCharacter(LocalPlayer);
    local LocalHitbox = Character and FFC(Character, "baseHitbox");
    Character = GetCharacter(Player);
    local HitBox = Character and FFC(Character, "baseHitbox");
    if HitBox and LocalHitbox then
        local HBPos = HitBox.CFrame.Position;
        ThrowKnife:FireServer(HitBox.Position + OFFSET, 0, SpeedCFrame);
        repeat wait() until KillKnife;
        KillKnife.Position = HitBox.Position - OFFSET;
        FireRemote("kill", Player, newproxy(), KillKnife.Name, "throw", (KillKnife.Position - HitBox.Position).Magnitude, HitBox.Name, HitBox.Size, KillKnife.Position);
        KillKnife = nil;
    end;
end;

--[silent aim]
local FindPartOnRayWithIgnoreList = workspace.FindPartOnRayWithIgnoreList;
local function CoconutRay(...)
    if type(Coconut) == "table" and Coconut.Active and Coconut.SilentAim then
        local Target = (Coconut.SilentAimTarget == "Target / Bounty" and Target) or ClosestPlayerToMouse;
        local Char = Target and GetCharacter(Target);
        local HRP = Char and FFC(Char, "HumanoidRootPart");
        if HRP then
            return HRP, HRP.Position, HRP.Position, HRP.Material;
        end;
    end;

    return FindPartOnRayWithIgnoreList(...);
end;
--hook workspace's __namecall, so that workspace:CoconutRay calls CoconutRay, instead of erroring
local workspaceNC; workspaceNC = hookmetamethod(workspace, "__namecall", newcclosure(function(...)
    if getnamecallmethod() == "CoconutRay" then
        return CoconutRay(...);
    end;
    return workspaceNC(...);
end));

local KnifeHost = workspace.KnifeHost;
local wrap = coroutine.wrap;
local function FakeWrap(Func)
    local Constants = getconstants(Func);
    local IndexIn = (table.find(Constants, "FindPartOnRayWithIgnoreList"));
    if IndexIn then
        setconstant(Func, IndexIn, "CoconutRay");
    end;

    local upvalues = getupvalues(Func);
    local KnifeName = upvalues[1];
    local Player = upvalues[4];
    local Direction = upvalues[14];
    local PlayerKnife = upvalues[5];
    local v10 = PlayerKnife.Handle.CFrame.Position;
    

    if Player == LocalPlayer then
        local Knife = KnifeHost:FindFirstChild(KnifeName);

        if Knife then
            KillKnife = Knife;
        end;
    elseif Coconut.Dodge then
        task.delay(0.015, function()
            print("ZHII ZHIN WON POW");
            local PCharacter = Player and GetCharacter(Player);
            if PCharacter then
                print("WON POW ZHIN ZHII");
                local Knife = KnifeHost:FindFirstChild(KnifeName);

                if Knife then
                    print(Player, "threw", Knife);
                    local Moving = true;
                    task.spawn(function()
                        while Moving do
                            if not (Knife and Knife.Parent) then
                                Moving = false;
                            end;
                            wait();
                        end;
                    end);
                    local Character = LocalPlayer.Character;
                    local HRP = Character and FFC(Character, "HumanoidRootPart");
                    if HRP then
                        print("WE HAVE A HRP");

                        task.spawn(function()
                            while type(Coconut) == "table" and Coconut.Active and HRP and Knife and Moving do
                                local Distance = (HRP.Position - Knife.Position).Magnitude;
                                if Distance <= 15 then
                                    Moving = false;
                                    local OLD = HRP.Position;
                                    Character:MoveTo(HRP.Position + Vector3.new(-(Direction.XVector.X) * 5, 0, -(Direction.ZVector.Z) * 5));
                                    task.wait(Distance / 15);
                                    Character:MoveTo(OLD);
                                end;
                                wait();
                            end;
                        end);
                    end;
                end;
            end;
        end);
        return wrap(Func);
    end;

    return wrap(Func);
end;

local LocalKnifeHandler = LocalPlayer.PlayerScripts.localknifehandler;
local coroutineName = ("game"):rep(math.random(10, 20));

local DoThrowKnifeFunc;
for I, Func in next, getgc(false) do
    if type(Func) == "function" and islclosure(Func) and getfenv(Func).script == LocalKnifeHandler then
        local Constants = getconstants(Func);
        if Constants[19] == "coroutine" and Constants[20] == "wrap" then
            DoThrowKnifeFunc = Func;
            break;
        end;
    end;
end;
if DoThrowKnifeFunc then
    local fenv = getfenv(DoThrowKnifeFunc);
    fenv[coroutineName] = {["wrap"] = FakeWrap};
    setconstant(DoThrowKnifeFunc, 19, coroutineName);
end;

--[[stab aura]]

local function GetKnifeFromCharacter(Character)
    local Char = Character or GetCharacter(LocalPlayer);
    if Char then
        local Knife = FFC(Char, "Knife");
        if Knife then return Knife; end;
    end;
end;
local function GetKnifeFromBackpack()
    local Backpack = FFC(LocalPlayer, "Backpack");
    if Backpack then
        local Knife = FFC(Backpack, "Knife");
        if Knife then return Knife; end;
    end;
end;
local function GetKnife(Character, CheckBackpack)
    return GetKnifeFromCharacter(Character) or GetKnifeFromBackpack();
end;
local function EquipKnife(Humanoid)
    if not Humanoid then
        local Char = LocalPlayer.Character;
        Humanoid = Char and FFC(Char, "Humanoid");
    end;
    if Humanoid then
        local Knife = GetKnife();
        if Knife then
            Humanoid:EquipTool(Knife);
        end;
    end;
end;

tspawn(function()
    while not Coconut.Loaded and not Coconut.Active do
        twait();
    end;
    tspawn(function()
        while Coconut.Active do
            twait(.1);
            local LocalCharacter = GetCharacter(LocalPlayer);
            local LocalHumanoid = LocalCharacter and FFC(LocalCharacter, "Humanoid");

            if Coconut.AutoEquip then
                local BKnife = GetKnifeFromBackpack();
                if BKnife then
                    EquipKnife(LocalHumanoid);
                    GrayedLib:Notification{"Coconut", "Equipping Knife!", 0.5};
                end;
            end;
        end;
    end);
end);


--[[ClosestPlayerToMouse]]
tinsert(Coconut.Connections, game:GetService("RunService").RenderStepped:Connect(function()
    ClosestPlayerToMouseDistance = math.huge;
    local MouseLocation = GML(UIS);
    for I, Player in next, GetPlayers(Players) do
        if typeof(Player) == "Instance" and Player ~= LocalPlayer then
            local C = GetCharacter(Player);
            local HRP = C and FFC(C, "HumanoidRootPart");
            if typeof(HRP) == "Instance" then
                if ClosestPlayerToMouse then
                    local V2 = SpaceToVector2(HRP.Position);
                    local Distance = (MouseLocation - V2).Magnitude;
                    if Distance < ClosestPlayerToMouseDistance then
                        ClosestPlayerToMouseDistance = Distance;
                        ClosestPlayerToMouse = Player;
                    end;
                else
                    ClosestPlayerToMouse = Player;
                end;
            end;
        end;
    end;
end));

-- --[[hitbox extender]]
local baseHitboxSize = Vector3.new(2, 2, 1);
local baseTransparency = 1;
-- --[spoofer]
local oldGameIndex; oldGameIndex = hookmetamethod(game, "__index", newcclosure(function(...)
    local Self, Key = ...;

    if typeof(Self) == "Instance" and type(Key) == "string" and tostring(Self) == "HumanoidRootPart" and (Key == "Size" or Key == "Transparency") then
        if Key == "Size" then
            return baseHitboxSize;
        end;
        return baseTransparency;
    end;

    return oldGameIndex(...);
end));

--[actual extender]
local function ExtendHitbox(Character)
    local Suc, Hitbox = pcall(WFC, Character, "HumanoidRootPart");
    if Suc and Hitbox then
        -- TODO: make these settings
        Hitbox.Size = Vector3.new(10, 10, 10);
        Hitbox.Transparency = 0.5;
    end;
end;
local function ShrinkHitbox(Character)
    local Suc, Hitbox = pcall(FFC, Character, "HumanoidRootPart");
    if Suc and Hitbox then
        Hitbox.Size = baseHitboxSize;
        Hitbox.Transparency = baseTransparency;
    end;
end;

local function DoActionOnCharacters(Action, Args)
    for I, Player in next, GetPlayers(Players) do
        if typeof(Player) == "Instance" and Player ~= LocalPlayer then
            local C = GetCharacter(Player);
            local HRP = C and FFC(C, "HumanoidRootPart");
            if typeof(HRP) == "Instance" then
                task.spawn(Action, C, Args);
            end;
        end;
    end;
end;

local function ExtendHitboxes()
    DoActionOnCharacters(ExtendHitbox);
end;
local function ShrinkHitboxes()
    DoActionOnCharacters(ShrinkHitbox);
end;

local function CharacterAdded(Character)
    if not (type(Coconut) == "table" and Coconut.HitboxExtender) then return;end;
    task.spawn(ExtendHitbox, Character);
end;

local LNAME = LocalPlayer.Name;
workspace.ChildAdded:Connect(function(C)
    if not (typeof(C) == "Instance" and C:IsA"Model" and C.Name ~= LNAME) then return;end;
    if FFC(Players, C.Name) then
        CharacterAdded(C);
    end;
end);

--[[make it active so the scripts will work]]
Coconut.Active = true;

--[[executing script multiple times]]
Coconut.stop = function()
    GrayedLib:Notification{"Coconut", "Thanks for using Coconut!", 1};

    Coconut.Active = false;
    
    for I, Connection in next, Coconut.Connections do
        Connection:Disconnect();
    end;
    
    if Coconut.Gui then
        Coconut.Gui:Destroy();
    end;
    Coconut.Gui = nil;

    -- EradicateOldControlDelete();
    
    if DoThrowKnifeFunc then
        setconstant(DoThrowKnifeFunc, 19, "coroutine");
        local fenv = getfenv(DoThrowKnifeFunc);
        fenv[coroutineName] = nil;
    end;

    if UnAttachHRPToggle then
        UnAttachHRPOff();
    end;

    if CharactersTable then
        setmetatable(CharactersTable, nil);
    end;
    ShrinkHitboxes();

    GrayedLib:Notification{"Coconut", "Bye!", 1};
end;
shared.CoconutAssassin = Coconut;

--[[UI]]
local Gui = GrayedLib:CreateGui{"Coconut - Assassin"};
Coconut.Gui = Gui;

local function CreateToggleWithConfigValue(Section, Name, Index)
    return Section:Toggle{Name, function(Status)
        Coconut[Index] = Status;
    end};
end;

--[sections]
local MainSection = Gui:CreateSection{"Main"};
local MiscSection = Gui:CreateSection{"Misc"};
local UISection = Gui:CreateSection{"UI"};

--[objects]
--MainSection
CreateToggleWithConfigValue(MainSection, "Auto Equip Knife", "AutoEquip");
CreateToggleWithConfigValue(MainSection, "Stab Aura", "StabAura");
MainSection:Toggle{"Hitbox Extender", function(Status)
    Coconut.HitboxExtender = Status;

    if Status then
        ExtendHitboxes();
    else
        ShrinkHitboxes();
    end;
end};
local SilentAimK; SilentAimK = MainSection:Keybind{"Silent Aim [false]", function()
    Coconut.SilentAim = not Coconut.SilentAim;
    SilentAimK.Text = "Silent Aim [" .. tostring(Coconut.SilentAim) .. "]";
end, Enum.KeyCode.E};
MainSection:Dropdown{"^^Target", {"Target / Bounty", "Closest To Mouse"}, "Target / Bounty", function(Option)
    Coconut.SilentAimTarget = Option;
end};

--MiscSection
CreateToggleWithConfigValue(MiscSection, "Dodge (WIP)", "Dodge");
local UnAttachHRP; UnAttachHRP = MiscSection:Keybind{"Un-Attach HRP [false]", function()
    UnAttachHRPToggle = not UnAttachHRPToggle;
    UnAttachHRP.Text = "Un-Attach HRP [" .. tostring(UnAttachHRPToggle) .. "]";

    if UnAttachHRPToggle then
        UnAttachHRPOn();
    else
        UnAttachHRPOff();
    end;
end, Enum.KeyCode.T};

MiscSection:Keybind{"Kill Target", function()
    if Target then
        KillPlayer(Target);
    end;
end, Enum.KeyCode.F};
MiscSection:Keybind{"Kill Closest To Mouse", function()
    if ClosestPlayerToMouse then
        KillPlayer(ClosestPlayerToMouse);
    end;
end, Enum.KeyCode.R};

local VIPBarrier = Lobby:FindFirstChild("VIPBarrier");
MiscSection:Toggle{"No VIP Barrier", function(Status)
    if VIPBarrier then
        if Status then
            VIPBarrier.Parent = Lighting;
        else
            VIPBarrier.Parent = Lobby;
        end;
    end;
end};

MiscSection:Toggle{"Control Delete", function(Status)
    if Status then
        (function()
            --old
            local old = shared.CoconutCD;
            if old then
                old.stop();
                -- shared.CoconutCD = nil;
            end;

            --Setup
            local LocalPlayer = game:GetService("Players").LocalPlayer;
            local Mouse = LocalPlayer:GetMouse();

            local UIS = game:GetService("UserInputService");
            local ISK = UIS.IsKeyDown;

            local ControlKey = Enum.KeyCode.LeftControl;
            local UndoKey = Enum.KeyCode.Z;
            local RedoKey = Enum.KeyCode.Y;
            local MouseButton1 = Enum.UserInputType.MouseButton1;

            local DeletePart;
            local UndoDelete;
            local RedoDelete;

            local InputEndedCon = UIS.InputEnded:Connect(function(Input)
                if ISK(UIS, ControlKey) then
                    if Input.UserInputType == MouseButton1 then
                        DeletePart(Mouse.Target);
                    elseif Input.KeyCode == UndoKey then
                        UndoDelete();
                    elseif Input.KeyCode == RedoKey then
                        RedoDelete();
                    end;
                end;
            end);

            --Main
            local CD = {
                InputEndedCon = InputEndedCon,

                Index = old and old.Index or 0,
                Order = old and old.Order or {}
            };

            local Folder = Instance.new("Folder");
            Folder.Name = "CoconutCD";

            CD.stop = function()
                InputEndedCon:Disconnect();
            end;
            shared.CoconutCD = CD;

            local function Has(Part, Property)
                local Suc, Res = pcall(function()return Part[Property];end);
                return Suc;
            end;
            DeletePart = function(Part)
                CD.Index += 1;

                local Parent = Part.Parent;
                local T = {
                    Object = Part,
                    Parent = Parent,
                };
                Part.Parent = Folder;

                CD.Order[CD.Index] = T;
            end;

            UndoDelete = function()
                local Current = CD.Order[CD.Index];
                if Current then
                    Current.Object.Parent = Current.Parent;
                    
                    CD.Index -= 1;
                end;
            end;
            RedoDelete = function()
                local Next = CD.Order[CD.Index + 1];
                if Next then
                    Next.Object.Parent = Folder;
                    
                    CD.Index += 1;
                end;
            end;
        end)();
    else
        local old = shared.CoconutCD;
        if old then
            old.stop();
            -- shared.CoconutCD = nil;
        end;
    end;
end};

--UISection
UISection:Button{"Stop script", Coconut.stop};

local ThemeDropdownOptions = {};
for Theme, V in next, Gui.Themes do
    tinsert(ThemeDropdownOptions, Theme);
end;
UISection:Dropdown{"Theme", ThemeDropdownOptions, "Dark", function(Option) Gui:ChangeTheme(Option) end};

GrayedLib:Notification{"Coconut loaded!", "Message TechHog#8984 if\nyou have any issues.", 1};

