/*
 *
 *
 *			Nogov Admin Module
 *		  	2013/01/07
 *
 *
 *		Copyright (c) sBum. All rights reserved.
 *
 *
 */
/*

  < Callbacks >
	pCommandTextHandler_Admin(playerid, cmdtext[])
	OnPlayerAdminCommandText(playerid, cmdtext[])
	dResponseHandler_Admin(playerid, dialogid, response, listitem, inputtext[])
	mplResponseHandler_Admin(playerid, mplistid, selecteditem)

  < Functions >
	SendAdminMessage(color, message[], level=1)
	ShowAttachedObjectList(playerid, destid, dialogid)
	ShowAttachedObjectModifier(playerid, destid, index, dialogid, dialogstyle)
	AdminLog(playerid, result[])
	AgentLog(playerid, result[])

*/



//-----< Defines
#define DialogId_Admin(%0)			(50+%0)
#define MpListId_Admin(%0)			(25+%0)



//-----< Variables
new Float:Mark[MAX_PLAYERS][4],
	MarkInterior[MAX_PLAYERS],
	MarkVirtualWorld[MAX_PLAYERS];



//-----< Callbacks
forward pCommandTextHandler_Admin(playerid, cmdtext[]);
forward OnPlayerAdminCommandText(playerid, cmdtext[]);
forward dResponseHandler_Admin(playerid, dialogid, response, listitem, inputtext[]);
forward mplResponseHandler_Admin(playerid, mplistid, selecteditem);
//-----< pCommandTextHandler >--------------------------------------------------
public pCommandTextHandler_Admin(playerid, cmdtext[])
{
	if (CallLocalFunction("OnPlayerAdminCommandText", "ds", playerid, FixBlankString(cmdtext)))
	{
		new str[256];
		format(str, sizeof(str), "명령어 사용: %s", cmdtext);
		if (GetPVarInt(playerid, "pAgent"))
			AgentLog(playerid, str);
		AdminLog(playerid, str);
		return 1;
	}
	return 0;
}
//-----< OnPlayerAdminCommandText >---------------------------------------------
public OnPlayerAdminCommandText(playerid, cmdtext[])
{
	new cmd[256],
		idx,
		destid,
		str[256];
	cmd = strtok(cmdtext, idx);

	if (!GetPVarInt(playerid, "pAgent")) return 0;
	else if (!strcmp(cmd, "/에이전트", true) || !strcmp(cmd, "/agent", true))
	{
		if (GetPVarInt(playerid, "pAgentMode"))
		{
			DeletePVar(playerid, "pAgentMode");
			UnloadPlayerItemData(playerid);
			LoadPlayerItemData(playerid);
			SendClientMessage(playerid, COLOR_YELLOW, "에이전트 모드를 종료했습니다.");
			AgentLog(playerid, "에이전트 모드를 종료했습니다.");
			return 1;
		}
		SetPVarInt(playerid, "pAgentMode", true);
		LoadPlayerItemData(playerid);
		for (new i = 0, t = GetMaxPlayerItems(); i < t; i++)
			if (IsValidPlayerItemID(playerid, i))
				DestroyPlayerItem(playerid, i);
		SendClientMessage(playerid, COLOR_YELLOW, "에이전트 모드를 시작합니다.");
		AgentLog(playerid, "에이전트 모드를 시작합니다.");
		return 1;
	}

	if (GetPVarInt(playerid, "pAdmin") < 1
	&& !IsGrantedCommand(playerid, cmd)) return 0;
	else if (!strcmp(cmd, "/관리자도움말", true) || !strcmp(cmd, "/adminhelp", true) || !strcmp(cmd, "/ah", true))
	{
		new help[2048];
		strcat(help, ""C_PASTEL_YELLOW"- 유저 -"C_WHITE"\n\
		/체력, /아머, /정보수정, /정보검사, /인테리어, /버추얼월드, /스킨, /리스폰, /얼림, /녹임\n\
		/무기, /명령어권한부여, /명령어권한회수\n\
		\n");
		strcat(help, ""C_PASTEL_YELLOW"- 행동 -"C_WHITE"\n\
		/날기, /클로킹\n\
		\n");
		strcat(help, ""C_PASTEL_YELLOW"- 이동 -"C_WHITE"\n\
		/출두, /소환, /마크, /마크로, /텔레포트, /로산, /샌피, /라벤\n\
		\n");
		strcat(help, ""C_PASTEL_YELLOW"- 서버 -"C_WHITE"\n\
		/건물생성, /건물설정, /아이템생성, /아이템제거\n\
		\n");
		strcat(help, ""C_PASTEL_YELLOW"- 디버그 -"C_WHITE"\n\
		/부착오브젝트, /음악, /카메라정보, /가속도, /애님인덱스, /스페셜액션, /텍스트드로우, /오브젝트선택\n\
		\n");
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "관리자 도움말", help, "닫기", "");
		return 1;
	}
	//
	// 유저
	//
	else if (!strcmp(cmd, "/체력", true))
	{
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /체력 [플레이어] [양]");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "존재하지 않는 플레이어입니다.");
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /체력 [플레이어] [양]");
		new Float:h = floatstr(cmd);
		new Float:bh = GetPlayerHealthA(destid);
		SetPlayerHealth(destid, h);
		format(str, sizeof(str), "%s님의 체력을 설정했습니다. %f > %f", GetPlayerNameA(destid), bh, h);
		SendClientMessage(playerid, COLOR_WHITE, str);
		SendClientMessage(destid, COLOR_WHITE, "관리자에 의해 체력이 설정되었습니다.");
		return 1;
	}
	else if (!strcmp(cmd, "/아머", true))
	{
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /아머 [플레이어] [양]");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "존재하지 않는 플레이어입니다.");
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /아머 [플레이어] [양]");
		new Float:a = floatstr(cmd);
		new Float:ba = GetPlayerArmourA(destid);
		SetPlayerArmour(destid, a);
		format(str, sizeof(str), "%s님의 아머를 설정했습니다. %f > %f", GetPlayerNameA(destid), ba, a);
		SendClientMessage(playerid, COLOR_WHITE, str);
		SendClientMessage(destid, COLOR_WHITE, "관리자에 의해 아머가 설정되었습니다.");
		return 1;
	}
	else if (!strcmp(cmd, "/정보수정", true))
	{
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /정보수정 [플레이어] [정보] [배열] [값]");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "존재하지 않는 플레이어입니다.");
		SetPVarInt(playerid, "EditPVar_destid", destid);
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /정보수정 [플레이어] [정보] [배열] [값]");
		SetPVarString(playerid, "EditPVar_varname", cmd);
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /정보수정 [플레이어] [정보] [배열] [값]");
		SetPVarInt(playerid, "EditPVar_array", strval(cmd));
		strcpy(cmd, stringslice_c(cmdtext, 4));
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /정보수정 [플레이어] [정보] [배열] [값]");
		SetPVarString(playerid, "EditPVar_value", cmd);
		format(str, sizeof(str), "정보수정: %s(%d)", GetPlayerNameA(destid), destid);
		ShowPlayerDialog(playerid, DialogId_Admin(0), DIALOG_STYLE_LIST, str, "INTEGER\nFLOAT\nSTRING", "확인", "취소");
		return 1;
	}
	else if (!strcmp(cmd, "/정보검사", true))
	{
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /정보검사 [플레이어] [정보] [배열]");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "존재하지 않는 플레이어입니다.");
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /정보검사 [플레이어] [정보] [배열]");
		new varname[64];
		strcpy(varname, cmd);
		cmd = strtok(cmdtext, idx);
		new array = (strlen(cmd))?strval(cmd):0;
		format(str, sizeof(str), "- %s님의 %s", GetPlayerNameA(destid), varname);
		SendClientMessage(playerid, COLOR_YELLOW, str);
		format(str, sizeof(str), "  INTEGER: %d", GetPVarInt(playerid, varname, array));
		SendClientMessage(playerid, COLOR_YELLOW, str);
		format(str, sizeof(str), "  FLOAT: %f", GetPVarFloat(playerid, varname, array));
		SendClientMessage(playerid, COLOR_YELLOW, str);
		format(str, sizeof(str), "  STRING: %s", GetPVarString(playerid, varname, array));
		SendClientMessage(playerid, COLOR_YELLOW, str);
		return 1;
	}
	else if (!strcmp(cmd, "/인테리어", true))
	{
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /인테리어 [플레이어] [값]");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "존재하지 않는 플레이어입니다.");
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /인테리어 [플레이어] [값]");
		new interior = strval(cmd);
		new binterior = GetPlayerInterior(destid);
		SetPlayerInterior(destid, interior);
		format(str, sizeof(str), "%s님의 인테리어를 변경했습니다. %d > %d", GetPlayerNameA(destid), binterior, interior);
		SendClientMessage(playerid, COLOR_WHITE, str);
		SendClientMessage(destid, COLOR_WHITE, "관리자에 의해 인테리어가 변경되었습니다.");
		return 1;
	}
	else if (!strcmp(cmd, "/버추얼월드", true))
	{
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /버추얼월드 [플레이어] [값]");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "존재하지 않는 플레이어입니다.");
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /버추얼월드 [플레이어] [값]");
		new virtualworld = strval(cmd);
		new bvirtualworld = GetPlayerVirtualWorld(destid);
		SetPlayerVirtualWorld(destid, virtualworld);
		format(str, sizeof(str), "%s님의 버추얼월드를 변경했습니다. %d > %d", GetPlayerNameA(destid), bvirtualworld, virtualworld);
		SendClientMessage(playerid, COLOR_WHITE, str);
		SendClientMessage(destid, COLOR_WHITE, "관리자에 의해 버추얼월드가 변경되었습니다.");
		return 1;
	}
	else if (!strcmp(cmd, "/스킨", true))
	{
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /스킨 [플레이어] [값]");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "존재하지 않는 플레이어입니다.");
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /스킨 [플레이어] [값]");
		new skin = strval(cmd);
		new bskin = GetPlayerSkin(destid);
		SetPlayerSkin(playerid, skin);
		format(str, sizeof(str), "%s님의 스킨을 변경했습니다. %d > %d", GetPlayerNameA(destid), bskin, skin);
		SendClientMessage(playerid, COLOR_WHITE, str);
		SendClientMessage(destid, COLOR_WHITE, "관리자에 의해 스킨이 변경되었습니다.");
		return 1;
	}
	else if (!strcmp(cmd, "/리스폰", true))
	{
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /리스폰 [플레이어]");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "존재하지 않는 플레이어입니다.");
		SpawnPlayer_(destid);
		format(str, sizeof(str), "%s님을 리스폰시켰습니다.", GetPlayerNameA(destid));
		SendClientMessage(playerid, COLOR_WHITE, str);
		SendClientMessage(destid, COLOR_WHITE, "관리자에 의해 리스폰되었습니다.");
		return 1;
	}
	else if (!strcmp(cmd, "/얼림", true))
	{
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /얼림 [플레이어]");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "존재하지 않는 플레이어입니다.");
		TogglePlayerControllable(playerid, 0);
		format(str, sizeof(str), "%s님을 얼렸습니다.", GetPlayerNameA(destid));
		SendClientMessage(playerid, COLOR_WHITE, str);
		SendClientMessage(playerid, COLOR_WHITE, "관리자에 의해 얼었습니다.");
		return 1;
	}
	else if (!strcmp(cmd, "/녹임", true))
	{
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /녹임 [플레이어]");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "존재하지 않는 플레이어입니다.");
		TogglePlayerControllable(playerid, 1);
		format(str, sizeof(str), "%s님을 녹였습니다.", GetPlayerNameA(destid));
		SendClientMessage(playerid, COLOR_WHITE, str);
		SendClientMessage(playerid, COLOR_WHITE, "관리자에 의해 녹았습니다.");
		return 1;
	}
	else if (!strcmp(cmd, "/무기", true))
	{
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /무기 [플레이어]");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "존재하지 않는 플레이어입니다.");
		new list[MAX_WEAPONS], colors[MAX_WEAPONS], items;
		for (new i = 0; i < MAX_WEAPONS; i++)
			if (GetWeaponObjectModelID(i) != 1575)
			{
				list[items] = GetWeaponObjectModelID(i);
				items++;
			}
		MpListData[playerid][0] = destid;
		ShowPlayerMpList(playerid, MpListId_Admin(0), "Weapons", list, colors, items);
		return 1;
	}
	else if (!strcmp(cmd, "/명령어권한부여", true))
	{
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /명령어권한부여 [플레이어] [명령어]");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "존재하지 않는 플레이어입니다.");
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /명령어권한부여 [플레이어] [명령어]");
		GrantCommand(destid, cmd);
		format(str, sizeof(str), "%s님에게 "C_BLUE"%s"C_YELLOW"의 사용 권한을 부여했습니다.", GetPlayerNameA(destid), cmd);
		SendClientMessage(playerid, COLOR_YELLOW, str);
		format(str, sizeof(str), "관리자가 "C_BLUE"%s"C_YELLOW"의 사용 권한을 부여했습니다.", cmd);
		SendClientMessage(destid, COLOR_YELLOW, str);
		return 1;
	}
	else if (!strcmp(cmd, "/명령어권한회수", true))
	{
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /명령어권한회수 [플레이어] [명령어]");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "존재하지 않는 플레이어입니다.");
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /명령어권한회수 [플레이어] [명령어]");
		RevokeCommand(destid, cmd);
		format(str, sizeof(str), "%s님으로부터 "C_BLUE"%s"C_YELLOW"의 사용 권한을 회수했습니다.", GetPlayerNameA(destid), cmd);
		SendClientMessage(playerid, COLOR_YELLOW, str);
		format(str, sizeof(str), "관리자가 "C_BLUE"%s"C_YELLOW"의 사용 권한을 회수했습니다.", cmd);
		SendClientMessage(destid, COLOR_YELLOW, str);
		return 1;
	}
	//
	// 행동
	//
	else if (!strcmp(cmd, "/날기", true))
	{
		if (GetPVarType(playerid, "FlyMode")) CancelFlyMode(playerid);
		else FlyMode(playerid);
		return 1;
	}
	else if (!strcmp(cmd, "/클로킹", true) || !strcmp(cmd, "/cloaking", true))
	{
		if (GetPlayerVirtualWorld(playerid) != VirtualWorld_Position(0))
		{
			SetPVarInt(playerid, "pClockingVw", GetPlayerVirtualWorld(playerid));
			SetPlayerVirtualWorld(playerid, VirtualWorld_Position(0));
			SetDynamicObjectPos(PositionObject[playerid], 0.0, 0.0, 0.0);
			GameTextForPlayer(playerid, "Cloaked", 1000, 2);
			AgentLog(playerid, "클로킹하였습니다.");
		}
		else
		{
			SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "pClockingVw"));
			DeletePVar(playerid, "pClockingVw");
			GameTextForPlayer(playerid, "Uncloaked", 1000, 2);
			AgentLog(playerid, "클로킹을 해제했습니다.");
		}
		return 1;
	}
	//
	// 이동
	//
	else if (!strcmp(cmd, "/출두", true) || !strcmp(cmd, "/가", true)  || !strcmp(cmd, "/가자", true))
	{
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /출두 [플레이어]");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "존재하지 않는 플레이어입니다.");
		new Float:x, Float:y, Float:z, Float:a;
		GetPlayerPos(destid, x, y, z);
		GetPlayerFacingAngle(destid, a);
		x += 1.0 * floatsin(-a, degrees);
		y += 1.0 * floatcos(-a, degrees);
		SetPlayerPos(playerid, x, y, z);
		SetPlayerFacingAngle(playerid, a + 180.0);
		SetCameraBehindPlayer(playerid);
		SetPlayerInterior(playerid, GetPlayerInterior(destid));
		SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(destid));
		return 1;
	}
	else if (!strcmp(cmd, "/소환", true))
	{
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /소환 [플레이어]");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "존재하지 않는 플레이어입니다.");
		new Float:x, Float:y, Float:z, Float:a;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
		x += 1.0 * floatsin(-a, degrees);
		y += 1.0 * floatcos(-a, degrees);
		SetPlayerPos(destid, x, y, z);
		SetPlayerFacingAngle(destid, a + 180.0);
		SetCameraBehindPlayer(destid);
		SetPlayerInterior(destid, GetPlayerInterior(playerid));
		SetPlayerVirtualWorld(destid, GetPlayerVirtualWorld(playerid));
		SendClientMessage(destid, COLOR_WHITE, "관리자에 의해 소환되었습니다.");
		return 1;
	}
	else if (!strcmp(cmd, "/마크", true))
	{
		GetPlayerPos(playerid, Mark[playerid][0], Mark[playerid][1], Mark[playerid][2]);
		GetPlayerFacingAngle(playerid, Mark[playerid][3]);
		MarkInterior[playerid] = GetPlayerInterior(playerid);
		MarkVirtualWorld[playerid] = GetPlayerVirtualWorld(playerid);
		SendClientMessage(playerid, COLOR_WHITE, "현재 위치가 마크되었습니다.");
		return 1;
	}
	else if (!strcmp(cmd, "/마크로", true))
	{
		SetPlayerPos(playerid, Mark[playerid][0], Mark[playerid][1], Mark[playerid][2]);
		SetPlayerFacingAngle(playerid, Mark[playerid][3]);
		SetCameraBehindPlayer(playerid);
		SetPlayerInterior(playerid, MarkInterior[playerid]);
		SetPlayerVirtualWorld(playerid, MarkVirtualWorld[playerid]);
		return 1;
	}
	else if (!strcmp(cmd, "/텔레포트", true))
	{
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /텔레포트 [좌표]");
		new pos[3][10];
		split(cmd, pos, ',');
		SetPlayerPos(playerid, floatstr(pos[0]), floatstr(pos[1]), floatstr(pos[2]));
		return 1;
	}
	else if (!strcmp(cmd, "/로산", true))
	{
		if (IsPlayerInAnyVehicle(playerid))
			SetVehiclePos(GetPlayerVehicleID(playerid), 1531.4265, -1676.7639, 13.3828 + 2.0);
		else
			SetPlayerPos(playerid, 1531.4265, -1676.7639, 13.3828 + 2.0);
		SetPlayerInterior(playerid, 0);
		return 1;
	}
	else if (!strcmp(cmd, "/샌피", true))
	{
		if (IsPlayerInAnyVehicle(playerid))
			SetVehiclePos(GetPlayerVehicleID(playerid), -1422.2572, -289.8291, 14.1484 + 2.0);
		else
			SetPlayerPos(playerid, -1422.2572, -289.8291, 14.1484 + 2.0);
		SetPlayerInterior(playerid, 0);
		return 1;
	}
	else if (!strcmp(cmd, "/라벤", true))
	{
		if (IsPlayerInAnyVehicle(playerid))
			SetVehiclePos(GetPlayerVehicleID(playerid), 1679.5079, 1448.0795, 47.7813 + 2.0);
		else
			SetPlayerPos(playerid, 1679.5079, 1448.0795, 47.7813 + 2.0);
		SetPlayerInterior(playerid, 0);
		return 1;
	}
	//
	// 서버
	//
	else if (!strcmp(cmd, "/건물생성", true))
	{
		CreateProperty();
		SendClientMessage(playerid, COLOR_WHITE, "건물을 생성했습니다. '/건물설정'에서 설정하세요.");
		return 1;
	}
	else if (!strcmp(cmd, "/건물설정", true))
	{
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return ShowPropertyList(playerid, DialogId_Admin(1));
		destid = strval(cmd);
		if (!IsValidPropertyID(destid))
		for (new i = 0, t = GetMaxProperties(); i < t; i++)
			if (IsValidPropertyID(i) && GetPropertyDBID(i) == destid)
				return ShowPropertyModifier(playerid, i);
		SendClientMessage(playerid, COLOR_WHITE, "존재하지 않는 건물입니다.");
		return 1;
	}
	else if (!strcmp(cmd, "/아이템생성", true))
	{
		/*strcpy(cmd, stringslice_c(cmdtext, 1));
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /아이템생성 [이름]");
		new Float:x, Float:y, Float:z, Float:a;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
		CreateItem(cmd, x, y, z + GetItemZVariation(cmd), a, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), 0, chEmpty);*/
		ShowItemModelList(playerid, DialogId_Admin(2));
		return 1;
	}
	else if (!strcmp(cmd, "/아이템제거", true))
	{
		new itemid = GetPlayerNearestItem(playerid);
		if (!IsValidItemID(itemid))
			return SendClientMessage(playerid, COLOR_WHITE, "근처에 떨어진 아이템이 없습니다.");
		DestroyItem(itemid);
		return 1;
	}
	//
	// 디버그
	//
	else if (!strcmp(cmd, "/부착오브젝트", true))
	{
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /부착오브젝트 [플레이어]");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "존재하지 않는 플레이어입니다.");
		DialogData[playerid][0] = destid;
		ShowPlayerDialog(playerid, DialogId_Admin(3), DIALOG_STYLE_LIST, "부착오브젝트", "목록\n편집\n제거", "확인", "취소");
		return 1;
	}
	else if (!strcmp(cmd, "/음악", true))
	{
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /음악 [플레이어] ([URL])");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "존재하지 않는 플레이어입니다.");
		strcpy(cmd, stringslice_c(cmdtext, 2));
		if (!strlen(cmd))
			return StopAudioStreamForPlayer(destid);
		PlayAudioStreamForPlayer(destid, cmd);
		return 1;
	}
	else if (!strcmp(cmd, "/카메라정보", true))
	{
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /카메라정보 [플레이어]");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "존재하지 않는 플레이어입니다.");
		new Float:px, Float:py, Float:pz,
			Float:vx, Float:vy, Float:vz,
			dstr[256];
		GetPlayerCameraPos(destid, px, py, pz);
		GetPlayerCameraFrontVector(destid, vx, vy, vz);
		strcpy(dstr, chNullString);
		strcat(dstr, C_LIGHTGREEN);
		strtab(dstr, "이름", 13);
		strcat(dstr, C_WHITE);
		strcat(dstr, GetPlayerNameA(destid));
		strcat(dstr, "\n");
		strcat(dstr, C_LIGHTGREEN);
		strtab(dstr, "카메라좌표", 13);
		strcat(dstr, C_WHITE);
		format(str, sizeof(str), "%.4f, %.4f, %.4f", px, py, pz);
		strcat(dstr, str);
		strcat(dstr, "\n");
		strcat(dstr, C_LIGHTGREEN);
		strtab(dstr, "카메라벡터", 13);
		strcat(dstr, C_WHITE);
		format(str, sizeof(str), "%.4f, %.4f, %.4f", vx, vy, vz);
		strcat(dstr, str);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "카메라정보", dstr, "확인", chNullString);
		return 1;
	}
	else if (!strcmp(cmd, "/가속도", true))
	{
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /가속도 [플레이어] ([값])");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "존재하지 않는 플레이어입니다.");
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
		{
			new Float:x, Float:y, Float:z;
			GetPlayerVelocity(destid, x, y, z);
			format(str, sizeof(str), "%s님의 가속도: %.4f, %.4f, %.4f", GetPlayerNameA(destid), x, y, z);
			SendClientMessage(playerid, COLOR_WHITE, str);
			return 1;
		}
		new velocity[3][16];
		split(cmd, velocity, ',');
		SetPlayerVelocity(destid, floatstr(velocity[0]), floatstr(velocity[1]), floatstr(velocity[2]));
		format(str, sizeof(str), "%s님의 가속도: %.4f, %.4f, %.4f", GetPlayerNameA(destid), floatstr(velocity[0]), floatstr(velocity[1]), floatstr(velocity[2]));
		SendClientMessage(playerid, COLOR_WHITE, str);
		return 1;
	}
	else if (!strcmp(cmd, "/애님인덱스", true))
	{
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /애님인덱스 [플레이어] ([값])");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "존재하지 않는 플레이어입니다.");
		format(str, sizeof(str), "%s님의 애니메이션 인덱스: %d", GetPlayerNameA(destid), GetPlayerAnimationIndex(destid));
		SendClientMessage(playerid, COLOR_WHITE, str);
		return 1;
	}
	else if (!strcmp(cmd, "/스페셜액션", true))
	{
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /스페셜액션 [플레이어] ([값])");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "존재하지 않는 플레이어입니다.");
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
		{
			format(str, sizeof(str), "%s님의 스페셜 액션: %d", GetPlayerNameA(destid), GetPlayerSpecialAction(destid));
			SendClientMessage(playerid, COLOR_WHITE, str);
			return 1;
		}
		SetPlayerSpecialAction(playerid, strval(cmd));
		format(str, sizeof(str), "%s님의 스페셜 액션: %d", GetPlayerNameA(destid), strval(cmd));
		SendClientMessage(playerid, COLOR_WHITE, str);
		return 1;
	}
	else if (!strcmp(cmd, "/텍스트드로우", true))
	{
		ShowPlayerDialog(playerid, DialogId_Admin(10), DIALOG_STYLE_LIST, "TextDraw", "목록\n편집\n제거\n보이기\n숨기기\n추가", "확인", "취소");
		return 1;
	}
	else if (!strcmp(cmd, "/오브젝트선택", true))
	{
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /오브젝트선택 [플레이어]");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "존재하지 않는 플레이어입니다.");
		SelectObject(destid);
		return 1;
	}
	return 0;
}
//-----< dResponseHandler >-----------------------------------------------------
public dResponseHandler_Admin(playerid, dialogid, response, listitem, inputtext[])
{
	new str[256], destid, receive[4][16];
	switch (dialogid - DialogId_Admin(0))
	{
		case 0:
		{
			if (response)
			{
				destid = GetPVarInt(playerid, "EditPVar_destid");
				if (!IsPlayerConnected(destid))
					return SendClientMessage(playerid, COLOR_WHITE, "존재하지 않는 플레이어입니다.");
				new varname[64];
				strcpy(varname, GetPVarString(playerid, "EditPVar_varname"));
				new array = GetPVarInt(playerid, "EditPVar_array");
				strcpy(str, GetPVarString(playerid, "EditPVar_value"));
				switch (listitem)
				{
					case 0:
						SetPVarInt(destid, varname, strval(str), array);
					case 1:
						SetPVarFloat(destid, varname, floatstr(str), array);
					default:
						SetPVarString(destid, varname, str, array);
				}
				format(str, sizeof(str), "%s님이 %s님의 %s 수정: %s", GetPlayerNameA(playerid), GetPlayerNameA(destid), varname, str);
				SendAdminMessage(COLOR_YELLOW, str, 0);
			}
			SetPVarInt(playerid, "EditPVar_destid", 0);
			SetPVarString(playerid, "EditPVar_varname", chNullString);
			SetPVarString(playerid, "EditPVar_value", chNullString);
		}
		case 1:
			if (response)
				ShowPropertyModifier(playerid, DialogData[playerid][listitem]);
		case 2:
			if (response && listitem)
			{
				new Float:x, Float:y, Float:z, Float:a;
				GetPlayerPos(playerid, x, y, z);
				GetPlayerFacingAngle(playerid, a);
				CreateItem(listitem - 1, x, y, z, a, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), chEmpty);
			}
		case 3:
			if (response)
			{
				destid = DialogData[playerid][0];
				switch (listitem)
				{
					case 0: ShowAttachedObjectList(playerid, destid, DialogId_Admin(4));
					case 1: ShowAttachedObjectList(playerid, destid, DialogId_Admin(6));
					case 2: ShowAttachedObjectList(playerid, destid, DialogId_Admin(9));
				}
			}
		case 4:
		{
			if (response)
			{
				destid = DialogData[playerid][0];
				if (!listitem)
					return ShowAttachedObjectList(playerid, destid, DialogId_Admin(4));
				new index = listitem - 1;
				if (!IsPlayerAttachedObjectSlotUsed(destid, index))
				{
					SendClientMessage(playerid, COLOR_WHITE, "사용하지 않는 인덱스입니다.");
					ShowAttachedObjectList(playerid, destid, DialogId_Admin(4));
					return 1;
				}
				ShowAttachedObjectModifier(playerid, destid, index, DialogId_Admin(5), DIALOG_STYLE_MSGBOX);
			}
			else ShowPlayerDialog(playerid, DialogId_Admin(3), DIALOG_STYLE_LIST, "부착오브젝트", "목록\n편집\n제거", "확인", "취소");
		}
		case 5:
			if (!response)
				ShowAttachedObjectList(playerid, destid, DialogId_Admin(4));
		case 6:
		{
			if (response)
			{
				destid = DialogData[playerid][0];
				if (!listitem)
					return ShowAttachedObjectList(playerid, destid, DialogId_Admin(6));
				new index = listitem - 1;
				DialogData[playerid][1] = index;
				if (!IsPlayerAttachedObjectSlotUsed(destid, index))
				{
					AttachedObjectInfo[destid][index][aoModel]		= 0;
					AttachedObjectInfo[destid][index][aoBone]		= 1;
					AttachedObjectInfo[destid][index][aoOffset][0]	= 0.0;
					AttachedObjectInfo[destid][index][aoOffset][1]	= 0.0;
					AttachedObjectInfo[destid][index][aoOffset][2]	= 0.0;
					AttachedObjectInfo[destid][index][aoRot][0]		= 0.0;
					AttachedObjectInfo[destid][index][aoRot][1]		= 0.0;
					AttachedObjectInfo[destid][index][aoRot][2]		= 0.0;
					AttachedObjectInfo[destid][index][aoScale][0]	= 1.0;
					AttachedObjectInfo[destid][index][aoScale][1]	= 1.0;
					AttachedObjectInfo[destid][index][aoScale][2]	= 1.0;
					AttachedObjectInfo[destid][index][aoMColor][0]	= 0;
					AttachedObjectInfo[destid][index][aoMColor][1]	= 0;
				}
				ShowAttachedObjectModifier(playerid, destid, index, DialogId_Admin(7), DIALOG_STYLE_LIST);
			}
			else ShowPlayerDialog(playerid, DialogId_Admin(3), DIALOG_STYLE_LIST, "부착오브젝트", "목록\n편집\n제거", "확인", "취소");
		}
		case 7:
		{
			destid = DialogData[playerid][0];
			if (response)
			{
				new index = DialogData[playerid][1];
				if (!listitem)
					return ShowAttachedObjectModifier(playerid, destid, index, DialogId_Admin(7), DIALOG_STYLE_LIST);
				DialogData[playerid][2] = listitem;
				switch (listitem)
				{
					case 1: format(str, sizeof(str), "현재 Model: %d", AttachedObjectInfo[destid][index][aoModel]);
					case 2: format(str, sizeof(str), "현재 Bone: %d", AttachedObjectInfo[destid][index][aoBone]);
					case 3: format(str, sizeof(str), "현재 Offset: %.4f,%.4f,%.4f",
								AttachedObjectInfo[destid][index][aoOffset][0],
								AttachedObjectInfo[destid][index][aoOffset][1],
								AttachedObjectInfo[destid][index][aoOffset][2]);
					case 4: format(str, sizeof(str), "현재 Rot: %.4f,%.4f,%.4f",
								AttachedObjectInfo[destid][index][aoRot][0],
								AttachedObjectInfo[destid][index][aoRot][1],
								AttachedObjectInfo[destid][index][aoRot][2]);
					case 5: format(str, sizeof(str), "현재 Scale: %.4f,%.4f,%.4f",
								AttachedObjectInfo[destid][index][aoScale][0],
								AttachedObjectInfo[destid][index][aoScale][1],
								AttachedObjectInfo[destid][index][aoScale][2]);
					case 6: format(str, sizeof(str), "현재 MColor: %d,%d",
								AttachedObjectInfo[destid][index][aoMColor][0],
								AttachedObjectInfo[destid][index][aoMColor][1]);
				}
				ShowPlayerDialog(playerid, DialogId_Admin(8), DIALOG_STYLE_INPUT, "부착오브젝트", str, "확인", "취소");
			}
			else ShowAttachedObjectList(playerid, destid, DialogId_Admin(6));
		}
		case 8:
		{
			destid = DialogData[playerid][0];
			new index = DialogData[playerid][1];
			if (response && strlen(inputtext))
			{
				switch (DialogData[playerid][2])
				{
					case 1: AttachedObjectInfo[destid][index][aoModel] = strval(inputtext);
					case 2: AttachedObjectInfo[destid][index][aoBone] = strval(inputtext);
					case 3:
					{
						split(inputtext, receive, ',');
						for (new i = 0; i < 3; i++)
							AttachedObjectInfo[destid][index][aoOffset][i] = floatstr(receive[i]);
					}
					case 4:
					{
						split(inputtext, receive, ',');
						for (new i = 0; i < 3; i++)
							AttachedObjectInfo[destid][index][aoRot][i] = floatstr(receive[i]);
					}
					case 5:
					{
						split(inputtext, receive, ',');
						for (new i = 0; i < 3; i++)
							AttachedObjectInfo[destid][index][aoScale][i] = floatstr(receive[i]);
					}
					case 6:
					{
						split(inputtext, receive, ',');
						for (new i = 0; i < 2; i++)
							AttachedObjectInfo[destid][index][aoMColor][i] = strval(receive[i]);
					}
				}
				SetPlayerAttachedObject(destid, index, AttachedObjectInfo[destid][index][aoModel], AttachedObjectInfo[destid][index][aoBone],
					AttachedObjectInfo[destid][index][aoOffset][0], AttachedObjectInfo[destid][index][aoOffset][1], AttachedObjectInfo[destid][index][aoOffset][2],
					AttachedObjectInfo[destid][index][aoRot][0], AttachedObjectInfo[destid][index][aoRot][1], AttachedObjectInfo[destid][index][aoRot][2],
					AttachedObjectInfo[destid][index][aoScale][0], AttachedObjectInfo[destid][index][aoScale][1], AttachedObjectInfo[destid][index][aoScale][2],
					AttachedObjectInfo[destid][index][aoMColor][0], AttachedObjectInfo[destid][index][aoMColor][1]);
			}
			ShowAttachedObjectModifier(playerid, destid, index, DialogId_Admin(7), DIALOG_STYLE_LIST);
		}
		case 9:
		{
			if (response)
			{
				destid = DialogData[playerid][0];
				if (!listitem)
					return ShowAttachedObjectList(playerid, destid, DialogId_Admin(9));
				RemovePlayerAttachedObject(playerid, listitem - 1);
				ShowAttachedObjectList(playerid, destid, DialogId_Admin(9));
			}
			else ShowPlayerDialog(playerid, DialogId_Admin(3), DIALOG_STYLE_LIST, "부착오브젝트", "목록\n편집\n제거", "확인", "취소");
		}
		case 10:
			if (response)
			{
				if (listitem == 5)
				{
					TextDrawCreate(1.0, 1.0, "New TextDraw");
					OnPlayerCommandText(playerid, "/텍스트드로우");
					return 1;
				}
				DialogData[playerid][0] = listitem;
				ShowTextDrawList(playerid, DialogId_Admin(11));
			}
		case 11:
		{
			if (response)
			{
				destid = DialogData[playerid][1] = listitem - 1;
				if (TextDrawInfo[destid][tdID] == Text:INVALID_TEXT_DRAW || !listitem)
					return OnDialogResponse(playerid, DialogId_Admin(11), true, listitem, chEmpty);
				switch (DialogData[playerid][0])
				{
					case 0: ShowTextDrawModifier(playerid, destid, DialogId_Admin(12), DIALOG_STYLE_MSGBOX);
					case 1: ShowTextDrawModifier(playerid, destid, DialogId_Admin(13), DIALOG_STYLE_LIST);
					case 2:
					{
						TextDrawDestroy(destid);
						OnDialogResponse(playerid, DialogId_Admin(10), true, DialogData[playerid][0], chEmpty);
					}
					case 3: ShowPlayerDialog(playerid, DialogId_Admin(15), DIALOG_STYLE_INPUT, "TextDraw", "텍스트드로우를 볼 플레이어를 적으세요.", "확인", "뒤로");
					case 4: ShowPlayerDialog(playerid, DialogId_Admin(15), DIALOG_STYLE_INPUT, "TextDraw", "텍스트드로우를 숨길 플레이어를 적으세요.", "확인", "뒤로");
				}
			}
			else OnPlayerCommandText(playerid, "/텍스트드로우");
		}
		case 12:
			if (!response)
				OnDialogResponse(playerid, DialogId_Admin(10), true, DialogData[playerid][0], chEmpty);
		case 13:
		{
			if (response)
			{
				destid = DialogData[playerid][1];
				if (!listitem)
					return OnDialogResponse(playerid, DialogId_Admin(11), true, destid + 1, chEmpty);
				DialogData[playerid][2] = listitem - 1;
				switch (DialogData[playerid][2])
				{
					case 0: format(str, sizeof(str), "현재 Position: %.4f,%.4f", TextDrawInfo[destid][tdPos][0], TextDrawInfo[destid][tdPos][1]);
					case 1: format(str, sizeof(str), "현재 Text: %s", TextDrawInfo[destid][tdText]);
					case 2: format(str, sizeof(str), "현재 LetterSize: %.4f,%.4f", TextDrawInfo[destid][tdLetterSize][0], TextDrawInfo[destid][tdLetterSize][1]);
					case 3: format(str, sizeof(str), "현재 TextSize: %.4f,%.4f", TextDrawInfo[destid][tdTextSize][0], TextDrawInfo[destid][tdTextSize][1]);
					case 4: format(str, sizeof(str), "현재 Alignment: %d", TextDrawInfo[destid][tdAlignment]);
					case 5: format(str, sizeof(str), "현재 Color: %d", TextDrawInfo[destid][tdColor]);
					case 6: format(str, sizeof(str), "현재 UseBox: %d", TextDrawInfo[destid][tdUseBox]);
					case 7: format(str, sizeof(str), "현재 BoxColor: %d", TextDrawInfo[destid][tdBoxColor]);
					case 8: format(str, sizeof(str), "현재 Shadow: %d", TextDrawInfo[destid][tdShadow]);
					case 9: format(str, sizeof(str), "현재 Outline: %d", TextDrawInfo[destid][tdOutline]);
					case 10: format(str, sizeof(str), "현재 BackgroundColor: %d", TextDrawInfo[destid][tdBackgroundColor]);
					case 11: format(str, sizeof(str), "현재 Font: %d", TextDrawInfo[destid][tdFont]);
					case 12: format(str, sizeof(str), "현재 Proportional: %d", TextDrawInfo[destid][tdProportional]);
					case 13: format(str, sizeof(str), "현재 PreviewModel: %d", TextDrawInfo[destid][tdPreviewModel]);
					case 14: format(str, sizeof(str), "현재 PreviewRot: %.4f,%.4f,%.4f,%.4f", TextDrawInfo[destid][tdPreviewRot][0], TextDrawInfo[destid][tdPreviewRot][1], TextDrawInfo[destid][tdPreviewRot][2], TextDrawInfo[destid][tdPreviewRot][3]);
					case 15: format(str, sizeof(str), "현재 PreviewVehCol: %d,%d", TextDrawInfo[destid][tdPreviewVehCol][0], TextDrawInfo[destid][tdPreviewVehCol][1]);
				}
				ShowPlayerDialog(playerid, DialogId_Admin(14), DIALOG_STYLE_INPUT, "TextDraw", str, "확인", "뒤로");
			}
			else OnDialogResponse(playerid, DialogId_Admin(10), true, DialogData[playerid][0], chEmpty);
		}
		case 14:
		{
			destid = DialogData[playerid][1];
			if (response && strlen(inputtext))
				switch (DialogData[playerid][2])
				{
					case 0:
					{
						split(inputtext, receive, ',');
						TextDrawSetPosition(destid, floatstr(receive[0]), floatstr(receive[1]));
					}
					case 1: TextDrawSetString(destid, inputtext);
					case 2:
					{
						split(inputtext, receive, ',');
						TextDrawLetterSize(destid, floatstr(receive[0]), floatstr(receive[1]));
					}
					case 3:
					{
						split(inputtext, receive, ',');
						TextDrawTextSize(destid, strval(receive[0]), strval(receive[1]));
					}
					case 4: TextDrawAlignment(destid, strval(inputtext));
					case 5: TextDrawColor(destid, strval(inputtext));
					case 6: TextDrawUseBox(destid, strval(inputtext));
					case 7: TextDrawBoxColor(destid, strval(inputtext));
					case 8: TextDrawSetShadow(destid, strval(inputtext));
					case 9: TextDrawSetOutline(destid, strval(inputtext));
					case 10: TextDrawBackgroundColor(destid, strval(inputtext));
					case 11: TextDrawFont(destid, strval(inputtext));
					case 12: TextDrawSetProportional(destid, strval(inputtext));
					case 13: TextDrawSetPreviewModel(destid, strval(inputtext));
					case 14:
					{
						split(inputtext, receive, ',');
						TextDrawSetPreviewRot(destid, floatstr(receive[0]), floatstr(receive[1]), floatstr(receive[2]), floatstr(receive[3]));
					}
					case 15:
					{
						split(inputtext, receive, ',');
						TextDrawSetPreviewVehCol(destid, strval(receive[0]), strval(receive[1]));
					}
				}
			TextDrawUpdate(destid);
			OnDialogResponse(playerid, DialogId_Admin(11), true, destid + 1, chEmpty);
		}
		case 15:
		{
			new mode = DialogData[playerid][0];
			if (response)
			{
				destid = ReturnUser(inputtext);
				if (!IsPlayerConnected(destid) && strval(inputtext) != -1)
				{
					SendClientMessage(playerid, COLOR_WHITE, "존재하지 않는 플레이어입니다.");
				}
				else
					switch (mode)
					{
						case 0:
						{
							if (strval(inputtext) == -1)
								TextDrawShowForAll(DialogData[playerid][1]);
							else
								TextDrawShowForPlayer(playerid, DialogData[playerid][1]);
						}
						case 1:
						{
							if (strval(inputtext) == -1)
								TextDrawHideForAll(DialogData[playerid][1]);
							else
								TextDrawHideForPlayer(playerid, DialogData[playerid][1]);
						}
					}
			}
			OnDialogResponse(playerid, DialogId_Admin(10), true, mode, chEmpty);
		}
		case 16:
		{
			if (response)
			{
				GivePlayerWeapon(MpListData[playerid][0], MpListData[playerid][1], strval(inputtext));
				format(str, sizeof(str), "%s님께 "C_BLUE"%s"C_WHITE"을(를) %d발 드렸습니다.", GetPlayerNameA(MpListData[playerid][0]), GetWeaponNameA(MpListData[playerid][1]), strval(inputtext));
				SendClientMessage(playerid, COLOR_WHITE, str);
				format(str, sizeof(str), "%s님께서 "C_BLUE"%s"C_WHITE"을(를) %d발 주셨습니다.", GetPlayerNameA(playerid), GetWeaponNameA(MpListData[playerid][1]), strval(inputtext));
				SendClientMessage(MpListData[playerid][0], COLOR_WHITE, str);
			}
			else
			{
				format(str, sizeof(str), "/무기 %d", MpListData[playerid][0]);
				OnPlayerCommandText(playerid, str);
			}
		}
	}
	return 1;
}
//-----< mplResponseHandler >---------------------------------------------------
public mplResponseHandler_Admin(playerid, mplistid, selecteditem)
{
	new str[256];
	switch (MpListId_Admin(0) - mplistid)
	{
		case 0:
		{
			for (new i = 0; i < MAX_WEAPONS; i++)
				if (GetWeaponObjectModelID(i) == selecteditem)
				{
					MpListData[playerid][1] = i;
					format(str, sizeof(str), ""C_WHITE"%s님에게 "C_BLUE"%s"C_WHITE"을(를) 몇 발 주시겠습니까?", GetPlayerNameA(MpListData[playerid][0]), GetWeaponNameA(i));
					ShowPlayerDialog(playerid, DialogId_Admin(16), DIALOG_STYLE_INPUT, ""C_BLUE"무기", str, "확인", "뒤로");
				}
		}
	}
	return 1;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----< SendAdminMessage >-----------------------------------------------------
stock SendAdminMessage(color, message[], level=1)
{
	for (new i = 0, t = GetMaxPlayers(); i < t; i++)
	{
		new alevel = GetPVarInt(i, "pAdmin");
		if (alevel && alevel >= level
		||	!level && GetPVarInt(i, "pAgent"))
			SendClientMessage(i, color, message);
	}
}
//-----< ShowAttachedObjectList >-----------------------------------------------
stock ShowAttachedObjectList(playerid, destid, dialogid)
{
	new str[1024];
	strcpy(str, chNullString);
	strtab(str, "Index", 7);
	strtab(str, "Model", 7);
	strcat(str, "Bone");
	for (new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
	{
		if(IsPlayerAttachedObjectSlotUsed(destid, i))
		{
			strcat(str, "\n");
			strtab(str, valstr_(i), 7);
			strtab(str, valstr_(AttachedObjectInfo[destid][i][aoModel]), 7);
			strcat(str, valstr_(AttachedObjectInfo[destid][i][aoBone]));
		}
		else
		{
			strcat(str, "\n");
			strtab(str, valstr_(i), 7);
			strtab(str, "None", 7);
			strcat(str, "None");
		}
	}
	ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, "부착오브젝트", str, "확인", "취소");
	return 1;
}
//-----< ShowAttachedObjectModifier >-------------------------------------------
stock ShowAttachedObjectModifier(playerid, destid, index, dialogid, dialogstyle)
{
	new str[1024];
	strtab(str, "Index", 10); format(str, sizeof(str), "%s%d", str, index);
	strcat(str, "\n");	strtab(str, "Model", 10);	strcat(str, valstr_(AttachedObjectInfo[destid][index][aoModel]));
	strcat(str, "\n");	strtab(str, "Bone", 10);	strcat(str, valstr_(AttachedObjectInfo[destid][index][aoBone]));
	strcat(str, "\n");	strtab(str, "Offset", 10);	format(str, sizeof(str), "%s%.4f,%.4f,%.4f", str,
		AttachedObjectInfo[destid][index][aoOffset][0], AttachedObjectInfo[destid][index][aoOffset][1], AttachedObjectInfo[destid][index][aoOffset][2]);
	strcat(str, "\n");	strtab(str, "Rot", 10);		format(str, sizeof(str), "%s%.4f,%.4f,%.4f", str,
		AttachedObjectInfo[destid][index][aoRot][0], AttachedObjectInfo[destid][index][aoRot][1], AttachedObjectInfo[destid][index][aoRot][2]);
	strcat(str, "\n");	strtab(str, "Scale", 10);	format(str, sizeof(str), "%s%.4f,%.4f,%.4f", str,
		AttachedObjectInfo[destid][index][aoScale][0], AttachedObjectInfo[destid][index][aoScale][1], AttachedObjectInfo[destid][index][aoScale][2]);
	strcat(str, "\n");  strtab(str, "MColor", 10);  format(str, sizeof(str), "%s%d,%d", str,
		AttachedObjectInfo[destid][index][aoMColor][0], AttachedObjectInfo[destid][index][aoMColor][1]);
	ShowPlayerDialog(playerid, dialogid, dialogstyle, "부착오브젝트", str, "확인", "취소");
	return 1;
}
//-----< ShowTextDrawList >-----------------------------------------------------
stock ShowTextDrawList(playerid, dialogid)
{
	new str[MAX_TEXT_DRAWS * 128];
	strcpy(str, chNullString);
	strtab(str, "ID", 5);
	strcat(str, "Text");
	for (new i = 0; i < MAX_TEXT_DRAWS; i++)
	{
		strcat(str, "\n");
		strtab(str, valstr_(i), 5);
		if (TextDrawInfo[i][tdID] != Text:INVALID_TEXT_DRAW)
			strcat(str, TextDrawInfo[i][tdText]);
		else
			strcat(str, "None");
	}
	ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, "TextDraw", str, "확인", "뒤로");
	return 1;
}
//-----< ShowTextDrawModifier >-------------------------------------------------
stock ShowTextDrawModifier(playerid, textid, dialogid, dialogstyle)
{
	new str[1024];
	strtab(str, "ID", 17); strcat(str, valstr_(textid));
	strcat(str, "\n");	strtab(str, "Position",			17);	format(str, sizeof(str), "%s%.4f,%.4f", str, TextDrawInfo[textid][tdPos][0], TextDrawInfo[textid][tdPos][1]);
	strcat(str, "\n");	strtab(str, "Text",				17);	strcat(str, TextDrawInfo[textid][tdText]);
	strcat(str, "\n");  strtab(str, "LetterSize",		17);	format(str, sizeof(str), "%s%.4f,%.4f", str, TextDrawInfo[textid][tdLetterSize][0], TextDrawInfo[textid][tdLetterSize][1]);
	strcat(str, "\n");  strtab(str, "TextSize",			17);	format(str, sizeof(str), "%s%.4f,%.4f", str, TextDrawInfo[textid][tdTextSize][0], TextDrawInfo[textid][tdTextSize][1]);
	strcat(str, "\n");  strtab(str, "Alignment",		17);	strcat(str, valstr_(TextDrawInfo[textid][tdAlignment]));
	strcat(str, "\n");  strtab(str, "Color",			17);	strcat(str, valstr_(TextDrawInfo[textid][tdColor]));
	strcat(str, "\n");  strtab(str, "UseBox",			14);	strcat(str, valstr_(TextDrawInfo[textid][tdUseBox]));
	strcat(str, "\n");  strtab(str, "BoxColor",			17);	strcat(str, valstr_(TextDrawInfo[textid][tdBoxColor]));
	strcat(str, "\n");  strtab(str, "Shadow",			14);	strcat(str, valstr_(TextDrawInfo[textid][tdShadow]));
	strcat(str, "\n");  strtab(str, "Outline", 			17);	strcat(str, valstr_(TextDrawInfo[textid][tdOutline]));
	strcat(str, "\n");  strtab(str, "BackgroundColor",	17);	strcat(str, valstr_(TextDrawInfo[textid][tdBackgroundColor]));
	strcat(str, "\n");  strtab(str, "Font",				17);	strcat(str, valstr_(TextDrawInfo[textid][tdFont]));
	strcat(str, "\n");  strtab(str, "Proportional",		17);	strcat(str, valstr_(TextDrawInfo[textid][tdProportional]));
	strcat(str, "\n");  strtab(str, "PreviewModel",		17);	strcat(str, valstr_(TextDrawInfo[textid][tdPreviewModel]));
	strcat(str, "\n");  strtab(str, "PreviewRot",		17);	format(str, sizeof(str), "%s%d,%d,%d,%d", str, TextDrawInfo[textid][tdPreviewRot][0], TextDrawInfo[textid][tdPreviewRot][1], TextDrawInfo[textid][tdPreviewRot][2], TextDrawInfo[textid][tdPreviewRot][3]);
	strcat(str, "\n");  strtab(str,	"PreviewVehCol",	17);	format(str, sizeof(str), "%s%d,%d", str, TextDrawInfo[textid][tdPreviewVehCol][0], TextDrawInfo[textid][tdPreviewVehCol][1]);
	ShowPlayerDialog(playerid, dialogid, dialogstyle, "TextDraw", str, "확인", "뒤로");
	return 1;
}
//-----< AdminLog >-------------------------------------------------------------
stock AdminLog(playerid, result[])
{
	new File:fHandle,
		str[256],
		year, month, day,
		hour, minute, second;
	getdate(year, month, day);
	format(str, sizeof(str), "AdminLog/%s_%d년%d월%d일.txt", GetPlayerNameA(playerid), year, month, day);
	fHandle = fopen(str, io_append);
	if (fHandle)
	{
		gettime(hour, minute, second);
		format(str, sizeof(str), "\r\n[%d:%d:%d] ", hour, minute, second);
		fwrite(fHandle, str);
		for (new i = 0, t = strlen(result); i < t; i++)
			fputchar(fHandle, result[i], false);
	}
	fclose(fHandle);
}
//-----< AgentLog >-------------------------------------------------------------
stock AgentLog(playerid, result[])
{
	new File:fHandle,
		str[256],
		year, month, day,
		hour, minute, second;
	getdate(year, month, day);
	format(str, sizeof(str), "AgentLog/%s_%d년%d월%d일.txt", GetPlayerNameA(playerid), year, month, day);
	fHandle = fopen(str, io_append);
	if (fHandle)
	{
		gettime(hour, minute, second);
		format(str, sizeof(str), "\r\n[%d:%d:%d] ", hour, minute, second);
		fwrite(fHandle, str);
		for (new i = 0, t = strlen(result); i < t; i++)
			fputchar(fHandle, result[i], false);
	}
	fclose(fHandle);
}
//-----<  >---------------------------------------------------------------------
