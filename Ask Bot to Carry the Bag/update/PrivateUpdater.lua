_G.BotCarryBags = _G.BotCarryBags or {}

_G.PrivateUpdater = _G.PrivateUpdater or {}

PrivateUpdater.Online_Version = ""

PrivateUpdater.Local_Version = ""

PrivateUpdater.Update_Percent = 0

function PrivateUpdater:CheckUpdate(to_folder_name, from_folder_name, modtxt_raw_url, download_url)
	if BotCarryBags and BotCarryBags.settings and BotCarryBags.settings.auto_update == 0 then
		return
	end
	local _file = io.open("mods/" .. to_folder_name .. "/mod.txt", "r")
	if not _file then
		return
	end
	local _file_data = json.decode(_file:read("*all")) or {}
	_file:close()
	if not _file_data then
		return
	end
	if string.is_nil_or_empty(_file_data.version) then
		return
	end
	PrivateUpdater.Local_Version = _file_data.version
	dohttpreq(modtxt_raw_url,
		function(data, id)
			if data and json then
				local _data = json.decode(data) or {}
				if _data then
					if not string.is_nil_or_empty(_data.version) and not string.is_nil_or_empty(_data.name) then
						PrivateUpdater.Online_Version = _data.version
						if not string.is_nil_or_empty(PrivateUpdater.Local_Version) and 
							not string.is_nil_or_empty(PrivateUpdater.Online_Version) and 
							PrivateUpdater.Local_Version ~= PrivateUpdater.Online_Version then
							local _dialog_data = {
								title = "[Private Updater]",
								text = "'".. _data.name .."'\n new version '".. PrivateUpdater.Online_Version .."' is online.\nDo you want to update? (Local is '".. PrivateUpdater.Local_Version .."')",
								button_list = {
									{ text = "[Yes]", callback_func = callback(self, self, "Accept2Update", {download_url = download_url, to_folder_name = to_folder_name, from_folder_name = from_folder_name}) },
									{ text = "[No]", is_cancel_button = true },
									{ text = "[No-Always]", callback_func = callback(self, self, "AlwaysNo", {}) }
								},
								id = tostring(math.random(0,0xFFFFFFFF))
							}
							managers.system_menu:show(_dialog_data)
						end
					end
				end
			end
		end
	)
end

function PrivateUpdater:Accept2Update(data)
	if not data.download_url or not data.to_folder_name or not data.from_folder_name then
		return
	end
	PrivateUpdater:DoUpdate(data.download_url, data.to_folder_name, data.from_folder_name)
end

function PrivateUpdater:Update_Stats()
	local _dialog_data = {
		title = "[Private Updater]",
		text = " ~".. PrivateUpdater.Update_Percent .."%",
		button_list = {
			{ text = "[Refresh]", callback_func = callback(self, self, "Update_Stats", {}) },
			{ text = "[No]", is_cancel_button = true }
		},
		id = tostring(math.random(0,0xFFFFFFFF))
	}
	managers.system_menu:show(_dialog_data)
end

function PrivateUpdater:AlwaysNo()
	if BotCarryBags then
		BotCarryBags.settings.auto_update = 0
		BotCarryBags:Save()
	end
end

function PrivateUpdater:DoUpdate(download_url, to_folder_name, from_folder_name)
	dohttpreq(download_url,
		function(data, id)
			log("Retrieved server data:\n" .. id)
			PrivateUpdater.Update_Percent = 100
			if data then
				local C = LuaModManager.Constants
				local download_path = C.mods_directory .. C.downloads_directory
				local file_path = download_path .. id .. ".zip"
				local _file = io.open(file_path, "wb+")
				if _file then
					_file:write(data)
					_file:close()
				end
				local mods_folder = "mods/downloads/" .. id .. "/"
				unzip(file_path, mods_folder)
				os.remove(file_path)
				PrivateUpdater:MoveFile(mods_folder, to_folder_name, from_folder_name)
			end
		end,
		function(id, bytes, total_bytes)
			PrivateUpdater.Update_Percent = math.floor((bytes/total_bytes)*100)
		end
	)
end

function PrivateUpdater:MoveFile(mods_folder, to_folder_name, from_folder_name)
	if not mods_folder or not to_folder_name or not from_folder_name then
		return
	end
	if io.file_is_readable(mods_folder .. from_folder_name .. "/mod.txt") then
		os.execute(string.format('rd /S /Q "%s"', "mods/" .. to_folder_name .. "/"))
		os.execute(string.format('move /Y "%s" "%s"', mods_folder .. from_folder_name, "mods/"))
		os.execute(string.format('rd /S /Q "%s"', mods_folder))
		local _dialog_data = {
			title = "[Private Updater]",
			text = "Successful!!",
			button_list = {
				{ text = "[No]", is_cancel_button = true }
			},
			id = tostring(math.random(0,0xFFFFFFFF))
		}
		managers.system_menu:show(_dialog_data)
	end
end

Hooks:Add("MenuManagerOnOpenMenu", "BotCarryBags_MenuManagerOnOpenMenu", function(menu_manager, menu, position)
	if menu == "menu_main" then
		PrivateUpdater:CheckUpdate("Ask Bot to Carry the Bag", 
			"AskBottoCarrytheBag-master/Ask Bot to Carry the Bag", 
			"https://raw.githubusercontent.com/DrNewbie/AskBottoCarrytheBag/master/Ask%20Bot%20to%20Carry%20the%20Bag/mod.txt", 
			"https://github.com/DrNewbie/AskBottoCarrytheBag/archive/master.zip")
	end
end)