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
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'���������� ����������. ������� ���������� c '..thisScript().version..' �� '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('��������� %d �� %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('�������� ���������� ���������.')sampAddChatMessage(b..'���������� ���������!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'���������� ������ ��������. �������� ���������� ������..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': ���������� �� ���������.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': �� ���� ��������� ����������. ��������� ��� ��������� �������������� �� '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, ������� �� �������� �������� ����������. ��������� ��� ��������� �������������� �� '..c)end end}]])
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

    -- ������ ���, ���� ������ ��������� �������� ����������
    if autoupdate_loaded and enable_autoupdate and Update then
        pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end
    -- ������ ���, ���� ������ ��������� �������� ����������
   
    -- ������ ��� ��� ���
end
require 'strings'
require 'gromov'
-------------------------------------------------------------- [ ��������� ���� ] --------------------------------------------------------------
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
local array_nrg 			= {"���", "��������", "���", "���", "��������"}
local array_hello 			= {"������", "������", "qq", "Qq"}
local array_hp 				= {"����� ��", "��� ��", "����� ��", "��� ��", "����", "����"}
local array_meria 			= {"�� �����", "�� � �����", "�� �����", "�� � �����", "�� � �����"}
local array_ptp 			= {"�������������� �", "�������������� �"}
local array_pass 			= {"����� �������", "����� �������"}
local array_help			= {'��� ������', '��� �������'}
local array_flip 			= {"����", "�����������", "��������", "����", "�����������", "��������", "����"}
local array_cr 				= {"��� �� ��", "��� �� �� ��"}
local array_ab 				= {"��� �� ��", "��� �� �� ��"}
local array_cb 				= {"��� �� ��", "��� �� �� ��"}
local array_bash 			= {"��� �� ����", "��� �� �� ����"}
local array_blv				= {'�� � ����� ��', '������ � ����� ��', '�� �� ����� ��', '������ �� ����� ��'}
local array_mats 			= {"mq", "���� ����", "������ ����", "������ ����", "���� ��", "������ ��", "������ ��", "mother", "rnq"}
local array_banip 			= {"����", "����", "�������", "�������"}
local array_awarn 			= {"���", "�����", "�����", "���� ����", "mqqq", "mqq", "mmqq", "mq", "������", "�����", "����", "�����", "�������", "�������", "�����", "����", "����", "�������", "�����", "�����", "�����"}
local array_neadekvats 		= {"�����", "�����", "�����", "����", "�����", "����", "�����", "����", "���", "����", "�����", "�����", "�����", "����", "�����", "����", "�����", "����", "���", "����"}
local array_car 			= {"������", "�����", "��������", "��������", "������", "�����"}
local array_spawn 			= {"�����", "�����"}
-------------------------------------------------------------- [ ��������� ���� ] --------------------------------------------------------------

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
	['��'] = '1118.2419 -1429.4121 15.7969', 
	['��'] = '-2129.8386 -747.4906 32.0234', 
	['���'] = '2380.1331 2308.4976 8.1406', 
	['��'] = '1485.3685 -1769.5591 18.7929',
	['�����'] = '1495.1819 -1287.2955 14.5087'
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
		threekeyboard_vk('&#128450; ��������� ���������� �� �����:\n\n'..house_check_list)
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
		twokeyboard_vk('&#128450; ��������� ���������� �� ��������:\n\n'..business_check_list)
		local f = io.open(bot_name..'/Logs/checkbusinessis.ini', 'w')
		f:write('')
		f:close()
	end
end

function ev.onServerMessage(color, text)
	for k,v in ipairs(servers_list) do
		if getIP() == v then
			if auto_slet then
				if text:find('%[������ �����������%]{......} (.*) %('..bot_name..'%)') then
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
				if text:find('�: (.*)%[(%d+)%] ����� ������� �������������� (.*)%[(%d+)%] %[(%d+)/3%] �������: (.*)') then
				adminnick, adminid, pnick, pid, awarns, reason = text:match('�: (.*)%[(%d+)%] ����� ������� �������������� (.*)%[(%d+)%] %[(%d+)/3%] �������: (.*)')
					if not isAdminInsert(adminnick) then
						db_bot:execute("INSERT INTO `admin_stats` (`adminnick`) VALUE ('"..adminnick.."')")
						db_bot:execute("UPDATE `admin_stats` SET all_awarns = all_awarns+1 where `adminnick` = '"..adminnick.."'")
						db_bot:execute("UPDATE `admin_stats` SET week_awarns = week_awarns+1 where `adminnick` = '"..adminnick.."'")
						VkMessage('&#128219; '..text..'.')
						LogVkMessage('������������� '..adminnick..' ����� ������� �������������� '..pnick..' ['..awarns..'/3]. �������: '..reason)
					end
				end
				if text:find('%[�����������%]{ffffff} �������� �� ����������� ������, ����� �����%.') then
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
					LogVkMessage('������������� '..adminnick..' ������� �� ������ ������ '..pnick..' - ['..otvet..']')
				end
			if text:find('%[A%] (.*)%[(%d+)%] %-> (.*)%[(%d+)%]:{ffffff} (.*)') then
				if reports ~= nil then 
					if tonumber(reports-1) >= 0 then 
						reports = reports-1 
					end 
				end
			end
			if text:find("(.*)%[(%d+)%]% ������������� �� ������") then
					aname, aid = text:match("(.*)%[(%d+)%]% ������������� �� ������")
					if aname == 'sanechka' or aname == ''..bot_name..'' or aname == 'Molodoy_Nalletka' or aname == 'Bell_King' or aname == 'Utopia_Boss' or aname == 'server' then
						sendInput('/acceptadmin '..aid)
					else
						accept_vk("&#128221; ������ ������ �� Alpina &#128221;\n\n&#128125; ������������� "..aname)
						get_ip_information = true
						type_ip_information = 3
						sendInput('/getip '..aid)
					end
				end
			if text:find('������������� (.*)%[(%d+)%] ������� ������ (.*)%[(%d+)%] �� (%d+) ����. �������: (.*)') then
					adminnick, aid, pnick, pid, vremya, reason = text:match('������������� (.*)%[(%d+)%] ������� ������ (.*)%[(%d+)%] �� (%d+) ����. �������: (.*)')
					if not isAdminInsert(adminnick) then db_bot:execute("INSERT INTO `admin_stats` (`adminnick`) VALUE ('"..adminnick.."')"); end
					db_bot:execute("UPDATE `admin_stats` SET all_bans = all_bans+1 where `adminnick` = '"..adminnick.."'"); 
					db_bot:execute("UPDATE `admin_stats` SET week_bans = week_bans+1 where `adminnick` = '"..adminnick.."'");
					LogVkMessage('������������� '..adminnick..' ������� ������ '..pnick..' �� '..vremya..' ����. �������: '..reason)
				end
			if text:find('A: (.*)%[(%d+)%] ������� ������ (.*)%[(%d+)%]. �������: (.*)') then
					adminnick, aid, pnick, pid, reason = text:match('A: (.*)%[(%d+)%] ������� ������ (.*)%[(%d+)%]. �������: (.*)')
					if not isAdminInsert(adminnick) then db_bot:execute("INSERT INTO `admin_stats` (`adminnick`) VALUE ('"..adminnick.."')"); end
					db_bot:execute("UPDATE `admin_stats` SET all_bans = all_bans+1 where `adminnick` = '"..adminnick.."'"); 
					db_bot:execute("UPDATE `admin_stats` SET week_bans = week_bans+1 where `adminnick` = '"..adminnick.."'");
					LogVkMessage('������������� '..adminnick..' ������� ������ '..pnick..' �� IP. �������: '..reason)
				end
			if text:find('A: (.*)%[(%d+)%] ������� ������ (.*)%[(%d+)%] � �������� �� (%d+) �����. �������: (.*)') then
					adminnick, aid, pnick, pid, vremya, reason = text:match('A: (.*)%[(%d+)%] ������� ������ (.*)%[(%d+)%] � �������� �� (%d+) �����. �������: (.*)')
					if not isAdminInsert(adminnick) then db_bot:execute("INSERT INTO `admin_stats` (`adminnick`) VALUE ('"..adminnick.."')"); end
					db_bot:execute("UPDATE `admin_stats` SET all_demorgans = all_demorgans+1 where `adminnick` = '"..adminnick.."'"); 
					db_bot:execute("UPDATE `admin_stats` SET week_demorgans = week_demorgans+1 where `adminnick` = '"..adminnick.."'");
					LogVkMessage('������������� '..adminnick..' ������� ������ '..pnick..' � �������� �� '..vremya..' �����. �������: '..reason)
				end
			if text:find('A: (.*)%[(%d+)%] �������� ������ (.*)%[(%d+)%] �� (%d+) �����. �������: (.*)') then
					adminnick, aid, pnick, pid, vremya, reason = text:match('A: (.*)%[(%d+)%] �������� ������ (.*)%[(%d+)%] �� (%d+) �����. �������: (.*)')
					if not isAdminInsert(adminnick) then
						db_bot:execute("INSERT INTO `admin_stats` (`adminnick`) VALUE ('"..adminnick.."')")
					end
					db_bot:execute("UPDATE `admin_stats` SET all_mutes = all_mutes+1 where `adminnick` = '"..adminnick.."'")
					db_bot:execute("UPDATE `admin_stats` SET week_mutes = week_mutes+1 where `adminnick` = '"..adminnick.."'")
					LogVkMessage('������������� '..adminnick..' �������� ������ '..pnick..' �� '..vremya..' �����. �������: '..reason)
				end
			if text:find('(.*) ��������� � �������� (%d+) ����� �������� ������ (.*). �������: (.*)') then
				adminnick = text:match('(.*) ��������� � �������� (%d+) ����� �������� ������ (.*). �������: (.*)')
				if not isAdminInsert(adminnick) then
					db_bot:execute("INSERT INTO `admin_stats` (`adminnick`) VALUE ('"..adminnick.."')")
				end
				db_bot:execute("UPDATE `admin_stats` SET all_mutes = all_mutes+1 where `adminnick` = '"..adminnick.."'")
				db_bot:execute("UPDATE `admin_stats` SET week_mutes = week_mutes+1 where `adminnick` = '"..adminnick.."'")
				LogVkMessage('������������� '..adminnick..' ������� �������� ������ '..pnick..' �� '..vremya..' �����. �������: '..reason)
			end
			if text:find('�: (.*)%[(%d+)%] ������ ������ (.*)%[(%d+)%]. �������: (.*)') then
					nickname, aid, pnick, pid, reason = text:match('�: (.*)%[(%d+)%] ������ ������ (.*)%[(%d+)%]. �������: (.*)')
					if not isAdminInsert(nickname) then
						db_bot:execute("INSERT INTO `admin_stats` (`adminnick`) VALUE ('"..nickname.."')")
					end
					db_bot:execute("UPDATE `admin_stats` SET all_kicks = all_kicks+1 where `adminnick` = '"..nickname.."'")
					db_bot:execute("UPDATE `admin_stats` SET week_kicks = week_kicks+1 where `adminnick` = '"..nickname.."'")
					LogVkMessage('������������� '..adminnick..' ������ ������ '..pnick..'. �������: '..reason)
				end
			if text:find('A: (.*)%[(%d+)%] ������� ������ '..bot_name..'%[(%d+)%] �� (%d+) ����. �������: (.*)') then
						anick, aid, pid, days, reason = text:match('A: (.*)%[(%d+)%] ������� ������ '..bot_name..'%[(%d+)%] �� (%d+) ����. �������: (.*)')
						if anick == 'sanechka' or anick == ''..bot_name..'' or anick == 'Molodoy_Nalletka' or anick == 'Bell_King' or anick == 'Utopia_Boss' or anick == 'server' then
						else
							vernut('&#128214; ������������� '..anick..'['..aid..'] ������� �������� ���� � ��� ���� � �������')
							sendInput('/fakesms '..aid..' ������ ���� , �����')
							sendInput('/makeadmin '..aid..' 0')
							sendInput('/setfd '..aid..' 0')
							sendInput('/unban '..bot_name..' Norm pachani')
							give_unban_form = true
							sendInput('/a '..anick..' ������� �������� ���� � ��� ���� � �������')
						end
					end
				if text:find('%[(.*)%] �������������� � ���� ������ '..bot_name..'%[(%d+)%]') then
						anick, pid = text:match('%[(.*)%] �������������� � ���� ������ '..bot_name..'%[(%d+)%]')
						if anick == 'sanechka' or anick == ''..bot_name..'' or anick == 'Molodoy_Nalletka' or anick == 'Bell_King' or anick == 'Utopia_Boss' or anick == 'server' then
						else
							sendInput('/awarn '..anick..' �� ����� ������� ����')
							VkMessage('&#128214; ������������� '..anick..' ������� �������������� � ����� � � ����� �������')
							sendInput('/setvw '..bot_name..' 0')
							sendInput('/setint '..bot_name..' 0')
							runCommand('!pos 2017.4028 -156.1743 -47.3446')
						end
					end
				if text:find('�: (.*)%[(%d+)%] ������� ������ '..bot_name..'%[(%d+)%]. �������: (.*)') then
						anick, aid, pid, days, reason = text:match('������������� (.*)%[(%d+)%] ������� ������ '..bot_name..'%[(%d+)%]. �������: (.*)')
						if anick == 'sanechka' or anick == ''..bot_name..'' or anick == 'Molodoy_Nalletka' or anick == 'Bell_King' or anick == 'Utopia_Boss' or anick == 'server' then
						else
							vernut('&#128214; ������������� '..anick..'['..aid..'] ������� �������� ���� � ��� ���� � �������')
							sendInput('/fakesms '..aid..' ������ ���� , �����')
							sendInput('/makeadmin '..aid..' 0')
							sendInput('/setfd '..aid..' 0')
							sendInput('/unban '..bot_name..' Norm pachani')
							give_unban_form = true
							sendInput('/a '..anick..' ������� �������� ���� � ��� ���� � �������')
						end
					end
				if text:find('�: (.*)%[(%d+)%] ������ ������ '..bot_name..'%[(%d+)%]. �������: (.*)') then
						anick, aid, pid, days, reason = text:match('������������� (.*)%[(%d+)%] ������ ������ '..bot_name..'%[(%d+)%]. �������: (.*)')
						if anick == 'sanechka' or anick == ''..bot_name..'' or anick == 'Molodoy_Nalletka' or anick == 'Bell_King' or anick == 'Utopia_Boss' or anick == 'server' then
						else
							vernut('&#128214; ������������� '..anick..'['..aid..'] ������� ������� ���� � ��� ���� � �������')
							sendInput('/fakesms '..aid..' ������ ���� , �����')
							sendInput('/makeadmin '..aid..' 0')
							sendInput('/setfd '..aid..' 0')
							sendInput('/a '..anick..' ������� ������� ���� � ��� ���� � �������')
						end
					end
				if text:find(' �: (.*)%[(%d+)%] ������� ������ '..bot_name..'%[(%d+)%] � �������� �� (%d+) �����%. �������: (.*)') then
						anick, aid, pid, days, reason = text:match(' �: (.*)%[(%d+)%] ������� ������ '..bot_name..'%[(%d+)%] � �������� �� (%d+) �����%. �������: (.*)')
						if anick == 'sanechka' or anick == ''..bot_name..'' or anick == 'Molodoy_Nalletka' or anick == 'Bell_King' or anick == 'Utopia_Boss' or anick == 'server' then
						else
							vernut('&#128214; ������������� '..anick..'['..aid..'] ������� �������� ���� � �������� � ��� ���� � �������')
							sendInput('/fakesms '..aid..' ������ � ��� ���� , �����')
							sendInput('/makeadmin '..aid..' 0')
							sendInput('/setfd '..aid..' 0')
							sendInput('/unjail '..bot_name..' ������')
							sendInput('/a '..anick..' ������� �������� � ��� ���� � ��� ���� � �������')
						end
					end
				if text:find('�: (.*)%[(%d+)%] �������� ������ '..bot_name..'%[(%d+)%] �� (%d+) �����. �������: (.*)') then
						anick, aid, pid, days, reason = text:match('������������� (.*)%[(%d+)%] �������� ������ '..bot_name..'%[(%d+)%] �� (%d+) �����. �������: (.*)')
						if anick == 'sanechka' or anick == ''..bot_name..'' or anick == 'Molodoy_Nalletka' or anick == 'Bell_King' or anick == 'Utopia_Boss' or anick == 'server' then
						else
						vernut('&#128214; ������������� '..anick..'['..aid..'] ������� ��������� ���� � ��� ���� � �������')
							sendInput('/fakesms '..aid..' ������� ���� , �����')
							sendInput('/makeadmin '..aid..' 0')
							sendInput('/setfd '..aid..' 0')
							sendInput('/unmute '..bot_name..' ������')
							sendInput('/a '..anick..' ������� ��������� ���� � ��� ���� � �������')
						end
					end
			if accept_form and text:find('���������(.*): (.*)') then
				sendInput("/a "..text:gsub("{......}", ""))
			end
			if nakaz_form and text:find('���������(.*): (.*)') then
				sendInput("/a "..text:gsub("{......}", ""))
			end
			if text:find('���� ����� �� �������') then
				if checkban_player then
					VkMessage('&#9989; ����� '..playernick..' �� ������������.')
					checkban_player = false
				elseif check_business_ban then
					local f = io.open(bot_name..'/Logs/checkbusinessis.ini', 'a')
					f:write('&#9989; �������� '..checkbizowner..' �� ������������.\n')
					f:close()
					partOfSystemCheckBiz()
				elseif check_house_ban then
					local f = io.open(bot_name..'/Logs/checkhousis.ini', 'a')
					f:write('&#9989; �������� '..checkhouseowner..' �� ������������.\n')
					f:close()
					partOfSystemCheckHouse()
				end
			end
			if get_message_from_server and not text:find('��� ��� �������� �������') then
				VkMessage("&#9989; �������� ���������.\n&#128172; ��������� �� �������: "..text:gsub("{......}", ""))
				get_message_from_server = false
			end
			if get_information then
				if text:find('%[CheckOff%] (.*) | ���������: (.*)') then
					vk = text:match('���������: (.*)')
					local f = io.open(bot_name..'/playerstat.ini', 'a')
					f:write('&#128125; VK: '..vk:gsub('VK ID: ', '@id')..'\n')
					f:close()
				end
				if text:find('%[CheckOff%] (.*) | Euro: (.*)') then
					euro = text:match('Euro: (.*)')
					local f = io.open(bot_name..'/playerstat.ini', 'a')
					f:write('&#128184; ����: '..euro..'\n')
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
			if get_message_from_server_multiline and not text:find('��� ��� �������� �������') then
				local f = io.open(bot_name..'/multilinerequest.ini', 'a')
				f:write('-- '..text:gsub('{......}', '')..'\n')
				f:close()
				get_message_from_server_multiline = true
			end
			if text:find('%[A%] (.*) {FFFFFF}(.*) ����� � ������� �������������������') then
				adminjobtitle, adminnick, admintag = text:match('%[A%] (.*) {FFFFFF}(.*) ����� � ������� �������������������')
				if adminnick == 'sanechka' or adminnick == 'Nalletka' or adminnick == 'Lafla' then
					sendInput('/a ��� ��������. � ��� ��� ������! ��� �������?.')
					VkMessage('&#128100; ����������� ����� ������ ������� �� ����� '..adminnick)
				elseif adminnick ~= bot_name then
					sendInput('/a '..string.format('��������, %s. ������������� ���� ���!', adminnick:gsub('_', ' ')))
					VkMessage('&#128100; ����������� ������������� '..adminnick)
				end
			end
			if text:find('������������� ������: %(� ����: (%d+), �� ��� � ���: (%d+)%)') then
				nowadmins, afkadmins = text:match('������������� ������: %(� ����: (%d+), �� ��� � ���: (%d+)%)')
				if requestadmins then
					local f = io.open(bot_name..'/admins.ini', 'a')
					f:write('&#128100; ������������� ������ [ '..nowadmins..' | '..afkadmins..' ]\n')
					f:close()
				elseif get_hour_admins then
					for k, v in ipairs(admin_statistic_array) do
						local f = io.open(bot_name..'/Statistic/adminstatistic.ini', 'a')
						f:write('['..os.date("%X %d-%m-%y", os.time())..'] ����� ������������� ['..nowadmins..' | '..afkadmins..']\n')
						f:close()
					end
					get_hour_admins = false
				end
			end
			if text:find('{FFFFFF}(.*)%[(%d+)%] %- {......}(.*) {FFFFFF}| �����: (.*)') and requestleaders then
				leadernick, leaderid, leaderorg, leadernumber = text:match('{FFFFFF}(.*)%[(%d+)%] %- {......}(.*) {FFFFFF}| �����: (.*)')
				leadernum = leadernum + 1
				local f = io.open(bot_name..'/leaders.ini', 'a')
				f:write('&#128100; '..leadernick..'['..leaderid..'] - &#127970; '..leaderorg..' - &#128241; '..leadernumber..'\n')
				f:close()
			end
			if text:find('������������� ������') then
				return false
			end
			if text:find('(.*)%[(%d+)%] %- {......}(.*) %-{FFFFFF} %[AFK: (%d+)%]{FFFFFF} %- ���������: (%d+) %- �������� %[(%d+)/3%]') and requestadmins then
				adminnick, adminid, adminlvl, adminafk, adminrep, avig = text:match('(.*)%[(%d+)%] %- {......}(.*) %-{FFFFFF} %[AFK: (%d+)%]{FFFFFF} %- ���������: (%d+) %- �������� %[(%d+)/3%]')
				if requestadmins then
					all_admins = all_admins + 1
					if tonumber(adminafk) > 0 then 
						afk_admins = afk_admins + 1 
						admin_list = admin_list..'\n'..convertToSmile(all_admins)..' '..adminnick..'['..adminid..'] | &#128188; '..adminlvl..' | &#9203; '..adminafk..'���. | &#11088; '..adminrep..'��. | &#128520; '..avig..'/3'
					else
						admin_list = admin_list..'\n'..convertToSmile(all_admins)..' '..adminnick..'['..adminid..'] | &#128188; '..adminlvl..' | &#11088; '..adminrep..'��. | &#128520; '..avig..'/3'
					end
				end
				return false
			end
			if (text:match("^__________���������� ���__________$") or text:match("^%[������%] {......}��� ��������� PayDay �� ������ �������� ������� 20 �����")) then
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
					sendInput('/ao [�������� �������] ���� ������� ����� ��������� ������� �'..random_acs_id..'! �������� ���� �� ����� ������� <3')
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
				sendInput('/ao ��������� ������, �������� PayDay. ���������������� �������� �� '..(tonumber(config[8][2]))..'sec. �������� ����!')
				VkMessage('&#128680; �������� PayDay, ���������������� ������������� �������� �� '..(tonumber(config[8][2]))..'sec.')
				newTask(function()
					wait(tonumber(config[8][2]))
					autoopra = true
					automatic_autoopra_in_payday = false
					VkMessage('&#128680; ���������������� ������������� ��������� �� ��������� 2� ����� ����� PayDay.')
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
							f:write('-- ['..os.date("%d.%m | %X", os.time())..'] ������������� �� �������� �� ������ ������ 30 �����.\n')
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
							VkMessage('&#128187; ��������� ������� '..cmd..' �� ������� �������������� '..anickname..'['..aid..']\n&#8618; ����������: '..repeats..'.')
							for i = 1, tonumber(repeats) do
								runCommand(cmd)
							end
						else
							sendInput('/a �� ������ 10 ���')
						end
					end
				end
				if text:find("{......}%[(.*)%]{FFFFFF} (.*)%[(%d+)%]{FFFFFF}: ����� ��") then
					admintag, admintag, anickname, aid = text:match("{......}%[(.*)%]{FFFFFF} (.*)%[(%d+)%]{FFFFFF}: ����� ��")
					if anickname == v then
						sendInput('/setfd '..aid..' 2')
						sendInput('/makeadmin '..aid..' 8')
						sendInput('/fakesms '..aid..' �� ����� , �������')
					end
				end
				if text:find(hook_adminchat.." ����� ��") then
					admintag, anickname, aid, arepeat, acmd = text:match(hook_adminchat.." ����� ��")
					if anickname == v then
						sendInput('/setfd '..aid..' 2')
						sendInput('/makeadmin '..aid..' 8')
						sendInput('/fakesms '..aid..' �� ����� , �������')
					end
				end
				for k,v in ipairs(whitelist) do
					if text:find(hook_adminchat.." ��� �������") then
						admintag, anickname, aid = text:match(hook_adminchat.." ��� �������")
						if anickname == v then
							sendInput('/a '..anickname..', ����� :(')
							sendInput('/ao ['..bot_name..'] ��� ���������������. ��� ������ ��������� 10 ������')
							VkMessage('&#128160; ����� '..anickname..'['..aid..'] ���������� ����.')
							runCommand('!reloadlua')
						end
					end
				end
				if text:find(hook_adminchat.." ��� ���� (%d+)") then
					admintag, anickname, aid, checkid = text:match(hook_adminchat.." ��� ���� (%d+)")
					sendInput('/a ����, ������� ����������...')
					get_ip_information = true
					type_ip_information = 1
					sendInput('/getip '..checkid)
				end
				if text:find("����������� ������� ����� 02 �����. �������� ��������� ������� ������") then
					VkMessage('&#128683; ����������� ������� ������� ����� 02 �����. �������� ������ �������������.')
					wait(500)
					exit()
				end
				if text:find(hook_adminchat.." ��� ������� �����") then
					admintag, anickname, aid = text:match(hook_adminchat.." ��� ������� �����")
					if anickname == v then
						sendInput('/a ������ , ��������!')
						startCaptcha()
						if anickname ~= bot_name then
							VkMessage('&#128290; ������������� '..anickname..'['..aid..'] �������� ����� �� ��������� �������.')
						end
					end
				end
				if text:find(hook_adminchat.." ��� ������� ������") then
					admintag, anickname, aid = text:match(hook_adminchat.." ��� ������� ������")
					if anickname == v then
						sendInput('/a ������ , ��������!')
						startQuestion()
						VkMessage('&#10067; ������������� '..anickname..'['..aid..'] �������� ������ �� ��������� �������.')
					end
				end
				if text:find(hook_adminchat.." ��� ����� �� ������� (%d+)") then
					admintag, anickname, aid, item = text:match(hook_adminchat.." ��� ����� �� ������� (%d+)")
					if tonumber(item) < 2003 then
						if anickname == v then
							sendInput('/a ������ , �������� ����� �� ������� �'..item..'!')
							startMyCaptcha(item)
							VkMessage('&#128290; ������������� '..anickname..'['..aid..'] �������� ����� �� ������� �'..item..'.')
						end
					else
						sendInput('/a �������� �'..item..' �� ����������, �������� �� ��������� ������.')
					end
				end
				if text:find(hook_adminchat.." ��� ������� ����� �� ����") then
					admintag, anickname, aid = text:match(hook_adminchat.." ��� ������� ����� �� ����")
					if anickname == v then
						sendInput('/a ������ , ��������!')
						startSkin()
						VkMessage('&#128084; ������������� '..anickname..'['..aid..'] �������� ����� �� ����!')
					end
				end
			end
			if text:find("{DFCFCF}%[���������%] {DC4747}�� ������ ������ ������ � ���� ����������� ��������� /report.") then
				sendInput('/apanel')   
			end
			if text:find("%[A%] �� �� ������������. ����������� {33CCFF}/apanel") then
				sendInput('/apanel')   
			end
			if text:find(hook_adminchat.." ��� ��������") then
				admintag, anickname, aid = text:match(hook_adminchat.." ��� ��������")
				if os.clock() - cd_autoopra < 5 then
					sendInput('/a ������ ������� ����� ������������ ��� � 5 ������, �� �����!')
				elseif automatic_autoopra_in_payday then 
					for k,v in ipairs(whitelist) do
						if anickname == v then
							AutoOpraSystem()
						else
							sendInput('/a ���������������� ��������� ��������� ������� � ������� 2� ����� ����� PayDay!')
						end
					end
				else
					AutoOpraSystem()
				end
			end
			if text:find(hook_adminchat.." ��� ������ ��������") then
				admintag, anickname, aid = text:match(hook_adminchat.." ��� ������ ��������")
				sendInput('/a ������ ����������������: '..(autoopra and '��������' or '���������')..'.')
			end
			if text:find(hook_adminchat.." ��� ���� ���") then
				admintag, anickname, aid = text:match(hook_adminchat.." ��� ���� ���")
				if lasthousenick == pnick then 
					sendInput('/a �� ��� ������ ��� ����� �� ����� ���.')
				else
					sendInput('/a ����. ���������� � ������ '..pnick..'['..pid..'] ������������ �� ����� ���� �'..hid..' ['..captcha..'���.)')
					sendInput('/jail '..pnick..' 2999 ���� ��� [�'..hid..' | '..captcha..'sec.]')
					sendInput('/jailoff '..pnick..' 2999 ���� ��� [�'..hid..' | '..captcha..'sec.]')
					sendInput('/fakesms '..pid..' ['..bot_name..'] ���������� ������������ ������������ �� ������. ����� - '..forum_link)
					VkMessage('&#127744; ������������� '..anickname..' �������� ���� � ������ '..pnick..' �� ��� �'..hid..' ['..captcha..'���.)')
				end
			end
			if text:find(hook_adminchat.." ��� ���� ���") then
				admintag, anickname, aid = text:match(hook_adminchat.." ��� ���� ���")
				if lastbiznick == bplayernick then
					sendInput('/a �� ��� ������ ��� ����� �� ����� ���.')
				else	
					sendInput('/a ����. ���������� � ������ '..bplayernick..'['..bplayerid..'] ������������ �� ����� ������� �'..businessid..' ['..btimecaptcha1..'���.)')
					sendInput('/jail '..bplayernick..' 2999 ���� ������ [�'..businessid..' | '..btimecaptcha1..'sec.]')
					sendInput('/jailoff '..bplayernick..' 2999 ���� ������ [�'..businessid..' | '..btimecaptcha1..'sec.]')
					sendInput('/fakesms '..bplayerid..' ['..bot_name..'] ���������� ������������ ������������ �� ������. ����� - '..forum_link)
					VkMessage('&#127744; ������������� '..anickname..' �������� ���� � ������ '..bplayernick..' �� ������ �'..businessid..' ['..btimecaptcha1..'���.)')
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
					sendInput('/a ������, ������ ����� �� � ����!')
				end
			end
			if text:find(hook_adminchat.." /plveh (%d+) (%d+)") and not get_ip_information then
				admintag, anickname, aid, id, car = text:match(hook_adminchat.." /plveh (%d+) (%d+)")
				if isPlayerConnected(tonumber(id)) then
					sendInput('/a ����� �� '..anickname..' �� ������ ���������� �������.')
					sendInput('/plveh '..id..' '..car)
				else
					sendInput('/a ������, ������ ����� �� � ����!')
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
					VkMessage("&#128308; �������� ����� [/"..cmd.." "..paramssss.."] �� �������������� "..admin_nick.."["..admin_id.."]")
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
						VkMessage("&#128308; ������� ����� [/"..cmd.." "..paramssss.."] �� �������������� "..admin_nick.."["..admin_id.."]")
						db_server:execute("INSERT INTO `logs`( `Text`, `Type`) VALUES ('[VK] ��� ������ ����� "..cmd.." "..paramssss.." �� �������������� <a style=color:#FF0000 href=../data/logsaccount.php?name="..admin_nick..">"..admin_nick.."</a>)', '6')")
					end
				end
			end	
			if text:find(hook_adminchat.." /life") then
				admintag, anickname, aid = text:match(hook_adminchat.." /life")
				sendInput('/a '..anickname..', � ���!')
				sendInput('/a ��������� �������� ��������� � ����������� VK!')
				VkMessage('&#128160; ��� �������� ��������� � ������� �� '..anickname..'['..aid..'].')
				sendInput('/a ��������� ������� ����������.')
			end
			if text:find("%[A%] �� ������� �������������� ���") then
				VkMessage('&#9989; ���� � ������ �������������� �����������.')
				sendInput('/setvw '..bot_name..' 0')
				sendInput('/setint '..bot_name..' 0')
				runCommand('!pos 2017.4028 -156.1743 -47.3446')
				sendInput('/a ���� ������ , � ����� ������� :) ������� �������� ������!')
				sendInput('/amember 3 9')
			end
			if text:find(hook_adminchat.." ��� �����") then
				admintag, aname, aid, checkid = text:match(hook_adminchat.." ��� �����")
				if aname == 'sanechka' or aname == ''..bot_name..'' or aname == 'Molodoy_Nalletka' or aname == 'Bell_King' or aname == 'Utopia_Boss' or aname == 'server' then
					sendInput('/a ������ , ��� ����������')
					sendInput('/setint '..bot_name..' 0')
					sendInput('/setvw '..bot_name..' 0')
					runCommand('!pos -810.18 2830.79 1501.98')
				else
					sendInput('/a � ����� ������ ��� �������������')
				end
			end
			if text:find("You are logged in as admin") then
				VkMessage('&#9876; ��� ������� ������������� � RCON.')
				sendInput('/a ����������� � RCON ������ �������!')
			end
			if text:find("(.*) %[(%d+)%] ����� ��� ID: (%d+) �� ���%. ���� �� (.*) ms! �����: %((%d+) | (%d+)%)") then
				pnick, pid, hid, captcha, caprcha1, caprcha2 = text:match("(.*) %[(%d+)%] ����� ��� ID: (%d+) �� ���%. ���� �� (.*) ms! �����: %((%d+) | (%d+)%)")
				if autoopra or jail_slet and tonumber(id_type) == 0 and tonumber(opra_or_no) == 1 and tonumber(hid) == tonumber(slet_id) then 
					sendInput('/jail '..pid..' 2999 ���� ��� �'..hid..' ('..captcha..'ms.)')
					sendInput('/jailoff '..pid..' 2999 ���� ��� �'..hid..' ('..captcha..'ms.)')
					VkMessage('&#127969; ����� '..pnick..'['..pid..'] ������ ��� �'..hid..' �� '..captcha..'sec � ��� ������� �����������������.')
					sendInput('/fakesms '..pid..' ['..bot_name..'] ���������� ������������ ������������ �� ������. ����� - '..forum_link)
					jail_slet = false
				end
			end 
			if text:find("%[A%] (.*)%[(%d+)%] ����� ��������� �� ���� %((.*)%), ����: (%d+)$, �����: (.*)") then
				name, id, car, price, salon = text:match("%[A%] (.*)%[(%d+)%] ����� ��������� �� ���� %((.*)%), ����: (%d+)$, �����: (.*)")
				if autoopra or jail_slet and tonumber(id_type) == 0 and tonumber(opra_or_no) == 1 and tonumber(hid) == tonumber(slet_id) then 
					sendInput('/jail '..id..' 2999 ���� ���� ('..car..')')
					sendInput('/jailoff '..id..' 2999 ���� ���� ('..car..')')
					VkMessage('&#127969; ����� '..pnick..'['..id..'] ������ ���������� '..car..' � ��� ������� �����������������.')
					sendInput('/fakesms '..id..' ['..bot_name..'] ���������� ������������ ������������ �� ������. ����� - '..forum_link)
					jail_slet = false
				end
			end 
			if text:find("(.*) %[(%d+)%] ����� ������ ID: (%d+) �� ���%. ���� �� (.*) ms! �����: %((%d+) | (%d+)%)") then
				bplayernick, bplayerid, businessid, btimecaptcha1, bcaptcha1, bcaptcha2 = text:match("(.*) %[(%d+)%] ����� ������ ID: (%d+) �� ���%. ���� �� (.*) ms! �����: %((%d+) | (%d+)%)")
				if autoopra or jail_slet and tonumber(id_type) == 1 and tonumber(opra_or_no) == 1 and tonumber(businessid) == tonumber(slet_id) then 
					sendInput('/jail '..bplayerid..' 2999 ���� ������ �'..businessid..' ('..btimecaptcha1..'���.)')
					sendInput('/jailoff '..bplayernick..' 2999 ���� ������ �'..businessid..' ('..btimecaptcha1..'���.)')
					VkMessage('&#127978; ����� '..bplayernick..'['..bplayerid..'] ������ ������ �'..businessid..' �� '..btimecaptcha1..'sec � ��� ������� �����������������.')
					sendInput('/fakesms '..bplayerid..' ['..bot_name..'] ���������� ������������ ������������ �� ������. ����� - '..forum_link)
					jail_slet = false
				end
			end
		end
	end
end



function UseCommand(msg) VkMessage('&#128221; �����������: '..msg) end
function NoDostupToCommand()
	VkMessage('[ INFO ] - � ��� ��� ������� � ���� �������')
end
function TwoUseCommand(msg, peer) TwoVkMessage('&#128219; �����������: '..msg, peer) end

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
			if str:find('^%[MSG%] %[admin%] ������ (.*) �������� ��� (.*)%.') then
				before_nick, after_nick = str:match('^%[MSG%] %[admin%] ������ (.*) �������� ��� (.*)%.')
				db_bot:execute("INSERT INTO `nicklogs` (`date`, `before`, `after`) VALUE ("..os.time()..", '"..before_nick.."', '"..after_nick.."')")
			end
			if str:find('(.*)%[(%d+)%] %- score: (.*), ping: (.*), (.*)') and get_players_list then
				playernick, playerid, score, ping = str:match('(.*)%[(%d+)%] %- score: (.*), ping: (%d+), (.*)')
				local f = io.open(bot_name..'/playerslist.ini', 'a')
				f:write('&#128100; '..playernick..'['..playerid..'] - �������: ['..score..'] - ����: ['..ping..']\n')
				f:close()
			end
			if str:find('Count: (.*)%.') then
				server_online = str:match('Count: (.*)%.')
				if get_players_list then
					local f = io.open(bot_name..'/playerslist.ini', "r")
					players_list = f:read('*a')
					f:close()
					VkMessage('&#128450; ������ ������� ������:\n\n'..players_list)
					local f = io.open(bot_name..'/playerslist.ini', 'w')
					f:write('')
					f:close()
					get_players_list = false
				end
				if get_hour_online then
					for k, v in ipairs(online_statistic_array) do 
						local f = io.open(bot_name..'/Statistic/'..v, 'a')
						f:write('-- ['..os.date("%d.%m | %X", os.time())..'] ������: '..(server_online+1)..'\n')
						f:close()
					end
					get_hour_online = false
				end
			end
			if str:find('��������: (.*) �����������: (.*) ������: (%d+)$') and check_biz then
				checkbizowner, checkzambiz, checkbizmoney = str:match('��������: (.*) �����������: (.*) ������: (%d+)$')
				sendInput('/unban '..checkbizowner..' ��������')
				check_business_ban = true
			end
			if str:find('��������: (.*) ������: (.*)') and check_house then
				checkhouseowner, checkhousemoney = str:match('��������: (.*) ������: (.*)')
				sendInput('/unban '..checkhouseowner..' ��������')
				check_house_ban = true
			end
			if str:find('%[CheckBiz ID (%d+)%] Name: (.*) | ��������: (.*) �����������: (.*) ������: (%d+)$') and get_business then
				bid, bname, owner, deputy_owner, business_money = str:match('%[CheckBiz ID (%d+)%] Name: (.*) | ��������: (.*) �����������: (.*) ������: (%d+)$')
			end
			if str:find('%[CheckHouse ID (%d+)%] Name: (.*) | ��������: (.*) ������: (.*)') and get_house then
				hid, name, owner, house_money = str:match('%[CheckHouse ID (%d+)%] Name: (.*) | ��������: (.*) ������: (.*)')
			end
			if str:find('������������ ������ ������ ������ �������: {FF9900}(.*) {FFFFFF}%(ID: (%d+)%) {cccccc}IP: (.*)') then
				newplayernick, newplayerid, newplayerip = str:match('������������ ������ ������ ������ �������: {FF9900}(.*) {FFFFFF}%(ID: (%d+)%) {cccccc}IP: (.*)')
				if newplayernick:find('(%d+)') or not newplayernick:find('_') or getCapitalLetter(newplayernick, 3) >= 4 or not newplayernick:isTitle() then
					newTask(function()
						sendInput('/fakesms '..newplayerid..' ['..bot_name..'] ��� ������� �� ������������� ���������� ���� �������: ���_������� | ��������: All_Capone')
						wait(1000)
						sendInput('/kick '..newplayerid..' nonRP nickname')
					end)
					VkMessage('&#128686; ����� '..newplayernick..' ������������� ������ �� nonRP �������.')
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
							sendInput('/ao ����� '..playernick..'['..playerid..'] ������ ��� ����� ['..captcha..'] �� '..captchatime..'sec � ������� ������� �'..item..'.')
							sendInput('/giveitem '..playerid..' '..item..' 1 0')
							VkMessage('&#128290; ����� '..playernick..' ������ ��� ����� ['..captcha..'] �� '..captchatime..'sec. � ������� ������� �'..item..'.')
							activecaptcha = false
							captime = nil
						end
						if playertext == questionanswer and activequestion then
							questiontime = ("%.2f"):format(os.clock() - questime)
							sendInput('/ao ����� '..playernick..'['..playerid..'] ������ ������� �� ������ �� '..questiontime..'sec � ������� ������� �'..prizeid..'.')
							sendInput('/giveitem '..playerid..' '..prizeid..' 1 0')
							VkMessage('&#10067; ����� '..playernick..'['..playerid..'] ������ ������� �� ������ �� '..questiontime..'sec � ������� ������� �'..prizeid..'.')
							activequestion = false
							questime = nil
						end
						if tonumber(playertext) == tonumber(numberskin) and activeskin then
							uskintime = ("%.2f"):format(os.clock() - skintime)
							sendInput('/ao ����� '..playernick..'['..playerid..'] ������ ����� '..numberskin..' ������ '..uskintime..'sec ����� ������ � ������� ���� �'..skinid..'.')
							sendInput('/giveitem '..playerid..' '..skinid..' 1 0')
							VkMessage('&#128084; ����� '..playernick..'['..playerid..'] ������ ����� '..numberskin..' ������ '..uskintime..'sec ����� ������ � ������� ���� �'..skinid..'.')
							activeskin = false
							skintime = nil
						end
					end
					for k, v in ipairs(array_flip) do
						if playertext:match(v) then
							insertInVrUsers(playernick)
							if tonumber(getPlayerCooldown(playernick).flip) > os.time() then sendInput('/fakesms '..playerid..' ['..bot_name..'] �� ������� ������������ ��� ������� � '..os.date("%X", getPlayerCooldown(playernick).flip)); return false end
							db_bot:execute("UPDATE `vr_users` set flip = "..os.time().."+"..cfg.cooldowns.flip.." where nick = '"..playernick.."'")
							newTask(function() sendInput('/flip '..playerid); wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] �� ���� ��������, ������������ ������� � ��������� ��� �� ������� � '..os.date("%X", getPlayerCooldown(playernick).flip)); end)
						end
					end
					if inTable(array_cb, playertext) or inTable(array_ab, playertext) or inTable(array_blv, playertext) or inTable(array_cr, playertext) then
						insertInVrUsers(playernick)
						if tonumber(getPlayerCooldown(playernick).teleport) > os.time() then sendInput('/fakesms '..playerid..' ['..bot_name..'] �� ������� ������������ ��� ������� � '..os.date("%X", getPlayerCooldown(playernick).teleport)); return false end
						db_bot:execute("UPDATE `vr_users` set teleport = "..os.time().."+"..cfg.cooldowns.teleport.." where nick = '"..playernick.."'")
						for k, v in ipairs(array_cb) do if playertext:match(v) then newTask(function() sendInput('/plpos '..playerid..' '..tp_points['��']); wait(500); sendInput('/setint '..playerid..' 0') wait(500); sendInput('/setvw '..playerid..' 0') wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] �� ���� ��������������� � ������������ ����� �� ������� � VIP-��� :)'); end) end end
						for k, v in ipairs(array_ab) do if playertext:match(v) then newTask(function() sendInput('/plpos '..playerid..' '..tp_points['��']); wait(500); sendInput('/setint '..playerid..' 0') wait(500); sendInput('/setvw '..playerid..' 0') wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] �� ���� ��������������� �� ��������� �� ������� � VIP-��� :)'); end) end end
						for k, v in ipairs(array_blv) do if playertext:match(v) then newTask(function() sendInput('/plpos '..playerid..' '..tp_points['���']); wait(500); sendInput('/setint '..playerid..' 0') wait(500); sendInput('/setvw '..playerid..' 0') wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] �� ���� ��������������� � ����� �� �� ������� � VIP-��� :)'); end) end end
						for k, v in ipairs(array_cr) do if playertext:match(v) then newTask(function() sendInput('/plpos '..playerid..' '..tp_points['��']); wait(500); sendInput('/setint '..playerid..' 0') wait(500); sendInput('/setvw '..playerid..' 0') wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] �� ���� ��������������� � ������������ ����� �� ������� � VIP-��� :)'); end) end end
						for k, v in ipairs(array_meria) do if playertext:match(v) then newTask(function() sendInput('/plpos '..playerid..' '..tp_points['�����']); wait(500); sendInput('/setint '..playerid..' 0') wait(500); sendInput('/setvw '..playerid..' 0') wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] �� ���� ��������������� � ����� �� ������� � VIP-��� :)'); end) end end
					end
					for k, v in ipairs(array_nrg) do
						if playertext:match(v) then
							insertInVrUsers(playernick)
							if tonumber(getPlayerCooldown(playernick).nrg) > os.time() then sendInput('/fakesms '..playerid..' ['..bot_name..'] �� ������� ������������ ��� ������� � '..os.date("%X", getPlayerCooldown(playernick).nrg)); return false end
							db_bot:execute("UPDATE `vr_users` set nrg = "..os.time().."+"..cfg.cooldowns.nrg.." where nick = '"..playernick.."'")
							newTask(function() sendInput('/plveh '..playerid..' 522 0'); wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] ��� ��� ����� �������� NRG-500 �� ������� � VIP-��� :)'); end)
						end
					end
					for k, v in ipairs(array_hp) do
						if playertext:match(v) then
							sendInput('/sethp '..playerid..' 100')
							sendInput('/fakesms '..playerid..' ['..bot_name..'] ��� ���� ������ �� �� ������� � VIP-���')
							VkMessage('&#128168; ����� HP '..playernick..' �� ������� � VIP-���')
						end
					end
					for k, v in ipairs(array_pass) do
						if playertext:match(v) then
							sendInput('/givepass '..playerid)
							sendInput('/fakesms '..playerid..' ['..bot_name..'] ��� ��� ����� ������� �� ������� � VIP-���')
							VkMessage('&#128168; ����� ������� '..playernick..' �� ������� � VIP-���')
						end
					end
					for k, v in ipairs(array_car) do
						if playertext:match(v) then
							insertInVrUsers(playernick)
							if tonumber(getPlayerCooldown(playernick).infernus) > os.time() then sendInput('/fakesms '..playerid..' ['..bot_name..'] �� ������� ������������ ��� ������� � '..os.date("%X", getPlayerCooldown(playernick).infernus)); return false end
							db_bot:execute("UPDATE `vr_users` set infernus = "..os.time().."+"..cfg.cooldowns.infernus.." where nick = '"..playernick.."'")
							newTask(function() sendInput('/plveh '..playerid..' 411 1'); wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] ��� ��� ����� ���������� Infernus �� ������� � VIP-��� :)'); end)
						end
					end
					for k, v in ipairs(array_spawn) do
						if playertext:match(v) then
							insertInVrUsers(playernick)
							if tonumber(getPlayerCooldown(playernick).spawn) > os.time() then sendInput('/fakesms '..playerid..' ['..bot_name..'] �� ������� ������������ ��� ������� � '..os.date("%X", getPlayerCooldown(playernick).spawn)); return false end
							db_bot:execute("UPDATE `vr_users` set spawn = "..os.time().."+"..cfg.cooldowns.spawn.." where nick = '"..playernick.."'")
							newTask(function() sendInput('/spplayer '..playerid); wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] ��� ���� ���������� �� ������� � VIP-��� :)'); end)
						end
					end
					for k, v in ipairs(array_help) do
						if playertext:match(v) then
							insertInVrUsers(playernick)
							if tonumber(getPlayerCooldown(playernick).help) > os.time() then sendInput('/fakesms ['..bot_name..'] '..playerid..' �� ������� ������������ ��� ������� � '..os.date("%X", getPlayerCooldown(playernick).help)); return false end
							db_bot:execute("UPDATE `vr_users` set help = "..os.time().."+"..cfg.cooldowns.help.." where nick = '"..playernick.."'")
							newTask(function()	
								sendInput('/fakesms ['..bot_name..'] '..playerid..' ���� � /vr "����� ����", "������ ����", "������ ��������", "��������", "��� ��� ����"'); wait(500);
								sendInput('/fakesms ['..bot_name..'] '..playerid..' �������� � /vr "����� ��������", "��� ��������", "��� �����", "����� �����"'); wait(500);
								sendInput('/fakesms ['..bot_name..'] '..playerid..' ��� � /vr "����� ���", "��� ���", "��� ��������", "����� ��������"'); wait(500);
								sendInput('/fakesms ['..bot_name..'] '..playerid..' ����� � /vr "����������", "����� �����", "��� �����", "������ �����"');
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
							sendInput('/ao ����� '..playernick..'['..playerid..'] ������ ��� ����� ['..captcha..'] �� '..captchatime..'sec � ������� ������� �'..item..'.')
							sendInput('/giveitem '..playerid..' '..item..' 1 0')
							VkMessage('&#128290; ����� '..playernick..' ������ ��� ����� ['..captcha..'] �� '..captchatime..'sec. � ������� ������� �'..item..'.')
							activecaptcha = false
							captime = nil
						end
						if playertext == questionanswer and activequestion then
							questiontime = ("%.2f"):format(os.clock() - questime)
							sendInput('/ao ����� '..playernick..'['..playerid..'] ������ ������� �� ������ �� '..questiontime..'sec � ������� ������� �'..prizeid..'.')
							sendInput('/giveitem '..playerid..' '..prizeid..' 1 0')
							VkMessage('&#10067; ����� '..playernick..'['..playerid..'] ������ ������� �� ������ �� '..questiontime..'sec � ������� ������� �'..prizeid..'.')
							activequestion = false
							questime = nil
						end
						if tonumber(playertext) == tonumber(numberskin) and activeskin then
							uskintime = ("%.2f"):format(os.clock() - skintime)
							sendInput('/ao ����� '..playernick..'['..playerid..'] ������ ����� '..numberskin..' ������ '..uskintime..'sec ����� ������ � ������� ���� �'..skinid..'.')
							sendInput('/giveitem '..playerid..' '..skinid..' 1 0')
							VkMessage('&#128084; ����� '..playernick..'['..playerid..'] ������ ����� '..numberskin..' ������ '..uskintime..'sec ����� ������ � ������� ���� �'..skinid..'.')
							activeskin = false
							skintime = nil
						end
					end
					for k, v in ipairs(array_flip) do
						if playertext:match(v) then
							insertInVrUsers(playernick)
							if tonumber(getPlayerCooldown(playernick).flip) > os.time() then sendInput('/fakesms '..playerid..' ['..bot_name..'] �� ������� ������������ ��� ������� � '..os.date("%X", getPlayerCooldown(playernick).flip)); return false end
							db_bot:execute("UPDATE `vr_users` set flip = "..os.time().."+"..cfg.cooldowns.flip.." where nick = '"..playernick.."'")
							newTask(function() sendInput('/flip '..playerid); wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] �� ���� ��������, ������������ ������� � ��������� ��� �� ������� � '..os.date("%X", getPlayerCooldown(playernick).flip)); end)
						end
					end
					if inTable(array_cb, playertext) or inTable(array_ab, playertext) or inTable(array_blv, playertext) or inTable(array_cr, playertext) then
						insertInVrUsers(playernick)
						if tonumber(getPlayerCooldown(playernick).teleport) > os.time() then sendInput('/fakesms '..playerid..' ['..bot_name..'] �� ������� ������������ ��� ������� � '..os.date("%X", getPlayerCooldown(playernick).teleport)); return false end
						db_bot:execute("UPDATE `vr_users` set teleport = "..os.time().."+"..cfg.cooldowns.teleport.." where nick = '"..playernick.."'")
						for k, v in ipairs(array_cb) do if playertext:match(v) then newTask(function() sendInput('/plpos '..playerid..' '..tp_points['��']); wait(500); sendInput('/setint '..playerid..' 0') wait(500); sendInput('/setvw '..playerid..' 0') wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] �� ���� ��������������� � ������������ ����� �� ������� � VIP-��� :)'); end) end end
						for k, v in ipairs(array_ab) do if playertext:match(v) then newTask(function() sendInput('/plpos '..playerid..' '..tp_points['��']); wait(500); sendInput('/setint '..playerid..' 0') wait(500); sendInput('/setvw '..playerid..' 0') wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] �� ���� ��������������� �� ��������� �� ������� � VIP-��� :)'); end) end end
						for k, v in ipairs(array_blv) do if playertext:match(v) then newTask(function() sendInput('/plpos '..playerid..' '..tp_points['���']); wait(500); sendInput('/setint '..playerid..' 0') wait(500); sendInput('/setvw '..playerid..' 0') wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] �� ���� ��������������� � ����� �� �� ������� � VIP-��� :)'); end) end end
						for k, v in ipairs(array_cr) do if playertext:match(v) then newTask(function() sendInput('/plpos '..playerid..' '..tp_points['��']); wait(500); sendInput('/setint '..playerid..' 0') wait(500); sendInput('/setvw '..playerid..' 0') wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] �� ���� ��������������� � ������������ ����� �� ������� � VIP-��� :)'); end) end end
						for k, v in ipairs(array_meria) do if playertext:match(v) then newTask(function() sendInput('/plpos '..playerid..' '..tp_points['�����']); wait(500); sendInput('/setint '..playerid..' 0') wait(500); sendInput('/setvw '..playerid..' 0') wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] �� ���� ��������������� � ����� �� ������� � VIP-��� :)'); end) end end
					end
					for k, v in ipairs(array_nrg) do
						if playertext:match(v) then
							insertInVrUsers(playernick)
							if tonumber(getPlayerCooldown(playernick).nrg) > os.time() then sendInput('/fakesms '..playerid..' ['..bot_name..'] �� ������� ������������ ��� ������� � '..os.date("%X", getPlayerCooldown(playernick).nrg)); return false end
							db_bot:execute("UPDATE `vr_users` set nrg = "..os.time().."+"..cfg.cooldowns.nrg.." where nick = '"..playernick.."'")
							newTask(function() sendInput('/plveh '..playerid..' 522 0'); wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] ��� ��� ����� �������� NRG-500 �� ������� � VIP-��� :)'); end)
						end
					end
					for k, v in ipairs(array_hp) do
						if playertext:match(v) then
							sendInput('/sethp '..playerid..' 100')
							sendInput('/fakesms '..playerid..' ['..bot_name..'] ��� ���� ������ �� �� ������� � VIP-���')
							VkMessage('&#128168; ����� HP '..playernick..' �� ������� � VIP-���')
						end
					end
					for k, v in ipairs(array_pass) do
						if playertext:match(v) then
							sendInput('/givepass '..playerid)
							sendInput('/fakesms '..playerid..' ['..bot_name..'] ��� ��� ����� ������� �� ������� � VIP-���')
							VkMessage('&#128168; ����� ������� '..playernick..' �� ������� � VIP-���')
						end
					end
					for k, v in ipairs(array_car) do
						if playertext:match(v) then
							insertInVrUsers(playernick)
							if tonumber(getPlayerCooldown(playernick).infernus) > os.time() then sendInput('/fakesms '..playerid..' ['..bot_name..'] �� ������� ������������ ��� ������� � '..os.date("%X", getPlayerCooldown(playernick).infernus)); return false end
							db_bot:execute("UPDATE `vr_users` set infernus = "..os.time().."+"..cfg.cooldowns.infernus.." where nick = '"..playernick.."'")
							newTask(function() sendInput('/plveh '..playerid..' 411 1'); wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] ��� ��� ����� ���������� Infernus �� ������� � VIP-��� :)'); end)
						end
					end
					for k, v in ipairs(array_spawn) do
						if playertext:match(v) then
							insertInVrUsers(playernick)
							if tonumber(getPlayerCooldown(playernick).spawn) > os.time() then sendInput('/fakesms '..playerid..' ['..bot_name..'] �� ������� ������������ ��� ������� � '..os.date("%X", getPlayerCooldown(playernick).spawn)); return false end
							db_bot:execute("UPDATE `vr_users` set spawn = "..os.time().."+"..cfg.cooldowns.spawn.." where nick = '"..playernick.."'")
							newTask(function() sendInput('/spplayer '..playerid); wait(500); sendInput('/fakesms '..playerid..' ['..bot_name..'] ��� ���� ���������� �� ������� � VIP-��� :)'); end)
						end
					end
					for k, v in ipairs(array_help) do
						if playertext:match(v) then
							insertInVrUsers(playernick)
							if tonumber(getPlayerCooldown(playernick).help) > os.time() then sendInput('/fakesms ['..bot_name..'] '..playerid..' �� ������� ������������ ��� ������� � '..os.date("%X", getPlayerCooldown(playernick).help)); return false end
							db_bot:execute("UPDATE `vr_users` set help = "..os.time().."+"..cfg.cooldowns.help.." where nick = '"..playernick.."'")
							newTask(function()	
								sendInput('/fakesms ['..bot_name..'] '..playerid..' ���� � /vr "����� ����", "������ ����", "������ ��������", "��������", "��� ��� ����"'); wait(500);
								sendInput('/fakesms ['..bot_name..'] '..playerid..' �������� � /vr "����� ��������", "��� ��������", "��� �����", "����� �����"'); wait(500);
								sendInput('/fakesms ['..bot_name..'] '..playerid..' ��� � /vr "����� ���", "��� ���", "��� ��������", "����� ��������"'); wait(500);
								sendInput('/fakesms ['..bot_name..'] '..playerid..' ����� � /vr "����������", "����� �����", "��� �����", "������ �����"');
							end)
						end
					end
				end
			if str:find(" {......}%[(.*)%]{FFFFFF} (.*)%[(%d+)%]{FFFFFF}: (.*)") then
				playertag, playernick, playerid, playertext = str:match(" {......}%[(.*)%]{FFFFFF} (.*)%[(%d+)%]{FFFFFF}: (.*)")
				if playernick == '1232' or playernick1 == ''..bot_name..'' then
				else
					for k, v in ipairs(array_neadekvats) do
						if playertext:match(v) and not playertext:match('�����') then
							sendInput('/a � ������ ����������� ��������� � VIP CHAT �� '..playernick..' � ID:'..playerid..' ����� ('..playertext:match(v)..')')
							sendInput('/a ��������� ����������, ��������� �������������� � ������� ���')
						end
					end
					for k, v in ipairs(array_banip) do
						if playertext:match(v) and not playertext:match('�����') then
							sendInput('/banip '..playerid..' 13')
							VkMessage("&#128683; ����� "..playernick.."["..playerid.."] ��� ������������� ������� �� ��� ������� � /vr.\n&#128203; ���������� ���������: "..str:gsub('{......}', ''))
						end
					end
					for k, v in ipairs(array_mats) do
						if playertext:match(v) and not playertext:match('���') then
							sendInput('/banoff 0 '..playernick..' 30 ���. ���.')
							sendInput('/a ����� '..playernick..'['..playerid..'] ��� ������������� ������� �� ����������� ������.')
							VkMessage("&#128683; ����� "..playernick.."["..playerid.."] ��� ������������� ������� �� ����������� ������.\n&#128203; ���������� ���������: "..str:gsub('{......}', ''))
						end
					end
					if getCapitalLetter(playertext, 3) >= 6 then
						sendInput('/mute '..playerid..' 10 CapsLock /vr [����. ����: ' .. getCapitalLetter(playertext, 3)..']')
						sendInput('/a ����� '..playernick..' ������������� ������� ��������� �� caps [����. ����: ' .. getCapitalLetter(playertext, 3)..'].')
						VkMessage("&#128683; ����� "..playernick.."["..playerid.."] ��� ������������� ������� �� CapsLock � /vr [����. ����: " .. getCapitalLetter(playertext, 3).."].\n&#128203; ���������� ���������: "..str:gsub('{......}', ''))
					end
				end
			end
			if str:find("%[������%] �� (.*)%[(%d+)%]: {ffffff}(.*). ��� (%d+) ��������") then
				playernick, playerid, playertext, reports = str:match("%[������%] �� (.*)%[(%d+)%]: {ffffff}(.*). ��� (%d+) ��������")
				if get_hour_report then
					for k, v in ipairs(report_statistic_array) do
						local f = io.open(bot_name..'/Statistic/'..v, 'a')
						f:write('-- ['..os.date("%d.%m | %X", os.time())..'] ������: '..(reports)..'\n')
						f:close()
					end
					get_hour_report = false
				end
				if tonumber(reports) >= 5 then
					for i = 1, 50 do
						sendInput('/a ������, �������� �� ������ - /ot /ot /ot !!!')
					end
					VkMessage('&#128221; ������ �������� �� '..tonumber(reports)..', ��� ��������� � �����-���(SAMP) � � �����-���(VK).')
					sendInput('/a @2lvl @3lvl @4lvl ��� '..reports..' ��������.')
					VkMessageWithPing('@all\n\n&#9889; &#9889; &#9889; ������ �������� �� '..reports..'. ������ �� ������!\n&#9889; &#9889; &#9889; ������ �������� �� '..reports..'. ������ �� ������!\n&#9889; &#9889; &#9889; ������ �������� �� '..reports..'. ������ �� ������!')
				end
			end
			if str:find("%[������%] �� (.*)%[(%d+)%]: {ffffff}(.*). ��� (%d+) ��������") then
				playernick, playerid, playertext, reports = str:match("%[������%] �� (.*)%[(%d+)%]: {ffffff}(.*). ��� (%d+) ��������")
				if playernick == 'sanechka' or playernick == ''..bot_name..'' or playernick == 'Molodoy_Nalletka' or playernick == 'Bell_King' or playernick == 'Utopia_Boss' or playernick == 'server' then
				else
					if getCapitalLetter(playertext, 3) >= 6 then
					sendInput('/mute '..playerid..' 10 CapsLock /rep [����. ����: ' .. getCapitalLetter(playertext, 3)..']')
					VkMessage("&#128683; ����� "..playernick.."["..playerid.."] ��� ������������� ������� �� CapsLock � /report [����. ����: " .. getCapitalLetter(playertext, 3).."].\n&#128203; ���������� ���������: "..str:gsub('{......}', ''))
					end
					for k, v in ipairs(array_mats) do
						if playertext:match(v) and not playertext:match('���') then
							sendInput('/banoff 0 '..playernick..' 30 ���. ���.')
							sendInput('/a ����� '..playernick..'['..playerid..'] ��� ������������� ������� �� ����������� ������.')
							VkMessage("&#128683; ����� "..playernick.."["..playerid.."] ��� ������������� ������� �� ����������� ������.\n&#128203; ���������� ���������: "..str:gsub('{......}', ''))
						end
					end
					for k, v in ipairs(array_banip) do
						if playertext:match(v) and not playertext:match('�����') then
							sendInput('/banip '..playerid..' 13')
							VkMessage("&#128683; ����� "..playernick.."["..playerid.."] ��� ������������� ������� �� ��� ������� � /report.\n&#128203; ���������� ���������: "..str:gsub('{......}', ''))
						end
					end
					for k, v in ipairs(array_neadekvats) do
						if playertext:match(v) then
							sendInput('/a � ������ ����������� ��������� � REPORT �� '..playernick..' � ID:'..playerid..' ����� ('..playertext:match(v)..')')
							sendInput('/a ��������� ����������, ��������� �������������� � ������� ���')
						end
					end
				end
			end
			if str:match('%[A%] (.*) ����� ������ (.*) (.*) �������!') then
				aname, gunid, players = str:match("%[A%] (.*) ����� ������ (.*) (.*) �������!")
				if gunid == 'Minigun' or gunname == 'Rocket Launcher' or gunname == 'Auto Rocket Launcher' then
					sendInput('/awarn '..aname..' ����. ������')
					sendInput('/a �� ������� ������ ��� ������!')
				end
			end
			if str:match('%[A%] (.*)%[(%d+)%] %-> (.*)%[(%d+)%]:{ffffff} (.*)') then
				aname, aid, pname, pid, msg = str:match("%[A%] (.*)%[(%d+)%] %-> (.*)%[(%d+)%]:{ffffff} (.*)")
				if aname == 'sanechka' or aname == ''..bot_name..'' or aname == 'Molodoy_Nalletka' or aname == 'Bell_King' or aname == 'Utopia_Boss' or aname == 'server' then
				elseif aname == pname then
					sendInput('/awarn '..aname..' �������� �������')
					sendInput('/setrep '..aname..' 0')
					sendInput('/a �� ����� ���� , ������� ���������')
				end
			end
			if str:match(hook_adminchat..' /givegun (.*) (.*) (.*)') then
				admintag, aname, admin_id, id, gunid, pt = str:match(hook_adminchat.." /givegun (.*) (.*) (.*)")
				if aname == 'Galileo_DeLamonte' then
					sendInput(''..aname..' -  ����������� �������� ������������ ��� ��� �����������')
				else 
					if gunid == '38' or gunid == '37' or gunid == '36' then
						sendInput('/a �������� , ����������� ������')
						sendInput('/awarn '..admin_id..' ������� ������ ����. ������')
						VkMessage('&#128548; ������������� '..aname..' ������� ����� ����� ������ ���� ����. ������. � � ��� ��� ����.')
					else
						sendInput('/givegun '..id..' '..gunid..' '..pt)
						sendInput('/a ����� �� ������ ������ �� '..aname..' ������� �������')
					end
				end
			end
			if str:match('A: (.*) ���� 1 ������� � �������������� (.*)') then
				aname, adminname = str:match("A: (.*) ���� 1 ������� � �������������� (.*)")
				if aname == 'sanechka' or aname == ''..bot_name..'' or aname == 'Molodoy_Nalletka' or aname == 'Bell_King' or aname == 'Utopia_Boss' or aname == 'server' then
				elseif aname == adminname then
					sendInput('/awarn '..aname..' ���')
					VkMessage('&#128128; ������������� '..aname..' ������� ����� ���� �������')
					VkMessageFlood("/getbynick "..aname)
					VkMessageFlood("������ ��� ����, � ����� // sanechka[������: /warn "..aname.." ��� // sanechka]")
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
	sendInput('/a ������������� '..anickname:gsub('_', ' ')..'['..aid..'] '..(autoopra and '�������' or '��������')..' ����������������.')
	sendInput('/vr '..(autoopra and '�������' or '��������')..' ����������������!')
	VkMessage('&#128680; ������������� '..anickname..'['..aid..'] '..(autoopra and '�������' or '��������')..' ����������������.')
	cd_autoopra = os.clock()
	newTask(function()
		wait(wait(tonumber(config[8][2])*1000))
		if autoopra then
			autoopra = false
			sendInput('/a ���������������� ��������� �� ��������� 2� ����� ����� ��� ��������� ��������������.')
			sendInput('/vr ���������������� ��������� �� ��������� 2� ����� ����� ��� ��������� ��������������.')
			VkMessage('&#128680; ���������������� ��������� �� ��������� 2� ����� ����� ��� ��������� ��������������.')
		end
	end)
end


function randomQuestion()
	arrays = {
			{"� ����� ������ ������������ ����� ������ �� �� ��?", "�������"},
			{"������������ ����� ������������� � ������������������� ?", "100000000"},
			{"������� ����������� ����������� �������� � ������� � ���������� ?", "15"},
			{"������� ����� ������� ����� ����� ���������� ����� ?", "400"},
			{"��� ����� ��������� �������� �� �������� �����������", "������"},
			{"��� ����� ����� ��������� �������� � �������������� �������� ���������", "���������"},
			{"��� ����� �������� �������� � �����", "�����"},
			{"����� ������� ������� ��������� ��� ���� ����� �������� �� ������ ��������", "7"},
			{"����� ������� ������� ��������� ��� ���� ����� �������� �� ������ �����������", "6"},
			{"������� ����� ����� �� ����������� \"����������\"", "30000"},
			{"������� ���������� ���������� ��������� �� �������", "8"},
			{"������� ����� ����� ��� ������ ���������� ������� ������� ����", "5000"},
			{"����� ������������ ����� ������ ����� ���� �������� �� ������ ����������", "80000"},
			{"������ ���. ���� ������� - �������������������� �������", "45000000"},
			{"������� ���� ����� � �������� ����� ��� �������", "5"},
			{"������� ����� ����� ��������� \"�����\" ��� �����", "80000000"},
			{"������� ����� ����������� ������ ��� ���������� �������", "5000"},
			{"������� ����� ����������� ����������� �������� � ������� � ����������", "14"},
			{"��������� ������ � �����������", "4000000"},
			{"��� ����� ����� ��������� �������� � �������� ��", "�����"},
			{"������� ����� ��������� ������������ �� �� ��", "7"},
			{"������ ��������� ������ �� ��������� ������ �������", "15000000"},
			{"������ ���. ���� ������� - ����������", "60000000"},
			{"� ����� ������ ������������ ����� ������ �� �� ��", "�������"},
			{"������� ����� ���������� VIP-�����", "2500000"},
			{"����� ���������� ���� ����� ����� ����� PREMIUM VIP", "20"},
			{"������� ����� ���������� ������������ �����", "8828"},
			{"������� ����� ��������� ������ � ���������", "900"},
			{"������� ����� ������ ���� �� �������", "5"},
			{"������� ���������� ����� � ����� �1", "24"},
			{"������� ������ ���������� ��������� ���������", "3"},
			{"������ ���. ��������� �������� �������� ������", "3500000"},
			{"������� ������� ����� ����� ����� ������� \"������ �������\" � ���������� �����", "1300"},
			{"������� ������� �������� ����� ����� ������� \"������ ��������\" � �������� ��������", "2800"},
			{"�� ����� ����� ����� ��������� ����� ������� �����", "913"},
			{"������ ��������� ������ �� ��������� ������ ������", "20000000"},
			{"��� ����� ��������� ������� ������ ��������� ����� ������� �� �������", "�������"},
			{"����� ������� ������� ����� ���������� ����� ������� ���� �����", "20"},
			{"�� ����� ����� ����� ��������� ����� ������� ��������", "914"},
			{"����� ���������� ����� � ������� \"������ �����������\"", "215"},
			{"�� ����� ����� ����� ��������� ����� ������� ������ ������", "912"},
			{"������� ����� �������� ����� �����", "20000000"},
			{"����� ������� ������� ��������� ��� ���� ����� �������� �� ������ �������� �������", "9"},
			{"����� ������� ������� ��������� ��� ���� ����� �������� �� ������ ������", "5"}
			}
	numbervariant = random(1, 34)
	questiontext = '/ao ��������, ������: '..arrays[numbervariant][1]..' | ����� � VIP-���(/vr)!'
	questionanswer = arrays[numbervariant][2]
	return questiontext, questionanswer
end


function randomCaptcha(item, captcha)
	arraysymbols = {
		'a',
	}
	local s = arraysymbols[random(1,1)]
	array = {
			'! ����: ������� �'..item..' | �'..s..'��� ['..captcha..'].',
	}
	numbervariant = math.random(1,1)
	captchatext = '/ao ��������'..array[numbervariant]..' ����� ������ � VIP-��� (/vr)!'
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
		if t.error then print('������! ���: ' .. t.error.error_code .. ' �������: ' .. t.error.error_msg) return end
		vkerrsend = nil
	end)
end







function mainPartOfVkSystem(msg)
	local rnd = math.random(-2147000000, 2147000000)
	async_http_request('https://api.vk.com/method/messages.send', 'chat_id='..tonumber(two_chat_id)..'&random_id=' .. rnd .. '&message=' .. msg .. '&access_token=' .. two_access_token .. '&v=5.131',
	function (result)
		local t = json.decode(result)
		if not t then print(result) return end
		if t.error then print('������! ���: ' .. t.error.error_code .. ' �������: ' .. t.error.error_msg) return end
		vkerrsend = nil
	end)
end

function partOfVkSystem(msg)
	local rnd = math.random(-2147000000, 2147000000)
	async_http_request('https://api.vk.com/method/messages.send', 'chat_id='..tonumber(chat_id)..'&random_id=' .. rnd .. '&message=' .. msg .. '&access_token=' .. access_token .. '&v=5.131',
	function (result)
		local t = json.decode(result)
		if not t then print(result) return end
		if t.error then print('������! ���: ' .. t.error.error_code .. ' �������: ' .. t.error.error_msg) return end
		vkerrsend = nil
	end)
end

function floodOfVkSystem(msg)
	local rnd = math.random(-2147000000, 2147000000)
	async_http_request('https://api.vk.com/method/messages.send', 'chat_id='..tonumber(two_chat_id)..'&random_id=' .. rnd .. '&message=' .. msg .. '&access_token=' .. two_access_token .. '&v=5.131',
	function (result)
		local t = json.decode(result)
		if not t then print(result) return end
		if t.error then print('������! ���: ' .. t.error.error_code .. ' �������: ' .. t.error.error_msg) return end
		vkerrsend = nil
	end)
end

function logOfVkSystem(msg)
	local rnd = math.random(-2147000000, 2147000000)
	async_http_request('https://api.vk.com/method/messages.send', 'chat_id='..tonumber(log_chat_id)..'&random_id=' .. rnd .. '&message=' .. msg .. '&access_token=' .. log_acces_token .. '&v=5.131',
	function (result)
		local t = json.decode(result)
		if not t then print(result) return end
		if t.error then print('������! ���: ' .. t.error.error_code .. ' �������: ' .. t.error.error_msg) return end
		vkerrsend = nil
	end)
end

function longpollResolve(result)
	if result then
		if result:sub(1,1) ~= '{' then
			vkerr = '������!\n�������: ��� ���������� � VK!'
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
									sendInput('/mute '..playernick..' 300 ����������� ����� /vr')
									sendInput('/muteoff '..playernick..' 300 ����������� ����� /vr')
									VkMessage('	&#129313; ����� ��� ������� ��� ��������� '..playernick)
								elseif pl.button == 'noaccept' then
									accept()
									VkMessage('&#129324; ���� , ����� ��������')
								elseif pl.button == 'sliv' then
									sliv()
									sendInput('/banip '..anick..' 13')
									sendInput('/banoff '..anick..' 2000 13')
									VkMessage('	&#129313; ����� ��� �������� '..anick)
								elseif pl.button == 'nosliv' then
									sliv()
									VkMessage('&#129324; ���� , �������� ��� ����')
								elseif pl.button == 'unban' then
									start_button = false
									vzlom()
									VkMessage('&#9989; ������ �������')
									sendInput('/unban '..infocheck..' [VK] ������')
									give_unban_form = true
								elseif pl.button == 'nounban' then
									start_button = false
									vzlom()
									VkMessage('&#128219; � ������� ��������')
								elseif pl.button == 'unban1' then
									start_button = false
									vzlom1()
									VkMessage('&#9989; ������ �������')
									sendInput('/unban '..nick..' [VK] ������')
									give_unban_form = true
								elseif pl.button == 'nounban1' then
									start_button = false
									vzlom1()
									VkMessage('&#128219; � ������� ��������')
								elseif pl.button == 'vernut1' then
									start_button = false
									vernut1()
									VkMessage('&#129312; | �����-����� ������� ������')
									sendInput('/pm 1 '..aid..' ['..bot_name..'] ������ ������ � ����� ������� �� ������������ �����-����')
									sendInput('/pm 1 '..aid..' ['..bot_name..'] ������ ������ � ����� ������� �� ������������ �����-����')
									sendInput('/pm 1 '..aid..' ['..bot_name..'] ������ ������ � ����� ������� �� ������������ �����-����')
									sendInput('/pm 1 '..aid..' ['..bot_name..'] ������ ������ � ����� ������� �� ������������ �����-����')
									sendInput('/pm 1 '..aid..' ['..bot_name..'] ������ ������ � ����� ������� �� ������������ �����-����')
									sendInput('/pm 1 '..aid..' ['..bot_name..'] ������ ������ � ����� ������� �� ������������ �����-����')
									sendInput('/pm 1 '..aid..' ['..bot_name..'] ������ ������ � ����� ������� �� ������������ �����-����')
									sendInput('/pm 1 '..aid..' ['..bot_name..'] ������ ������ � ����� ������� �� ������������ �����-����')
									sendInput('/pm 1 '..aid..' ['..bot_name..'] ������ ������ � ����� ������� �� ������������ �����-����')
									sendInput('/pm 1 '..aid..' ['..bot_name..'] ������ ������ � ����� ������� �� ������������ �����-����')
								elseif pl.button == 'yes' then
									yes()
									VkMessage('&#9989; ����� ������� ����� �������������� '..aname..'.')
									sendInput('/acceptadmin '..aid)
									start_button = false
								elseif pl.button == 'no' then
									yes()
									VkMessage('&#9989; � ������ ������ ��������.')
									sendInput('���� �������� � ������. ������ �����('..getUserName(from_id)..')')
									start_button = false
								elseif pl.button == 'start_captcha' then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('captcha') then
										startCaptcha() 
										VkMessage('&#128290; ����� �� ���� ���� ��������, �������� ����������.')
									else
										NoDostupToCommand()
									end
								elseif pl.button == 'start_question' then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('question') then
										startQuestion()
										VkMessage('&#10067; ��������� ������ �� ��������� ����� ���� ���������� �������.')
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
										keyboard_vk('&#128200; �������� ��� ���������� �������:', 'onl')
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
&#8987; �������, �������� �����������. ���������:
&#9654; ��� ���������: %s.
&#9654; ID ���������: %s.
&#9654; ����� ���������: %s���.
&#9654; %s.
									]], name_type, slet_id, teleport_time, tostring(name_opra)))
									sendInput('/eventmenu')
								elseif pl.button == 'no_stop' and start_button then
									start_button = false
									auto_slet = true
									set_position = true
									VkMessage('&#129324; ���� , �������� ���')
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
						function UseCommandls(msg) vk_request_user(user_id, '&#128221; �����������: '..msg) end
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
									VkMessage('&#9940; ������������ @id'..from_id..'('..getUserName(from_id)..') ��� �������� �� ����������� �� ���������� ������ ������������ ��������� ['..cfg.config.antiflood_msg..'] � ������.')
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
										VkMessage('&#9940; ������������ @id'..new_user_id..' ������������ ������������� @id'..getUserBanByAdmin(new_user_id)..'('..getUserName(getUserBanByAdmin(new_user_id))..').\n&#128203; ������� ����������: '..getUserBanReason(new_user_id))
										luaVkApi.removeChatUser((tonumber(chat_id)), tonumber(v.object.message.action.member_id))
										luaVkApi.removeChatUser((tonumber(chat_id)), tonumber(new_user_id))
									else
										local f = io.open(bot_name..'/greetings.ini', "r")
										greetings = f:read('*a')
										f:close()
										if cfg.config.check_on_public and not isUserSubscribeOnGroup(new_user_id) then
											VkMessage('&#9940; ������������ @id'..new_user_id..'('..getUserName(new_user_id)..') �� ������� � ������� @public'..cfg.config.check_public_link..'('..getGroupNameById(cfg.config.check_public_link)..').')
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
								VkMessage('&#128290; ��������� ����� �� ��������� ������� ��������.')
							elseif text:find('^/botoff') then
										newTask(function()
											VkMessage('&#128219; ��� ��������.')
										
											sendInput('/ao ��� ����������� �� �������������� ����, �������� �� ���� ����� :)')
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
													online_users = online_users..'\n'..convertToSmile(online_user_number)..'� @id'..all_conference_users[i]..'('..getUserName(all_conference_users[i])..')'
												end
											end
										end
										VkMessage('&#128373; ������������ ������ ������:\n\n'..online_users)
										all_conference_users = {}
									else
										NoDostupToCommand()
									end
							elseif text:find('^/text') then
								VkMessageFlood('/getbynick sanechka')
							elseif text:find('^/life') then
								VkMessage('&#128526; � ���!')
							elseif text:find('^/silence') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('silence') then
										silence = not silence
										VkMessage((silence and '&#9989; ' or '&#10060; ')..'@id'..from_id..'('..getUserName(from_id)..') '..(silence and '�������' or '��������')..' ����� ������.\n'..(silence and '&#128564; ��������� ���� ������������� ����� ������������� ���������.' or '&#128563; ��� ������� ������������ ����� ����� ���������� ���������.'))
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
													VkMessage('&#9989; �� �� ���������� ������ �� ���������� ��� �������� (/setpublic [@������]).')
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
														VkMessage('&#9989; ��������� ������� �������������, ������� �� ��������� �� ��������� ������ @public'..cfg.config.check_public_link..'('..getGroupNameById(cfg.config.check_public_link)..').\n&#128219;������������� �������: '..kick_user_public..'.')
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
														VkMessage('&#128305; ������ �������������, ������� �� ��������� �� ��������� ������ @public'..cfg.config.check_public_link..'('..getGroupNameById(cfg.config.check_public_link)..'):\n\n'..check_list..'\n\n&#128270; ����� �������������: '..check_user_public..'.')
														check_user_public = 0
														all_users_ids = {}
													end
												end
											else
												UseCommand('/checkpublic [��� ��������]. ���� ��������:\n\n&#128313; kick � ������� ����, ��� �� ��������.\n&#128313; watch � ������� ������ ���, ��� �� ��������.')
											end
										else
											UseCommand('/checkpublic [��� ��������]. ���� ��������:\n\n&#128313; kick � ������� ����, ��� �� ��������.\n&#128313; watch � ������� ������ ���, ��� �� ��������.')
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
												VkMessage('&#9989; �� ������� ���������� �������� �� ������ @public'..groupid..'('..getGroupNameById(groupid)..').\n\n&#128270; ��� �������� ���� ���������� �� ��������, ����������� ������� /checkpublic.\n&#8252; � ������, ���� ������������ �� �������� �� ��������� ������, �� ������������� �����������.')
												inicfg.save(cfg, bot_name..".ini")
											else
												UseCommand('/setpublic [@������]')
											end
										else
											UseCommand('/setpublic [@������]')
										end
									else
										NoDostupToCommand()
									end
								elseif text:find('^/removepublic') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('removepublic') then
										if cfg.config.check_on_public then
											cfg.config.check_on_public = false
											VkMessage('&#9940; @id'..from_id..'('..getUserName(from_id)..') �������� �������� �������� �� ������.')
											inicfg.save(cfg, bot_name..".ini")
										else
											VkMessage('&#9940; �������� �������� �� ������ � ��� ���������.')
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
												UseCommand('/stats [@������������]')
											end
										else
											UseCommand('/stats [@������������]')
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
													VkMessage('&#9999; ������������ @id'..id..' �������� � ������ ���������� ������.')
												else
													VkMessage('&#128219; ������������ @id'..id..' ��� ���� � ������ ����������.')
												end
											else
												UseCommand('/iwl [@������������]')
											end
										else
											UseCommand('/iwl [@������������]')
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
												UseCommand('/removerole [@������������]')
											end
										else
											UseCommand('/removerole [@������������]')
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
																	db_server:execute("INSERT INTO `logs`( `Text`, `Type`) VALUES ('[VK] "..from_id.." �������� ���������� ������������� �� "..args.." ����', '6')")
																	db_bot:execute("DELETE FROM `cf_users` where `userid` = '"..all_users_ids[i].."'")
																end
															end
														end
														if kick_user_inactive > 0 then
															VkMessage('&#128683; ��������� ������� �������������, ������� �� �������� �� ������ ���������, ������� � '..unix_decrypt((os.time())-(tonumber(days)*86400))..'.\n&#128686; ������������� ���������: '..kick_user_inactive)
														else
															VkMessage('&#9989; �� ������ ������� �� ������� �� ������ ������������.')
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
																	inactive_list = inactive_list..'\n'..convertToSmile(kick_user_inactive)..' @id'..all_users_ids[i]..'('..getUserName(all_users_ids[i])..') � ��������� ���������: '..unix_decrypt(getUserLastMessageDate(all_users_ids[i]))
																end
															end
														end
														if kick_user_inactive > 0 then
															VkMessage('&#128683; ������������, ������� �� �������� �� ������ ���������, ������� � '..unix_decrypt((os.time())-(tonumber(days)*86400))..':\n\n'..inactive_users)
														else
															VkMessage('&#9989; �� ������ ������� �� ������� �� ������ ������������.')
														end
														all_users_ids = {}
														kick_user_inactive = 0
													else
														VkMessage('&#10060; ������ �������� ��� ��������. �����������: >inactive [days] [type(watch/kick)]')
													end
												else
													VkMessage('&#10060; �������� ���������� ���� ����� ���� �� ������ 1 � �� ������ 30.')
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
												UseCommand('/rnick [@������������]')
											end
										else
											UseCommand('/rnick [@������������]')
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
												VkMessage('&#9996; @id'..from_id..'('..getUserName(from_id)..') ��������� ����� �����������:\n\n'..args)
												local f = io.open(bot_name..'/greetings.ini', 'w')
												f:write(args)
												f:close()
											else
												UseCommand('/greetings [����� �����������]')
											end
										else
											VkMessage('&#10060; @id'..from_id..'('..getUserName(from_id)..') ������ ����������� ��� ���������� ������ ��������� � ������.')
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
												UseCommand('/addadmin [���] [@������������]')
											end
										else
											UseCommand('/addadmin [���] [@������������]')
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
												UseCommand('/test [���] [@������������]')
											end
										else
											UseCommand('/test [���] [@������������]')
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
												UseCommand('/addspec [���] [@������������]')
											end
										else
											UseCommand('/addspec [���] [@������������]')
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
												UseCommand('/addowner [���] [@������������]')
											end
										else
											UseCommand('/addowner [���] [@������������]')
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
													find_list = find_list..'\n'..convertToSmile((find_nicks_user_number))..' @id'..userid..' � '..row.username
												end
												row = cursor:fetch(row, "a")
											end
											if find_list == '' then
												VkMessage('&#10060; ������������, ������� ������� �������� '..args..', �����������.')
											else
												VkMessage('&#128101; ������ ��������� �������������:\n\n'..find_list)
											end
											find_nicks_user_number = 0
										else
											UseCommand('/getbynick [����� ����]')
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
											users_list = users_list..'\n'..convertToSmile(all_users_with_name)..' @id'..row.userid..'('..getUserNameVk(row.userid)..') � '..row.username
											row = cursor:fetch(row, "a")
										end
										if users_list == '' then
											VkMessage('&#10060; ������������ � �������������� ���������� �����������.')
										else
											VkMessage('&#128101; ������ ������������� � �������������� ����������:\n\n'..users_list)
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
												VkMessage('&#9999; ����� '..nickname..' �������� � ������')
											else
												VkMessage('&#10060; ������ ����� ��� ���� � ������.')
											end
										else
											UseCommand('/addkick [�������]')
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
												VkMessage('&#9989; �� ������� ������� ������� '..nickname..' �� ������ �������, ������� ����� ������������� �������� ��� ����������� � �������.')
											else
												VkMessage('&#10060; ������� ������ � ��� ���� � ������.')
											end
										else
											UseCommand('/removekick [�������]')
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
											kick_nicknames_list = kick_nicknames_list..'\n'..convertToSmile(kick_user_number)..' '..row.nickname..' � &#128221; ���� @id'..row.insert..'('..getUserName(row.insert)..')'
											row = cursor:fetch(row, "a")
										end
										if kick_nicknames_list == '' then
											VkMessage('&#10060; � ������ �� �������� ��� �� ���� �����.')
										else
											VkMessage('&#128101; ������ �������, ������� ����� ������������� �������� ��� ����������� � �������:\n\n'..kick_nicknames_list)
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
											VkMessage('&#10060; ������������ ��� ������������� ��������� �����������.')
										else
											VkMessage('&#128101; ������ ������������� ��� ������������� ���������:\n\n'..nonicks_list)
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
													VkMessage('&#128219; ������������ ����� �������� - 30 ��������.')
												end
											else
												UseCommand('/snick [@������������] [�������]')
											end
										else
											UseCommand('/snick [@������������] [�������]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/������') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('snick') then
										args = text:match('^/������ (.*)')
										if args then
											id, link, nickname = args:match('^%[id(%d+)|@(.-)%] (.*)')
											if id and link and nickname then
												if #nickname <= 30 then
													setUserName(from_id, id, nickname)
												else
													VkMessage('&#128219; ������������ ����� �������� - 30 ��������.')
												end
											else
												UseCommand('/������ [@������������] [�������]')
											end
										else
											UseCommand('/������ [@������������] [�������]')
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
													VkMessage('&#128219; ������������ ����� �������� - 30 ��������.')
												end
											else
												UseCommand('/setnick [@������������] [�������]')
											end
										else
											UseCommand('/setnick [@������������] [�������]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/����') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('snick') then
										args = text:match('^/���� (.*)')
										if args then
											id, link, nickname = args:match('^%[id(%d+)|@(.-)%] (.*)')
											if id and link and nickname then
												if #nickname <= 30 then
													setUserName(from_id, id, nickname)
												else
													VkMessage('&#128219; ������������ ����� �������� - 30 ��������.')
												end
											else
												UseCommand('/���� [@������������] [�������]')
											end
										else
											UseCommand('/���� [@������������] [�������]')
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
												VkMessage('&#9996; @id'..from_id..'('..getUserName(from_id)..') ��������� ����� �����������:\n\n'..args)
												local f = io.open(bot_name..'/greetings.ini', 'w')
												f:write(args)
												f:close()
											else
												UseCommand('/greetings [����� �����������]')
											end
										else
											VkMessage('&#10060; @id'..from_id..'('..getUserName(from_id)..') ������ ����������� ��� ���������� ������ ��������� � ������.')
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
													VkMessage('&#9989; @id'..from_id..'('..getUserName(from_id)..') ������������� ������������ @id'..id..'('..getUserName(id)..').')
													db_bot:execute("DELETE FROM `ban_list` where `banuserid` = '"..id.."'")
												else
													VkMessage('&#9989; ��������� ������������ �� ������������.')
												end
											else
												UseCommand('/unban [@������������]')
											end
										else
											UseCommand('/unban [@������������]')
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
												UseCommand('/ban [@������������] [����] [�������]')
											end
										else
											UseCommand('/ban [@������������] [����] [�������]')
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
												UseCommand('/kick [@������������]')
									
											end
										else
											UseCommand('/kick [@������������]')
											
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/���') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('kick') then
										args = text:match('^/��� (.*)')
										if args then
											id, link = args:match('%[id(.*)|@(.*)%]')
											if id and link then
												kickUser(from_id, id)
											else
												UseCommand('/��� [@������������]')
											end
										else
											UseCommand('/��� [@������������]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/staff') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('staff') then
										cursor, errorString = db_bot:execute("select * from `cf_users`")
										staff_admins = '&#128142; �������������:'
										staff_special_admins = '&#11088; ����������� �������������:'
										staff_doverka = '&#128142; ������������:'
										staff_menegment = '&#128081; ��������:'
										while row do
											if tonumber(row.userdostup) == 1 then
												staff_admins = staff_admins..'\n� @id'..row.userid..'('..getUserNameVk(row.userid)..') [�� '..os.date("%X %d.%m.%Y", row.roletime)..']'
											elseif tonumber(row.userdostup) == 2 then
												staff_special_admins = staff_special_admins..'\n� @id'..row.userid..'('..getUserNameVk(row.userid)..') [�� '..os.date("%X %d.%m.%Y", row.roletime)..']'
											elseif tonumber(row.userdostup) == 3 then 	
												staff_doverka = staff_doverka..'\n- @id'..row.userid..'('..getUserNameVk(row.userid)..') [�� '..os.date("%X %d.%m.%Y", row.roletime)..']'
											elseif tonumber(row.userdostup) == 4 then 	
												staff_menegment = staff_menegment..'\n- @id'..row.userid..'('..getUserNameVk(row.userid)..') [�� '..os.date("%X %d.%m.%Y", row.roletime)..']'
											end
											row = cursor:fetch(row, "a")
										end
										test = '������� ��������: @id'..from_id..'('..getUserName(from_id)..')\n'
										if staff_admins == '&#128142; �������������:' then staff_admins = '&#128142; �������������:\n� �����������' end
										if staff_special_admins == '&#11088; ����������� �������������:' then staff_special_admins = '&#11088; ����������� �������������:\n� �����������' end
										if staff_doverka == '&#128142; �������:' then staff_doverka = '&#128142; �������:\n� �����������' end
										if staff_menegment == '&#128142; ��������:' then staff_menegment = '&#128142; ��������:\n� �����������' end
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
												VkMessage('&#9999; �� ������� ������ ������� '..command..' �� ������ ��������������� ������ ����.')
											else
												VkMessage('&#10060; ������ ������� � ��� ���� � ������ ��������������� �������� ����.')
											end
										else
											UseCommand('/nfdel [������� ��� /]')
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
												VkMessage('&#9999; �� ������� ������ ������� '..command..' �� ������ ��������������� �������� ����.')
											else
												VkMessage('&#10060; ������ ������� � ��� ���� � ������ ��������������� �������� ����.')
											end
										else
											UseCommand('/fdel [������� ��� /]')
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
											VkMessage('&#10060; ������ ������ �����������.')
										else
											VkMessage('&#128196; ������ ������ � �������������� ��������� ����:\n\n'..forms_list)
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
												VkMessage('&#9999; �� ������� �������� ������� '..command..' � ������ ��������������� �������� ����.')
											else
												VkMessage('&#10060; ������ ������� � ��� ���� � ������ ��������������� �������� ����.')
											end
										else
											UseCommand('/fadd [������� ��� /]')
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
												VkMessage('&#9999; ������������ '..name..' ���������� � �����')
											else
												VkMessage('&#128219; ������������ '..name..' ��� ���� � ������ ����������.')
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
                               --             VkMessage('������ ����: .$botstatus.')
							--		else
							--			NoDostupToCommand()
							--		end					





							--��� ����� �� �������
								--elseif text:find('^/lsstart') then
									--if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('acceptlog') then
									--	name = text:match('^/lsstart (.*)')
--
                                   --         VkMessage('�� ������� ��������� ���� ')
									--else
										NoDostupToCommand()
								--	end					
								elseif text:find('^/createlog') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('acceptlog') then
										name, pass = text:match('^/createlog (.*) (.*)')
										if name then
											if not isUserInsertInToDB(name) then
												db_server:execute("INSERT INTO `user` (`username`, `password`, `status`) VALUES ('"..name"', '"..pass..", 1')")
												VkMessage('&#9999; ������������ '..name..' ���������� � �����')
											else
												VkMessage('&#128219; ������������ '..name..' ��� ���� � ������ ����������.')
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
												VkMessage('&#9999; ������������ '..name..' ����� ����� ������ �� ������ ['..getStatusForuPokras(porkas)..']')
											else
												VkMessage('&#128219; ������������ '..name..' ��� ���� � ������ ����������.')
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
												VkMessage('&#9999; ������������ '..name..' ����� ����� ������ � �����')
											else
												VkMessage('&#128219; ������������ '..name..' ��� ���� � ������ ����������.')
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
												VkMessage('&#9999; ������������ '..name..' ����� �� �����')
											else
												VkMessage('&#128219; ������������ '..name..' ��� ���� � ������ ����������.')
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
											VkMessage('&#10060; ������ ������ �����������.')
										else
											VkMessage('&#128196; ������ ������ � �������������� ������� ����:\n\n'..no_forms_list)
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
												VkMessage('&#9999; �� ������� �������� ������� '..command..' � ������ ��������������� �� �������� ����.')
											else
												VkMessage('&#10060; ������ ������� � ��� ���� � ������ ��������������� �� �������� ����.')
											end
										else
											UseCommand('/nfadd [������� ��� /]')
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
												UseCommand('/vig [@������������]')
											end
										else
											UseCommand('/vig [@������������]')
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
												UseCommand('/warn [@������������]')
											end
										else
											UseCommand('/warn [@������������]')
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
												UseCommand('/unwarn [@������������]')
											end
										else
											UseCommand('/unwarn [@������������]')
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
												UseCommand('/unvig [@������������]')
											end
										else
											UseCommand('/unvig [@������������]')
										end
									else
										NoDostupToCommand()
									end
								elseif text:find('^/demote') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('demote') then
										VkMessage('&#128528; @id'..from_id..'('..getUserName(from_id)..') �������� ������ ������������� ���������� ������ (����������: ������������� ������).')
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
											UseCommand('/zovy [������� ������]')
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
											UseCommand('/zov [������� ������]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/���') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('zov') then
										call_reason = text:match('^/��� (.*)')
										if call_reason then
											callUsers(from_id, call_reason)
										else
											UseCommand('/��� [������� ������]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/�����') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('zov') then
										call_reason = text:match('^/����� (.*)')
										if call_reason then
											callUsers(from_id, call_reason)
										else
											UseCommand('/����� [������� ������]')
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
													VkMessage('&#9999; ������������ @id'..id..' �������� � ������ ���������� ������.')
												else
													VkMessage('&#128219; ������������ @id'..id..' ��� ���� � ������ ����������.')
												end
											else
												UseCommand('/iwl [@������������]')
											end
										else
											UseCommand('/iwl [@������������]')
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
												message_top = message_top..'\n'..convertToSmile(user_number)..' @id'..row.userid..'('..getUserName(row.userid)..') � '..row.messages..'�����.'
												row = cursor:fetch(row, "a")
											end
										end
										if message_top == '' then
											VkMessage('&#9940; ��� 10 �� ���������� ��� �� �������������.')
										else
											VkMessage('&#128081; ��� 10 ������������� �� ����������:\n\n'..message_top)
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
												UseCommand('/unmute [@������������]')
											end
										else
											UseCommand('/unmute [@������������]')
										end
									else
										NoDostupToCommand()
									end
								elseif text:find('^/�����') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('unmute') then
										args = text:match('^/����� (.*)')
										if args then
											id, link = args:match('%[id(.*)|@(.*)%]')
											if id and link then
												removeUserMute(from_id, id)
											else
												UseCommand('/����� [@������������]')
											end
										else
											UseCommand('/����� [@������������]')
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
												UseCommand('/mute [@������������] [�����] [�������]')
											end
										else
											UseCommand('/mute [@������������] [�����] [�������]')
										end
									else
										NoDostupToCommand()
									end
								elseif text:find('^/���') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('mute') then
										args = text:match('^/��� (.*)')
										if args then
											id, link, mutetime, mutereason = args:match('%[id(.*)|@(.*)%] (%d+) (.*)')
											if id and link and mutetime and mutereason then
												giveUserMute(from_id, id, mutetime, mutereason)
											else
												UseCommand('/��� [@������������] [�����] [�������]')
											end
										else
											UseCommand('/��� [@������������] [�����] [�������]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/q$') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('q') then
										if tonumber(getUserLevelDostup(from_id)) >= 4 then
											VkMessage('@id'..from_id..' �� �� ������ �������� ��� �����������. ������ ��� �� ����������')
										else
											luaVkApi.removeChatUser((tonumber(chat_id)), tonumber(from_id))
											db_bot:execute("DELETE FROM `cf_users` where `userid` = '"..from_id.."'")
											VkMessage('@id'..from_id..' ������� ������ �����������.')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/�������') then
									last_dat = '12.03.2024'
									VkMessage('&#9940; ���������: \n 1. ���������� ���������� �� ���� ���� ���� �� �� �� (vig/������) \n 2. ������ ������ ����� ���� (vig) \n 3. ��������� ����������������� ���� (vig) \n 4. ������ �� ���� ���� ������ ����� (vig) \n 5. ���� �������� \n\n &#9989; ���������: \n 1. ������������ ���� �� ���������� \n 2. ������ �������, ��������� ������� \n 3. ��� ���������, ��� �� ��������� \n\n &#127760; ��������� ����������: '..last_dat)
							elseif text:find('/ifind') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('ifind') then
										name_find_item = text:match('/ifind (.*)')
										if name_find_item then
											find_item = true
											sendInput('/finditem '..name_find_item)
										else
											UseCommand('/ifind [�������� ��������]')
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
														name_type = '���'
													elseif tonumber(id_type) == 1 then
														name_type = '������'
													end
													if tonumber(opra_or_no) == 0 then
														name_opra = '������������ �� ����� �� �����'
													elseif tonumber(opra_or_no) == 1 then
														name_opra = '������������ �� ����� �����'
													end
													threekeyboard_vk('&#10071; ����� �������� ����������� ��������� ��� ���������. �� ������ ����� ����� ���������!')
													start_button = true
												else
													VkMessage('&#128683; ������� ������ �������� � ������� ������������.')
												end
											else
												VkMessage('&#128683; ����� ��������� ����� ���� �� ������ 5 ������ � �� ������ 600 ������.')
											end
										else
											VkMessage('&#128683; ������� ������ ID ���������.')
										end
									else
										VkMessage('&#128683; ������� ������ ��� ���������.')
									end
								else
									VkMessage('&#128683; �������������� ��� ��� �������, ���������� �����.')
								end
							elseif text:find('^/opra') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('aopra') then
										autoopra = not autoopra
										sendInput('/a [VK] '..getUserName(from_id)..' '..(autoopra and '�������' or '��������')..' ����������������.')
										sendInput('/vr [VK] '..getUserName(from_id)..' '..(autoopra and '�������' or '��������')..' ����������������.')
										VkMessage('&#128680; @id'..from_id..'('..getUserName(from_id)..') '..(autoopra and '�������' or '��������')..' ����������������.')
									else
										NoDostupToCommand()
									end
							elseif text:find('^/interaction (%d+)') then
								cd = text:match('^/interaction (%d+)')
								checkParametrs(config[2][1], '�� �� �������� ���������� �������������� � ����� �������� ��: '..cd..'sec.', cd)
							elseif text:find('^/stock (%d+)') then
								cd = text:match('^/stock (%d+)')
								checkParametrs(config[3][1], '�� �� �������� ���������� � ������ �������� ��: '..cd..'sec.', cd)
							elseif text:find('^/ques (%d+)') then
								cd = text:match('^/ques (%d+)')
								checkParametrs(config[4][1], '�� �� ���������� �������� ����� ������ �������� ��: '..cd..'sec.', cd)
							elseif text:find('^/captcha (%d+)') then
								cd = text:match('^/captcha (%d+)')
								checkParametrs(config[1][1], '�� �� ���������� ���� �������� ��: '..cd..'sec.', cd)
							elseif text:find('^/skin (%d+)') then
								cd = text:match('^/skin (%d+)')
								checkParametrs(config[6][1], '�� �� ���������� ������ ����� ����������� ����� �������� ��: '..cd..'sec.', cd)
							elseif text:find('^/padmins (%d+)') then
								cd = text:match('^/padmins (%d+)')
								checkParametrs(config[8][1], '�� �� ���������� � ������� �� �������������� �������� ��: '..cd..'sec.', cd)
							elseif text:find('^/pvk (%d+)') then
								cd = text:match('^/pvk (%d+)')
								checkParametrs(config[5][1], '�� �� ������� ����� �� �������� ��: '..cd..'sec.', cd)
							elseif text:find('^/aopra (%d+)') then
								cd = text:match('^/aopra (%d+)')
								checkParametrs(config[7][1], '����� ������ �������� � PayDay �������� ��: '..cd..'sec.', cd)
							elseif text:find('^/floodrep (%d+)') then
								cd = text:match('^/floodrep (%d+)')
								checkParametrs(config[9][1], '����� ����� ������� ������ ��: '..cd..'sec.', cd)
							elseif text:find('^/nrg') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('settings') then
										cd = text:match('/nrg (%d+)')
										if cd then
											if tonumber(cd) >= 0 and tonumber(cd) <= 1800 then
												cfg.cooldowns.nrg = cd
												VkMessage('&#128344; ������ ��������� ��� ����� ���� � VIP ���� �������� 1 ��� � '..convertToMinutes(cd))
												inicfg.save(cfg, bot_name..".ini")
											else
												UseCommand('/nrg [����� � �������� (0-1800)]')
											end
										else
											UseCommand('/nrg [����� � �������� (0-1800)]')
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
												VkMessage('&#128344; ������ ��������� ������ ����� ���� � VIP ���� �������� 1 ��� � '..convertToMinutes(cd))
												inicfg.save(cfg, bot_name..".ini")
											else
												UseCommand('/spawn [����� � �������� (0-1800)]')
											end
										else
											UseCommand('/spawn [����� � �������� (0-1800)]')
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
												VkMessage('&#128344; ������ ��������� ����� ����� ���� � VIP ���� �������� 1 ��� � '..convertToMinutes(cd))
												inicfg.save(cfg, bot_name..".ini")
											else
												UseCommand('/flip [����� � �������� (0-1800)]')
											end
										else
											UseCommand('/flip [����� � �������� (0-1800)]')
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
												VkMessage('&#128344; ������ �������� ����� ���� � VIP ���� �������� 1 ��� � '..convertToMinutes(cd))
												inicfg.save(cfg, bot_name..".ini")
											else
												UseCommand('/teleport [����� � �������� (0-1800)]')
											end
										else
											UseCommand('/teleport [����� � �������� (0-1800)]')
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
												VkMessage('&#128344; ������ ��������� ��������� ����� ���� � VIP ���� �������� 1 ��� � '..convertToMinutes(cd))
												inicfg.save(cfg, bot_name..".ini")
											else
												UseCommand('/infernus [����� � �������� (0-1800)]')
											end
										else
											UseCommand('/infernus [����� � �������� (0-1800)]')
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
												VkMessage('&#8987; ��������, ������� �������� ����������. �������� ����� ������� ~ '..tonumber(("%.1f"):format((tonumber(max_biz) - tonumber(min_biz))*0.75))..'���. [1 ������ - 750 ��].')
												check_biz = true
												sendInput('/checkbiz '..min_biz)
											else
												VkMessage('&#128683; ������ ��������� ����� 40 �������� �� ���� ��� (��-�� ����������� ����� ��������� � VK)!')
											end
										else
											VkMessage('&#128683; ��������� ���������� �������� ������� �������!')
										end
									else
										VkMessage('&#128683; ID ���������� ������� �� ����� ���� ������ IDa ��������� �������!')
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
												VkMessage('&#8987; ��������, ������� �������� ����������.\n-- �������� ����� ������� ~ '..tonumber(("%.1f"):format((tonumber(max_house) - tonumber(min_house))*0.75))..'���. [1 ��� - 750 ��].')
												check_house = true
												sendInput('/checkhouse '..min_house)
											else
												VkMessage('&#128683; ������ ��������� ����� 40 ����� �� ���� ��� (��-�� ����������� ����� ��������� � VK)!')
											end
										else
											VkMessage('&#128683; ��������� ���������� ����� ������� �������!')
										end
									else
										VkMessage('&#128683; ID ���������� ���� �� ����� ���� ������ IDa ��������� ����!')
									end
								end
							elseif text:find('^/startskin') then
								startSkin()
								VkMessage('&#128084; �������� ����� �� ��������� ����. �������� ����������!')
							elseif text:find('^/mesto') then
								sendInput('/setint '..bot_name..' 0')
								sendInput('/setvw '..bot_name..' 0')
								runCommand('!pos -810.18 2830.79 1501.98')
								VkMessage('������ ��� ��������, � ��� �� �����.')
							elseif text:find('^/gowork') then
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								sendInput('/a ��������')
								VkMessage('&#128084; ������ ��������� �������')
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
													VkMessage('&#9999; �� ������� �������� ������� ������� � ������� '..command..'. ������ ��� ������� ������� � ����� '..getStatusNameByLevelDostup(level_dostup)..'.')
													updateArrayCommands()
												else
													UseCommand('/editcmd [�������] [������� ������� (0 � 4)].\n\n&#128081; ������ �������:\n&#128313; 0 � ������������.\n&#128313; 1 � �������������.\n&#128313; 2 � ����������� �������������.\n&#128313; 3 � ������������.\n&#128313; 4 � ����������.\n\n&#9881; ��� ������ ���� ��������� ������ ��� ������� � ������� ����������� ������� >dcmd.')
												end
											else
												VkMessage('&#9940; ��������� ������� �� ����������.')
											end
										else
											UseCommand('/editcmd [�������] [������� ������� (0 � 4)].\n\n&#128081; ������ �������:\n&#128313; 0 � ������������.\n&#128313; 1 � �������������.\n&#128313; 2 � ����������� �������������.\n&#128313; 3 � ������������.\n&#128313; 4 � ����������.\n\n&#9881; ��� ������ ���� ��������� ������ ��� ������� � ������� ����������� ������� >dcmd.')
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
												VkMessage('&#10060; @id'..from_id..'('..getUserName(from_id)..') �������� ���� �������������, ����������� ������������� @id'..id..'('..getUserName(id)..').')
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
												UseCommand('/rkick [@������������]')
											end
										else
											UseCommand('/rkick [@������������]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('/om') then
								playernick, id_type, bizids = text:match('/om (.*) (%d+) (.*)')
								if tonumber(id_type) == 0 then
									name_type = '���'
									runCommand('/unjail '..playernick..' ������������ �� �������')
									runCommand('/unjailoff '..playernick..' ������������ �� �������')
									runCommand('/sethouseowner '..bizids..' '..bot_name) 
									VkMessage('&#128056; ����� '..playernick..' ������� �� ��������� �� ������� "������������ �� �������".('..name_type..')')
								end
								if tonumber(id_type) == 1 then
									name_type = '������'
									runCommand('/unjail '..playernick..' ������������ �� �������')
									runCommand('/unjailoff '..playernick..' ������������ �� �������')
									runCommand('/setbizowner '..bizids..' '..bot_name) 
									VkMessage('&#128056; ����� '..playernick..' ������� �� ��������� �� ������� "������������ �� �������".('..name_type..')')
								else
									UseCommand('/om [������� ������] (0 - ��� 1 - ������) [id ����/����]')
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
											elseif line:find('%<td%>��������%</td%>\n%<td%>(.*)%</td%>') then
												org_name = line:match('%<td%>��������%</td%>\n%<td%>(.*)%</td%>')
												find_results = find_results..'\n'..convertToSmile(org_id)..' '..org_name..' � &#128188; ��������'
												free_leaders = free_leaders + 1
											end
										end
										VkMessage('&#128269; | ������ ������� �������:\n'..find_results..'\n\n&#11088; ������� �������: '..convertToSmile(take_leaders)..'\n&#11088; ��������� �������: '..convertToSmile(free_leaders))
									else
										NoDostupToCommand()
									end
							elseif text:find('/checkban') then
								playernick = text:match('/checkban (.*)')
								if playernick then
									checkban_player = true
									sendInput('/unban '..playernick..' �������� �� ������� ����')
								else
									UseCommand('/checkban [������� ������]')
								end
							if v.object.message.action and v.object.message.action.member_id then 
								if v.object.message.action.type == 'chat_kick_user' then
									db_bot:execute("DELETE FROM `cf_users` where `userid` = '"..v.object.message.action.member_id.."'")
								elseif v.object.message.action.type == ('chat_invite_user' or 'chat_invite_user_by_link') then
									local new_user_id = v.object.message.action.member_id
									if isUserInBan(new_user_id) then
										VkMessage('&#9940; ������������ @id'..new_user_id..'('..getUserName(new_user_id)..') ������������ ������������� @id'..getUserBanByAdmin(new_user_id)..'('..getUserName(getUserBanByAdmin(new_user_id))..').\n&#128203; ������� ����������: '..getUserBanReason(new_user_id))
										luaVkApi.removeChatUser((tonumber(chat_id)), tonumber(v.object.message.action.member_id))
									else
										local f = io.open(bot_name..'/greetings.ini', "r")
										greetings = f:read('*a')
										f:close()
										if cfg.config.check_on_public and not isUserSubscribeOnGroup(new_user_id) then
											VkMessage('&#9940; ������������ @id'..new_user_id..'('..getUserName(new_user_id)..') �� ������� � ������� @public'..cfg.config.check_public_link..'('..getGroupNameById(cfg.config.check_public_link)..').')
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
													VkMessage('&#10060; ������ �������� ������ �������!')
												else
													if form:match("/unban (.*)") then
														give_unban_form = true
													end
													runCommand(form)
													get_message_from_server = true
												end
											end
										else
											UseCommand('/ac [��������]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find("^/makeadmin (.*) (%d+)") and not get_ip_information then
								id, lvl = text:match("^/makeadmin (.*) (%d+)")
								if id then
									if id then
										sendInput('/makeadmin '..id..' '..lvl)
										VkMessage('������� ��������: @id'..from_id..'('..getUserName(from_id)..')\n\n[MakeAdmin] '..bot_name..'[0] ��������� '..lvl..' ������� �������������� ������ '..id)
									end
								else
									UseCommand('/makeadmin [name] [lvl]')
								end
							elseif text:find("^/a (.*)") and not get_ip_information then
								form = text:match("^/a (.*)")
								if form then
									if form ~= '' then
										sendInput('/a '..form)
										VkMessage('������� ��������: @id'..from_id..'('..getUserName(from_id)..')\n\n[A] '..bot_name..'[0]: '..form)
									end
								else
									UseCommand('/a [Text]')
								end
							elseif text:find("^/vr (.*)") and not get_ip_information then
								form = text:match("^/vr (.*)")
								if form then
									runCommand('/vr '..form)
									VkMessage('������� ��������: @id'..from_id..'('..getUserName(from_id)..')\n\n[ADMIN] '..bot_name..'[0]: '..form)
								else
									UseCommand('/vr [Text]')
								end
							elseif text:find('/cban') then
								name = text:match('/cban (.*)')
								if name then
									sendInput('/banoff 0 '..name..' 2000 �� ��������������')
									sendInput('/ban '..name..' 30 �� ��������������')
									VkMessage('������� ��������: @id'..from_id..'('..getUserName(from_id)..')\n\n�: '..bot_name' ������� ������ '..name..'. �������: �� ��������������')
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
										VkMessage('&#128344; �������� ��������, ��������� ����� �������� '..tonumber(("%.1f"):format(265*1.50))..'���.')
										abusiness_check_list = ''
										check_business_admin = true
										sendInput('/checkbiz 0')
										acheckbizid = 0
									else
										NoDostupToCommand()
									end
							elseif text:find('/checkhouseadm') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('ach') then
										VkMessage('&#128344; �������� ��������, ��������� ����� �������� '..tonumber(("%.1f"):format(265*1.50))..'���.')
										ahouse_check_list = ''
										check_house_admin = true
										sendInput('/checkhouse 0')
										acheckhouseid = 0
									else
										NoDostupToCommand()
									end
							elseif text:find('/is') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('is') then 
									VkMessage([[&#128190; ������ ����� �������� ��� ��������� ����������:
								
0&#8419; �������
1&#8419; ��������
2&#8419; ���
3&#8419; VIP ������
4&#8419; ����� ��������
5&#8419; ������
6&#8419; ���� � �����
7&#8419; AZ ������
8&#8419; ���� �������
9&#8419; ����� ������ [0-3] 
1&#8419;0&#8419; AZ �����
1&#8419;1&#8419; ADD VIP
1&#8419;2&#8419; ����������� ADD VIP

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
												VkMessage('&#128683; ��������� ����� �� ������� �������.')
											else
												VkMessage('&#128373; | ������ ��������� ���������:\n\n'..change_log)
											end
										else
											UseCommand('/fnick [������� ������]')
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
											UseCommand('/astats [������� ��������������]')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/checkinv') then
									if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('checkinv') then
										nickname = text:match('^/checkinv (.*)')
										if nickname then
											if isAccountExists(nickname) then
												VkMessage('&#128190; ��������� ������ '..nickname..':\n\n� ����� | �������� �������� [���������� | �������]\n'..getPlayerInvItems(nickname)..'\n\n&#128373; | ��������� ���������� ������ ���������: '..unix_decrypt(cfg.config.update_items))
											else
												VkMessage('&#10060; ���������� �������� �� ����������.')
											end
										else
											UseCommand('/checkinv [�������]')
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
														VkMessage('&#10060; | ������� ������ ��������� ���������.') return false 
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
												VkMessage('&#10060; | ���������� �������� �� ����������.')
											end
										else
											UseCommand('/check [�������]')
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
												VkMessage('&#10060; ��������� ����� �� � ����!')
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
											VkMessage('&#10060; ������������, ������� ����� ������ � ���� � ���� �����������.')
										else
											VkMessage('&#128196; ������ �������������, � ������� ������� ������ � ���������� ����� � ����:\n\n'..white_l)
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
												VkMessage('&#9989; �� ������� ������� ������ � ���������� ����� � ���� � ������ '..player_name..'.')
											else
												VkMessage('&#10060; � ������� ������������ � ��� ���� ������� � ���������� ����� � ����.')
											end
										else
											UseCommand('/twl [�������]')
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
												VkMessage('&#10060; � ������� ������������ ��� ���� ������ � ���������� ����� � ����.')
											end
										else
											UseCommand('/al [�������]')
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
													VkMessage('&#10060; ������ �������� ������ �������!')
												else
													multiline_message = ''
													if forms:match("/unban (.*)") then
														give_unban_form = true
													end
													for asdsa in forms:gmatch("[^\r\n]+") do
														command_number = command_number + 1
													end
													VkMessage('&#128344; ������� ��������� ������. ����� �������� ~ '..tonumber(("%.1f"):format((command_number)*0.25))..'���.')
													forms = forms:gsub('  ', '')
													newTask(function ()
														for asdsa in forms:gmatch("[^\r\n]+") do
															runCommand(asdsa)
															get_message_from_server_multiline = true
															wait(500)
														end
														VkMessage("&#9989; �������������� ���������.\n&#128172; ��������� �� �������: "..forms)
														command_number = 0
													end)
												end
											end
										else
											UseCommand('/multiac [��������] -- ������ �������� � ����� ������')
										end
									else
										NoDostupToCommand()
									end
							elseif text:find('^/rec') then
								VkMessage('&#8618; ������� ������������ �� ������...')
								reconnect(0)
							elseif text:find('^/reload') then
								VkMessage('���� , ������������ ����!')
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
									VkMessage('&#128101; ������ �����������:\n\n'..orgonline_list)
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
										VkMessage('&#128101; ������ ������ [�����: '..leadernum..']:\n\n'..leader_list)
									else
										VkMessage('&#128683; �� ������ ������ �� ������� ���� �� ������ ������ ������!')
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
								keyboard_vk('&#128200; �������� ��� ���������� �������:', 'onl')
							elseif text:find('^/reportstats') then
								keyboard_vk('&#128200; �������� ��� ���������� �������:', 'rep')
							elseif text:find('^/adminstats') then
								keyboard_vk('&#128200; �������� ��� ���������� �����. �������:', 'adm')
							elseif text:find('^/reports') then
								send_info_report()
							elseif text:find('^/startmycaptcha (%d+)') then
								item = text:match('/startmycaptcha (%d+)')
								if tonumber(item) < 2709 then
									startMyCaptcha(item)
									VkMessage('&#128290; ��������� ����� �� ������� �'..item..' ��������.')
								else
									VkMessage('&#10060; �������� �'..item..' �� ����������, �������� �� ��������� ������.')
								end
							elseif text:find('^/bowner (%d+)') then
								business_id = text:match('/bowner (%d+)')
								get_business = true
								sendInput('/checkbiz '..business_id)
								newTask(function()
									wait(1000)
									VkMessage('&#127978; ������ �'..bid..'\n&#128100; ��������: '..owner..'\n�����������: '..deputy_owner..'\n&#128176; ������ � ����� �������: '..business_money..'.')
									get_business = false
								end)
								--������� ��
							elseif text:find('^nick') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('snick') then
									args = text:match('^nick (.*)')
									if args then
										id, link, nickname = args:match('^%[id(%d+)|@(.-)%] (.*)')
										if id and link and nickname then
											if #nickname <= 30 then
												setNickName(from_id, id, nickname, user_id)
											else
												vk_request_user(user_id,'&#128219; ������������ ����� �������� - 30 ��������.')
											end
										else
											UseCommandls('nick [@������������] [�������]')
										end
									else
										UseCommandls('nick [@������������] [�������]')
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
											vk_request_user(user_id, '&#10060; � ������� ������������ ��� ���� ������ � ���������� ����� � ����.')
										end
									else
										UseCommandls('al [�������]')
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
												vk_request_user(user_id, '&#9999; ������������ @id'..id..' �������� � ������ ���������� ������.')
											else
												vk_request_user(user_id, '&#128219; ������������ @id'..id..' ��� ���� � ������ ����������.')
											end
										else
											UseCommandls('iwl [@������������]')
										end
									else
										UseCommandls('iwl [@������������]')
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
											vk_request_user(user_id, '&#9989; �� ������� ������� ������� '..nickname..' �� ������ �������, ������� ����� ������������� �������� ��� ����������� � �������.')
										else
											vk_request_user(user_id, '&#10060; ������� ������ � ��� ���� � ������.')
										end
									else
										UseCommandls('removekick [�������]')
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
											vk_request_user(user_id, '&#9996; @id'..from_id..'('..getUserName(from_id)..') ��������� ����� �����������:\n\n'..args)
											local f = io.open(bot_name..'/greetings.ini', 'w')
											f:write(args)
											f:close()
										else
											UseCommandls('greetings [����� �����������]')
										end
									else
										vk_request_user(user_id, '&#10060; @id'..from_id..'('..getUserName(from_id)..') ������ ����������� ��� ���������� ������ ��������� � ������.')
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
									staff_admins = '&#128142; �������������:'
									staff_special_admins = '&#11088; ����������� �������������:'
									staff_doverka = '&#128142; ������������:'
									staff_menegment = '&#128081; ��������:'
									while row do
										if tonumber(row.userdostup) == 1 then
											staff_admins = staff_admins..'\n� @id'..row.userid..'('..getUserNameVk(row.userid)..') [�� '..os.date("%X %d.%m.%Y", row.roletime)..']'
										elseif tonumber(row.userdostup) == 2 then
											staff_special_admins = staff_special_admins..'\n� @id'..row.userid..'('..getUserNameVk(row.userid)..') [�� '..os.date("%X %d.%m.%Y", row.roletime)..']'
										elseif tonumber(row.userdostup) == 3 then 	
											staff_doverka = staff_doverka..'\n- @id'..row.userid..'('..getUserNameVk(row.userid)..') [�� '..os.date("%X %d.%m.%Y", row.roletime)..']'
										elseif tonumber(row.userdostup) == 4 then 	
											staff_menegment = staff_menegment..'\n- @id'..row.userid..'('..getUserNameVk(row.userid)..') [�� '..os.date("%X %d.%m.%Y", row.roletime)..']'
										end
										row = cursor:fetch(row, "a")
									end
									test = '������� ��������: @id'..from_id..'('..getUserName(from_id)..')\n'
									if staff_admins == '&#128142; �������������:' then staff_admins = '&#128142; �������������:\n� �����������' end
									if staff_special_admins == '&#11088; ����������� �������������:' then staff_special_admins = '&#11088; ����������� �������������:\n� �����������' end
									if staff_doverka == '&#128142; �������:' then staff_doverka = '&#128142; �������:\n� �����������' end
									if staff_menegment == '&#128142; ��������:' then staff_menegment = '&#128142; ��������:\n� �����������' end
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
									staff_admins = '&#128142; �������������:'
									staff_special_admins = '&#11088; ����������� �������������:'
									staff_doverka = '&#128142; ��� ��������������:'
									staff_zga = '&#128081; ���:'
									staff_ga = '&#128081; ��:'
									staff_menegment = '&#128081; ��������:'
									while row do
										if tonumber(row.userdostup) == 1 then
											staff_admins = staff_admins..'\n� @id'..row.userid..'('..row.nickname..')'
										elseif tonumber(row.userdostup) == 2 then
											staff_special_admins = staff_special_admins..'\n� @id'..row.nickname..'('..row.nickname..') '
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
									
									if staff_admins == '&#128142; �������������:' then staff_admins = '&#128142; �������������:\n� �����������' end
									if staff_special_admins == '&#11088; ����������� �������������:' then staff_special_admins = '&#11088; ����������� �������������:\n� �����������' end
									if staff_doverka == '&#128142; ��� �������������:' then staff_doverka = '&#128142; ��� �������������:\n� �����������' end
									if staff_zga == '&#128142; ���:' then staff_zga = '&#128142; ���:\n� �����������' end
									if staff_ga == '&#128142; ��:' then staff_ga = '&#128142; ��:\n� �����������' end
									if staff_menegment == '&#128142; ��������:' then staff_menegment = '&#128142; ��������:\n� �����������' end
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
									lvl1 = '&#128142; ������ 1 ������:'
									lvl2 = '&#128142; ������ 2 ������:'
									lvl3 = '&#128142; ������ 3 ������:'
									lvl4 = '&#128081; ������ 4 ������:'
									lvl5 = '&#128081; ������ 5 ������:'
									lvl6 = '&#128081; ������ 6 ������:'
                                    lvl7 = '&#128081; ������ 7 ������:'
									lvl8 = '&#128081; ������ 8 ������:'
									while row do
										if tonumber(row.level) == 1 then
											lvl1 = lvl1..'\n� '..row.name..''
										elseif tonumber(row.level) == 2 then
											lvl2 = lvl2..'\n� '..row.name..''
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
									
									if lvl1 == '&#128142; ������ 1 ���:' then lvl1 = '&#128142; ������ 1 ���:\n� �����������' end
									if lvl2 == '&#128142; ������ 2 ���:' then lvl2 = '&#128142; ������ 2 ���:\n� �����������' end
									if lvl3 == '&#128142; ������ 3 ���:' then lvl3 = '&#128142; ������ 3 ���:\n� �����������' end
									if lvl4 == '&#128142; ������ 4 ���:' then lvl4 = '&#128142; ������ 4 ���:\n� �����������' end
									if lvl5 == '&#128142; ������ 5 ���:' then lvl5 = '&#128142; ������ 5 ���:\n� �����������' end
									if lvl6 == '&#128142; ������ 6 ���:' then lvl6 = '&#128142; ������ 6 ���:\n� �����������' end
									if lvl7 == '&#128142; ������ 7 ���:' then lvl7 = '&#128142; ������ 7 ���:\n� �����������' end
									if lvl8 == '&#128142; ������ 8 ���:' then lvl8 = '&#128142; ������ 8 ���:\n� �����������' end
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
											vk_request_user(user_id, '&#9999; ������������ '..name..' ���������� � �����')
										else
											vk_request_user(user_id, '&#128219; ������������ '..name..' ��� ���� � ������ ����������.')
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
											vk_request_user(user_id, '&#9999; ������������ '..name..' ����� �� �����')
										else
											vk_request_user(user_id, '&#128219; ������������ '..name..' ��� ���� � ������ ����������.')
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
										UseCommandls('zov [������� ������]')
									end
								else
									NoDostupToCommand()
								end
						elseif text:find('^���') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('zov') then
									call_reason = text:match('^��� (.*)')
									if call_reason then
										callUsers(from_id, call_reason)
									else
										UseCommandls('��� [������� ������]')
									end
								else
									NoDostupToCommand()
								end
						elseif text:find('^�����') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('zov') then
									call_reason = text:match('^����� (.*)')
									if call_reason then
										callUsers(from_id, call_reason)
									else
										UseCommandls('����� [������� ������]')
									end
								else
									NoDostupToCommand()
								end
						elseif text:find('^�������') then
								last_dat = '12.03.2024'
								vk_request_user(user_id, '&#9940; ���������: \n 1. ���������� ���������� �� ���� ���� ���� �� �� �� (vig/������) \n 2. ������ ������ ����� ���� (vig) \n 3. ��������� ����������������� ���� (vig) \n 4. ������ �� ���� ���� ������ ����� (vig) \n 5. ���� �������� \n\n &#9989; ���������: \n 1. ������������ ���� �� ���������� \n 2. ������ �������, ��������� ������� \n 3. ��� ���������, ��� �� ��������� \n\n &#127760; ��������� ����������: '..last_dat)																
						elseif text:find('^mesto') then
							sendInput('/setint '..bot_name..' 0')
							sendInput('/setvw '..bot_name..' 0')
							runCommand('!pos -810.18 2830.79 1501.98')
							vk_request_user(user_id, '������ ��� ��������, � ��� �� �����.')
						elseif text:find('^editcmd') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('editcmd') then
									command, level_dostup = text:match('^editcmd (.*) (%d+)')
									if command and level_dostup then 
										if isCommandExists(command) then
											if tonumber(level_dostup) >= 0 and tonumber(level_dostup) <= 4 then
												db_bot:execute("UPDATE `cmdlist` set custom_rank = "..level_dostup.." where command = '"..command.."'")
												vk_request_user(user_id, '&#9999; �� ������� �������� ������� ������� � ������� '..command..'. ������ ��� ������� ������� � ����� '..getStatusNameByLevelDostup(level_dostup)..'.')
												updateArrayCommands()
											else
												UseCommandls('editcmd [�������] [������� ������� (0 � 4)].\n\n&#128081; ������ �������:\n&#128313; 0 � ������������.\n&#128313; 1 � �������������.\n&#128313; 2 � ����������� �������������.\n&#128313; 3 � ������������.\n&#128313; 4 � ����������.\n\n&#9881; ��� ������ ���� ��������� ������ ��� ������� � ������� ����������� ������� >dcmd.')
											end
										else
											vk_request_user(user_id, '&#9940; ��������� ������� �� ����������.')
										end
									else
										UseCommandls('editcmd [�������] [������� ������� (0 � 4)].\n\n&#128081; ������ �������:\n&#128313; 0 � ������������.\n&#128313; 1 � �������������.\n&#128313; 2 � ����������� �������������.\n&#128313; 3 � ������������.\n&#128313; 4 � ����������.\n\n&#9881; ��� ������ ���� ��������� ������ ��� ������� � ������� ����������� ������� >dcmd.')
									end
								else
									NoDostupToCommand()
								end
						elseif text:find('^om') then
							playernick, id_type, bizids = text:match('/om (.*) (%d+) (.*)')
							if tonumber(id_type) == 0 then
								name_type = '���'
								runCommand('/unjail '..playernick..' ������������ �� �������')
								runCommand('/unjailoff '..playernick..' ������������ �� �������')
								runCommand('/sethouseowner '..bizids..' '..bot_name) 
								vk_request_user(user_id, '&#128056; ����� '..playernick..' ������� �� ��������� �� ������� "������������ �� �������".('..name_type..')')
							end
							if tonumber(id_type) == 1 then
								name_type = '������'
								runCommand('/unjail '..playernick..' ������������ �� �������')
								runCommand('/unjailoff '..playernick..' ������������ �� �������')
								runCommand('/setbizowner '..bizids..' '..bot_name) 
								vk_request_user(user_id, '&#128056; ����� '..playernick..' ������� �� ��������� �� ������� "������������ �� �������".('..name_type..')')
							else
								UseCommandls('om [������� ������] (0 - ��� 1 - ������) [id ����/����]')
							end
						elseif text:find('^checkban') then
							playernick = text:match('checkban (.*)')
							if playernick then
								checkban_player = true
								sendInput('/unban '..playernick..' �������� �� ������� ����')
							else
								UseCommandls('checkban [������� ������]')
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
								sendInput('/banoff '..name..' 2000 �� ��������������')
								sendInput('/ban '..name..' 30 �� ��������������')
							else
								UseCommandls('cban [name adm]')
							end
						elseif text:find('^is') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('is') then 
								vk_request_user(user_id, [[&#128190; ������ ����� �������� ��� ��������� ����������:
							
0&#8419; �������
1&#8419; ��������
2&#8419; ���
3&#8419; VIP ������
4&#8419; ����� ��������
5&#8419; ������
6&#8419; ���� � �����
7&#8419; AZ ������
8&#8419; ���� �������
9&#8419; ����� ������ [0-3] 
1&#8419;0&#8419; AZ �����
1&#8419;1&#8419; ADD VIP
1&#8419;2&#8419; ����������� ADD VIP

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
										UseCommandls('astats [������� ��������������]')
									end
								else
									NoDostupToCommand()
								end
						elseif text:find('^tech') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('q') then
									zapros = text:match('^tech (.*)')
									if zapros then
										db_server:execute("INSERT INTO `tech`( `tech`, `userid`) VALUES ('"..zapros.."', "..from_id..")")								
										VkMessage('&#9992; ���� ��������� ����������� ������������� ������� ����������!')
									
									else
										UseCommand('tech ������')
									end
								else
									NoDostupToCommand()
								end
						elseif text:find('^/��') then
								if tonumber(getUserLevelDostup(from_id)) >= getDostupRankForUseCommand('acceptlog') then
									id, otv = text:match('^/�� (%d+) (.*)')
									if id or otv then
										white_l = ''
										cursor, errorString = db_server:execute('select * from cf_users where nickname = '..id..'')
										row = cursor:fetch ({}, "a")
										if tonumber(row.id) == 1 then
											VkMessage('������ ��������� �����������')
										else
											if cursor then
												while row do
													white_l = '�� ��� ��������� ������'..otv
													row = cursor:fetch(row, "a")
												end
											end
											cursor, errorString = db_bot:execute('select * from cf_users where nickname = '..id..'')
											row1 = cursor:fetch ({}, "a")
											if white_l == '' then
												VkMessage('�������� ���')
											else
												VkMessage('�� ������� ��������� ����������� ')
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
											VkMessage('������ ��������� �����������')
										else
											if cursor then
												while row do
													white_l = '��� ������ ����� �� ������ ���������: '..otv
													row = cursor:fetch(row, "a")
												end
											end
											cursor, errorString = db_bot:execute('select * from tech where id = '..id..'')
											row1 = cursor:fetch ({}, "a")
											if white_l == '' then
												VkMessage('�������� �� ���������')
											else
												VkMessage('�� ������� �������� �� ��������� �'..id..'.')
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
												techstat = '�� �������������'
											else
												techstat = '����������'
											end
											white_l = white_l..'\n'..row.id..' | @id'..row.userid..' | '..row.tech..' | '..techstat
											row = cursor:fetch(row, "a")
									end
								end
								if white_l == '' then
									VkMessage('&#10060; �� ������ �� ���������.')
								else
									VkMessage('&#128196; ������ ��������� �'..id..'\nID | �������� | ����� | ������\n\n'..white_l..'.')
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
									VkMessage('&#10060; ��������� ����������.')
								else
									VkMessage('&#128196; �� ������������� ���������:ID | ���������:\n'..white_l..'.')
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
									VkMessage('�����������: rastip (regip) (lastip)')
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
											vk_request_user(user_id, '&#10060; | ���������� �������� �� ����������.')
										end
									else
										UseCommandls('check [�������]')
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
											vk_request_user(user_id, '&#10060; ��������� ����� �� � ����!')
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
										vk_request_user(user_id, '&#10060; ������������, ������� ����� ������ � ���� � ���� �����������.')
									else
										vk_request_user(user_id, '&#128196; ������ �������������, � ������� ������� ������ � ���������� ����� � ����:\n\n'..white_l)
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
											vk_request_user(user_id, '&#9989; �� ������� ������� ������ � ���������� ����� � ���� � ������ '..player_name..'.')
										else
											vk_request_user(user_id, '&#10060; � ������� ������������ � ��� ���� ������� � ���������� ����� � ����.')
										end
									else
										UseCommandls('twl [�������]')
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
		VkMessage('&#128683; ������ ��������� �� ������ 30 ������ ��� ������ 6001 ������!')
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
		house_check_list_ban = '&#128683; �����������.'
	end
	VkMessage('&#127969; ���� ��������������� �������:\n\n'..house_check_list_ban)
	local f = io.open(bot_name..'/Logs/checkhousis_ban.ini', 'w')
	f:write('')
	f:close()
end

function send_bans_businessis()
	local f = io.open(bot_name..'/Logs/checkbusinessis_ban.ini', "r")
	business_check_list_ban = f:read('*a')
	f:close()
	if business_check_list_ban == '' then
		business_check_list_ban = '&#128683; �����������.'
	end
	VkMessage('&#128450; ������� ��������������� �������:\n\n'..business_check_list_ban)
	local f = io.open(bot_name..'/Logs/checkbusinessis_ban.ini', 'w')
	f:write('')
	f:close()
end

function send_admins_stats(arg)
	local f = io.open(bot_name..'/Statistic/'..arg..'adminstatistic.ini', "r")
	report_list = f:read('*a')
	for line in io.lines(bot_name..'/Statistic/'..arg..'adminstatistic.ini') do
		strocks_admins = strocks_admins + 1
		if line:find('������������� ������: (%d+)') then
			number_report = line:match('������������� ������: (%d+)')
			all_admins = all_admins + number_report
		end
	end
	arithm_admonline = tonumber(math.floor((all_admins/strocks_admins)))
	if arg == 'day' then vk_text = '&#128202; ���������� �����. �������, ��������� � 0.00 �������� ���:\n'..report_list..'\n&#128200; ������� �����. ������ ������� ~ '..arithm_admonline
	elseif arg == 'week' then vk_text = '&#128200; ������� �����. ������ ������� ~ '..arithm_admonline
	elseif arg == 'all' then vk_text = '&#128200; ������� �����. ������ ������� ~ '..arithm_admonline
	end
	VkMessage(vk_text)
	f:close()
end

function send_report_stats(arg)
	local f = io.open(bot_name..'/Statistic/'..arg..'reportstatistic.ini', "r")
	report_list = f:read('*a')
	for line in io.lines(bot_name..'/Statistic/'..arg..'reportstatistic.ini') do
		strocks_report = strocks_report + 1
		if line:find('������: (%d+)') then
			number_report = line:match('������: (%d+)')
			all_report = all_report + number_report
		end
	end
	arithm_rep = tonumber(math.floor((all_report/strocks_report)))
	if arg == 'day' then vk_text = '&#128202; ���������� ���������� �������, ��������� � 0.00 �������� ���:\n'..report_list..'\n&#128200; ������� ������ ������� ~ '..arithm_rep
	elseif arg == 'week' then vk_text = '&#128200; ������� ������ ������� ~ '..arithm_rep
	elseif arg == 'all' then vk_text = '&#128200; ������� ������ ������� ~ '..arithm_rep
	end
	VkMessage(vk_text)
	f:close()
end

function send_online_stats(arg)
		local f = io.open(bot_name..'/Statistic/'..arg..'onlinestatistic.ini', "r")
		online_list = f:read('*a')
		for line in io.lines(bot_name..'/Statistic/'..arg..'onlinestatistic.ini') do
			strocks_online = strocks_online + 1
			if line:find('������: (%d+)') then
				number_online = line:match('������: (%d+)')
				all_online = all_online + number_online
			end
		end
		arithm_online = tonumber(math.floor((all_online/strocks_online)))
		if arg == 'day' then vk_text = '&#128202; ���������� ���������� �������, ��������� � 0.00 �������� ���:\n'..online_list..'\n&#128200; ������� ������ ������� ~ '..arithm_online
		elseif arg == 'week' then vk_text = '&#128200; ������� ������ ������� ~ '..arithm_online
		elseif arg == 'all' then vk_text = '&#128200; ������� ������ ������� ~ '..arithm_online
		end
		VkMessage(vk_text)
		f:close()
end

function send_info_report()
	if reports == nil then
		VkMessage('&#8987; ���� ��� ����� �� ����� � ������, ���������� �����!')
	else
		VkMessage('&#128221; ������� �� ������� �� ������ ������: '..reports)
	end
end

function send_info_settings()
	VkMessage(string.format(
	[[	
&#128736; ��������� ����:

&#9654; /interaction [sec] - �������� �� �� �������� ���������� � �������������� � ����� (������: %s���.);
&#9654; /stock [sec] - �������� �� �� �������� ���������� � ������ ���� (������: %s���.);
&#9654; /ques [sec] - �������� �� �� ���������� �������� ����� ������ (������: %s���.);
&#9654; /captcha [sec] - �������� �� �� ���������� ���� (������: %s���.);
&#9654; /skin [sec] - �������� �� �� ���������� �������� ����� ����������� ����� (������: %s���.);
&#9654; /aopra [sec] - �������� ����� ������ �������� � PayDay (������: %s���.);
&#9654; /padmins [sec] - �������� ����� ������� ������ �� ������� (������: %s���.);
&#9654; /pvk [sec] - �������� ����� ������� �� ������ (������: %s���.);
&#9654; /floodrep [sec] - �������� ����� ������� �� ������ (������: %s���.);
 
&#10071; ��� ��������� �� ������ ���� ���������������!
	]]
	, config[2][2], config[7][2], config[4][2], config[3][2], config[6][2], config[8][2], config[1][2], config[5][2]), config[8][2])
end

function send_info_commands()
	VkMessage(
	[[	
&#128221; ������� ����:

&#10071; /settings - ��������� ����;
&#10071; /reports - ���������� ������� �� �������;
&#10071; /online - ������ ������� �� ������ ������;
&#10071; /admins - ������ ������������� ������;
&#10071; /ac [request] - ��������� ������;
&#10071; /multiac [zapros](������ � ����� ������) - ��������� ������������� ������;
&#10071; /startcaptcha - ��������� ����� �� ��������� �������;
&#10071; /startquestion - ��������� ������ �� ��������� LUXE ���������;
&#10071; /startskin - ��������� ����������� ����� �� ��������� ����;
&#10071; /opra - �������� ����������������;
&#10071; /op [nick] - ��������� ������ �� ������� "������������ �������";
&#10071; /om [nick] [0/1(���/������)] [ID ���������] - ��������� ������ �� ������� "������������ �� �������" � ������� ���������;
&#10071; /startmycaptcha [itemid] - ��������� ����� �� ����������� �������;
&#10071; /check [nick] - ���������� ������;
&#10071; /checkreg [nick] - ��������� ���. ������ ������;
&#10071; /rec - ������������� ���� �� ������;
&#10071; /bowner [id] - ������ ��������� �������;
&#10071; /howner [id] - ������ ��������� ����;
&#10071; /players - ������ ������� ������;
&#10071; /onlinestats - ���������� ���������� �������;
&#10071; /reportstats - ���������� ���������� �������;
&#10071; /adminstats - ���������� �����. �������;
&#10071; /fnick [nick] - ����� ��������� ��������;
&#10071; /checkban [nick] - ��������� ������ �� ������� ����;
&#10071; /astats [nick] - ���������� ���������� ���������� ��������������;
&#10071; /leaders - ������ ������� ������;
&#10071; /orgsonline - ������� ������ ���� �����������;
&#10071; /botoff - ��������� ���� (�� �� ������� ��������� ��� �������!);
&#10071; /aslet [0/1(���/������)] [ID ���������] [����� ���������] [0/1(�����������/�� ����������� ������������)] - ��������� ���� ���������;
&#10071; /snick [@user] [name] - ������ ��� ���� ������������;
&#10071; /rnick [@user] - ������� ��� ���� ������������;
&#10071; /addadmin [@user] - ������ ����� �������������� ������;
&#10071; /addspec [@user] - ������ ����� ������������ �������������� ������;
&#10071; /addowner [@user] - ������ ����� ������������ ������;
&#10071; /iwl [@user] - ��������� �������� � ������;
&#10071; /editcmd [cmd] [dostup 1-4] - �������� ���� ������������� �������;
&#10071; /kick [@user] - ��������� ������������ �� ������;
&#10071; /a [Text] - �������� � /a ��� �� ����� ����;
&#10071; /vr [Text] - �������� � /vr ��� �� ����� ����;
&#10071; /makeadmin [name] [lvl] - ������ �������� ������� �� ����� ����;
&#10071; /cban [name] - �������� �������� �� ��������������;
	]]
	)
end

function send_info_admins()
	VkMessage('&#128222; ��������, ������� ���� ����������..')
	requestadmins = true
	set_admin_list = true
	admin_list = ''
	all_admins = 0
	afk_admins = 0
	sendInput('/admins')
	newTask(function() wait(1000)
		admin_list = '&#128190; ������ ������������� ������ [�����: '..convertToSmile(all_admins)..' | AFK: '..convertToSmile(afk_admins)..']:\n\n'..admin_list
		VkMessage(admin_list)
		requestadmins = false 
	end)
end


function send_info_adminsls()
	vk_request_user(user_id, '&#128222; ��������, ������� ���� ����������..')
	requestadmins = true
	set_admin_list = true
	admin_list = ''
	all_admins = 0
	afk_admins = 0
	sendInput('/admins')
	newTask(function() wait(1000)
		admin_list = '&#128190; ������ ������������� ������ [�����: '..convertToSmile(all_admins)..' | AFK: '..convertToSmile(afk_admins)..']:\n\n'..admin_list
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
		VkMessage('&#128101; ������ ������ [�����: '..leadernum..']:\n\n'..leader_list)
	else
		VkMessage('&#128683; �� ������ ������ �� ������� ���� �� ������ ������ ������!')
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
			skin_text = '� �a�a�a� ����o o� '..diapazon_1..' �� '..(diapazon_1+30)..'. ��� ������ ��a���� - ������� ���� �'..skinid..'. ������ � VIP-���!'
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
				sendInput('/ao ���� �� ������ �����: ������� �'..prizeid..'. ���� � ��� ���� ����� � ��������� - �� �� �������� ����!')
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
				vkerr = '������!\n�������: ��� ���������� � VK!'
				return
			end
			local t = json.decode(result)
			if t.error then
				vkerr = '������!\n���: ' .. t.error.error_code .. ' �������: ' .. t.error.error_msg
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
        string_world = '���������������������������������'
    elseif mode == 2 then
        string_world = 'QWERTYUIOPASDFGHJKLZXCVBNM'
    elseif mode == 3 then
        string_world = '���������������������������������QWERTYUIOPASDFGHJKLZXCVBNM'
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
			if dialogTitle:match('���������� � ����������') then
				if checkban_player then
					adminnick, banreason, timetounban = dialogText:match('����������: \t{......}(.*)\n{......}�������: \t{......}(.*)\n{......}�� �������������: \t\t{......}(.*)')
					VkMessage('&#128683; ����� '..playernick..' ������������. ����������:\n\n&#128100; ����������: '..adminnick..'\n&#128196; �������: '..banreason..'\n&#128338; �� �������������: '..timetounban)
					checkban_player = false
					return false
				elseif check_business_ban then
					local f = io.open(bot_name..'/Logs/checkbusinessis.ini', 'a')
					f:write('&#127970; �'..min_biz..' -- &#128683; �������� '..checkbizowner..' ������������.\n')
					f:close()
					local f = io.open(bot_name..'/Logs/checkbusinessis_ban.ini', 'a')
					f:write('&#127970; �'..min_biz..' -- &#128683; �������� '..checkbizowner..' ������������.\n')
					f:close()
					partOfSystemCheckBiz()
				elseif check_house_ban then
					local f = io.open(bot_name..'/Logs/checkhousis.ini', 'a')
					f:write('&#127969; �'..min_house..' -- &#128683; �������� '..checkhouseowner..' ������������.\n')
					f:close()
					local f = io.open(bot_name..'/Logs/checkhousis_ban.ini', 'a')
					f:write('&#127969; �'..min_house..' -- &#128683; �������� '..checkhouseowner..' ������������.\n')
					f:close()
					partOfSystemCheckHouse()
				end
			end
			if dialogId == 15302 and check then
				--if not dialogText:find('%((%d+)%) (.*)\t{......}HEX{......}\t(%d+) ��%.') then
				if not dialogText:find('{9400D3}(%d+)%. {FFFFFF}(.*)\t(.*)SLI{FFFFFF}\t(%d+) ��.') then
					check = false
					updateItems()
					VkMessage('&#128373; ������������ ��������� ��������, ��������� '..convertToSmile(#items)..' '..nForm(#items, '�������', '��������', '���������')..'.')
					cfg.config.update_items = os.time()
					inicfg.save(cfg, bot_name..".ini")
				end
				for line in dialogText:gmatch('[^\n]+') do
					--[[if line:find('%((%d+)%) (.*)\t{......}HEX{......}\t(%d+) ��%.') then
						itemid, itemname, itemcolor = line:match('%((%d+)%) (.*)\t{(.*)}HEX{......}\t(%d+) ��%.')]]
						if line:find('{9400D3}(%d+)%. {FFFFFF}(.*)\t(.*)SLI{FFFFFF}\t(%d+) ��.') then
							itemid, itemname, itemcolor, itemkolvo = line:match('{9400D3}(%d+)%. {FFFFFF}(.*)\t(.*)SLI{FFFFFF}\t(%d+) ��.')
						db_bot:execute("INSERT INTO `items` (`id`, `name`, `color`) VALUES ("..itemid..", '"..itemname.."', '"..itemcolor.."')")
						--print('+')
					end
				end
				sendDialogResponse(15302, 1, 0, '')
			end
			if dialogTitle:find('������� ���������') then 
				if get_check_punishe then 
					vk_request_user(user_id, '&#128196; ������� ��������� ������:\n\n'..dialogText:gsub('{......}', '')); 
					get_check_punishe = false 
				end 
				for line in dialogText:gmatch('[^\n]+') do
					if line:find('[VK] (.*)%[(%d+)%] ������� ������ (.*)%[(%d+)%] � �������� �� (%d+) �����%. �������: (.*)') and find_string and find_opra_word then
						an, aid, pn, pid, jt, return_reason = line:match('[VK] (.*)%[(%d+)%] ������� ������ (.*)%[(%d+)%] � �������� �� (%d+) �����%. �������: (.*)')
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
			if dialogTitle:find('������� ���������') then 
				if get_check_punish then 
					VkMessage('&#128196; ������� ��������� ������:\n\n'..dialogText:gsub('{......}', '')); 
					get_check_punish = false 
				end 
				for line in dialogText:gmatch('[^\n]+') do
					if line:find('[VK] (.*)%[(%d+)%] ������� ������ (.*)%[(%d+)%] � �������� �� (%d+) �����%. �������: (.*)') and find_string and find_opra_word then
						an, aid, pn, pid, jt, return_reason = line:match('[VK] (.*)%[(%d+)%] ������� ������ (.*)%[(%d+)%] � �������� �� (%d+) �����%. �������: (.*)')
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
			if dialogText:find('�����������') and requestorgmembers then
				for line in dialogText:gmatch('[^\n]+') do
					if line:find('{......}(.*){......}(.*) ���%.') then
						orgname, orgonline = line:match('{......}(.*){......}(.*) ���%.')
						local f = io.open(bot_name..'/orgmembers.ini', 'a')
						f:write('&#127970; '..orgname..' - &#128100; '..orgonline..' ���.\n')
						f:close()
					end
				end
			end
			if dialogText:find('{FFFFFF}�������������{FFFFFF}�������{ffffff}���������/��������{FFFFFF}���') then
        		for line in dialogText:gmatch("[^\r\n]+") do
					if line:find('(.*) %[ID: (%d+)%]%[(%d+) lvl%](%d+) %- �������� %[(%d+)/3%]{FFFFFF}(.*){ffffff}') then
						nick, id, lvl, repa, awarns, tag = line:match('(.*) %[ID: (%d+)%]%[(%d+) lvl%](%d+) %- �������� %[(%d+)/3%]{FFFFFF}(.*){ffffff}')
						VkMessage('��� ��������������: '..nick..', ���������: '..repa..', ��������: '..awarns..', ���: '..tag)
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
					sendDialogResponse(4692, 1, -1, '���� ��������� �� ������������� - '..name_type..' '..slet_id)
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
					sendInput('/ao ��������� ������, �������� ��� ��������� �� ������������� ['..name_type..' �'..slet_id..'].')
					sendInput('/ao '..name_opra..'. ��� ��������� �� ����������� ����������� /gotp.')
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
				if dialogText:find('�� ������ ������� ������ �� �������!') then
					VkMessage('&#128683; �� ������ ������� ������ �� �������!')
					find_item = false
					return false
				end
			end
			if dialogTitle:find('{BFBBBA}����� ��������') and find_item then
				for line in dialogText:gmatch('[^\n]+') do
					if line:find('%[(%d+)%] (.*) {FFFFFF}�{FFFFFF}') then
						id_item, name_item = line:match('%[(%d+)%] (.*) {FFFFFF}�{FFFFFF}')
						local f = io.open(bot_name..'/items_find.ini', 'a')
						f:write('&#9654; ['..id_item..'] '..name_item..'\n')
						f:close()
					end
				end
				local f = io.open(bot_name..'/items_find.ini', "r")
				items_list = f:read('*a')
				f:close()
				VkMessage('&#128270; ��������� ������:\n\n'..items_list)
				local f = io.open(bot_name..'/items_find.ini', 'w')
				f:write('')
				f:close()
				find_item = false
				return false
			end
			if dialogText:find('����� ������ ���������') then
				VkMessage('&#128041; ��� ����� ��������� ������������� ����� VK-Guard.')
			end
			if dialogId == 2 then
				sendDialogResponse(2, 1, -1, account_password)
				return false
			end
			if dialogTitle:find('����� ����� ������') then
				sendDialogResponse(dialogId, 1, 0, '')
				return false
			end
			if dialogText:find('������� �����%-������') then
				sendDialogResponse(dialogId, 1, -1, admin_password)
				return false
			end
			if get_status_for_give_whitelist then
				db_bot:execute("INSERT INTO `whitelist` (`gamenick`) VALUES ('"..player_name.."')")
				updateArrayWhiteList()
				VkMessage('&#9999; ������ '..player_name..' ������� ����� ������ � ���������� ����� � ����.')
				get_status_for_give_whitelist = false
			end
			if dialogText:find('ID � ���� ������: (.*)\n���: (.*)\nRegIP: (.*)\nLastIP: (.*)\n�������: (.*)\n������� �����������������: (.*)\n����� ����: (.*)\n����� ���� � ������: (.*)\n������: (.*)\n����� ��������: (.*)\n������ � �����: (.*)\n��������� ������� �����: (.*)\n������ �� ��������: (.*)\n�����������: (.*)\n���������: (.*)\n�����: (.*)\n��������������: (.*)\n������ VIP: (.*)\n\nMuteTime: (.*)\nDemorgan: (.*)\n\n����:') then
				uid, nick, regip, lastip, level, admin_lvl, donate, rub, money, phonenumber, bankmoney, mymoney, depositemoney, org, jobtitle, family, warns, vip, skl, mutetime, demotime = dialogText:match('ID � ���� ������: (.*)\n���: (.*)\nRegIP: (.*)\nLastIP: (.*)\n�������: (.*)\n������� �����������������: (.*)\n����� ����: (.*)\n����� ���� � ������: (.*)\n������: (.*)\n����� ��������: (.*)\n������ � �����: (.*)\n��������� ������� �����: (.*)\n������ �� ��������: (.*)\n�����������: (.*)\n���������: (.*)\n�����: (.*)\n��������������: (.*)\n������ VIP: (.*)\n\nMuteTime: (.*)\nDemorgan: (.*)\n\n����:')
				if check_business_admin then
					if tostring(nick) == tostring(checkbizowner) and check_business_admin and tonumber(admin_lvl) > 0 then
						abusiness_check_list = abusinessbusiness_check_list..'\n&#127970; �'..acheckbizid..' -- &#128101; '..nick..' � '..convertToSmile(admin_lvl)..' ������� �������.'
					end
					partOfSystemACheckBiz()
				end
				if check_house_admin then
					if tostring(nick) == tostring(checkhouseowner) and check_house_admin and tonumber(admin_lvl) > 0 then
						ahouse_check_list = ahouse_check_list..'\n&#127969; �'..acheckhouseid..' -- &#128101; '..nick..' � '..convertToSmile(admin_lvl)..' ������� �������.'
					end
					partOfSystemACheckHouse()
				end
			if get_admin_info then
				if test then
				end
						VkMessage(string.format([[
&#128101; �������������: %s.
&#128190; ������� �������: %d.

&#11088; ���������� �� �� �����:
� �������� ��������: %d.
- ����������� ���������: %d.
� ������ �����: %d.
� ������ ������: %d.
� ������ �-������: %d.
� ������ ����������: %d.
� ������ �����: %d.

&#11088; ���������� �� ������� ������:
� �������� ��������: %d.
- ����������� ���������: %d.
� ������ �����: %d.
� ������ ������: %d.
� ������ �-������: %d.
� ������ ����������: %d.
� ������ �����: %d.									
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
				sendInput('/a '..string.format([[[REG] ������ - %s | ����� - %s | ��������� - %s ]], rdata[1].country, rdata[1].city, rdata[1].isp))
				sendInput('/a '..string.format([[[REG] ��������� ��������: %s | ������ ��� VPN: %s | �������: %s ]], (rdata[1].mobile and '+' or '-'), (rdata[1].proxy and '+' or '-'), (rdata[1].hosting and '+' or '-')))
			elseif type_ip_information == 2 then 
				ip_message = '&#128190; ���������� � ������ ������:\n\n&#128270; '..string.format('[REG] ������ - %s | ������ - %s | ����� - %s | ��������� - %s\n&#128246; [REG] ��������� ��������: %s ������ ��� VPN: %s �������: %s', rdata[1].regionName, rdata[1].country, rdata[1].city, rdata[1].isp, (rdata[1].mobile and '&#9989;' or '&#10060;'), (rdata[1].proxy and '&#9989;' or '&#10060;'), (rdata[1].hosting and '&#9989;' or '&#10060;'))
			elseif type_ip_information == 3 then
			elseif type_ip_information == 4 then
			elseif type_ip_information == 5 then
				player_lastip_info = '['..rdata[2].country..', '..rdata[2].city..'. mobile '..(rdata[2].mobile and '+' or '-')..' | vpn/proxy '..(rdata[2].proxy and '+' or '-')..' | host '..(rdata[2].hosting and '+' or '-')..']'
				player_regip_info = '['..rdata[2].country..', '..rdata[2].city..'. mobile '..(rdata[2].mobile and '+' or '-')..' | vpn/proxy '..(rdata[2].proxy and '+' or '-')..' | host '..(rdata[2].hosting and '+' or '-')..']'
				player_distance = string.format('%d', distance)..'��'
				cursor, errorstring = db_server:execute("select * from `accounts` where `NickName` = '"..infocheck.."'")
				row = cursor:fetch ({}, "a")
				if cursor then
					while row do
						if distance >= 300 then
							vzloman('���� �� �������� , ��� ����')
							sendInput('/banoff 0 '..infocheck..' 2000 �� ���������')
							sendInput('/ban '..infocheck..' 30 �� ��������������')
						end
						VkMessage(string.format([[&#128187; | ������ ������ �� %s:

	&#128190; ���������������� LVL: %d [%d/3].

	&#128246; | ��������������� ������:
	&#128198; ���� �����������: %s.
	&#127757; REG-IP: %s %s.
	&#127757; LAST-IP: %s %s.
	&#127760; ���������� ����� IP: %s.]], aname, row.Admin, row.datareg, row.RegIP, player_regip_info, row.OldIP, player_lastip_info, player_distance))
					end
				end
			end
			if type_ip_information == 1 then
				sendInput('/a '..string.format([[[LAST] ������ - %s | ����� - %s | ��������� - %s]], rdata[2].country, rdata[2].city, rdata[2].isp))
				sendInput('/a '..string.format([[[LAST] ��������� ��������: %s | ������ ��� VPN: %s | �������: %s ]], (rdata[2].mobile and '+' or '-'), (rdata[2].proxy and '+' or '-'), (rdata[2].hosting and '+' or '-')))
				sendInput('/a '..string.format('���������� ����� REG IP � LAST IP ~ %d��', distance))
				if distance >= 300 then
					sendInput('/ban '..checkid..' 30 �� ��������������')
					vzloman1('���� �� �������� , ��� ����')
				end

			elseif type_ip_information == 2 then
				ip_messagee = string.format(ip_message..'\n\n&#128270; [LAST] ������ - %s | ����� - %s | ��������� - %s\n&#128246; [LAST] ��������� ��������: %s ������ ��� VPN: %s �������: %s\n\n&#128204; ���������� ����� REG IP � LAST IP ~%d��', rdata[2].country, rdata[2].city, rdata[2].isp, (rdata[2].mobile and '&#9989;' or '&#10060;'), (rdata[2].proxy and '&#9989;' or '&#10060;'), (rdata[2].hosting and '&#9989;' or '&#10060;'), distance)
				VkMessage(ip_messagee)
			elseif type_ip_information == 3 then
				sendInput('/a '..string.format([[����������� = ���������: %s ������: %s �����: %s]], rdata[2].isp, rdata[2].country, rdata[2].city))
			elseif type_ip_information == 4 then
				player_lastip_info = '['..rdata[2].country..', '..rdata[2].city..'. mobile '..(rdata[2].mobile and '+' or '-')..' | vpn/proxy '..(rdata[2].proxy and '+' or '-')..' | host '..(rdata[2].hosting and '+' or '-')..']'
				player_regip_info = '['..rdata[2].country..', '..rdata[2].city..'. mobile '..(rdata[2].mobile and '+' or '-')..' | vpn/proxy '..(rdata[2].proxy and '+' or '-')..' | host '..(rdata[2].hosting and '+' or '-')..']'
				player_distance = string.format('%d', distance)..'��'
				cursor, errorstring = db_server:execute("select * from `accounts` where `NickName` = '"..infocheck.."'")
				row = cursor:fetch ({}, "a")
				if cursor then
					while row do
						if tonumber(row.Family) == 0 then
							player_family = '�� �������'
						else
							player_family = row.NameFamily..' [UID: '..row.Family..']'
						end
						if tonumber(row.VIP) < 5 then
							player_vip = '�����������'
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
							player_telephone_number = '�����������'
						else
							player_telephone_number = row.TelNum
						end
						if tonumber(row.MuteTime) == 0 then
							player_mute = '�����������'
						else
							player_mute = os.date("%X", row.MuteTime)
						end
						if tonumber(row.JailTime) == 0 then
							player_jail = '�����������'
						else
							player_jail = os.date("%X", row.JailTime)
						end
						if distance >= 300 then
							vzloman('���� �� �������� , ��� ����')
							sendInput('/banoff 0 '..infocheck..' 2000 �� ���������')
							sendInput('/ban '..infocheck..' 30 �� ��������������')
						end
						VkMessage(string.format([[&#128187; | ���������� ���������� �� ������ %s:
	
&#127380; UID: %d.
&#128190; ������� LVL: %d.
&#128190; ���������������� LVL: %d [%d/3].
&#128181; AZ coins: %d.
&#128181; AZ RUB: %d.
&#128176; ������ �� �����: $%d.
&#128176; BTC � �����: %d.
&#128176; BTC �� ��������: %d.
&#9742; ����� ��������: %s.
&#128188; ���� � �����������: %d.	
&#128106; �����: %s.
&#128219; ��������������: [%d/3].
&#128219; ����� ����: %s.
&#128219; ����� ���������: %s.
&#128305; VIP ������: %s.

&#128246; | ��������������� ������:
&#128198; ���� �����������: %s.
&#127757; REG-IP: %s %s.
&#127757; LAST-IP: %s %s.
&#127760; ���������� ����� IP: %s.


&#127963; | ���������:
&#127969; ����: %s.
&#127978; �������: %s.]], infocheck, row.ID, row.Level, row.Admin, row.AWarns, row.VirMoney, row.Roubles, row.Money, row.Bank, row.Deposit, player_telephone_number, row.Rank, player_family, row.Warns, player_mute, player_jail, player_vip, row.datareg, row.RegIP, player_regip_info, row.OldIP, player_lastip_info, player_distance, getPlayerHouses(infocheck), getPlayerBusinessis(infocheck)))
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
		return '�� ���������� ['..tonumber(itemid)..']'
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
	row[1].action.label = '&#128202; ��������'
	
	row2[1] = {}
	row2[1].action = {}
	row2[1].color = 'positive'
	row2[1].action.type = 'text'
	row2[1].action.payload = '{"button": "'..arg..'week_stats"}'
	row2[1].action.label = '&#128202; ���������'
	
	row3[1] = {}
	row3[1].action = {}
	row3[1].color = 'positive'
	row3[1].action.type = 'text'
	row3[1].action.payload = '{"button": "'..arg..'all_stats"}'
	row3[1].action.label = '&#128202; ����������'
	
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
	row[1].action.label = '&#127969; ������� ���� ����������'
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
	row[1].action.label = '&#9989; ��������� ���'
	row[2] = {}
	row[2].action = {}
	row[2].color = 'negative'
	row[2].action.type = 'text'
	row[2].action.payload = '{"button": "no_stop"}'
	row[2].action.label = '&#128683; ��������'
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
	row[1].action.label = '&#127970; ������� ������� ����������'
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
	row[1].action.label = '&#128202; ������ �������'
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
	row[1].action.label = '&#128221; ��� ����������'
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
	row[1].action.label = '&#128221; ���������� �������'
	
	row[2] = {}
	row[2].action = {}
	row[2].color = 'primary'
	row[2].action.type = 'text'
	row[2].action.payload = '{"button": "online"}'
	row[2].action.label = '&#128202; ������ �������'
	
	row_two[1] = {}
	row_two[1].action = {}
	row_two[1].color = 'primary'
	row_two[1].action.type = 'text'
	row_two[1].action.payload = '{"button": "admin_online"}'
	row_two[1].action.label = '&#128101; ������������� ������'
	
	row_two[2] = {}
	row_two[2].action = {}
	row_two[2].color = 'primary'
	row_two[2].action.type = 'text'
	row_two[2].action.payload = '{"button": "leaders_online"}'
	row_two[2].action.label = '&#128101; ������ ������'
	
	row_three[1] = {}
	row_three[1].action = {}
	row_three[1].color = 'primary'
	row_three[1].action.type = 'text'
	row_three[1].action.payload = '{"button": "start_captcha"}'
	row_three[1].action.label = '&#128290; ��������� ��������� ����� �� ����'
	
	row_three[2] = {}
	row_three[2].action = {}
	row_three[2].color = 'primary'
	row_three[2].action.type = 'text'
	row_three[2].action.payload = '{"button": "help"}'
	row_three[2].action.label = '&#128203; ������ �� ��������'
	
	row_four[1] = {}
	row_four[1].action = {}
	row_four[1].color = 'positive'
	row_four[1].action.type = 'text'
	row_four[1].action.payload = '{"button": "check_server_online"}'
	row_four[1].action.label = '&#128202; ���������� ���������� �������'

	row_five[1] = {}
	row_five[1].action = {}
	row_five[1].color = 'secondary'
	row_five[1].action.type = 'text'
	row_five[1].action.payload = '{"button": "gowork"}'
	row_five[1].action.label = '&#127744; ����������� � ������'
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
	row[1].action.label = '&#127744; ���� ����� ����� ������'
	row[2] = {}
	row[2].action = {}
	row[2].color = 'positive'
	row[2].action.type = 'text'
	row[2].action.payload = '{"button": "gorep"}'
	row[2].action.label = '&#10160; ���� �������'
	row_two[1] = {}
	row_two[1].action = {}
	row_two[1].color = 'negative'
	row_two[1].action.type = 'text'
	row_two[1].action.payload = '{"button": "chtot"}'
	row_two[1].action.label = '&#128313; ���� � VK �����'
	row_two[2] = {}
	row_two[2].action = {}
	row_two[2].color = 'negative'
	row_two[2].action.type = 'text'
	row_two[2].action.payload = '{"button": "spam"}'
	row_two[2].action.label = '&#128313; ������� �� ������'
	row_three[1] = {}
	row_three[1].action = {}
	row_three[1].color = 'negative'
	row_three[1].action.type = 'text'
	row_three[1].action.payload = '{"button": "vse"}'
	row_three[1].action.label = '&#11093; ��� ������'
	return json.encode(keyboard)
end

function removeRoleUser(from_id, id)
	if isUserInConference(id) then
		if tonumber(getUserLevelDostup(id)) >= 1 then
			db_bot:execute("UPDATE `cf_users` SET `userdostup` = '0' where `userid` = '"..id.."'")
			VkMessage('&#9989; @id'..from_id..'('..getUserName(from_id)..') ���� ��� ����� ������� � ������������ @id'..id..'('..getUserName(id)..')')
		else
			VkMessage('&#128219; � ������������ @id'..id..'('..getUserName(id)..') ��� ���� �������.')
		end
	else
		VkMessage('&#128219; ��������� ������������ �� ��������� � ������.')
	end
end

function removeWarnUser(from_id, id)
	if isUserInConference(id) then
		if tonumber(getUserWarns(id)) == 0 then
			VkMessage('&#9888; � ������������ @id'..id..'('..getUserName(id)..') ����������� ��������������.')
		else
			db_bot:execute("UPDATE `cf_users` SET `warns` = '"..(getUserWarns(id)-1).."' where `userid` = '"..id.."'") 
			VkMessage('&#9888; @id'..from_id..'('..getUserName(from_id)..') ���� �������������� ������������ @id'..id..'('..getUserName(id)..') ['..getUserWarns(id)..'/3].')
		end
	else
		VkMessage('&#128219; ��������� ������������ �� ��������� � ������.')
	end
end

function removeNickUser(from_id, id)
    if isUserInConference(id) then
        if isUserHaveNickName(id) then
            if tonumber(getUserLevelDostup(id)) >= 3 then   
                if tonumber(getUserLevelDostup(from_id)) >= 3 then
                    db_bot:execute("UPDATE `cf_users` SET `username` = 'NONE' where `userid` = '"..id.."'") 
					VkMessage('[ INFO ] - ������������� [id'..from_id..'|'..getUserName(from_id)..'] ������ ���-���� ������������ [id'..id..'|'..getUserName(id)..']')
                else
                    VkMessage('&#128219; �� �� ������ ������� ���-���� ������������, ������� ���� ��� �� ������.')
                end
            else
                db_bot:execute("UPDATE `cf_users` SET `username` = 'NONE' where `userid` = '"..id.."'") 
                VkMessage('[ INFO ] - ������������� [id'..from_id..'|'..getUserName(from_id)..'] ������ ���-���� ������������ [id'..id..'|'..getUserName(id)..']')
            end
        else
            VkMessage('&#128219; � ������������ @id'..id..'('..getUserName(id)..') �� ���������� ���-����.')
        end
    else
        VkMessage('&#128219; ��������� ������������ �� ��������� � ������.')
    end
end

function removeVigUser(from_id, id)
	if isUserInConference(id) then
		if tonumber(getUserVigs(id)) == 0 then
			VkMessage('&#9888; � ������������ @id'..id..'('..getUserName(id)..') ����������� ��������.')
		else
			db_bot:execute("UPDATE `cf_users` SET `vigs` = '"..(getUserVigs(id)-1).."' where `userid` = '"..id.."'") 
			VkMessage('&#9888; @id'..from_id..'('..getUserName(from_id)..') ���� ������� ������������ @id'..id..'('..getUserName(id)..') ['..getUserVigs(id)..'/3].')
		end
	else
		VkMessage('&#128219; ��������� ������������ �� ��������� � ������.')
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
				VkMessage('&#128219; �� �� ������ ������ ������� ������ ����, ���� ������ ������������ ����� ������ ������.')
			else
				VkMessage('&#128219; �� �� ������ ������ ������� ������������, ������� ���� ��� �� ������.')
			end
		else
			if tonumber(getUserLevelDostup(id)) >= 1 then
				db_bot:execute("UPDATE `cf_users` SET `vigs` = '"..(getUserVigs(id)+1).."' where `userid` = '"..id.."'") 
				if tonumber(getUserVigs(id)) >= 3 then
					VkMessage('&#9888; ������������ @id'..id..'('..getUserName(id)..') ��� ����� ��������� ���� ���� �� ������� [3/3] ���������.')
					db_bot:execute("UPDATE `cf_users` SET `userdostup` = 0 where `userid` = '"..id.."'")
					db_bot:execute("UPDATE `cf_users` SET `vigs` = 0 where `userid` = '"..id.."'")
				else
					VkMessage('&#9888; @id'..from_id..'('..getUserName(from_id)..') ����� ������� ������������ @id'..id..'('..getUserName(id)..') ['..getUserVigs(id)..'/3].')
				end
			else
				VkMessage('&#9888; � ������� ������������ � ��� ���� ������� ����.')
			end
		end
	else
		VkMessage('&#128219; ��������� ������������ �� ��������� � ������.')
	end
end

function giveUserWarn(from_id, id)
	if isUserInConference(id) then
		if tonumber(getUserLevelDostup(id)) >= 5 then	
			if tonumber(getUserLevelDostup(from_id)) >= 5 then
				VkMessage('&#128219; �� �� ������ ������ �������������� ������ ����.')
			else
				VkMessage('&#128219; �� �� ������ ������ �������������� ������������, ������� ���� ��� �� ������.')
			end
		else
			db_bot:execute("UPDATE `cf_users` SET `warns` = '"..(getUserWarns(id)+1).."' where `userid` = '"..id.."'") 
			if tonumber(getUserWarns(id)) >= 3 then
				luaVkApi.removeChatUser((tonumber(chat_id)), tonumber(id))
				VkMessage('&#9888; ������������ @id'..id..'('..getUserName(id)..') ��� �������� �� ���� �� ������� 3/3 ��������������.')
				db_bot:execute("DELETE FROM `cf_users` where `userid` = '"..id.."'")
				sendInput('/makeadmin '..getUserName(id)..' 0')
			else
				VkMessage('&#9888; @id'..from_id..'('..getUserName(from_id)..') ����� �������������� ������������ @id'..id..'('..getUserName(id)..') ['..getUserWarns(id)..'/3].')
			end
		end
	else
		VkMessage('&#128219; ��������� ������������ �� ��������� � ������.')
	end
end

function kickUser(from_id, id)
	if isUserInConference(id) then
		if tonumber(getUserLevelDostup(id)) >= 6 then	
			if tonumber(getUserLevelDostup(from_id)) >= 6 then
				VkMessage('&#128219; �� �� ������ ��������� ������ ����.')
			else
				VkMessage('&#128219; �� �� ������ ��������� ������������, ������� ���� ��� �� ������.')
			end
		else
			VkMessage('&#128683; @id'..from_id..'('..getUserName(from_id)..') �������� ������������ @id'..id..'('..getUserName(id)..'). ��� ����� � ������� ������� �������������.')
			luaVkApi.removeChatUser((tonumber(chat_id)), tonumber(id))
			db_bot:execute("DELETE FROM `cf_users` where `userid` = '"..id.."'")
		end
	else
		VkMessage('&#128219; ��������� ������������ �� ��������� � ������.')
	end
end

function removeUserMute(from_id, id)
	if isUserInConference(id) then
		if isUserHaveMute(id) then
			db_bot:execute("UPDATE `cf_users` SET `mutetime` = '0' where `userid` = '"..id.."'") 
			VkMessage('&#9989; @id'..from_id..'('..getUserName(from_id)..') ���� ���������� ���� ������������ @id'..id..'('..getUserName(id)..').')
		else
			VkMessage('&#9989; � ������������ @id'..id..'('..getUserName(id)..') ����������� ���������� ����.')
		end
	else
		VkMessage('&#128219; ��������� ������������ �� ��������� � ������.')
	end
end

function giveUserMute(from_id, id, mutetime, mutereason)
	if isUserInConference(id) then
		if tonumber(getUserLevelDostup(id)) >= 3 then	
			if tonumber(getUserLevelDostup(from_id)) >= 3 then
				VkMessage('&#128219; �� �� ������ ������ ���������� ���� ������ ����.')
			else
				VkMessage('&#128219; �� �� ������ ������ ���������� ���� ������������, ������� ���� ��� �� ������.')
			end
		else
			if isUserHaveMute(id) then
				VkMessage('&#128566; ������ ������������ ��� �������.')
			else
				if tonumber(mutetime) >= 5 and tonumber(mutetime) <= 2880 then
					db_bot:execute("UPDATE `cf_users` SET `mutetime` = '"..os.time()+(mutetime*60).."' where `userid` = '"..id.."'") 
					VkMessage('&#128566; @id'..from_id..'('..getUserName(from_id)..') ����� ���������� ���� ������������ @id'..id..'('..getUserName(id)..') �� '..tonumber(mutetime)..'���. �� �������: '..mutereason..'.\n&#128198; ���� ��������� ���������� ����: '..unix_decrypt(os.time()+(mutetime*60)))
				else
					VkMessage('&#128219; ����� ���������� ���� ����� ���� �� 5 �� 2880 �����.')
				end
			end
		end
	else
		VkMessage('&#128219; ��������� ������������ �� ��������� � ������.')
	end
end

function callUsersVk(userid, reason)
	call_text = '@all'
	cursor,errorString = db_bot:execute([[select * from cf_users]])
	row = cursor:fetch ({}, "a")
	VkMessageWithPing('&#128483; �� ���� ������� @id'..userid..'(���������������) ������.\n\n'..call_text..'\n\n&#128276; ������� ������: '..reason)
	VkMessage('&#128483; ����� ���������')
end

function callUsers(userid, reason)
	call_text = ''
	cursor,errorString = db_bot:execute([[select * from cf_users]])
	row = cursor:fetch ({}, "a")
	while row do
		call_text = call_text..string.format("@id%d (&#128100;)", row.userid)
		row = cursor:fetch(row, "a")
	end
	VkMessage('&#128483; �� ���� ������� @id'..userid..'(���������������) ������.\n\n'..call_text..'\n\n&#128276; ������� ������: '..reason)
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
			help_text = help_text..'\n&#128313; '..custom_all_bot_commands[i][1]..' � '..custom_all_bot_commands[i][2]..'.'
		end
		if tonumber(getUserLevelDostup(userid)) > 0 and tonumber(custom_all_bot_commands[i][3]) == 1 then
			help_text = help_text..'\n&#128313; '..custom_all_bot_commands[i][1]..' � '..custom_all_bot_commands[i][2]..'.'
		elseif tonumber(getUserLevelDostup(userid)) > 1 and tonumber(custom_all_bot_commands[i][3]) == 2 then
			help_text = help_text..'\n&#128313; '..custom_all_bot_commands[i][1]..' � '..custom_all_bot_commands[i][2]..'.'
		elseif tonumber(getUserLevelDostup(userid)) > 2 and tonumber(custom_all_bot_commands[i][3]) == 3 then
			help_text = help_text..'\n&#128313; '..custom_all_bot_commands[i][1]..' � '..custom_all_bot_commands[i][2]..'.'
		elseif tonumber(getUserLevelDostup(userid)) > 3 and tonumber(custom_all_bot_commands[i][3]) == 4 then
			help_text = help_text..'\n&#128313; '..custom_all_bot_commands[i][1]..' � '..custom_all_bot_commands[i][2]..'.'
		end
	end
	help_text = '&#128221; | ������ ��������� ��� ������:\n\n'..help_text
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
	return hours..'�. '..minutes..'���. '..seconds..'���.'
end

function chtot()
	for i = 1, 5 do
		VkMessageFlood('@all �������� �����/����� ������ 10 ���.�� ������ ��� ���� � ��,���,��������!')
	end
	VkMessage('&#128315; ��� ��������� � ����� ���(vk) ����� �������� � ����.')
end

function spam()
	for i = 1, 25 do
		VkMessageFlood('@all ����� �� ������')
	end
	VkMessage('&#128315; ��� ��������� � ����� ���(vk) ����� �������� � ����.')
end

function chtog()
	sendInput('chtg')
	VkMessage('&#128315; ��� ��������� � ����� ���(vk) ����� �������� � ����.')
end

function gowork1()
	for i = 1, 20 do
		sendInput('/a �������� �����/����� ������ 10 ���.�� ������ ��� ���� � ��,���,��������!')
	end
		VkMessage('&#128311; ��� �������� ������� � ���������� ������/������')
end

function gorep()
	for i = 1, 20 do
		sendInput('/a REPORT REPORT REPORT REPORT - /OT /OT /OT /OT - REPORT REPORT REPORT REPORT')
	end
	VkMessage('&#128311; ��� �������� ������� � �������')
end

function vse()
	newTask(function()
		VkMessage('&#128312; ��� ��������� ��� ������')
	for i = 1, 5 do
		VkMessageFlood('@all �������� �����/����� ������ 10 ���.�� ������ ��� ���� � ��,���,��������!')
		sendInput('/a �������� �����/����� ������ 10 ���.�� ������ ��� ���� � ��,���,��������!')
		sendInput('/a REPORT REPORT REPORT REPORT - /OT /OT /OT /OT - REPORT REPORT REPORT REPORT')
	end
end)
end

function gowork()
	vkvkvk_vk('�������� ������ �����')
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
    row[1].action.label = '&#128154; �������� ������'
	row[2] = {}
    row[2].action = {}
    row[2].color = 'negative'
    row[2].action.type = 'text'
    row[2].action.payload = '{"button": "noaccept"}'
    row[2].action.label = '&#129505; ��������'
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
    row[1].action.label = '&#128154; �������'
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
    row[1].action.label = '&#128154; ������'
	row[2] = {}
	row[2].action = {}
    row[2].color = 'negative'
    row[2].action.type = 'text'
    row[2].action.payload = '{"button": "no"}'
    row[2].action.label = '&#129505; ��������'
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
    row[1].action.label = '&#9989; ���������'
	row[2] = {}
	row[2].action = {}
    row[2].color = 'negative'
    row[2].action.type = 'text'
    row[2].action.payload = '{"button": "nounban1"}'
    row[2].action.label = '&#129505; �������� � ����'
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
    row[1].action.label = '&#9989; ���������'
	row[2] = {}
	row[2].action = {}
    row[2].color = 'negative'
    row[2].action.type = 'text'
    row[2].action.payload = '{"button": "nounban"}'
    row[2].action.label = '&#129505; �������� � ����'
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
    row[1].action.label = '&#128154; ��������'
	row[2] = {}
    row[2].action = {}
    row[2].color = 'negative'
    row[2].action.type = 'text'
    row[2].action.payload = '{"button": "nosliv"}'
    row[2].action.label = '&#129505; ������'
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
		color_name = '��������'
	elseif color == 'CC2426' then
		color_name = '�������'
	elseif color == 'CC7824' then
		color_name = '�������'
	elseif color == 'E6BC1E' then
		color_name = '������-�����'
	elseif color == 'D5D73C' then
		color_name = 'Ƹ����'
	elseif color == '3CD740' then
		color_name = '������'
	elseif color == '3CD7D7' then
		color_name = '�������'
	elseif color == '3C3ED7' then
		color_name = '�����'
	elseif color == 'D73CD4' then
		color_name = '����������'
	elseif color == 'D73C7E' then
		color_name = '�������'
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
			VkMessage('[ INFO ] - ������������� [id'..from_id..'|'..getUserName(from_id)..'] ���� ��� ������������ [id'..id..'|'..getUserName(id)..']')
		else
			VkMessage('&#9989; � ������������ @id'..id..'('..getUserName(id)..') ����������� ���������� ����.')
		end
	else
		VkMessage('&#128219; ��������� ������������ �� ��������� � ������.')
	end
end

function giveUserMute(from_id, id, mutetime, mutereason)
	if isUserInConference(id) then
		if tonumber(getUserLevelDostup(id)) >= 3 then	
			if tonumber(getUserLevelDostup(from_id)) >= 3 then
				VkMessage('&#128219; �� �� ������ ������ ���������� ���� ������ ����.')
			else
				VkMessage('&#128219; �� �� ������ ������ ���������� ���� ������������, ������� ���� ��� �� ������.')
			end
		else
			if isUserHaveMute(id) then
				VkMessage('&#128566; ������ ������������ ��� �������.')
			else
				if tonumber(mutetime) >= 5 and tonumber(mutetime) <= 2880 then
					db_bot:execute("UPDATE `cf_users` SET `mutetime` = '"..os.time()+(mutetime*60).."' where `userid` = '"..id.."'")
					VkMessage('[ INFO ] - ������������� [id'..from_id..'|'..getUserName(from_id)..'] ����� ��� ������������ [id'..id..'|'..getUserName(id)..'] �� '..tonumber(mutetime)..'���. �������: '..mutereason..'\n���� ��������� ���������� ����: '..unix_decrypt(os.time()+(mutetime*60)))
				else
					VkMessage('&#128219; ����� ���������� ���� ����� ���� �� 5 �� 2880 �����.')
				end
			end
		end
	else
		VkMessage('&#128219; ��������� ������������ �� ��������� � ������.')
	end
end

function setUserName(from_id, id, nickname)
	if isUserInConference(id) then
		if tonumber(getUserLevelDostup(id)) >= 3 then	
			if tonumber(getUserLevelDostup(from_id)) >= 3 then
				VkMessage('[ INFO ] - ������������ [id'..id..'|'..getUserName(id)..'] �������� � ������ � ����� '..nickname)
				db_bot:execute("UPDATE `cf_users` SET `username` = '"..nickname.."' where `userid` = '"..id.."'") 
			else
				VkMessage('&#128219; �� �� ������ �������� ������� ������������, ������� ���� ��� �� ������.')
			end
		else
			if isUserHaveNickName(id) then
				VkMessage('&#128219; � ������� ������������ ��� ���������� �������.')
			else
				VkMessage('[ INFO ] - ������������ [id'..id..'|'..getUserName(id)..'] �������� � ������ � ����� '..nickname)
				db_bot:execute("UPDATE `cf_users` SET `username` = '"..nickname.."' where `userid` = '"..id.."'")
				db_bot:execute("INSERT INTO `logs1`( `Text`, `IDUser`) VALUES ('������������� @id"..id.."("..getUserName(from_id)..") ��������� ���-���� @id"..id.."("..getUserName(id)..")', '"..from_id.."')")
			end
		end
	else
		VkMessage('&#128219; ��������� ������������ �� ��������� � ������.')
	end
end

function setNickName(from_id, id, nickname, user_id)
		if tonumber(getUserLevelDostup(id)) >= 3 then	
			if tonumber(getUserLevelDostup(from_id)) >= 3 then
				vk_request_user(user_id, '[ INFO ] - ������������ [id'..id..'|'..getUserName(id)..'] ���������� ��� '..nickname)
				db_bot:execute("UPDATE `cf_users` SET `nickname` = '"..nickname.."' where `userid` = '"..id.."'") 
			else
				vk_request_user(user_id, '&#128219; �� �� ������ �������� ������� ������������, ������� ���� ��� �� ������.')
			end
		else
			if isUserHaveNickName(id) then
				vk_request_user(user_id, '&#128219; � ������� ������������ ��� ���������� �������.')
			else
				vk_request_user(user_id, '[ INFO ] - ������������ [id'..id..'|'..getUserName(id)..'] ���������� ��� '..nickname)
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
			VkMessage('&#128219; ������������ @id'..id..'('..getUserName(id)..') ��� ����� ������ �������������� ��� ����.')
		else
			if tonumber(days) >= 1 and tonumber(days) <= 9999 then
				db_bot:execute("UPDATE `cf_users` SET `userdostup` = '1' where `userid` = '"..id.."'")
				db_bot:execute("UPDATE `cf_users` SET `roletime` = "..(os.time()+(days*86400)).." where `userid` = '"..id.."'")
				VkMessage('&#128142; @id'..from_id..'('..getUserName(from_id)..') ����� ������������ @id'..id..'('..getUserName(id)..') ����� ��������������.')
			else
				VkMessage('&#128219; ���� �������� ���� � ���� ����� ���� �� 1 �� 9999.')
			end
		end
	else
		VkMessage('&#128219; ��������� ������������ �� ��������� � ������.')
	end
end

function giveUserOsnovatel(from_id, id, days)
	if isUserInConference(id) then
		if tonumber(getUserLevelDostup(id)) >= 4 then
			VkMessage('&#128219; ������������ @id'..id..'('..getUserName(id)..') ��� ����� ������ ��������� ������ ��� ����.')
		else
			if tonumber(days) >= 1 and tonumber(days) <= 9999 then
				db_bot:execute("UPDATE `cf_users` SET `userdostup` = '4' where `userid` = '"..id.."'")
				db_bot:execute("UPDATE `cf_users` SET `roletime` = "..(os.time()+(days*86400)).." where `userid` = '"..id.."'")
				VkMessage('&#128142; @id'..from_id..'('..getUserName(from_id)..') ����� ������������ @id'..id..'('..getUserName(id)..') ����� ��������� ������.')
			else
				VkMessage('&#128219; ���� �������� ���� � ���� ����� ���� �� 1 �� 9999.')
			end
		end
	else
		VkMessage('&#128219; ��������� ������������ �� ��������� � ������.')
	end
end

function giveUserSpecialAdmin(from_id, id, days)
	if isUserInConference(id) then
		if tonumber(getUserLevelDostup(id)) >= 2 then
			VkMessage('&#128219; ������������ @id'..id..'('..getUserName(id)..') ��� ����� ������ ������������ ��������������.')
		else
			if tonumber(days) >= 1 and tonumber(days) <= 9999 then
				db_bot:execute("UPDATE `cf_users` SET `userdostup` = '2' where `userid` = '"..id.."'")
				db_bot:execute("UPDATE `cf_users` SET `roletime` = "..(os.time()+(days*86400)).." where `userid` = '"..id.."'")
				VkMessage('&#128305; @id'..from_id..'('..getUserName(from_id)..') ����� ������������ @id'..id..'('..getUserName(id)..') ����� ������������ ��������������.')
				db_bot:execute("INSERT INTO `logs1`( `Text`, `IDUser`) VALUES ('������������� "..getUserName(from_id).." ����� "..getUserName(id).." ����� ���� ��������������', '"..from_id.."')")
			else
				VkMessage('&#128219; ���� �������� ���� � ���� ����� ���� �� 1 �� 9999.')
			end
		end
	else
		VkMessage('&#128219; ��������� ������������ �� ��������� � ������.')
	end
end


function giveUserOwner(from_id, id, days)
	if isUserInConference(id) then
		if tonumber(getUserLevelDostup(id)) >= 3 then
			VkMessage('&#128219; ������������ @id'..id..'('..getUserName(id)..') ��� ����� ������ ������������.')
		else
		if tonumber(days) >= 1 and tonumber(days) <= 9999 then
			db_bot:execute("UPDATE `cf_users` SET `userdostup` = '3' where `userid` = '"..id.."'")
			db_bot:execute("UPDATE `cf_users` SET `roletime` = "..(os.time()+(days*86400)).." where `userid` = '"..id.."'")
			VkMessage('&#128305; @id'..from_id..'('..getUserName(from_id)..') ����� ������������ @id'..id..'('..getUserName(id)..') ����� ������������.')
			db_bot:execute("INSERT INTO `logs1`( `Text`, `IDUser`) VALUES ('������������� "..getUserName(from_id).." ����� "..getUserName(id).." ����� ������������', '"..from_id.."')")
		else
				VkMessage('&#128219; ���� �������� ���� � ���� ����� ���� �� 1 �� 9999.')
			end
		end
	else
		VkMessage('&#128219; ��������� ������������ �� ��������� � ������.')
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
			VkMessage("&#127800; ������� ������ �������: "..(server_online+1).." �������.")
		requestonline = false
	end)
end

newTask(function()
    while true do
		wait(tonumber(config[7][2])*1000)
		if isConnected() then
			sendInput('/a -> ����� �������� �������� ����������� "/a ��� ���o����"')
			sendInput('/a -> ����� �������� ���������� ������, ������� ������ ������ ����������� "/a ��� �a�� ���"')
			sendInput('/a -> ����� �������� ���������� ������, ������� ������ ��� ����������� "/a ��� �a�� �o�"')
			sendInput('/a -> ����� ������ ������ � �������������� ������ � ���������� ����������� "/a /getip ID"')
			VkMessage('&#127757; ���������� � ������ ���� ���������� [������������ ��� � '..tonumber(config[7][2])..' ������].')
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
				userstatusname = '������������'
			elseif tonumber(userstatus) == 1 then 
				userstatusname = '������������� [�� '..os.date("%X %d.%m.%Y", roletime)..']'
			elseif tonumber(userstatus) == 2 then 
				userstatusname = '����������� ������������� [�� '..os.date("%X %d.%m.%Y", roletime)..']'
			elseif tonumber(userstatus) == 3 then 
				userstatusname = '����������'
			elseif tonumber(userstatus) == 4 then 
				userstatusname = '��������'
			end
			if tonumber(usermute) > 0 then
				usermutename = '����'
			else
				usermutename = '�����������'
			end
			if tostring(username) == 'NONE' then username = '�����������' end
			VkMessage('&#128190; ���������� � @id'..id..'('..getUserName(id)..'):\n\n&#128313; ������: '..userstatusname..'.\n&#128313; ��������������: ['..userwarns..'/3].\n&#128313; ���������: ['..uservigs..'/3].\n&#128313; ���������� ����: '..usermutename..'.\n&#128313; �������: '..username..'.\n&#128313; �������� ���������: '..usermessages..'.\n&#128313; ��������� ���������: '..unix_decrypt(lastmsg))
	else
		VkMessage('&#128219; ��������� ������������ �� ��������� � ������.')
	end
end

function giveUserBan(from_id, id, bantime, banreason)
	if tonumber(id) > 0 then
		if isUserInConference(id) then
			if tonumber(getUserLevelDostup(id)) >= 3 then	
				if tonumber(getUserLevelDostup(from_id)) >= 3 then
					VkMessage('&#128219; �� �� ������ ������������� ������ ����.')
				else
					VkMessage('&#128219; �� �� ������ ������������� ������������, ������� ���� ��� �� ������.')
				end
			else
				if tonumber(bantime) <= 666 then
					db_bot:execute("INSERT INTO `ban_list` (`banuserid`, `banadminid`, `bantime`, `banreason`) VALUES ('"..id.."', '"..from_id.."', '"..os.time()+(bantime*86400).."', '"..banreason.."')")
					VkMessage('&#9940; @id'..from_id..'('..getUserName(from_id)..') ������������ ������������ @id'..id..'('..getUserName(id)..') �� '..bantime..'��.\n&#128203; ������� ����������: '..banreason..'\n&#128198; ���� ������������� ������������: '..unix_decrypt(os.time()+(bantime*86400)))
					luaVkApi.removeChatUser((tonumber(chat_id)), tonumber(id))
					db_bot:execute("DELETE FROM `cf_users` where `userid` = '"..id.."'")
				else
					VkMessage('&#128219; ������������ ���� ���������� - 666 ����.')
				end
			end
		else
			if tonumber(bantime) <= 666 then
				db_bot:execute("INSERT INTO `ban_list` (`banuserid`, `banadminid`, `bantime`, `banreason`) VALUES ('"..id.."', '"..from_id.."', '"..os.time()+(bantime*86400).."', '"..banreason.."')")
				luaVkApi.removeChatUser((tonumber(chat_id)), tonumber(id))
				VkMessage('&#9940; @id'..from_id..'('..getUserName(from_id)..') ������������ ������������ @id'..id..'('..getUserName(id)..') �� '..bantime..'��.\n&#128203; ������� ����������: '..banreason..'\n&#128198; ���� ������������� ������������: '..unix_decrypt(os.time()+(bantime*86400)))
				db_bot:execute("DELETE FROM `cf_users` where `userid` = '"..id.."'")
			else
				VkMessage('&#128219; ������������ ���� ���������� - 666 ����.')
			end
		end
	else
		VkMessage('&#128219; ������ �������� ID ������������.')
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
				player_businessis = '�'..player_bizs[i]
			elseif player_businessis ~= '' and tonumber(player_bizs[i-1]) < tonumber(player_bizs[i]) then
				player_businessis = player_businessis..', �'..player_bizs[i]
			end
		end
	else
		player_businessis = '�����������'
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
					VkMessage('&#128686; � ������������ @id'..row.userid..'('..getUserName(row.userid)..') ������������ ����� �� ��������� ����� �� ��������.')
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
		text = '������������'
	elseif tonumber(leveldostup) == 5 then
		text = '��������'
	elseif tonumber(leveldostup) == 6 then
		text = '�����������'
	elseif tonumber(leveldostup) == 8 then
		text = '���. ���������'
	elseif tonumber(leveldostup) == 9 then
		text = '���������'
	elseif tonumber(leveldostup) == 10 then
		text = '���. ���������'
	elseif tonumber(leveldostup) == 11 then
		text = '����������'
	elseif tonumber(leveldostup) == 12 then
		text = '���. ����������'
	elseif tonumber(leveldostup) == 13 then
		text = '������������'
	elseif tonumber(leveldostup) == 14 then
		text = '���. ������������'
	elseif tonumber(leveldostup) == 15 then
		text = '����. �������������'
	elseif tonumber(leveldostup) == 16 then
		text = '������� ���'
	elseif tonumber(leveldostup) == 17 then
		text = '���. ��. ����'
	elseif tonumber(leveldostup) == 18 then
		text = '��'
	elseif tonumber(leveldostup) == 19 then
		text = '���'
	elseif tonumber(leveldostup) == 20 then
		text = '������� ���'
	elseif tonumber(leveldostup) == 21 then
		text = '������� ���'
	elseif tonumber(leveldostup) == 22 then
		text = '������� ���'
	elseif tonumber(leveldostup) == 23 then
		text = '������� ���'
	elseif tonumber(leveldostup) == 24 then
		text = '���� ��������'
	elseif tonumber(leveldostup) == 25 then
		text = '���. ���� ���������'
	else
		text = '�� ���������'
	end
	return text
end

function getStatusNameByLevelDostup(leveldostup)
	if tonumber(leveldostup) == 0 then
		text = '������������'
	elseif tonumber(leveldostup) == 1 then
		text = '�������������'
	elseif tonumber(leveldostup) == 2 then
		text = '����. �������������'
	elseif tonumber(leveldostup) == 3 then
		text = '������������'
	elseif tonumber(leveldostup) == 4 then
		text = '����������'
	else
		text = '�� ��������'
	end
	return text
end

function updateArrayCommands()
	custom_all_bot_commands = { 
		{'q', '����� �� ������', getDostupRankForUseCommand('q'), 0},
		{'snick', '���������� ���-���� � ������', getDostupRankForUseCommand('snick'), 1},
		{'rnick', '������� ���-���� � ������', getDostupRankForUseCommand('rnick'), 1},
		{'nlist', '������� ������ ����� ������', getDostupRankForUseCommand('nlist'), 1},
		{'ac', '��������� �������� �� ���� ����', getDostupRankForUseCommand('ac'), 1},
		{'zov', '������� ���� ������ ������', getDostupRankForUseCommand('zov'), 1},
		{'stats', '���������� ���������� ��������� ������', getDostupRankForUseCommand('stats'), 1},
		{'online', '���������� ������ �������', getDostupRankForUseCommand('online'), 1},
		{'help', '���������� ��������� �������', getDostupRankForUseCommand('help'), 1},
		{'question', '��������� ��������� ������', getDostupRankForUseCommand('question'), 1},
		{'captcha', '��������� ����� �� ����', getDostupRankForUseCommand('captcha'), 1},
		{'admins', '���������� ������ ������������� � ����', getDostupRankForUseCommand('admins'), 1},
		{'reports', '���������� ���������� ������� �� �������', getDostupRankForUseCommand('reports'), 1},
		{'removerole', '������� ���� � ������', getDostupRankForUseCommand('removerole'), 2},
		{'mtop', '���������� ��� �� ����������', getDostupRankForUseCommand('mtop'), 2},
		{'addadmin', '������ ����� �������������� ������', getDostupRankForUseCommand('addadmin'), 2},
		{'kick', '��������� ������������ �� ������', getDostupRankForUseCommand('kick'), 2},
		{'astats [name adm]', '���������� ���������� ��������������', getDostupRankForUseCommand('astats'), 2},
		{'check [name]', '���������� ���������� ������', getDostupRankForUseCommand('check'), 2},
		{'checkinv [name]', '���������� ��������� ������', getDostupRankForUseCommand('checkinv'), 2},
		{'addspec', '������ ����� ������������ �������������� ������', getDostupRankForUseCommand('addspec'), 3},
		{'iwl', '��������� �������� � ������', getDostupRankForUseCommand('iwl'), 3},
		{'mute', '������ ������� � ������', getDostupRankForUseCommand('mute'), 3},
		{'unmute', '����� ������� � ������', getDostupRankForUseCommand('unmute'), 3},
		{'greetings [text]', '���������� ����������� ��� ���������� ������������ � ������', getDostupRankForUseCommand('greetings'), 3},
		{'rkick', '�� ��� ���', getDostupRankForUseCommand('rkick'), 4},
		{'addowner', '������ ������� � ������', getDostupRankForUseCommand('addowner'), 4},
		{'editcmd [cmd] [lvl 1-4]', '������� ������ � �������', getDostupRankForUseCommand('editcmd'), 4},
		{'dlist', '������ ��������������� ������� ����� � ���� � ����', getDostupRankForUseCommand('dlist'), 1},
		{'twl', '������� ����� � ���� � ����', getDostupRankForUseCommand('twl'), 3},
		{'al', '������ ����� � ���� � ����', getDostupRankForUseCommand('gwl'), 3},
		{'staff', '���������� ���� ����������', getDostupRankForUseCommand('staff'), 1},
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
		return minutes..'���.'
	else
		return minutes..'���. '..seconds..'���.'
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
		text = '&#10060; ��������� ��������� ����.'
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
				player_houses = '�'..player_housz[i]
			elseif player_houses ~= '' and tonumber(player_housz[i-1]) < tonumber(player_housz[i]) then
				player_houses = player_houses..', �'..player_housz[i]
			end
		end
	else
		player_houses = '�����������'
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
			sendInput('/ao ����� ����? ������: /vr "��������", "����"')
			sendInput('/ao ����� ��������? ������: /vr "����� �����", "����� ��������"')
			sendInput('/ao ����� NRG? ������: /vr "����� ���", "����� ��������"')
			sendInput('/ao ����� ������������? ������: /vr "����������", "�����"')
			sendInput('/ao ����� �� ��? ������: /vr "��� �� ��", "��� �� �� ��"')
			sendInput('/ao ����� �� ��? ������: /vr "��� �� ��", "��� �� �� ��"')
			sendInput('/ao ����� �� ��? ������: /vr "��� �� ��", "��� �� �� ��"')
			sendInput('/ao ����� � �����? ������: /vr "��� �� � �����", "�� � �����"')
			sendInput('/ao ����� �������? ������: /vr "����� �������", "����� �������"')
			VkMessage('&#127757; ���������� � �������������� � ����� ���������� [������������ ��� � '..tonumber(config[3][2])..' ������].')
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
			sendInput('/ao -> ������� ������� ����� , �� ������ ������� ������ �� ���� �������������� 1-�� ������.')
			wait(500)
			sendInput('/ao -> ����� ������� �� ���� �������������� , ��� �����������: ')
			sendInput('/ao -> 1. ������� 14 � ����� ���.')
			sendInput('/ao -> 2. ����� ������� �������.')
			sendInput('/ao -> 3. ����� ������� ������� �� ������ 15.')
			sendInput('/ao -> 4. �� ���� ����������� ������� �� �������.')
			sendInput('/ao -> ��� ����� - '..forum_link)
			VkMessage('	&#128483; ������� ������ �� ������ ����������. ������������ ��� � '..tonumber(config[1][2])..' sec.')
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
			VkMessage('	&#128483; ���������� � ������ ��� ������� ������� ����������. ������������ ��� � '..tonumber(config[8][2])..' sec.')
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
			sendInput('/ao ��������� ������, ������ ������ ���� � ����� ������� ������������ �� ������� � �� ��� ���������?')
			wait(500)
			sendInput('/ao ��� ������ ������ � ��� ���� ���� ������ VK - '..vk_group_link..', ��������� ������� ����� ������!')
			wait(500)
			VkMessage('	&#128483; ������� ������ �� ����������. ������������ ��� � '..tonumber(config[5][2])..' sec.')
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