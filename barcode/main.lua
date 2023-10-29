-- the main file

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
local function require(module)
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

BarcodeC.SelectConfig = require("config.lua");

BarcodeC.Collection = getgc(false);
-- require("acBypass1.lua");

BarcodeC.loadingUI = require("loadingUI.lua");
BarcodeC.getCharacter = require("getCharacter.lua");

BarcodeC.getKnifeFromCharacter, BarcodeC.getKnifeFromBackpack, BarcodeC.getKnife, BarcodeC.equipKnife = require("knife.lua");
BarcodeC.checkKnife = require("checkKnife.lua");
BarcodeC.fireRemote = require("fireRemote.lua");
BarcodeC.throwAt = require("throwAt.lua");
BarcodeC.killPlayer = require("killPlayer.lua");
BarcodeC.stabPlayer = require("stabPlayer.lua");

BarcodeC.playTween, BarcodeC.createTween = require("tween.lua");

require("closestPlayerToMouse.lua");
require("target.lua");
require("autoEquip.lua");
require("autoThrow.lua");
require("silentAim.lua");
require("hitboxExtender.lua");

require("acBypass2.lua");
BarcodeC.Fly = require("fly.lua");
require("autoFarm.lua");

BarcodeC.fakeWrap = require("fakeWrap.lua");
BarcodeC.wrapFunc = require("wrapFunc.lua");

BarcodeC.ChatFunction, BarcodeC.SetChatColor, BarcodeC.SetChatTag = require("chat.lua");

-- require("skinChanger.lua");

require("killAllAutofarmV1.lua");
BarcodeC.Esp = require("Esp.lua");
task.spawn(function()
    BarcodeC.Loaded = true;
    BarcodeC.LoadingTimeTaken = os.time() - OldTime;
    task.wait(0.5);
    BarcodeC.loadingUI:Destroy();

    -- require("ui.lua");
    require("ui2.lua");
    -- require("ui3.lua");
    require("extras.lua");
end);
