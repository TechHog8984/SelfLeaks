--[=[

this is a network spy for Assasin.
it's just a gui that shows packets as they get sent.
i found it super fascinating.

it uses `syn.set_thread_identity` so it won't run from the getgo even if it does still work.
i don't think the syntax highlighting was good but i don't remember 100%

reach out to me @techhog on discord if you have any questions

]=]

local function GetGUI()
    --GuiToLua V3

    --objects
    local Assassin_Network_Spy = Instance.new'ScreenGui'

    local Main = Instance.new'Frame'
    local TabButtons = Instance.new'Frame'
    local UIListLayout = Instance.new'UIListLayout'
    local _Ping = Instance.new'TextButton'
    local _Misc = Instance.new'TextButton'
    local _Kill = Instance.new'TextButton'
    local Title = Instance.new'TextLabel'
    local Tab = Instance.new'Frame'
    local Title__2 = Instance.new'TextLabel'
    local LogContainer = Instance.new'ScrollingFrame'
    local UIListLayout__2 = Instance.new'UIListLayout'
    local Log = Instance.new'TextButton'
    local Clear = Instance.new'TextButton'
    local Close = Instance.new'TextButton'
    local Viewer = Instance.new'Frame'
    local Title__3 = Instance.new'TextLabel'
    local Close__2 = Instance.new'TextButton'
    local Text = Instance.new'TextBox'

    --properties
    Assassin_Network_Spy.Name = "Assassin Network Spy"
    Assassin_Network_Spy.Parent = game:GetService"CoreGui";
    Assassin_Network_Spy.ResetOnSpawn = false
    Assassin_Network_Spy.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Main.BorderColor3 = Color3.fromRGB(255, 255, 255)
    Main.Name = "Main"
    Main.Parent = Assassin_Network_Spy
    Main.Position = UDim2.new(0.2694703936576843, 0, 0.28421053290367126, 0)
    Main.Size = UDim2.new(0, 442, 0, 355)

    TabButtons.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabButtons.Name = "TabButtons"
    TabButtons.Parent = Main
    TabButtons.Position = UDim2.new(0, 0, 0.10169491171836853, 0)
    TabButtons.Size = UDim2.new(1, 0, 0, 31)

    UIListLayout.Parent = TabButtons
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal

    _Ping.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    _Ping.BorderColor3 = Color3.fromRGB(255, 255, 255)
    _Ping.Name = "#Ping"
    _Ping.Parent = TabButtons
    _Ping.Size = UDim2.new(0.3330523371696472, 0, 1, 0)
    _Ping.Font = Enum.Font.Nunito
    _Ping.Text = "Ping"
    _Ping.TextColor3 = Color3.fromRGB(255, 255, 255)
    _Ping.TextSize = 29

    _Misc.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    _Misc.BorderColor3 = Color3.fromRGB(255, 255, 255)
    _Misc.Name = "@Misc"
    _Misc.Parent = TabButtons
    _Misc.Position = UDim2.new(0.3330523371696472, 0, 0, 0)
    _Misc.Size = UDim2.new(0.3334737718105316, 0, 1, 0)
    _Misc.Font = Enum.Font.Nunito
    _Misc.Text = "Misc"
    _Misc.TextColor3 = Color3.fromRGB(255, 255, 255)
    _Misc.TextSize = 29

    _Kill.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    _Kill.BorderColor3 = Color3.fromRGB(255, 255, 255)
    _Kill.Name = "!Kill"
    _Kill.Parent = TabButtons
    _Kill.Position = UDim2.new(0.6665262579917908, 0, 0, 0)
    _Kill.Size = UDim2.new(0.3334737718105316, 0, 1, 0)
    _Kill.Font = Enum.Font.Nunito
    _Kill.Text = "Kill"
    _Kill.TextColor3 = Color3.fromRGB(255, 255, 255)
    _Kill.TextSize = 29

    Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Title.BorderColor3 = Color3.fromRGB(255, 255, 255)
    Title.Name = "Title"
    Title.Parent = Main
    Title.Size = UDim2.new(1, 0, 0, 36)
    Title.Font = Enum.Font.Roboto
    Title.Text = "Assassin Network Spy"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 29

    Tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Tab.BackgroundTransparency = 1
    Tab.BorderSizePixel = 0
    Tab.Name = "Tab"
    Tab.Parent = Main
    Tab.Position = UDim2.new(0, 0, 0.1889999955892563, 5)
    Tab.Size = UDim2.new(1, 0, 0, 282)

    Title__2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Title__2.BorderColor3 = Color3.fromRGB(255, 255, 255)
    Title__2.Name = "Title"
    Title__2.Parent = Tab
    Title__2.Size = UDim2.new(0, 348, 0, 22)
    Title__2.Font = Enum.Font.Roboto
    Title__2.Text = "Kill"
    Title__2.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title__2.TextSize = 23

    LogContainer.Active = true
    LogContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    LogContainer.BorderColor3 = Color3.fromRGB(255, 255, 255)
    LogContainer.Name = "LogContainer"
    LogContainer.Parent = Tab
    LogContainer.Position = UDim2.new(0, 0, 0, 29)
    LogContainer.Size = UDim2.new(1, 0, 0, 255)
    LogContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    LogContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    LogContainer.ScrollingDirection = Enum.ScrollingDirection.Y

    UIListLayout__2.Parent = LogContainer
    UIListLayout__2.SortOrder = Enum.SortOrder.LayoutOrder

    Log.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Log.BorderColor3 = Color3.fromRGB(255, 255, 255)
    Log.Name = "Log"
    Log.Parent = LogContainer
    Log.Size = UDim2.new(1, 0, 0, 20)
    Log.Font = Enum.Font.Nunito
    Log.Text = "Log"
    Log.TextColor3 = Color3.fromRGB(255, 255, 255)
    Log.TextSize = 23

    Clear.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Clear.BorderColor3 = Color3.fromRGB(255, 255, 255)
    Clear.Name = "Clear"
    Clear.Parent = Tab
    Clear.Position = UDim2.new(0.7873303294181824, 0, -0.0011239401064813137, 0)
    Clear.Size = UDim2.new(0, 94, 0, 22)
    Clear.Font = Enum.Font.Nunito
    Clear.Text = "Clear"
    Clear.TextColor3 = Color3.fromRGB(255, 255, 255)
    Clear.TextSize = 23

    Close.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Close.BorderColor3 = Color3.fromRGB(255, 255, 255)
    Close.Name = "Close"
    Close.Parent = Main
    Close.Position = UDim2.new(0.918552041053772, 0, 0, 0)
    Close.Size = UDim2.new(0, 36, 0, 36)
    Close.Font = Enum.Font.Nunito
    Close.Text = "X"
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
    Close.TextSize = 35

    Viewer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Viewer.BorderColor3 = Color3.fromRGB(255, 255, 255)
    Viewer.Name = "Viewer"
    Viewer.Parent = Assassin_Network_Spy
    Viewer.Position = UDim2.new(0.2907627522945404, 0, 0.3082777261734009, 0)
    Viewer.Size = UDim2.new(0, 386, 0, 313)

    Title__3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Title__3.BorderColor3 = Color3.fromRGB(255, 255, 255)
    Title__3.Name = "Title"
    Title__3.Parent = Viewer
    Title__3.Size = UDim2.new(1, 0, 0, 36)
    Title__3.Font = Enum.Font.Roboto
    Title__3.Text = "Viewer"
    Title__3.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title__3.TextSize = 29

    Close__2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Close__2.BorderColor3 = Color3.fromRGB(255, 255, 255)
    Close__2.Name = "Close"
    Close__2.Parent = Viewer
    Close__2.Position = UDim2.new(0.9055987000465393, 0, 0, 0)
    Close__2.Size = UDim2.new(0, 36, 0, 36)
    Close__2.Font = Enum.Font.Nunito
    Close__2.Text = "X"
    Close__2.TextColor3 = Color3.fromRGB(255, 255, 255)
    Close__2.TextSize = 35

    Text.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Text.BorderColor3 = Color3.fromRGB(255, 255, 255)
    Text.ClearTextOnFocus = false
    Text.Name = "Text"
    Text.Parent = Viewer
    Text.Position = UDim2.new(0, 0, 0.11821085959672928, 0)
    Text.Size = UDim2.new(0, 385, 0, 276)
    Text.TextEditable = false;
    Text.Font = Enum.Font.Code
    Text.PlaceholderText = "Text here..."
    Text.RichText = true
    Text.Text = ""
    Text.TextColor3 = Color3.fromRGB(255, 255, 255)
    Text.TextSize = 17
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.TextYAlignment = Enum.TextYAlignment.Top


    return Assassin_Network_Spy;
end;

local Highlighter = (function()
        --[[string & table functions]]
    local insert = table.insert;
    local concat = table.concat;

    local gsub = string.gsub;
    local sub = string.sub;
    local format = string.format;
    local match = string.match;
    local reverse = string.reverse;
    local split = function(Str)
        local Split = {};
        gsub(Str, ".", function(c)insert(Split, c)end);
        return Split;
    end;

    --[[color formats]]
    local KeywordColorFormat = "<b><font color = 'rgb(248, 109, 124)'>%s</font></b>"
    local StringColorFormat = "<font color = 'rgb(173, 241, 149)'>%s</font>";
    local BuiltInFunctionColorFormat = "<font color = 'rgb(132, 214, 247)'>%s</font>";
    local NumberColorFormat = "<font color = 'rgb(255, 198, 0)'>%s</font>";
    local FunctionCallColorFormat = "<font color = 'rgb(253, 251, 172)'>%s</font>";

    --[[misc]]
    local FilterHightlightsPattern = "<font color = 'rgb%(([%d]+), ([%d]+), ([%d]+)%)'>([^<]+)</font>";
    local function FilterHighlights(Text)
        return (gsub(Text, FilterHightlightsPattern, function(...)
            local R, G, B, Inside = ...;
            return Inside;
        end));
    end;
    local function StringToTable(String)
        local Table = {};
        gsub(String:gsub("[ \t]", ""), "([^\n]+)", function(Value)
            insert(Table, Value);
        end);
        return Table;
    end;

    --[[main]]
    local Highlighter = {split = split};

    Highlighter.RobloxGlobals = StringToTable[[assert
        collectgarbage
        error
        getfenv
        getmetatable
        ipairs
        loadstring
        newproxy
        next
        pairs
        pcall
        print
        rawequal
        rawget
        rawset
        select
        setfenv
        setmetatable
        tonumber
        tostring
        type
        unpack
        xpcall
        delay
        elapsedTime
        LoadLibrary
        printidentity
        require
        settings
        spawn
        stats
        tick
        time
        typeof
        UserSettings
        version
        wait
        warn

        Enum
        game
        plugin
        shared
        script
        workspace
    ]];
    Highlighter.Keywords = StringToTable[[local
        function
        do
        for
        in
        if
        then
        end
        or
        and
        not
        continue
        elseif
    ]];

    do
        function Highlighter:DoQuotes(Text, Split, Colors)
            local Split = Split or split(Text);

            local QuoteStartOrEndIndexes = {};
            local SingleQuoteStartOrEndIndexes = {};

            local Backslashes = {};
            local EscapeSlashes = {};
            for I, Character in next, Split do
                if Character == "\\" then
                    Backslashes[I] = Character;
                end;
            end;
            local IndexInBackslashes = 0;
            for I, Slash in next, Backslashes do
                local Before = Backslashes[I - 1];
                if Before then
                    Backslashes[I] = nil;
                    Backslashes[I - 1] = nil;
                    continue;
                end
                local After = Split[I + 1];
                if After and (After == '"' or After == "'") then
                    EscapeSlashes[I] = Slash;
                end;
            end;

            for I, Character in next, Split do
                local Before = I - 1 > 0 and Split[I - 1];

                if not Before or not EscapeSlashes[I - 1] then 
                    if Character == '"' then
                        insert(QuoteStartOrEndIndexes, I);
                    elseif Character == "'" then
                        insert(SingleQuoteStartOrEndIndexes, I);
                    end;
                end;
            end;

            local QuoteStartToEnd = {};
            local SingleQuoteStartToEnd = {};

            for Start = 1, #Split do
                local QuoteIndex = table.find(QuoteStartOrEndIndexes, Start);
                if QuoteIndex and QuoteIndex % 2 ~= 0 then
                    local EndIndex = QuoteStartOrEndIndexes[QuoteIndex + 1];
                    if EndIndex then
                        for I = Start + 1, EndIndex - 1 do
                            local SingleQuoteIndex = table.find(SingleQuoteStartOrEndIndexes, I);
                            if SingleQuoteIndex then
                                table.remove(SingleQuoteStartOrEndIndexes, SingleQuoteIndex);
                            end;
                        end;
                    end;
                    QuoteStartToEnd[Start] = EndIndex or false;
                end;

                local SingleQuoteIndex = table.find(SingleQuoteStartOrEndIndexes, Start);
                if SingleQuoteIndex and SingleQuoteIndex % 2 ~= 0 then
                    local EndIndex = SingleQuoteStartOrEndIndexes[SingleQuoteIndex + 1];
                    if EndIndex then
                        for I = Start + 1, EndIndex - 1 do
                            local QuoteIndex = table.find(QuoteStartOrEndIndexes, I);
                            if QuoteIndex then
                                table.remove(QuoteStartOrEndIndexes, QuoteIndex);
                            end;
                        end;
                    end;
                    SingleQuoteStartToEnd[Start] = EndIndex or false;
                end;
            end;

            for StartIndex, EndIndex in next, QuoteStartToEnd do
                local Formatted = "";
                for I = StartIndex, EndIndex or #Split do
                    Formatted ..= Split[I];
                    Split[I] = "";
                end;
                if #Formatted > 0 then
                    Colors[StartIndex] = format(StringColorFormat, Formatted);
                end;
            end;

            for StartIndex, EndIndex in next, SingleQuoteStartToEnd do
                local Formatted = "";
                for I = StartIndex, EndIndex or #Split do
                    Formatted ..= Split[I];
                    Split[I] = "";
                end;
                if #Formatted > 0 then
                    Colors[StartIndex] = format(StringColorFormat, Formatted);
                end;
            end;

            return QuoteStartToEnd, SingleQuoteStartToEnd;
        end;
        function Highlighter:DoRobloxGlobals(Text, Split, Colors)
            local Split = Split or split(Text);

            local Indexes = {};
            for I, Character in next, Split do
                for _, Func in next, Highlighter.RobloxGlobals do
                    local Length = #Func;
                    local Found = 0;
                    for X = 1, Length do
                        if Split[I + X - 1] == sub(Func, X, X) then
                            Found += 1;
                        end;
                    end;

                    if Found == Length then
                        Indexes[I] = I + Length - 1;
                    end;
                end;
            end;

            for StartIndex, EndIndex in next, Indexes do
                if #Split > EndIndex then
                    local CharAfterEnd = Split[EndIndex + 1];
                    if CharAfterEnd and not (CharAfterEnd == "" or CharAfterEnd == " " or CharAfterEnd == "\t" or CharAfterEnd == ";" or CharAfterEnd == "(" or CharAfterEnd == "." or CharAfterEnd == ":") then
                        continue;
                    end
                end;

                local Formatted = "";

                for I = StartIndex, EndIndex do
                    Formatted ..= Split[I];
                    Split[I] = "";
                end

                if #Formatted > 0 then
                    Colors[StartIndex] = format(BuiltInFunctionColorFormat, Formatted);
                end;
            end;
        end;
        function Highlighter:DoKeywords(Text, Split, Colors)
            local Split = Split or split(Text);

            local Indexes = {};
            for I, Character in next, Split do
                for _, Func in next, Highlighter.Keywords do
                    local Length = #Func;
                    local Found = 0;
                    for X = 1, Length do
                        if Split[I + X - 1] == sub(Func, X, X) then
                            Found += 1;
                        end;
                    end;

                    if Found == Length then
                        Indexes[I] = I + Length - 1;
                    end;
                end;
            end;
            for StartIndex, EndIndex in next, Indexes do
                local CharAfterEnd = Split[EndIndex + 1];
                if #Split > EndIndex and CharAfterEnd then
                    if not (CharAfterEnd == "" or CharAfterEnd == " " or CharAfterEnd == "\t" or CharAfterEnd == "\n" or CharAfterEnd == ";") then
                        continue;
                    end
                end;
                local CharBefore = Split[StartIndex - 1];
                if CharBefore and not (CharBefore == "" or CharBefore == " " or CharBefore == "\t" or CharBefore == "\n" or CharBefore == ";") then
                    continue;
                end

                local Formatted = "";

                for I = StartIndex, EndIndex do
                    Formatted ..= Split[I];
                    Split[I] = "";
                end

                if #Formatted > 0 then
                    Colors[StartIndex] = format(KeywordColorFormat, Formatted);
                end;
            end;
        end;
        function Highlighter:DoNumbers(Text, Split, Colors)
            local Split = Split or split(Text);

            local Indexes = {};
            for I, Character in next, Split do
                if match(Character, "%d") then
                    local Before = Split[I - 1];
                    local ValidNumber = (not Before) or false;
                    if Before and match(Before, "%d") then 
                        if Indexes[I - 1] then 
                            ValidNumber = true; 
                        else 
                            continue;
                        end;
                    end;
                    if not (ValidNumber or Before == "." or Before == "" or Before == " " or Before == ")" or Before == "\t" or Before == "\n" or Before == ";") then
                        continue;
                    end
                    Indexes[I] = Character;
                elseif Character == "." then
                    local Before = Split[I - 1];
                    local After = Split[I + 1];

                    if (Before and match(Before, "%d")) or (After and match(After, "%d")) then
                        Indexes[I] = Character;
                    end;
                end;
            end;

            for Index, Character in next, Indexes do		
                Colors[Index] = format(NumberColorFormat, Character);
            end;
        end;
    end;

    local RichTextEscapeCharacters = {
        ["<"] = "&lt;",
        [">"] = "&gt;",
        ["&"] = "&amp;"
    };

    local InsertRichTextEscapeCharacters; do
        local function Handler(Character)
            return RichTextEscapeCharacters[Character] or Character;
        end;
        InsertRichTextEscapeCharacters = function(Text)
            return (gsub(Text, ".", Handler));
        end;
    end;

    function Highlighter:Highlight(Text)
        local Text = InsertRichTextEscapeCharacters(Text);
        local Split = Highlighter.split(Text);
        local Colors = {};

        --get colors
        Highlighter:DoQuotes(Text, Split, Colors);
        Highlighter:DoRobloxGlobals(Text, Split, Colors);
        Highlighter:DoKeywords(Text, Split, Colors);
        Highlighter:DoNumbers(Text, Split, Colors);

        --apply colors
        for Index, Value in next, Colors do
            Split[Index] = Value;
        end;

        return concat(Split);
    end;

    return Highlighter;
end)();
local FormatTuple = (function()
    local s = string;
    local sformat = s.format;
    
    local Tostring2, Types, Datatypes = loadstring(game:HttpGet"https://gitlab.com/te4224/Scripts/-/raw/main/Chrysalism/V1/tostring2.lua")();
    
    local ConcatKeyItemPattern = "[%s] = %s,\n";
    local ConcatItemPattern = "%s,\n";
    local function FormatTable(Table, IndentLevel)
        local Formatted = "{\n";
    
        local IndentLevel, IndentString = (IndentLevel or 1) + 1, "\t";
        local NumberIndexes = 1;
        local IndexCount = 0;
        for Index, Value in next, Table do
            IndentString = "";
            for i = 1, IndentLevel do
                IndentString ..= "\t";
            end;
            IndexCount += 1;
            local IndexString, ValueString;
            IndexString = Tostring2(Index);
    
            if type(Value) == "table" then
                ValueString = FormatTable(Value, IndentLevel + 1);
            else
                ValueString = Tostring2(Value);
            end;
            if type(Index) == "number" and Index == NumberIndexes then
                NumberIndexes += 1;
                Formatted ..= IndentString .. sformat(ConcatItemPattern, ValueString);
            else
                Formatted ..= IndexString .. sformat(ConcatKeyItemPattern, IndexString, ValueString);
            end;
        end;
    
        IndentString = "";
        for i = 2, IndentLevel do
            IndentString ..= "\t";
        end;
    
        Formatted ..= IndentString .. "}";
    
        return Formatted;
    end;
    local function FormatTuple(IndentLevel, ...)
        local Formatted = "(\n";

        local IndentLevel, IndentString = (IndentLevel or 1) + 1, "\t";
        local NumberIndexes = 1;
        local IndexCount = 0;

        local function Skr(Value)
            IndentString = ("\t"):rep(IndentLevel);
            IndexCount += 1;

            local ValueString;
            
            if type(Value) == "table" then
                ValueString = FormatTable(Value, IndentLevel + 1);
            else
                ValueString = Tostring2(Value);
            end;
            Formatted ..= IndentString .. sformat(ConcatItemPattern, ValueString);
        end;

        for Index, Value in next, {...} do
            if Index ~= NumberIndexes then
                Skr(nil);
            end;
            Skr(Value)
            NumberIndexes += 1;
        end;

        IndentString = "";
        for i = 2, IndentLevel do
            IndentString ..= "\t";
        end;
    
        Formatted ..= IndentString .. ")";

        return Formatted;
    end;
    
    return FormatTuple;
end)();

local GUI = GetGUI();
local Viewer = GUI.Viewer;Viewer.Active = true;Viewer.Draggable = true;
local Main = GUI.Main;Main.Active = true;Main.Draggable = true;
local TabButtons = Main.TabButtons;
local TabTemplate = Main.Tab;TabTemplate.Parent=nil;
local LogTemplate = TabTemplate.LogContainer.Log;LogTemplate.Parent = nil;
local Tabs = {};

Main.Close.MouseButton1Click:Connect(function()
    GUI:Destroy();
end);
Viewer.Close.MouseButton1Click:Connect(function()
    Viewer.Visible = false;
end);
Viewer.Visible = false;

for I, Button in next, TabButtons:GetChildren() do
    if Button.ClassName ~= "TextButton" then continue;end;
    local Name = Button.Name:sub(2, -1);
    local Tab = TabTemplate:Clone();
    Tab = TabTemplate:Clone();
    Tab.Parent = Main;
    Tab.Name = Name;
    Tab.Title.Text = Name;
    Tabs[Name] = Tab;

    Button.MouseButton1Click:Connect(function()
        for N, T in next, Tabs do
            T.Visible = false;
        end;
        Tab.Visible = true;
    end);
end;

local function Log(Type, Args)
    print"_____";
    print(Type);
    table.foreach(Args, print);
    print"_____";

    local Tab = Tabs[Type];
    local LogContainer = Tab:FindFirstChild"LogContainer";

    -- print(Tab);

    local Log = LogTemplate:Clone();
    Log.Visible = true;
    Log.Parent = LogContainer;
    Log.MouseButton1Click:Connect(function()
        local o = syn.get_thread_identity();
        syn.set_thread_identity(3);

        Viewer.Text.Text = Highlighter:Highlight(FormatTuple(nil, unpack(Args)));
        Viewer.Visible = true;

        syn.set_thread_identity(o);
    end);
end;


local scall = syn and syn.secure_call or secure_call or securecall;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local BACFolder = ReplicatedStorage.BAC;
local NetworkModule = BACFolder.Network;

local Network = require(NetworkModule);
local NetworkMT = getrawmetatable(Network);
local NetworkMT__Index = NetworkMT.__index;

local FireServer = scall(NetworkMT__Index, NetworkModule, Network, "FireServer") -- same as "Network.FireServer"
local OldCall = getrawmetatable(FireServer).__call;
local function FireRemote(...)
    return scall(OldCall, NetworkModule, FireServer, ...);   -- same as "Network.FireServer(...)"
end;

local function checkArg(arg, check)
    return type(arg) == type(check) and arg == check;
end;
getrawmetatable(FireServer).__call = function(...)
    if GUI and GUI.Parent then
        local self, args = (...), {select(2, ...)};
        local Type = "Misc";
        if checkArg(args[1], "BAC") and checkArg(args[2], "Ping") then
            Type = "Ping";
        elseif checkArg(args[1], "kill") then
            Type = "Kill";
        end;
        
        local o = syn.get_thread_identity();
        syn.set_thread_identity(3);
            Log(Type, args);
        syn.set_thread_identity(o);
    end;

    return OldCall(...);

end;
