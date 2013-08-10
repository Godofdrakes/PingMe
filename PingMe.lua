--=-- PingMe
--=-- By Godofdrakes

--[[NOTES
	Idea:
		Each recieved node makes a NavWheel node. Using the node makes a map marker at that ping's location.
--]]

require "math";
require "string";
require "table";
require "lib/lib_Slash";
require "lib/lib_InterfaceOptions";
require "lib/lib_MapMarker";
require "lib/lib_Callback2";
require "lib/lib_NavWheel";
require "lib/lib_UserKeybinds"

--Variables
local PING = {};
local enableScanning = true
local scanArmy = true
local openArmy = false
local scanSquad = true
local openSquad = true
local scanPublic = true
local openPublic = false
local dev = true --Scan system chat.
local loaded = false

--Map Markers
local army_marker = {}
local squad_marker = {}
local public_marker = {}
local system_marker = {}
local misc_marker = {}

--Key Bind
local FUNCTION_KEYS = {
	["F1"] = {NUM=112, TAB="Function Keys"},
	["F2"] = {NUM=113, TAB="Function Keys"},
	["F3"] = {NUM=114, TAB="Function Keys"},
	["F4"] = {NUM=115, TAB="Function Keys"},
	["F5"] = {NUM=116, TAB="Function Keys"},
	["F6"] = {NUM=117, TAB="Function Keys"},
	["F7"] = {NUM=118, TAB="Function Keys"},
	["F8"] = {NUM=119, TAB="Function Keys"},
	["F9"] = {NUM=120, TAB="Function Keys"},
	["F10"] = {NUM=121, TAB="Function Keys"},
	["F11"] = {NUM=122, TAB="Function Keys"},
	["F12"] = {NUM=123, TAB="Function Keys"},
}

local KEY_ID = FUNCTION_KEYS["F5"]["NUM"]
local KEY_BIND = {}

--Nodes
local ping_nodes = {}

--Core Functions
InterfaceOptions.AddCheckBox({id="ENABLESCAN", label="Enable scanning of pings", default=true, tooltip="Disables all scanning of recieved pings. You can still ping your loaction to others."})
InterfaceOptions.AddChoiceMenu({id="FUNCTION_KEY", label="Bind to", tooltip="Pressing this key will automatically open the PingMe node in the NavWheel. Usefull if it disappears for some reason.",})
InterfaceOptions.AddChoiceEntry({menuId="FUNCTION_KEY", label="F1", val=112})
InterfaceOptions.AddChoiceEntry({menuId="FUNCTION_KEY", label="F2", val=113})
InterfaceOptions.AddChoiceEntry({menuId="FUNCTION_KEY", label="F3", val=114})
InterfaceOptions.AddChoiceEntry({menuId="FUNCTION_KEY", label="F4", val=115})
InterfaceOptions.AddChoiceEntry({menuId="FUNCTION_KEY", label="F5", val=116})
InterfaceOptions.AddChoiceEntry({menuId="FUNCTION_KEY", label="F6", val=117})
InterfaceOptions.AddChoiceEntry({menuId="FUNCTION_KEY", label="F7", val=118})
InterfaceOptions.AddChoiceEntry({menuId="FUNCTION_KEY", label="F8", val=119})
InterfaceOptions.AddChoiceEntry({menuId="FUNCTION_KEY", label="F9", val=120})
InterfaceOptions.AddChoiceEntry({menuId="FUNCTION_KEY", label="F10", val=121})
InterfaceOptions.AddChoiceEntry({menuId="FUNCTION_KEY", label="F11", val=122})
InterfaceOptions.AddChoiceEntry({menuId="FUNCTION_KEY", label="F12", val=123})
InterfaceOptions.AddChoiceEntry({menuId="FUNCTION_KEY", label="NONE", val=nil})
InterfaceOptions.NotifyOnLoaded(true)

function SetOptionsAvailability()
end

function OnComponentLoad()
	InterfaceOptions.SetCallbackFunc(function(id, val)
		OnMessage({type=id, data=val})
	end, "PingMe")
	LIB_SLASH.BindCallback({slash_list="pinga", description="Sends your location over army chat.", func=PING.Army})
	LIB_SLASH.BindCallback({slash_list="pings", description="Sends your location over squad chat.", func=PING.Squad})
	LIB_SLASH.BindCallback({slash_list="pingz", description="Sends your location over zone chat.", func=PING.Zone})
	LIB_SLASH.BindCallback({slash_list="pingd", description="Sends your location over system chat.", func=PING.Dev})
	LIB_SLASH.BindCallback({slash_list="cleararmy", description="Removes the currently saved army ping.", func=PING.ClearArmy})
	LIB_SLASH.BindCallback({slash_list="clearSquad", description="Removes the currently saved squad ping.", func=PING.ClearSquad})
	LIB_SLASH.BindCallback({slash_list="clearpublic", description="Removes the currently saved public ping.", func=PING.ClearPublic})
	LIB_SLASH.BindCallback({slash_list="clearpings", description="Removes all currently saved pings.", func=PING.ClearPings})
	SetOptionsAvailability()
end

function OnMessage(args)
	local option = args.type
	local message = args.data
	if (option == "__LOADED") then
		InitNavNodes()
		BindKey()
		loaded = true
		return nil
	end

	if (option == "ENABLESCAN") then enableScanning = (message == true or message == "true")

	elseif (option == "SCAN_ARMY") then scanArmy = message
	elseif (option == "OPEN_ARMY") then openArmy = message

	elseif (option == "SCAN_SQUAD") then scanSquad = message
	elseif (option == "OPEN_SQUAD") then openSquad = message

	elseif (option == "SCAN_PUBLIC") then scanPublic = message
	elseif (option == "OPEN_PUBLIC") then openPublic = message

	elseif (option == "DEV") then dev = message

	elseif (option == "FUNCTION_KEY") then KEY_ID = message; BindKey()

	end
	SetOptionsAvailability()
end

--Slash Commands
PING.Army = function(args)
	local text = "I'm"
	if (args.text ~= "") then
		text = args.text
	end
	local message = text.." at ".. "X["..tostring(math.floor(Player.GetPosition()["x"])).."] ".."Y["..tostring(math.floor(Player.GetPosition()["y"])).."] ".."Z["..tostring(math.floor(Player.GetPosition()["z"])).."]"
	puts(message, "army")
end

PING.Squad = function(args)
	local text = "I'm"
	if (args.text ~= "") then
		text = args.text
	end
	local message = text.." at ".. "X["..tostring(math.floor(Player.GetPosition()["x"])).."] ".."Y["..tostring(math.floor(Player.GetPosition()["y"])).."] ".."Z["..tostring(math.floor(Player.GetPosition()["z"])).."]"
	puts(message, "squad")
end

PING.Zone = function(args)
	local text = "I'm"
	if (args.text ~= "") then
		text = args.text
	end
	local message = text.." at ".. "X["..tostring(math.floor(Player.GetPosition()["x"])).."] ".."Y["..tostring(math.floor(Player.GetPosition()["y"])).."] ".."Z["..tostring(math.floor(Player.GetPosition()["z"])).."]"
	puts(message, "zone")
end

PING.Dev = function(args)
	local text = "I'm"
	if (args.text ~= "") then
		text = args.text
	end
	local message = text.." at ".. "X["..tostring(math.floor(Player.GetPosition()["x"])).."] ".."Y["..tostring(math.floor(Player.GetPosition()["y"])).."] ".."Z["..tostring(math.floor(Player.GetPosition()["z"])).."]"
	puts(message, "system")
end

PING.ClearArmy = function(args)
	if army_marker ~= nil then army_marker:Destroy(); army_marker = nil; end
	puts("PingMe: Army marker removed.")
end

PING.ClearSquad = function(args)
	if squad_marker ~= nil then squad_marker:Destroy(); squad_marker = nil; end
	puts("PingMe: Squad marker removed.")
end

PING.ClearPublic = function(args)
	if public_marker ~= nil then public_marker:Destroy(); public_marker = nil; end
	puts("PingMe: Public marker removed.")
end

PING.ClearPings = function(args)
	if army_marker ~= nil then army_marker:Destroy(); army_marker = nil; end
	if squad_marker ~= nil then squad_marker:Destroy(); squad_marker = nil; end
	if public_marker ~= nil then public_marker:Destroy(); public_marker = nil; end
	if system_marker ~= nil then system_marker:Destroy(); system_marker = nil; end
	puts("PingMe: All markers removed.")
end

function CheckPing(args)
	if (enableScanning) then
		local pos = {x=args.text:match(("X%[(-*%d+)%]")), y=args.text:match(("Y%[(-*%d+)%]")), z=args.text:match(("Z%[(-*%d+)%]"))}
		if (pos.x ~= nil and pos.y ~= nil and pos.z ~= nil) then
			MarkerNode({id=args.author or "blarg", channel=args.channel or "system", title=args.text or "system", subtitle=args.author or "blarg", x=pos.x, y=pos.y, z=pos.z})
		end
	end
end

function puts(buffer, chatOutput)
	--Makes chat messages. Credit to LemonKing
	--if chatOutput is undefined broadcast will be used
	if type(chatOutput) ~= "string" then chatOutput = nil end
	Component.GenerateEvent("MY_CHAT_MESSAGE", {channel=chatOutput or "system", text=tostring(buffer)})
end

function MakeMarker(args) --args = {id, channel, title, subtitle, x, y, z}
	if (args.channel == "army" and army_marker[args.id].map == nil) then
		army_marker[args.id].map = MapMarker.Create()
		army_marker[args.id].map:BindToPosition({x=args.x, y=args.y, z=args.z})
		army_marker[args.id].map:SetTitle(args.title)
		army_marker[args.id].map:SetSubtitle(args.subtitle)
		army_marker[args.id].map:GetIcon():SetTexture("icons", "Army")
		army_marker[args.id].map:ShowOnWorldMap(1)
		army_marker[args.id].map:ShowOnRadar(1)
		army_marker[args.id].map:SelectOnMap()
		army_marker[args.id].map:Ping()
	elseif (args.channel == "squad" and squad_marker[args.id].map == nil) then
		squad_marker[args.id].map = MapMarker.Create()
		squad_marker[args.id].map:BindToPosition({z=args.x, y=args.y, z=args.z})
		squad_marker[args.id].map:SetTitle(args.title)
		squad_marker[args.id].map:SetSubtitle(args.subtitle)
		squad_marker[args.id].map:GetIcon():SetTexture("aag_icons", "squad")
		squad_marker[args.id].map:ShowOnWorldMap(1)
		squad_marker[args.id].map:ShowOnRadar(1)
		squad_marker[args.id].map:SelectOnMap()
		squad_marker[args.id].map:Ping()
	elseif ((args.channel == "zone" or args.channel == "local") and public_marker[args.id].map == nil) then
		public_marker[args.id].map = MapMarker.Create()
		public_marker[args.id].map:BindToPosition({x=args.x, y=args.y, z=args.z})
		public_marker[args.id].map:SetTitle(args.title)
		public_marker[args.id].map:SetSubtitle(args.subtitle)
		public_marker[args.id].map:GetIcon():SetTexture("icons", "com_tower")
		public_marker[args.id].map:ShowOnWorldMap(1)
		public_marker[args.id].map:ShowOnRadar(1)
		public_marker[args.id].map:SelectOnMap()
		public_marker[args.id].map:Ping()
	elseif (system_marker[args.id].map == nil) then
		system_marker[args.id].map = MapMarker.Create()
		system_marker[args.id].map:BindToPosition({x=args.x, y=args.y, z=args.z})
		system_marker[args.id].map:SetTitle(args.title)
		system_marker[args.id].map:SetSubtitle(args.subtitle)
		system_marker[args.id].map:GetIcon():SetTexture("icons", "security")
		system_marker[args.id].map:ShowOnWorldMap(1)
		system_marker[args.id].map:ShowOnRadar(1)
		system_marker[args.id].map:SelectOnMap()
		system_marker[args.id].map:Ping()
	elseif (misc_marker[args.id].map == nil) then
		misc_marker[args.id].map = MapMarker.Create()
		misc_marker[args.id].map:BindToPosition({x=args.x, y=args.y, z=args.z})
		misc_marker[args.id].map:SetTitle(args.title)
		misc_marker[args.id].map:SetSubtitle(args.subtitle)
		misc_marker[args.id].map:GetIcon():SetTexture("icons", "security")
		misc_marker[args.id].map:ShowOnWorldMap(1)
		misc_marker[args.id].map:ShowOnRadar(1)
		misc_marker[args.id].map:SelectOnMap()
		misc_marker[args.id].map:Ping()
	end
end

function MarkerNode(args) --args = {id, channel, title, subtitle, x, y, z}
	if (args.channel == "army" and army_marker[args.id] == nil) then
		army_marker[args.id] = {}
		army_marker[args.id].args = args
		army_marker[args.id].timer = Callback2.Create()
		army_marker[args.id].timer:Bind(army_marker[args.id].delete)
		army_marker[args.id].timer:Schedule(120)
		army_marker[args.id].node = NavWheel.CreateNode(args.id)
		army_marker[args.id].node:SetTitle(args.title)
		army_marker[args.id].node:SetDescription(args.subtitle)
		army_marker[args.id].action = function()
			NavWheel.Close()
			army_marker[args.id].node:Destroy()
			MakeMarker(args)
		end
		army_marker[args.id].node:SetAction(army_marker[args.id].action)
		army_marker[args.id].node:SetParent("army_markers")
		army_marker[args.id].node:GetIcon():SetTexture("icons", "Army")
		army_marker[args.id].delete = function()
			army_marker[args.id].timer:Release()
			army_marker[args.id].node:Destroy()
			army_marker[args.id] = nil
		end
	elseif (args.channel == "squad" and squad_marker[args.id] == nil) then
		squad_marker[args.id] = {}
		squad_marker[args.id].args = args
		squad_marker[args.id].timer = Callback2.Create()
		squad_marker[args.id].timer:Bind(squad_marker[args.id].delete)
		squad_marker[args.id].timer:Schedule(120)
		squad_marker[args.id].node = NavWheel.CreateNode(args.id)
		squad_marker[args.id].node:SetTitle(args.title)
		squad_marker[args.id].node:SetDescription(args.subtitle)
		squad_marker[args.id].action = function()
			NavWheel.Close()
			squad_marker[args.id].node:Destroy()
			MakeMarker(args)
		end
		squad_marker[args.id].node:SetAction(squad_marker[args.id].action)
		squad_marker[args.id].node:SetParent("squad_markers")
		squad_marker[args.id].node:GetIcon():SetTexture("aag_icons", "squad")
		squad_marker[args.id].delete = function()
			squad_marker[args.id].timer:Release()
			squad_marker[args.id].node:Destroy()
			squad_marker[args.id] = nil
		end
	elseif (args.channel == "zone" and public_marker[args.id] == nil) then
		public_marker[args.id] = {}
		public_marker[args.id].args = args
		public_marker[args.id].timer = Callback2.Create()
		public_marker[args.id].timer:Bind(public_marker[args.id].delete)
		public_marker[args.id].timer:Schedule(120)
		public_marker[args.id].node = NavWheel.CreateNode(args.id)
		public_marker[args.id].node:SetTitle(args.title)
		public_marker[args.id].node:SetDescription(args.subtitle)
		public_marker[args.id].action = function()
			NavWheel.Close()
			public_marker[args.id].node:Destroy()
			MakeMarker(args)
		end
		public_marker[args.id].node:SetAction(public_marker[args.id].action)
		public_marker[args.id].node:SetParent("public_markers")
		public_marker[args.id].node:GetIcon():SetTexture("icons", "com_tower")
		public_marker[args.id].delete = function()
			public_marker[args.id].timer:Release()
			public_marker[args.id].node:Destroy()
			public_marker[args.id] = nil
		end
	elseif (args.channel == "system" and system_marker[args.id] == nil and dev) then
		system_marker[args.id] = {}
		system_marker[args.id].args = args
		system_marker[args.id].timer = Callback2.Create()
		system_marker[args.id].timer:Bind(system_marker[args.id].delete)
		system_marker[args.id].timer:Schedule(120)
		system_marker[args.id].node = NavWheel.CreateNode(args.id)
		system_marker[args.id].node:SetTitle(args.title)
		system_marker[args.id].node:SetDescription(args.subtitle)
		system_marker[args.id].action = function()
			NavWheel.Close()
			system_marker[args.id].node:Destroy()
			MakeMarker(args)
		end
		system_marker[args.id].node:SetAction(system_marker[args.id].action)
		system_marker[args.id].node:SetParent("system_markers")
		system_marker[args.id].node:GetIcon():SetTexture("icons", "refining")
		system_marker[args.id].delete = function()
			system_marker[args.id].timer:Release()
			system_marker[args.id].node:Destroy()
			system_marker[args.id] = nil
		end
	elseif (misc_marker[args.id] == nil) then
		misc_marker[args.id] = {}
		misc_marker[args.id].args = args
		misc_marker[args.id].timer = Callback2.Create()
		misc_marker[args.id].timer:Bind(misc_marker[args.id].delete)
		misc_marker[args.id].timer:Schedule(120)
		misc_marker[args.id].node = NavWheel.CreateNode(args.id)
		misc_marker[args.id].node:SetTitle(args.title)
		misc_marker[args.id].node:SetDescription(args.subtitle)
		misc_marker[args.id].action = function()
			NavWheel.Close()
			misc_marker[args.id].node:Destroy()
			MakeMarker(args)
		end
		misc_marker[args.id].node:SetAction(misc_marker[args.id].action)
		misc_marker[args.id].node:SetParent("misc_markers")
		misc_marker[args.id].node:GetIcon():SetTexture("icons", "game")
		misc_marker[args.id].delete = function()
			misc_marker[args.id].timer:Release()
			misc_marker[args.id].node:Destroy()
			misc_marker[args.id] = nil
		end
	end
end

function InitNavNodes()
	ping_nodes.base = NavWheel.CreateNode()
	ping_nodes.base:SetTitle("PingMe")
	ping_nodes.base:SetDescription("Recieved Markers")
	ping_nodes.base:SetParent("hud_root")
	ping_nodes.base:GetIcon():SetTexture("icons", "ping")

	ping_nodes.army = NavWheel.CreateNode()
	ping_nodes.army:SetTitle("Army Pings")
	ping_nodes.army:SetDescription("Pings recieved through army chat.")
	ping_nodes.army:SetParent(ping_nodes.base:GetId())
	ping_nodes.army:GetIcon():SetTexture("icons", "Army")

	ping_nodes.squad = NavWheel.CreateNode()
	ping_nodes.squad:SetTitle("Squad Pings")
	ping_nodes.squad:SetDescription("Pings recieved through squad chat.")
	ping_nodes.squad:SetParent(ping_nodes.base:GetId())
	ping_nodes.squad:GetIcon():SetTexture("aag_icons", "squad")

	ping_nodes.public = NavWheel.CreateNode()
	ping_nodes.public:SetTitle("Public Pings")
	ping_nodes.public:SetDescription("Pings recieved through public chat channels.")
	ping_nodes.public:SetParent(ping_nodes.base:GetId())
	ping_nodes.public:GetIcon():SetTexture("icons", "com_tower")

	if (dev) then
		ping_nodes.system = NavWheel.CreateNode()
		ping_nodes.system:SetTitle("System Pings")
		ping_nodes.system:SetDescription("Pings recieved through system chat.")
		ping_nodes.system:SetParent(ping_nodes.base:GetId())
		ping_nodes.system:GetIcon():SetTexture("icons", "refining")
	end

	ping_nodes.misc = NavWheel.CreateNode()
	ping_nodes.misc:SetTitle("Misc Pings")
	ping_nodes.misc:SetDescription("Pings recieved through other chat channels.")
	ping_nodes.misc:SetParent(ping_nodes.base:GetId())
	ping_nodes.misc:GetIcon():SetTexture("icons", "game")
end

function BindKey()
	KEY_BIND.FUNC = function()
		NavWheel.OpenNode(ping_nodes.base:GetId())
	end

	if (loaded) then
		KEY_BIND.BIND:Destroy()
		KEY_BIND.BIND = UserKeybinds.Create()
		KEY_BIND.BIND:RegisterAction("OPEN_PINGME", KEY_BIND.FUNC)
		if (KEY_ID ~= "NONE" and KEY_ID ~= nil) then
			KEY_BIND.BIND:BindKey("OPEN_PINGME", tonumber(KEY_ID))
		end
	else
		KEY_BIND.BIND = UserKeybinds.Create()
		KEY_BIND.BIND:RegisterAction("OPEN_PINGME", KEY_BIND.FUNC)
		if (KEY_ID ~= "NONE" and KEY_ID ~= nil) then
			KEY_BIND.BIND:BindKey("OPEN_PINGME", tonumber(KEY_ID))
		end
	end
end