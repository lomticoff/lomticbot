local ev = require 'samp.events'
local addon = require 'addon'
local requests = require 'requests'
encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local effil = require 'effil'
local json = require 'json'
local mysql_drv	= require 'luasql.mysql'
local cjson 					= require 'cjson'
local inicfg 					= require 'inicfg'
local luaVkApi 					= require 'luaVkApi'
local cjson 					= require 'cjson'
local mysql_drv					= require 'luasql.mysql'
local crypto 					= require 'crypto_lua'
script_name("lomtic")
script_version("14.07.2024")
local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://github.com/lomticoff/lomticbot/blob/main/updaterjson.json?" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://github.com/qrlk/moonloader-script-updater/"
        end
    end
end
function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then
        return
    end
    while not isSampAvailable() do
        wait(100)
    end

    -- вырежи тут, если хочешь отключить проверку обновлений
    if autoupdate_loaded and enable_autoupdate and Update then
        pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end
    -- вырежи тут, если хочешь отключить проверку обновлений
   
    -- дальше идёт ваш код
end
require 'strings'
require 'gromov'
-------------------------------------------------------------- [ НАСТРОЙКИ БОТА ] --------------------------------------------------------------
local two_access_token 		= 'vk1.a.L_moesifN9X1zRa9RdBWxnwsBCoRI9gljHx1-n105CHqpZqgbl1INiMbiAf2tF6XmtJuCc5Pp2rF8pNcsRpxzq8u06AW5taSKBpQmYjzmfDUD7MhAKrjjsqiUEsCS8LB_6y6m_709pFWQy58IaEe-d7rUpIWJzOJ3EKHLNjaDxPcwTY3bfrNwFloG0xJUswKZO5lKl2ZwSkrLFPr1MVBHA'
local access_token 			= 'vk1.a.L_moesifN9X1zRa9RdBWxnwsBCoRI9gljHx1-n105CHqpZqgbl1INiMbiAf2tF6XmtJuCc5Pp2rF8pNcsRpxzq8u06AW5taSKBpQmYjzmfDUD7MhAKrjjsqiUEsCS8LB_6y6m_709pFWQy58IaEe-d7rUpIWJzOJ3EKHLNjaDxPcwTY3bfrNwFloG0xJUswKZO5lKl2ZwSkrLFPr1MVBHA'
local group_id 				= '225917711'
local log_chat_id           = '1'
local log_acces_token       = 'vk1.a.L_moesifN9X1zRa9RdBWxnwsBCoRI9gljHx1-n105CHqpZqgbl1INiMbiAf2tF6XmtJuCc5Pp2rF8pNcsRpxzq8u06AW5taSKBpQmYjzmfDUD7MhAKrjjsqiUEsCS8LB_6y6m_709pFWQy58IaEe-d7rUpIWJzOJ3EKHLNjaDxPcwTY3bfrNwFloG0xJUswKZO5lKl2ZwSkrLFPr1MVBHA'
local chat_id                           = '1'
local two_chat_id 			= '1'
local bot_name 				= 'Test_Arizona' 
local account_password 		= 'qwerty' 
local admin_password 		= '123123' 
local hook_adminchat 		= '%[A%] {......}%[(.*)%]{99CC00} (.*)%[(%d+)%]:'
local vk_group_link 		= 'vk.com/'
local forum_link 			= ''
local server_db 			= 'gs258121'
local server_user 			= 'gs258121'
local server_pass			= 'vGeK3PKn4q6g'
local server_host			= '51.91.215.125'
local forum_db 				= 'lomticforum'
local forum_user 			= 'lomticforum'
local forum_pass			= 'lomticforum'
local forum_host			= '92.53.99.174'
local servers_list			= {'51.75.232.67:2093'}
local array_nrg 			= {"нрг", "мотоцикл", "Нрг", "НРГ", "Мотоцикл"}
local array_hello 			= {"привет", "Привет", "qq", "Qq"}
local array_hp 				= {"дайте хп", "дай хп", "Дайте хп", "Дай ХП", "хилл", "Хилл"}
local array_meria 			= {"тп мэрия", "тп в мэрию", "ТП мэрия", "ТП в мэрию", "тп в мерию"}
local array_ptp 			= {"телепортируйте к", "Телепортируйте к"}
local array_pass 			= {"дайте паспорт", "Дайте паспорт"}
local array_help			= {'бот помощь', 'бот команды'}
local array_flip 			= {"флип", "переверните", "почините", "Флип", "Переверните", "Почините", "ФЛИП"}
local array_cr 				= {"бот тп цр", "бот тп на цр"}
local array_ab 				= {"бот тп аб", "бот тп на аб"}
local array_cb 				= {"бот тп цб", "бот тп на цб"}
local array_bash 			= {"бот тп банк", "бот тп на банк"}
local array_blv				= {'тп к банку лв', 'тпните к банку лв', 'тп на банку лв', 'тпните на банку лв'}
local array_mats 			= {"mq", "мать ебал", "матуху ебал", "мачеху ебал", "маме ку", "матери ку", "мачехе ку", "mother", "rnq"}
local array_banip 			= {"нубо", "Нубо", "Админки", "Лидерки"}
local array_awarn 			= {"хуй", "пизда", "шлюха", "мать ебал", "mqqq", "mqq", "mmqq", "mq", "динаху", "блять", "сука", "нахуй", "бледина", "блядина", "пенис", "ебал", "член", "головка", "нахуя", "нихуя", "пидор"}
local array_neadekvats 		= {"пидор", "пизда", "шлюха", "мать", "блять", "сука", "нахуй", "бляд", "хуй", "член", "Пидор", "Пизда", "Шлюха", "Мать", "Блять", "Сука", "Нахуй", "Бляд", "Хуй", "Член"}
local array_car 			= {"машину", "тачку", "инфернус", "Инфернус", "Машину", "Тачку"}
local array_spawn 			= {"спавн", "Спавн"}
-------------------------------------------------------------- [ НАСТРОЙКИ БОТА ] --------------------------------------------------------------

local cfg = inicfg.load(
    {
	config = {
		vipchat_action = true,
		antiflood_msg = 60,
		conference_peer_id = '1',
		check_on_public = false,
	},
	cooldowns = {
		nrg = 90,
		flip = 45,
		infernus = 90,
		spawn = 90,
		help = 120,
		teleport = 300,
		try = 600,
		hp = 90,
		pass = 120,
	}
    }, bot_name..".ini"
)

local tp_points = {
	['цр'] = '1118.2419 -1429.4121 15.7969', 
	['аб'] = '-2129.8386 -747.4906 32.0234', 
	['блв'] = '2380.1331 2308.4976 8.1406', 
	['цб'] = '1485.3685 -1769.5591 18.7929',
	['мерия'] = '1495.1819 -1287.2955 14.5087'
}

local per_interval_admins
local per_interval_captcha
local per_interval_interaction
local per_interval_question
local per_interval_rekla
local per_interval_skin
local per_interval_stock
local per_timeout_autoopra
local per_uinterval_wflood

local config = {
	{'interval_admins', per_interval_admins},
	{'interval_captcha', per_interval_captcha},
	{'interval_interaction', per_interval_interaction},
	{'interval_question', per_interval_question},
	{'interval_rekla', per_interval_rekla},
	{'interval_skin', per_interval_skin},
	{'interval_stock', per_interval_stock},
	{'timeout_autoopra', per_timeout_autoopra},
	{'uinterval_wflood', per_uinterval_wflood}
}

local msgs = {}
local names_day_of_week = {'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'}
local default_all_bot_commands = { 
	{'q', 0},
	{'is', 0},
	{'snick', 1},
	{'rnick', 1},
	{'nlist', 1},
	{'ac', 1},
	{'zov', 1},
	{'stats', 1},
	{'online', 1},
	{'stata', 1},
	{'help', 1},
	{'question', 1},
	{'captcha', 1},
	{'admins', 1},
	{'reports', 1},
	{'dlist', 1},
	{'staff', 1},
	{'leaders', 1},
	{'aleaders', 1},
	{'removerole', 2},
	{'mtop', 2},
	{'addadmin', 2},
	{'kick', 2},
	{'astats', 2},
	{'check', 2},
	{'checkinv', 2},
	{'warn', 2},
	{'vig', 2},
	{'unwarn', 2},
	{'unvig', 2},
	{'aopra', 2},
	{'addspec', 3},
	{'iwl', 3},
	{'mute', 3},
	{'unmute', 3},
	{'greetings', 3},
	{'twl', 3},
	{'gwl', 3},
	{'demote', 3},
	{'fdel', 3},
	{'aflist', 3},
	{'fadd', 3},
	{'nfdel', 3},
	{'naflist', 3},
	{'nfadd', 3},
	{'settings', 3},
	{'ban', 3},
	{'silence', 3},
	{'checkpublic', 3},
	{'setpublic', 3},
	{'removepublic', 3},
	{'unban', 3},
	{'rkick', 4},
	{'addowner', 4},
	{'spam', 4},
	{'editcmd', 4},
}

local report_statistic_array = {'dayreportstatistic.ini', 'weekreportstatistic.ini', 'allreportstatistic.ini'}
local admin_statistic_array = {'dayadminstatistic.ini', 'weekadminstatistic.ini', 'alladminstatistic.ini'}
local online_statistic_array = {'dayonlinestatistic.ini', 'weekonlinestatistic.ini', 'allonlinestatistic.ini'}
local toweek_nulled_array = {'weekonlinestatistic.ini', 'weekreportstatistic.ini', 'weekadminstatistic.ini'}
local today_nulled_array = {'dayonlinestatistic.ini', 'dayreportstatistic.ini', 'dayadminstatistic.ini'}

local ansi_decode= {
   [128]='\208\130',[129]='\208\131',[130]='\226\128\154',[131]='\209\147',[132]='\226\128\158',[133]='\226\128\166',
   [134]='\226\128\160',[135]='\226\128\161',[136]='\226\130\172',[137]='\226\128\176',[138]='\208\137',[139]='\226\128\185',
   [140]='\208\138',[141]='\208\140',[142]='\208\139',[143]='\208\143',[144]='\209\146',[145]='\226\128\152',
   [146]='\226\128\153',[147]='\226\128\156',[148]='\226\128\157',[149]='\226\128\162',[150]='\226\128\147',[151]='\226\128\148',
   [152]='\194\152',[153]='\226\132\162',[154]='\209\153',[155]='\226\128\186',[156]='\209\154',[157]='\209\156',
   [158]='\209\155',[159]='\209\159',[160]='\194\160',[161]='\209\142',[162]='\209\158',[163]='\208\136',
   [164]='\194\164',[165]='\210\144',[166]='\194\166',[167]='\194\167',[168]='\208\129',[169]='\194\169',
   [170]='\208\132',[171]='\194\171',[172]='\194\172',[173]='\194\173',[174]='\194\174',[175]='\208\135',
   [176]='\194\176',[177]='\194\177',[178]='\208\134',[179]='\209\150',[180]='\210\145',[181]='\194\181',
   [182]='\194\182',[183]='\194\183',[184]='\209\145',[185]='\226\132\150',[186]='\209\148',[187]='\194\187',
   [188]='\209\152',[189]='\208\133',[190]='\209\149',[191]='\209\151'
}
local utf8_decode={
  [128]={[147]='\150',[148]='\151',[152]='\145',[153]='\146',[154]='\130',[156]='\147',[157]='\148',[158]='\132',[160]='\134',[161]='\135',[162]='\149',[166]='\133',[176]='\137',[185]='\139',[186]='\155'},
  [130]={[172]='\136'},
  [132]={[150]='\185',[162]='\153'},
  [194]={[152]='\152',[160]='\160',[164]='\164',[166]='\166',[167]='\167',[169]='\169',[171]='\171',[172]='\172',[173]='\173',[174]='\174',[176]='\176',[177]='\177',[181]='\181',[182]='\182',[183]='\183',[187]='\187'},
  [208]={[129]='\168',[130]='\128',[131]='\129',[132]='\170',[133]='\189',[134]='\178',[135]='\175',[136]='\163',[137]='\138',[138]='\140',[139]='\142',[140]='\141',[143]='\143',[144]='\192',[145]='\193',[146]='\194',[147]='\195',[148]='\196',
    [149]='\197',[150]='\198',[151]='\199',[152]='\200',[153]='\201',[154]='\202',[155]='\203',[156]='\204',[157]='\205',[158]='\206',[159]='\207',[160]='\208',[161]='\209',[162]='\210',[163]='\211',[164]='\212',[165]='\213',[166]='\214',
    [167]='\215',[168]='\216',[169]='\217',[170]='\218',[171]='\219',[172]='\220',[173]='\221',[174]='\222',[175]='\223',[176]='\224',[177]='\225',[178]='\226',[179]='\227',[180]='\228',[181]='\229',[182]='\230',[183]='\231',[184]='\232',
    [185]='\233',[186]='\234',[187]='\235',[188]='\236',[189]='\237',[190]='\238',[191]='\239'},
  [209]={[128]='\240',[129]='\241',[130]='\242',[131]='\243',[132]='\244',[133]='\245',[134]='\246',[135]='\247',[136]='\248',[137]='\249',[138]='\250',[139]='\251',[140]='\252',[141]='\253',[142]='\254',[143]='\255',[144]='\161',[145]='\184',
    [146]='\144',[147]='\131',[148]='\186',[149]='\190',[150]='\179',[151]='\191',[152]='\188',[153]='\154',[154]='\156',[155]='\158',[156]='\157',[158]='\162',[159]='\159'},[210]={[144]='\165',[145]='\180'}
}

local nmdc = {
  [36] = '$',
  [124] = '|'
}

function Utf8ToAnsi(s)
  local a, j, r, b = 0, 0, ''
  for i = 1, s and s:len() or 0 do
    b = s:byte(i)
    if b < 128 then
      if nmdc[b] then
        r = r..nmdc[b]
      else
        r = r..string.char(b)
      end
    elseif a == 2 then
      a, j = a - 1, b
    elseif a == 1 then
      a, r = a - 1, r..utf8_decode[j][b]
    elseif b == 226 then
      a = 2
    elseif b == 194 or b == 208 or b == 209 or b == 210 then
      j, a = b, 1
    else
      r = r..'_'
    end
  end
  return r
end

local ts, server, key
local autoopra = false
local cd_autoopra = os.clock()
local silence = false
local all_users_ids = {}
local all_conference_users = {}
local cd_nrg = os.clock()
local all_conference_users = {}
local whitelist = {}
local automatic_autoopra_in_payday = false
local captime = 0
local questime = 0
local skintime = 0
local strocks_online = 0
local strocks_report = 0
local strocks_admins = 0
local all_online = 0 
local all_report = 0 
local all_admins = 0 
local give_bans = 0
local give_mutes = 0
local give_demorgans = 0
local give_warns = 0
local give_kicks = 0
local answer_reports = 0
local leadernum = 0
local gotp_slet = 0
all_users_ids = {}
local all_users_with_name = 0

function partOfSystemCheckHouse()
	min_house = min_house + 1
	if tonumber(min_house) <= tonumber(max_house) then
		newTask(function()
			wait(750)
			sendInput('/checkhouse '..min_house..'')
		end)
	elseif tonumber(min_house) > tonumber(max_house) then
		check_house = false
		check_house_ban = false
		local f = io.open(bot_name..'/Logs/checkhousis.ini', "r")
		house_check_list = f:read('*a')
		f:close()
		threekeyboard_vk('&#128450; Собранная информация по домам:\n\n'..house_check_list)
		local f = io.open(bot_name..'/Logs/checkhousis.ini', 'w')
		f:write('')
		f:close()
	end
end

function partOfSystemCheckBiz()
	min_biz = min_biz + 1
	if tonumber(min_biz) <= tonumber(max_biz) then
		newTask(function()
			wait(750)
			sendInput('/checkbiz '..min_biz)
		end)
	elseif tonumber(min_biz) > tonumber(max_biz) then
		check_biz = false
		check_business_ban = false
		local f = io.open(bot_name..'/Logs/checkbusinessis.ini', "r")
		business_check_list = f:read('*a')
		f:close()
		twokeyboard_vk('&#128450; Собранная информация по бизнесам:\n\n'..business_check_list)
		local f = io.open(bot_name..'/Logs/checkbusinessis.ini', 'w')
		f:write('')
		f:close()
	end
end

function ev.onServerMessage(color, text)
	for k,v in ipairs(servers_list) do
		if getIP() == v then
			if auto_slet then
				if text:find('%[Начало Мероприятия%]{......} (.*) %('..bot_name..'%)') then
					sendInput('/gotp')
					gotp_slet = gotp_slet + 1
					if tonumber(gotp_slet) == 1 then
						newTask(function()
							while true do
								wait(1000)
								if isConnected() and auto_slet then
									sendInput('/smp '..name_opra)
								end
							end
						end)
					end
				end
				if text:find('А: (.*)%[(%d+)%] выдал выговор администратору (.*)%[(%d+)%] %[(%d+)/3%] Причина: (.*)') then
				adminnick, adminid, pnick, pid, awarns, reason = text:match('А: (.*)%[(%d+)%] выдал выговор администратору (.*)%[(%d+)%] %[(%d+)/3%] Причина: (.*)')
					if not isAdminInsert(adminnick) then
						db_bot:execute("INSERT INTO `admin_stats` (`adminnick`) VALUE ('"..adminnick.."')")
						db_bot:execute("UPDATE `admin_stats` SET all_awarns = all_awarns+1 where `adminnick` = '"..adminnick.."'")
						db_bot:execute("UPDATE `admin_stats` SET week_awarns = week_awarns+1 where `adminnick` = '"..adminnick.."'")
						VkMessage('&#128219; '..text..'.')
						LogVkMessage('Администратор '..adminnick..' выдал выговор администратору '..pnick..' ['..awarns..'/3]. Причина: '..reason)
					end
				end
				if text:find('%[Мероприятие%]{ffffff} Телепорт на мероприятие закрыт, время вышло%.') then
					if tonumber(id_type) == 0 then
						sendInput('/asellhouse '..slet_id)
					elseif tonumber(id_type) == 1 then
						sendInput('/asellbiz '..slet_id)
					end
					auto_slet = false
					jail_slet = true
				end
			end
			if text:find('%[A%] (.*)%[(%d+)%] %-> (.*)%[(%d+)%]:{ffffff} (.*)') then
					adminnick, aid, pnick, pid, otvet = text:match('%[A%] (.*)%[(%d+)%] %-> (.*)%[(%d+)%]:{ffffff} (.*)')
					if not isAdminInsert(adminnick) then db_bot:execute("INSERT INTO `admin_stats` (`adminnick`) VALUE ('"..adminnick.."')"); end
					db_bot:execute("UPDATE `admin_stats` SET all_reports = all_reports+1 where `adminnick` = '"..adminnick.."'"); 
					db_bot:execute("UPDATE `admin_stats` SET week_reports = week_reports+1 where `adminnick` = '"..adminnick.."'");
					LogVkMessage('Администратор '..adminnick..' ответил на репорт игроку '..pnick..' - ['..otvet..']')
				end
			if text:find('%[A%] (.*)%[(%d+)%] %-> (.*)%[(%d+)%]:{ffffff} (.*)') then
				if reports ~= nil then 
					if tonumber(reports-1) >= 0 then 
						reports = reports-1 
					end 
				end
			end
			if text:find("(.*)%[(%d+)%]% подозревается во взломе") then
					aname, aid = text:match("(.*)%[(%d+)%]% подозревается во взломе")
					if aname == 'sanechka' or aname == ''..bot_name..'' or aname == 'Molodoy_Nalletka' or aname == 'Bell_King' or aname == 'Utopia_Boss' or aname == 'server' then
						sendInput('/acceptadmin '..aid)
					else
						accept_vk("&#128221; Запрос ацепта на Alpina &#128221;\n\n&#128125; Администратор "..aname)
						get_ip_information = true
						type_ip_information = 3
						sendInput('/getip '..aid)
					end
				end
			if text:find('Администратор (.*)%[(%d+)%] забанил игрока (.*)%[(%d+)%] на (%d+) дней. Причина: (.*)') then
					adminnick, aid, pnick, pid, vremya, reason = text:match('Администратор (.*)%[(%d+)%] забанил игрока (.*)%[(%d+)%] на (%d+) дней. Причина: (.*)')
					if not isAdminInsert(adminnick) then db_bot:execute("INSERT INTO `admin_stats` (`adminnick`) VALUE ('"..adminnick.."')"); end
					db_bot:execute("UPDATE `admin_stats` SET all_bans = all_bans+1 where `adminnick` = '"..adminnick.."'"); 
					db_bot:execute("UPDATE `admin_stats` SET week_bans = week_bans+1 where `adminnick` = '"..adminnick.."'");
					LogVkMessage('Администратор '..adminnick..' забанил игрока '..pnick..' на '..vremya..' дней. Причина: '..reason)
				end
			if text:find('A: (.*)%[(%d+)%] забанил игрока (.*)%[(%d+)%]. Причина: (.*)') then
					adminnick, aid, pnick, pid, reason = text:match('A: (.*)%[(%d+)%] забанил игрока (.*)%[(%d+)%]. Причина: (.*)')
					if not isAdminInsert(adminnick) then db_bot:execute("INSERT INTO `admin_stats` (`adminnick`) VALUE ('"..adminnick.."')"); end
					db_bot:execute("UPDATE `admin_stats` SET all_bans = all_bans+1 where `adminnick` = '"..adminnick.."'"); 
					db_bot:execute("UPDATE `admin_stats` SET week_bans = week_bans+1 where `adminnick` = '"..adminnick.."'");
					LogVkMessage('Администратор '..adminnick..' забанил игрока '..pnick..' по IP. Причина: '..reason)
				end
			if text:find('A: (.*)%[(%d+)%] посадил игрока (.*)%[(%d+)%] в деморган на (%d+) минут. Причина: (.*)') then
					adminnick, aid, pnick, pid, vremya, reason = text:match('A: (.*)%[(%d+)%] посадил игрока (.*)%[(%d+)%] в деморган на (%d+) минут. Причина: (.*)')
					if not isAdminInsert(adminnick) then db_bot:execute("INSERT INTO `admin_stats` (`adminnick`) VALUE ('"..adminnick.."')"); end
					db_bot:execute("UPDATE `admin_stats` SET all_demorgans = all_demorgans+1 where `adminnick` = '"..adminnick.."'"); 
					db_bot:execute("UPDATE `admin_stats` SET week_demorgans = week_demorgans+1 where `adminnick` = '"..adminnick.."'");
					LogVkMessage('Администратор '..adminnick..' посадил игрока '..pnick..' в деморган на '..vremya..' минут. Причина: '..reason)
				end
			if text:find('A: (.*)%[(%d+)%] заглушил игрока (.*)%[(%d+)%] на (%d+) минут. Причина: (.*)') then
					adminnick, aid, pnick, pid, vremya, reason = text:match('A: (.*)%[(%d+)%] заглушил игрока (.*)%[(%d+)%] на (%d+) минут. Причина: (.*)')
					if not isAdminInsert(adminnick) then
						db_bot:execute("INSERT INTO `admin_stats` (`adminnick`) VALUE ('"..adminnick.."')")
					end
					db_bot:execute("UPDATE `admin_stats` SET all_mutes = all_mutes+1 where `adminnick` = '"..adminnick.."'")
					db_bot:execute("UPDATE `admin_stats` SET week_mutes = week_mutes+1 where `adminnick` = '"..adminnick.."'")
					LogVkMessage('Администратор '..adminnick..' заглушил игрока '..pnick..' на '..vremya..' минут. Причина: '..reason)
				end
			if text:find('(.*) установил в оффлайне (%d+) минут молчанки игроку (.*). Причина: (.*)') then
				adminnick = text:match('(.*) установил в оффлайне (%d+) минут молчанки игроку (.*). Причина: (.*)')
				if not isAdminInsert(adminnick) then
					db_bot:execute("INSERT INTO `admin_stats` (`adminnick`) VALUE ('"..adminnick.."')")
				end
				db_bot:execute("UPDATE `admin_stats` SET all_mutes = all_mutes+1 where `adminnick` = '"..adminnick.."'")
				db_bot:execute("UPDATE `admin_stats` SET week_mutes = week_mutes+1 where `adminnick` = '"..adminnick.."'")
				LogVkMessage('Администратор '..adminnick..' оффлайн заглушил игрока '..pnick..' на '..vremya..' минут. Причина: '..reason)
			end
			if text:find('А: (.*)%[(%d+)%] кикнул игрока (.*)%[(%d+)%]. Причина: (.*)') then
					nickname, aid, pnick, pid, reason = text:match('А: (.*)%[(%d+)%] кикнул игрока (.*)%[(%d+)%]. Причина: (.*)')
					if not isAdminInsert(nickname) then
						db_bot:execute("INSERT INTO `admin_stats` (`adminnick`) VALUE ('"..nickname.."')")
					end
					db_bot:execute("UPDATE `admin_stats` SET all_kicks = all_kicks+1 where `adminnick` = '"..nickname.."'")
					db_bot:execute("UPDATE `admin_stats` SET week_kicks = week_kicks+1 where `adminnick` = '"..nickname.."'")
					LogVkMessage('Администратор '..adminnick..' кикнул игрока '..pnick..'. Причина: '..reason)
				end
			if text:find('A: (.*)%[(%d+)%] забанил игрока '..bot_name..'%[(%d+)%] на (%d+) дней. Причина: (.*)') then
						anick, aid, pid, days, reason = text:match('A: (.*)%[(%d+)%] забанил игрока '..bot_name..'%[(%d+)%] на (%d+) дней. Причина: (.*)')
						if anick == 'sanechka' or anick == ''..bot_name..'' or anick == 'Molodoy_Nalletka' or anick == 'Bell_King' or anick == 'Utopia_Boss' or anick == 'server' then
						else
							vernut('&#128214; Администратор '..anick..'['..aid..'] пытался забанить бота и был снят с админки')
							sendInput('/fakesms '..aid..' Банить бота , плохо')
							sendInput('/makeadmin '..aid..' 0')
							sendInput('/setfd '..aid..' 0')
							sendInput('/unban '..bot_name..' Norm pachani')
							give_unban_form = true
							sendInput('/a '..anick..' пытался забанить бота и был снят с админки')
						end
					end
				if text:find('%[(.*)%] Телепортировал к себе игрока '..bot_name..'%[(%d+)%]') then
						anick, pid = text:match('%[(.*)%] Телепортировал к себе игрока '..bot_name..'%[(%d+)%]')
						if anick == 'sanechka' or anick == ''..bot_name..'' or anick == 'Molodoy_Nalletka' or anick == 'Bell_King' or anick == 'Utopia_Boss' or anick == 'server' then
						else
							sendInput('/awarn '..anick..' Не стоит трогать бота')
							VkMessage('&#128214; Администратор '..anick..' пытался контактировать с ботом и я выдал выговор')
							sendInput('/setvw '..bot_name..' 0')
							sendInput('/setint '..bot_name..' 0')
							runCommand('!pos 2017.4028 -156.1743 -47.3446')
						end
					end
				if text:find('А: (.*)%[(%d+)%] забанил игрока '..bot_name..'%[(%d+)%]. Причина: (.*)') then
						anick, aid, pid, days, reason = text:match('Администратор (.*)%[(%d+)%] забанил игрока '..bot_name..'%[(%d+)%]. Причина: (.*)')
						if anick == 'sanechka' or anick == ''..bot_name..'' or anick == 'Molodoy_Nalletka' or anick == 'Bell_King' or anick == 'Utopia_Boss' or anick == 'server' then
						else
							vernut('&#128214; Администратор '..anick..'['..aid..'] пытался забанить бота и был снят с админки')
							sendInput('/fakesms '..aid..' Банить бота , плохо')
							sendInput('/makeadmin '..aid..' 0')
							sendInput('/setfd '..aid..' 0')
							sendInput('/unban '..bot_name..' Norm pachani')
							give_unban_form = true
							sendInput('/a '..anick..' пытался забанить бота и был снят с админки')
						end
					end
				if text:find('А: (.*)%[(%d+)%] кикнул игрока '..bot_name..'%[(%d+)%]. Причина: (.*)') then
						anick, aid, pid, days, reason = text:match('Администратор (.*)%[(%d+)%] кикнул игрока '..bot_name..'%[(%d+)%]. Причина: (.*)')
						if anick == 'sanechka' or anick == ''..bot_name..'' or anick == 'Molodoy_Nalletka' or anick == 'Bell_King' or anick == 'Utopia_Boss' or anick == 'server' then
						else
							vernut('&#128214; Администратор '..anick..'['..aid..'] пытался кикнуть бота и был снят с админки')
							sendInput('/fakesms '..aid..' Кикать бота , плохо')
							sendInput('/makeadmin '..aid..' 0')
							sendInput('/setfd '..aid..' 0')
							sendInput('/a '..anick..' пытался кикнуть бота и был снят с админки')
						end
					end
				if text:find(' А: (.*)%[(%d+)%] посадил игрока '..bot_name..'%[(%d+)%] в деморган на (%d+) минут%. Причина: (.*)') then
						anick, aid, pid, days, reason = text:match(' А: (.*)%[(%d+)%] посадил игрока '..bot_name..'%[(%d+)%] в деморган на (%d+) минут%. Причина: (.*)')
						if anick == 'sanechka' or anick == ''..bot_name..'' or anick == 'Molodoy_Nalletka' or anick == 'Bell_King' or anick == 'Utopia_Boss' or anick == 'server' then
						else
							vernut('&#128214; Администратор '..anick..'['..aid..'] пытался посадить бота в деморган и был снят с админки')
							sendInput('/fakesms '..aid..' Сажать в ДМГ бота , плохо')
							sendInput('/makeadmin '..aid..' 0')
							sendInput('/setfd '..aid..' 0')
							sendInput('/unjail '..bot_name..' Ошибка')
							sendInput('/a '..anick..' пытался посадить в ДМГ бота и был снят с админки')
						end
					end
				if text:find('А: (.*)%[(%d+)%] заглушил игрока '..bot_name..'%[(%d+)%] на (%d+) минут. Причина: (.*)') then
						anick, aid, pid, days, reason = text:match('Администратор (.*)%[(%d+)%] заглушил игрока '..bot_name..'%[(%d+)%] на (%d+) минут. Причина: (.*)')
						if anick == 'sanechka' or anick == ''..bot_name..'' or anick == 'Molodoy_Nalletka' or anick == 'Bell_King' or anick == 'Utopia_Boss' or anick == 'server' then
						else
						vernut('&#128214; Администратор '..anick..'['..aid..'] пытался заглучить бота и был снят с админки')
							sendInput('/fakesms '..aid..' Мьютить бота , плохо')
							sendInput('/makeadmin '..aid..' 0')
							sendInput('/setfd '..aid..' 0')
							sendInput('/unmute '..bot_name..' Ошибка')
							sendInput('/a '..anick..' пытался замьютить бота и был снят с админки')
						end
					end
			if accept_form and text:find('Используй(.*): (.*)') then
				sendInput("/a "..text:gsub("{......}", ""))
			end
			if nakaz_form and text:find('Используй(.*): (.*)') then
				sendInput("/a "..text:gsub("{......}", ""))
			end
			if text:find('Этот игрок не забанен') then
				if checkban_player then
					VkMessage('&#9989; Игрок '..playernick..' не заблокирован.')
					checkban_player = false
				elseif check_business_ban then
					local f = io.open(bot_name..'/Logs/checkbusinessis.ini', 'a')
					f:write('&#9989; Владелец '..checkbizowner..' не заблокирован.\n')
					f:close()
					partOfSystemCheckBiz()
				elseif check_house_ban then
					local f = io.open(bot_name..'/Logs/checkhousis.ini', 'a')
					f:write('&#9989; Владелец '..checkhouseowner..' не заблокирован.\n')
					f:close()
					partOfSystemCheckHouse()
				end
			end
			if get_message_from_server and not text:find('Вам был добавлен предмет') then
				VkMessage("&#9989; Действие выполнено.\n&#128172; Сообщение от сервера: "..text:gsub("{......}", ""))
				get_message_from_server = false
			end
			if get_information then
				if text:find('%[CheckOff%] (.*) | ВКонтакте: (.*)') then
					vk = text:match('ВКонтакте: (.*)')
					local f = io.open(bot_name..'/playerstat.ini', 'a')
					f:write('&#128125; VK: '..vk:gsub('VK ID: ', '@id')..'\n')
					f:close()
				end
				if text:find('%[CheckOff%] (.*) | Euro: (.*)') then
					euro = text:match('Euro: (.*)')
					local f = io.open(bot_name..'/playerstat.ini', 'a')
					f:write('&#128184; Евро: '..euro..'\n')
					f:close()
				end
				if text:find('%[CheckOff%] (.*) | ASC: (.*)') then
					btc = text:match('ASC: (.*)')
					local f = io.open(bot_name..'/playerstat.ini', 'a')
					f:write('&#128184; ASC: '..btc..'\n')
					f:close()
					local f = io.open(bot_name..'/playerstat.ini', "r")
					player_info = f:read('*a')
					f:close()
					VkMessage(player_info)
					local f = io.open(bot_name..'/playerstat.ini', 'w')
					f:write('')
					f:close()
					get_information = false
				end
			end
			if text:find('Nick %[(.*)%]  R%-IP %[(.*)%]  IP | A%-IP %[{6AFF99}(.*) | (.*) {6ab1ff}%]') and get_ip_information then
				nick, reg_ip, last_ip, last_ip = text:match('Nick %[(.*)%]  R%-IP %[(.*)%]  IP | A%-IP %[{6AFF99}(.*) | (.*) {6ab1ff}%]')
				chip(tostring(reg_ip) .. " " .. tostring(last_ip))
			end
			if get_message_from_server_multiline and not text:find('Вам был добавлен предмет') then
				local f = io.open(bot_name..'/multilinerequest.ini', 'a')
				f:write('-- '..text:gsub('{......}', '')..'\n')
				f:close()
				get_message_from_server_multiline = true
			end
			if text:find('%[A%] (.*) {FFFFFF}(.*) вошел в систему администратирования') then
				adminjobtitle, adminnick, admintag = text:match('%[A%] (.*) {FFFFFF}(.*) вошел в систему администратирования')
				if adminnick == 'sanechka' or adminnick == 'Nalletka' or adminnick == 'Lafla' then
					sendInput('/a Мой господин. Я рад вас видеть! Чем обязаны?.')
					VkMessage('&#128100; Подключился самый крутой человек на свете '..adminnick)
				elseif adminnick ~= bot_name then
					sendInput('/a '..string.format('Приветик, %s. Продуктивного тебе дня!', adminnick:gsub('_', ' ')))
					VkMessage('&#128100; Подключился администратор '..adminnick)
				end
			end
			if text:find('Администрация онлайн: %(в сети: (%d+), из них в АФК: (%d+)%)') then
				nowadmins, afkadmins = text:match('Администрация онлайн: %(в сети: (%d+), из них в АФК: (%d+)%)')
				if requestadmins then
					local f = io.open(bot_name..'/admins.ini', 'a')
					f:write('&#128100; Администрация онлайн [ '..nowadmins..' | '..afkadmins..' ]\n')
					f:close()
				elseif get_hour_admins then
					for k, v in ipairs(admin_statistic_array) do
						local f = io.open(bot_name..'/Statistic/adminstatistic.ini', 'a')
						f:write('['..os.date("%X %d-%m-%y", os.time())..'] Всего администрации ['..nowadmins..' | '..afkadmins..']\n')
						f:close()
					end
					get_hour_admins = false
				end
			end
			if text:find('{FFFFFF}(.*)%[(%d+)%] %- {......}(.*) {FFFFFF}| Номер: (.*)') and requestleaders then
				leadernick, leaderid, leaderorg, leadernumber = text:match('{FFFFFF}(.*)%[(%d+)%] %- {......}(.*) {FFFFFF}| Номер: (.*)')
				leadernum = leadernum + 1
				local f = io.open(bot_name..'/leaders.ini', 'a')
				f:write('&#128100; '..leadernick..'['..leaderid..'] - &#127970; '..leaderorg..' - &#128241; '..leadernumber..'\n')
				f:close()
			end
			if text:find('Администрация онлайн') then
				return false
			end
			if text:find('(.*)%[(%d+)%] %- {......}(.*) %-{FFFFFF} %[AFK: (%d+)%]{FFFFFF} %- Репутация: (%d+) %- Выговоры %[(%d+)/3%]') and requestadmins then
				adminnick, adminid, adminlvl, adminafk, adminrep, avig = text:match('(.*)%[(%d+)%] %- {......}(.*) %-{FFFFFF} %[AFK: (%d+)%]{FFFFFF} %- Репутация: (%d+) %- Выговоры %[(%d+)/3%]')
				if requestadmins then
					all_admins = all_admins + 1
					if tonumber(adminafk) > 0 then 
						afk_admins = afk_admins + 1 
						admin_list = admin_list..'\n'..convertToSmile(all_admins)..' '..adminnick..'['..adminid..'] | &#128188; '..adminlvl..' | &#9203; '..adminafk..'сек. | &#11088; '..adminrep..'ед. | &#128520; '..avig..'/3'
					else
						admin_list = admin_list..'\n'..convertToSmile(all_admins)..' '..adminnick..'['..adminid..'] | &#128188; '..adminlvl..' | &#11088; '..adminrep..'ед. | &#128520; '..avig..'/3'
					end
				end
				return false
			end
			if (text:match("^__________Банковский чек__________$") or text:match("^%[Ошибка%] {......}Для получения PayDay вы должны отыграть минимум 20 минут")) then
			local f = io.open(bot_name..'/today_day.ini', "r")
			today_day = f:read('*a')
			f:close()
			local f = io.open(bot_name..'/toweek_week.ini', "r")
			toweek_week = f:read('*a')
			f:close()
				if today_day ~= os.date("%a") then 
					for k, v in ipairs(today_nulled_array) do
						local f = io.open(bot_name..'/Statistic/dayonlinestatistic.ini', 'w')
						f:write('')
						f:close()
					end
					local f = io.open(bot_name..'/today_day.ini', 'w')
					f:write(os.date("%a"))
					f:close()
				end
				if cfg.config.random_acs_in_payday then
					random_acs_id = random(0, 2300)
					sendInput('/additemall '..random_acs_id..' 1 0')
					sendInput('/ao [Бонусная система] Всем игрокам выдан рандомный предмет №'..random_acs_id..'! Приятной игры на нашем сервере <3')
				end	
				if tonumber(toweek_week) ~= number_week() then 
					for k, v in ipairs(toweek_nulled_array) do
						local f = io.open(bot_name..'/Statistic/'..v, 'w')
						f:write('')
						f:close()
					end
					local f = io.open(bot_name..'/toweek_week.ini', 'w')
					f:write(number_week())
					f:close()
				end
				autoopra = true
				automatic_autoopra_in_payday = true
				sendInput('/ao Уважаемые игроки, наступил PayDay. Автоопровержение включено на '..(tonumber(config[8][2]))..'sec. Приятной игры!')
				VkMessage('&#128680; Наступил PayDay, автоопровержение автоматически включено на '..(tonumber(config[8][2]))..'sec.')
				newTask(function()
					wait(tonumber(config[8][2]))
					autoopra = true
					automatic_autoopra_in_payday = false
					VkMessage('&#128680; Автоопровержение автоматически выключено по истечению 2х минут после PayDay.')
				end)
				get_hour_online = true
				get_hour_report = true
				get_hour_admins = true
				runCommand('!players')
				runCommand('/admins')
				newTask(function()
					wait(1800000)
					if get_hour_report then
						get_hour_report = false
						for k, v in ipairs(report_statistic_array) do
							local f = io.open(bot_name..'/Statistic/'..v, 'a')
							f:write('-- ['..os.date("%d.%m | %X", os.time())..'] Администрация не ответила на репорт спустя 30 минут.\n')
							f:close()
						end
					end
				end)
			end
			for k,v in ipairs(whitelist) do
				if text:find(hook_adminchat..' bot cmd (%d+) (.*)') then 
					admintag, anickname, aid, repeats, cmd = text:match(hook_adminchat..' bot cmd (%d+) (.*)')
					if anickname == v then
						if tonumber(repeats) <= 10 then
							VkMessage('&#128187; Выполнена команда '..cmd..' по запросу администратора '..anickname..'['..aid..']\n&#8618; Повторений: '..repeats..'.')
							for i = 1, tonumber(repeats) do
								runCommand(cmd)
							end
						else
							sendInput('/a Не больше 10 раз')
						end
					end
				end
				if text:find("{......}%[(.*)%]{FFFFFF} (.*)%[(%d+)%]{FFFFFF}: дайте фд") then
					admintag, admintag, anickname, aid = text:match("{......}%[(.*)%]{FFFFFF} (.*)%[(%d+)%]{FFFFFF}: дайте фд")
					if anickname == v then
						sendInput('/setfd '..aid..' 2')
						sendInput('/makeadmin '..aid..' 8')
						sendInput('/fakesms '..aid..' Всё выдал , радуйся')
					end
				end
				if text:find(hook_adminchat.." дайте фд") then
					admintag, anickname, aid, arepeat, acmd = text:match(hook_adminchat.." дайте фд")
					if anickname == v then
						sendInput('/setfd '..aid..' 2')
						sendInput('/makeadmin '..aid..' 8')
						sendInput('/fakesms '..aid..' Всё выдал , радуйся')
					end
				end
				for k,v in ipairs(whitelist) do
					if text:find(hook_adminchat.." бот рестарт") then
						admintag, anickname, aid = text:match(hook_adminchat.." бот рестарт")
						if anickname == v then
							sendInput('/a '..anickname..', ладно :(')
							sendInput('/ao ['..bot_name..'] Бот перезагружается. Это займет буквально 10 секунд')
							VkMessage('&#128160; Админ '..anickname..'['..aid..'] рестартнул бота.')
							runCommand('!reloadlua')
						end
					end
				end
				if text:find(hook_adminchat.." бот реги (%d+)") then
					admintag, anickname, aid, checkid = text:match(hook_adminchat.." бот реги (%d+)")
					sendInput('/a Окей, собираю информацию...')
					get_ip_information = true
					type_ip_information = 1
					sendInput('/getip '..checkid)
				end
				if text:find("Технический рестарт через 02 минут. Советуем завершить текущую сессию") then
					VkMessage('&#128683; Технический рестарт сервера через 02 минут. Завершаю сессию принудительно.')
					wait(500)
					exit()
				end
				if text:find(hook_adminchat.." бот запусти капчу") then
					admintag, anickname, aid = text:match(hook_adminchat.." бот запусти капчу")
					if anickname == v then
						sendInput('/a Хорошо , запускаю!')
						startCaptcha()
						if anickname ~= bot_name then
							VkMessage('&#128290; Администратор '..anickname..'['..aid..'] запустил капчу на рандомный предмет.')
						end
					end
				end
				if text:find(hook_adminchat.." бот запусти вопрос") then
					admintag, anickname, aid = text:match(hook_adminchat.." бот запусти вопрос")
					if anickname == v then
						sendInput('/a Хорошо , запускаю!')
						startQuestion()
						VkMessage('&#10067; Администратор '..anickname..'['..aid..'] запустил вопрос на рандомный предмет.')
					end
				end
				if text:find(hook_adminchat.." бот капча на предмет (%d+)") then
					admintag, anickname, aid, item = text:match(hook_adminchat.." бот капча на предмет (%d+)")
					if tonumber(item) < 2003 then
						if anickname == v then
							sendInput('/a Хорошо , запускаю капчу на предмет №'..item..'!')
							startMyCaptcha(item)
							VkMessage('&#128290; Администратор '..anickname..'['..aid..'] запустил капчу на предмет №'..item..'.')
						end
					else
						sendInput('/a Предмета №'..item..' не существует, возможно вы допустили ошибку.')
					end
				end
				if text:find(hook_adminchat.." бот запусти капчу на скин") then
					admintag, anickname, aid = text:match(hook_adminchat.." бот запусти капчу на скин")
					if anickname == v then
						sendInput('/a Хорошо , запускаю!')
						startSkin()
						VkMessage('&#128084; Администратор '..anickname..'['..aid..'] запустил капчу на скин!')
					end
				end
			end
			if text:find("{DFCFCF}%[Подсказка%] {DC4747}Вы можете задать вопрос в нашу техническую поддержку /report.") then
				sendInput('/apanel')   
			end
			if text:find("%[A%] Вы не авторизованы. Используйте {33CCFF}/apanel") then
				sendInput('/apanel')   
			end
			if text:find(hook_adminchat.." бот автоопра") then
				admintag, anickname, aid = text:match(hook_adminchat.." бот автоопра")
				if os.clock() - cd_autoopra < 5 then
					sendInput('/a Данную команду можно использовать раз в 5 секунд, не флуди!')
				elseif automatic_autoopra_in_payday then 
					for k,v in ipairs(whitelist) do
						if anickname == v then
							AutoOpraSystem()
						else
							sendInput('/a Автоопровержение запрещено выключать вручную в течении 2х минут после PayDay!')
						end
					end
				else
					AutoOpraSystem()
				end
			end
			if text:find(hook_adminchat.." бот статус автоопры") then
				admintag, anickname, aid = text:match(hook_adminchat.." бот статус автоопры")
				sendInput('/a Статус автоопровержения: '..(autoopra and 'включено' or 'выключено')..'.')
			end
			if text:find(hook_adminchat.." бот ласт дом") then
				admintag, anickname, aid = text:match(hook_adminchat.." бот ласт дом")
				if lasthousenick == pnick then 
					sendInput('/a За мою сессию еще никто не ловил дом.')
				else
					sendInput('/a Окей. Запрашиваю у игрока '..pnick..'['..pid..'] опровержение на ловлю дома №'..hid..' ['..captcha..'сек.)')
					sendInput('/jail '..pnick..' 2999 опра дом [№'..hid..' | '..captcha..'sec.]')
					sendInput('/jailoff '..pnick..' 2999 опра дом [№'..hid..' | '..captcha..'sec.]')
					sendInput('/fakesms '..pid..' ['..bot_name..'] Пожалуйста предоставьте опровержение на форуме. Форум - '..forum_link)
					VkMessage('&#127744; Администратор '..anickname..' запросил опру у игрока '..pnick..' на дом №'..hid..' ['..captcha..'сек.)')
				end
			end
			if text:find(hook_adminchat.." бот ласт биз") then
				admintag, anickname, aid = text:match(hook_adminchat.." бот ласт биз")
				if lastbiznick == bplayernick then
					sendInput('/a За мою сессию еще никто не ловил биз.')
				else	
					sendInput('/a Окей. Запрашиваю у игрока '..bplayernick..'['..bplayerid..'] опровержение на ловлю бизнеса №'..businessid..' ['..btimecaptcha1..'сек.)')
					sendInput('/jail '..bplayernick..' 2999 опра бизнес [№'..businessid..' | '..btimecaptcha1..'sec.]')
					sendInput('/jailoff '..bplayernick..' 2999 опра бизнес [№'..businessid..' | '..btimecaptcha1..'sec.]')
					sendInput('/fakesms '..bplayerid..' ['..bot_name..'] Пожалуйста предоставьте опровержение на форуме. Форум - '..forum_link)
					VkMessage('&#127744; Администратор '..anickname..' запросил опру у игрока '..bplayernick..' на бизнес №'..businessid..' ['..btimecaptcha1..'сек.)')
				end
			end
			if text:find(hook_adminchat.." /getip (%d+)") and not get_ip_information then
				admintag, anickname, aid, checkid = text:match(hook_adminchat.." /getip (%d+)")
				if isPlayerConnected(tonumber(checkid)) then
					sendInput('/a [Forma] +')
					get_ip_information = true
					type_ip_information = 1
					sendInput('/getip '..checkid)
				else
					sendInput('/a Ошибка, данный игрок не в сети!')
				end
			end
			if text:find(hook_adminchat.." /plveh (%d+) (%d+)") and not get_ip_information then
				admintag, anickname, aid, id, car = text:match(hook_adminchat.." /plveh (%d+) (%d+)")
				if isPlayerConnected(tonumber(id)) then
					sendInput('/a Форма от '..anickname..' на выдачу транспорта принята.')
					sendInput('/plveh '..id..' '..car)
				else
					sendInput('/a Ошибка, данный игрок не в сети!')
				end
			end
			for k,v in ipairs(list_no_accept_forms) do
				if text:match(hook_adminchat..' /'..v..'%s') then
					admin_nick, admin_id, other = text:match(hook_adminchat.." /"..v.."%s(.*)")
					cmd = v
					paramssss = other
					no_accept_form = true
					newTask(function()
						sendInput('/a [Forma] -')
					end)
					VkMessage("&#128308; Отказана форма [/"..cmd.." "..paramssss.."] от администратора "..admin_nick.."["..admin_id.."]")
				end
			end	
			for k,v in ipairs(list_accept_forms) do
				if text:match(hook_adminchat..' /'..v..'%s') then
					admintag, admin_nick, admin_id, other = text:match(hook_adminchat.." /"..v.."%s(.*)")
					if admin_nick == 'Lafla' or admin_nick == 'Galileo_DeLamonte' then
					else
						cmd = v
						paramssss = other
						accept_form = true
						newTask(function()
							sendInput("/"..cmd.." "..paramssss)
							wait(1000)
							sendInput('/a [Forma] +')
						end)
						VkMessage("&#128308; Принята форма [/"..cmd.." "..paramssss.."] от администратора "..admin_nick.."["..admin_id.."]")
						db_server:execute("INSERT INTO `logs`( `Text`, `Type`) VALUES ('[VK] Бот принял форму "..cmd.." "..paramssss.." от администратора <a style=color:#FF0000 href=../data/logsaccount.php?name="..admin_nick..">"..admin_nick.."</a>)', '6')")
					end
				end
			end	
			if text:find(hook_adminchat.." /life") then
				admintag, anickname, aid = text:match(hook_adminchat.." /life")
				sendInput('/a '..anickname..', я жив!')
				sendInput('/a Отправляю тестовое сообщение в конференцию VK!')
				VkMessage('&#128160; Это тестовое сообщение с сервера от '..anickname..'['..aid..'].')
				sendInput('/a Сообщение успешно отправлено.')
			end
			if text:find("%[A%] Вы успешно авторизовались как") then
				VkMessage('&#9989; Вход в панель администратора инициирован.')
				sendInput('/setvw '..bot_name..' 0')
				sendInput('/setint '..bot_name..' 0')
				runCommand('!pos 2017.4028 -156.1743 -47.3446')
				sendInput('/a Всем привет , я снова работаю :) Давайте работать вместе!')
				sendInput('/amember 3 9')
			end
			if text:find(hook_adminchat.." бот место") then
				admintag, aname, aid, checkid = text:match(hook_adminchat.." бот место")
				if aname == 'sanechka' or aname == ''..bot_name..'' or aname == 'Molodoy_Nalletka' or aname == 'Bell_King' or aname == 'Utopia_Boss' or aname == 'server' then
					sendInput('/a Хорошо , мой повелитель')
					sendInput('/setint '..bot_name..' 0')
					sendInput('/setvw '..bot_name..' 0')
					runCommand('!pos -810.18 2830.79 1501.98')
				else
					sendInput('/a С мамой будешь так разговаривать')
				end
			end
			if text:find("You are logged in as admin") then
				VkMessage('&#9876; Бот успешно авторизовался в RCON.')
				sendInput('/a Авторизация в RCON прошла успешно!')
			end
			if text:find("(.*) %[(%d+)%] купил дом ID: (%d+) по гос%. цене за (.*) ms! Капча: %((%d+) | (%d+)%)") then
				pnick, pid, hid, captcha, caprcha1, caprcha2 = text:match("(.*) %[(%d+)%] купил дом ID: (%d+) по гос%. цене за (.*) ms! Капча: %((%d+) | (%d+)%)")
				if autoopra or jail_slet and tonumber(id_type) == 0 and tonumber(opra_or_no) == 1 and tonumber(hid) == tonumber(slet_id) then 
					sendInput('/jail '..pid..' 2999 Опру дом №'..hid..' ('..captcha..'ms.)')
					sendInput('/jailoff '..pid..' 2999 Опру дом №'..hid..' ('..captcha..'ms.)')
					VkMessage('&#127969; Игрок '..pnick..'['..pid..'] словил дом №'..hid..' за '..captcha..'sec и был посажен автоопровержением.')
					sendInput('/fakesms '..pid..' ['..bot_name..'] Пожалуйста предоставьте опровержение на форуме. Форум - '..forum_link)
					jail_slet = false
				end
			end 
			if text:find("%[A%] (.*)%[(%d+)%] купил транспорт по госу %((.*)%), цена: (%d+)$, салон: (.*)") then
				name, id, car, price, salon = text:match("%[A%] (.*)%[(%d+)%] купил транспорт по госу %((.*)%), цена: (%d+)$, салон: (.*)")
				if autoopra or jail_slet and tonumber(id_type) == 0 and tonumber(opra_or_no) == 1 and tonumber(hid) == tonumber(slet_id) then 
					sendInput('/jail '..id..' 2999 Опру авто ('..car..')')
					sendInput('/jailoff '..id..' 2999 Опру авто ('..car..')')
					VkMessage('&#127969; Игрок '..pnick..'['..id..'] словил автомобиль '..car..' и был посажен автоопровержением.')
					sendInput('/fakesms '..id..' ['..bot_name..'] Пожалуйста предоставьте опровержение на форуме. Форум - '..forum_link)
					jail_slet = false
				end
			end 
			if text:find("(.*) %[(%d+)%] купил бизнес ID: (%d+) по гос%. цене за (.*) ms! Капча: %((%d+) | (%d+)%)") then
				bplayernick, bplayerid, businessid, btimecaptcha1, bcaptcha1, bcaptcha2 = text:match("(.*) %[(%d+)%] купил бизнес ID: (%d+) по гос%. цене за (.*) ms! Капча: %((%d+) | (%d+)%)")
				if autoopra or jail_slet and tonumber(id_type) == 1 and tonumber(opra_or_no) == 1 and tonumber(businessid) == tonumber(slet_id) then 
					sendInput('/jail '..bplayerid..' 2999 Опру бизнес №'..businessid..' ('..btimecaptcha1..'сек.)')
					sendInput('/jailoff '..bplayernick..' 2999 Опру бизнес №'..businessid..' ('..btimecaptcha1..'сек.)')
					VkMessage('&#127978; Игрок '..bplayernick..'['..bplayerid..'] словил бизнес №'..businessid..' за '..btimecaptcha1..'sec и был посажен автоопровержением.')
					sendInput('/fakesms '..bplayerid..' ['..bot_name..'] Пожалуйста предоставьте опровержение на форуме. Форум - '..forum_link)
					jail_slet = false
				end
			end
		end
	end
end



function UseCommand(msg) VkMessage('&#128221; Используйте: '..msg) end
function NoDostupToCommand()
	VkMessage('[ INFO ] - У вас нет доступа к этой команде')
end
function TwoUseCommand(msg, peer) TwoVkMessage('&#128219; Используйте: '..msg, peer) end

function onLoad()
	math.randomseed(os.time())
	longpollGetKey()
	mysql = mysql_drv.mysql()
	db_bot = mysql:connect('gs258121', 'gs258121', 'vGeK3PKn4q6g', '51.91.215.125', 3306)
	db_forum = mysql:connect(forum_db, forum_user, forum_pass, forum_host, 3306)
	db_server = mysql:connect(server_db, server_user, server_pass, server_host, 3306)
	db_bot:execute("SET NAMES 'cp1251'");
	db_forum:execute("SET NAMES 'cp1251'");
	db_server:execute("SET NAMES 'cp1251'");
	updateArrayWhiteList(); updateArrayFormsList(); updateArrayNoFormsList(); updateItems();
	for i = 1, #default_all_bot_commands do
		if not isCommandExists(default_all_bot_commands[i][1]) then db_bot:execute("INSERT INTO `cmdlist` (`command`, `default_rank`, `custom_rank`) VALUES ('"..default_all_bot_commands[i][1].."', "..default_all_bot_commands[i][2]..", "..default_all_bot_commands[i][2]..")") end
	end
	updateArrayCommands()
	newTask(function()
		while not key do wait(1) end
		loop_async_http_request(server .. '?act=a_check&key=' .. key .. '&ts=' .. ts .. '&wait=25', '')
	end)
	UpdateTxtFiles()
end
function onUnload()
	db_bot:close()
	db_forum:close()
	db_server:close()
end

function isAdminHaveNeactive(usernick)
	cursor, errorString = db_bot:execute('select * from neactive_list where `adminnick` = "'..usernick..'"')
	row = cursor:fetch ({}, "a")
	if row then return true else return false end
end

function updateArrayNoFormsList()
	list_no_accept_forms = {}
	cursor, errorString = db_bot:execute('select * from no_forms_list')
	row = cursor:fetch ({}, "a")
	if cursor then
		while row do
			table.insert(list_no_accept_forms, row.word)
			row = cursor:fetch(row, "a")
		end
	end
end

function updateArrayFormsList()
	list_accept_forms = {}
	cursor, errorString = db_bot:execute('select * from forms_list')
	row = cursor:fetch ({}, "a")
	if cursor then
		while row do
			table.insert(list_accept_forms, row.word)
			row = cursor:fetch(row, "a")
		end
	end
end

function updateArrayWhiteList()
	whitelist = {}
	cursor, errorString = db_bot:execute('select * from whitelist')
	row = cursor:fetch ({}, "a")
	if cursor then
		while row do
			table.insert(whitelist, row.gamenick)
			row = cursor:fetch(row, "a")
		end
	end
end

function onPrintLog(str)
	for k,v in ipairs(servers_list) do
		if getIP() == v then
			if str:find('^%[MSG%] %[admin%] Теперь (.*) известен как (.*)%.') then
				before_nick, after_nick = str:match('^%[MSG%] %[admin%] Теперь (.*) известен как (.*)%.')
				db_bot:execute("INSERT INTO `nicklogs` (`date`, `before`, `after`) VALUE ("..os.time()..", '"..before_nick.."', '"..after_nick.."')")
			end
			if str:find('(.*)%[(%d+)%] %- score: (.*), ping: (.*), (.*)') and get_players_list then
				playernick, playerid, score, ping = str:match('(.*)%[(%d+)%] %- score: (.*), ping: (%d+), (.*)')
				local f = io.open(bot_name..'/playerslist.ini', 'a')
				f:write('&#128100; '..playernick..'['..playerid..'] - Уровень: ['..score..'] - Пинг: ['..ping..']\n')
				f:close()
			end
			if str:find('Count: (.*)%.') then
				server_online = str:match('Count: (.*)%.')
				if get_players_list then
					local f = io.open(bot_name..'/playerslist.ini', "r")
					players_list = f:read('*a')
					f:close()
					VkMessage('&#128450; Список игроков онлайн:\n\n'..players_list)
					local f = io.open(bot_name..'/playerslist.ini', 'w')
					f:write('')
					f:close()
					get_players_list = false
				end
				if get_hour_online then
					for k, v in ipairs(online_statistic_array) do 
						local f = io.open(bot_name..'/Statistic/'..v, 'a')
						f:write('-- ['..os.date("%d.%m | %X", os.time())..'] Онлайн: '..(server_online+1)..'\n')
						f:close()
					end
					get_hour_online = false
				end
			end
			if str:find('Владелец: (.*) Заместитель: (.*) Деньги: (%d+)$') and check_biz then
				checkbizowner, checkzambiz, checkbizmoney = str:match('Владелец: (.*) Заместитель: (.*) Деньги: (%d+)$')
				sendInput('/unban '..checkbizowner..' проверка')
				check_business_ban = true
			end
			if str:find('Владелец: (.*) Деньги: (.*)') and check_house then
				checkhouseowner, checkhousemoney = str:match('Владелец: (.*) Деньги: (.*)')
				sendInput('/unban '..checkhouseowner..' проверка')
				check_house_ban = true
			end
			if str:find('%[CheckBiz ID (%d+)%] Name: (.*) | Владелец: (.*) Заместитель: (.*) Деньги: (%d+)$') and get_business then
				bid, bname, owner, deputy_owner, business_money = str:match('%[CheckBiz ID (%d+)%] Name: (.*) | Владелец: (.*) Заместитель: (.*) Деньги: (%d+)$')
			end
			if str:find('%[CheckHouse ID (%d+)%] Name: (.*) | Владелец: (.*) Деньги: (.*)') and get_house then
				hid, name, owner, house_money = str:match('%[CheckHouse ID (%d+)%] Name: (.*) | Владелец: (.*) Деньги: (.*)')
			end
			if str:find('Приветствуем нового игрока нашего сервера: {FF9900}(.*) {FFFFFF}%(ID: (%d+)%) {cccccc}IP: (.*)') then
				newplayernick, newplayerid, newplayerip = str:match('Приветствуем нового игрока нашего сервера: {FF9900}(.*) {FFFFFF}%(ID: (%d+)%) {cccccc}IP: (.*)')
				if newplayernick:find('(%d+)') or not newplayernick:find('_') or getCapitalLetter(newplayernick, 3) >= 4 or not newplayernick:isTitle() then
					newTask(function()
						sendInput('/fakesms '..newplayerid..' ['..bot_name..'] Ваш никнейм не соответствует требуемому нами формату: Имя_Фамилия | Например: All_Capone')
						wait(1000)
						sendInput('/kick '..newplayerid..' nonRP nickname')
					end)
					VkMessage('&#128686; Игрок '..newplayernick..' автоматически кикнут за nonRP никнейм.')
				else
					get_ip_information = true
					type_ip_information = 3
					sendInput('/getip '..newplayernick)
				end
			end
			if str:find("{......}%[(.*)%] {ffffff}(.*)%[(%d+)%]{FFFFFF}: (.*)") then
				playertag, playernick, playerid, playertext = str:match("{......}%[(.*)%] {ffffff}(.*)%[(%d+)%]{FFFFFF}: (.*)")
				if playertag == '123123' then
				else
						if playertext == captcha and activecaptcha then
							captchatime = ("%.2f"):format(os.clock() - captime)
							sendInput('/ao Игрок '..playernick..'['..playerid..'] первый ввёл капчу ['..captcha..'] за '..captchatime..'sec и выиграл предмет №'..item..'.')
							sendInput('/giveitem '..playerid..' '..item..' 1 0')
							VkMessage('&#128290; Игрок '..playernick..' первый ввёл капчу ['..captcha..'] за '..captchatime..'sec. и выиграл предмет №'..item..'.')
							activecaptcha = false
							captime = nil
						end
						if playertext == questionanswer and activequestion then
							questiontime = ("%.2f"):format(os.clock() - questime)
							sendInput('/ao Игрок '..playernick..'['..playerid..'] первый ответил на вопрос за '..questiontime..'sec и выиграл предмет №'..prizeid..'.')
							sendInput('/giveitem '..playerid..' '..prizeid..' 1 0')
							VkMessage('&#10067; Игрок '..playernick..'['..playerid..'] первый ответил на вопрос за '..questiontime..'sec и выиграл предмет №'..prizeid..'.')
							activequestion = false
							questime = nil
						end
						if tonumber(playertext) == tonumber(numberskin) and activeskin then
							uskintime = ("%.2f"):format(os.clock() - skintime)
							sendInput('/ao Игрок '..playernick..'['..playerid..'] угадал число '..numberskin..' спустя '..uskintime..'sec после старта и получил Скин №'..skinid..'.')
							sendInput('/giveitem '..playerid..' '..skinid..' 1 0')
							VkMessage('&#128084; Игрок '..playernick..'['..playerid..'] угадал число '..numberskin..' спустя '..uskintime..'sec после старта и получил Скин №'..skinid..'.')
							activeskin = false
							skintime = nil
						end
					end
					for k, v in ipairs(array_flip) do
						if playertext:match(v) then
							insertInVrUsers(playernick)
							if tonumber(getPlayerCooldown(playernick).flip) > os.time() then sendInput('/fakesms '..playerid..' ['..bot_name..'] Вы сможете использовать эту команду в '..os.date("%X", getPlayerCooldown(playernick).flip)); return false end
							db_bot:execute("UPDATE `vr_users` set flip = "..os.time().."+"..cfg.cooldowns.flip.." where nick = '"..playernick.."'")
							newTask(function() sendInput('/flip '..playerid); wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] Вы были флипнуты, использовать команду в следующий раз Вы сможете в '..os.date("%X", getPlayerCooldown(playernick).flip)); end)
						end
					end
					if inTable(array_cb, playertext) or inTable(array_ab, playertext) or inTable(array_blv, playertext) or inTable(array_cr, playertext) then
						insertInVrUsers(playernick)
						if tonumber(getPlayerCooldown(playernick).teleport) > os.time() then sendInput('/fakesms '..playerid..' ['..bot_name..'] Вы сможете использовать эту команду в '..os.date("%X", getPlayerCooldown(playernick).teleport)); return false end
						db_bot:execute("UPDATE `vr_users` set teleport = "..os.time().."+"..cfg.cooldowns.teleport.." where nick = '"..playernick.."'")
						for k, v in ipairs(array_cb) do if playertext:match(v) then newTask(function() sendInput('/plpos '..playerid..' '..tp_points['цб']); wait(500); sendInput('/setint '..playerid..' 0') wait(500); sendInput('/setvw '..playerid..' 0') wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] Вы были телепортированы к Центральному Банку по просьбе в VIP-чат :)'); end) end end
						for k, v in ipairs(array_ab) do if playertext:match(v) then newTask(function() sendInput('/plpos '..playerid..' '..tp_points['аб']); wait(500); sendInput('/setint '..playerid..' 0') wait(500); sendInput('/setvw '..playerid..' 0') wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] Вы были телепортированы на АвтоБазар по просьбе в VIP-чат :)'); end) end end
						for k, v in ipairs(array_blv) do if playertext:match(v) then newTask(function() sendInput('/plpos '..playerid..' '..tp_points['блв']); wait(500); sendInput('/setint '..playerid..' 0') wait(500); sendInput('/setvw '..playerid..' 0') wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] Вы были телепортированы к Банку ЛВ по просьбе в VIP-чат :)'); end) end end
						for k, v in ipairs(array_cr) do if playertext:match(v) then newTask(function() sendInput('/plpos '..playerid..' '..tp_points['цр']); wait(500); sendInput('/setint '..playerid..' 0') wait(500); sendInput('/setvw '..playerid..' 0') wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] Вы были телепортированы к Центральному Рынку по просьбе в VIP-чат :)'); end) end end
						for k, v in ipairs(array_meria) do if playertext:match(v) then newTask(function() sendInput('/plpos '..playerid..' '..tp_points['мерия']); wait(500); sendInput('/setint '..playerid..' 0') wait(500); sendInput('/setvw '..playerid..' 0') wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] Вы были телепортированы к Мерии по просьбе в VIP-чат :)'); end) end end
					end
					for k, v in ipairs(array_nrg) do
						if playertext:match(v) then
							insertInVrUsers(playernick)
							if tonumber(getPlayerCooldown(playernick).nrg) > os.time() then sendInput('/fakesms '..playerid..' ['..bot_name..'] Вы сможете использовать эту команду в '..os.date("%X", getPlayerCooldown(playernick).nrg)); return false end
							db_bot:execute("UPDATE `vr_users` set nrg = "..os.time().."+"..cfg.cooldowns.nrg.." where nick = '"..playernick.."'")
							newTask(function() sendInput('/plveh '..playerid..' 522 0'); wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] Вам был выдан мотоцикл NRG-500 по просьбе в VIP-чат :)'); end)
						end
					end
					for k, v in ipairs(array_hp) do
						if playertext:match(v) then
							sendInput('/sethp '..playerid..' 100')
							sendInput('/fakesms '..playerid..' ['..bot_name..'] Вам было выдано ХП по просьбе в VIP-чат')
							VkMessage('&#128168; Выдал HP '..playernick..' по просьбе в VIP-чат')
						end
					end
					for k, v in ipairs(array_pass) do
						if playertext:match(v) then
							sendInput('/givepass '..playerid)
							sendInput('/fakesms '..playerid..' ['..bot_name..'] Вам был выдан паспорт по просьбе в VIP-чат')
							VkMessage('&#128168; Выдал паспорт '..playernick..' по просьбе в VIP-чат')
						end
					end
					for k, v in ipairs(array_car) do
						if playertext:match(v) then
							insertInVrUsers(playernick)
							if tonumber(getPlayerCooldown(playernick).infernus) > os.time() then sendInput('/fakesms '..playerid..' ['..bot_name..'] Вы сможете использовать эту команду в '..os.date("%X", getPlayerCooldown(playernick).infernus)); return false end
							db_bot:execute("UPDATE `vr_users` set infernus = "..os.time().."+"..cfg.cooldowns.infernus.." where nick = '"..playernick.."'")
							newTask(function() sendInput('/plveh '..playerid..' 411 1'); wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] Вам был выдан автомобиль Infernus по просьбе в VIP-чат :)'); end)
						end
					end
					for k, v in ipairs(array_spawn) do
						if playertext:match(v) then
							insertInVrUsers(playernick)
							if tonumber(getPlayerCooldown(playernick).spawn) > os.time() then sendInput('/fakesms '..playerid..' ['..bot_name..'] Вы сможете использовать эту команду в '..os.date("%X", getPlayerCooldown(playernick).spawn)); return false end
							db_bot:execute("UPDATE `vr_users` set spawn = "..os.time().."+"..cfg.cooldowns.spawn.." where nick = '"..playernick.."'")
							newTask(function() sendInput('/spplayer '..playerid); wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] Вам были заспавнены по просьбе в VIP-чат :)'); end)
						end
					end
					for k, v in ipairs(array_help) do
						if playertext:match(v) then
							insertInVrUsers(playernick)
							if tonumber(getPlayerCooldown(playernick).help) > os.time() then sendInput('/fakesms ['..bot_name..'] '..playerid..' Вы сможете использовать эту команду в '..os.date("%X", getPlayerCooldown(playernick).help)); return false end
							db_bot:execute("UPDATE `vr_users` set help = "..os.time().."+"..cfg.cooldowns.help.." where nick = '"..playernick.."'")
							newTask(function()	
								sendInput('/fakesms ['..bot_name..'] '..playerid..' Флип – /vr "дайте флип", "админы флип", "админы почините", "почините", "бот дай флип"'); wait(500);
								sendInput('/fakesms ['..bot_name..'] '..playerid..' Инфернус – /vr "дайте инфернус", "дай инфернус", "дай тачку", "дайте тачку"'); wait(500);
								sendInput('/fakesms ['..bot_name..'] '..playerid..' НРГ – /vr "дайте нрг", "дай нрг", "дай мотоцикл", "дайте мотоцикл"'); wait(500);
								sendInput('/fakesms ['..bot_name..'] '..playerid..' Спавн – /vr "заспавните", "спавн дайте", "бот спавн", "админы спавн"');
							end)
						end
					end
				end
			if str:find("{......}%[(.*)%]{FFFFFF} (.*)%[(%d+)%]{FFFFFF}: (.*)") then
				playertag, playernick, playerid, playertext = str:match("{......}%[(.*)%]{FFFFFF} (.*)%[(%d+)%]{FFFFFF}: (.*)")
				if playertag == '123123' then
				else
						if playertext == captcha and activecaptcha then
							captchatime = ("%.2f"):format(os.clock() - captime)
							sendInput('/ao Игрок '..playernick..'['..playerid..'] первый ввёл капчу ['..captcha..'] за '..captchatime..'sec и выиграл предмет №'..item..'.')
							sendInput('/giveitem '..playerid..' '..item..' 1 0')
							VkMessage('&#128290; Игрок '..playernick..' первый ввёл капчу ['..captcha..'] за '..captchatime..'sec. и выиграл предмет №'..item..'.')
							activecaptcha = false
							captime = nil
						end
						if playertext == questionanswer and activequestion then
							questiontime = ("%.2f"):format(os.clock() - questime)
							sendInput('/ao Игрок '..playernick..'['..playerid..'] первый ответил на вопрос за '..questiontime..'sec и выиграл предмет №'..prizeid..'.')
							sendInput('/giveitem '..playerid..' '..prizeid..' 1 0')
							VkMessage('&#10067; Игрок '..playernick..'['..playerid..'] первый ответил на вопрос за '..questiontime..'sec и выиграл предмет №'..prizeid..'.')
							activequestion = false
							questime = nil
						end
						if tonumber(playertext) == tonumber(numberskin) and activeskin then
							uskintime = ("%.2f"):format(os.clock() - skintime)
							sendInput('/ao Игрок '..playernick..'['..playerid..'] угадал число '..numberskin..' спустя '..uskintime..'sec после старта и получил Скин №'..skinid..'.')
							sendInput('/giveitem '..playerid..' '..skinid..' 1 0')
							VkMessage('&#128084; Игрок '..playernick..'['..playerid..'] угадал число '..numberskin..' спустя '..uskintime..'sec после старта и получил Скин №'..skinid..'.')
							activeskin = false
							skintime = nil
						end
					end
					for k, v in ipairs(array_flip) do
						if playertext:match(v) then
							insertInVrUsers(playernick)
							if tonumber(getPlayerCooldown(playernick).flip) > os.time() then sendInput('/fakesms '..playerid..' ['..bot_name..'] Вы сможете использовать эту команду в '..os.date("%X", getPlayerCooldown(playernick).flip)); return false end
							db_bot:execute("UPDATE `vr_users` set flip = "..os.time().."+"..cfg.cooldowns.flip.." where nick = '"..playernick.."'")
							newTask(function() sendInput('/flip '..playerid); wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] Вы были флипнуты, использовать команду в следующий раз Вы сможете в '..os.date("%X", getPlayerCooldown(playernick).flip)); end)
						end
					end
					if inTable(array_cb, playertext) or inTable(array_ab, playertext) or inTable(array_blv, playertext) or inTable(array_cr, playertext) then
						insertInVrUsers(playernick)
						if tonumber(getPlayerCooldown(playernick).teleport) > os.time() then sendInput('/fakesms '..playerid..' ['..bot_name..'] Вы сможете использовать эту команду в '..os.date("%X", getPlayerCooldown(playernick).teleport)); return false end
						db_bot:execute("UPDATE `vr_users` set teleport = "..os.time().."+"..cfg.cooldowns.teleport.." where nick = '"..playernick.."'")
						for k, v in ipairs(array_cb) do if playertext:match(v) then newTask(function() sendInput('/plpos '..playerid..' '..tp_points['цб']); wait(500); sendInput('/setint '..playerid..' 0') wait(500); sendInput('/setvw '..playerid..' 0') wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] Вы были телепортированы к Центральному Банку по просьбе в VIP-чат :)'); end) end end
						for k, v in ipairs(array_ab) do if playertext:match(v) then newTask(function() sendInput('/plpos '..playerid..' '..tp_points['аб']); wait(500); sendInput('/setint '..playerid..' 0') wait(500); sendInput('/setvw '..playerid..' 0') wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] Вы были телепортированы на АвтоБазар по просьбе в VIP-чат :)'); end) end end
						for k, v in ipairs(array_blv) do if playertext:match(v) then newTask(function() sendInput('/plpos '..playerid..' '..tp_points['блв']); wait(500); sendInput('/setint '..playerid..' 0') wait(500); sendInput('/setvw '..playerid..' 0') wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] Вы были телепортированы к Банку ЛВ по просьбе в VIP-чат :)'); end) end end
						for k, v in ipairs(array_cr) do if playertext:match(v) then newTask(function() sendInput('/plpos '..playerid..' '..tp_points['цр']); wait(500); sendInput('/setint '..playerid..' 0') wait(500); sendInput('/setvw '..playerid..' 0') wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] Вы были телепортированы к Центральному Рынку по просьбе в VIP-чат :)'); end) end end
						for k, v in ipairs(array_meria) do if playertext:match(v) then newTask(function() sendInput('/plpos '..playerid..' '..tp_points['мерия']); wait(500); sendInput('/setint '..playerid..' 0') wait(500); sendInput('/setvw '..playerid..' 0') wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] Вы были телепортированы к Мерии по просьбе в VIP-чат :)'); end) end end
					end
					for k, v in ipairs(array_nrg) do
						if playertext:match(v) then
							insertInVrUsers(playernick)
							if tonumber(getPlayerCooldown(playernick).nrg) > os.time() then sendInput('/fakesms '..playerid..' ['..bot_name..'] Вы сможете использовать эту команду в '..os.date("%X", getPlayerCooldown(playernick).nrg)); return false end
							db_bot:execute("UPDATE `vr_users` set nrg = "..os.time().."+"..cfg.cooldowns.nrg.." where nick = '"..playernick.."'")
							newTask(function() sendInput('/plveh '..playerid..' 522 0'); wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] Вам был выдан мотоцикл NRG-500 по просьбе в VIP-чат :)'); end)
						end
					end
					for k, v in ipairs(array_hp) do
						if playertext:match(v) then
							sendInput('/sethp '..playerid..' 100')
							sendInput('/fakesms '..playerid..' ['..bot_name..'] Вам было выдано ХП по просьбе в VIP-чат')
							VkMessage('&#128168; Выдал HP '..playernick..' по просьбе в VIP-чат')
						end
					end
					for k, v in ipairs(array_pass) do
						if playertext:match(v) then
							sendInput('/givepass '..playerid)
							sendInput('/fakesms '..playerid..' ['..bot_name..'] Вам был выдан паспорт по просьбе в VIP-чат')
							VkMessage('&#128168; Выдал паспорт '..playernick..' по просьбе в VIP-чат')
						end
					end
					for k, v in ipairs(array_car) do
						if playertext:match(v) then
							insertInVrUsers(playernick)
							if tonumber(getPlayerCooldown(playernick).infernus) > os.time() then sendInput('/fakesms '..playerid..' ['..bot_name..'] Вы сможете использовать эту команду в '..os.date("%X", getPlayerCooldown(playernick).infernus)); return false end
							db_bot:execute("UPDATE `vr_users` set infernus = "..os.time().."+"..cfg.cooldowns.infernus.." where nick = '"..playernick.."'")
							newTask(function() sendInput('/plveh '..playerid..' 411 1'); wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] Вам был выдан автомобиль Infernus по просьбе в VIP-чат :)'); end)
						end
					end
					for k, v in ipairs(array_spawn) do
						if playertext:match(v) then
							insertInVrUsers(playernick)
							if tonumber(getPlayerCooldown(playernick).spawn) > os.time() then sendInput('/fakesms '..playerid..' ['..bot_name..'] Вы сможете использовать эту команду в '..os.date("%X", getPlayerCooldown(playernick).spawn)); return false end
							db_bot:execute("UPDATE `vr_users` set spawn = "..os.time().."+"..cfg.cooldowns.spawn.." where nick = '"..playernick.."'")
							newTask(function() sendInput('/spplayer '..playerid); wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] Вам были заспавнены по просьбе в VIP-чат :)'); end)
						end
					end
					for k, v in ipairs(array_help) do
						if playertext:match(v) then
							insertInVrUsers(playernick)
							if tonumber(getPlayerCooldown(playernick).help) > os.time() then sendInput('/fakesms ['..bot_name..'] '..playerid..' Вы сможете использовать эту команду в '..os.date("%X", getPlayerCooldown(playernick).help)); return false end
							db_bot:execute("UPDATE `vr_users` set help = "..os.time().."+"..cfg.cooldowns.help.." where nick = '"..playernick.."'")
							newTask(function()	
								sendInput('/fakesms ['..bot_name..'] '..playerid..' Флип – /vr "дайте флип", "админы флип", "админы почините", "почините", "бот дай флип"'); wait(500);
								sendInput('/fakesms ['..bot_name..'] '..playerid..' Инфернус – /vr "дайте инфернус", "дай инфернус", "дай тачку", "дайте тачку"'); wait(500);
								sendInput('/fakesms ['..bot_name..'] '..playerid..' НРГ – /vr "дайте нрг", "дай нрг", "дай мотоцикл", "дайте мотоцикл"'); wait(500);
								sendInput('/fakesms ['..bot_name..'] '..playerid..' Спавн – /vr "заспавните", "спавн дайте", "бот спавн", "админы спавн"');
							end)
						end
					end
				end
			if str:find(" {......}%[(.*)%]{FFFFFF} (.*)%[(%d+)%]{FFFFFF}: (.*)") then
				playertag, playernick, playerid, playertext = str:match(" {......}%[(.*)%]{FFFFFF} (.*)%[(%d+)%]{FFFFFF}: (.*)")
				if playernick == '1232' or playernick1 == ''..bot_name..'' then
				else
					for k, v in ipairs(array_neadekvats) do
						if playertext:match(v) and not playertext:match('пидар') then
							sendInput('/a Я увидел запрещённое сообщение в VIP CHAT от '..playernick..' с ID:'..playerid..' слово ('..playertext:match(v)..')')
							sendInput('/a Проверьте информацию, сохраните доказательства и выдайте мут')
						end
					end
					for k, v in ipairs(array_banip) do
						if playertext:match(v) and not playertext:match('пидар') then
							sendInput('/banip '..playerid..' 13')
							VkMessage("&#128683; Игрок "..playernick.."["..playerid.."] был автоматически наказан за Оск сервера в /vr.\n&#128203; Содержимое сообщения: "..str:gsub('{......}', ''))
						end
					end
					for k, v in ipairs(array_mats) do
						if playertext:match(v) and not playertext:match('топ') then
							sendInput('/banoff 0 '..playernick..' 30 Оск. род.')
							sendInput('/a Игрок '..playernick..'['..playerid..'] был автоматически наказан за оскорбление родных.')
							VkMessage("&#128683; Игрок "..playernick.."["..playerid.."] был автоматически наказан за Оскорбление родных.\n&#128203; Содержимое сообщения: "..str:gsub('{......}', ''))
						end
					end
					if getCapitalLetter(playertext, 3) >= 6 then
						sendInput('/mute '..playerid..' 10 CapsLock /vr [загл. букв: ' .. getCapitalLetter(playertext, 3)..']')
						sendInput('/a Игрок '..playernick..' автоматически получил наказание за caps [загл. букв: ' .. getCapitalLetter(playertext, 3)..'].')
						VkMessage("&#128683; Игрок "..playernick.."["..playerid.."] был автоматически наказан за CapsLock в /vr [загл. букв: " .. getCapitalLetter(playertext, 3).."].\n&#128203; Содержимое сообщения: "..str:gsub('{......}', ''))
					end
				end
			end
			if str:find("%[Жалоба%] от (.*)%[(%d+)%]: {ffffff}(.*). Уже (%d+) репортов") then
				playernick, playerid, playertext, reports = str:match("%[Жалоба%] от (.*)%[(%d+)%]: {ffffff}(.*). Уже (%d+) репортов")
				if get_hour_report then
					for k, v in ipairs(report_statistic_array) do
						local f = io.open(bot_name..'/Statistic/'..v, 'a')
						f:write('-- ['..os.date("%d.%m | %X", os.time())..'] Репорт: '..(reports)..'\n')
						f:close()
					end
					get_hour_report = false
				end
				if tonumber(reports) >= 5 then
					for i = 1, 50 do
						sendInput('/a АДМИНЫ, ОТВЕЧАЕМ НА РЕПОРТ - /ot /ot /ot !!!')
					end
					VkMessage('&#128221; Репорт поднялся до '..tonumber(reports)..', бот профлудил в админ-чат(SAMP) и в админ-чат(VK).')
					sendInput('/a @2lvl @3lvl @4lvl уже '..reports..' реппорта.')
					VkMessageWithPing('@all\n\n&#9889; &#9889; &#9889; РЕПОРТ ПОДНЯЛСЯ ДО '..reports..'. БЫСТРО НА СЕРВЕР!\n&#9889; &#9889; &#9889; РЕПОРТ ПОДНЯЛСЯ ДО '..reports..'. БЫСТРО НА СЕРВЕР!\n&#9889; &#9889; &#9889; РЕПОРТ ПОДНЯЛСЯ ДО '..reports..'. БЫСТРО НА СЕРВЕР!')
				end
			end
			if str:find("%[Жалоба%] от (.*)%[(%d+)%]: {ffffff}(.*). Уже (%d+) репортов") then
				playernick, playerid, playertext, reports = str:match("%[Жалоба%] от (.*)%[(%d+)%]: {ffffff}(.*). Уже (%d+) репортов")
				if playernick == 'sanechka' or playernick == ''..bot_name..'' or playernick == 'Molodoy_Nalletka' or playernick == 'Bell_King' or playernick == 'Utopia_Boss' or playernick == 'server' then
				else
					if getCapitalLetter(playertext, 3) >= 6 then
					sendInput('/mute '..playerid..' 10 CapsLock /rep [загл. букв: ' .. getCapitalLetter(playertext, 3)..']')
					VkMessage("&#128683; Игрок "..playernick.."["..playerid.."] был автоматически наказан за CapsLock в /report [загл. букв: " .. getCapitalLetter(playertext, 3).."].\n&#128203; Содержимое сообщения: "..str:gsub('{......}', ''))
					end
					for k, v in ipairs(array_mats) do
						if playertext:match(v) and not playertext:match('топ') then
							sendInput('/banoff 0 '..playernick..' 30 Оск. род.')
							sendInput('/a Игрок '..playernick..'['..playerid..'] был автоматически наказан за оскорбление родных.')
							VkMessage("&#128683; Игрок "..playernick.."["..playerid.."] был автоматически наказан за Оскорбление родных.\n&#128203; Содержимое сообщения: "..str:gsub('{......}', ''))
						end
					end
					for k, v in ipairs(array_banip) do
						if playertext:match(v) and not playertext:match('пидар') then
							sendInput('/banip '..playerid..' 13')
							VkMessage("&#128683; Игрок "..playernick.."["..playerid.."] был автоматически наказан за Оск сервера в /report.\n&#128203; Содержимое сообщения: "..str:gsub('{......}', ''))
						end
					end
					for k, v in ipairs(array_neadekvats) do
						if playertext:match(v) then
							sendInput('/a Я увидел запрещённое сообщение в REPORT от '..playernick..' с ID:'..playerid..' слово ('..playertext:match(v)..')')
							sendInput('/a Проверьте информацию, сохраните доказательства и выдайте мут')
						end
					end
				end
			end
			if str:match('%[A%] (.*) выдал оружие (.*) (.*) игрокам!') then
				aname, gunid, players = str:match("%[A%] (.*) выдал оружие (.*) (.*) игрокам!")
				if gunid == 'Minigun' or gunname == 'Rocket Launcher' or gunname == 'Auto Rocket Launcher' then
					sendInput('/awarn '..aname..' Запр. Оружие')
					sendInput('/a Не советую больше так делать!')
				end
			end
			if str:match('%[A%] (.*)%[(%d+)%] %-> (.*)%[(%d+)%]:{ffffff} (.*)') then
				aname, aid, pname, pid, msg = str:match("%[A%] (.*)%[(%d+)%] %-> (.*)%[(%d+)%]:{ffffff} (.*)")
				if aname == 'sanechka' or aname == ''..bot_name..'' or aname == 'Molodoy_Nalletka' or aname == 'Bell_King' or aname == 'Utopia_Boss' or aname == 'server' then
				elseif aname == pname then
					sendInput('/awarn '..aname..' Накрутка репорта')
					sendInput('/setrep '..aname..' 0')
					sendInput('/a За такие мувы , обнулил репутацию')
				end
			end
			if str:match(hook_adminchat..' /givegun (.*) (.*) (.*)') then
				admintag, aname, admin_id, id, gunid, pt = str:match(hook_adminchat.." /givegun (.*) (.*) (.*)")
				if aname == 'Galileo_DeLamonte' then
					sendInput(''..aname..' -  разработчик запретил использовать вам эту возможность')
				else 
					if gunid == '38' or gunid == '37' or gunid == '36' then
						sendInput('/a Отказано , запрещённое оружие')
						sendInput('/awarn '..admin_id..' Попытка выдачи запр. оружия')
						VkMessage('&#128548; Администратор '..aname..' пытался через форму выдать себе запр. оружие. И я дал ему пред.')
					else
						sendInput('/givegun '..id..' '..gunid..' '..pt)
						sendInput('/a Форма на выдачу оружия от '..aname..' успешно принята')
					end
				end
			end
			if str:match('A: (.*) снял 1 выговор у администратора (.*)') then
				aname, adminname = str:match("A: (.*) снял 1 выговор у администратора (.*)")
				if aname == 'sanechka' or aname == ''..bot_name..'' or aname == 'Molodoy_Nalletka' or aname == 'Bell_King' or aname == 'Utopia_Boss' or aname == 'server' then
				elseif aname == adminname then
					sendInput('/awarn '..aname..' НПА')
					VkMessage('&#128128; Администратор '..aname..' пытался снять себе выговор')
					VkMessageFlood("/getbynick "..aname)
					VkMessageFlood("Выдать ему пред, с тэгом // sanechka[Пример: /warn "..aname.." НПА // sanechka]")
				end
			end
		end
	end
end

local _getAllPlayers = getAllPlayers;
	getAllPlayers = function()
    local players2 = {};
    for id, player in pairs(_getAllPlayers()) do
        player.id = id;
        table.insert(players2, player);
    end

    return players2;
end

function getPlayerColor(id)
    local players2 = getAllPlayers();
    for key, value in pairs(players2) do
        if (value.id == id) then
            return value.color;
        end
    end
end

function getPlayerName(id) 
    local players2 = getAllPlayers();
    for key, value in pairs(players2) do
        if (value.id == id) then
            return value.nick;
        end
    end
end

function goOnStreet()
	 newTask(function() wait(1000)
		runCommand('!pos -810.18 2830.79 1501.98')
		sendInput('/setvw '..bot_name..' 0')	
		sendInput('/setint '..bot_name..' 0')	
	end)
end

function AutoOpraSystem()
	autoopra = not autoopra
	sendInput('/a Администратор '..anickname:gsub('_', ' ')..'['..aid..'] '..(autoopra and 'включил' or 'выключил')..' автоопровержение.')
	sendInput('/vr '..(autoopra and 'Включил' or 'Выключил')..' автоопровержение!')
	VkMessage('&#128680; Администратор '..anickname..'['..aid..'] '..(autoopra and 'включил' or 'выключил')..' автоопровержение.')
	cd_autoopra = os.clock()
	newTask(function()
		wait(wait(tonumber(config[8][2])*1000))
		if autoopra then
			autoopra = false
			sendInput('/a Автоопровержение выключено по истечению 2х минут после его включения администрацией.')
			sendInput('/vr Автоопровержение выключено по истечению 2х минут после его включения администрацией.')
			VkMessage('&#128680; Автоопровержение выключено по истечению 2х минут после его включения администрацией.')
		end
	end)
end


function randomQuestion()
	arrays = {
			{"В честь какаго разработчика стоит статуя на ЖД ЛС?", "Калькор"},
			{"Максимальная сумма пожертвования в благотворительность ?", "100000000"},
			{"Сколько нелегальных автомобилей доступно к покупке в автосалоне ?", "15"},
			{"Сколько стоит вызвать такси через телефонную будку ?", "400"},
			{"Как зовут менеджера стоящего на аукционе контейнеров", "Магнус"},
			{"Как зовут квест персонажа стоящего у тренировочного полигона автошколы", "Маргарита"},
			{"Как зовут скупщика нелегала в гетто", "Гурам"},
			{"Какой игровой уровень требуется для того чтобы устроить на работу адвоката", "7"},
			{"Какой игровой уровень требуется для того чтобы устроить на работу инкассатора", "6"},
			{"Сколько стоит билет на мероприятие \"Собиратели\"", "30000"},
			{"Укажите количество нефтевышек доступных на сервере", "8"},
			{"Сколько стоит кирка для добычи ископаемых которую продает Лари", "5000"},
			{"Какая максимальная сумма штрафа может быть наложена на личный автомобиль", "80000"},
			{"Какова гос. цена бизнеса - сельскохозяйственный магазин", "45000000"},
			{"Сколько авто стоит в пожарной части Лос Сантоса", "5"},
			{"Сколько стоит стоит улучшение \"Бренд\" для семьи", "80000000"},
			{"Сколько стоят обручальные кольца для проведения свадьбы", "5000"},
			{"Сколько всего нелегальных автомобилей доступно к покупке в автосалоне", "14"},
			{"Начальная ставка в контейнерах", "4000000"},
			{"Как зовут квест персонажа стоящего в Больнице ЛС", "Керри"},
			{"Сколько всего автобусов припарковано на ЖД ЛВ", "7"},
			{"Какова начальная ставка на контейнер класса премиум", "15000000"},
			{"Какова гос. цена бизнеса - нефтевышка", "60000000"},
			{"В честь какого разработчика стоит статуя на ЖД ЛС", "Калькор"},
			{"Сколько стоит лотерейный VIP-билет", "2500000"},
			{"Какое количество авто можно иметь купив PREMIUM VIP", "20"},
			{"Укажите номер справочной центрального банка", "8828"},
			{"Сколько стоит совершить прыжок с парашютом", "900"},
			{"Сколько всего личных ферм на сервере", "5"},
			{"Укажите количество ячеек у фермы №1", "24"},
			{"Укажите точное количество магазинов видеокарт", "3"},
			{"Какова гос. стоимость трейлера среднего класса", "3500000"},
			{"Укажите сколько дрифт монет стоит предмет \"Крылья зеленые\" в сувенирной лавке", "1300"},
			{"Укажите сколько семейных монет стоит предмет \"Рюкзак будущего\" в семейном магазине", "2800"},
			{"На какой номер нужно позвонить чтобы вызвать такси", "913"},
			{"Какова начальная ставка на контейнер класса ультра", "20000000"},
			{"Как зовут персонажа который всегда встречает новых игроков на вокзале", "Джереми"},
			{"Какой игровой уровень нужно достигнуть чтобы создать свою семью", "20"},
			{"На какой номер нужно позвонить чтобы вызвать механика", "914"},
			{"Какой порядковый номер у бизнеса \"Аренда велосипедов\"", "215"},
			{"На какой номер нужно позвонить чтобы вызвать скорую помощь", "912"},
			{"Сколько стоит создание новой семьи", "20000000"},
			{"Какой игровой уровень требуется для того чтобы устроить на работу водителя трамвая", "9"},
			{"Какой игровой уровень требуется для того чтобы устроить на работу крупье", "5"}
			}
	numbervariant = random(1, 34)
	questiontext = '/ao Внимание, вопрос: '..arrays[numbervariant][1]..' | Ответ в VIP-чат(/vr)!'
	questionanswer = arrays[numbervariant][2]
	return questiontext, questionanswer
end


function randomCaptcha(item, captcha)
	arraysymbols = {
		'a',
	}
	local s = arraysymbols[random(1,1)]
	array = {
			'! Приз: предмет №'..item..' | К'..s..'пча ['..captcha..'].',
	}
	numbervariant = math.random(1,1)
	captchatext = '/ao Внимание'..array[numbervariant]..' Ответ ТОЛЬКО в VIP-чат (/vr)!'
	return captchatext
end

function random(min, max)
    kf = math.random(min, max)
    math.randomseed(os.time() * kf)
    rand = math.random(min, max)
    return tonumber(rand)
end

function AnsiToUtf8(s)
   local r, b = ''
   for i = 1, s and s:len() or 0 do
     b = s:byte(i)
     if b < 128 then
       r = r..string.char(b)
     else
      if b > 239 then
         r = r..'\209'..string.char(b - 112)
       elseif b > 191 then
         r = r..'\208'..string.char(b - 48)
       elseif ansi_decode[b] then
         r = r..ansi_decode[b]
       else
         r = r..'_'
       end
     end
   end
  return r
end


function vk_request_user(user_id, msg)
	msg = AnsiToUtf8(msg)
	msg = url_encode(msg)
	local keyboard = vkKeyboardls()
	keyboard = u8(keyboard)
	keyboard = url_encode(keyboard)
	msg = msg .. '&keyboard=' .. keyboard
	mainPartOfVkSystem(msg, user_id)
	async_http_request('https://api.vk.com/method/messages.send', 'user_id=' .. user_id .. '&random_id=' .. math.random(-2147483648, 2147483647) .. '&message=' .. msg .. '&access_token=' .. access_token .. '&v=5.131',
	function (result)
		local t = json.decode(result)
		if not t then print(result) return end
		if t.error then print('Ошибка! Код: ' .. t.error.error_code .. ' Причина: ' .. t.error.error_msg) return end
		vkerrsend = nil
	end)
end







function mainPartOfVkSystem(msg)
	local rnd = math.random(-2147000000, 2147000000)
	async_http_request('https://api.vk.com/method/messages.send', 'chat_id='..tonumber(two_chat_id)..'&random_id=' .. rnd .. '&message=' .. msg .. '&access_token=' .. two_access_token .. '&v=5.131',
	function (result)
		local t = json.decode(result)
		if not t then print(result) return end
		if t.error then print('Ошибка! Код: ' .. t.error.error_code .. ' Причина: ' .. t.error.error_msg) return end
		vkerrsend = nil
	end)
end

function partOfVkSystem(msg)
	local rnd = math.random(-2147000000, 2147000000)
	async_http_request('https://api.vk.com/method/messages.send', 'chat_id='..tonumber(chat_id)..'&random_id=' .. rnd .. '&message=' .. msg .. '&access_token=' .. access_token .. '&v=5.131',
	function (result)
		local t = json.decode(result)
		if not t then print(result) return end
		if t.error then print('Ошибка! Код: ' .. t.error.error_code .. ' Причина: ' .. t.error.error_msg) return end
		vkerrsend = nil
	end)
end

function floodOfVkSystem(msg)
	local rnd = math.random(-2147000000, 2147000000)
	async_http_request('https://api.vk.com/method/messages.send', 'chat_id='..tonumber(two_chat_id)..'&random_id=' .. rnd .. '&message=' .. msg .. '&access_token=' .. two_access_token .. '&v=5.131',
	function (result)
		local t = json.decode(result)
		if not t then print(result) return end
		if t.error then print('Ошибка! Код: ' .. t.error.error_code .. ' Причина: ' .. t.error.error_msg) return end
		vkerrsend = nil
	end)
end

function logOfVkSystem(msg)
	local rnd = math.random(-2147000000, 2147000000)
	async_http_request('https://api.vk.com/method/messages.send', 'chat_id='..tonumber(log_chat_id)..'&random_id=' .. rnd .. '&message=' .. msg .. '&access_token=' .. log_acces_token .. '&v=5.131',
	function (result)
		local t = json.decode(result)
		if not t then print(result) return end
		if t.error then print('Ошибка! Код: ' .. t.error.error_code .. ' Причина: ' .. t.error.error_msg) return end
		vkerrsend = nil
	end)
end

function longpollResolve(result)
	if result then
		if result:sub(1,1) ~= '{' then
			vkerr = 'Ошибка!\nПричина: Нет соединения с VK!'
			return
		end
		local t = json.decode(result)
		if t.failed then
			if t.failed == 1 then
				ts = t.ts
			else
				key = nil
				longpollGetKey()
			end
			return
		end
		if t.ts then
			ts = t.ts
		end
		if t.updates then
			for k, v in ipairs(t.updates) do
				if v.type == 'message_new' and v.object.message then
					if v.object.message.payload then
						local pl = json.decode(v.object.message.payload)
						if pl.button then
							local chat_id = v.object.message.chat_id
							if tonumber(chat_id) == tonumber(chat_id) then
								local from_id = tonumber(v.object.message.from_id)
								if pl.button == 'report' then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('reports') then
										send_info_report()
									else
										NoDostupToCommand()
									end
								elseif pl.button == 'online' then	
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('online') then
										send_info_online()
									else
										NoDostupToCommand()
									end
								elseif pl.button == 'admin_online' then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('admins') then
										send_info_admins()
									else
										NoDostupToCommand()
									end
								elseif pl.button == 'leaders_online' then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('leaders') then
										send_info_leaders()
									else
										NoDostupToCommand()
									end
								elseif pl.button == 'accept' then
									accept()
									sendInput('/mute '..playernick..' 300 Оскорбление родни /vr')
									sendInput('/muteoff '..playernick..' 300 Оскорбление родни /vr')
									VkMessage('	&#129313; Выдал мут мамкоёбу под никнеймом '..playernick)
								elseif pl.button == 'noaccept' then
									accept()
									VkMessage('&#129324; Окей , уношу виселицу')
								elseif pl.button == 'sliv' then
									sliv()
									sendInput('/banip '..anick..' 13')
									sendInput('/banoff '..anick..' 2000 13')
									VkMessage('	&#129313; выдал бан сливщику '..anick)
								elseif pl.button == 'nosliv' then
									sliv()
									VkMessage('&#129324; Окей , обойдёмся без бана')
								elseif pl.button == 'unban' then
									start_button = false
									vzlom()
									VkMessage('&#9989; Сейчас разбаню')
									sendInput('/unban '..infocheck..' [VK] Ошибка')
									give_unban_form = true
								elseif pl.button == 'nounban' then
									start_button = false
									vzlom()
									VkMessage('&#128219; В разбане отказано')
								elseif pl.button == 'unban1' then
									start_button = false
									vzlom1()
									VkMessage('&#9989; Сейчас разбаню')
									sendInput('/unban '..nick..' [VK] Ошибка')
									give_unban_form = true
								elseif pl.button == 'nounban1' then
									start_button = false
									vzlom1()
									VkMessage('&#128219; В разбане отказано')
								elseif pl.button == 'vernut1' then
									start_button = false
									vernut1()
									VkMessage('&#129312; | Админ-права успешно выданы')
									sendInput('/pm 1 '..aid..' ['..bot_name..'] Срочно отпиши в конфу админов за возвращением админ-прав')
									sendInput('/pm 1 '..aid..' ['..bot_name..'] Срочно отпиши в конфу админов за возвращением админ-прав')
									sendInput('/pm 1 '..aid..' ['..bot_name..'] Срочно отпиши в конфу админов за возвращением админ-прав')
									sendInput('/pm 1 '..aid..' ['..bot_name..'] Срочно отпиши в конфу админов за возвращением админ-прав')
									sendInput('/pm 1 '..aid..' ['..bot_name..'] Срочно отпиши в конфу админов за возвращением админ-прав')
									sendInput('/pm 1 '..aid..' ['..bot_name..'] Срочно отпиши в конфу админов за возвращением админ-прав')
									sendInput('/pm 1 '..aid..' ['..bot_name..'] Срочно отпиши в конфу админов за возвращением админ-прав')
									sendInput('/pm 1 '..aid..' ['..bot_name..'] Срочно отпиши в конфу админов за возвращением админ-прав')
									sendInput('/pm 1 '..aid..' ['..bot_name..'] Срочно отпиши в конфу админов за возвращением админ-прав')
									sendInput('/pm 1 '..aid..' ['..bot_name..'] Срочно отпиши в конфу админов за возвращением админ-прав')
								elseif pl.button == 'yes' then
									yes()
									VkMessage('&#9989; Ацепт успешно выдан администратору '..aname..'.')
									sendInput('/acceptadmin '..aid)
									start_button = false
								elseif pl.button == 'no' then
									yes()
									VkMessage('&#9989; В выдаче ацепта отказано.')
									sendInput('Тебе отказали в ацепте. Кнопку нажал('..getUserName(from_id)..')')
									start_button = false
								elseif pl.button == 'start_captcha' then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('captcha') then
										startCaptcha() 
										VkMessage('&#128290; Капча на скин была запущена, ожидайте победителя.')
									else
										NoDostupToCommand()
									end
								elseif pl.button == 'start_question' then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('question') then
										startQuestion()
										VkMessage('&#10067; Рандомный вопрос на рандомный новый люкс автомобиль запущен.')
									else
										NoDostupToCommand()
									end
								elseif pl.button == 'help' then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('help') then
										sendHelpMessage(from_id, message_id)
									else
										NoDostupToCommand()
									end
								elseif pl.button == 'check_server_online' then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('stata') then
										keyboard_vk('&#128200; Выберите тип статистики онлайна:', 'onl')
									else
										NoDostupToCommand()
									end
								elseif pl.button == 'onlday_stats' then
									send_online_stats('day')
								elseif pl.button == 'onlweek_stats' then
									send_online_stats('week')
								elseif pl.button == 'onlall_stats' then
									send_online_stats('all')
								elseif pl.button == 'repday_stats' then
									send_report_stats('day')
								elseif pl.button == 'repweek_stats' then
									send_report_stats('week')
								elseif pl.button == 'repall_stats' then
									send_report_stats('all')
								elseif pl.button == 'admday_stats' then
									send_admins_stats('day')
								elseif pl.button == 'admweek_stats' then
									send_admins_stats('week')
								elseif pl.button == 'admall_stats' then
									send_admins_stats('all')
								elseif pl.button == 'return_business_ban' then
									send_bans_businessis()
								elseif pl.button == 'return_house_ban' then
									send_bans_housis()
								elseif pl.button == 'gowork' then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('spam') then
										gowork()
									else
										NoDostupToCommand()
									end
								elseif pl.button == 'gowork1' then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('spam') then
										gowork1()
									else
										NoDostupToCommand()
									end
								elseif pl.button == 'gorep' then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('spam') then
										gorep()
									else
										NoDostupToCommand()
									end
								elseif pl.button == 'chtot' then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('spam') then
										chtot()
									else
										NoDostupToCommand()
									end
								elseif pl.button == 'spam' then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('spam') then
										spam()
									else
										NoDostupToCommand()
									end
								elseif pl.button == 'chtog' then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('spam') then
										chtog()
									else
										NoDostupToCommand()
									end
								elseif pl.button == 'vse' then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('spam') then
										vse()
									else
										NoDostupToCommand()
									end
								elseif pl.button == 'yes_start' and start_button then
									start_button = false
									auto_slet = true
									set_position = true
									if tonumber(id_type) == 0 then
										sendInput('/gotohouse '..slet_id)
									elseif tonumber(id_type) == 1 then
										sendInput('/gotobiz '..slet_id)
									end
									VkMessage(string.format([[
&#8987; Принято, запускаю мероприятие. Настройки:
&#9654; Тип имущества: %s.
&#9654; ID имущества: %s.
&#9654; Время телепорта: %sсек.
&#9654; %s.
									]], name_type, slet_id, teleport_time, tostring(name_opra)))
									sendInput('/eventmenu')
								elseif pl.button == 'no_stop' and start_button then
									start_button = false
									auto_slet = true
									set_position = true
									VkMessage('&#129324; Окей , отклоняю слёт')
								end
							end
						end
						return
					end
					if v.object.message.text then
						local text = v.object.message.text 
						local chat_id = v.object.message.chat_id 
						local from_id = tonumber(v.object.message.from_id)
						local send_date = tonumber(v.object.message.date)
						local user_id = tonumber(v.object.message.from_id)
						local message_id = tonumber(v.object.message.conversation_message_id)
						function UseCommandls(msg) vk_request_user(user_id, '&#128221; Используйте: '..msg) end
						if tonumber(peer_id) == tonumber(chat_id) then
							if isUserHaveMute(from_id) then
								luaVkApi.deleteMessages(message_id, group_id, peer_id)
							else
								db_bot:execute("UPDATE `cf_users` SET messages = messages+1 where `userid` = '"..from_id.."'")
								db_bot:execute("UPDATE `cf_users` SET `lastmessage_date` = '"..send_date.."' where `userid` = '"..from_id.."'")
								if cfg.config.anti_flood then
									db_bot:execute("UPDATE `cf_users` SET messages_in_minute = messages_in_minute+1 where `userid` = '"..from_id.."'")
								end
								cursor, errorString = db_bot:execute("select * from `cf_users` where `userid` = '"..from_id.."'")
								if cursor then
									row = cursor:fetch({}, "a")
									while row do
										usermessages = row.messages_in_minute
										row = cursor:fetch(row, "a")
									end
								end
								if cfg.config.anti_flood and tonumber(usermessages) > tonumber(cfg.config.antiflood_msg) and tonumber(getUserLevelDostup(from_id)) < 1 then
									luaVkApi.removeChatUser((tonumber(chat_id)), tonumber(from_id))
									db_bot:execute("DELETE FROM `cf_users` where `userid` = '"..from_id.."'")
									VkMessage('&#9940; Пользователь @id'..from_id..'('..getUserName(from_id)..') был исключен из конференции за превышение лимита отправляемых сообщений ['..cfg.config.antiflood_msg..'] в минуту.')
								end
							end
							if silence and tonumber(getUserLevelDostup(from_id)) < 3 then
								ydal_message()
							end
							if v.object.message.action and v.object.message.action.member_id then 
								if v.object.message.action.type == 'chat_kick_user' then
									VkMessage(v.object.message.action.member_id..' bye bye')
									db_bot:execute("DELETE FROM `cf_users` where `userid` = '"..v.object.message.action.member_id.."'")
								elseif v.object.message.action.type == ('chat_invite_user' or 'chat_invite_user_by_link') then
									local new_user_id = v.object.message.action.member_id
									if isUserInBan(new_user_id) then
										VkMessage('&#9940; Пользователь @id'..new_user_id..' заблокирован пользователем @id'..getUserBanByAdmin(new_user_id)..'('..getUserName(getUserBanByAdmin(new_user_id))..').\n&#128203; Причина блокировки: '..getUserBanReason(new_user_id))
										luaVkApi.removeChatUser((tonumber(chat_id)), tonumber(v.object.message.action.member_id))
										luaVkApi.removeChatUser((tonumber(chat_id)), tonumber(new_user_id))
									else
										local f = io.open(bot_name..'/greetings.ini', "r")
										greetings = f:read('*a')
										f:close()
										if cfg.config.check_on_public and not isUserSubscribeOnGroup(new_user_id) then
											VkMessage('&#9940; Пользователь @id'..new_user_id..'('..getUserName(new_user_id)..') не состоит в паблике @public'..cfg.config.check_public_link..'('..getGroupNameById(cfg.config.check_public_link)..').')
											db_bot:execute("DELETE FROM `cf_users` where `userid` = '"..new_user_id.."'")
											luaVkApi.removeChatUser((tonumber(chat_id)), tonumber(new_user_id))
										else
											db_bot:execute("INSERT INTO `cf_users` (`userdostup`, `userid`, `username`, `warns`, `vigs`, `mutetime`, `messages`, `lastmessage_date`, `messages_in_minute`) VALUES (0, '"..new_user_id.."', 'NONE', 0, 0, 0, 0, '"..os.time().."', 0)")
											if greetings ~= '' then
												VkMessage('@id'..new_user_id..'('..getUserName(new_user_id)..'), '..greetings)
											end
										end
									end
								end
							end
						end
						if tonumber(chat_id) == tonumber(chat_id) then
							text = Utf8ToAnsi(text)
							if text:find('^/startcaptcha') then
								startCaptcha()
								VkMessage('&#128290; Рандомная капча на рандомный предмет запущена.')
							elseif text:find('^/botoff') then
										newTask(function()
											VkMessage('&#128219; Бот отключен.')
										
											sendInput('/ao Бот выключается на неопределенный срок, максимум на пару часов :)')
											wait(500)
											exit()
										end)
							elseif text:find('^/uonline') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('uonline') then
										online_users = ''
										local online_user_number = 0
										local result = luaVkApi.getConversationMembers(chat_id, group_id)
										local t = json.decode(u8:decode(result))['response']['items']
										for k, v in ipairs(t) do
											if tonumber(v.member_id) > 0 then
												table.insert(all_conference_users, v.member_id)
											end
										end
										for i = 1, #all_conference_users do
											local result = luaVkApi.getUsersInfo(all_conference_users[i], 'online')
											local result = u8:decode(result)
											local t = json.decode(u8:decode(result))['response']
											for k, v in ipairs(t) do
												if tonumber(v.online) == 1 then
													online_user_number = online_user_number + 1
													online_users = online_users..'\n'..convertToSmile(online_user_number)..'– @id'..all_conference_users[i]..'('..getUserName(all_conference_users[i])..')'
												end
											end
										end
										VkMessage('&#128373; Пользователи беседы онлайн:\n\n'..online_users)
										all_conference_users = {}
									else
										NoDostupToCommand()
									end
							elseif text:find('^/text') then
								VkMessageFlood('/getbynick sanechka')
							elseif text:find('^/life') then
								VkMessage('&#128526; Я жив!')
							elseif text:find('^/silence') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('silence') then
										silence = not silence
										VkMessage((silence and '&#9989; ' or '&#10060; ')..'@id'..from_id..'('..getUserName(from_id)..') '..(silence and 'включил' or 'выключил')..' режим тишины.\n'..(silence and '&#128564; Сообщения всех пользователей будет автоматически удаляться.' or '&#128563; Все обычные пользователи снова могут отправлять сообщения.'))
									else
										NoDostupToCommand()
									end
							elseif text:find('^/checkpublic') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('checkpublic') then
										args = text:match('^/checkpublic (.*)')
										if args then
											check_type = args:match('(.*)')
											if check_type == 'kick' or check_type == 'watch' then
												if cfg.config.check_public_link == '' then
													VkMessage('&#9989; Вы не установили ссылку на сообщество для проверки (/setpublic [@паблик]).')
												else
													if check_type == 'kick' then
														local kick_user_public = 0
														getAllUsersIds()
														for i = 1, #all_users_ids do
															if not isUserSubscribeOnGroup(all_users_ids[i]) and tonumber(getUserLevelDostup(all_users_ids[i])) < 1 then
																kick_user_public = kick_user_public + 1
																db_bot:execute("DELETE FROM `cf_users` where `userid` = '"..all_users_ids[i].."'")
																luaVkApi.removeChatUser((tonumber(chat_id)), tonumber(all_users_ids[i]))
															end
														end
														VkMessage('&#9989; Завершена очистка пользователей, которые не подписаны на указанный паблик @public'..cfg.config.check_public_link..'('..getGroupNameById(cfg.config.check_public_link)..').\n&#128219;Пользователей удалено: '..kick_user_public..'.')
														kick_user_public = 0
														all_users_ids = {}
													elseif check_type == 'watch' then
														local check_user_public = 0
														check_list = ''
														getAllUsersIds()
														for i = 1, #all_users_ids do
															if not isUserSubscribeOnGroup(all_users_ids[i]) and tonumber(getUserLevelDostup(all_users_ids[i])) < 1 then
																check_user_public = check_user_public + 1
																check_list = check_list..'\n'..convertToSmile(check_user_public)..' @id'..all_users_ids[i]..'('..getUserName(all_users_ids[i])..')'
															end
														end
														VkMessage('&#128305; Список пользователей, которые не подсисаны на указанный паблик @public'..cfg.config.check_public_link..'('..getGroupNameById(cfg.config.check_public_link)..'):\n\n'..check_list..'\n\n&#128270; Всего пользователей: '..check_user_public..'.')
														check_user_public = 0
														all_users_ids = {}
													end
												end
											else
												UseCommand('/checkpublic [тип проверки]. Типы проверок:\n\n&#128313; kick – кикнуть всех, кто не подписан.\n&#128313; watch – вывести список тех, кто не подписан.')
											end
										else
											UseCommand('/checkpublic [тип проверки]. Типы проверок:\n\n&#128313; kick – кикнуть всех, кто не подписан.\n&#128313; watch – вывести список тех, кто не подписан.')
										end
									else
										NoDostupToCommand()
									end
								elseif text:find('^/setpublic') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('setpublic') then
										args = text:match('^/setpublic (.*)')
										if args then
											groupid, grouplink = args:match('%[club(.*)|(.*)%]')
											if groupid and grouplink then
												cfg.config.check_on_public = true
												cfg.config.check_public_link = tostring(groupid)
												VkMessage('&#9989; Вы успешно установили проверку на паблик @public'..groupid..'('..getGroupNameById(groupid)..').\n\n&#128270; Для проверки всех участников на подписку, используйте команду /checkpublic.\n&#8252; В случае, если пользователь не подписан на указанный паблик, он автоматически исключается.')
												inicfg.save(cfg, bot_name..".ini")
											else
												UseCommand('/setpublic [@паблик]')
											end
										else
											UseCommand('/setpublic [@паблик]')
										end
									else
										NoDostupToCommand()
									end
								elseif text:find('^/removepublic') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('removepublic') then
										if cfg.config.check_on_public then
											cfg.config.check_on_public = false
											VkMessage('&#9940; @id'..from_id..'('..getUserName(from_id)..') выключил проверку подписки на паблик.')
											inicfg.save(cfg, bot_name..".ini")
										else
											VkMessage('&#9940; Проверка подписки на паблик и так выключена.')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/stats') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('stats') then
										args = text:match('^/stats (.*)')
										if args then
											id, link = args:match('%[id(.*)|@(.*)%]')
											if id and link then
												checkUserStats(from_id, id)
											else
												UseCommand('/stats [@пользователь]')
											end
										else
											UseCommand('/stats [@пользователь]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/iwl') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('iwl') then
										args = text:match('^/iwl (.*)')
										if args then
											id, link = args:match('%[id(.*)|@(.*)%]')
											if id and link then
												if not isUserInsertInToDB(id) then
													db_bot:execute("INSERT INTO `cf_users` (`userdostup`, `userid`, `username`, `warns`, `vigs`, `mutetime`, `messages`, `lastmessage_date`, `messages_in_minute`) VALUES (0, '"..id.."', 'NONE', 0, 0, 0, 0, '"..os.time().."', 0)")
													VkMessage('&#9999; Пользователь @id'..id..' добавлен в список участников беседы.')
												else
													VkMessage('&#128219; Пользователь @id'..id..' уже есть в списке участников.')
												end
											else
												UseCommand('/iwl [@пользователь]')
											end
										else
											UseCommand('/iwl [@пользователь]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/removerole') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('removerole') then
										args = text:match('^/removerole (.*)')
										if args then
											id, link = args:match('%[id(.*)|@(.*)%]')
											if id and link then
												removeRoleUser(from_id, id)
											else
												UseCommand('/removerole [@пользователь]')
											end
										else
											UseCommand('/removerole [@пользователь]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/inactive') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('inactive') then
										args = text:match('^/inactive (.*)')
										if args then
											days, type_inactive = args:match('(%d+) (.*)')
											if days and type_inactive then
												if tonumber(days) > 0 and tonumber(days) <= 30 then
													if tostring(type_inactive) == 'kick' then
														local kick_user_inactive = 0
														inactive_list = ''
														getAllUsersIds()
														for i = 1, #all_users_ids do
															if tonumber(getUserLevelDostup(all_users_ids[i])) < 1 then
																if tonumber(getUserLastMessageDate(all_users_ids[i])) <= ((os.time())-(tonumber(days)*86400)) then
																	kick_user_inactive = kick_user_inactive + 1
																	luaVkApi.removeChatUser((tonumber(chat_id)), tonumber(all_users_ids[i]))
																	db_server:execute("INSERT INTO `logs`( `Text`, `Type`) VALUES ('[VK] "..from_id.." исключил неактивных пользователей за "..args.." дней', '6')")
																	db_bot:execute("DELETE FROM `cf_users` where `userid` = '"..all_users_ids[i].."'")
																end
															end
														end
														if kick_user_inactive > 0 then
															VkMessage('&#128683; Завершена очистка пользователей, которые не написали ни одного сообщения, начиная с '..unix_decrypt((os.time())-(tonumber(days)*86400))..'.\n&#128686; Пользователей исключено: '..kick_user_inactive)
														else
															VkMessage('&#9989; По вашему запросу не найдено ни одного пользователя.')
														end
														all_users_ids = {}
														kick_user_inactive = 0
													elseif tostring(type_inactive) == 'watch' then
														local kick_user_inactive = 0
														inactive_list = ''
														getAllUsersIds()
														for i = 1, #all_users_ids do
															if tonumber(getUserLevelDostup(all_users_ids[i])) < 1 then
																if tonumber(getUserLastMessageDate(all_users_ids[i])) <= ((os.time())-(tonumber(days)*86400)) then
																	kick_user_inactive = kick_user_inactive + 1
																	inactive_list = inactive_list..'\n'..convertToSmile(kick_user_inactive)..' @id'..all_users_ids[i]..'('..getUserName(all_users_ids[i])..') – Последнее сообщение: '..unix_decrypt(getUserLastMessageDate(all_users_ids[i]))
																end
															end
														end
														if kick_user_inactive > 0 then
															VkMessage('&#128683; Пользователи, которые не написали ни одного сообщения, начиная с '..unix_decrypt((os.time())-(tonumber(days)*86400))..':\n\n'..inactive_users)
														else
															VkMessage('&#9989; По вашему запросу не найдено ни одного пользователя.')
														end
														all_users_ids = {}
														kick_user_inactive = 0
													else
														VkMessage('&#10060; Указан неверный тип проверки. Используйте: >inactive [days] [type(watch/kick)]')
													end
												else
													VkMessage('&#10060; Указаное количество дней может быть не меньше 1 и не больше 30.')
												end
											else
												UseCommand('/inactive [days] [type(watch/kick)]')
											end
										else
											UseCommand('/inactive [days] [type(watch/kick)]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/rnick') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('rnick') then
										args = text:match('^/rnick (.*)')
										if args then
											id, link = args:match('%[id(.*)|@(.*)%]')
											if id and link then
												removeNickUser(from_id, id)
											else
												UseCommand('/rnick [@пользователь]')
											end
										else
											UseCommand('/rnick [@пользователь]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/greetings') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('greetings') then
										local f = io.open(bot_name..'/greetings.ini', "r")
										greetings = f:read('*a')
										f:close()
										if greetings == '' then
											args = text:match('^/greetings (.*)')
											if args then
												VkMessage('&#9996; @id'..from_id..'('..getUserName(from_id)..') установил новое приветствие:\n\n'..args)
												local f = io.open(bot_name..'/greetings.ini', 'w')
												f:write(args)
												f:close()
											else
												UseCommand('/greetings [текст приветствия]')
											end
										else
											VkMessage('&#10060; @id'..from_id..'('..getUserName(from_id)..') удалил приветствие при добавлении нового участника в беседу.')
											local f = io.open(bot_name..'/greetings.ini', 'w')
											f:write('')
											f:close()
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/addadmin') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('addadmin') then
										args = text:match('^/addadmin (.*)')
										if args then
											days, id, link = args:match('(%d+) %[id(.*)|@(.*)%]')
											if id and link and days then
												giveUserAdmin(from_id, id, days)
											else
												UseCommand('/addadmin [дни] [@пользователь]')
											end
										else
											UseCommand('/addadmin [дни] [@пользователь]')
										end
									else
										NoDostupToCommand()
									end
								elseif text:find('^/test') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('addowner') then
										args = text:match('^/test (.*)')
										if args then
											days, id, link = args:match('(%d+) %[id(.*)|@(.*)%]')
											if id and link and days then
												giveUserOsnovatel(from_id, id, days)
											else
												UseCommand('/test [дни] [@пользователь]')
											end
										else
											UseCommand('/test [дни] [@пользователь]')
										end
									else
										NoDostupToCommand()
									end
								elseif text:find('^/addspec') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('addspec') then
										args = text:match('^/addspec (.*)')
										if args then
											days, id, link = args:match('(%d+) %[id(.*)|@(.*)%]')
											if id and link and days then
												giveUserSpecialAdmin(from_id, id, days)
											else
												UseCommand('/addspec [дни] [@пользователь]')
											end
										else
											UseCommand('/addspec [дни] [@пользователь]')
										end
									else
										NoDostupToCommand()
									end
								elseif text:find('^/addowner') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('addowner') then
										args = text:match('^/addowner (.*)')
										if args then
											days, id, link = args:match('(%d+) %[id(.*)|@(.*)%]')
											if id and link and days then
												giveUserOwner(from_id, id, days)
											else
												UseCommand('/addowner [дни] [@пользователь]')
											end
										else
											UseCommand('/addowner [дни] [@пользователь]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/getbynick') then
									args = text:match('^/getbynick (.*)')
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('findnick') then
										if args then
											local find_nicks_user_number = 0
											find_list = ''
											cursor, errorString = db_bot:execute("select * from cf_users where `username` != 'NONE' ORDER BY id")
											row = cursor:fetch ({}, "a")
											while row do
												find_nicks_user_number = (find_nicks_user_number) + 1
												if row.username:find(args) then
													userid = row.userid
													find_list = find_list..'\n'..convertToSmile((find_nicks_user_number))..' @id'..userid..' – '..row.username
												end
												row = cursor:fetch(row, "a")
											end
											if find_list == '' then
												VkMessage('&#10060; Пользователи, никнейм которых содержит '..args..', отсутствуют.')
											else
												VkMessage('&#128101; Список найденных пользователей:\n\n'..find_list)
											end
											find_nicks_user_number = 0
										else
											UseCommand('/getbynick [часть ника]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/nlist') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('nlist') then
										users_list = ''
										cursor, errorString = db_bot:execute("select * from cf_users where `username` != 'NONE' ORDER BY id")
										row = cursor:fetch ({}, "a")
										while row do
											all_users_with_name = tonumber(all_users_with_name) + 1
											users_list = users_list..'\n'..convertToSmile(all_users_with_name)..' @id'..row.userid..'('..getUserNameVk(row.userid)..') – '..row.username
											row = cursor:fetch(row, "a")
										end
										if users_list == '' then
											VkMessage('&#10060; Пользователи с установленными никнеймами отсутствуют.')
										else
											VkMessage('&#128101; Список пользователей с установленными никнеймами:\n\n'..users_list)
										end
										all_users_with_name = 0
									else
										NoDostupToCommand()
									end
							elseif text:find('^/addkick') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('addkick') then
										nickname = text:match('^/addkick (.*)')
										if nickname then
											if not isUserInsertIntoKicklist(nickname) then
												db_bot:execute("INSERT INTO `kicklist` (`nickname`) VALUES ('"..nickname.."')")
												VkMessage('&#9999; Игрок '..nickname..' добавлен в список')
											else
												VkMessage('&#10060; Данный игрок уже есть в списке.')
											end
										else
											UseCommand('/addkick [никнейм]')
										end
									else
										NoDostupToCommand()
									end
								elseif text:find('^/removekick') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('removekick') then
										nickname = text:match('^/removekick (.*)')
										if nickname then
											if isUserInsertIntoKicklist(nickname) then
												db_bot:execute('DELETE FROM `kicklist` where nickname = \''..nickname..'\'')
												VkMessage('&#9989; Вы успешно удалили никнейм '..nickname..' со списка игроков, которые будут автоматически кикаться при подключении к серверу.')
											else
												VkMessage('&#10060; Данного игрока и так нету в списке.')
											end
										else
											UseCommand('/removekick [никнейм]')
										end
									else
										NoDostupToCommand()
									end
								elseif text:find('^/klist') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('klist') then
										kick_nicknames_list = ''
										kick_user_number = 0
										cursor, errorString = db_bot:execute("select * from kicklist")
										row = cursor:fetch ({}, "a")
										while row do
											kick_user_number = tonumber(kick_user_number) + 1
											kick_nicknames_list = kick_nicknames_list..'\n'..convertToSmile(kick_user_number)..' '..row.nickname..' – &#128221; Занёс @id'..row.insert..'('..getUserName(row.insert)..')'
											row = cursor:fetch(row, "a")
										end
										if kick_nicknames_list == '' then
											VkMessage('&#10060; В список не добавлен еще ни один игрок.')
										else
											VkMessage('&#128101; Список игроков, которые будут автоматически кикаться при подключении к серверу:\n\n'..kick_nicknames_list)
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/nonicks') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('nonicks') then
										local users_no_nicks = 0
										nonicks_list = ''
										cursor, errorString = db_bot:execute("select * from cf_users where `username` = 'NONE' ORDER BY id")
										row = cursor:fetch ({}, "a")
										while row do
											users_no_nicks = users_no_nicks + 1
											nonicks_list = nonicks_list..'\n'..convertToSmile(users_no_nicks)..' @id'..row.userid..'('..getUserName(row.userid)..')'
											row = cursor:fetch(row, "a")
										end
										if nonicks_list == '' then
											VkMessage('&#10060; Пользователи без установленных никнеймов отсутствуют.')
										else
											VkMessage('&#128101; Список пользователей без установленных никнеймов:\n\n'..nonicks_list)
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/snick') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('snick') then
										args = text:match('^/snick (.*)')
										if args then
											id, link, nickname = args:match('^%[id(%d+)|@(.-)%] (.*)')
											if id and link and nickname then
												if #nickname <= 30 then
													setUserName(from_id, id, nickname)
												else
													VkMessage('&#128219; Максимальная длина никнейма - 30 символов.')
												end
											else
												UseCommand('/snick [@пользователь] [никнейм]')
											end
										else
											UseCommand('/snick [@пользователь] [никнейм]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/сетник') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('snick') then
										args = text:match('^/сетник (.*)')
										if args then
											id, link, nickname = args:match('^%[id(%d+)|@(.-)%] (.*)')
											if id and link and nickname then
												if #nickname <= 30 then
													setUserName(from_id, id, nickname)
												else
													VkMessage('&#128219; Максимальная длина никнейма - 30 символов.')
												end
											else
												UseCommand('/сетник [@пользователь] [никнейм]')
											end
										else
											UseCommand('/сетник [@пользователь] [никнейм]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/setnick') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('snick') then
										args = text:match('^/setnick (.*)')
										if args then
											id, link, nickname = args:match('^%[id(%d+)|@(.-)%] (.*)')
											if id and link and nickname then
												if #nickname <= 30 then
													setUserName(from_id, id, nickname)
												else
													VkMessage('&#128219; Максимальная длина никнейма - 30 символов.')
												end
											else
												UseCommand('/setnick [@пользователь] [никнейм]')
											end
										else
											UseCommand('/setnick [@пользователь] [никнейм]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/сник') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('snick') then
										args = text:match('^/сник (.*)')
										if args then
											id, link, nickname = args:match('^%[id(%d+)|@(.-)%] (.*)')
											if id and link and nickname then
												if #nickname <= 30 then
													setUserName(from_id, id, nickname)
												else
													VkMessage('&#128219; Максимальная длина никнейма - 30 символов.')
												end
											else
												UseCommand('/сник [@пользователь] [никнейм]')
											end
										else
											UseCommand('/сник [@пользователь] [никнейм]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/greetings') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('greetings') then
										local f = io.open(bot_name..'/greetings.ini', "r")
										greetings = f:read('*a')
										f:close()
										if greetings == '' then
											args = text:match('^/greetings (.*)')
											if args then
												VkMessage('&#9996; @id'..from_id..'('..getUserName(from_id)..') установил новое приветствие:\n\n'..args)
												local f = io.open(bot_name..'/greetings.ini', 'w')
												f:write(args)
												f:close()
											else
												UseCommand('/greetings [текст приветствия]')
											end
										else
											VkMessage('&#10060; @id'..from_id..'('..getUserName(from_id)..') удалил приветствие при добавлении нового участника в беседу.')
											local f = io.open(bot_name..'/greetings.ini', 'w')
											f:write('')
											f:close()
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/unban') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('unban') then
										args = text:match('^/unban (.*)')
										if args then
											id, link, banreason = args:match('%[id(.*)|@(.*)%]')
											if id and link then
												if isUserInBan(id) then
													VkMessage('&#9989; @id'..from_id..'('..getUserName(from_id)..') разблокировал пользователя @id'..id..'('..getUserName(id)..').')
													db_bot:execute("DELETE FROM `ban_list` where `banuserid` = '"..id.."'")
												else
													VkMessage('&#9989; Указанный пользователь не заблокирован.')
												end
											else
												UseCommand('/unban [@пользователь]')
											end
										else
											UseCommand('/unban [@пользователь]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/ban') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('ban') then
										args = text:match('^/ban (.*)')
										if args then
											id, link, bantime, banreason = args:match('%[id(.*)|@(.*)%] (%d+) (.*)')
											if id and link then
												giveUserBan(from_id, id, bantime, banreason)
											else
												UseCommand('/ban [@пользователь] [срок] [причина]')
											end
										else
											UseCommand('/ban [@пользователь] [срок] [причина]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/kick') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('kick') then
										args = text:match('^/kick (.*)')
										if args then
											id, link = args:match('%[id(.*)|@(.*)%]')
											if id and link then
												kickUser(from_id, id)
											else
												UseCommand('/kick [@пользователь]')
									
											end
										else
											UseCommand('/kick [@пользователь]')
											
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/кик') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('kick') then
										args = text:match('^/кик (.*)')
										if args then
											id, link = args:match('%[id(.*)|@(.*)%]')
											if id and link then
												kickUser(from_id, id)
											else
												UseCommand('/кик [@пользователь]')
											end
										else
											UseCommand('/кик [@пользователь]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/staff') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('staff') then
										cursor, errorString = db_bot:execute("select * from `cf_users`")
										staff_admins = '&#128142; Администрация:'
										staff_special_admins = '&#11088; Специальная администрация:'
										staff_doverka = '&#128142; Руководители:'
										staff_menegment = '&#128081; Владелец:'
										while row do
											if tonumber(row.userdostup) == 1 then
												staff_admins = staff_admins..'\n– @id'..row.userid..'('..getUserNameVk(row.userid)..') [до '..os.date("%X %d.%m.%Y", row.roletime)..']'
											elseif tonumber(row.userdostup) == 2 then
												staff_special_admins = staff_special_admins..'\n– @id'..row.userid..'('..getUserNameVk(row.userid)..') [до '..os.date("%X %d.%m.%Y", row.roletime)..']'
											elseif tonumber(row.userdostup) == 3 then 	
												staff_doverka = staff_doverka..'\n- @id'..row.userid..'('..getUserNameVk(row.userid)..') [до '..os.date("%X %d.%m.%Y", row.roletime)..']'
											elseif tonumber(row.userdostup) == 4 then 	
												staff_menegment = staff_menegment..'\n- @id'..row.userid..'('..getUserNameVk(row.userid)..') [до '..os.date("%X %d.%m.%Y", row.roletime)..']'
											end
											row = cursor:fetch(row, "a")
										end
										test = 'Команду выполнил: @id'..from_id..'('..getUserName(from_id)..')\n'
										if staff_admins == '&#128142; Администрация:' then staff_admins = '&#128142; Администрация:\n– Отсутствует' end
										if staff_special_admins == '&#11088; Специальная администрация:' then staff_special_admins = '&#11088; Специальная администрация:\n– Отсутствует' end
										if staff_doverka == '&#128142; Доверка:' then staff_doverka = '&#128142; Доверка:\n– Отсутствует' end
										if staff_menegment == '&#128142; Владелец:' then staff_menegment = '&#128142; Владелец:\n– Отсутствует' end
										VkMessage(string.format([[%s
%s

%s

%s

%s

]], test, staff_menegment, staff_doverka, staff_special_admins, staff_admins))
									else
										NoDostupToCommand()
									end
							elseif text:find('^/nfdel') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('nfdel') then
										command = text:match('^/nfdel (.*)')
										if command then
											if isCommandFormAutoAccept(command) then
												db_bot:execute("delete from `no_forms_list` where `word` = '"..command.."'")
												updateArrayNoFormsList()
												VkMessage('&#9999; Вы успешно убрали команду '..command..' из списка автоматического отказа форм.')
											else
												VkMessage('&#10060; Данной команды и так нету в списке автоматического принятия форм.')
											end
										else
											UseCommand('/nfdel [команда без /]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/fdel') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('fdel') then
										command = text:match('^/fdel (.*)')
										if command then
											if isCommandFormAutoAccept(command) then
												db_bot:execute("delete from `forms_list` where `word` = '"..command.."'")
												updateArrayFormsList()
												VkMessage('&#9999; Вы успешно убрали команду '..command..' из списка автоматического принятия форм.')
											else
												VkMessage('&#10060; Данной команды и так нету в списке автоматического принятия форм.')
											end
										else
											UseCommand('/fdel [команда без /]')
										end
									else
										NoDostupToCommand()
									end
								elseif text:find('^/aflist') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('aflist') then
										forms_list = ''
										cursor, errorString = db_bot:execute('select * from forms_list')
										row = cursor:fetch ({}, "a")
										if cursor then
											while row do
												forms_list = forms_list..'\n&#128313; '..row.word
												row = cursor:fetch(row, "a")
											end
										end
										if forms_list == '' then
											VkMessage('&#10060; Список команд отсутствует.')
										else
											VkMessage('&#128196; Список команд с автоматическим принятием форм:\n\n'..forms_list)
										end
									else
										NoDostupToCommand()
									end
								elseif text:find('^/fadd') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('fadd') then
										command = text:match('^/fadd (.*)')
										if command then
											if not isCommandFormAutoAccept(command) then
												db_bot:execute("INSERT INTO `forms_list` (`word`) VALUES ('"..command.."')")
												updateArrayFormsList()
												VkMessage('&#9999; Вы успешно добавили команду '..command..' в список автоматического принятия форм.')
											else
												VkMessage('&#10060; Данная команда и так есть в списке автоматического принятия форм.')
											end
										else
											UseCommand('/fadd [команда без /]')
										end
									else
										NoDostupToCommand()
									end
								elseif text:find('^/acceptlog') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('acceptlog') then
										name = text:match('^/acceptlog (.*)')
										if name then
											if not isUserInsertInToDB(name) then
												db_server:execute("UPDATE `user` SET `status` = '1' WHERE `user`.`username` = '"..name.."';")
												VkMessage('&#9999; Пользователь '..name..' подтверждён в логах')
											else
												VkMessage('&#128219; Пользователь '..name..' уже есть в списке участников.')
											end
										else
											UseCommand('/acceptlog [nickname]')
										end
									else
										NoDostupToCommand()
									end
								--elseif text:find('^/botstatus') then
								--	if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('acceptlog') then
								--		name = text:match('^/botstatus (.*)')
--
                               --             VkMessage('Статус бота: .$botstatus.')
							--		else
							--			NoDostupToCommand()
							--		end					





							--ЭТА ХУЙНЯ НЕ РАБОЧАЯ
								--elseif text:find('^/lsstart') then
									--if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('acceptlog') then
									--	name = text:match('^/lsstart (.*)')
--
                                   --         VkMessage('Не удалось запустить бота ')
									--else
										NoDostupToCommand()
								--	end					
								elseif text:find('^/createlog') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('acceptlog') then
										name, pass = text:match('^/createlog (.*) (.*)')
										if name then
											if not isUserInsertInToDB(name) then
												db_server:execute("INSERT INTO `user` (`username`, `password`, `status`) VALUES ('"..name"', '"..pass..", 1')")
												VkMessage('&#9999; Пользователь '..name..' подтверждён в логах')
											else
												VkMessage('&#128219; Пользователь '..name..' уже есть в списке участников.')
											end
										else
											UseCommand('/acceptlog [nickname]')
										end
									else
										NoDostupToCommand()
									end
								elseif text:find('^/setforumpokras') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('acceptlog') then
										name, porkas = text:match('^/setforumpokras (.*) (.*)')
										if tonumber(porkas) >= 0 and tonumber(porkas) <= 25 then
											if not isUserInsertInToDBForum(name) then
												db_forum:execute("UPDATE `xf_user` SET `user_group_id` = '"..porkas.."' WHERE `xf_user`.`username` = '"..name.."';")
												db_forum:execute("UPDATE `xf_user` SET `display_style_group_id` = '"..porkas.."' WHERE `xf_user`.`username` = '"..name.."';")
												VkMessage('&#9999; Пользователю '..name..' выдан новый покрас на форуме ['..getStatusForuPokras(porkas)..']')
											else
												VkMessage('&#128219; Пользователь '..name..' уже есть в списке участников.')
											end
										else
											UseCommand('/setforumpokras [nickname] [pokras 1-25]')
										end
									else
										NoDostupToCommand()
									end
								elseif text:find('^/setpasslog') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('acceptlog') then
										name, pass = text:match('^/setpasslog (.*) (.*)')
										if name then
											if not isUserInsertInToDB(name) then
												db_server:execute("UPDATE `user` SET `password` = '"..pass.."' WHERE `user`.`username` = '"..name.."';")
												VkMessage('&#9999; Пользователю '..name..' выдан новый пароль в логах')
											else
												VkMessage('&#128219; Пользователь '..name..' уже есть в списке участников.')
											end
										else
											UseCommand('/setpasslog [nickname] [pass]')
										end
									else
										NoDostupToCommand()
									end
								elseif text:find('^/deletelog') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('acceptlog') then
										name = text:match('^/deletelog (.*)')
										if name then
											if not isUserInsertInToDB(name) then
												db_server:execute("UPDATE `user` SET `status` = '0' WHERE `user`.`username` = '"..name.."';")
												VkMessage('&#9999; Пользователь '..name..' удалён из логов')
											else
												VkMessage('&#128219; Пользователь '..name..' уже есть в списке участников.')
											end
										else
											UseCommand('/deletelog [nickname]')
										end
									else
										NoDostupToCommand()
									end
								elseif text:find('^/naflist') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('naflist') then
										no_forms_list = ''
										cursor, errorString = db_bot:execute('select * from no_forms_list')
										row = cursor:fetch ({}, "a")
										if cursor then
											while row do
												no_forms_list = no_forms_list..'\n&#128313; '..row.word
												row = cursor:fetch(row, "a")
											end
										end
										if no_forms_list == '' then
											VkMessage('&#10060; Список команд отсутствует.')
										else
											VkMessage('&#128196; Список команд с автоматическим отказом форм:\n\n'..no_forms_list)
										end
									else
										NoDostupToCommand()
									end
								elseif text:find('^/nfadd') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('nfadd') then
										command = text:match('^/nfadd (.*)')
										if command then
											if not isCommandFormNoAutoAccept(command) then
												db_bot:execute("INSERT INTO `no_forms_list` (`word`) VALUES ('"..command.."')")
												updateArrayNoFormsList()
												VkMessage('&#9999; Вы успешно добавили команду '..command..' в список автоматического не принятия форм.')
											else
												VkMessage('&#10060; Данная команда и так есть в списке автоматического не принятия форм.')
											end
										else
											UseCommand('/nfadd [команда без /]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/vig') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('vig') then
										args = text:match('^/vig (.*)')
										if args then
											id, link = args:match('%[id(.*)|@(.*)%]')
											if id and link then
												giveUserVig(from_id, id)
											else
												UseCommand('/vig [@пользователь]')
											end
										else
											UseCommand('/vig [@пользователь]')
										end
									else
										NoDostupToCommand()
									end
								elseif text:find('^/warn') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('warn') then
										args = text:match('^/warn (.*)')
										if args then
											id, link = args:match('%[id(.*)|@(.*)%]')
											if id and link then
												giveUserWarn(from_id, id)
											else
												UseCommand('/warn [@пользователь]')
											end
										else
											UseCommand('/warn [@пользователь]')
										end
									else
										NoDostupToCommand()
									end
								elseif text:find('^/unwarn') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('unwarn') then
										args = text:match('^/unwarn (.*)')
										if args then
											id, link = args:match('%[id(.*)|@(.*)%]')
											if id and link then
												removeWarnUser(from_id, id)
											else
												UseCommand('/unwarn [@пользователь]')
											end
										else
											UseCommand('/unwarn [@пользователь]')
										end
									else
										NoDostupToCommand()
									end
								elseif text:find('^/unvig') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('unvig') then
										args = text:match('^/unvig (.*)')
										if args then
											id, link = args:match('%[id(.*)|@(.*)%]')
											if id and link then
												removeVigUser(from_id, id)
											else
												UseCommand('/unvig [@пользователь]')
											end
										else
											UseCommand('/unvig [@пользователь]')
										end
									else
										NoDostupToCommand()
									end
								elseif text:find('^/demote') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('demote') then
										VkMessage('&#128528; @id'..from_id..'('..getUserName(from_id)..') запустил ПОЛНУЮ расформировку участников беседы (исключение: администрация беседы).')
										local result = luaVkApi.getConversationMembers(chat_id, group_id)
										for k, v in ipairs(t) do
											if tonumber(v.member_id) > 0 and tostring(v.is_admin) == 'nil' then
												table.insert(all_conference_users, v.member_id)
											end
										end
										for i = 1, #all_conference_users do
											luaVkApi.removeChatUser((tonumber(chat_id)), tonumber(all_conference_users[i]))
											db_bot:execute("DELETE FROM `cf_users` where `userid` = '"..all_conference_users[i].."'")
										end
										all_conference_users = {}
									else
										NoDostupToCommand()
									end
							elseif text:find('^/zovy') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('zov') then
										call_reason = text:match('^/zovy (.*)')
										if call_reason then
											callUsersVk(from_id, call_reason)
										else
											UseCommand('/zovy [причина вызова]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/zov') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('zov') then
										call_reason = text:match('^/zov (.*)')
										if call_reason then
											callUsers(from_id, call_reason)
										else
											UseCommand('/zov [причина вызова]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/зов') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('zov') then
										call_reason = text:match('^/зов (.*)')
										if call_reason then
											callUsers(from_id, call_reason)
										else
											UseCommand('/зов [причина вызова]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/вызов') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('zov') then
										call_reason = text:match('^/вызов (.*)')
										if call_reason then
											callUsers(from_id, call_reason)
										else
											UseCommand('/вызов [причина вызова]')
										end
									else
										NoDostupToCommand()
									end								
							elseif text:find('^/iwl') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('iwl') then
										args = text:match('^/iwl (.*)')
										if args then
											id, link = args:match('%[id(.*)|@(.*)%]')
											if id and link then
												if not isUserInsertInToDB(id) then
													db_bot:execute("INSERT INTO `cf_users` (`userdostup`, `userid`, `username`, `warns`, `vigs`, `mutetime`, `messages`, `lastmessage_date`, `messages_in_minute`) VALUES (0, '"..id.."', 'NONE', 0, 0, 0, 0, '"..os.time().."', 0)")
													VkMessage('&#9999; Пользователь @id'..id..' добавлен в список участников беседы.')
												else
													VkMessage('&#128219; Пользователь @id'..id..' уже есть в списке участников.')
												end
											else
												UseCommand('/iwl [@пользователь]')
											end
										else
											UseCommand('/iwl [@пользователь]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/mtop') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('mtop') then
										message_top = ''
										local user_number = 0
										cursor, errorString = db_bot:execute("select * from `cf_users` ORDER BY messages DESC LIMIT 0, 10")
										if cursor then
											row = cursor:fetch ({}, "a")
											while row do
												user_number = user_number + 5
												message_top = message_top..'\n'..convertToSmile(user_number)..' @id'..row.userid..'('..getUserName(row.userid)..') – '..row.messages..'сообщ.'
												row = cursor:fetch(row, "a")
											end
										end
										if message_top == '' then
											VkMessage('&#9940; ТОП 10 по сообщениям еще не сформировался.')
										else
											VkMessage('&#128081; ТОП 10 пользователей по сообщениям:\n\n'..message_top)
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/clearchat') then
								clearChat()
							elseif text:find('^/unmute') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('unmute') then
										args = text:match('^/unmute (.*)')
										if args then
											id, link = args:match('%[id(.*)|@(.*)%]')
											if id and link then
												removeUserMute(from_id, id)
											else
												UseCommand('/unmute [@пользователь]')
											end
										else
											UseCommand('/unmute [@пользователь]')
										end
									else
										NoDostupToCommand()
									end
								elseif text:find('^/унмут') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('unmute') then
										args = text:match('^/унмут (.*)')
										if args then
											id, link = args:match('%[id(.*)|@(.*)%]')
											if id and link then
												removeUserMute(from_id, id)
											else
												UseCommand('/унмут [@пользователь]')
											end
										else
											UseCommand('/унмут [@пользователь]')
										end
									else
										NoDostupToCommand()
									end
								elseif text:find('^/mute') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('mute') then
										args = text:match('^/mute (.*)')
										if args then
											id, link, mutetime, mutereason = args:match('%[id(.*)|@(.*)%] (%d+) (.*)')
											if id and link and mutetime and mutereason then
												giveUserMute(from_id, id, mutetime, mutereason)
											else
												UseCommand('/mute [@пользователь] [время] [причина]')
											end
										else
											UseCommand('/mute [@пользователь] [время] [причина]')
										end
									else
										NoDostupToCommand()
									end
								elseif text:find('^/мут') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('mute') then
										args = text:match('^/мут (.*)')
										if args then
											id, link, mutetime, mutereason = args:match('%[id(.*)|@(.*)%] (%d+) (.*)')
											if id and link and mutetime and mutereason then
												giveUserMute(from_id, id, mutetime, mutereason)
											else
												UseCommand('/мут [@пользователь] [время] [причина]')
											end
										else
											UseCommand('/мут [@пользователь] [время] [причина]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/q$') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('q') then
										if tonumber(getUserLevelDostup(from_id)) >= 4 then
											VkMessage('@id'..from_id..' вы не можете покинуть эту конференцию. Потому что вы Основатель')
										else
											luaVkApi.removeChatUser((tonumber(chat_id)), tonumber(from_id))
											db_bot:execute("DELETE FROM `cf_users` where `userid` = '"..from_id.."'")
											VkMessage('@id'..from_id..' покинул данную конференцию.')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/правила') then
									last_dat = '12.03.2024'
									VkMessage('&#9940; Запрещено: \n 1. Пересылать информацию из бота кому либо не из ФД (vig/снятие) \n 2. Выдача битков через бота (vig) \n 3. Нарушение работоспособности бота (vig) \n 4. Писать от лица бота всякую хуйню (vig) \n 5. Быть долбаёбом \n\n &#9989; Разрешено: \n 1. Использовать бота по назначению \n 2. Банить ебланов, сливающие админку \n 3. Все остальное, что не запрещено \n\n &#127760; Последнее обновление: '..last_dat)
							elseif text:find('/ifind') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('ifind') then
										name_find_item = text:match('/ifind (.*)')
										if name_find_item then
											find_item = true
											sendInput('/finditem '..name_find_item)
										else
											UseCommand('/ifind [Название предмета]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/aslet (%d+) (%d+) (%d+) (%d+)') then
								if not auto_slet then
									id_type, slet_id, teleport_time, opra_or_no = text:match('^/aslet (%d+) (%d+) (%d+) (%d+)')
									if tonumber(id_type) >= 0 and tonumber(id_type) <= 2 then
										if tonumber(slet_id) >= 0 and tonumber(slet_id) <= 1300 then
											if tonumber(teleport_time) >= 5 and tonumber(teleport_time) <= 600 then
												if tonumber(opra_or_no) >= 0 and tonumber(opra_or_no) <= 1 then
													if tonumber(id_type) == 0 then
														name_type = 'Дом'
													elseif tonumber(id_type) == 1 then
														name_type = 'Бизнес'
													end
													if tonumber(opra_or_no) == 0 then
														name_opra = 'Опровержение на ловлю не нужно'
													elseif tonumber(opra_or_no) == 1 then
														name_opra = 'Опровержение на ловлю нужно'
													end
													threekeyboard_vk('&#10071; Перед запуском мероприятия проверьте все параметры. Вы можете слить чужое имущество!')
													start_button = true
												else
													VkMessage('&#128683; Неверно указан параметр о запросе опровержения.')
												end
											else
												VkMessage('&#128683; Время телепорта может быть не меньше 5 секунд и не больше 600 секунд.')
											end
										else
											VkMessage('&#128683; Неверно указан ID имущества.')
										end
									else
										VkMessage('&#128683; Неверно указан тип имущества.')
									end
								else
									VkMessage('&#128683; Автоматический слёт уже запущен, попробуйте позже.')
								end
							elseif text:find('^/opra') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('aopra') then
										autoopra = not autoopra
										sendInput('/a [VK] '..getUserName(from_id)..' '..(autoopra and 'включил' or 'выключил')..' автоопровержение.')
										sendInput('/vr [VK] '..getUserName(from_id)..' '..(autoopra and 'включил' or 'выключил')..' автоопровержение.')
										VkMessage('&#128680; @id'..from_id..'('..getUserName(from_id)..') '..(autoopra and 'включил' or 'выключил')..' автоопровержение.')
									else
										NoDostupToCommand()
									end
							elseif text:find('^/interaction (%d+)') then
								cd = text:match('^/interaction (%d+)')
								checkParametrs(config[2][1], 'КД на отправку информации взаимодействии с ботом изменено на: '..cd..'sec.', cd)
							elseif text:find('^/stock (%d+)') then
								cd = text:match('^/stock (%d+)')
								checkParametrs(config[3][1], 'КД на отправку информации о акциях изменено на: '..cd..'sec.', cd)
							elseif text:find('^/ques (%d+)') then
								cd = text:match('^/ques (%d+)')
								checkParametrs(config[4][1], 'КД на проведение викторин через вопрос изменено на: '..cd..'sec.', cd)
							elseif text:find('^/captcha (%d+)') then
								cd = text:match('^/captcha (%d+)')
								checkParametrs(config[1][1], 'КД на проведение капч изменено на: '..cd..'sec.', cd)
							elseif text:find('^/skin (%d+)') then
								cd = text:match('^/skin (%d+)')
								checkParametrs(config[6][1], 'КД на проведение виктор через отгадывание числа изменено на: '..cd..'sec.', cd)
							elseif text:find('^/padmins (%d+)') then
								cd = text:match('^/padmins (%d+)')
								checkParametrs(config[8][1], 'КД на информацию о заявках на администратора изменено на: '..cd..'sec.', cd)
							elseif text:find('^/pvk (%d+)') then
								cd = text:match('^/pvk (%d+)')
								checkParametrs(config[5][1], 'КД на рекламу групы ВК изменено на: '..cd..'sec.', cd)
							elseif text:find('^/aopra (%d+)') then
								cd = text:match('^/aopra (%d+)')
								checkParametrs(config[7][1], 'Время работы автоопры в PayDay изменено на: '..cd..'sec.', cd)
							elseif text:find('^/floodrep (%d+)') then
								cd = text:match('^/floodrep (%d+)')
								checkParametrs(config[9][1], 'Время флуда репорта изменён на: '..cd..'sec.', cd)
							elseif text:find('^/nrg') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('settings') then
										cd = text:match('/nrg (%d+)')
										if cd then
											if tonumber(cd) >= 0 and tonumber(cd) <= 1800 then
												cfg.cooldowns.nrg = cd
												VkMessage('&#128344; Теперь получение НРГ через бота в VIP чате доступно 1 раз в '..convertToMinutes(cd))
												inicfg.save(cfg, bot_name..".ini")
											else
												UseCommand('/nrg [время в секундах (0-1800)]')
											end
										else
											UseCommand('/nrg [время в секундах (0-1800)]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/spawn') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('settings') then
										cd = text:match('/spawn (%d+)')
										if cd then
											if tonumber(cd) >= 0 and tonumber(cd) <= 1800 then
												cfg.cooldowns.spawn = cd
												VkMessage('&#128344; Теперь получение спавна через бота в VIP чате доступно 1 раз в '..convertToMinutes(cd))
												inicfg.save(cfg, bot_name..".ini")
											else
												UseCommand('/spawn [время в секундах (0-1800)]')
											end
										else
											UseCommand('/spawn [время в секундах (0-1800)]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/flip') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('settings') then
										cd = text:match('/flip (%d+)')
										if cd then
											if tonumber(cd) >= 0 and tonumber(cd) <= 1800 then
												cfg.cooldowns.flip = cd
												VkMessage('&#128344; Теперь получение флипа через бота в VIP чате доступно 1 раз в '..convertToMinutes(cd))
												inicfg.save(cfg, bot_name..".ini")
											else
												UseCommand('/flip [время в секундах (0-1800)]')
											end
										else
											UseCommand('/flip [время в секундах (0-1800)]')
										end
									else
										NoDostupToCommand()
									end
								elseif text:find('^/teleport') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('settings') then
										cd = text:match('/teleport (%d+)')
										if cd then
											if tonumber(cd) >= 0 and tonumber(cd) <= 1800 then
												cfg.cooldowns.teleport = cd
												VkMessage('&#128344; Теперь телепорт через бота в VIP чате доступен 1 раз в '..convertToMinutes(cd))
												inicfg.save(cfg, bot_name..".ini")
											else
												UseCommand('/teleport [время в секундах (0-1800)]')
											end
										else
											UseCommand('/teleport [время в секундах (0-1800)]')
										end
									else
										NoDostupToCommand()
									end
								elseif text:find('^/infernus') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('settings') then
										cd = text:match('/infernus (%d+)')
										if cd then
											if tonumber(cd) >= 0 and tonumber(cd) <= 1800 then
												cfg.cooldowns.infernus = cd
												VkMessage('&#128344; Теперь получение Инфернуса через бота в VIP чате доступно 1 раз в '..convertToMinutes(cd))
												inicfg.save(cfg, bot_name..".ini")
											else
												UseCommand('/infernus [время в секундах (0-1800)]')
											end
										else
											UseCommand('/infernus [время в секундах (0-1800)]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/checkbusiness (%d+) (%d+)') then
								min_biz, max_biz = text:match('^/checkbusiness (%d+) (%d+)')
								local f = io.open(bot_name..'/Logs/checkbusinessis_ban.ini', 'w')
								f:write('')
								f:close()
								if not check_biz then
									if tonumber(min_biz) < tonumber(max_biz) then
										if tonumber(min_biz) >= 0 and tonumber(max_biz) <= 360 then
											if (tonumber(max_biz) - tonumber(min_biz)) <= 40 then
												VkMessage('&#8987; Ожидайте, начинаю собирать информацию. Проверка будет длиться ~ '..tonumber(("%.1f"):format((tonumber(max_biz) - tonumber(min_biz))*0.75))..'сек. [1 бизнес - 750 мс].')
												check_biz = true
												sendInput('/checkbiz '..min_biz)
											else
												VkMessage('&#128683; Нельзя проверять более 40 бизнесов за один раз (из-за органичения длины сообщения в VK)!')
											end
										else
											VkMessage('&#128683; Параметры промежутка бизнесов указаны неверно!')
										end
									else
										VkMessage('&#128683; ID начального бизнеса не может быть меньше IDa конечного бизнеса!')
									end
								end
							elseif text:find('^/checkhouse (%d+) (%d+)') then
								min_house, max_house = text:match('^/checkhouse (%d+) (%d+)')
								local f = io.open(bot_name..'/Logs/checkhousis_ban.ini', 'w')
								f:write('')
								f:close()
								if not check_house then
									if tonumber(min_house) < tonumber(max_house) then
										if tonumber(min_house) >= 0 and tonumber(max_house) <= 1300 then
											if (tonumber(max_house) - tonumber(min_house)) <= 40 then
												VkMessage('&#8987; Ожидайте, начинаю собирать информацию.\n-- Проверка будет длиться ~ '..tonumber(("%.1f"):format((tonumber(max_house) - tonumber(min_house))*0.75))..'сек. [1 дом - 750 мс].')
												check_house = true
												sendInput('/checkhouse '..min_house)
											else
												VkMessage('&#128683; Нельзя проверять более 40 домов за один раз (из-за органичения длины сообщения в VK)!')
											end
										else
											VkMessage('&#128683; Параметры промежутка домов указаны неверно!')
										end
									else
										VkMessage('&#128683; ID начального дома не может быть меньше IDa конечного дома!')
									end
								end
							elseif text:find('^/startskin') then
								startSkin()
								VkMessage('&#128084; Запустил капчу на рандомный скин. Ожидайте победителя!')
							elseif text:find('^/mesto') then
								sendInput('/setint '..bot_name..' 0')
								sendInput('/setvw '..bot_name..' 0')
								runCommand('!pos -810.18 2830.79 1501.98')
								VkMessage('Хорошо мой господин, я уже на месте.')
							elseif text:find('^/gowork') then
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								sendInput('/a РАБОТАТЬ')
								VkMessage('&#128084; Скрипт профлудил админам')
							elseif text:find('^/players') then
								get_players_list = true
								runCommand('!players')
							elseif text:find('^/editcmd') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('editcmd') then
										command, level_dostup = text:match('^/editcmd (.*) (%d+)')
										if command and level_dostup then 
											if isCommandExists(command) then
												if tonumber(level_dostup) >= 0 and tonumber(level_dostup) <= 4 then
													db_bot:execute("UPDATE `cmdlist` set custom_rank = "..level_dostup.." where command = '"..command.."'")
													VkMessage('&#9999; Вы успешно изменили уровень доступа к команде '..command..'. Теперь эта команда доступа с ранга '..getStatusNameByLevelDostup(level_dostup)..'.')
													updateArrayCommands()
												else
													UseCommand('/editcmd [команда] [уровень доступа (0 – 4)].\n\n&#128081; Уровни доступа:\n&#128313; 0 – пользователь.\n&#128313; 1 – администратор.\n&#128313; 2 – специальный администратор.\n&#128313; 3 – руководитель.\n&#128313; 4 – основатель.\n\n&#9881; Для сброса всех кастомных рангов для доступа к команде используйте команду >dcmd.')
												end
											else
												VkMessage('&#9940; Указанной команды не существует.')
											end
										else
											UseCommand('/editcmd [команда] [уровень доступа (0 – 4)].\n\n&#128081; Уровни доступа:\n&#128313; 0 – пользователь.\n&#128313; 1 – администратор.\n&#128313; 2 – специальный администратор.\n&#128313; 3 – руководитель.\n&#128313; 4 – основатель.\n\n&#9881; Для сброса всех кастомных рангов для доступа к команде используйте команду >dcmd.')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/rkick') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('rkick') then
										args = text:match('^/rkick (.*)')
										if args then
											id, link = args:match('^%[id(%d+)|(.*)%]')
											if id and link then
												VkMessage('&#10060; @id'..from_id..'('..getUserName(from_id)..') исключил всех пользователей, добавленных пользователем @id'..id..'('..getUserName(id)..').')
												local result = luaVkApi.getConversationMembers(chat_id, group_id)
												for k, v in ipairs(t) do
													if tonumber(v.member_id) > 0 and tonumber(v.invited_by) == tonumber(id) then
													table.insert(all_conference_users, v.member_id)
												end
												end
												for i = 1, #all_conference_users do
													luaVkApi.removeChatUser((tonumber(chat_id)), tonumber(all_conference_users[i]))
													db_bot:execute("DELETE FROM `cf_users` where `userid` = '"..all_conference_users[i].."'")
												end
												all_conference_users = {}	
											else
												UseCommand('/rkick [@пользователь]')
											end
										else
											UseCommand('/rkick [@пользователь]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('/om') then
								playernick, id_type, bizids = text:match('/om (.*) (%d+) (.*)')
								if tonumber(id_type) == 0 then
									name_type = 'Дом'
									runCommand('/unjail '..playernick..' опровержение не принято')
									runCommand('/unjailoff '..playernick..' опровержение не принято')
									runCommand('/sethouseowner '..bizids..' '..bot_name) 
									VkMessage('&#128056; Игрок '..playernick..' выпущен из деморгана по причине "опровержение не принято".('..name_type..')')
								end
								if tonumber(id_type) == 1 then
									name_type = 'Бизнес'
									runCommand('/unjail '..playernick..' опровержение не принято')
									runCommand('/unjailoff '..playernick..' опровержение не принято')
									runCommand('/setbizowner '..bizids..' '..bot_name) 
									VkMessage('&#128056; Игрок '..playernick..' выпущен из деморгана по причине "опровержение не принято".('..name_type..')')
								else
									UseCommand('/om [никнейм игрока] (0 - дом 1 - бизнес) [id дома/Биза]')
								end
							elseif text:find('^/aleaders') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('aleaders') then
										local find_results, take_leaders, free_leaders = '', 0, 0
										local response = requests.get('https://logs.firework-games.online/data/leaders.php', {headers={["user-agent"] = "Mozilla/5.0", ["cookie"] = "PHPSESSID=440744beec8a924ca60e9b134bc8ff85"}})
										local text_response = u8:decode(response.text);
										for line in text_response:gmatch('[^\n]+') do
											if line:find('%<a href="../data/logsaccount.php?name=(.*)"%>(.*)%</a%>') then
												nick1, nick2 = line:match('%<a href="../data/logsaccount.php?name=(.*)"%>(.*)%</a%>')
												find_results = find_results..'\n'..convertToSmile(org_id)..' &#128188; '..nick2
												take_leaders = take_leaders + 1
											elseif line:find('%<td%>Свободна%</td%>\n%<td%>(.*)%</td%>') then
												org_name = line:match('%<td%>Свободна%</td%>\n%<td%>(.*)%</td%>')
												find_results = find_results..'\n'..convertToSmile(org_id)..' '..org_name..' – &#128188; Свободна'
												free_leaders = free_leaders + 1
											end
										end
										VkMessage('&#128269; | Список лидеров сервера:\n'..find_results..'\n\n&#11088; Занятых лидерок: '..convertToSmile(take_leaders)..'\n&#11088; Свободных лидерок: '..convertToSmile(free_leaders))
									else
										NoDostupToCommand()
									end
							elseif text:find('/checkban') then
								playernick = text:match('/checkban (.*)')
								if playernick then
									checkban_player = true
									sendInput('/unban '..playernick..' проверка на наличие бана')
								else
									UseCommand('/checkban [никнейм игрока]')
								end
							if v.object.message.action and v.object.message.action.member_id then 
								if v.object.message.action.type == 'chat_kick_user' then
									db_bot:execute("DELETE FROM `cf_users` where `userid` = '"..v.object.message.action.member_id.."'")
								elseif v.object.message.action.type == ('chat_invite_user' or 'chat_invite_user_by_link') then
									local new_user_id = v.object.message.action.member_id
									if isUserInBan(new_user_id) then
										VkMessage('&#9940; Пользователь @id'..new_user_id..'('..getUserName(new_user_id)..') заблокирован пользователем @id'..getUserBanByAdmin(new_user_id)..'('..getUserName(getUserBanByAdmin(new_user_id))..').\n&#128203; Причина блокировки: '..getUserBanReason(new_user_id))
										luaVkApi.removeChatUser((tonumber(chat_id)), tonumber(v.object.message.action.member_id))
									else
										local f = io.open(bot_name..'/greetings.ini', "r")
										greetings = f:read('*a')
										f:close()
										if cfg.config.check_on_public and not isUserSubscribeOnGroup(new_user_id) then
											VkMessage('&#9940; Пользователь @id'..new_user_id..'('..getUserName(new_user_id)..') не состоит в паблике @public'..cfg.config.check_public_link..'('..getGroupNameById(cfg.config.check_public_link)..').')
											db_bot:execute("DELETE FROM `cf_users` where `userid` = '"..new_user_id.."'")
											luaVkApi.removeChatUser((tonumber(chat_id)), tonumber(new_user_id))
										else
											db_bot:execute("INSERT INTO `cf_users` (`userdostup`, `userid`, `username`, `warns`, `vigs`, `mutetime`, `messages`, `lastmessage_date`, `messages_in_minute`) VALUES (0, '"..new_user_id.."', 'NONE', 0, 0, 0, 0, '"..os.time().."', 0)")
											if greetings ~= '' then
												VkMessage('@id'..new_user_id..'('..getUserName(new_user_id)..'), '..greetings)
											end
										end
									end
								end
							end
							elseif text:find('^/help') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('help') then
									sendHelpMessage(from_id, message_id)
								else
									NoDostupToCommand()
								end
							elseif text:find('^/settings') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('settings') then
									send_info_settings()
								else
									NoDostupToCommand()
								end
							elseif text:find('/ac') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('ac') then
										form = text:match('/ac (.*)')
										if form then
											if form ~= '' then
												if (form:match("^/ot") or form:match("additem") or form:match("setfd") or form:match("addbiz") or form:match("addhouse") or form:match("cmd") or form:match("setstat") or form:match("giverub") or form:match("addcode") or form:match("topadmin") or form:match("givechass") or form:match("asellbiz") or form:match("asellhouse") or form:match("giveitem") or form:match("sethouseowner")  or form:match("setbizowner") or form:match("awarn") or form:match("makefulldostup") or form:match("makefulldostupoff") or form:match("awarnoff") or form:match("makeadmin") or form:match("makeadminoff")) and tonumber(getUserLevelDostup(from_id)) <= 3 then
													VkMessage('&#10060; Данное действие нельзя вызвать!')
												else
													if form:match("/unban (.*)") then
														give_unban_form = true
													end
													runCommand(form)
													get_message_from_server = true
												end
											end
										else
											UseCommand('/ac [действие]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find("^/makeadmin (.*) (%d+)") and not get_ip_information then
								id, lvl = text:match("^/makeadmin (.*) (%d+)")
								if id then
									if id then
										sendInput('/makeadmin '..id..' '..lvl)
										VkMessage('Команду выполнил: @id'..from_id..'('..getUserName(from_id)..')\n\n[MakeAdmin] '..bot_name..'[0] установил '..lvl..' уровень администратора игроку '..id)
									end
								else
									UseCommand('/makeadmin [name] [lvl]')
								end
							elseif text:find("^/a (.*)") and not get_ip_information then
								form = text:match("^/a (.*)")
								if form then
									if form ~= '' then
										sendInput('/a '..form)
										VkMessage('Команду выполнил: @id'..from_id..'('..getUserName(from_id)..')\n\n[A] '..bot_name..'[0]: '..form)
									end
								else
									UseCommand('/a [Text]')
								end
							elseif text:find("^/vr (.*)") and not get_ip_information then
								form = text:match("^/vr (.*)")
								if form then
									runCommand('/vr '..form)
									VkMessage('Команду выполнил: @id'..from_id..'('..getUserName(from_id)..')\n\n[ADMIN] '..bot_name..'[0]: '..form)
								else
									UseCommand('/vr [Text]')
								end
							elseif text:find('/cban') then
								name = text:match('/cban (.*)')
								if name then
									sendInput('/banoff 0 '..name..' 2000 До разбирательств')
									sendInput('/ban '..name..' 30 До разбирательств')
									VkMessage('Команду выполнил: @id'..from_id..'('..getUserName(from_id)..')\n\nА: '..bot_name' забанил игрока '..name..'. Причина: До разбирательств')
								else
									UseCommand('/cban [name adm]')
								end
							elseif text:find("^/regcheck (.*)") and not get_ip_information then
								checkid = text:match("^/regcheck (.*)")
								if checkid then
									get_ip_information = true
									type_ip_information = 2
									sendInput('/getip '..checkid)
								else
									UseCommand('/regcheck [ID]')
								end
							elseif text:find('/checkadmb') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('acb') then
										VkMessage('&#128344; Проверка запущена, примерное время ожидания '..tonumber(("%.1f"):format(265*1.50))..'сек.')
										abusiness_check_list = ''
										check_business_admin = true
										sendInput('/checkbiz 0')
										acheckbizid = 0
									else
										NoDostupToCommand()
									end
							elseif text:find('/checkhouseadm') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('ach') then
										VkMessage('&#128344; Проверка запущена, примерное время ожидания '..tonumber(("%.1f"):format(265*1.50))..'сек.')
										ahouse_check_list = ''
										check_house_admin = true
										sendInput('/checkhouse 0')
										acheckhouseid = 0
									else
										NoDostupToCommand()
									end
							elseif text:find('/is') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('is') then 
									VkMessage([[&#128190; Список кодов значений для изменения статистики:
								
0&#8419; Уровень
1&#8419; Уважения
2&#8419; Пол
3&#8419; VIP статус
4&#8419; Номер телефона
5&#8419; Работа
6&#8419; Счёт в банке
7&#8419; AZ монеты
8&#8419; Очки фермера
9&#8419; Место спавна [0-3] 
1&#8419;0&#8419; AZ рубли
1&#8419;1&#8419; ADD VIP
1&#8419;2&#8419; Бесконечный ADD VIP

									]])
									else
										NoDostupToCommand()
									end
							elseif text:find('^/fnick') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('fnick') then
										playernick = text:match('^/fnick (.*)')
										if playernick then
											change_log = ''
											cursor, errorString = db_bot:execute("select * from `nicklogs` where `before` = '"..playernick.."'")
											row = cursor:fetch ({}, "a")
											while row do
												change_log = change_log..'\n&#128198; '..unix_decrypt(row.date)..' '..row.before..' &#9193; '..row.after..'.'
												row = cursor:fetch(row, "a")
											end
											if change_log == '' then
												VkMessage('&#128683; Указанный игрок не изменял никнейм.')
											else
												VkMessage('&#128373; | Список найденных изменений:\n\n'..change_log)
											end
										else
											UseCommand('/fnick [никнейм игрока]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('/astats') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('astats') then
										adminnick = text:match('/astats (.*)')
										if adminnick then
											get_admin_info = true
											sendInput('/checkoff '..adminnick)
										else
											UseCommand('/astats [никнейм администратора]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/checkinv') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('checkinv') then
										nickname = text:match('^/checkinv (.*)')
										if nickname then
											if isAccountExists(nickname) then
												VkMessage('&#128190; Инвентарь игрока '..nickname..':\n\n№ слота | Название предмета [количество | заточка]\n'..getPlayerInvItems(nickname)..'\n\n&#128373; | Последнее обновление списка предметов: '..unix_decrypt(cfg.config.update_items))
											else
												VkMessage('&#10060; Указанного аккаунта не существует.')
											end
										else
											UseCommand('/checkinv [никнейм]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('/check') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('check') then
										infocheck = text:match('/check (.*)')
										if infocheck then
											if isAccountExists(infocheck) then
													if infocheck == 'sanechka' or infocheck == ''..bot_name..'' or infocheck == 'Molodoy_Nalletka' or infocheck == 'Bell_King' or infocheck == 'Utopia_Boss' or infocheck == 'server' then 
														VkMessage('&#10060; | Данного игрока запрещено проверять.') return false 
													end
														newTask(function()
															cursor,errorString = db_server:execute("select * from `accounts` where `NickName` = '"..infocheck.."'")
															row = cursor:fetch ({}, "a")
															if cursor then
																while row do
																	get_ip_information = true
																	type_ip_information = 4
																	chip(tostring(row.RegIP) .. " " .. tostring(row.OldIP))
																	row = cursor:fetch(row, "a")
																end
															end
														end)
											else
												VkMessage('&#10060; | Указанного аккаунта не существует.')
											end
										else
											UseCommand('/check [никнейм]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find("/logs") then
										logname = text:match("/logs (.*)")
										if logname then
											if logname then
												test = db_server:execute("SELECT * FROM `logs` WHERE `Text` LIKE '%"..logname.."%';")
												VkMessage(test)
											else
												UseCommand('/logs ')
											end
										else
											UseCommand('/logs ')
										end
							elseif text:find("/cp") and not get_check_punish then
										checkp_id = text:match("/cp (%d+)")
										if checkp_id then
											if isPlayerConnected(tonumber(checkp_id)) then
												get_check_punish = true
												sendInput('/checkpunish '..checkp_id)
											else
												VkMessage('&#10060; Указанный игрок не в сети!')
											end
										else
											UseCommand('/cp [ID]')
										end
							elseif text:find('^/dlist') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('dlist') then
										white_l = ''
										cursor, errorString = db_bot:execute('select * from whitelist')
										row = cursor:fetch ({}, "a")
										if cursor then
											while row do
												white_l = white_l..'\n'..convertToSmile((white_user_number))..' '..row.gamenick
												row = cursor:fetch(row, "a")
											end
										end
										if white_l == '' then
											VkMessage('&#10060; Пользователи, которые имеют доступ к боту в игре отсутствуют.')
										else
											VkMessage('&#128196; Список пользователей, у которых имеется доступ к управлению ботом в игре:\n\n'..white_l)
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/twl') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('twl') then
										player_name = text:match('^/twl (.*)')
										if player_name then
											if isUserHaveDostupInGame(player_name) then
												db_bot:execute("delete from `whitelist` where `gamenick` = '"..player_name.."'")
												updateArrayWhiteList()
												VkMessage('&#9989; Вы успешно забрали доступ к управлению ботом в игре у игрока '..player_name..'.')
											else
												VkMessage('&#10060; У данного пользователя и так нету доступа к управлению ботом в игре.')
											end
										else
											UseCommand('/twl [никнейм]')
										end
									else
										NoDostupToCommand()
									end
								elseif text:find('^/al') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('gwl') then
										player_name = text:match('^/al (.*)')
										if player_name then
											if not isUserHaveDostupInGame(player_name) then
												get_status_for_give_whitelist = true
												sendInput('/checkoff '..player_name)
											else
												VkMessage('&#10060; У данного пользователя уже есть доступ к управлению ботом в игре.')
											end
										else
											UseCommand('/al [никнейм]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('/multiac') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('multiac') then
										local command_number = 0
										forms = text:match('/multiac (.*)')
										if forms then
											if forms ~= '' then
												if (forms:match("^/ot") or forms:match("additem") or forms:match("asellbiz") or forms:match("asellhouse") or forms:match("sethouseowner") or forms:match("setbizowner") or forms:match("awarn") or forms:match("makefulldostup") or forms:match("makefulldostupoff") or forms:match("awarnoff") or forms:match("makeadmin") or forms:match("makeadminoff")) and tonumber(getUserLevelDostup(from_id)) <= 1 then
													VkMessage('&#10060; Данное действие нельзя вызвать!')
												else
													multiline_message = ''
													if forms:match("/unban (.*)") then
														give_unban_form = true
													end
													for asdsa in forms:gmatch("[^\r\n]+") do
														command_number = command_number + 1
													end
													VkMessage('&#128344; Начинаю выполнять задачу. Время ожидания ~ '..tonumber(("%.1f"):format((command_number)*0.25))..'сек.')
													forms = forms:gsub('  ', '')
													newTask(function ()
														for asdsa in forms:gmatch("[^\r\n]+") do
															runCommand(asdsa)
															get_message_from_server_multiline = true
															wait(500)
														end
														VkMessage("&#9989; Мультидействие выполнено.\n&#128172; Сообщения от сервера: "..forms)
														command_number = 0
													end)
												end
											end
										else
											UseCommand('/multiac [действия] -- каждое действие с новой строки')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/rec') then
								VkMessage('&#8618; Начинаю перезаходить на сервер...')
								reconnect(0)
							elseif text:find('^/reload') then
								VkMessage('Окей , перезапускаю бота!')
								runCommand('!reloadlua')
							elseif text:find('^/admins$') and not requestadmins then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('admins') then
									send_info_admins()
								else
									NoDostupToCommand()
								end
							elseif text:find('^admins$') and not requestadmins then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('admins') then
									send_info_adminsls()
								else
									NoDostupToCommand()
								end
							elseif text:find('^/orgsonline$') and not requestorgmembers then
								requestorgmembers = true
								runCommand('/orgmembers')
								newTask(function()
									wait(2000)
									local f = io.open(bot_name..'/orgmembers.ini', "r")
									orgonline_list = f:read('*a')
									f:close()
									VkMessage('&#128101; Онлайн организаций:\n\n'..orgonline_list)
									local f = io.open(bot_name..'/orgmembers.ini', 'w')
									f:write('')
									f:close()
									requestorgmembers = false
								end)
							elseif text:find('^/leaders$') and not requestleaders then
								requestleaders = true
								runCommand('/leaders')
								newTask(function()
									wait(2000)
									if tonumber(leadernum) > 0 then
										local f = io.open(bot_name..'/leaders.ini', "r")
										leader_list = f:read('*a')
										f:close()
										VkMessage('&#128101; Лидеры онлайн [Всего: '..leadernum..']:\n\n'..leader_list)
									else
										VkMessage('&#128683; На данный момент на сервере нету ни одного лидера онлайн!')
									end
									local f = io.open(bot_name..'/leaders.ini', 'w')
									f:write('')
									f:close()
									requestleaders = false
									leadernum = 0
								end)
							elseif text:find('^/online$') and not requestonline then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('online') then
									send_info_online()
								else
									NoDostupToCommand()
								end
							elseif text:find('^/onlinestats') then
								keyboard_vk('&#128200; Выберите тип статистики онлайна:', 'onl')
							elseif text:find('^/reportstats') then
								keyboard_vk('&#128200; Выберите тип статистики репорта:', 'rep')
							elseif text:find('^/adminstats') then
								keyboard_vk('&#128200; Выберите тип статистики админ. онлайна:', 'adm')
							elseif text:find('^/reports') then
								send_info_report()
							elseif text:find('^/startmycaptcha (%d+)') then
								item = text:match('/startmycaptcha (%d+)')
								if tonumber(item) < 2709 then
									startMyCaptcha(item)
									VkMessage('&#128290; Рандомная капча на предмет №'..item..' запущена.')
								else
									VkMessage('&#10060; Предмета №'..item..' не существует, возможно вы допустили ошибку.')
								end
							elseif text:find('^/bowner (%d+)') then
								business_id = text:match('/bowner (%d+)')
								get_business = true
								sendInput('/checkbiz '..business_id)
								newTask(function()
									wait(1000)
									VkMessage('&#127978; Бизнес №'..bid..'\n&#128100; Владелец: '..owner..'\nЗаместитель: '..deputy_owner..'\n&#128176; Деньги в банке бизнеса: '..business_money..'.')
									get_business = false
								end)
								--команды лс
							elseif text:find('^nick') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('snick') then
									args = text:match('^nick (.*)')
									if args then
										id, link, nickname = args:match('^%[id(%d+)|@(.-)%] (.*)')
										if id and link and nickname then
											if #nickname <= 30 then
												setNickName(from_id, id, nickname, user_id)
											else
												vk_request_user(user_id,'&#128219; Максимальная длина никнейма - 30 символов.')
											end
										else
											UseCommandls('nick [@пользователь] [никнейм]')
										end
									else
										UseCommandls('nick [@пользователь] [никнейм]')
									end
								else
									NoDostupToCommand()
								end
							elseif text:find('^al') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('gwl') then
									player_name = text:match('^al (.*)')
									if player_name then
										if not isUserHaveDostupInGame(player_name) then
											get_status_for_give_whitelist = true
										else
											vk_request_user(user_id, '&#10060; У данного пользователя уже есть доступ к управлению ботом в игре.')
										end
									else
										UseCommandls('al [никнейм]')
									end
								else
									NoDostupToCommand()
								end
							elseif text:find('^iwl') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('iwl') then
									args = text:match('^iwl (.*)')
									if args then
										id, link = args:match('%[id(.*)|@(.*)%]')
										if id and link then
											if not isUserInsertInToDB(id) then
												db_bot:execute("INSERT INTO `cf_users` (`userdostup`, `userid`, `username`, `warns`, `vigs`, `mutetime`, `messages`, `lastmessage_date`, `messages_in_minute`) VALUES (0, '"..id.."', 'NONE', 0, 0, 0, 0, '"..os.time().."', 0)")
												vk_request_user(user_id, '&#9999; Пользователь @id'..id..' добавлен в список участников беседы.')
											else
												vk_request_user(user_id, '&#128219; Пользователь @id'..id..' уже есть в списке участников.')
											end
										else
											UseCommandls('iwl [@пользователь]')
										end
									else
										UseCommandls('iwl [@пользователь]')
									end
								else
									NoDostupToCommand()
								end
							elseif text:find('^removekick') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('removekick') then
									nickname = text:match('^removekick (.*)')
									if nickname then
										if isUserInsertIntoKicklist(nickname) then
											db_bot:execute('DELETE FROM `kicklist` where nickname = \''..nickname..'\'')
											vk_request_user(user_id, '&#9989; Вы успешно удалили никнейм '..nickname..' со списка игроков, которые будут автоматически кикаться при подключении к серверу.')
										else
											vk_request_user(user_id, '&#10060; Данного игрока и так нету в списке.')
										end
									else
										UseCommandls('removekick [никнейм]')
									end
								else
									NoDostupToCommand()
								end				
						elseif text:find('^greetings') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('greetings') then
									local f = io.open(bot_name..'/greetings.ini', "r")
									greetings = f:read('*a')
									f:close()
									if greetings == '' then
										args = text:match('^greetings (.*)')
										if args then
											vk_request_user(user_id, '&#9996; @id'..from_id..'('..getUserName(from_id)..') установил новое приветствие:\n\n'..args)
											local f = io.open(bot_name..'/greetings.ini', 'w')
											f:write(args)
											f:close()
										else
											UseCommandls('greetings [текст приветствия]')
										end
									else
										vk_request_user(user_id, '&#10060; @id'..from_id..'('..getUserName(from_id)..') удалил приветствие при добавлении нового участника в беседу.')
										local f = io.open(bot_name..'/greetings.ini', 'w')
										f:write('')
										f:close()
									end
								else
									NoDostupToCommand()
								end
						elseif text:find('^staff') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('staff') then
									cursor, errorString = db_bot:execute("select * from `cf_users`")
									staff_admins = '&#128142; Администрация:'
									staff_special_admins = '&#11088; Специальная администрация:'
									staff_doverka = '&#128142; Руководители:'
									staff_menegment = '&#128081; Владелец:'
									while row do
										if tonumber(row.userdostup) == 1 then
											staff_admins = staff_admins..'\n– @id'..row.userid..'('..getUserNameVk(row.userid)..') [до '..os.date("%X %d.%m.%Y", row.roletime)..']'
										elseif tonumber(row.userdostup) == 2 then
											staff_special_admins = staff_special_admins..'\n– @id'..row.userid..'('..getUserNameVk(row.userid)..') [до '..os.date("%X %d.%m.%Y", row.roletime)..']'
										elseif tonumber(row.userdostup) == 3 then 	
											staff_doverka = staff_doverka..'\n- @id'..row.userid..'('..getUserNameVk(row.userid)..') [до '..os.date("%X %d.%m.%Y", row.roletime)..']'
										elseif tonumber(row.userdostup) == 4 then 	
											staff_menegment = staff_menegment..'\n- @id'..row.userid..'('..getUserNameVk(row.userid)..') [до '..os.date("%X %d.%m.%Y", row.roletime)..']'
										end
										row = cursor:fetch(row, "a")
									end
									test = 'Команду выполнил: @id'..from_id..'('..getUserName(from_id)..')\n'
									if staff_admins == '&#128142; Администрация:' then staff_admins = '&#128142; Администрация:\n– Отсутствует' end
									if staff_special_admins == '&#11088; Специальная администрация:' then staff_special_admins = '&#11088; Специальная администрация:\n– Отсутствует' end
									if staff_doverka == '&#128142; Доверка:' then staff_doverka = '&#128142; Доверка:\n– Отсутствует' end
									if staff_menegment == '&#128142; Владелец:' then staff_menegment = '&#128142; Владелец:\n– Отсутствует' end
									vk_request_user(user_id, string.format([[%s
%s

%s

%s

%s

]], test, staff_menegment, staff_doverka, staff_special_admins, staff_admins))
								else
									NoDostupToCommand()
								end		
								
							elseif text:find('^admlist') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('staff') then
									cursor, errorString = db_bot:execute("select * from `cf_users`")
									staff_admins = '&#128142; Администрация:'
									staff_special_admins = '&#11088; Специальная администрация:'
									staff_doverka = '&#128142; Тех Администраторы:'
									staff_zga = '&#128081; ЗГА:'
									staff_ga = '&#128081; ГА:'
									staff_menegment = '&#128081; Владелец:'
									while row do
										if tonumber(row.userdostup) == 1 then
											staff_admins = staff_admins..'\n– @id'..row.userid..'('..row.nickname..')'
										elseif tonumber(row.userdostup) == 2 then
											staff_special_admins = staff_special_admins..'\n– @id'..row.nickname..'('..row.nickname..') '
										elseif tonumber(row.userdostup) == 3 then 	
											staff_doverka = staff_doverka..'\n- @id'..row.userid..'('..row.nickname..') '
										elseif tonumber(row.userdostup) == 4 then 	
											staff_zga = staff_zga..'\n- @id'..row.userid..'('..row.nickname..') '
										elseif tonumber(row.userdostup) == 5 then 	
											staff_ga = staff_ga..'\n- @id'..row.userid..'('..row.nickname..') '
										elseif tonumber(row.userdostup) == 6 then 	
											staff_menegment = staff_menegment..'\n- @id'..row.userid..'('..row.nickname..') '		
										end
										row = cursor:fetch(row, "a")
									end
									
									if staff_admins == '&#128142; Администрация:' then staff_admins = '&#128142; Администрация:\n– Отсутствует' end
									if staff_special_admins == '&#11088; Специальная администрация:' then staff_special_admins = '&#11088; Специальная администрация:\n– Отсутствует' end
									if staff_doverka == '&#128142; Тех Администрация:' then staff_doverka = '&#128142; Тех Администрация:\n– Отсутствует' end
									if staff_zga == '&#128142; ЗГА:' then staff_zga = '&#128142; ЗГА:\n– Отсутствует' end
									if staff_ga == '&#128142; ГА:' then staff_ga = '&#128142; ГА:\n– Отсутствует' end
									if staff_menegment == '&#128142; Владелец:' then staff_menegment = '&#128142; Владелец:\n– Отсутствует' end
									vk_request_user(user_id, string.format([[
%s										

%s

%s

%s

%s

%s

]], staff_zga, staff_ga, staff_menegment, staff_doverka, staff_special_admins, staff_admins))
								else
									NoDostupToCommand()
								end	
							elseif text:find('^listadm') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('staff') then
									cursor, errorString = db_bot:execute("select * from `admin`")
									lvl1 = '&#128142; Админы 1 уровня:'
									lvl2 = '&#128142; Админы 2 уровня:'
									lvl3 = '&#128142; Админы 3 уровня:'
									lvl4 = '&#128081; Админы 4 уровня:'
									lvl5 = '&#128081; Админы 5 уровня:'
									lvl6 = '&#128081; Админы 6 уровня:'
                                    lvl7 = '&#128081; Админы 7 уровня:'
									lvl8 = '&#128081; Админы 8 уровня:'
									while row do
										if tonumber(row.level) == 1 then
											lvl1 = lvl1..'\n– '..row.name..''
										elseif tonumber(row.level) == 2 then
											lvl2 = lvl2..'\n– '..row.name..''
										elseif tonumber(row.level) == 3 then 	
											lvl3 = lvl3..'\n- '..row.name..''
										elseif tonumber(row.level) == 4 then 	
											lvl4 = lvl4..'\n- '..row.name..''
										elseif tonumber(row.level) == 5 then 	
											lvl5 = lvl5..'\n- '..row.name..''
										elseif tonumber(row.level) == 6 then 	
											lvl6 = lvl6..'\n- '..row.name..''	
										elseif tonumber(row.level) == 7 then 	
											lvl7 = lvl7..'\n- '..row.name..''
										elseif tonumber(row.level) == 8 then 	
											lvl8 = lvl8..'\n- '..row.name..''			
										end
										row = cursor:fetch(row, "a")
									end
									
									if lvl1 == '&#128142; Админы 1 лвл:' then lvl1 = '&#128142; Админы 1 лвл:\n– Отсутствует' end
									if lvl2 == '&#128142; Админы 2 лвл:' then lvl2 = '&#128142; Админы 2 лвл:\n– Отсутствует' end
									if lvl3 == '&#128142; Админы 3 лвл:' then lvl3 = '&#128142; Админы 3 лвл:\n– Отсутствует' end
									if lvl4 == '&#128142; Админы 4 лвл:' then lvl4 = '&#128142; Админы 4 лвл:\n– Отсутствует' end
									if lvl5 == '&#128142; Админы 5 лвл:' then lvl5 = '&#128142; Админы 5 лвл:\n– Отсутствует' end
									if lvl6 == '&#128142; Админы 6 лвл:' then lvl6 = '&#128142; Админы 6 лвл:\n– Отсутствует' end
									if lvl7 == '&#128142; Админы 7 лвл:' then lvl7 = '&#128142; Админы 7 лвл:\n– Отсутствует' end
									if lvl8 == '&#128142; Админы 8 лвл:' then lvl8 = '&#128142; Админы 8 лвл:\n– Отсутствует' end
									vk_request_user(user_id, string.format([[
%s										

%s

%s

%s

%s

%s

%s

%s

]], lvl8, lvl7, lvl6, lvl5, lvl4, lvl3, lvl2, lvl1))
								else
									NoDostupToCommand()
								end														
							elseif text:find('^acceptlog') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('acceptlog') then
									name = text:match('^acceptlog (.*)')
									if name then
										if not isUserInsertInToDB(name) then
											db_server:execute("UPDATE `user` SET `status` = '1' WHERE `user`.`username` = '"..name.."';")
											vk_request_user(user_id, '&#9999; Пользователь '..name..' подтверждён в логах')
										else
											vk_request_user(user_id, '&#128219; Пользователь '..name..' уже есть в списке участников.')
										end
									else
										UseCommandls('acceptlog [nickname]')
									end
								else
									NoDostupToCommand()
								end
							 
							elseif text:find('^deletelog') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('acceptlog') then
									name = text:match('^deletelog (.*)')
									if name then
										if not isUserInsertInToDB(name) then
											db_server:execute("UPDATE `user` SET `status` = '0' WHERE `user`.`username` = '"..name.."';")
											vk_request_user(user_id, '&#9999; Пользователь '..name..' удалён из логов')
										else
											vk_request_user(user_id, '&#128219; Пользователь '..name..' уже есть в списке участников.')
										end
									else
										UseCommandls('deletelog [nickname]')
									end
								else
									NoDostupToCommand()
								end
						elseif text:find('^zov') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('zov') then
									call_reason = text:match('^zov (.*)')
									if call_reason then
										callUsers(from_id, call_reason)
									else
										UseCommandls('zov [причина вызова]')
									end
								else
									NoDostupToCommand()
								end
						elseif text:find('^зов') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('zov') then
									call_reason = text:match('^зов (.*)')
									if call_reason then
										callUsers(from_id, call_reason)
									else
										UseCommandls('зов [причина вызова]')
									end
								else
									NoDostupToCommand()
								end
						elseif text:find('^вызов') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('zov') then
									call_reason = text:match('^вызов (.*)')
									if call_reason then
										callUsers(from_id, call_reason)
									else
										UseCommandls('вызов [причина вызова]')
									end
								else
									NoDostupToCommand()
								end
						elseif text:find('^правила') then
								last_dat = '12.03.2024'
								vk_request_user(user_id, '&#9940; Запрещено: \n 1. Пересылать информацию из бота кому либо не из ФД (vig/снятие) \n 2. Выдача битков через бота (vig) \n 3. Нарушение работоспособности бота (vig) \n 4. Писать от лица бота всякую хуйню (vig) \n 5. Быть долбаёбом \n\n &#9989; Разрешено: \n 1. Использовать бота по назначению \n 2. Банить ебланов, сливающие админку \n 3. Все остальное, что не запрещено \n\n &#127760; Последнее обновление: '..last_dat)																
						elseif text:find('^mesto') then
							sendInput('/setint '..bot_name..' 0')
							sendInput('/setvw '..bot_name..' 0')
							runCommand('!pos -810.18 2830.79 1501.98')
							vk_request_user(user_id, 'Хорошо мой господин, я уже на месте.')
						elseif text:find('^editcmd') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('editcmd') then
									command, level_dostup = text:match('^editcmd (.*) (%d+)')
									if command and level_dostup then 
										if isCommandExists(command) then
											if tonumber(level_dostup) >= 0 and tonumber(level_dostup) <= 4 then
												db_bot:execute("UPDATE `cmdlist` set custom_rank = "..level_dostup.." where command = '"..command.."'")
												vk_request_user(user_id, '&#9999; Вы успешно изменили уровень доступа к команде '..command..'. Теперь эта команда доступа с ранга '..getStatusNameByLevelDostup(level_dostup)..'.')
												updateArrayCommands()
											else
												UseCommandls('editcmd [команда] [уровень доступа (0 – 4)].\n\n&#128081; Уровни доступа:\n&#128313; 0 – пользователь.\n&#128313; 1 – администратор.\n&#128313; 2 – специальный администратор.\n&#128313; 3 – руководитель.\n&#128313; 4 – основатель.\n\n&#9881; Для сброса всех кастомных рангов для доступа к команде используйте команду >dcmd.')
											end
										else
											vk_request_user(user_id, '&#9940; Указанной команды не существует.')
										end
									else
										UseCommandls('editcmd [команда] [уровень доступа (0 – 4)].\n\n&#128081; Уровни доступа:\n&#128313; 0 – пользователь.\n&#128313; 1 – администратор.\n&#128313; 2 – специальный администратор.\n&#128313; 3 – руководитель.\n&#128313; 4 – основатель.\n\n&#9881; Для сброса всех кастомных рангов для доступа к команде используйте команду >dcmd.')
									end
								else
									NoDostupToCommand()
								end
						elseif text:find('^om') then
							playernick, id_type, bizids = text:match('/om (.*) (%d+) (.*)')
							if tonumber(id_type) == 0 then
								name_type = 'Дом'
								runCommand('/unjail '..playernick..' опровержение не принято')
								runCommand('/unjailoff '..playernick..' опровержение не принято')
								runCommand('/sethouseowner '..bizids..' '..bot_name) 
								vk_request_user(user_id, '&#128056; Игрок '..playernick..' выпущен из деморгана по причине "опровержение не принято".('..name_type..')')
							end
							if tonumber(id_type) == 1 then
								name_type = 'Бизнес'
								runCommand('/unjail '..playernick..' опровержение не принято')
								runCommand('/unjailoff '..playernick..' опровержение не принято')
								runCommand('/setbizowner '..bizids..' '..bot_name) 
								vk_request_user(user_id, '&#128056; Игрок '..playernick..' выпущен из деморгана по причине "опровержение не принято".('..name_type..')')
							else
								UseCommandls('om [никнейм игрока] (0 - дом 1 - бизнес) [id дома/Биза]')
							end
						elseif text:find('^checkban') then
							playernick = text:match('checkban (.*)')
							if playernick then
								checkban_player = true
								sendInput('/unban '..playernick..' проверка на наличие бана')
							else
								UseCommandls('checkban [никнейм игрока]')
							end
						elseif text:find('^help') then
							if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('help') then
								sendHelpMessage(from_id, message_id)
							else
								NoDostupToCommand()
							end
						elseif text:find("^makeadmin (.*) (%d+)") and not get_ip_information then
							id, lvl = text:match("^makeadmin (.*) (%d+)")
							if id then
								if id then
									sendInput('/makeadmin '..id..' '..lvl)
									end
							else
								UseCommandls('makeadmin [name] [lvl]')
							end
						elseif text:find('^cban') then
							name = text:match('cban (.*)')
							if name then
								sendInput('/banoff '..name..' 2000 До разбирательств')
								sendInput('/ban '..name..' 30 До разбирательств')
							else
								UseCommandls('cban [name adm]')
							end
						elseif text:find('^is') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('is') then 
								vk_request_user(user_id, [[&#128190; Список кодов значений для изменения статистики:
							
0&#8419; Уровень
1&#8419; Уважения
2&#8419; Пол
3&#8419; VIP статус
4&#8419; Номер телефона
5&#8419; Работа
6&#8419; Счёт в банке
7&#8419; AZ монеты
8&#8419; Очки фермера
9&#8419; Место спавна [0-3] 
1&#8419;0&#8419; AZ рубли
1&#8419;1&#8419; ADD VIP
1&#8419;2&#8419; Бесконечный ADD VIP

								]])
								else
									NoDostupToCommand()
								end
						elseif text:find('astats') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('astats') then
									adminnick = text:match('astats (.*)')
									if adminnick then
										get_admin_info = true
										sendInput('/checkoff '..adminnick)
									else
										UseCommandls('astats [никнейм администратора]')
									end
								else
									NoDostupToCommand()
								end
						elseif text:find('^tech') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('q') then
									zapros = text:match('^tech (.*)')
									if zapros then
										db_server:execute("INSERT INTO `tech`( `tech`, `userid`) VALUES ('"..zapros.."', "..from_id..")")								
										VkMessage('&#9992; Ваше обращение технической администрации успешно отправлено!')
									
									else
										UseCommand('tech запрос')
									end
								else
									NoDostupToCommand()
								end
						elseif text:find('^/жб') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('acceptlog') then
									id, otv = text:match('^/жб (%d+) (.*)')
									if id or otv then
										white_l = ''
										cursor, errorString = db_server:execute('select * from cf_users where nickname = '..id..'')
										row = cursor:fetch ({}, "a")
										if tonumber(row.id) == 1 then
											VkMessage('Данное обращение рассмотрено')
										else
											if cursor then
												while row do
													white_l = 'На вас поступила жалоба'..otv
													row = cursor:fetch(row, "a")
												end
											end
											cursor, errorString = db_bot:execute('select * from cf_users where nickname = '..id..'')
											row1 = cursor:fetch ({}, "a")
											if white_l == '' then
												VkMessage('Неверный ник')
											else
												VkMessage('Вы успешно отправили уведомление ')
												vk_request_user(''..row1.userid..'',''..white_l..'')
												
											end
										end
									else
										UseCommand('/')
									end
								else
									NoDostupToCommand()
								end
						elseif text:find('^/sendtech') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('acceptlog') then
									id, otv = text:match('^/sendtech (%d+) (.*)')
									if id or otv then
										white_l = ''
										cursor, errorString = db_server:execute('select * from tech where id = '..id..'')
										row = cursor:fetch ({}, "a")
										if tonumber(row.status) == 1 then
											VkMessage('Данное обращение рассмотрено')
										else
											if cursor then
												while row do
													white_l = 'Вам пришёл ответ по вашему обращению: '..otv
													row = cursor:fetch(row, "a")
												end
											end
											cursor, errorString = db_bot:execute('select * from tech where id = '..id..'')
											row1 = cursor:fetch ({}, "a")
											if white_l == '' then
												VkMessage('Неверный ИД обращения')
											else
												VkMessage('Вы успешно ответили на обращение №'..id..'.')
												vk_request_user(''..row1.userid..'',''..white_l..'')
												db_bot:execute("UPDATE `tech` SET `status` = '1' WHERE `tech`.`id` = '"..id.."';")
											end
										end
									else
										UseCommand('/sendtech [id] [otvet]')
									end
								else
									NoDostupToCommand()
								end
				    	elseif text:find('^/infotech') then
							if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('dlist') then
								id = text:match('infotech (%d+)')
									white_l = ''
									cursor, errorString = db_bot:execute('select * from tech where id = '..id..'')
									row = cursor:fetch ({}, "a")
									if cursor then
										while row do
											if tonumber(row.status) <= 0 then
												techstat = 'На рассмотреннии'
											else
												techstat = 'Рассмотрен'
											end
											white_l = white_l..'\n'..row.id..' | @id'..row.userid..' | '..row.tech..' | '..techstat
											row = cursor:fetch(row, "a")
									end
								end
								if white_l == '' then
									VkMessage('&#10060; Не верный ИД обращения.')
								else
									VkMessage('&#128196; Данные обращения №'..id..'\nID | ВЛаделец | Текст | Статус\n\n'..white_l..'.')
								end
							else
								NoDostupToCommand()
							end		
				    	elseif text:find('^/techlist') then
							if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('dlist') then
								white_l = ''
								white_id = ''
								white_tech = ''
								cursor, errorString = db_bot:execute('select * from tech where status = 0 order by tech desc')
								row = cursor:fetch ({}, "a")
								if cursor then
									while row do
										white_l = white_l..'\n'..row.id..' | '..row.tech
										white_id = white_id..'\n'..convertToSmile((white_user_number))..' '..row.id
										white_tech = white_tech..'\n'..convertToSmile((white_user_number))..' '..row.tech
										row = cursor:fetch(row, "a")
									end
								end
								if white_l == '' then
									VkMessage('&#10060; Обращения отсутсвуют.')
								else
									VkMessage('&#128196; Не рассмотренные обращения:ID | Обращение:\n'..white_l..'.')
								end
							else
								NoDostupToCommand()
                            end
						elseif text:find('^rastip') then
							if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('check') then
								regip, oldip = text:match('^rastip (.*) (.*)')
								if oldip then
									get_ip_information = true
									type_ip_information = 2
									chip(tostring(regip) .. " " .. tostring(oldip))
								else
									VkMessage('Используйте: rastip (regip) (lastip)')
                                end
							end
						elseif text:find('check') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('check') then
									infocheck = text:match('check (.*)')
									if infocheck then
										if isAccountExists(infocheck) then
													newTask(function()
														cursor,errorString = db_server:execute("select * from `accounts` where `NickName` = '"..infocheck.."'")
														row = cursor:fetch ({}, "a")
														if cursor then
															while row do
																get_ip_information = true
																type_ip_information = 2
																chip(tostring(row.RegIP) .. " " .. tostring(row.OldIP))
																row = cursor:fetch(row, "a")
															end
														end
													end)
										else
											vk_request_user(user_id, '&#10060; | Указанного аккаунта не существует.')
										end
									else
										UseCommandls('check [никнейм]')
									end
								else
									NoDostupToCommand()
								end

						elseif text:find("^cp") and not get_check_punishe then
									checkp_id = text:match("^cp (%d+)")
									if checkp_id then
										if isPlayerConnected(tonumber(checkp_id)) then
											get_check_punishe = true
											sendInput('/checkpunish '..checkp_id)
										else
											vk_request_user(user_id, '&#10060; Указанный игрок не в сети!')
										end
									else
										UseCommandls('cp [ID]')
									end
						elseif text:find('^lb') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('dlist') then
									white_l = ''
									cursor, errorString = db_bot:execute('select * from whitelist')
									row = cursor:fetch ({}, "a")
									if cursor then
										while row do
											white_l = white_l..'\n'..convertToSmile((white_user_number))..' '..row.gamenick
											row = cursor:fetch(row, "a")
										end
									end
									if white_l == '' then
										vk_request_user(user_id, '&#10060; Пользователи, которые имеют доступ к боту в игре отсутствуют.')
									else
										vk_request_user(user_id, '&#128196; Список пользователей, у которых имеется доступ к управлению ботом в игре:\n\n'..white_l)
									end
								else
									NoDostupToCommand()
								end
						elseif text:find('^twl') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('twl') then
									player_name = text:match('^twl (.*)')
									if player_name then
										if isUserHaveDostupInGame(player_name) then
											db_bot:execute("delete from `whitelist` where `gamenick` = '"..player_name.."'")
											updateArrayWhiteList()
											vk_request_user(user_id, '&#9989; Вы успешно забрали доступ к управлению ботом в игре у игрока '..player_name..'.')
										else
											vk_request_user(user_id, '&#10060; У данного пользователя и так нету доступа к управлению ботом в игре.')
										end
									else
										UseCommandls('twl [никнейм]')
									end
								else
									NoDostupToCommand()
								end							
							end
						end
					end
				end
			end
		end
	end
end
function checkParametrs(name_cfg, text_vk, cd)
	if tonumber(cd) >= 30 and tonumber(cd) <= 6001 then
		local f = io.open(bot_name..'/Settings/'..name_cfg..'.txt', 'w')
		f:write(cd)
		f:close()
		UpdateTxtFiles()
		VkMessage('&#9881; '..text_vk)
		runCommand('!reloadlua')
	else
		VkMessage('&#128683; Нельзя указывать КД меньше 30 секунд или больше 6001 секунд!')
	end
end

function UpdateTxtFiles()
	for i = 1, #config do
		local f = io.open(bot_name..'/Settings/'..config[i][1]..'.txt', "r")
		config[i][2] = f:read('*a')
		f:close()
	end
end

function send_bans_housis()
	local f = io.open(bot_name..'/Logs/checkhousis_ban.ini', "r")
	house_check_list_ban = f:read('*a')
	f:close()
	if house_check_list_ban == '' then
		house_check_list_ban = '&#128683; Отсутствуют.'
	end
	VkMessage('&#127969; Дома заблокированных игроков:\n\n'..house_check_list_ban)
	local f = io.open(bot_name..'/Logs/checkhousis_ban.ini', 'w')
	f:write('')
	f:close()
end

function send_bans_businessis()
	local f = io.open(bot_name..'/Logs/checkbusinessis_ban.ini', "r")
	business_check_list_ban = f:read('*a')
	f:close()
	if business_check_list_ban == '' then
		business_check_list_ban = '&#128683; Отсутствуют.'
	end
	VkMessage('&#128450; Бизнесы заблокированных игроков:\n\n'..business_check_list_ban)
	local f = io.open(bot_name..'/Logs/checkbusinessis_ban.ini', 'w')
	f:write('')
	f:close()
end

function send_admins_stats(arg)
	local f = io.open(bot_name..'/Statistic/'..arg..'adminstatistic.ini', "r")
	report_list = f:read('*a')
	for line in io.lines(bot_name..'/Statistic/'..arg..'adminstatistic.ini') do
		strocks_admins = strocks_admins + 1
		if line:find('Администрация онлайн: (%d+)') then
			number_report = line:match('Администрация онлайн: (%d+)')
			all_admins = all_admins + number_report
		end
	end
	arithm_admonline = tonumber(math.floor((all_admins/strocks_admins)))
	if arg == 'day' then vk_text = '&#128202; Статистика админ. онлайна, собранная с 0.00 текущего дня:\n'..report_list..'\n&#128200; Средний админ. онлайн сервера ~ '..arithm_admonline
	elseif arg == 'week' then vk_text = '&#128200; Средний админ. онлайн сервера ~ '..arithm_admonline
	elseif arg == 'all' then vk_text = '&#128200; Средний админ. онлайн сервера ~ '..arithm_admonline
	end
	VkMessage(vk_text)
	f:close()
end

function send_report_stats(arg)
	local f = io.open(bot_name..'/Statistic/'..arg..'reportstatistic.ini', "r")
	report_list = f:read('*a')
	for line in io.lines(bot_name..'/Statistic/'..arg..'reportstatistic.ini') do
		strocks_report = strocks_report + 1
		if line:find('Репорт: (%d+)') then
			number_report = line:match('Репорт: (%d+)')
			all_report = all_report + number_report
		end
	end
	arithm_rep = tonumber(math.floor((all_report/strocks_report)))
	if arg == 'day' then vk_text = '&#128202; Статистика серверного репорта, собранная с 0.00 текущего дня:\n'..report_list..'\n&#128200; Средний репорт сервера ~ '..arithm_rep
	elseif arg == 'week' then vk_text = '&#128200; Средний репорт сервера ~ '..arithm_rep
	elseif arg == 'all' then vk_text = '&#128200; Средний репорт сервера ~ '..arithm_rep
	end
	VkMessage(vk_text)
	f:close()
end

function send_online_stats(arg)
		local f = io.open(bot_name..'/Statistic/'..arg..'onlinestatistic.ini', "r")
		online_list = f:read('*a')
		for line in io.lines(bot_name..'/Statistic/'..arg..'onlinestatistic.ini') do
			strocks_online = strocks_online + 1
			if line:find('Онлайн: (%d+)') then
				number_online = line:match('Онлайн: (%d+)')
				all_online = all_online + number_online
			end
		end
		arithm_online = tonumber(math.floor((all_online/strocks_online)))
		if arg == 'day' then vk_text = '&#128202; Статистика серверного онлайна, собранная с 0.00 текущего дня:\n'..online_list..'\n&#128200; Средний онлайн сервера ~ '..arithm_online
		elseif arg == 'week' then vk_text = '&#128200; Средний онлайн сервера ~ '..arithm_online
		elseif arg == 'all' then vk_text = '&#128200; Средний онлайн сервера ~ '..arithm_online
		end
		VkMessage(vk_text)
		f:close()
end

function send_info_report()
	if reports == nil then
		VkMessage('&#8987; Пока что никто не писал в репорт, попробуйте позже!')
	else
		VkMessage('&#128221; Репорта на сервере на данный момент: '..reports)
	end
end

function send_info_settings()
	VkMessage(string.format(
	[[	
&#128736; Настройки бота:

&#9654; /interaction [sec] - изменить КД на отправку информации о взаимодействии с ботом (сейчас: %sсек.);
&#9654; /stock [sec] - изменить КД на отправку информации о акциях бота (сейчас: %sсек.);
&#9654; /ques [sec] - изменить КД на проведение викторин через вопрос (сейчас: %sсек.);
&#9654; /captcha [sec] - изменить КД на проведение капч (сейчас: %sсек.);
&#9654; /skin [sec] - изменить КД на проведение викторин через отгадывание числа (сейчас: %sсек.);
&#9654; /aopra [sec] - изменить время работы автоопра в PayDay (сейчас: %sсек.);
&#9654; /padmins [sec] - изменить время рекламы заявок на админов (сейчас: %sсек.);
&#9654; /pvk [sec] - изменить время рекламы ВК группы (сейчас: %sсек.);
&#9654; /floodrep [sec] - изменить время рекламы ВК группы (сейчас: %sсек.);
 
&#10071; При изменении КД скрипт бота перезагружается!
	]]
	, config[2][2], config[7][2], config[4][2], config[3][2], config[6][2], config[8][2], config[1][2], config[5][2]), config[8][2])
end

function send_info_commands()
	VkMessage(
	[[	
&#128221; Команды бота:

&#10071; /settings - настройки бота;
&#10071; /reports - количество репорта на сервере;
&#10071; /online - онлайн сервера на данный момент;
&#10071; /admins - список администрации онлайн;
&#10071; /ac [request] - отправить запрос;
&#10071; /multiac [zapros](каждый с новой строки) - отправить многострочный запрос;
&#10071; /startcaptcha - запустить капчу на рандомный предмет;
&#10071; /startquestion - запустить вопрос на рандомный LUXE транспорт;
&#10071; /startskin - запустить отгадывание числа на рандомный скин;
&#10071; /opra - включить автоопровержение;
&#10071; /op [nick] - выпустить игрока по причине "опровержение принято";
&#10071; /om [nick] [0/1(дом/бизнес)] [ID имущества] - выпустить игрока по причине "опровержение не принято" и забрать имущество;
&#10071; /startmycaptcha [itemid] - запустить капчу на определённый предмет;
&#10071; /check [nick] - статистика игрока;
&#10071; /checkreg [nick] - проверить рег. данные игрока;
&#10071; /rec - перезапустить бота на сервер;
&#10071; /bowner [id] - узнать владельца бизнеса;
&#10071; /howner [id] - узнать владельца дома;
&#10071; /players - список игроков онлайн;
&#10071; /onlinestats - статистика серверного онлайна;
&#10071; /reportstats - статистика серверного репорта;
&#10071; /adminstats - статистика админ. онлайна;
&#10071; /fnick [nick] - поиск изменений никнейма;
&#10071; /checkban [nick] - проверить игрока на наличие бана;
&#10071; /astats [nick] - абсолютная статистика активности администратора;
&#10071; /leaders - список лидеров онлайн;
&#10071; /orgsonline - текущий онлайн всех организаций;
&#10071; /botoff - отключить бота (вы не сможете запустить его вручную!);
&#10071; /aslet [0/1(дом/бизнес)] [ID имущества] [время телепорта] [0/1(запрашивать/не запрашивать опровержение)] - запустить слет имущества;
&#10071; /snick [@user] [name] - выдать ник нейм пользователю;
&#10071; /rnick [@user] - удалить ник нейм пользователю;
&#10071; /addadmin [@user] - выдать права администратора беседы;
&#10071; /addspec [@user] - выдать права специального администратора беседы;
&#10071; /addowner [@user] - выдать права руководителя беседы;
&#10071; /iwl [@user] - прописать человека в беседе;
&#10071; /editcmd [cmd] [dostup 1-4] - изменить ранг использования команды;
&#10071; /kick [@user] - исключить пользователя из беседы;
&#10071; /a [Text] - Написать в /a чат от имени бота;
&#10071; /vr [Text] - Написать в /vr чат от имени бота;
&#10071; /makeadmin [name] [lvl] - Выдать человеку админку от имени бота;
&#10071; /cban [name] - Забанить человека до разбирательств;
	]]
	)
end

function send_info_admins()
	VkMessage('&#128222; Ожидайте, начинаю сбор информации..')
	requestadmins = true
	set_admin_list = true
	admin_list = ''
	all_admins = 0
	afk_admins = 0
	sendInput('/admins')
	newTask(function() wait(1000)
		admin_list = '&#128190; Список администрации онлайн [Всего: '..convertToSmile(all_admins)..' | AFK: '..convertToSmile(afk_admins)..']:\n\n'..admin_list
		VkMessage(admin_list)
		requestadmins = false 
	end)
end


function send_info_adminsls()
	vk_request_user(user_id, '&#128222; Ожидайте, начинаю сбор информации..')
	requestadmins = true
	set_admin_list = true
	admin_list = ''
	all_admins = 0
	afk_admins = 0
	sendInput('/admins')
	newTask(function() wait(1000)
		admin_list = '&#128190; Список администрации онлайн [Всего: '..convertToSmile(all_admins)..' | AFK: '..convertToSmile(afk_admins)..']:\n\n'..admin_list
		vk_request_user(user_id, admin_list)
		requestadmins = false 
	end)
end

function send_info_leaders()
	requestleaders = true	
	runCommand('/leaders')
	newTask(function()
	wait(2000)
	if tonumber(leadernum) > 0 then
		local f = io.open(bot_name..'/leaders.ini', "r")
		leader_list = f:read('*a')
		f:close()
		VkMessage('&#128101; Лидеры онлайн [Всего: '..leadernum..']:\n\n'..leader_list)
	else
		VkMessage('&#128683; На данный момент на сервере нету ни одного лидера онлайн!')
	end
		local f = io.open(bot_name..'/leaders.ini', 'w')
		f:write('')
		f:close()
		requestleaders = false
		leadernum = 0
	end)
end

function startCaptcha()
	for k,v in ipairs(servers_list) do
		if getIP() == v then
			item = math.random(1,  300)
			captcha = math.random(1000,9999)..'0'
			activecaptcha = true
			sendInput(randomCaptcha(item, captcha))
			captime = os.clock()
		end
	end
end

function nowHours()
	return os.date("%H", os.time())
end

function startSkin()
if tonumber(nowHours()) <= 23 and tonumber(nowHours()) >= 08 then 
	for k,v in ipairs(servers_list) do
		if getIP() == v then
			skinid = random(0, 311)
			diapazon_1 = random(0, 1000)
			numberskin = random(diapazon_1, (diapazon_1+30))
			activeskin = true
			skin_text = 'Я зaгaдaл числo oт '..diapazon_1..' до '..(diapazon_1+30)..'. Кто первый угaдает - получит Скин №'..skinid..'. Ответы в VIP-чат!'
			sendInput('/ao '..skin_text)
			skintime = os.clock()
		end
		end
	end
end

function startQuestion()
	for k,v in ipairs(servers_list) do
		if getIP() == v then
			prizeid = random(1872, 1900)
			activequestion = true
			newTask(function()
				sendInput(randomQuestion().questiontext)
				wait(500)
				sendInput('/ao Приз за верный ответ: предмет №'..prizeid..'. Если у Вас нету места в инвентаре - Вы не получите приз!')
			end)
			questime = os.clock()
		end
	end
end

function startMyCaptcha(arg)
	for k,v in ipairs(servers_list) do
		if getIP() == v then
			captcha = random(1,  300)..'0'
			activecaptcha = true
			sendInput(randomCaptcha(arg, captcha))
			captime = os.clock()
		end
	end
end


math.randomseed(os.time())

function threekeyboard_vk(msg)
	msg = AnsiToUtf8(msg)
	msg = url_encode(msg)
	local keyboard = fourVkKeyboard()
	keyboard = u8(keyboard)
	keyboard = url_encode(keyboard)
	msg = msg .. '&keyboard=' .. keyboard
	partOfVkSystem(msg)
end

function threekeyboard_vk(msg)
	msg = AnsiToUtf8(msg)
	msg = url_encode(msg)
	local keyboard = fiveVkKeyboard()
	keyboard = u8(keyboard)
	keyboard = url_encode(keyboard)
	msg = msg .. '&keyboard=' .. keyboard
	partOfVkSystem(msg)
end

function twokeyboard_vk(msg)
	msg = AnsiToUtf8(msg)
	msg = url_encode(msg)
	local keyboard = threeVkKeyboard()
	keyboard = u8(keyboard)
	keyboard = url_encode(keyboard)
	msg = msg .. '&keyboard=' .. keyboard
	partOfVkSystem(msg)
end

function keyboard_vk(msg, name_stat)
	msg = AnsiToUtf8(msg)
	msg = url_encode(msg)
	local keyboard = twoVkKeyboard(name_stat)
	keyboard = u8(keyboard)
	keyboard = url_encode(keyboard)
	msg = msg .. '&keyboard=' .. keyboard
	partOfVkSystem(msg)
end

function VkMessage(msg)
	msg = AnsiToUtf8(msg)
	msg = url_encode(msg)
	local keyboard = vkKeyboard()
	keyboard = u8(keyboard)
	keyboard = url_encode(keyboard)
	msg = msg .. '&keyboard=' .. keyboard
	partOfVkSystem(msg)
end

function VkMessageFlood(msg) msg = AnsiToUtf8(msg); msg = url_encode(msg); floodOfVkSystem(msg, two_chat_id) end

function VkMessageWithPing(msg) 
	msg = AnsiToUtf8(msg);
	msg = url_encode(msg); 
	local keyboard = Test();
	mainPartOfVkSystem(msg, two_chat_id)
end
function LogVkMessage(msg) msg = AnsiToUtf8(msg); msg = url_encode(msg); logOfVkSystem(msg, log_chat_id) end

function vkvkvk_vk(msg)
	msg = AnsiToUtf8(msg)
	msg = url_encode(msg)
	local keyboard = vkvkvk()
	keyboard = u8(keyboard)
	keyboard = url_encode(keyboard)
	msg = msg .. '&keyboard=' .. keyboard
	partOfVkSystem(msg)
end

function VkMessageWithKeyboard(msg)
	msg = AnsiToUtf8(msg)
	msg = url_encode(msg)
	local keyboard = vkKeyboard()
	keyboard = u8(keyboard)
	keyboard = url_encode(keyboard)
	msg = msg .. '&keyboard=' .. keyboard
	mainPartOfVkSystem(msg, chat_id)
end


function url_encode(str)
  local str = string.gsub(str, "\\", "\\")
  local str = string.gsub(str, "([^%w])", char_to_hex)
  return str
end

function char_to_hex(str)
  return string.format("%%%02X", string.byte(str))
end


function longpollGetKey()
	async_http_request('https://api.vk.com/method/groups.getLongPollServer?group_id=' .. group_id .. '&access_token=' .. access_token .. '&v=5.131', '', function (result)
		if result then
			if not result:sub(1,1) == '{' then
				vkerr = 'Ошибка!\nПричина: Нет соединения с VK!'
				return
			end
			local t = json.decode(result)
			if t.error then
				vkerr = 'Ошибка!\nКод: ' .. t.error.error_code .. ' Причина: ' .. t.error.error_msg
				return
			end
			server = t.response.server
			ts = t.response.ts
			key = t.response.key
			vkerr = nil
		end
	end)
end


function threadHandle(runner, url, args, resolve, reject) 
	local t = runner(url, args)
	local r = t:get(0)
	while not r do
		r = t:get(0)
		wait(0)
	end
	local status = t:status()
	if status == 'completed' then
		local ok, result = r[1], r[2]
		if ok then resolve(result) else reject(result) end
	elseif err then
		reject(err)
	elseif status == 'canceled' then
		reject(status)
	end
	t:cancel(0)
end

function requestRunner()
	return effil.thread(function(u, a)
		local https = require 'ssl.https'
		local ok, result = pcall(https.request, u, a)
		if ok then
			return {true, result}
		else
			return {false, result}
		end
	end)
end

function async_http_request(url, args, resolve, reject)
	local runner = requestRunner()
	if not reject then reject = function() end end
	newTask(function()
		threadHandle(runner, url, args, resolve, reject)
	end)
end

local vkerr, vkerrsend 

function loop_async_http_request(url, args, reject)
	local runner = requestRunner()
	if not reject then reject = function() end end
	newTask(function()
		while true do
			while not key do wait(0) end
			url = server .. '?act=a_check&key=' .. key .. '&ts=' .. ts .. '&wait=25' 
			threadHandle(runner, url, args, longpollResolve, reject)
		end
	end)
end

function distance_cord(lat1, lon1, lat2, lon2)
	if lat1 == nil or lon1 == nil or lat2 == nil or lon2 == nil or lat1 == "" or lon1 == "" or lat2 == "" or lon2 == "" then
		return 0
	end
	local dlat = math.rad(lat2 - lat1)
	local dlon = math.rad(lon2 - lon1)
	local sin_dlat = math.sin(dlat / 2)
	local sin_dlon = math.sin(dlon / 2)
	local a =
		sin_dlat * sin_dlat + math.cos(math.rad(lat1)) * math.cos(
			math.rad(lat2)
		) * sin_dlon * sin_dlon
	local c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
	local d = 6378 * c
	return d
end

function getCapitalLetter(text, mode)
    local num = 0
    local a = {}
    local b = tostring(text)

    if mode == 1 then
        string_world = 'ЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ'
    elseif mode == 2 then
        string_world = 'QWERTYUIOPASDFGHJKLZXCVBNM'
    elseif mode == 3 then
        string_world = 'ЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮQWERTYUIOPASDFGHJKLZXCVBNM'
    end

    for i = 1, #b do
        a[#a + 1] = b:sub(i, i)
    end

    for k, v in pairs(a) do
        if string.find(string_world, v, nil, true) then
            num = num + 1
        end
    end

    return num
end


function ev.onShowDialog(dialogId, dialogStyle, dialogTitle, okButtonText, cancelButtonText, dialogText)
	for k,v in ipairs(servers_list) do
		if getIP() == v then
			if dialogTitle:match('Информация о забаненном') then
				if checkban_player then
					adminnick, banreason, timetounban = dialogText:match('Блокиратор: \t{......}(.*)\n{......}Причина: \t{......}(.*)\n{......}До разблокировки: \t\t{......}(.*)')
					VkMessage('&#128683; Игрок '..playernick..' заблокирован. Информация:\n\n&#128100; Блокиратор: '..adminnick..'\n&#128196; Причина: '..banreason..'\n&#128338; До разблокировки: '..timetounban)
					checkban_player = false
					return false
				elseif check_business_ban then
					local f = io.open(bot_name..'/Logs/checkbusinessis.ini', 'a')
					f:write('&#127970; №'..min_biz..' -- &#128683; Владелец '..checkbizowner..' заблокирован.\n')
					f:close()
					local f = io.open(bot_name..'/Logs/checkbusinessis_ban.ini', 'a')
					f:write('&#127970; №'..min_biz..' -- &#128683; Владелец '..checkbizowner..' заблокирован.\n')
					f:close()
					partOfSystemCheckBiz()
				elseif check_house_ban then
					local f = io.open(bot_name..'/Logs/checkhousis.ini', 'a')
					f:write('&#127969; №'..min_house..' -- &#128683; Владелец '..checkhouseowner..' заблокирован.\n')
					f:close()
					local f = io.open(bot_name..'/Logs/checkhousis_ban.ini', 'a')
					f:write('&#127969; №'..min_house..' -- &#128683; Владелец '..checkhouseowner..' заблокирован.\n')
					f:close()
					partOfSystemCheckHouse()
				end
			end
			if dialogId == 15302 and check then
				--if not dialogText:find('%((%d+)%) (.*)\t{......}HEX{......}\t(%d+) шт%.') then
				if not dialogText:find('{9400D3}(%d+)%. {FFFFFF}(.*)\t(.*)SLI{FFFFFF}\t(%d+) шт.') then
					check = false
					updateItems()
					VkMessage('&#128373; Сканирование предметов окончено, добавлено '..convertToSmile(#items)..' '..nForm(#items, 'предмет', 'предмета', 'предметов')..'.')
					cfg.config.update_items = os.time()
					inicfg.save(cfg, bot_name..".ini")
				end
				for line in dialogText:gmatch('[^\n]+') do
					--[[if line:find('%((%d+)%) (.*)\t{......}HEX{......}\t(%d+) шт%.') then
						itemid, itemname, itemcolor = line:match('%((%d+)%) (.*)\t{(.*)}HEX{......}\t(%d+) шт%.')]]
						if line:find('{9400D3}(%d+)%. {FFFFFF}(.*)\t(.*)SLI{FFFFFF}\t(%d+) шт.') then
							itemid, itemname, itemcolor, itemkolvo = line:match('{9400D3}(%d+)%. {FFFFFF}(.*)\t(.*)SLI{FFFFFF}\t(%d+) шт.')
						db_bot:execute("INSERT INTO `items` (`id`, `name`, `color`) VALUES ("..itemid..", '"..itemname.."', '"..itemcolor.."')")
						--print('+')
					end
				end
				sendDialogResponse(15302, 1, 0, '')
			end
			if dialogTitle:find('История наказания') then 
				if get_check_punishe then 
					vk_request_user(user_id, '&#128196; История наказаний игрока:\n\n'..dialogText:gsub('{......}', '')); 
					get_check_punishe = false 
				end 
				for line in dialogText:gmatch('[^\n]+') do
					if line:find('[VK] (.*)%[(%d+)%] посадил игрока (.*)%[(%d+)%] в деморган на (%d+) минут%. Причина: (.*)') and find_string and find_opra_word then
						an, aid, pn, pid, jt, return_reason = line:match('[VK] (.*)%[(%d+)%] посадил игрока (.*)%[(%d+)%] в деморган на (%d+) минут%. Причина: (.*)')
						if check_player_on_house then
							if tostring(pn) == tostring(return_house_nick) then
								for k, v in ipairs(array_oprs_words) do
									if return_reason:match(v) and find_opra_word then
										find_opra_word = false
										for n, w in ipairs(array_house_words) do
											if return_reason:match(w) then
												estimated_housenumber = return_reason:match('(%d+)')
												sendInput('/checkhouse '..estimated_housenumber)
												check_house_owner_for_return_house = true
											end
										end
										for n, w in ipairs(array_biz_words) do
											if return_reason:match(w) then
												check_player_on_house = false
											end
										end
									else
										if find_opra_word then
											find_opra_word = false
											makeFalseForParams()
											check_player_on_house = false
										end
									end
								end
								find_string = false
								return false
							end
						end
						if check_player_on_biz then
							if tostring(pn) == tostring(return_biz_nick) then
								for k, v in ipairs(array_oprs_words) do
									if return_reason:match(v) and find_opra_word then
										find_opra_word = false
										for n, w in ipairs(array_biz_words) do
											if return_reason:match(w) then
												estimated_biznumber = return_reason:match('(%d+)')
												sendInput('/checkbiz '..estimated_biznumber)
												check_biz_owner_for_return_biz = true
											end
										end
										for n, w in ipairs(array_house_words) do
											if return_reason:match(w) then
												check_player_on_biz = false
											end
										end
									else
										if find_opra_word then
											find_opra_word = false
											makeFalseForParams()
											check_player_on_biz = false
										end
									end
								end
								find_string = false
								return false
							end
						end
					end
				end
			end			
			if dialogTitle:find('История наказания') then 
				if get_check_punish then 
					VkMessage('&#128196; История наказаний игрока:\n\n'..dialogText:gsub('{......}', '')); 
					get_check_punish = false 
				end 
				for line in dialogText:gmatch('[^\n]+') do
					if line:find('[VK] (.*)%[(%d+)%] посадил игрока (.*)%[(%d+)%] в деморган на (%d+) минут%. Причина: (.*)') and find_string and find_opra_word then
						an, aid, pn, pid, jt, return_reason = line:match('[VK] (.*)%[(%d+)%] посадил игрока (.*)%[(%d+)%] в деморган на (%d+) минут%. Причина: (.*)')
						if check_player_on_house then
							if tostring(pn) == tostring(return_house_nick) then
								for k, v in ipairs(array_oprs_words) do
									if return_reason:match(v) and find_opra_word then
										find_opra_word = false
										for n, w in ipairs(array_house_words) do
											if return_reason:match(w) then
												estimated_housenumber = return_reason:match('(%d+)')
												sendInput('/checkhouse '..estimated_housenumber)
												check_house_owner_for_return_house = true
											end
										end
										for n, w in ipairs(array_biz_words) do
											if return_reason:match(w) then
												check_player_on_house = false
											end
										end
									else
										if find_opra_word then
											find_opra_word = false
											makeFalseForParams()
											check_player_on_house = false
										end
									end
								end
								find_string = false
								return false
							end
						end
						if check_player_on_biz then
							if tostring(pn) == tostring(return_biz_nick) then
								for k, v in ipairs(array_oprs_words) do
									if return_reason:match(v) and find_opra_word then
										find_opra_word = false
										for n, w in ipairs(array_biz_words) do
											if return_reason:match(w) then
												estimated_biznumber = return_reason:match('(%d+)')
												sendInput('/checkbiz '..estimated_biznumber)
												check_biz_owner_for_return_biz = true
											end
										end
										for n, w in ipairs(array_house_words) do
											if return_reason:match(w) then
												check_player_on_biz = false
											end
										end
									else
										if find_opra_word then
											find_opra_word = false
											makeFalseForParams()
											check_player_on_biz = false
										end
									end
								end
								find_string = false
								return false
							end
						end
					end
				end
			end
			if dialogText:find('Организация') and requestorgmembers then
				for line in dialogText:gmatch('[^\n]+') do
					if line:find('{......}(.*){......}(.*) чел%.') then
						orgname, orgonline = line:match('{......}(.*){......}(.*) чел%.')
						local f = io.open(bot_name..'/orgmembers.ini', 'a')
						f:write('&#127970; '..orgname..' - &#128100; '..orgonline..' чел.\n')
						f:close()
					end
				end
			end
			if dialogText:find('{FFFFFF}Администратор{FFFFFF}Уровень{ffffff}Репутация/Выговоры{FFFFFF}Тэг') then
        		for line in dialogText:gmatch("[^\r\n]+") do
					if line:find('(.*) %[ID: (%d+)%]%[(%d+) lvl%](%d+) %- Выговоры %[(%d+)/3%]{FFFFFF}(.*){ffffff}') then
						nick, id, lvl, repa, awarns, tag = line:match('(.*) %[ID: (%d+)%]%[(%d+) lvl%](%d+) %- Выговоры %[(%d+)/3%]{FFFFFF}(.*){ffffff}')
						VkMessage('Ник администратора: '..nick..', Репутация: '..repa..', Выговоры: '..awarns..', Тэг: '..tag)
					end
				end
			end
			if dialogId == 91 and give_unban_form then
				sendDialogResponse(91, 1, 65535, '')
				give_unban_form = false
				return false
			end
			if auto_slet then
				if dialogId == 4690 and set_position then
					sendDialogResponse(4690, 1, 0, '')
					sendDialogResponse(4691, 1, 1, '')
					set_position = false
					set_name_mp = true
					sendInput('/eventmenu')
					return false
				end
				if dialogId == 4690 and set_name_mp then
					sendDialogResponse(4690, 1, 1, '')
					sendDialogResponse(4692, 1, -1, 'Слет имущества от администрации - '..name_type..' '..slet_id)
					set_name_mp = false
					set_give_hp = true
					sendInput('/eventmenu')
					return false
				end
				if dialogId == 4690 and set_give_hp then
					sendDialogResponse(4690, 1, 2, '')
					sendDialogResponse(4693, 1, -1, '100')
					set_give_hp = false
					set_give_armour = true
					sendInput('/eventmenu')
					return false
				end
				if dialogId == 4690 and set_give_armour then
					sendDialogResponse(4690, 1, 3, '')
					sendDialogResponse(4694, 1, -1, '100')
					set_give_armour = false
					set_time_teleport = true
					sendInput('/eventmenu')
					return false
				end
				if dialogId == 4690 and set_time_teleport then
					sendDialogResponse(4690, 1, 7, '')
					sendDialogResponse(4696, 1, -1, teleport_time)
					set_time_teleport = false
					start_mp = true
					sendInput('/eventmenu')
					return false
				end
				if dialogId == 4690 and start_mp then
					sendDialogResponse(4690, 1, 8, '')
					start_mp = false
					sendInput('/ao Уважаемые игроки, проходит Слёт имущества от администрации ['..name_type..' №'..slet_id..'].')
					sendInput('/ao '..name_opra..'. Для телепорта на мероприятие используйте /gotp.')
					return false
				end
				if dialogId == 4697 then
					sendDialogResponse(4697, 1, 65535, '')
					return false
				end
			end
			if find_item then
				if dialogId == 15300 then
					sendDialogResponse(15300, 1, 65535, '')
					return false
				end
				if dialogId == 15301 then
					sendDialogResponse(15301, 1, 65535, name_find_item)
					return false
				end
				if dialogText:find('По вашему запросу ничего не найдено!') then
					VkMessage('&#128683; По вашему запросу ничего не найдено!')
					find_item = false
					return false
				end
			end
			if dialogTitle:find('{BFBBBA}Поиск предмета') and find_item then
				for line in dialogText:gmatch('[^\n]+') do
					if line:find('%[(%d+)%] (.*) {FFFFFF}•{FFFFFF}') then
						id_item, name_item = line:match('%[(%d+)%] (.*) {FFFFFF}•{FFFFFF}')
						local f = io.open(bot_name..'/items_find.ini', 'a')
						f:write('&#9654; ['..id_item..'] '..name_item..'\n')
						f:close()
					end
				end
				local f = io.open(bot_name..'/items_find.ini', "r")
				items_list = f:read('*a')
				f:close()
				VkMessage('&#128270; Результат поиска:\n\n'..items_list)
				local f = io.open(bot_name..'/items_find.ini', 'w')
				f:write('')
				f:close()
				find_item = false
				return false
			end
			if dialogText:find('Через личное сообщение') then
				VkMessage('&#128041; При входе запрошено подтверждение через VK-Guard.')
			end
			if dialogId == 2 then
				sendDialogResponse(2, 1, -1, account_password)
				return false
			end
			if dialogTitle:find('Выбор места спавна') then
				sendDialogResponse(dialogId, 1, 0, '')
				return false
			end
			if dialogText:find('Введите админ%-пароль') then
				sendDialogResponse(dialogId, 1, -1, admin_password)
				return false
			end
			if get_status_for_give_whitelist then
				db_bot:execute("INSERT INTO `whitelist` (`gamenick`) VALUES ('"..player_name.."')")
				updateArrayWhiteList()
				VkMessage('&#9999; Игроку '..player_name..' успешно выдан доступ к управлению ботом в игре.')
				get_status_for_give_whitelist = false
			end
			if dialogText:find('ID в базе данных: (.*)\nНик: (.*)\nRegIP: (.*)\nLastIP: (.*)\nУровень: (.*)\nУровень Администрирования: (.*)\nДонат счет: (.*)\nДонат счет в рублях: (.*)\nДеньги: (.*)\nНомер телефона: (.*)\nДеньги в банке: (.*)\nСостояние личного счета: (.*)\nДеньги на депозите: (.*)\nОрганизация: (.*)\nДолжность: (.*)\nСемья: (.*)\nПредупреждения: (.*)\nСтатус VIP: (.*)\n\nMuteTime: (.*)\nDemorgan: (.*)\n\nДома:') then
				uid, nick, regip, lastip, level, admin_lvl, donate, rub, money, phonenumber, bankmoney, mymoney, depositemoney, org, jobtitle, family, warns, vip, skl, mutetime, demotime = dialogText:match('ID в базе данных: (.*)\nНик: (.*)\nRegIP: (.*)\nLastIP: (.*)\nУровень: (.*)\nУровень Администрирования: (.*)\nДонат счет: (.*)\nДонат счет в рублях: (.*)\nДеньги: (.*)\nНомер телефона: (.*)\nДеньги в банке: (.*)\nСостояние личного счета: (.*)\nДеньги на депозите: (.*)\nОрганизация: (.*)\nДолжность: (.*)\nСемья: (.*)\nПредупреждения: (.*)\nСтатус VIP: (.*)\n\nMuteTime: (.*)\nDemorgan: (.*)\n\nДома:')
				if check_business_admin then
					if tostring(nick) == tostring(checkbizowner) and check_business_admin and tonumber(admin_lvl) > 0 then
						abusiness_check_list = abusinessbusiness_check_list..'\n&#127970; №'..acheckbizid..' -- &#128101; '..nick..' – '..convertToSmile(admin_lvl)..' уровень админки.'
					end
					partOfSystemACheckBiz()
				end
				if check_house_admin then
					if tostring(nick) == tostring(checkhouseowner) and check_house_admin and tonumber(admin_lvl) > 0 then
						ahouse_check_list = ahouse_check_list..'\n&#127969; №'..acheckhouseid..' -- &#128101; '..nick..' – '..convertToSmile(admin_lvl)..' уровень админки.'
					end
					partOfSystemACheckHouse()
				end
			if get_admin_info then
				if test then
				end
						VkMessage(string.format([[
&#128101; Администратор: %s.
&#128190; Уровень админки: %d.

&#11088; Активность за всё время:
– Репортов отвечено: %d.
- Мероприятий проведено: %d.
– Выдано банов: %d.
– Выдано варнов: %d.
– Выдано а-варнов: %d.
– Выдано деморганов: %d.
– Выдано мутов: %d.

&#11088; Активность за текущую неделю:
– Репортов отвечено: %d.
- Мероприятий проведено: %d.
– Выдано банов: %d.
– Выдано варнов: %d.
– Выдано а-варнов: %d.
– Выдано деморганов: %d.
– Выдано мутов: %d.									
]], nick, admin_lvl, getAdminInfo(nick).all_reports, getAdminInfo(nick).all_events, getAdminInfo(nick).all_bans, getAdminInfo(nick).all_warns, getAdminInfo(nick).all_awarns, getAdminInfo(nick).all_demorgans, getAdminInfo(nick).all_mutes, getAdminInfo(nick).week_reports, getAdminInfo(nick).week_events, getAdminInfo(nick).week_bans, getAdminInfo(nick).week_warns, getAdminInfo(nick).week_awarns, getAdminInfo(nick).week_demorgans,
getAdminInfo(nick).week_mutes))
					get_admin_info = false
				end	
			end
		end
	end
	--return false
end

function ev.onSendCommand(cmd)
	if check_business_admin and (cmd ~= 'checkoff' or cmd ~= 'checkbiz') then
		return false
	elseif check_house_admin and (cmd ~= 'checkoff' or cmd ~= 'checkhouse') then
		return false
	end
end	

function chip(arg)
	ips = {}

	for tablee in string.gmatch(arg, "(%d+%p%d+%p%d+%p%d+)") do
		table.insert(ips, {query = tablee})
	end

	if #ips > 0 then
		data_json = cjson.encode(ips) 

		asyncHttpRequest("POST", "http://ip-api.com/batch?fields=16974545&lang=ru", {data = data_json}, function (check)
			rdata = cjson.decode(u8:decode(check.text))
			local distance = distance_cord(rdata[1].lat, rdata[1].lon, rdata[2].lat, rdata[2].lon)
			if type_ip_information == 1 then
				sendInput('/a '..string.format([[[REG] Страна - %s | Город - %s | Провайдер - %s ]], rdata[1].country, rdata[1].city, rdata[1].isp))
				sendInput('/a '..string.format([[[REG] Мобильный интернет: %s | Прокси или VPN: %s | Хостинг: %s ]], (rdata[1].mobile and '+' or '-'), (rdata[1].proxy and '+' or '-'), (rdata[1].hosting and '+' or '-')))
			elseif type_ip_information == 2 then 
				ip_message = '&#128190; Информация о данных игрока:\n\n&#128270; '..string.format('[REG] Регион - %s | Страна - %s | Город - %s | Провайдер - %s\n&#128246; [REG] Мобильный интернет: %s Прокси или VPN: %s Хостинг: %s', rdata[1].regionName, rdata[1].country, rdata[1].city, rdata[1].isp, (rdata[1].mobile and '&#9989;' or '&#10060;'), (rdata[1].proxy and '&#9989;' or '&#10060;'), (rdata[1].hosting and '&#9989;' or '&#10060;'))
			elseif type_ip_information == 3 then
			elseif type_ip_information == 4 then
			elseif type_ip_information == 5 then
				player_lastip_info = '['..rdata[2].country..', '..rdata[2].city..'. mobile '..(rdata[2].mobile and '+' or '-')..' | vpn/proxy '..(rdata[2].proxy and '+' or '-')..' | host '..(rdata[2].hosting and '+' or '-')..']'
				player_regip_info = '['..rdata[2].country..', '..rdata[2].city..'. mobile '..(rdata[2].mobile and '+' or '-')..' | vpn/proxy '..(rdata[2].proxy and '+' or '-')..' | host '..(rdata[2].hosting and '+' or '-')..']'
				player_distance = string.format('%d', distance)..'км'
				cursor, errorstring = db_server:execute("select * from `accounts` where `NickName` = '"..infocheck.."'")
				row = cursor:fetch ({}, "a")
				if cursor then
					while row do
						if distance >= 300 then
							vzloman('Чуть не доглядел , уже баню')
							sendInput('/banoff 0 '..infocheck..' 2000 До выяснений')
							sendInput('/ban '..infocheck..' 30 До разбирательств')
						end
						VkMessage(string.format([[&#128187; | Запрос ацепта от %s:

	&#128190; Административный LVL: %d [%d/3].

	&#128246; | Регистрационные данные:
	&#128198; Дата регистрации: %s.
	&#127757; REG-IP: %s %s.
	&#127757; LAST-IP: %s %s.
	&#127760; Расстояние между IP: %s.]], aname, row.Admin, row.datareg, row.RegIP, player_regip_info, row.OldIP, player_lastip_info, player_distance))
					end
				end
			end
			if type_ip_information == 1 then
				sendInput('/a '..string.format([[[LAST] Страна - %s | Город - %s | Провайдер - %s]], rdata[2].country, rdata[2].city, rdata[2].isp))
				sendInput('/a '..string.format([[[LAST] Мобильный интернет: %s | Прокси или VPN: %s | Хостинг: %s ]], (rdata[2].mobile and '+' or '-'), (rdata[2].proxy and '+' or '-'), (rdata[2].hosting and '+' or '-')))
				sendInput('/a '..string.format('Расстояние между REG IP и LAST IP ~ %dкм', distance))
				if distance >= 300 then
					sendInput('/ban '..checkid..' 30 До разбирательств')
					vzloman1('Чуть не доглядел , уже баню')
				end

			elseif type_ip_information == 2 then
				ip_messagee = string.format(ip_message..'\n\n&#128270; [LAST] Страна - %s | Город - %s | Провайдер - %s\n&#128246; [LAST] Мобильный интернет: %s Прокси или VPN: %s Хостинг: %s\n\n&#128204; Расстояние между REG IP и LAST IP ~%dкм', rdata[2].country, rdata[2].city, rdata[2].isp, (rdata[2].mobile and '&#9989;' or '&#10060;'), (rdata[2].proxy and '&#9989;' or '&#10060;'), (rdata[2].hosting and '&#9989;' or '&#10060;'), distance)
				VkMessage(ip_messagee)
			elseif type_ip_information == 3 then
				sendInput('/a '..string.format([[Регистрация = Провайдер: %s Страна: %s Город: %s]], rdata[2].isp, rdata[2].country, rdata[2].city))
			elseif type_ip_information == 4 then
				player_lastip_info = '['..rdata[2].country..', '..rdata[2].city..'. mobile '..(rdata[2].mobile and '+' or '-')..' | vpn/proxy '..(rdata[2].proxy and '+' or '-')..' | host '..(rdata[2].hosting and '+' or '-')..']'
				player_regip_info = '['..rdata[2].country..', '..rdata[2].city..'. mobile '..(rdata[2].mobile and '+' or '-')..' | vpn/proxy '..(rdata[2].proxy and '+' or '-')..' | host '..(rdata[2].hosting and '+' or '-')..']'
				player_distance = string.format('%d', distance)..'км'
				cursor, errorstring = db_server:execute("select * from `accounts` where `NickName` = '"..infocheck.."'")
				row = cursor:fetch ({}, "a")
				if cursor then
					while row do
						if tonumber(row.Family) == 0 then
							player_family = 'Не состоит'
						else
							player_family = row.NameFamily..' [UID: '..row.Family..']'
						end
						if tonumber(row.VIP) < 5 then
							player_vip = 'Отсутствует'
						elseif tonumber(row.VIP) == 5 then
							player_vip = 'Titan [5]'
						elseif tonumber(row.VIP) == 6 then
							player_vip = 'Premium [6]'
						elseif tonumber(row.VIP) == 7 then
							player_vip = 'Swag [7]'
						elseif tonumber(row.VIP) == 8 then
							player_vip = 'Holy [8]'
						elseif tonumber(row.VIP) == 9 then
							player_vip = 'Absolute [9]'
						elseif tonumber(row.VIP) == 10 then
							player_vip = 'Immortal [10]'
						else
							player_vip = 'Unknown ['..row.VIP..']'
						end
						if tonumber(row.TelNum) == 0 then
							player_telephone_number = 'Отсутствует'
						else
							player_telephone_number = row.TelNum
						end
						if tonumber(row.MuteTime) == 0 then
							player_mute = 'Отсутствует'
						else
							player_mute = os.date("%X", row.MuteTime)
						end
						if tonumber(row.JailTime) == 0 then
							player_jail = 'Отсутствует'
						else
							player_jail = os.date("%X", row.JailTime)
						end
						if distance >= 300 then
							vzloman('Чуть не доглядел , уже баню')
							sendInput('/banoff 0 '..infocheck..' 2000 До выяснений')
							sendInput('/ban '..infocheck..' 30 До разбирательств')
						end
						VkMessage(string.format([[&#128187; | Полученная информация по игроку %s:
	
&#127380; UID: %d.
&#128190; Игровой LVL: %d.
&#128190; Административный LVL: %d [%d/3].
&#128181; AZ coins: %d.
&#128181; AZ RUB: %d.
&#128176; Деньги на руках: $%d.
&#128176; BTC в банке: %d.
&#128176; BTC на депозите: %d.
&#9742; Номер телефона: %s.
&#128188; Ранг в организации: %d.	
&#128106; Семья: %s.
&#128219; Предупреждения: [%d/3].
&#128219; Время мута: %s.
&#128219; Время деморгана: %s.
&#128305; VIP статус: %s.

&#128246; | Регистрационные данные:
&#128198; Дата регистрации: %s.
&#127757; REG-IP: %s %s.
&#127757; LAST-IP: %s %s.
&#127760; Расстояние между IP: %s.


&#127963; | Имущество:
&#127969; Дома: %s.
&#127978; Бизнесы: %s.]], infocheck, row.ID, row.Level, row.Admin, row.AWarns, row.VirMoney, row.Roubles, row.Money, row.Bank, row.Deposit, player_telephone_number, row.Rank, player_family, row.Warns, player_mute, player_jail, player_vip, row.datareg, row.RegIP, player_regip_info, row.OldIP, player_lastip_info, player_distance, getPlayerHouses(infocheck), getPlayerBusinessis(infocheck)))
					end
				end
			end
			get_ip_information = false
		end, function (check)
		end)
	end
end

function asyncHttpRequest(method, url, args, resolve, reject)
	local request_thread = effil.thread(function(method, url, args)
		local requests = require"requests"
		local result, response = pcall(requests.request, method, url, args)
		if result then
			response.json, response.xml = nil, nil
			return true, response
		else
			return false, response
		end
	end)(method, url, args)

	if not resolve then
		resolve = function() end
	end
	if not reject then
		reject = function() end
	end
	newTask(function()
		local runner = request_thread
		while true do
			local status, err = runner:status()
			if not err then
				if status == "completed" then
					local result, response = runner:get()
					if result then
						resolve(response)
					else
						reject(response)
					end
					return
				elseif status == "canceled" then
					return reject(status)
				end
			else
				return reject(err)
			end
			wait(0)
		end
	end)
end

function getItemName(itemid)
	if items[tonumber(itemid)] then
		return items[tonumber(itemid)].name
	else
		return 'Не определено ['..tonumber(itemid)..']'
	end
end

function distance_cord(lat1, lon1, lat2, lon2)
	if lat1 == nil or lon1 == nil or lat2 == nil or lon2 == nil or lat1 == "" or lon1 == "" or lat2 == "" or lon2 == "" then
		return 0
	end
	local dlat = math.rad(lat2 - lat1)
	local dlon = math.rad(lon2 - lon1)
	local sin_dlat = math.sin(dlat / 2)
	local sin_dlon = math.sin(dlon / 2)
	local a =
		sin_dlat * sin_dlat + math.cos(math.rad(lat1)) * math.cos(
			math.rad(lat2)
		) * sin_dlon * sin_dlon
	local c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
	local d = 6378 * c
	return d
end

function fourkeyboard_vk(msg)
	msg = AnsiToUtf8(msg)
	msg = url_encode(msg)
	local keyboard = sixVkKeyboard()
	keyboard = u8(keyboard)
	keyboard = url_encode(keyboard)
	msg = msg .. '&keyboard=' .. keyboard
	mainPartOfVkSystem(msg, chat_id)
end

function twoVkKeyboard(arg)
	local keyboard = {}
	keyboard.one_time = false
	keyboard.inline = true
	keyboard.buttons = {}
	keyboard.buttons[1] = {}
	keyboard.buttons[2] = {}
	keyboard.buttons[3] = {}
	local row = keyboard.buttons[1]
	local row2 = keyboard.buttons[2]
	local row3 = keyboard.buttons[3]
	row[1] = {}
	row[1].action = {}
	row[1].color = 'positive'
	row[1].action.type = 'text'
	row[1].action.payload = '{"button": "'..arg..'day_stats"}'
	row[1].action.label = '&#128202; Суточная'
	
	row2[1] = {}
	row2[1].action = {}
	row2[1].color = 'positive'
	row2[1].action.type = 'text'
	row2[1].action.payload = '{"button": "'..arg..'week_stats"}'
	row2[1].action.label = '&#128202; Недельная'
	
	row3[1] = {}
	row3[1].action = {}
	row3[1].color = 'positive'
	row3[1].action.type = 'text'
	row3[1].action.payload = '{"button": "'..arg..'all_stats"}'
	row3[1].action.label = '&#128202; Абсолютная'
	
	return json.encode(keyboard)
end

function fourVkKeyboard()
	local keyboard = {}
	keyboard.one_time = false
	keyboard.inline = true
	keyboard.buttons = {}
	keyboard.buttons[1] = {}
	local row = keyboard.buttons[1]
	row[1] = {}
	row[1].action = {}
	row[1].color = 'negative'
	row[1].action.type = 'text'
	row[1].action.payload = '{"button": "return_house_ban"}'
	row[1].action.label = '&#127969; Вывести дома забаненных'
	return json.encode(keyboard)
end

function fiveVkKeyboard()
	local keyboard = {}
	keyboard.one_time = false
	keyboard.inline = true
	keyboard.buttons = {}
	keyboard.buttons[1] = {}
	local row = keyboard.buttons[1]
	row[1] = {}
	row[1].action = {}
	row[1].color = 'positive'
	row[1].action.type = 'text'
	row[1].action.payload = '{"button": "yes_start"}'
	row[1].action.label = '&#9989; Запустить слёт'
	row[2] = {}
	row[2].action = {}
	row[2].color = 'negative'
	row[2].action.type = 'text'
	row[2].action.payload = '{"button": "no_stop"}'
	row[2].action.label = '&#128683; Отменить'
	return json.encode(keyboard)
end

function threeVkKeyboard()
	local keyboard = {}
	keyboard.one_time = false
	keyboard.inline = true
	keyboard.buttons = {}
	keyboard.buttons[1] = {}
	local row = keyboard.buttons[1]
	row[1] = {}
	row[1].action = {}
	row[1].color = 'negative'
	row[1].action.type = 'text'
	row[1].action.payload = '{"button": "return_business_ban"}'
	row[1].action.label = '&#127970; Вывести бизнесы забаненных'
	return json.encode(keyboard)
end

function Test()
	local keyboard = {}
	keyboard.one_time = false
	keyboard.buttons = {}
	keyboard.buttons[1] = {}
	local row = keyboard.buttons[1]
	row[1] = {}
	row[1].action = {}
	row[1].color = 'primary'
	row[1].action.type = 'text'
	row[1].action.payload = '{"button": "online"}'
	row[1].action.label = '&#128202; Онлайн сервера'
	return json.encode(keyboard)
end


function vkKeyboardls() 
	local keyboard = {}
	keyboard.one_time = false
	keyboard.buttons = {}
	keyboard.buttons[1] = {}
	local row = keyboard.buttons[1]
	row[1] = {}
	row[1].action = {}
	row[1].color = 'primary'
	row[1].action.type = 'text'
	row[1].action.payload = '{"button": ""}'
	row[1].action.label = '&#128221; Моя информация'
	return json.encode(keyboard)
end


function vkKeyboard() 
	local keyboard = {}
	keyboard.one_time = false
	keyboard.buttons = {}
	keyboard.buttons[1] = {}
	keyboard.buttons[2] = {}
	keyboard.buttons[3] = {}
	keyboard.buttons[4] = {}
	keyboard.buttons[5] = {}
	local row = keyboard.buttons[1]
	local row_two = keyboard.buttons[2]
	local row_three = keyboard.buttons[3]
	local row_four = keyboard.buttons[4]
	local row_five = keyboard.buttons[5]
	row[1] = {}
	row[1].action = {}
	row[1].color = 'primary'
	row[1].action.type = 'text'
	row[1].action.payload = '{"button": "report"}'
	row[1].action.label = '&#128221; Количество репорта'
	
	row[2] = {}
	row[2].action = {}
	row[2].color = 'primary'
	row[2].action.type = 'text'
	row[2].action.payload = '{"button": "online"}'
	row[2].action.label = '&#128202; Онлайн сервера'
	
	row_two[1] = {}
	row_two[1].action = {}
	row_two[1].color = 'primary'
	row_two[1].action.type = 'text'
	row_two[1].action.payload = '{"button": "admin_online"}'
	row_two[1].action.label = '&#128101; Администрация онлайн'
	
	row_two[2] = {}
	row_two[2].action = {}
	row_two[2].color = 'primary'
	row_two[2].action.type = 'text'
	row_two[2].action.payload = '{"button": "leaders_online"}'
	row_two[2].action.label = '&#128101; Лидеры онлайн'
	
	row_three[1] = {}
	row_three[1].action = {}
	row_three[1].color = 'primary'
	row_three[1].action.type = 'text'
	row_three[1].action.payload = '{"button": "start_captcha"}'
	row_three[1].action.label = '&#128290; Запустить рандомную капчу на скин'
	
	row_three[2] = {}
	row_three[2].action = {}
	row_three[2].color = 'primary'
	row_three[2].action.type = 'text'
	row_three[2].action.payload = '{"button": "help"}'
	row_three[2].action.label = '&#128203; Помощь по командам'
	
	row_four[1] = {}
	row_four[1].action = {}
	row_four[1].color = 'positive'
	row_four[1].action.type = 'text'
	row_four[1].action.payload = '{"button": "check_server_online"}'
	row_four[1].action.label = '&#128202; Статистика серверного онлайна'

	row_five[1] = {}
	row_five[1].action = {}
	row_five[1].color = 'secondary'
	row_five[1].action.type = 'text'
	row_five[1].action.payload = '{"button": "gowork"}'
	row_five[1].action.label = '&#127744; Напоминалка о работе'
	return json.encode(keyboard)
end

function vkvkvk()
	local keyboard = {}
	keyboard.one_time = false
	keyboard.inline = true
	keyboard.buttons = {}
	keyboard.buttons[1] = {}
	keyboard.buttons[2] = {}
	keyboard.buttons[3] = {}
	local row = keyboard.buttons[1]
	local row_two = keyboard.buttons[2]
	local row_three = keyboard.buttons[3]
	row[1] = {}
	row[1].action = {}
	row[1].color = 'positive'
	row[1].action.type = 'text'
	row[1].action.payload = '{"button": "gowork1"}'
	row[1].action.label = '&#127744; Флуд чтобы слеты делали'
	row[2] = {}
	row[2].action = {}
	row[2].color = 'positive'
	row[2].action.type = 'text'
	row[2].action.payload = '{"button": "gorep"}'
	row[2].action.label = '&#10160; Флуд репорта'
	row_two[1] = {}
	row_two[1].action = {}
	row_two[1].color = 'negative'
	row_two[1].action.type = 'text'
	row_two[1].action.payload = '{"button": "chtot"}'
	row_two[1].action.label = '&#128313; Флуд в VK конфу'
	row_two[2] = {}
	row_two[2].action = {}
	row_two[2].color = 'negative'
	row_two[2].action.type = 'text'
	row_two[2].action.payload = '{"button": "spam"}'
	row_two[2].action.label = '&#128313; Заходим на сервер'
	row_three[1] = {}
	row_three[1].action = {}
	row_three[1].color = 'negative'
	row_three[1].action.type = 'text'
	row_three[1].action.payload = '{"button": "vse"}'
	row_three[1].action.label = '&#11093; Все вместе'
	return json.encode(keyboard)
end

function removeRoleUser(from_id, id)
	if isUserInConference(id) then
		if tonumber(getUserLevelDostup(id)) >= 1 then
			db_bot:execute("UPDATE `cf_users` SET `userdostup` = '0' where `userid` = '"..id.."'")
			VkMessage('&#9989; @id'..from_id..'('..getUserName(from_id)..') снял все права доступа у пользователя @id'..id..'('..getUserName(id)..')')
		else
			VkMessage('&#128219; У пользователя @id'..id..'('..getUserName(id)..') нет прав доступа.')
		end
	else
		VkMessage('&#128219; Указанный пользователь не находится в беседе.')
	end
end

function removeWarnUser(from_id, id)
	if isUserInConference(id) then
		if tonumber(getUserWarns(id)) == 0 then
			VkMessage('&#9888; У пользователя @id'..id..'('..getUserName(id)..') отсутствуют предупреждения.')
		else
			db_bot:execute("UPDATE `cf_users` SET `warns` = '"..(getUserWarns(id)-1).."' where `userid` = '"..id.."'") 
			VkMessage('&#9888; @id'..from_id..'('..getUserName(from_id)..') снял предупреждение пользователю @id'..id..'('..getUserName(id)..') ['..getUserWarns(id)..'/3].')
		end
	else
		VkMessage('&#128219; Указанный пользователь не находится в беседе.')
	end
end

function removeNickUser(from_id, id)
    if isUserInConference(id) then
        if isUserHaveNickName(id) then
            if tonumber(getUserLevelDostup(id)) >= 3 then   
                if tonumber(getUserLevelDostup(from_id)) >= 3 then
                    db_bot:execute("UPDATE `cf_users` SET `username` = 'NONE' where `userid` = '"..id.."'") 
					VkMessage('[ INFO ] - Администратор [id'..from_id..'|'..getUserName(from_id)..'] удалил ник-нейм пользователю [id'..id..'|'..getUserName(id)..']')
                else
                    VkMessage('&#128219; Вы не можете удалить ник-нейм пользователю, который выше вас по званию.')
                end
            else
                db_bot:execute("UPDATE `cf_users` SET `username` = 'NONE' where `userid` = '"..id.."'") 
                VkMessage('[ INFO ] - Администратор [id'..from_id..'|'..getUserName(from_id)..'] удалил ник-нейм пользователю [id'..id..'|'..getUserName(id)..']')
            end
        else
            VkMessage('&#128219; У пользователя @id'..id..'('..getUserName(id)..') не установлен ник-нейм.')
        end
    else
        VkMessage('&#128219; Указанный пользователь не находится в беседе.')
    end
end

function removeVigUser(from_id, id)
	if isUserInConference(id) then
		if tonumber(getUserVigs(id)) == 0 then
			VkMessage('&#9888; У пользователя @id'..id..'('..getUserName(id)..') отсутствуют выговоры.')
		else
			db_bot:execute("UPDATE `cf_users` SET `vigs` = '"..(getUserVigs(id)-1).."' where `userid` = '"..id.."'") 
			VkMessage('&#9888; @id'..from_id..'('..getUserName(from_id)..') снял выговор пользователю @id'..id..'('..getUserName(id)..') ['..getUserVigs(id)..'/3].')
		end
	else
		VkMessage('&#128219; Указанный пользователь не находится в беседе.')
	end
end

function isMentionExists(userid)
	cursor, errorString = db_bot:execute('select * from mention_list where `usermention` = "'..userid..'"')
	row = cursor:fetch ({}, "a")
	if row then return true else return false end
end

function giveUserVig(from_id, id)
	if isUserInConference(id) then
		if tonumber(getUserLevelDostup(id)) >= 3 then	
			if tonumber(getUserLevelDostup(from_id)) >= 3 then
				VkMessage('&#128219; Вы не можете выдать выговор самому себе, либо звание пользователя равно Вашему званию.')
			else
				VkMessage('&#128219; Вы не можете выдать выговор пользователю, который выше вас по званию.')
			end
		else
			if tonumber(getUserLevelDostup(id)) >= 1 then
				db_bot:execute("UPDATE `cf_users` SET `vigs` = '"..(getUserVigs(id)+1).."' where `userid` = '"..id.."'") 
				if tonumber(getUserVigs(id)) >= 3 then
					VkMessage('&#9888; Пользователь @id'..id..'('..getUserName(id)..') был лишён абсолютно всех прав за наличие [3/3] выговоров.')
					db_bot:execute("UPDATE `cf_users` SET `userdostup` = 0 where `userid` = '"..id.."'")
					db_bot:execute("UPDATE `cf_users` SET `vigs` = 0 where `userid` = '"..id.."'")
				else
					VkMessage('&#9888; @id'..from_id..'('..getUserName(from_id)..') выдал выговор пользователю @id'..id..'('..getUserName(id)..') ['..getUserVigs(id)..'/3].')
				end
			else
				VkMessage('&#9888; У данного пользователя и так нету никаких прав.')
			end
		end
	else
		VkMessage('&#128219; Указанный пользователь не находится в беседе.')
	end
end

function giveUserWarn(from_id, id)
	if isUserInConference(id) then
		if tonumber(getUserLevelDostup(id)) >= 5 then	
			if tonumber(getUserLevelDostup(from_id)) >= 5 then
				VkMessage('&#128219; Вы не можете выдать предупреждение самому себе.')
			else
				VkMessage('&#128219; Вы не можете выдать предупреждение пользователю, который выше вас по званию.')
			end
		else
			db_bot:execute("UPDATE `cf_users` SET `warns` = '"..(getUserWarns(id)+1).."' where `userid` = '"..id.."'") 
			if tonumber(getUserWarns(id)) >= 3 then
				luaVkApi.removeChatUser((tonumber(chat_id)), tonumber(id))
				VkMessage('&#9888; Пользователь @id'..id..'('..getUserName(id)..') был исключен из чата за наличие 3/3 предупреждений.')
				db_bot:execute("DELETE FROM `cf_users` where `userid` = '"..id.."'")
				sendInput('/makeadmin '..getUserName(id)..' 0')
			else
				VkMessage('&#9888; @id'..from_id..'('..getUserName(from_id)..') выдал предупреждение пользователю @id'..id..'('..getUserName(id)..') ['..getUserWarns(id)..'/3].')
			end
		end
	else
		VkMessage('&#128219; Указанный пользователь не находится в беседе.')
	end
end

function kickUser(from_id, id)
	if isUserInConference(id) then
		if tonumber(getUserLevelDostup(id)) >= 6 then	
			if tonumber(getUserLevelDostup(from_id)) >= 6 then
				VkMessage('&#128219; Вы не можете исключить самого себя.')
			else
				VkMessage('&#128219; Вы не можете исключить пользователя, который выше вас по званию.')
			end
		else
			VkMessage('&#128683; @id'..from_id..'('..getUserName(from_id)..') исключил пользователя @id'..id..'('..getUserName(id)..'). Его права и никнейм очищены автоматически.')
			luaVkApi.removeChatUser((tonumber(chat_id)), tonumber(id))
			db_bot:execute("DELETE FROM `cf_users` where `userid` = '"..id.."'")
		end
	else
		VkMessage('&#128219; Указанный пользователь не находится в беседе.')
	end
end

function removeUserMute(from_id, id)
	if isUserInConference(id) then
		if isUserHaveMute(id) then
			db_bot:execute("UPDATE `cf_users` SET `mutetime` = '0' where `userid` = '"..id.."'") 
			VkMessage('&#9989; @id'..from_id..'('..getUserName(from_id)..') снял блокировку чата пользователю @id'..id..'('..getUserName(id)..').')
		else
			VkMessage('&#9989; У пользователя @id'..id..'('..getUserName(id)..') отсутствует блокировка чата.')
		end
	else
		VkMessage('&#128219; Указанный пользователь не находится в беседе.')
	end
end

function giveUserMute(from_id, id, mutetime, mutereason)
	if isUserInConference(id) then
		if tonumber(getUserLevelDostup(id)) >= 3 then	
			if tonumber(getUserLevelDostup(from_id)) >= 3 then
				VkMessage('&#128219; Вы не можете выдать блокировку чата самому себе.')
			else
				VkMessage('&#128219; Вы не можете выдать блокировку чата пользователю, который выше вас по званию.')
			end
		else
			if isUserHaveMute(id) then
				VkMessage('&#128566; Данный пользователь уже замучен.')
			else
				if tonumber(mutetime) >= 5 and tonumber(mutetime) <= 2880 then
					db_bot:execute("UPDATE `cf_users` SET `mutetime` = '"..os.time()+(mutetime*60).."' where `userid` = '"..id.."'") 
					VkMessage('&#128566; @id'..from_id..'('..getUserName(from_id)..') выдал блокировку чата пользователю @id'..id..'('..getUserName(id)..') на '..tonumber(mutetime)..'мин. по причине: '..mutereason..'.\n&#128198; Дата истечения блокировки чата: '..unix_decrypt(os.time()+(mutetime*60)))
				else
					VkMessage('&#128219; Время блокировки чата может быть от 5 до 2880 минут.')
				end
			end
		end
	else
		VkMessage('&#128219; Указанный пользователь не находится в беседе.')
	end
end

function callUsersVk(userid, reason)
	call_text = '@all'
	cursor,errorString = db_bot:execute([[select * from cf_users]])
	row = cursor:fetch ({}, "a")
	VkMessageWithPing('&#128483; Вы были вызваны @id'..userid..'(администратором) беседы.\n\n'..call_text..'\n\n&#128276; Причина вызова: '..reason)
	VkMessage('&#128483; Вызов отправлен')
end

function callUsers(userid, reason)
	call_text = ''
	cursor,errorString = db_bot:execute([[select * from cf_users]])
	row = cursor:fetch ({}, "a")
	while row do
		call_text = call_text..string.format("@id%d (&#128100;)", row.userid)
		row = cursor:fetch(row, "a")
	end
	VkMessage('&#128483; Вы были вызваны @id'..userid..'(администратором) беседы.\n\n'..call_text..'\n\n&#128276; Причина вызова: '..reason)
end

function getGroupNameById(groupid)
	local result = luaVkApi.getCommunitiesById(groupid)
	local t = json.decode(u8:decode(result))['response']
	for k, v in ipairs(t) do
		groupname = v.name
	end
	return groupname
end

function isUserSubscribeOnGroup(userid)
	local result = luaVkApi.isCommunityMember(cfg.config.check_public_link, userid)
	local status_subscribe = json.decode(u8:decode(result))['response']
	if tonumber(status_subscribe) == 0 then return false else return true end
end

function sendHelpMessage(userid, msgid)
	help_text = ''
	for i = 1, #custom_all_bot_commands do
		if tonumber(custom_all_bot_commands[i][3]) == 0 then
			help_text = help_text..'\n&#128313; '..custom_all_bot_commands[i][1]..' – '..custom_all_bot_commands[i][2]..'.'
		end
		if tonumber(getUserLevelDostup(userid)) > 0 and tonumber(custom_all_bot_commands[i][3]) == 1 then
			help_text = help_text..'\n&#128313; '..custom_all_bot_commands[i][1]..' – '..custom_all_bot_commands[i][2]..'.'
		elseif tonumber(getUserLevelDostup(userid)) > 1 and tonumber(custom_all_bot_commands[i][3]) == 2 then
			help_text = help_text..'\n&#128313; '..custom_all_bot_commands[i][1]..' – '..custom_all_bot_commands[i][2]..'.'
		elseif tonumber(getUserLevelDostup(userid)) > 2 and tonumber(custom_all_bot_commands[i][3]) == 3 then
			help_text = help_text..'\n&#128313; '..custom_all_bot_commands[i][1]..' – '..custom_all_bot_commands[i][2]..'.'
		elseif tonumber(getUserLevelDostup(userid)) > 3 and tonumber(custom_all_bot_commands[i][3]) == 4 then
			help_text = help_text..'\n&#128313; '..custom_all_bot_commands[i][1]..' – '..custom_all_bot_commands[i][2]..'.'
		end
	end
	help_text = '&#128221; | Список доступных Вам команд:\n\n'..help_text
	newTask(function() 
		for i,v in ipairs(splitByChunk(help_text, 4000)) do
			VkMessage(v)
			wait(500)
		end
		wait(30000)
		luaVkApi.deleteMessages(msgid, group_id, chat_id)
	end)
end

function ydal_message()
	luaVkApi.deleteMessages(message_id, chat_id, peer_id)
	delete.message(message_id)
end

function clearChat()
	text = ''
	for i = 1, 100 do
		text = text..'\n&#13;'
	end
	VkMessage(text)
end

function convertToSmile(arg)
	text = ''
	for number in tostring(arg):gmatch('(%d)') do
		text = text..number..'&#8419;'
	end
	return text
end

function convertToHours(arg)
	all_minutes = math.modf(tonumber(arg) / 60)
	hours = math.modf(all_minutes/60)
	minutes = math.modf(all_minutes-(hours*60))
	seconds = math.modf(arg-((hours*3600)+(minutes*60)))
	return hours..'ч. '..minutes..'мин. '..seconds..'сек.'
end

function chtot()
	for i = 1, 5 do
		VkMessageFlood('@all ПРОВОДИМ СЛЕТЫ/КАПЧИ КАЖДЫЕ 10 СЕК.ЗА АКСАМИ ДЛЯ КАПЧ К ГА,ЗГА,КУРАТОРУ!')
	end
	VkMessage('&#128315; Бот профлудил в админ чат(vk) чтобы заходили в игру.')
end

function spam()
	for i = 1, 25 do
		VkMessageFlood('@all БЕГОМ НА СЕРВЕР')
	end
	VkMessage('&#128315; Бот профлудил в админ чат(vk) чтобы заходили в игру.')
end

function chtog()
	sendInput('chtg')
	VkMessage('&#128315; Бот профлудил в админ чат(vk) чтобы заходили в игру.')
end

function gowork1()
	for i = 1, 20 do
		sendInput('/a ПРОВОДИМ СЛЕТЫ/КАПЧИ КАЖДЫЕ 10 СЕК.ЗА АКСАМИ ДЛЯ КАПЧ К ГА,ЗГА,КУРАТОРУ!')
	end
		VkMessage('&#128311; Бот напомнил админам о проведение слетов/капчей')
end

function gorep()
	for i = 1, 20 do
		sendInput('/a REPORT REPORT REPORT REPORT - /OT /OT /OT /OT - REPORT REPORT REPORT REPORT')
	end
	VkMessage('&#128311; Бот напомнил админам о репорте')
end

function vse()
	newTask(function()
		VkMessage('&#128312; Бот профлудил все вместе')
	for i = 1, 5 do
		VkMessageFlood('@all ПРОВОДИМ СЛЕТЫ/КАПЧИ КАЖДЫЕ 10 СЕК.ЗА АКСАМИ ДЛЯ КАПЧ К ГА,ЗГА,КУРАТОРУ!')
		sendInput('/a ПРОВОДИМ СЛЕТЫ/КАПЧИ КАЖДЫЕ 10 СЕК.ЗА АКСАМИ ДЛЯ КАПЧ К ГА,ЗГА,КУРАТОРУ!')
		sendInput('/a REPORT REPORT REPORT REPORT - /OT /OT /OT /OT - REPORT REPORT REPORT REPORT')
	end
end)
end

function gowork()
	vkvkvk_vk('Выберите способ флуда')
end

function neadekvats_mat(msg)
    msg = AnsiToUtf8(msg)
    msg = url_encode(msg)
    local keyboard = accept()
    keyboard = u8(keyboard)
    keyboard = url_encode(keyboard)
    msg = msg .. '&keyboard=' .. keyboard
    partOfVkSystem(msg)
end

function accept()
    local keyboard = {}
    keyboard.one_time = false
    keyboard.inline = true
    keyboard.buttons = {}
    keyboard.buttons[1] = {}
    local row = keyboard.buttons[1]
    row[1] = {}
    row[1].action = {}
    row[1].color = 'positive'
    row[1].action.type = 'text'
    row[1].action.payload = '{"button": "accept"}'
    row[1].action.label = '&#128154; Наказать игрока'
	row[2] = {}
    row[2].action = {}
    row[2].color = 'negative'
    row[2].action.type = 'text'
    row[2].action.payload = '{"button": "noaccept"}'
    row[2].action.label = '&#129505; Отменить'
    return json.encode(keyboard)
end

function inTable(t, val, key)
    for k, v in pairs(t) do
        if key and k == key and v == val then return true end
        if type(v) == 'table' then
            if inTable(v, val, key) then return true end
        elseif not key and v == val then
            return true
        end
    end
    return false
end

function vernut(msg)
    msg = AnsiToUtf8(msg)
    msg = url_encode(msg)
    local keyboard = vernut1()
    keyboard = u8(keyboard)
    keyboard = url_encode(keyboard)
    msg = msg .. '&keyboard=' .. keyboard
    partOfVkSystem(msg)
end

function vernut1()
    local keyboard = {}
    keyboard.one_time = false
    keyboard.inline = true
    keyboard.buttons = {}
    keyboard.buttons[1] = {}
    local row = keyboard.buttons[1]
    row[1] = {}
    row[1].action = {}
    row[1].color = 'positive'
    row[1].action.type = 'text'
    row[1].action.payload = '{"button": "vernut1"}'
    row[1].action.label = '&#128154; Вернуть'
    return json.encode(keyboard)
end

function accept_vk(msg)
    msg = AnsiToUtf8(msg)
    msg = url_encode(msg)
    local keyboard = yes()
    keyboard = u8(keyboard)
    keyboard = url_encode(keyboard)
    msg = msg .. '&keyboard=' .. keyboard
    partOfVkSystem(msg)
end

function yes()
    local keyboard = {}
    keyboard.one_time = false
    keyboard.inline = true
    keyboard.buttons = {}
    keyboard.buttons[1] = {}
    local row = keyboard.buttons[1]
    row[1] = {}
    row[1].action = {}
    row[1].color = 'positive'
    row[1].action.type = 'text'
    row[1].action.payload = '{"button": "yes"}'
    row[1].action.label = '&#128154; Выдать'
	row[2] = {}
	row[2].action = {}
    row[2].color = 'negative'
    row[2].action.type = 'text'
    row[2].action.payload = '{"button": "no"}'
    row[2].action.label = '&#129505; Отказать'
    return json.encode(keyboard)
end

function vzloman1(msg)
    msg = AnsiToUtf8(msg)
    msg = url_encode(msg)
    local keyboard = vzlom1()
    keyboard = u8(keyboard)
    keyboard = url_encode(keyboard)
    msg = msg .. '&keyboard=' .. keyboard
    partOfVkSystem(msg)
end

function vzlom1()
    local keyboard = {}
    keyboard.one_time = false
    keyboard.inline = true
    keyboard.buttons = {}
    keyboard.buttons[1] = {}
    local row = keyboard.buttons[1]
    row[1] = {}
    row[1].action = {}
    row[1].color = 'positive'
    row[1].action.type = 'text'
    row[1].action.payload = '{"button": "unban1"}'
    row[1].action.label = '&#9989; Разбанить'
	row[2] = {}
	row[2].action = {}
    row[2].color = 'negative'
    row[2].action.type = 'text'
    row[2].action.payload = '{"button": "nounban1"}'
    row[2].action.label = '&#129505; Оставить в бане'
    return json.encode(keyboard)
end

function vzloman(msg)
    msg = AnsiToUtf8(msg)
    msg = url_encode(msg)
    local keyboard = vzlom()
    keyboard = u8(keyboard)
    keyboard = url_encode(keyboard)
    msg = msg .. '&keyboard=' .. keyboard
    partOfVkSystem(msg)
end

function vzlom()
    local keyboard = {}
    keyboard.one_time = false
    keyboard.inline = true
    keyboard.buttons = {}
    keyboard.buttons[1] = {}
    local row = keyboard.buttons[1]
    row[1] = {}
    row[1].action = {}
    row[1].color = 'positive'
    row[1].action.type = 'text'
    row[1].action.payload = '{"button": "unban"}'
    row[1].action.label = '&#9989; Разбанить'
	row[2] = {}
	row[2].action = {}
    row[2].color = 'negative'
    row[2].action.type = 'text'
    row[2].action.payload = '{"button": "nounban"}'
    row[2].action.label = '&#129505; Оставить в бане'
    return json.encode(keyboard)
end

function sliv_vk(msg)
    msg = AnsiToUtf8(msg)
    msg = url_encode(msg)
    local keyboard = sliv()
    keyboard = u8(keyboard)
    keyboard = url_encode(keyboard)
    msg = msg .. '&keyboard=' .. keyboard
    partOfVkSystem(msg)
end

function sliv()
    local keyboard = {}
    keyboard.one_time = false
    keyboard.inline = true
    keyboard.buttons = {}
    keyboard.buttons[1] = {}
    local row = keyboard.buttons[1]
    row[1] = {}
    row[1].action = {}
    row[1].color = 'positive'
    row[1].action.type = 'text'
    row[1].action.payload = '{"button": "sliv"}'
    row[1].action.label = '&#128154; Забанить'
	row[2] = {}
    row[2].action = {}
    row[2].color = 'negative'
    row[2].action.type = 'text'
    row[2].action.payload = '{"button": "nosliv"}'
    row[2].action.label = '&#129505; Отмена'
    return json.encode(keyboard)
end

function number_week()
    local current_time = os.date'*t'
    local start_year = os.time{ year = current_time.year, day = 1, month = 1 }
    local week_day = ( os.date('%w', start_year) - 1 ) % 7
    return math.ceil((current_time.yday + week_day) / 7)
end

function onRunCommand(cmd)
	if cmd:find('!test') then
		print(tonumber(gotp_slet))
	end
end

function getItemColor(color)
	if color == 'FFFFFF' then
		color_name = 'Стоковый'
	elseif color == 'CC2426' then
		color_name = 'Красный'
	elseif color == 'CC7824' then
		color_name = 'Золотой'
	elseif color == 'E6BC1E' then
		color_name = 'Тускло-жёлтый'
	elseif color == 'D5D73C' then
		color_name = 'Жёлтый'
	elseif color == '3CD740' then
		color_name = 'Зелёный'
	elseif color == '3CD7D7' then
		color_name = 'Голубой'
	elseif color == '3C3ED7' then
		color_name = 'Синий'
	elseif color == 'D73CD4' then
		color_name = 'Фиолетовый'
	elseif color == 'D73C7E' then
		color_name = 'Розовый'
	end
	return color_name
end

function isUserInsertIntoKicklist(nickname)
	row = cursor:fetch ({}, "a")
	if row then return true else return false end
end

function getAccountFullDostupByNick(nick)
	row = cursor:fetch ({}, "a")
	return row.afulldostup
end

function getAccountInGameByUserVk(vk)
	row = cursor:fetch ({}, "a")
	return row.NickName
end

function isAccountExists(nickname)
	cursor, errorstring = db_server:execute('select * from `accounts` where `NickName` = "'..nickname..'"')
	row = cursor:fetch ({}, "a")
	if row then return true else return false end
end

function isFamExists(checkfam)
	cursor, errorstring = db_server:execute('select * from `family` where `name` = "'..checkfam..'"')
	row = cursor:fetch ({}, "a")
	if row then return true else return false end
end

function removeUserMute(from_id, id)
	if isUserInConference(id) then
		if isUserHaveMute(id) then
			db_bot:execute("UPDATE `cf_users` SET `mutetime` = '0' where `userid` = '"..id.."'") 
			VkMessage('[ INFO ] - Администратор [id'..from_id..'|'..getUserName(from_id)..'] снят мут пользователю [id'..id..'|'..getUserName(id)..']')
		else
			VkMessage('&#9989; У пользователя @id'..id..'('..getUserName(id)..') отсутствует блокировка чата.')
		end
	else
		VkMessage('&#128219; Указанный пользователь не находится в беседе.')
	end
end

function giveUserMute(from_id, id, mutetime, mutereason)
	if isUserInConference(id) then
		if tonumber(getUserLevelDostup(id)) >= 3 then	
			if tonumber(getUserLevelDostup(from_id)) >= 3 then
				VkMessage('&#128219; Вы не можете выдать блокировку чата самому себе.')
			else
				VkMessage('&#128219; Вы не можете выдать блокировку чата пользователю, который выше вас по званию.')
			end
		else
			if isUserHaveMute(id) then
				VkMessage('&#128566; Данный пользователь уже замучен.')
			else
				if tonumber(mutetime) >= 5 and tonumber(mutetime) <= 2880 then
					db_bot:execute("UPDATE `cf_users` SET `mutetime` = '"..os.time()+(mutetime*60).."' where `userid` = '"..id.."'")
					VkMessage('[ INFO ] - Администратор [id'..from_id..'|'..getUserName(from_id)..'] выдал мут пользователю [id'..id..'|'..getUserName(id)..'] на '..tonumber(mutetime)..'мин. Причина: '..mutereason..'\nДата истечения блокировки чата: '..unix_decrypt(os.time()+(mutetime*60)))
				else
					VkMessage('&#128219; Время блокировки чата может быть от 5 до 2880 минут.')
				end
			end
		end
	else
		VkMessage('&#128219; Указанный пользователь не находится в беседе.')
	end
end

function setUserName(from_id, id, nickname)
	if isUserInConference(id) then
		if tonumber(getUserLevelDostup(id)) >= 3 then	
			if tonumber(getUserLevelDostup(from_id)) >= 3 then
				VkMessage('[ INFO ] - Пользователь [id'..id..'|'..getUserName(id)..'] добавлен в список с ником '..nickname)
				db_bot:execute("UPDATE `cf_users` SET `username` = '"..nickname.."' where `userid` = '"..id.."'") 
			else
				VkMessage('&#128219; Вы не можете изменить никнейм пользователю, который выше вас по званию.')
			end
		else
			if isUserHaveNickName(id) then
				VkMessage('&#128219; У данного пользователя уже установлен никнейм.')
			else
				VkMessage('[ INFO ] - Пользователь [id'..id..'|'..getUserName(id)..'] добавлен в список с ником '..nickname)
				db_bot:execute("UPDATE `cf_users` SET `username` = '"..nickname.."' where `userid` = '"..id.."'")
				db_bot:execute("INSERT INTO `logs1`( `Text`, `IDUser`) VALUES ('Администратор @id"..id.."("..getUserName(from_id)..") установил ник-нейм @id"..id.."("..getUserName(id)..")', '"..from_id.."')")
			end
		end
	else
		VkMessage('&#128219; Указанный пользователь не находится в беседе.')
	end
end

function setNickName(from_id, id, nickname, user_id)
		if tonumber(getUserLevelDostup(id)) >= 3 then	
			if tonumber(getUserLevelDostup(from_id)) >= 3 then
				vk_request_user(user_id, '[ INFO ] - Пользователю [id'..id..'|'..getUserName(id)..'] установлен ник '..nickname)
				db_bot:execute("UPDATE `cf_users` SET `nickname` = '"..nickname.."' where `userid` = '"..id.."'") 
			else
				vk_request_user(user_id, '&#128219; Вы не можете изменить никнейм пользователю, который выше вас по званию.')
			end
		else
			if isUserHaveNickName(id) then
				vk_request_user(user_id, '&#128219; У данного пользователя уже установлен никнейм.')
			else
				vk_request_user(user_id, '[ INFO ] - Пользователю [id'..id..'|'..getUserName(id)..'] установлен ник '..nickname)
				db_bot:execute("UPDATE `cf_users` SET `nickname` = '"..nickname.."' where `userid` = '"..id.."'")
			end
		end
end


function isUserHaveNickName(userid)
	cursor, errorString = db_bot:execute("select * from cf_users where `userid` = '"..userid.."'")
	row = cursor:fetch({}, "a")
	while row do
		if tostring(row.username) ~= 'NONE' then return true else return false end
	end
end

function isUserInBan(userid)
	cursor, errorString = db_bot:execute("select * from ban_list where `banuserid` = '"..userid.."'")
	row = cursor:fetch({}, "a")
	if row then return true else return false end
end

function giveUserAdmin(from_id, id, days)
	if isUserInConference(id) then
		if tonumber(getUserLevelDostup(id)) >= 1 then
			VkMessage('&#128219; Пользователь @id'..id..'('..getUserName(id)..') уже имеет статус администратора или выше.')
		else
			if tonumber(days) >= 1 and tonumber(days) <= 9999 then
				db_bot:execute("UPDATE `cf_users` SET `userdostup` = '1' where `userid` = '"..id.."'")
				db_bot:execute("UPDATE `cf_users` SET `roletime` = "..(os.time()+(days*86400)).." where `userid` = '"..id.."'")
				VkMessage('&#128142; @id'..from_id..'('..getUserName(from_id)..') выдал пользователю @id'..id..'('..getUserName(id)..') права администратора.')
			else
				VkMessage('&#128219; Срок действия роли в днях может быть от 1 до 9999.')
			end
		end
	else
		VkMessage('&#128219; Указанный пользователь не находится в беседе.')
	end
end

function giveUserOsnovatel(from_id, id, days)
	if isUserInConference(id) then
		if tonumber(getUserLevelDostup(id)) >= 4 then
			VkMessage('&#128219; Пользователь @id'..id..'('..getUserName(id)..') уже имеет статус владельца беседы или выше.')
		else
			if tonumber(days) >= 1 and tonumber(days) <= 9999 then
				db_bot:execute("UPDATE `cf_users` SET `userdostup` = '4' where `userid` = '"..id.."'")
				db_bot:execute("UPDATE `cf_users` SET `roletime` = "..(os.time()+(days*86400)).." where `userid` = '"..id.."'")
				VkMessage('&#128142; @id'..from_id..'('..getUserName(from_id)..') выдал пользователю @id'..id..'('..getUserName(id)..') права владельца беседы.')
			else
				VkMessage('&#128219; Срок действия роли в днях может быть от 1 до 9999.')
			end
		end
	else
		VkMessage('&#128219; Указанный пользователь не находится в беседе.')
	end
end

function giveUserSpecialAdmin(from_id, id, days)
	if isUserInConference(id) then
		if tonumber(getUserLevelDostup(id)) >= 2 then
			VkMessage('&#128219; Пользователь @id'..id..'('..getUserName(id)..') уже имеет статус специального администратора.')
		else
			if tonumber(days) >= 1 and tonumber(days) <= 9999 then
				db_bot:execute("UPDATE `cf_users` SET `userdostup` = '2' where `userid` = '"..id.."'")
				db_bot:execute("UPDATE `cf_users` SET `roletime` = "..(os.time()+(days*86400)).." where `userid` = '"..id.."'")
				VkMessage('&#128305; @id'..from_id..'('..getUserName(from_id)..') выдал пользователю @id'..id..'('..getUserName(id)..') права специального администратора.')
				db_bot:execute("INSERT INTO `logs1`( `Text`, `IDUser`) VALUES ('Администратор "..getUserName(from_id).." выдал "..getUserName(id).." права спец администратора', '"..from_id.."')")
			else
				VkMessage('&#128219; Срок действия роли в днях может быть от 1 до 9999.')
			end
		end
	else
		VkMessage('&#128219; Указанный пользователь не находится в беседе.')
	end
end


function giveUserOwner(from_id, id, days)
	if isUserInConference(id) then
		if tonumber(getUserLevelDostup(id)) >= 3 then
			VkMessage('&#128219; Пользователь @id'..id..'('..getUserName(id)..') уже имеет статус Руководителя.')
		else
		if tonumber(days) >= 1 and tonumber(days) <= 9999 then
			db_bot:execute("UPDATE `cf_users` SET `userdostup` = '3' where `userid` = '"..id.."'")
			db_bot:execute("UPDATE `cf_users` SET `roletime` = "..(os.time()+(days*86400)).." where `userid` = '"..id.."'")
			VkMessage('&#128305; @id'..from_id..'('..getUserName(from_id)..') выдал пользователю @id'..id..'('..getUserName(id)..') права Руководителя.')
			db_bot:execute("INSERT INTO `logs1`( `Text`, `IDUser`) VALUES ('Администратор "..getUserName(from_id).." выдал "..getUserName(id).." права руководителя', '"..from_id.."')")
		else
				VkMessage('&#128219; Срок действия роли в днях может быть от 1 до 9999.')
			end
		end
	else
		VkMessage('&#128219; Указанный пользователь не находится в беседе.')
	end
end

function insertInVrUsers(nick)
	if not isPlayerInsertInVipChatUsers(nick) then db_bot:execute("INSERT INTO `vr_users`(`nick`, `nrg`, `flip`, `infernus`, `spawn`, `help`, `teleport`, `try`, `hp`, `pass`) VALUES ('"..nick.."', 0, 0, 0, 0, 0, 0, 0, 0, 0)") end
end

function isPlayerInsertInVipChatUsers(nick)
	cursor, errorString = db_bot:execute("select * from vr_users where `nick` = '"..nick.."'")
	row = cursor:fetch({}, "a")
	if row then return true else return false end
end

function send_info_online()
	requestonline = true
	runCommand('!players')
	newTask(function()
			VkMessage("&#127800; Текущий онлайн сервера: "..(server_online+1).." человек.")
		requestonline = false
	end)
end

newTask(function()
    while true do
		wait(tonumber(config[7][2])*1000)
		if isConnected() then
			sendInput('/a -> Чтобы включить автоопру используйте "/a бот автoопра"')
			sendInput('/a -> Чтобы посадить последнего игрока, который словил бизнес используйте "/a бот лaст биз"')
			sendInput('/a -> Чтобы посадить последнего игрока, который словил дом используйте "/a бот лaст дoм"')
			sendInput('/a -> Чтобы узнать данные о местоположении игрока и расстояние используйте "/a /getip ID"')
			VkMessage('&#127757; Информация о акциях бота отправлена [отправляется раз в '..tonumber(config[7][2])..' секунд].')
		end
	end
end)

newTask(function()
    while true do
		wait(tonumber(config[4][2])*1000)
		startQuestion()
	end
end)

function checkUserStats(from_id, id)
	if isUserInConference(id) then
			cursor, errorString = db_bot:execute("select * from `cf_users` where `userid` = '"..id.."'")
			row = cursor:fetch({}, "a")
			while row do
				usermessages = row.messages
				userstatus = row.userdostup
				username = row.username
				userwarns = row.warns
				uservigs = row.vigs
				usermute = row.mutetime
				roletime = row.roletime
				lastmsg = row.lastmessage_date
				row = cursor:fetch(row, "a")
			end
			if tonumber(userstatus) == 0 then 
				userstatusname = 'Пользователь'
			elseif tonumber(userstatus) == 1 then 
				userstatusname = 'Администратор [до '..os.date("%X %d.%m.%Y", roletime)..']'
			elseif tonumber(userstatus) == 2 then 
				userstatusname = 'Специальный администратор [до '..os.date("%X %d.%m.%Y", roletime)..']'
			elseif tonumber(userstatus) == 3 then 
				userstatusname = 'Основатель'
			elseif tonumber(userstatus) == 4 then 
				userstatusname = 'Владелец'
			end
			if tonumber(usermute) > 0 then
				usermutename = 'Есть'
			else
				usermutename = 'Отсутствует'
			end
			if tostring(username) == 'NONE' then username = 'Отсутствует' end
			VkMessage('&#128190; Информация о @id'..id..'('..getUserName(id)..'):\n\n&#128313; Статус: '..userstatusname..'.\n&#128313; Предупреждений: ['..userwarns..'/3].\n&#128313; Выговоров: ['..uservigs..'/3].\n&#128313; Блокировка чата: '..usermutename..'.\n&#128313; НикНейм: '..username..'.\n&#128313; Отправил сообщений: '..usermessages..'.\n&#128313; Последнее сообщение: '..unix_decrypt(lastmsg))
	else
		VkMessage('&#128219; Указанный пользователь не находится в беседе.')
	end
end

function giveUserBan(from_id, id, bantime, banreason)
	if tonumber(id) > 0 then
		if isUserInConference(id) then
			if tonumber(getUserLevelDostup(id)) >= 3 then	
				if tonumber(getUserLevelDostup(from_id)) >= 3 then
					VkMessage('&#128219; Вы не можете заблокировать самого себя.')
				else
					VkMessage('&#128219; Вы не можете заблокировать пользователя, который выше вас по званию.')
				end
			else
				if tonumber(bantime) <= 666 then
					db_bot:execute("INSERT INTO `ban_list` (`banuserid`, `banadminid`, `bantime`, `banreason`) VALUES ('"..id.."', '"..from_id.."', '"..os.time()+(bantime*86400).."', '"..banreason.."')")
					VkMessage('&#9940; @id'..from_id..'('..getUserName(from_id)..') заблокировал пользователя @id'..id..'('..getUserName(id)..') на '..bantime..'дн.\n&#128203; Причина блокировки: '..banreason..'\n&#128198; Дата разблокировки пользователя: '..unix_decrypt(os.time()+(bantime*86400)))
					luaVkApi.removeChatUser((tonumber(chat_id)), tonumber(id))
					db_bot:execute("DELETE FROM `cf_users` where `userid` = '"..id.."'")
				else
					VkMessage('&#128219; Максимальный срок блокировки - 666 дней.')
				end
			end
		else
			if tonumber(bantime) <= 666 then
				db_bot:execute("INSERT INTO `ban_list` (`banuserid`, `banadminid`, `bantime`, `banreason`) VALUES ('"..id.."', '"..from_id.."', '"..os.time()+(bantime*86400).."', '"..banreason.."')")
				luaVkApi.removeChatUser((tonumber(chat_id)), tonumber(id))
				VkMessage('&#9940; @id'..from_id..'('..getUserName(from_id)..') заблокировал пользователя @id'..id..'('..getUserName(id)..') на '..bantime..'дн.\n&#128203; Причина блокировки: '..banreason..'\n&#128198; Дата разблокировки пользователя: '..unix_decrypt(os.time()+(bantime*86400)))
				db_bot:execute("DELETE FROM `cf_users` where `userid` = '"..id.."'")
			else
				VkMessage('&#128219; Максимальный срок блокировки - 666 дней.')
			end
		end
	else
		VkMessage('&#128219; Указан неверный ID пользователя.')
	end
end

function getPlayerBusinessis(nickname)
	player_businessis = ''
	player_bizs = {}
	cursor, errorstring = db_server:execute("SELECT * FROM `businesses` WHERE `Owner` = '"..nickname.."' ORDER BY ID")
	row = cursor:fetch ({}, "a")
	while row do
		table.insert(player_bizs, (row.ID-1))
		row = cursor:fetch(row, "a")
	end
	if player_bizs[1] then
		for i = 1, #player_bizs do
			if player_businessis == '' then
				player_businessis = '№'..player_bizs[i]
			elseif player_businessis ~= '' and tonumber(player_bizs[i-1]) < tonumber(player_bizs[i]) then
				player_businessis = player_businessis..', №'..player_bizs[i]
			end
		end
	else
		player_businessis = 'Отсутствуют'
	end
	return player_businessis
end

function getUserLevelDostup(userid)
	cursor, errorString = db_bot:execute("select * from cf_users where `userid` = '"..userid.."'")
	row = cursor:fetch({}, "a")
	if row then return row.userdostup else return 0 end
end

function isUserInsertInToDB(userid)
	cursor, errorString = db_bot:execute("select * from cf_users where `userid` = '"..userid.."'")
	row = cursor:fetch({}, "a")
	if row then return true else return false end
end

function isUserInsertInToDBForum(userid)
	cursor, errorString = db_forum:execute("select * from xf_user where `username` = '"..userid.."'")
	row = cursor:fetch({}, "a")
	if row then return true else return false end
end

function isUserInsertInToLogs(userid)
	cursor, errorString = db_server:execute("select * from user where `username` = '"..userid.."'")
	row = cursor:fetch({}, "a")
	if row then return true else return false end
end

function isUserInConference(userid)
	cursor, errorString = db_bot:execute("select * from cf_users where `userid` = '"..userid.."'")
	row = cursor:fetch({}, "a")
	if row then return true else return false end
end

function getUserBanReason(userid)
	cursor, errorString = db_bot:execute("select * from ban_list where `banuserid` = '"..userid.."'")
	row = cursor:fetch({}, "a")
	return row.banreason
end

function getUserBanByAdmin(userid)
	cursor, errorString = db_bot:execute("select * from ban_list where `banuserid` = '"..userid.."'")
	row = cursor:fetch({}, "a")
	return row.banadminid
end

function getUserWarns(userid)
	cursor, errorString = db_bot:execute("select * from cf_users where `userid` = '"..userid.."'")
	row = cursor:fetch({}, "a")
	return row.warns
end

function getUserVigs(userid)
	cursor, errorString = db_bot:execute("select * from cf_users where `userid` = '"..userid.."'")
	row = cursor:fetch({}, "a")
	return row.vigs
end

function getAllUsersIds()
	cursor,errorString = db_bot:execute([[select * from cf_users]])
	row = cursor:fetch ({}, "a")
	if cursor then
		while row do
			table.insert(all_users_ids, row.userid)
			row = cursor:fetch(row, "a")
		end
	end
end

function nForm(num, v1, v2, v3)
    if type(num) ~= 'number' then return end
    if (num % 10 == 1 and num % 10 ~= 11) then return v1
    elseif (num % 10 >= 2 and num % 10 <= 4) then return v2
    else return v3 end
end

function unix_decrypt(str)
    return os.date("%d.%m.%Y %X", str);
end

function splitByChunk(text, chunkSize)
    local s = {}
    for i=1, #text, chunkSize do
        s[#s+1] = text:sub(i,i+chunkSize - 1)
    end
    return s
end

function funcRoleSystem()
	cursor,errorString = db_bot:execute('select * from cf_users')
	row = cursor:fetch ({}, "a")
	if cursor then
		while row do
			if tonumber(row.roletime) > 0 and tonumber(row.userdostup) > 0 then
				if os.time() >= tonumber(row.roletime) then
					VkMessage('&#128686; У пользователя @id'..row.userid..'('..getUserName(row.userid)..') аннулированы права по истечению срока их действия.')
					db_bot:execute("update `cf_users` set `userdostup` = 0 where `userid` = '"..row.userid.."'")
					db_bot:execute("update `cf_users` set `roletime` = 0 where `userid` = '"..row.userid.."'")
				end
			end
			row = cursor:fetch(row, "a")
		end
	end
end

function isAdminInsert(nickname)
	cursor, errorString = db_bot:execute('select * from `admin_stats` where `adminnick` = "'..nickname..'"')
	row = cursor:fetch ({}, "a")
	if row then return true else return false end
end

function getAdminInfo(nickname)
	cursor, errorString = db_bot:execute("select * from admin_stats where `adminnick` = '"..nickname.."'")
	row = cursor:fetch({}, "a")
	return { 
		all_reports = row.all_reports, 
		week_events = row.week_events,
		all_events = row.all_events,
		all_bans = row.all_bans, 
		all_warns = row.all_warns, 
		all_demorgans =	row.all_demorgans, 
		all_mutes =	row.all_mutes, 
		all_online = row.all_online, 
		week_online = row.week_online, 
		week_reports = row.week_reports, 
		week_bans = row.week_bans, 
		week_warns = row.week_warns, 
		all_awarns = row.all_awarns, 
		week_awarns = row.week_awarns, 
		week_demorgans = row.week_demorgans, 
		week_mutes = row.week_mutes, 
		Monday = row.Monday, 
		Tuesday = row.Tuesday, 
		Wednesday = row.Wednesday, 
		Thursday = row.Thursday, 
		Friday = row.Friday, 
		Saturday = row.Saturday, 
		Sunday = row.Sunday, 
		days_inactive = row.days_inactive
	}
end

function getCheck(nickname)
	cursor, errorString = db_server:execute("select * from accounts where `NickName` = '"..nickname.."'")
	row = cursor:fetch({}, "a")
	return { 
		Reputation = row.Reputation
	}
end

function getPlayerCooldown(nick)
	cursor, errorString = db_bot:execute("select * from vr_users where `nick` = '"..nick.."'")
	row = cursor:fetch({}, "a")
	return { 
		nrg = row.nrg,
		flip = row.flip,
		spawn = row.spawn,
		infernus = row.infernus,
		try = row.try,
		help = row.help,
		teleport = row.teleport,
		hp = row.hp,
		pass = row.pass
	}
end

function getUserNameVk(userid)
	result = luaVkApi.getUsersInfo(userid)
	local t = json.decode(result)
	for k, v in ipairs(t.response) do
		firstname = u8:decode(v.first_name)
		lastname = u8:decode(v.last_name)
	end
	usernick = firstname..' '..lastname
	return usernick
end

function getUserName(userid)
	cursor, errorString = db_bot:execute('select * from cf_users where userid = '..userid)
	row = cursor:fetch ({}, "a")
	while row do
		if tostring(row.username) ~= 'NONE' then
			return row.username
		else
			result = luaVkApi.getUsersInfo(userid)
			local t = json.decode(result)
			for k, v in ipairs(t.response) do
				firstname = u8:decode(v.first_name)
				lastname = u8:decode(v.last_name)
			end
			usernick = firstname..' '..lastname
			return usernick
		end
	end
end

function getStatusForuPokras(leveldostup)
	if tonumber(leveldostup) == 2 then
		text = 'Пользователь'
	elseif tonumber(leveldostup) == 5 then
		text = 'Владелец'
	elseif tonumber(leveldostup) == 6 then
		text = 'Разработчик'
	elseif tonumber(leveldostup) == 8 then
		text = 'Зам. владельца'
	elseif tonumber(leveldostup) == 9 then
		text = 'Создатель'
	elseif tonumber(leveldostup) == 10 then
		text = 'Зам. Создатель'
	elseif tonumber(leveldostup) == 11 then
		text = 'Основатель'
	elseif tonumber(leveldostup) == 12 then
		text = 'Зам. Основателя'
	elseif tonumber(leveldostup) == 13 then
		text = 'Руководитель'
	elseif tonumber(leveldostup) == 14 then
		text = 'Зам. Руководителя'
	elseif tonumber(leveldostup) == 15 then
		text = 'Спец. Администратор'
	elseif tonumber(leveldostup) == 16 then
		text = 'Главный Тех'
	elseif tonumber(leveldostup) == 17 then
		text = 'Зам. Гл. Теха'
	elseif tonumber(leveldostup) == 18 then
		text = 'ГА'
	elseif tonumber(leveldostup) == 19 then
		text = 'ЗГА'
	elseif tonumber(leveldostup) == 20 then
		text = 'Куратор Нел'
	elseif tonumber(leveldostup) == 21 then
		text = 'Куратор Опр'
	elseif tonumber(leveldostup) == 22 then
		text = 'Куратор Гос'
	elseif tonumber(leveldostup) == 23 then
		text = 'Куратор Адм'
	elseif tonumber(leveldostup) == 24 then
		text = 'Пиар Менеджер'
	elseif tonumber(leveldostup) == 25 then
		text = 'Зам. Пиар Менеджера'
	else
		text = 'Не известная'
	end
	return text
end

function getStatusNameByLevelDostup(leveldostup)
	if tonumber(leveldostup) == 0 then
		text = 'Пользователь'
	elseif tonumber(leveldostup) == 1 then
		text = 'Администратор'
	elseif tonumber(leveldostup) == 2 then
		text = 'Спец. Администратор'
	elseif tonumber(leveldostup) == 3 then
		text = 'Руководитель'
	elseif tonumber(leveldostup) == 4 then
		text = 'Основатель'
	else
		text = 'Не определён'
	end
	return text
end

function updateArrayCommands()
	custom_all_bot_commands = { 
		{'q', 'выйти из беседы', getDostupRankForUseCommand('q'), 0},
		{'snick', 'установить ник-нейм в беседе', getDostupRankForUseCommand('snick'), 1},
		{'rnick', 'удалить ник-нейм в беседе', getDostupRankForUseCommand('rnick'), 1},
		{'nlist', 'вывести список ников беседы', getDostupRankForUseCommand('nlist'), 1},
		{'ac', 'выполнить действие от лица бота', getDostupRankForUseCommand('ac'), 1},
		{'zov', 'вызвать всех членов беседы', getDostupRankForUseCommand('zov'), 1},
		{'stats', 'посмотреть статистику участника беседы', getDostupRankForUseCommand('stats'), 1},
		{'online', 'посмотреть онлайн сервера', getDostupRankForUseCommand('online'), 1},
		{'help', 'посмотреть доступные команды', getDostupRankForUseCommand('help'), 1},
		{'question', 'запустить рандомный вопрос', getDostupRankForUseCommand('question'), 1},
		{'captcha', 'запустить капчу на скин', getDostupRankForUseCommand('captcha'), 1},
		{'admins', 'посмотреть список администрации в игре', getDostupRankForUseCommand('admins'), 1},
		{'reports', 'посмотреть количество репорта на сервере', getDostupRankForUseCommand('reports'), 1},
		{'removerole', 'удалить роль в беседе', getDostupRankForUseCommand('removerole'), 2},
		{'mtop', 'посмотреть топ по сообщениям', getDostupRankForUseCommand('mtop'), 2},
		{'addadmin', 'выдать права администратора беседы', getDostupRankForUseCommand('addadmin'), 2},
		{'kick', 'исключить пользователя из беседы', getDostupRankForUseCommand('kick'), 2},
		{'astats [name adm]', 'посмотреть статистику администратора', getDostupRankForUseCommand('astats'), 2},
		{'check [name]', 'посмотреть статистику игрока', getDostupRankForUseCommand('check'), 2},
		{'checkinv [name]', 'посмотреть инвентарь игрока', getDostupRankForUseCommand('checkinv'), 2},
		{'addspec', 'выдать права специального администратора беседы', getDostupRankForUseCommand('addspec'), 3},
		{'iwl', 'прописать человека в беседе', getDostupRankForUseCommand('iwl'), 3},
		{'mute', 'выдать затычку в беседе', getDostupRankForUseCommand('mute'), 3},
		{'unmute', 'снять затычку в беседе', getDostupRankForUseCommand('unmute'), 3},
		{'greetings [text]', 'установить приветствие при добавлении пользователя в беседу', getDostupRankForUseCommand('greetings'), 3},
		{'rkick', 'хз что это', getDostupRankForUseCommand('rkick'), 4},
		{'addowner', 'выдать доверку в беседе', getDostupRankForUseCommand('addowner'), 4},
		{'editcmd [cmd] [lvl 1-4]', 'сменить дсотуп к команде', getDostupRankForUseCommand('editcmd'), 4},
		{'dlist', 'список администраторов имеющих досту к боту в игре', getDostupRankForUseCommand('dlist'), 1},
		{'twl', 'забрать досту к боту в игре', getDostupRankForUseCommand('twl'), 3},
		{'al', 'выдать досту к боту в игре', getDostupRankForUseCommand('gwl'), 3},
		{'staff', 'посмотреть роли участников', getDostupRankForUseCommand('staff'), 1},
	}
end

function isCommandFormAutoAccept(cmd)
	cursor, errorString = db_bot:execute('select * from `forms_list` where `word` = "'..cmd..'"')
	row = cursor:fetch ({}, "a")
	if row then return true else return false end
end

function isCommandFormNoAutoAccept(cmd)
	cursor, errorString = db_bot:execute('select * from `no_forms_list` where `word` = "'..cmd..'"')
	row = cursor:fetch ({}, "a")
	if row then return true else return false end
end

function isUserHaveDostupInGame(nickname)
	cursor, errorString = db_bot:execute('select * from `whitelist` where `gamenick` = "'..nickname..'"')
	row = cursor:fetch ({}, "a")
	if row then return true else return false end
end

function getDostupRankForUseCommand(cmd)
	cursor, errorString = db_bot:execute('select * from `cmdlist` where `command` = "'..cmd..'"')
	row = cursor:fetch ({}, "a")
	return tonumber(row.custom_rank)
end

function convertToMinutes(arg)
	minutes = math.modf(tonumber(arg) / 60)
	seconds = arg - (math.modf(tonumber(arg) / 60) * 60)
	if seconds == 0 then
		return minutes..'мин.'
	else
		return minutes..'мин. '..seconds..'сек.'
	end
end

function isCommandExists(cmd)
	cursor, errorString = db_bot:execute('select * from `cmdlist` where `command` = "'..cmd..'"')
	row = cursor:fetch ({}, "a")
	if row then return true else return false end
end

function getPlayerInvItems(nickname)
	InvItem = {}
	InvItemAmount = {}
	Sharpening = {}
	text = ''
	cursor, errorstring = db_server:execute("SELECT * FROM `accounts` WHERE `NickName` = '"..nickname.."'")
	row = cursor:fetch ({}, "a")
	while row do
		for id in row.Item:gmatch('(%d+)') do
			table.insert(InvItem, id)
		end
		for id in row.ItemKolvo:gmatch('(%d+)') do
			table.insert(InvItemAmount, id)
		end
		for id in row.ItemLevel:gmatch('(%d+)') do
			table.insert(Sharpening, id)
		end
		row = cursor:fetch(row, "a")
	end
	if InvItem[1] then
		for i = 1, #InvItem do
			if tonumber(InvItem[i]) > 0 then
				if tonumber(Sharpening[i]) == 0 then 
					current_sharpening = ''
				else
					current_sharpening = ' | +'..Sharpening[i]
				end
				text = text..'\n'..convertToSmile(i)..' | '..getItemName(InvItem[i])..' ['..InvItemAmount[i]..current_sharpening..']'
			else
				i = i + 1
			end
		end
	else
		text = '&#10060; Инвентарь полностью пуст.'
	end
	return text
end

function getPlayerHouses(nickname)
	player_houses = ''
	player_housz = {}
	cursor, errorstring = db_server:execute("SELECT * FROM `houses` WHERE `Owner` = '"..nickname.."' ORDER BY ID")
	row = cursor:fetch ({}, "a")
	while row do
		table.insert(player_housz, (row.ID-1))
		row = cursor:fetch(row, "a")
	end
	if player_housz[1] then
		for i = 1, #player_housz do
			if player_houses == '' then
				player_houses = '№'..player_housz[i]
			elseif player_houses ~= '' and tonumber(player_housz[i-1]) < tonumber(player_housz[i]) then
				player_houses = player_houses..', №'..player_housz[i]
			end
		end
	else
		player_houses = 'Отсутствуют'
	end
	return player_houses
end

function isAccountExists(nickname)
	cursor, errorstring = db_server:execute('select * from `accounts` where `NickName` = "'..nickname..'"')
	row = cursor:fetch ({}, "a")
	if row then return true else return false end
end

function isUserHaveMute(userid)
	cursor, errorString = db_bot:execute("select * from cf_users where `userid` = '"..userid.."'")
	row = cursor:fetch({}, "a")
	while row do
		if tonumber(row.mutetime) > 0 then return true else return false end
	end
end

newTask(function()
    while true do
		wait(tonumber(config[3][2])*1000)
		if isConnected() then
			sendInput('/ao Нужен флип? Пишите: /vr "почините", "флип"')
			sendInput('/ao Нужен Инфернус? Пишите: /vr "дайте тачку", "дайте инфернус"')
			sendInput('/ao Нужен NRG? Пишите: /vr "дайте нрг", "дайте мотоцикл"')
			sendInput('/ao Нужно заспавниться? Пишите: /vr "заспавните", "спавн"')
			sendInput('/ao Нужно на АБ? Пишите: /vr "бот тп аб", "бот тп на аб"')
			sendInput('/ao Нужно на ЦР? Пишите: /vr "бот тп цр", "бот тп на цр"')
			sendInput('/ao Нужно на ЦБ? Пишите: /vr "бот тп цб", "бот тп на цб"')
			sendInput('/ao Нужно в Мерию? Пишите: /vr "бот тп в мерию", "тп в мерию"')
			sendInput('/ao Нужен паспорт? Пишите: /vr "дайте паспорт", "Дайте паспорт"')
			VkMessage('&#127757; Информация о взаимодействии с ботом отправлена [отправляется раз в '..tonumber(config[3][2])..' секунд].')
		end
	end
end)

function updateItems()
	items = {}
	cursor, errorString = db_bot:execute('select * from items')
	row = cursor:fetch({}, "a")
	while row do
		table.insert(items, {id = row.id, name = row.name, color = row.color})
		row = cursor:fetch(row, "a")
	end
end

newTask(function()
    while true do
		wait(tonumber(config[1][2])*1000)
		if isConnected() then
			sendInput('/ao -> Доброго времени суток , на форуме открыты заявки на пост администратора 1-го уровня.')
			wait(500)
			sendInput('/ao -> Чтобы попасть на пост администратора , вам понадобится: ')
			sendInput('/ao -> 1. Возраст 14 и более лет.')
			sendInput('/ao -> 2. Знать правила сервера.')
			sendInput('/ao -> 3. Иметь игровой уровень не меньше 15.')
			sendInput('/ao -> 4. Не быть действующим лидером во фракции.')
			sendInput('/ao -> Наш форум - '..forum_link)
			VkMessage('	&#128483; Реклама заявок на админа отправлена. Отправляется раз в '..tonumber(config[1][2])..' sec.')
		end
	end
end)

newTask(function()
    while true do
		wait(tonumber(config[8][2])*100000)
		if isConnected() then
			sendInput('/a REPORT REPORT REPORT')
			sendInput('/a REPORT REPORT REPORT')
			sendInput('/a REPORT REPORT REPORT')
			sendInput('/a REPORT REPORT REPORT')
			sendInput('/a REPORT REPORT REPORT')
			VkMessage('	&#128483; Информация о работе для админов успешно отправлена. Отправляется раз в '..tonumber(config[8][2])..' sec.')
		end
	end
end)

function getAdminNeactiveStartAndFinish(usernick)
	cursor, errorString = db_bot:execute('select * from neactive_list where `adminnick` = "'..usernick..'"')
	row = cursor:fetch ({}, "a")
	return { start = unix_decrypt(row.date_start), finish = unix_decrypt(row.date_finish) }
end

function isAdminHaveNeactive(usernick)
	cursor, errorString = db_bot:execute('select * from neactive_list where `adminnick` = "'..usernick..'"')
	row = cursor:fetch ({}, "a")
	if row then return true else return false end
end

newTask(function()
    while true do
		wait(tonumber(config[5][2])*1000)
		if isConnected() then
			sendInput('/ao Уважаемые игроки, хотите всегда быть в курсе событий происходящих на сервере и за его границами?')
			wait(500)
			sendInput('/ao Для такого случая у нас есть наша группа VK - '..vk_group_link..', узнавайте новости самым первым!')
			wait(500)
			VkMessage('	&#128483; Реклама группы ВК отправлена. Отправляется раз в '..tonumber(config[5][2])..' sec.')
		end
	end
end)

newTask(function()
	while true do
		wait(tonumber(config[2][2])*1000)
		if isConnected() then
			startCaptcha()
		end
	end
end)

newTask(function()
	while true do
		wait(tonumber(config[6][2])*1000)
		if isConnected() then
			startSkin()
		end
	end
end)