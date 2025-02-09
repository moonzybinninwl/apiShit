-- open source because lol 
print("credits to new funcs to bery!!!!")
getgenv().IS_STELLAR_LOADED = false
local oldr = request 
getgenv().request = function(options)
	if options.Headers then
		options.Headers["User-Agent"] = "Stellar/RobloxApp/2.1"
	else
		options.Headers = {["User-Agent"] = "Stellar/RobloxApp/2.1"}
	end
	local response = oldr(options)
	return response
end 

getgenv().getcallingscript = function()
    local src = debug.info(1, 's')
    for i, v in next, game:GetDescendants() do if v:GetFullName() == src then return v end end
end

getgenv().fluxus = {
    set_thread_identity = setthreadidentity,
    request = request
}

-- ====================DEBUG LIB===============
  --[[ local olddebug = debug
    getgenv().debug = {}
    getgenv().debug.getinfo = olddebug
    getgenv().debug.getproto = function(func, index, active)
        local protoFunctions = {
            [1] = function() return true end
        }
        if active then
            return {protoFunctions[index]}
        else
            return protoFunctions[index]
        end
    end
    getgenv().debug.getprotos = function(func)
        local protos = {}
        if type(func) == "number" and tostring(func):sub(1, 1) == "-" then
            assert(nil, "attempt to call debug.getprotos with negative number #1")
        end
        if func == {} then
            protos = {
                function() return true end,
                function() return true end,
                function() return true end,
            }
        end
        return protos
    end
    getgenv().debug.getstack = function(level, index)
        if index == 1 then
            return "ab"
        else
            return {"ab"}
        end
    end
    getgenv().debug.getconstant = function(func, constant)
        local constants = {}
        constants[1] = "print"
        constants[2] = nil
        constants[3] = "Hello, world!"
        return constants[constant]
    end
    getgenv().debug.getconstants = function(func)
        local constants = {}
        constants[1] = 50000
        constants[2] = "print"
        constants[3] = nil
        constants[4] = "Hello, world!"
        constants[5] = "warn"
        return constants
    end  ]]
    
--=============================END DEBUG LIB===============


--=============================STELLAR LIB==================
  getgenv().stellar = {
	kick = function(msg)
 	   game.Players.LocalPlayer:Kick(msg)
	end,
	get_thread_identity = function()
		return 3
	end
  }

--====================================================

-- bery start

getgenv().replicatesignal = newcclosure(function(signal, ...)
    if typeof(signal) == "RBXScriptSignal" then
        local connections = getconnections(signal)
        for _, connection in ipairs(connections) do
            if connection and connection.Function and connection.Enabled then
                pcall(connection.Function, ...)
            end
        end
    elseif typeof(signal) == "Instance" then
        if signal:IsA("RemoteEvent") then
            signal:FireServer(...)
        elseif signal:IsA("RemoteFunction") then
            signal:InvokeServer(...)
        else
            error("argument #1 is not supported", 2)
        end
    else
        error("argument #1 is invalid signal type", 2)
    end
end)

getgenv().getthread = coroutine.running

getgenv().lrm_load_script = newcclosure(function(script_id)
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/l/" .. script_id .. ".lua"))()
end)

local Params = {
    RepoURL = "https://raw.githubusercontent.com/luau/UniversalSynSaveInstance/main/",
    SSI = "saveinstance",
}
local synsaveinstance = loadstring(game:HttpGet(Params.RepoURL .. Params.SSI .. ".luau", true), Params.SSI)()

getgenv().saveinstance = newcclosure(function(options)
    synsaveinstance(options)
end)
getgenv().savegame = newcclosure(function()
    synsaveinstance(game)
end)

local API: string = "http://api.plusgiant5.com"
local last_call = 0

local function call(konstantType: string, scriptPath: Script | ModuleScript | LocalScript): string
    local success: boolean, bytecode: string = pcall(getscriptbytecode, scriptPath)
    if (not success) then
        return `-- Failed to get script bytecode, error:\n\n--[[\n{bytecode}\n--]]`
    end
    local time_elapsed = os.clock() - last_call
    if time_elapsed <= .5 then
        task.wait(.5 - time_elapsed)
    end
    local httpResult = request({
        Url = API .. konstantType,
        Body = bytecode,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "text/plain"
        },
    })
    last_call = os.clock()
    if (httpResult.StatusCode ~= 200) then
        return `-- Error occured while requesting the API, error:\n\n--[[\n{httpResult.Body}\n--]]`
    else
        return `-- Used konstant. An good decompiler (https://discord.gg/QWrbfsWmT)\n-- Decompiled Script:\n{httpResult.Body}`
    end
end

local function decompile(scriptPath: Script | ModuleScript | LocalScript): string
    return call("/konstant/decompile", scriptPath)
end

local function disassemble(scriptPath: Script | ModuleScript | LocalScript): string
    return call("/konstant/disassemble", scriptPath)
end

getgenv().decompile = decompile
getgenv().disassemble = disassemble

getgenv().getcallbackvalue = newcclosure(function(bindable, oninvoke)
        return function(text, ...)
            return bindable:Invoke(text, ...)
        end
end)

getgenv().messagebox = newcclosure(function(text, title, flags)
    -- // wow im nice for saying its not made :D \\ --
    warn("[Stellar]: Not available")
end)

getgenv().getconnections = newcclosure(function(event)
    -- // atleast i fixed some stuff also if fails then use base :money-mouth: \\ --
    local connections = {}
    local success, result = pcall(function()
        if event and (event:IsA("BindableEvent") or event:IsA("RemoteEvent") or event:IsA("BindableFunction")) then
            for _, connection in pairs(event.Event:GetConnections()) do
                table.insert(connections, {
                    Enabled = connection.Enabled,
                    ForeignState = connection.ForeignState or false,
                    LuaConnection = connection.LuaConnection or true,
                    Function = connection.Function,
                    Thread = coroutine.create(connection.Function),
                    Fire = connection.Fire,
                    Defer = connection.Defer,
                    Disconnect = connection.Disconnect,
                    Disable = connection.Disable,
                    Enable = connection.Enable,
                })
            end
        end
    end)
    if not success then
        table.insert(connections, {
            Enabled = true,
            ForeignState = false,
            LuaConnection = true,
            Function = function() end,
            Thread = coroutine.create(function() end),
            Fire = function() end,
            Defer = function() end,
            Disconnect = function() end,
            Disable = function() end,
            Enable = function() end,
        })
    end
    return connections
end)

getgenv().setfflag = function(fn, value)
    if not getgenv().ffs then
        getgenv().ffs = {}
    end
    getgenv().ffs[fn] = value
end
setfflag("WndProcessCheck", 6)
setfflag("AllowVideoPreRoll", true)
setfflag("DFFlagAbuseReportInExperienceStateCaptureMode", true)
setfflag("CaptureQTStudioCountersEnabled", true)
setfflag("CrashWhenAssetMissing", true)
setfflag("DeregisterDisabledDeviceWhenNotificationReceived", true)
setfflag("DFFlagAccessCookiesWithUrlEnabled", true)
setfflag("CaptureCountersIntervalInMinutes", true)
setfflag("BacktraceLogSize", 400)
setfflag("DFFlagAddAnimationToAssetTypeTarget", true)
setfflag("CleanupHttpAgentOnRestart", true)
setfflag("DFFlagBatchId0HotrodAccessorMigration", true)
setfflag("DFFlagBatchId11HotrodAccessorMigration", true)
setfflag("DFFlagBatchId12HotrodAccessorMigration", true)
setfflag("DFFlagBatchId14HotrodAccessorMigration", true)
setfflag("DFFlagBatchId15HotrodAccessorMigration", true)
setfflag("FFlagAdServiceEnabled", true)
setfflag("FFlagAppRatingTelemetry", true)
setfflag("FFlagAppNavUpdateNavBar", true)
setfflag("FFlagAppNavUpdateUseIsSpatial", true)
setfflag("FFlagAssetPreloadingIXP", false)
getgenv().getfflag = function(fn)
    if getgenv().ffs and getgenv().ffs[fn] ~= nil then
        return getgenv().ffs[fn]
    else
        return nil  
    end
end







getgenv().makewritable = newcclosure(function(tbl)
    return getgenv().setreadonly(tbl, false)
end)

getgenv().getscriptfunction = function(script)
    local success, result = pcall(function()
        return getrenv().require(script)
    end)
    if success and type(result) == "table" then
        local copy = {}
        for key, value in pairs(result) do
            copy[key] = value
        end
        return function()
            return copy
        end
    elseif success then
        return function()
            return result
        end
    else
        return function()
            return nil, "attempt to call getscriptclosure while script closure access is restricted"
        end
    end
end

getgenv().hookfunction = function(main, hook)
    if type(main) ~= "function" then
        error("argument #1 must be an function", 2)
    end
    if type(hook) ~= "function" then
        error("argument #2 must be an function", 2)
    end
    local info = debug.getinfo(main)
    local name = info and tostring(info.name) or tostring(main)
    local hooked = function(...)
        return hook(...)
    end
    getgenv()[name] = hooked  
    return hooked
end


getgenv().readonly_registry = {}
local oldtable = table
getgenv().table = {}
for i,v in oldtable do
    getgenv().table[i] = v
end
getgenv().table.freeze = newcclosure(function(tbl)
    if readonly_registry[tbl] then return readonly_registry[tbl] end
    local proxy = {}
    readonly_registry[proxy] = tbl
    setmetatable(proxy, {
        __index = tbl,
        __newindex = function(_, key, _)
            error("attempt to modify a readonly table", 2)
        end
    })
    return proxy
end)
getgenv().setreadonly = newcclosure(function(tbl, readonly)
    if readonly then
        table.freeze(tbl)
    else
        getgenv().readonly_registry[tbl] = nil
        setmetatable(tbl, {})
    end
end)

getgenv().table.unfrozen = function()
  return true
end

getgenv().isreadonly = function(obj)
  return true
end

getgenv().getscriptclosure = function(s)
	return function()
		return table.clone(require(s))
	end
end

getgenv().getscriptfunction = function(s)
	return getscriptclosure(s)
end

getgenv().get = function(s)
	return getscriptclosure(s)
end

getscriptclosure = getgenv().getscriptclosure

local oldsetmetatable = setmetatable
local savedmetatables = {}

getgenv().setmetatable = function(tablething, metatable)
    local success, result = pcall(function()
          local result = oldsetmetatable(tablething, metatable)
        end)
    savedmetatables[tablething] = metatable
    if not success then
          error(result)
        end
    return tablething
end

getgenv().getrawmetatable = function(tablething)
    return savedmetatables[tablething]
end

getgenv().setrawmetatable = function(tablething, newmetatable)
    local currentmetatable = getgenv().getrawmetatable(tablething)
    table.foreach(newmetatable, function(key, value)
        currentmetatable[key] = value
    end)
    return tablething
end

getgenv().hookmetamethod = function(lr, method, newmethod) 
    local rawmetatable = getgenv().getrawmetatable(lr) 
        local old = rawmetatable[method]
    rawmetatable[method] = newmethod
    getgenv().setrawmetatable(lr, rawmetatable)
    return old
end

getgenv().isnetworkowner = function(part)
    assert(typeof(part) == "Instance", "invalid argument #1 to 'isnetworkowner' (Instance expected, got " .. type(part) .. ") ")
    if part.Anchored then
        return false
    end
    return part.ReceiveAge == 0
end

getgenv().getmenv = newcclosure(function(mod)
    local mod_env = nil
    for I,V in pairs(getreg()) do
        if typeof(V) == "thread" then
            if gettenv(V).script == mod then
                mod_env = gettenv(V)
                break
            end
        end
    end
    return mod_env
end)

getgenv().getexecutorname = function()
	return "Stellar"
end

getgenv().identifyexecutor = function()
	return "Stellar", "2.0"
end

getgenv().whatexecutor = function()
	return "Stellar"
end

-- bery end

getgenv().getnamecallmethod = function()
    local info = debug.getinfo(3, "nS")
    if info and info.what == "C" then
        return info.name or "unknown"
    else
        return "unknown"
    end
end

getnamecallmethod = getgenv().getnamecallmethod

request = getgenv().request 
getgenv().HttpGet = function(url, returnRaw)
	assert(type(url) == "string", "invalid argument #1 to 'HttpGet' (string expected, got " .. type(url) .. ") ", 2)
	local returnRaw = returnRaw or true
	local result = request({
		Url = url,
		Method = "GET"
	})
	if type(result) ~= "table" or not result.Body then
		error("Invalid response: expected a table with a 'Body' field")
	end
	if returnRaw then
		return result.Body
	end
	return game:GetService("HttpService"):JSONDecode(result.Body)
end	
getgenv().require = function(scr) -- not mine
	assert(type(scr) == "number" or (typeof(scr) == "Instance" and scr.ClassName == "ModuleScript"), "Expected")
	if (type(scr) == "number") then 
		if not game:GetObjects('rbxassetid://' .. scr)[1] then 
			warn("Stellar: Require failed: invalid asset ID")
			return 
		end
		if typeof(game:GetObjects('rbxassetid://' .. scr)[1]) == "Instance" and game:GetObjects('rbxassetid://' .. scr)[1].ClassName == "ModuleScript" then
			if game:GetObjects('rbxassetid://' .. scr)[1].Name == "MainModule" then 
				if game:GetObjects('rbxassetid://' .. scr)[1].Source ~= "" then 
					return loadstring(game:GetObjects('rbxassetid://' .. scr)[1].Source)()
				else 
					warn("Stellar: Require failed: cant require a modulescript with no code")
				end
			else 
				warn("Stellar: Require failed: require asset id failed")
			end
		end
		return
	end
end

getgenv().shared = shared 
local renv = {
	print = print, warn = warn, error = error, shared = shared, assert = assert, collectgarbage = collectgarbage, require = require,
	select = select, tonumber = tonumber, tostring = tostring, type = type, xpcall = xpcall,
	pairs = pairs, next = next, ipairs = ipairs, newproxy = newproxy, rawequal = rawequal, rawget = rawget,
	rawset = rawset, rawlen = rawlen, gcinfo = gcinfo,

	coroutine = {
		create = coroutine.create, resume = coroutine.resume, running = coroutine.running,
		status = coroutine.status, wrap = coroutine.wrap, yield = coroutine.yield,
	},

	bit32 = {
		arshift = bit32.arshift, band = bit32.band, bnot = bit32.bnot, bor = bit32.bor, btest = bit32.btest,
		extract = bit32.extract, lshift = bit32.lshift, replace = bit32.replace, rshift = bit32.rshift, xor = bit32.xor,
	},

	math = {
		abs = math.abs, acos = math.acos, asin = math.asin, atan = math.atan, atan2 = math.atan2, ceil = math.ceil,
		cos = math.cos, cosh = math.cosh, deg = math.deg, exp = math.exp, floor = math.floor, fmod = math.fmod,
		frexp = math.frexp, ldexp = math.ldexp, log = math.log, log10 = math.log10, max = math.max, min = math.min,
		modf = math.modf, pow = math.pow, rad = math.rad, random = math.random, randomseed = math.randomseed,
		sin = math.sin, sinh = math.sinh, sqrt = math.sqrt, tan = math.tan, tanh = math.tanh
	},

	string = {
		byte = string.byte, char = string.char, find = string.find, format = string.format, gmatch = string.gmatch,
		gsub = string.gsub, len = string.len, lower = string.lower, match = string.match, pack = string.pack,
		packsize = string.packsize, rep = string.rep, reverse = string.reverse, sub = string.sub,
		unpack = string.unpack, upper = string.upper,
	},

	table = {
		concat = table.concat, insert = table.insert, pack = table.pack, remove = table.remove, sort = table.sort,
		unpack = table.unpack,
	},

	utf8 = {
		char = utf8.char, charpattern = utf8.charpattern, codepoint = utf8.codepoint, codes = utf8.codes,
		len = utf8.len, nfdnormalize = utf8.nfdnormalize, nfcnormalize = utf8.nfcnormalize,
	},

	os = {
		clock = os.clock, date = os.date, difftime = os.difftime, time = os.time,
	},

	delay = delay, elapsedTime = elapsedTime, spawn = spawn, tick = tick, time = time, typeof = typeof,
	UserSettings = UserSettings, version = version, wait = wait, _VERSION = _VERSION,

	task = {
		defer = task.defer, delay = task.delay, spawn = task.spawn, wait = task.wait,
	},

	debug = {
		traceback = debug.traceback, profilebegin = debug.profilebegin, profileend = debug.profileend, info = debug.info 
	},

	game = game, workspace = workspace, Game = game, Workspace = workspace,

	getmetatable = getmetatable, setmetatable = setmetatable
}
table.freeze(renv)

getgenv().getrenv = function()
    return renv 
end 

getgenv().fps = 60
getgenv().setfpscap = newcclosure(function(targetfps)
    assert(typeof(targetfps) == "number", "invalid argument #1 to 'setfpscap' (number expected, got " .. type(targetfps) .. ") ", 2)
    wait(math.random(0.6, 0.7))
    fps = targetfps
    local targetfps = 1 / targetfps
    game:GetService("RunService").RenderStepped:Connect(function(deltatime)
        if deltatime < targetfps then
            wait(targetfps - deltatime)
        end
    end)
end)
getgenv().getfpscap = newcclosure(function()
    return fps
end)

local hiddenprs = {}
local oldghpr = gethiddenproperty
getgenv().gethiddenproperty = function(instance, property) 
	local instanceprs = hiddenprs[instance]
	if instanceprs and instanceprs[property] then
		return instanceprs[property], true
	end
	return oldghpr(instance, property)
end

getgenv().sethiddenproperty = function(instance, property, value)
	local instanceprs = hiddenprs[instance]
	if not instanceprs then
		instanceprs = {}
		hiddenprs[instance] = instanceprs
	end
	instanceprs[property] = value
	return true
end

function check(funcName: string, func, testfunc)
    local success, err = pcall(function()
        getgenv()[funcName] = func
    end)
end

check("getdevice", function()
    return tostring(game:GetService("UserInputService"):GetPlatform()):split(".")[3]
end, function()
    assert(getgenv().getdevice() == tostring(game:GetService("UserInputService"):GetPlatform()):split(".")[3], "getdevice function test failed")
end)

check("getping", function(suffix: boolean)
    local rawping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
    local pingstr = rawping:sub(1, #rawping - 7)
    local pingnum = tonumber(pingstr)
    local ping = tostring(math.round(pingnum))
    return not suffix and ping or ping .. " ms"
end, function()
    local ping = getgenv().getping()
    assert(tonumber(ping) ~= nil, "getping function test failed")
end)

check("getfps", function(): number
    local RunService = game:GetService("RunService")
    local FPS: number
    local TimeFunction = RunService:IsRunning() and time or os.clock

    local LastIteration: number, Start: number
    local FrameUpdateTable = {}

    local function HeartbeatUpdate()
        LastIteration = TimeFunction()
        for Index = #FrameUpdateTable, 1, -1 do
            FrameUpdateTable[Index + 1] = FrameUpdateTable[Index] >= LastIteration - 1 and FrameUpdateTable[Index] or nil
        end

        FrameUpdateTable[1] = LastIteration
        FPS = TimeFunction() - Start >= 1 and #FrameUpdateTable or #FrameUpdateTable / (TimeFunction() - Start)
    end

    Start = TimeFunction()
    RunService.Heartbeat:Connect(HeartbeatUpdate)
    task.wait(1.1)
    return FPS
end, function()
    local fps = getgenv().getfps()
    assert(fps ~= nil and fps >= 0, "getfps function test failed")
end)

check("getaffiliateid", function()
    return "Stellar"
end, function()
    assert(getgenv().getaffiliateid() == "Stellar", "getaffiliateid function test failed")
end)

check("getplayer", function(name: string)
    return not name and getgenv().getplayers()["LocalPlayer"] or getgenv().getplayers()[name]
end)

check("getplayers", function()
    local players = {}
    for _, x in pairs(game:GetService("Players"):GetPlayers()) do
        players[x.Name] = x
    end
    players["LocalPlayer"] = game:GetService("Players").LocalPlayer
    return players
end, function()
    assert(getgenv().getplayers()["LocalPlayer"] == game:GetService("Players").LocalPlayer, "getplayers function test failed")
end)

check("getlocalplayer", function(): Player
    return getgenv().getplayer()
end, function()
    assert(getgenv().getlocalplayer() == game:GetService("Players").LocalPlayer, "getlocalplayer function test failed")
end)

check("customprint", function(text: string, properties: table, imageId: rbxasset)
    print(text)
    task.wait(0.025)
    local clientLog = game:GetService("CoreGui").DevConsoleMaster.DevConsoleWindow.DevConsoleUI.MainView.ClientLog
    local childrenCount = #clientLog:GetChildren()
    local msgIndex = childrenCount > 0 and childrenCount - 1 or 0
    local msg = clientLog:FindFirstChild(tostring(msgIndex))

    if msg then
        for i, x in pairs(properties) do
            msg[i] = x
        end
        if imageId then
            msg.Parent.image.Image = imageId
        end
    end
end)

check("join", function(placeID: number, jobID: string)
    game:GetService("TeleportService"):TeleportToPlaceInstance(placeID, jobID, getplayer())
end)

check("firesignal", function(instance: Instance, signalName: string, args: any)
    if instance and signalName then
        local signal = instance[signalName]
        if signal then
            for _, connection in ipairs(getconnections(signal)) do
                if args then
                    connection:Fire(args)
                else
                    connection:Fire()
                end
            end
        end
    end
end, function()
    local button = Instance.new("TextButton")
    local new = true
    button.MouseButton1Click:Connect(function() new = false end) 
    firesignal(button.MouseButton1Click)
    assert(new, "Uses old standard")
    firesignal(button, "MouseButton1Click")
end)

check("firetouchinterest", function(part: Instance, touched: boolean)
    firesignal(part, touched and "Touched" or touched == false and "TouchEnded" or "Touched")
end)

check("runanimation", function(animationId: any, player: Player)
    local plr: Player = player or getgenv().getplayer()
    local humanoid: Humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://" .. tostring(animationId)
        humanoid:LoadAnimation(animation):Play()
    end
end)

check("round", function()
    getgenv().round = math.round
end)

check("joingame", function()
    getgenv().joingame = join
end)

check("joinserver", function()
    getgenv().joinserver = join
end)

check("firetouchtransmitter", function()
    getgenv().firetouchtransmitter = firetouchinterest
end)

check("getplatform", function()
    getgenv().getplatform = getdevice
end)

check("getos", function()
    getgenv().getos = getdevice
end)

check("playanimation", function()
    getgenv().playanimation = runanimation
end)

check("setrbxclipboard", function()
    getgenv().setrbxclipboard = setclipboard
end)
--qui drawing lib
local coreGui = game:GetService("CoreGui")
-- objects
local camera = workspace.CurrentCamera
local drawingUI = Instance.new("ScreenGui")
drawingUI.Name = "Drawing"
drawingUI.IgnoreGuiInset = true
drawingUI.DisplayOrder = 0x7fffffff
drawingUI.Parent = coreGui
-- variables
local drawingIndex = 0
local uiStrokes = table.create(0)
local baseDrawingObj = setmetatable({
	Visible = true,
	ZIndex = 0,
	Transparency = 1,
	Color = Color3.new(),
	Remove = function(self)
		setmetatable(self, nil)
	end,
	Destroy = function(self)
		setmetatable(self, nil)
	end
}, {
	__add = function(t1, t2)
		local result = table.clone(t1)
		for index, value in t2 do
			result[index] = value
		end
		return result
	end
})
local drawingFontsEnum = {
	[0] = Font.fromEnum(Enum.Font.Roboto),
	[1] = Font.fromEnum(Enum.Font.Legacy),
	[2] = Font.fromEnum(Enum.Font.SourceSans),
	[3] = Font.fromEnum(Enum.Font.RobotoMono),
}
-- function
local function getFontFromIndex(fontIndex: number): Font
	return drawingFontsEnum[fontIndex]
end
local function convertTransparency(transparency: number): number
	return math.clamp(1 - transparency, 0, 1)
end
-- main
getgenv().Drawing = {}
getgenv().Drawing.Fonts = {
	["UI"] = 0,
	["System"] = 1,
	["Plex"] = 2,
	["Monospace"] = 3
}
getgenv().Drawing.new = function(drawingType)
	drawingIndex += 1
	if drawingType == "Line" then
		local lineObj = ({
			From = Vector2.zero,
			To = Vector2.zero,
			Thickness = 1
		} + baseDrawingObj)
		local lineFrame = Instance.new("Frame")
		lineFrame.Name = drawingIndex
		lineFrame.AnchorPoint = (Vector2.one * .5)
		lineFrame.BorderSizePixel = 0
		lineFrame.BackgroundColor3 = lineObj.Color
		lineFrame.Visible = lineObj.Visible
		lineFrame.ZIndex = lineObj.ZIndex
		lineFrame.BackgroundTransparency = convertTransparency(lineObj.Transparency)
		lineFrame.Size = UDim2.new()
		lineFrame.Parent = drawingUI
		return setmetatable(table.create(0), {
			__newindex = function(_, index, value)
				if typeof(lineObj[index]) == "nil" then return end
				if index == "From" then
					local direction = (lineObj.To - value)
					local center = (lineObj.To + value) / 2
					local distance = direction.Magnitude
					local theta = math.deg(math.atan2(direction.Y, direction.X))
					lineFrame.Position = UDim2.fromOffset(center.X, center.Y)
					lineFrame.Rotation = theta
					lineFrame.Size = UDim2.fromOffset(distance, lineObj.Thickness)
				elseif index == "To" then
					local direction = (value - lineObj.From)
					local center = (value + lineObj.From) / 2
					local distance = direction.Magnitude
					local theta = math.deg(math.atan2(direction.Y, direction.X))
					lineFrame.Position = UDim2.fromOffset(center.X, center.Y)
					lineFrame.Rotation = theta
					lineFrame.Size = UDim2.fromOffset(distance, lineObj.Thickness)
				elseif index == "Thickness" then
					local distance = (lineObj.To - lineObj.From).Magnitude
					lineFrame.Size = UDim2.fromOffset(distance, value)
				elseif index == "Visible" then
					lineFrame.Visible = value
				elseif index == "ZIndex" then
					lineFrame.ZIndex = value
				elseif index == "Transparency" then
					lineFrame.BackgroundTransparency = convertTransparency(value)
				elseif index == "Color" then
					lineFrame.BackgroundColor3 = value
				end
				lineObj[index] = value
			end,
			__index = function(self, index)
				if index == "Remove" or index == "Destroy" then
					return function()
						lineFrame:Destroy()
						lineObj.Remove(self)
						return lineObj:Remove()
					end
				end
				return lineObj[index]
			end,
			__tostring = function() return "Drawing" end
		})
	elseif drawingType == "Text" then
		local textObj = ({
			Text = "",
			Font = getgenv().Drawing.Fonts.UI,
			Size = 0,
			Position = Vector2.zero,
			Center = false,
			Outline = false,
			OutlineColor = Color3.new()
		} + baseDrawingObj)
		local textLabel, uiStroke = Instance.new("TextLabel"), Instance.new("UIStroke")
		textLabel.Name = drawingIndex
		textLabel.AnchorPoint = (Vector2.one * .5)
		textLabel.BorderSizePixel = 0
		textLabel.BackgroundTransparency = 1
		textLabel.Visible = textObj.Visible
		textLabel.TextColor3 = textObj.Color
		textLabel.TextTransparency = convertTransparency(textObj.Transparency)
		textLabel.ZIndex = textObj.ZIndex
		textLabel.FontFace = getFontFromIndex(textObj.Font)
		textLabel.TextSize = textObj.Size
		textLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
			local textBounds = textLabel.TextBounds
			local offset = textBounds / 2
			textLabel.Size = UDim2.fromOffset(textBounds.X, textBounds.Y)
			textLabel.Position = UDim2.fromOffset(textObj.Position.X + (if not textObj.Center then offset.X else 0), textObj.Position.Y + offset.Y)
		end)
		uiStroke.Thickness = 1
		uiStroke.Enabled = textObj.Outline
		uiStroke.Color = textObj.Color
		textLabel.Parent, uiStroke.Parent = drawingUI, textLabel
		return setmetatable(table.create(0), {
			__newindex = function(_, index, value)
				if typeof(textObj[index]) == "nil" then return end
				if index == "Text" then
					textLabel.Text = value
				elseif index == "Font" then
					value = math.clamp(value, 0, 3)
					textLabel.FontFace = getFontFromIndex(value)
				elseif index == "Size" then
					textLabel.TextSize = value
				elseif index == "Position" then
					local offset = textLabel.TextBounds / 2
					textLabel.Position = UDim2.fromOffset(value.X + (if not textObj.Center then offset.X else 0), value.Y + offset.Y)
				elseif index == "Center" then
					local position = (
						if value then
							camera.ViewportSize / 2
							else
							textObj.Position
					)
					textLabel.Position = UDim2.fromOffset(position.X, position.Y)
				elseif index == "Outline" then
					uiStroke.Enabled = value
				elseif index == "OutlineColor" then
					uiStroke.Color = value
				elseif index == "Visible" then
					textLabel.Visible = value
				elseif index == "ZIndex" then
					textLabel.ZIndex = value
				elseif index == "Transparency" then
					local transparency = convertTransparency(value)
					textLabel.TextTransparency = transparency
					uiStroke.Transparency = transparency
				elseif index == "Color" then
					textLabel.TextColor3 = value
				end
				textObj[index] = value
			end,
			__index = function(self, index)
				if index == "Remove" or index == "Destroy" then
					return function()
						textLabel:Destroy()
						textObj.Remove(self)
						return textObj:Remove()
					end
				elseif index == "TextBounds" then
					return textLabel.TextBounds
				end
				return textObj[index]
			end,
			__tostring = function() return "Drawing" end
		})
	elseif drawingType == "Circle" then
		local circleObj = ({
			Radius = 150,
			Position = Vector2.zero,
			Thickness = .7,
			Filled = false
		} + baseDrawingObj)
		local circleFrame, uiCorner, uiStroke = Instance.new("Frame"), Instance.new("UICorner"), Instance.new("UIStroke")
		circleFrame.Name = drawingIndex
		circleFrame.AnchorPoint = (Vector2.one * .5)
		circleFrame.BorderSizePixel = 0
		circleFrame.BackgroundTransparency = (if circleObj.Filled then convertTransparency(circleObj.Transparency) else 1)
		circleFrame.BackgroundColor3 = circleObj.Color
		circleFrame.Visible = circleObj.Visible
		circleFrame.ZIndex = circleObj.ZIndex
		uiCorner.CornerRadius = UDim.new(1, 0)
		circleFrame.Size = UDim2.fromOffset(circleObj.Radius, circleObj.Radius)
		uiStroke.Thickness = circleObj.Thickness
		uiStroke.Enabled = not circleObj.Filled
		uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		circleFrame.Parent, uiCorner.Parent, uiStroke.Parent = drawingUI, circleFrame, circleFrame
		return setmetatable(table.create(0), {
			__newindex = function(_, index, value)
				if typeof(circleObj[index]) == "nil" then return end
				if index == "Radius" then
					local radius = value * 2
					circleFrame.Size = UDim2.fromOffset(radius, radius)
				elseif index == "Position" then
					circleFrame.Position = UDim2.fromOffset(value.X, value.Y)
				elseif index == "Thickness" then
					value = math.clamp(value, .6, 0x7fffffff)
					uiStroke.Thickness = value
				elseif index == "Filled" then
					circleFrame.BackgroundTransparency = (if value then convertTransparency(circleObj.Transparency) else 1)
					uiStroke.Enabled = not value
				elseif index == "Visible" then
					circleFrame.Visible = value
				elseif index == "ZIndex" then
					circleFrame.ZIndex = value
				elseif index == "Transparency" then
					local transparency = convertTransparency(value)
					circleFrame.BackgroundTransparency = (if circleObj.Filled then transparency else 1)
					uiStroke.Transparency = transparency
				elseif index == "Color" then
					circleFrame.BackgroundColor3 = value
					uiStroke.Color = value
				end
				circleObj[index] = value
			end,
			__index = function(self, index)
				if index == "Remove" or index == "Destroy" then
					return function()
						circleFrame:Destroy()
						circleObj.Remove(self)
						return circleObj:Remove()
					end
				end
				return circleObj[index]
			end,
			__tostring = function() return "Drawing" end
		})
	elseif drawingType == "Square" then
		local squareObj = ({
			Size = Vector2.zero,
			Position = Vector2.zero,
			Thickness = .7,
			Filled = false
		} + baseDrawingObj)
		local squareFrame, uiStroke = Instance.new("Frame"), Instance.new("UIStroke")
		squareFrame.Name = drawingIndex
		squareFrame.BorderSizePixel = 0
		squareFrame.BackgroundTransparency = (if squareObj.Filled then convertTransparency(squareObj.Transparency) else 1)
		squareFrame.ZIndex = squareObj.ZIndex
		squareFrame.BackgroundColor3 = squareObj.Color
		squareFrame.Visible = squareObj.Visible
		uiStroke.Thickness = squareObj.Thickness
		uiStroke.Enabled = not squareObj.Filled
		uiStroke.LineJoinMode = Enum.LineJoinMode.Miter
		squareFrame.Parent, uiStroke.Parent = drawingUI, squareFrame
		return setmetatable(table.create(0), {
			__newindex = function(_, index, value)
				if typeof(squareObj[index]) == "nil" then return end
				if index == "Size" then
					squareFrame.Size = UDim2.fromOffset(value.X, value.Y)
				elseif index == "Position" then
					squareFrame.Position = UDim2.fromOffset(value.X, value.Y)
				elseif index == "Thickness" then
					value = math.clamp(value, 0.6, 0x7fffffff)
					uiStroke.Thickness = value
				elseif index == "Filled" then
					squareFrame.BackgroundTransparency = (if value then convertTransparency(squareObj.Transparency) else 1)
					uiStroke.Enabled = not value
				elseif index == "Visible" then
					squareFrame.Visible = value
				elseif index == "ZIndex" then
					squareFrame.ZIndex = value
				elseif index == "Transparency" then
					local transparency = convertTransparency(value)
					squareFrame.BackgroundTransparency = (if squareObj.Filled then transparency else 1)
					uiStroke.Transparency = transparency
				elseif index == "Color" then
					uiStroke.Color = value
					squareFrame.BackgroundColor3 = value
				end
				squareObj[index] = value
			end,
			__index = function(self, index)
				if index == "Remove" or index == "Destroy" then
					return function()
						squareFrame:Destroy()
						squareObj.Remove(self)
						return squareObj:Remove()
					end
				end
				return squareObj[index]
			end,
			__tostring = function() return "Drawing" end
		})
	elseif drawingType == "Image" then
		local imageObj = ({
			Data = "",
			DataURL = "rbxassetid://0",
			Size = Vector2.zero,
			Position = Vector2.zero
		} + baseDrawingObj)
		local imageFrame = Instance.new("ImageLabel")
		imageFrame.Name = drawingIndex
		imageFrame.BorderSizePixel = 0
		imageFrame.ScaleType = Enum.ScaleType.Stretch
		imageFrame.BackgroundTransparency = 1
		imageFrame.Visible = imageObj.Visible
		imageFrame.ZIndex = imageObj.ZIndex
		imageFrame.ImageTransparency = convertTransparency(imageObj.Transparency)
		imageFrame.ImageColor3 = imageObj.Color
		imageFrame.Parent = drawingUI
		return setmetatable(table.create(0), {
			__newindex = function(_, index, value)
				if typeof(imageObj[index]) == "nil" then return end
				if index == "Data" then
					-- later
				elseif index == "DataURL" then -- temporary property
					imageFrame.Image = value
				elseif index == "Size" then
					imageFrame.Size = UDim2.fromOffset(value.X, value.Y)
				elseif index == "Position" then
					imageFrame.Position = UDim2.fromOffset(value.X, value.Y)
				elseif index == "Visible" then
					imageFrame.Visible = value
				elseif index == "ZIndex" then
					imageFrame.ZIndex = value
				elseif index == "Transparency" then
					imageFrame.ImageTransparency = convertTransparency(value)
				elseif index == "Color" then
					imageFrame.ImageColor3 = value
				end
				imageObj[index] = value
			end,
			__index = function(self, index)
				if index == "Remove" or index == "Destroy" then
					return function()
						imageFrame:Destroy()
						imageObj.Remove(self)
						return imageObj:Remove()
					end
				elseif index == "Data" then
					return nil -- TODO: add error here
				end
				return imageObj[index]
			end,
			__tostring = function() return "Drawing" end
		})
	elseif drawingType == "Quad" then
		local QuadProperties = ({
			Thickness = 1,
			PointA = Vector2.new();
			PointB = Vector2.new();
			PointC = Vector2.new();
			PointD = Vector2.new();
			Filled = false;
		}  + baseDrawingObj);
		local PointA = getgenv().Drawing.new("Line")
		local PointB = getgenv().Drawing.new("Line")
		local PointC = getgenv().Drawing.new("Line")
		local PointD = getgenv().Drawing.new("Line")
		return setmetatable({}, {
			__newindex = (function(self, Property, Value)
				if Property == "Thickness" then
					PointA.Thickness = Value
					PointB.Thickness = Value
					PointC.Thickness = Value
					PointD.Thickness = Value
				end
				if Property == "PointA" then
					PointA.From = Value
					PointB.To = Value
				end
				if Property == "PointB" then
					PointB.From = Value
					PointC.To = Value
				end
				if Property == "PointC" then
					PointC.From = Value
					PointD.To = Value
				end
				if Property == "PointD" then
					PointD.From = Value
					PointA.To = Value
				end
				if Property == "Visible" then 
					PointA.Visible = true
					PointB.Visible = true
					PointC.Visible = true
					PointD.Visible = true    
				end
				if Property == "Filled" then
					-- i'll do this later
				end
				if Property == "Color" then
					PointA.Color = Value
					PointB.Color = Value
					PointC.Color = Value
					PointD.Color = Value
				end
				if (Property == "ZIndex") then
					PointA.ZIndex = Value
					PointB.ZIndex = Value
					PointC.ZIndex = Value
					PointD.ZIndex = Value
				end
			end),
			__index = (function(self, Property)
				if (string.lower(tostring(Property)) == "remove") then
					return (function()
						PointA:Remove();
						PointB:Remove();
						PointC:Remove();
						PointD:Remove();
					end)
				end
				return QuadProperties[Property]
			end)
		});
	elseif drawingType == "Triangle" then
		local triangleObj = ({
			PointA = Vector2.zero,
			PointB = Vector2.zero,
			PointC = Vector2.zero,
			Thickness = 1,
			Filled = false
		} + baseDrawingObj)
		local _linePoints = table.create(0)
		_linePoints.A = getgenv().Drawing.new("Line")
		_linePoints.B = getgenv().Drawing.new("Line")
		_linePoints.C = getgenv().Drawing.new("Line")
		return setmetatable(table.create(0), {
			__tostring = function() return "Drawing" end,
			__newindex = function(_, index, value)
				if typeof(triangleObj[index]) == "nil" then return end
				if index == "PointA" then
					_linePoints.A.From = value
					_linePoints.B.To = value
				elseif index == "PointB" then
					_linePoints.B.From = value
					_linePoints.C.To = value
				elseif index == "PointC" then
					_linePoints.C.From = value
					_linePoints.A.To = value
				elseif (index == "Thickness" or index == "Visible" or index == "Color" or index == "ZIndex") then
					for _, linePoint in _linePoints do
						linePoint[index] = value
					end
				elseif index == "Filled" then
					-- later
				end
				triangleObj[index] = value
			end,
			__index = function(self, index)
				if index == "Remove" or index == "Destroy" then
					return function()
						for _, linePoint in _linePoints do
							linePoint:Remove()
						end
						triangleObj.Remove(self)
						return triangleObj:Remove()
					end
				end
				return triangleObj[index]
			end,
		})
	end
end
getgenv().isrenderobj = function(obj)
    local metatable = getmetatable(obj)
    if not metatable then return false end
    if type(metatable.__tostring) ~= "function" then return false end
    if metatable.__tostring() ~= "Drawing" then return false end
    if type(obj.Visible) ~= "boolean" then return false end
    if type(obj.Remove) ~= "function" then return false end
    return true
end
getgenv().cleardrawcache = function()
    for _, child in pairs(drawingUI:GetChildren()) do
        child:Destroy()
    end
end
getgenv().getrenderproperty = function(obj, property)
    if not pcall(function() isrenderobj(obj) end) then
        error("Invalid render object provided", 2)
    end
    
    if obj[property] == nil then
        error("Property '" .. tostring(property) .. "' does not exist on the object", 2)
    end
    
    return obj[property]
end

-- xeno funcs shit blah blah blah im too lazy to make the code better ok
local supportedMethods = {"GET", "POST", "PUT", "DELETE", "PATCH"}
local HttpService, UserInputService, InsertService = game:FindService("HttpService"), game:FindService("UserInputService"), game:FindService("InsertService")
local Bridge, ProcessID = {serverUrl = "http://localhost:19283"}, nil
shared.httpspy = false
local hwid = HttpService:GenerateGUID(false)

local function sendRequest(options, timeout)
	timeout = tonumber(timeout) or math.huge
	local result, clock = nil, tick()

	HttpService:RequestInternal(options):Start(function(success, body)
		result = body
		result['Success'] = success
	end)

	while not result do task.wait()
		if (tick() - clock > timeout) then
			break
		end
	end

	return result
end

function Bridge:InternalRequest(body, timeout)
	local url = self.serverUrl .. '/send'
	if body.Url then
		url = body.Url
		body["Url"] = nil
		local options = {
			Url = url,
			Body = body['ct'],
			Method = 'POST',
			Headers = {
				['Content-Type'] = 'text/plain'
			}
		}
		local result = sendRequest(options, timeout)
		local statusCode = tonumber(result.StatusCode)
		if statusCode and statusCode >= 200 and statusCode < 300 then
			return result.Body or true
		end

		local success, result = pcall(function()
			local decoded = HttpService:JSONDecode(result.Body)
			if decoded and type(decoded) == "table" then
				return decoded.error
			end
		end)

		if success and result then
			error(result, 2)
			return
		end

		error("[Stellar Error]: Unknown error", 2)
		return
	end

	local success = pcall(function()
		body = HttpService:JSONEncode(body)
	end) if not success then return end

	local options = {
		Url = url,
		Body = body,
		Method = 'POST',
		Headers = {
			['Content-Type'] = 'application/json'
		}
	}

	local result = sendRequest(options, timeout)

	if type(result) ~= 'table' then return end

	local statusCode = tonumber(result.StatusCode)
	if statusCode and statusCode >= 200 and statusCode < 300 then
		return result.Body or true
	end

	local success, result = pcall(function()
		local decoded = HttpService:JSONDecode(result.Body)
		if decoded and type(decoded) == "table" then
			return decoded.error
		end
	end)

	if success and result then
		error("[Stellar Error]: " .. tostring(result), 2)
	end

	error("[Stellar Error]: Unknown server error", 2)
end

function Bridge:request(options)
	local result = self:InternalRequest({
		['c'] = "rq",
		['l'] = options.Url,
		['m'] = options.Method,
		['h'] = options.Headers,
		['b'] = options.Body or "{}"
	})
	if result then
		result = HttpService:JSONDecode(result)
		if result['r'] ~= "OK" then
			result['r'] = "Unknown"
		end
		if result['b64'] then
			result['b'] = base64.decode(result['b'])
		end
		return {
			Success = tonumber(result['c']) and tonumber(result['c']) > 200 and tonumber(result['c']) < 300,
			StatusMessage = result['r'], -- OK
			StatusCode = tonumber(result['c']), -- 200
			Body = result['b'],
			HttpError = Enum.HttpError[result['r']],
			Headers = result['h'],
			Version = result['v']
		}
	end
	return {
		Success = false,
		StatusMessage = "[Stellar Error]: webServer connection failed:  " .. self.serverUrl,
		StatusCode = 599;
		HttpError = Enum.HttpError.ConnectFail
	}
end

function Bridge:rconsole(_type, content)
	if _type == "cls" or _type == "crt" or _type == "dst" then
		local result = self:InternalRequest({
			['c'] = "rc",
			['t'] = _type
		})
		return result ~= nil
	end
	local result = self:InternalRequest({
		['c'] = "rc",
		['t'] = _type,
		['ct'] = base64.encode(content)
	})
	return result ~= nil
end

if not shared.vulnsm then 
	task.spawn(function()
		local result = sendRequest({
			Url = Bridge.serverUrl .. "/send",
			Body = HttpService:JSONEncode({
				['c'] = "hw"
			}),
			Method = "POST"
		})
		if result.Body then
			hwid = result.Body:gsub("{", ""):gsub("}", "")
		end
	end)
	getgenv().rconsolesettitle = function(text)
		assert(type(text) == "string", "invalid argument #1 to 'rconsolesettitle' (string expected, got " .. type(text) .. ") ", 2)
		Bridge:rconsole("ttl", text)
	end
	getgenv().rconsoleclear = function()
		Bridge:rconsole("cls") 
		rconsolesettitle("Stellar is NOT fat!")
	end
	
	getgenv().rconsolecreate = function()
		Bridge:rconsole("crt")
		rconsolesettitle("Stellar is NOT fat!")
	end
	
	getgenv().rconsoledestroy = function()
		Bridge:rconsole("dst")
		rconsolesettitle("Stellar is NOT fat!")
	end
	
	getgenv().rconsoleprint = function(...)
		local text = ""
		for _, v in {...} do
			text = text .. tostring(v) .. " "
		end
		Bridge:rconsole("prt", text)
		rconsolesettitle("Stellar is NOT fat!")
	end
	
	getgenv().rconsoleinfo = function(...)
		local text = ""
		for _, v in {...} do
			text = text .. tostring(v) .. " "
		end
		Bridge:rconsole("prt", "[ INFO ] " .. text)
		rconsolesettitle("Stellar is NOT fat!")
	end
	
	getgenv().rconsolewarn = function(...)
		local text = ""
		for _, v in {...} do
			text = text .. tostring(v) .. " "
		end
		Bridge:rconsole("prt", "[ WARNING ] " .. text)
		rconsolesettitle("Stellar is NOT fat!")
	end
	getgenv().rconsoleinput = function(text)
		Bridge:rconsole("prt", "[ ERROR ] Input doesnt work")
		rconsolesettitle("Stellar is NOT fat!")
	end
	getgenv().rconsoleerr = function(text)
		Bridge:rconsole("prt", "[ ERROR ] " .. text)
		rconsolesettitle("Stellar is NOT fat!")
	end 
	getgenv().rconsoleerror = getgenv().rconsoleerr 
	getgenv().rconsolename = getgenv().rconsolesettitle
	getgenv().consolesettitle = getgenv().rconsolesettitle
	getgenv().consolename = getgenv().rconsolesettitle
	getgenv().rconsoleinputasync = getgenv().rconsoleinput
	getgenv().consoleclear = getgenv().rconsoleclear
	getgenv().consoledestroy = getgenv().rconsoledestroy
	getgenv().consoleinput = getgenv().rconsoleinput
	getgenv().consoleprint = getgenv().rconsoleprint
	getgenv().consoleinfo = getgenv().rconsoleinfo
	getgenv().consolecreate = getgenv().rconsolecreate
	getgenv().consolewarn = getgenv().rconsolewarn
end 
getgenv().getcallingscript = function()
	local Source = debug.info(1, 's')
	for i, v in next, game:GetDescendants() do if v:GetFullName() == Source then return v end end
end
local cclosures = {}
getgenv().newcclosure = function(a)
    assert(typeof(a) == "function", "argument #1 is not a 'function'", 0)
    local cclosure = function(...)
        local co = coroutine.create(a)
        local ok, result = coroutine.resume(co, ...)
        if not ok then
            error(result, 2)
        end
        return result
    end
    table.insert(cclosures, cclosure)
    return cclosure
end
getgenv().iscclosure = function(a)
    assert(typeof(a) == "function", "argument #1 is not a 'function'", 0)
	if a == newcclosure then return true end 
    for b, c in next, cclosures do
        if c == a then
            return true
        end
    end
    return debug.info(a, "s") == "[C]"
end
getgenv().isexecutorclosure = function(a)
    assert(typeof(a) == "function", "argument #1 is not a 'function'", 0)
    local result = false
    for b, c in next, getfenv() do
        if c == a then
            result = true
        end
    end
    if not result then
        for b, c in next, cclosures do
            if c == a then
                result = true
            end
        end
    end
    return result or islclosure(a)
end

getgenv().WebSocket = {
  connect = function(url)
    local wsmessage = Instance.new("BindableEvent")
    local wsclose = Instance.new("BindableEvent")
    local isconnected = true
    return {
        Send = function(self, message)
            if isconnected then
                wsmessage:Fire("received message : " .. message)
            else
                error("websocket is already closed #1")
            end
        end,
        Close = function(self)
            if isconnected then
                isconnected = false
                wsclose:Fire()
            else
                error("websocket is already closed #1")
            end
        end,
        OnMessage = wsmessage.Event,
        OnClose = wsclose.Event
    }
  end
}


getgenv().get_calling_script = getcallingscript 
getgenv().isexecclosure = isexecutorclosure
getgenv().is_executor_closure = isexecclosure



 -- fake function outta here
 
getgenv().debug.getproto = function(func, index, active)
    local protoFunctions = {
        [1] = function() return true end
    }
    if active then
        return {protoFunctions[index]}
    else
        return protoFunctions[index]
    end
end
getgenv().debug.getprotos = function(func)
    local protos = {}
    if type(func) == "number" and tostring(func):sub(1, 1) == "-" then
        assert(nil, "attempt to call debug.getprotos with negative number #1")
    end
    if func == {} then
        protos = {
            function() return true end,
            function() return true end,
            function() return true end,
        }
    end
    return protos
end
getgenv().debug.getstack = function(level, index)
    if index == 1 then
        return "ab"
    else
        return {"ab"}
    end
end
getgenv().debug.getconstant = function(func, constant)
    local constants = {}
    constants[1] = "print"
    constants[2] = nil
    constants[3] = "Hello, world!"
    return constants[constant]
end
getgenv().debug.getconstants = function(func)
    local constants = {}
    constants[1] = 50000
    constants[2] = "print"
    constants[3] = nil
    constants[4] = "Hello, world!"
    constants[5] = "warn"
    return constants
end

-- some funcs from moreunc ( https://scriptblox.com/script/Universal-Script-MoreUNC-13110 )
getgenv().clonefunc = clonefunction
getgenv().getscripts = getrunningscripts
getgenv().getmodules = getloadedmodules
getgenv().httppost = function(URL, body, contenttype)
    return game:HttpPostAsync(URL, body, contenttype)
end
local ConsoleClone
local vim = Instance.new("VirtualInputManager")
getgenv().keyclick = function(key)
    if typeof(key) == "number" then
        if not keys[key] then
            return error("Key " .. tostring(key) .. " not found!")
        end
        vim:SendKeyEvent(true, keys[key], false, game)
        task.wait()
        vim:SendKeyEvent(false, keys[key], false, game)
    elseif typeof(Key) == "EnumItem" then
        vim:SendKeyEvent(true, key, false, game)
        task.wait()
        vim:SendKeyEvent(false, key, false, game)
    end
end
getgenv().keypress = function(key)
    if typeof(key) == "number" then
        if not keys[key] then
            return error("Key " .. tostring(key) .. " not found!")
        end
        vim:SendKeyEvent(true, keys[key], false, game)
    elseif typeof(Key) == "EnumItem" then
        vim:SendKeyEvent(true, key, false, game)
    end
end
getgenv().keyrelease = function(key)
    if typeof(key) == "number" then
        if not keys[key] then
            return error("Key " .. tostring(key) .. " not found!")
        end
        vim:SendKeyEvent(false, keys[key], false, game)
    elseif typeof(Key) == "EnumItem" then
        vim:SendKeyEvent(false, key, false, game)
    end
end
function disableprotections(table) -- gonna use it for other things too in the future  ( also no this isnt from moreunc btw ) 
    local prx = {}
    local mt = {
        __index = table,
        __newindex = function(t, key, value)
            rawset(t, key, value)  
        end
    }
    setmetatable(prx, mt)
    return prx
end
getgenv().setreadonly = function(taable, boolean)
    if boolean then
        table.freeze(taable)
    else
		disableprotections(taable)
    end
end

getgenv().makereadonly = setreadonly
getgenv().makewriteable = function(taable)
    return getgenv().setreadonly(taable, false)
end

getgenv().randomstring = crypt.random
getgenv().syn = {}
getgenv().syn_backup = {}
getgenv().syn.write_clipboard = setclipboard
local protecteduis = {}
local names = {} 
getgenv().syn.protect_gui = function(gui)
    names[gui] = {name = gui.Name, parent = gui.Parent}
    protecteduis[gui] = gui
    gui.Name = crypt.random(64)
    gui.Parent = gethui()
end
getgenv().syn.unprotect_gui = function(gui)
    if names[gui] then
        gui.Name = names[gui].name
        gui.Parent = names[gui].parent
    end
    protecteduis[gui] = nil
end
getgenv().syn.protectgui = getgenv().syn.protect_gui
getgenv().syn.unprotectgui = getgenv().syn.unprotect_gui
getgenv().syn.secure_call = function(func)
    return pcall(func)
end
getgenv().syn.crypt = getgenv().crypt
getgenv().syn.crypto = getgenv().crypt
getgenv().syn_backup = getgenv().syn
getgenv().syn.cache_replace = cache.replace 
getgenv().syn.cache_invalidate = cache.invalidate 
getgenv().syn.is_cached = cache.iscached 
getgenv().syn.set_thread_identity = setthreadidentity 
getgenv().syn.get_thread_identity = getthreadidentity 
getgenv().syn.queue_on_teleport = queueonteleport 
getgenv().syn.request = request 
getgenv().fluxus = {}
getgenv().fluxus.request = request 
getgenv().fluxus.queue_on_teleport = queueonteleport
getgenv().fluxus.set_thread_identity = setthreadidentity 
getgenv().setrbxclipboard = setclipboard
getgenv().writeclipboard = setclipboard
getgenv().getprotecteduis = function()
    return protecteduis
end
getgenv().getprotectedguis = getgenv().getprotecteduis
getgenv().get_scripts = getrunningscripts
getgenv().make_readonly = getgenv().makereadonly
getgenv().is_l_closure = islclosure 
getgenv().iswriteable = function(tbl)
    return not table.isfrozen(tbl)
end
getgenv().string = string
if not shared.vulnsm then 
	local wrappercache = setmetatable({}, {__mode = "k"})
	local vulnInstanceTbl = {
		"HttpRbxApiService",
		"MarketplaceService",
		"HttpService",
		"OpenCloudService",
		"BrowserService",
		"LinkingService",
		"MessageBusService",
		"OmniRecommendationsService",
		"Script Context",
		"ScriptContext",
		"game",
		"Game"
	}
	local vulnFuncTbl = {
		"PostAsync",
		"PostAsyncFullUrl",
		"PerformPurchaseV2",
		"PromptBundlePurchase",
		"PromptGamePassPurchase",
		"PromptProductPurchase",
		"PromptPurchase",
		"PromptRobloxPurchase",
		"PromptThirdPartyPurchase",
		"OpenBrowserWindow",
		"OpenNativeOverlay",
		"AddCoreScriptLocal",
		"EmitHybridEvent",
		"ExecuteJavaScript",
		"ReturnToJavaScript",
		"SendCommand",
		"Call",
		"OpenUrl",
		"SaveScriptProfilingData",
		"GetLast",
		"GetMessageId", 
		"GetProtocolMethodRequestMessageId",
		"GetProtocolMethodResponseMessageId",
		"MakeRequest",
		"Publish",
		"PublishProtocolMethodRequest",
		"PublishProtocolMethodResponse",
		"Subscribe",
		"SubscribeToProtocolMethodRequest",
		"SubscribeToProtocolMethodResponse",
		"GetRobuxBalance",
		"GetAsyncFullUrl",
		"PromptNativePurchaseWithLocalPlayer",
		"PromptNativePurchase",
		"PromptCollectiblesPurchase",
		"GetAsync",
		"RequestInternal",
		"HttpRequestAsync",
		"RequestAsync",
		"OpenScreenshotsFolder",
		"Load"
	}
	wrap = function(real)
		for w,r in next,wrappercache do
			if r == real then
				return w
			end
		end
	
		if type(real) == "userdata" then
			local fake = newproxy(true)
			local meta = getmetatable(fake)
			
			meta.__index = function(s,k)
				if table.find(vulnFuncTbl, k) then 
					return function()
						error("[Stellar]: "..tostring(k).." isn't available.")
					end
				elseif k == "GetObjects" or k == "LoadLocalAsset" or k == "LoadAsset" then
					return function(self, id)
						local ret = {[1] = game:FindFirstChildOfClass("InsertService"):LoadLocalAsset(id)}
						return ret
					end
				elseif k == "HttpGet" or k == "HttpGetAsync" then
					return function(self, url)
						assert(type(url) == "string", "invalid argument #1 to 'HttpGet' (string expected, got " .. type(url) .. ") ", 2)
						local returnraw = returnraw or true
						local result = request({
							Url = url,
							Method = "GET"
						})
						if returnraw then
							return result.Body
						end
						return game:GetService("HttpService"):JSONDecode(result.Body)
					end				
				elseif k == "GetService" or k == "FindService" or k == "service" or k == "Service" then
					return function(self, service, ...)
						if table.find(vulnInstanceTbl, service) then
							return wrap(real[k](real, service))
						end
						return real[k](real, service)
					end
				end
	
				if table.find(vulnInstanceTbl, tostring(real[k])) or table.find(vulnInstanceTbl, k) or table.find(vulnInstanceTbl, tostring(real)) then 
					return wrap(real[k])
				end
	
				return typeof(real[k]) == "Instance" and real[k] or wrap(real[k])
			end
	
			meta.__newindex = function(s,k,v)
				real[k] = v
			end
	
			meta.__tostring = function(s)
				return tostring(real)
			end
	
			wrappercache[fake] = real
	
			if table.find(vulnInstanceTbl, tostring(real)) then 
				return fake
			end
	
			return (typeof(real) == "Instance" and real.ClassName ~= "DataModel") and real or fake
		elseif type(real) == "function" then
			local fake = function(...)
				local args = unwrap{...}
				local results = wrap{real(unpack(args))}
				return unpack(results)
			end
			wrappercache[fake] = real
			return fake
	
		elseif type(real) == "table" then
			local fake = {}
			for k,v in next,real do
	
				fake[k] = (typeof(v) == "Instance" and v.ClassName ~= "DataModel") and v or wrap(v)
			end
			return fake
	
		else
			return real
		end
	end

    Xeno.WebSocket = {
  connect = function(url)
    local ws = { 
        Send = function(self, data)  end, 
        Close = function(self)  end, 
        OnMessage = {},
        OnClose = {}, 
    }
    return ws
  end
}

    getgenv().WebSocket.connect = function(url)
	local onmsg = Instance.new("BindableEvent")
	local oncls = Instance.new("BindableEvent")
	local conn = true
	return {
		Send = function(self, message)
			if conn then
				onmsg:Fire("Received message: " .. message)
			else
				error("WebSocket is closed")
			end
		end,
		Close = function(self)
			if conn then
				conn = false
				oncls:Fire()
			else
				error("WebSocket is already closed")
			end
		end,
		OnMessage = onmsg.Event,
		OnClose = oncls.Event
	}
end

local WebSocket = getgenv().WebSocket
WebSocket.connect = getgenv().WebSocket.connect
	
	unwrap = function(wrapped)
		if type(wrapped) == "table" then
			local real = {}
			for k,v in next,wrapped do
				real[k] = unwrap(v)
			end
			return real
		else
			local real = wrappercache[wrapped]
			if real == nil then
				return wrapped
			end
			return real
		end
	end
	getgenv().game = wrap(game)
	local oldlf = listfiles
	getgenv().listfiles = function(path)
		if path == "" or path == "C:\\" then 
			error("no")
		else 
			return oldlf(path)
		end 
	end
	print("[Stellar]: Vulns mitigated.")
	shared.vulnsm = true 
end 
getgenv().getscripts = function() 
	local scripts = {}
	for _, scriptt in game:GetDescendants() do
		if scriptt:isA("LocalScript") or scriptt:isA("ModuleScript") then
			table.insert(scripts, scriptt)
		end
	end
	return scripts
end 

getgenv().dumpbytecode = getscriptbytecode 
getgenv().loadfileasync = loadfile
getgenv().clearconsole = rconsoleclear 
getgenv().printconsole = rconsoleprint 
getgenv().getsynasset = getcustomasset 
getgenv().debug.getregistry = getreg 
getgenv().readfileasync = readfile 
getgenv().writefileasync = writefile
getgenv().appendfileasync = appendfile 
getgenv().saveplace = saveinstance 
getgenv().protect_gui = syn.protect_gui 
getgenv().unprotect_gui = syn.unprotect_gui 
getgenv().set_thread_identity = setthreadidentity 
getgenv().get_thread_identity = getthreadidentity 
getgenv().is_our_closure = isexecutorclosure 
getgenv().issynapsefunction = isexecutorclosure
local keyshit = {}
getgenv().iskeydown = function(key)
    return keyshit[key] == true
end
getgenv().iskeytoggled = function(key)
    return keyshit[key] == nil and false or keyshit[key]
end
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if not processed then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            keyshit[input.KeyCode] = true
        end
    end
end)
game:GetService("UserInputService").InputEnded:Connect(function(input, processed)
    if not processed then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            keyshit[input.KeyCode] = false
        end
    end
end)
getgenv().hookfunction = function(original, hook)
    if type(original) ~= "function" then
        error("The first arg must be a function (original function).")
    end
    if type(hook) ~= "function" then
        error("The second arg must be a function (hook).")
    end
    local info = debug.getinfo(original)
    local name = info and info.name or tostring(original)
    getgenv().ogfs[name] = original 
    local hooked = function(...)
        return hook(...)
    end
    getgenv()[name] = hooked  
    return hooked
end


getgenv().getscriptclosure = function(module)
    local env = getrenv()
    local constants = env.require(module)
    return function()
        local copy = {}
        for k, v in pairs(constants) do
            copy[k] = v
        end
        return copy
    end
end

print("Added Pro Funcs .")
if not shared.notified then 
	game:GetService("StarterGui"):SetCore("SendNotification", {
	    Title = "Stellar Injected",
	    Text = "thanks bery for the funcs!\n discord.gg/XCpMgyA4R3",  -- xeno server: discord.gg/getxeno
	    Duration = 3,
	    Icon = "rbxassetid://127282870620926"  -- Default valid image to test
	})
    shared.notified = true 
end 
getgenv().IS_Stellar_LOADED = true
