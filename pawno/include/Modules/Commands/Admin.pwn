/*
 *
 *
 *		PureunBa(서성범)
 *
 *			Admin Command
 *
 *
 *		Coded by PureunBa 2011-2013 @ all right reserved.
 *
 *			< pureunba.tistory.com >
 *
 *
 *		Release:	2013/01/07
 *		Update:		2013/02/02
 *
 *
 */
/*

  < Callbacks >
	pCommandTextHandler_Admin(playerid, cmdtext[])
	dResponseHandler_Admin(playerid, dialogid, response, listitem, inputtext[])

  < Functions >
	SendAdminMessage(color, message[], level=1)
	ShowAttachedObjectList(playerid, destid, dialogid)
	ShowAttachedObjectModifier(playerid, destid, index, dialogid, dialogstyle)

*/



//-----< Variables
new Float:Mark[MAX_PLAYERS][4],
	MarkInterior[MAX_PLAYERS],
	MarkVirtualWorld[MAX_PLAYERS];



//-----< Defines
#define DialogId_Admin(%0)		  (50+%0)



//-----< Callbacks
forward pCommandTextHandler_Admin(playerid, cmdtext[]);
forward dResponseHandler_Admin(playerid, dialogid, response, listitem, inputtext[]);
//-----< pCommandTextHandler >--------------------------------------------------
public pCommandTextHandler_Admin(playerid, cmdtext[])
{
	new cmd[256],
		idx,
		destid,
		str[256];
	cmd = strtok(cmdtext, idx);

	if (GetPVarInt_(playerid, "pAdmin") < 1) return 0;
	else if (!strcmp(cmd, "/관리자도움말", true) || !strcmp(cmd, "/adminhelp", true) || !strcmp(cmd, "/ah", true))
	{
		new help[2048];
		strcat(help, ""C_PASTEL_YELLOW"- 유저 -"C_WHITE"\n/체력, /아머, /정보수정, /정보검사, /인테리어, /버추얼월드, /스킨, /리스폰\n\n");
		strcat(help, ""C_PASTEL_YELLOW"- 이동 -"C_WHITE"\n/출두, /소환, /마크, /마크로, /날기, /텔레포트, /로산, /샌피, /라벤\n\n");
		strcat(help, ""C_PASTEL_YELLOW"- 서버 -"C_WHITE"\n/건물생성, /건물설정, /아이템생성, /아이템제거\n\n");
		strcat(help, ""C_PASTEL_YELLOW"- 디버그 -"C_WHITE"\n/부착오브젝트, /음악, /카메라정보, /가속도\n\n");
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
		SetPVarInt_(playerid, "EditPVar_destid", destid);
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /정보수정 [플레이어] [정보] [배열] [값]");
		SetPVarString_(playerid, "EditPVar_varname", cmd);
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /정보수정 [플레이어] [정보] [배열] [값]");
		SetPVarInt_(playerid, "EditPVar_array", strval(cmd));
		strcpy(cmd, stringslice_c(cmdtext, 4));
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "사용법: /정보수정 [플레이어] [정보] [배열] [값]");
		SetPVarString_(playerid, "EditPVar_value", cmd);
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
		format(str, sizeof(str), "  INTEGER: %d", GetPVarInt_(playerid, varname, array));
		SendClientMessage(playerid, COLOR_YELLOW, str);
		format(str, sizeof(str), "  FLOAT: %f", GetPVarFloat_(playerid, varname, array));
		SendClientMessage(playerid, COLOR_YELLOW, str);
		format(str, sizeof(str), "  STRING: %s", GetPVarString_(playerid, varname, array));
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
	else if (!strcmp(cmd, "/날기", true))
	{
		if (GetPVarType_(playerid, "FlyMode")) CancelFlyMode(playerid);
		else FlyMode(playerid);
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
	return 0;
}
//-----< dResponseHandler >-----------------------------------------------------
public dResponseHandler_Admin(playerid, dialogid, response, listitem, inputtext[])
{
	new str[256], destid;
	switch (dialogid - DialogId_Admin(0))
	{
		case 0:
		{
			if (response)
			{
				destid = GetPVarInt_(playerid, "EditPVar_destid");
				if (!IsPlayerConnected(destid))
					return SendClientMessage(playerid, COLOR_WHITE, "존재하지 않는 플레이어입니다.");
				new varname[64];
				strcpy(varname, GetPVarString_(playerid, "EditPVar_varname"));
				new array = GetPVarInt_(playerid, "EditPVar_array");
				strcpy(str, GetPVarString_(playerid, "EditPVar_value"));
				switch (listitem)
				{
					case 0:
						SetPVarInt_(destid, varname, strval(str), array);
					case 1:
						SetPVarFloat_(destid, varname, floatstr(str), array);
					default:
						SetPVarString_(destid, varname, str, array);
				}
				format(str, sizeof(str), "%s님이 %s님의 %s 수정: %s", GetPlayerNameA(playerid), GetPlayerNameA(destid), varname, str);
				SendAdminMessage(COLOR_YELLOW, str);
			}
			SetPVarInt_(playerid, "EditPVar_destid", 0);
			SetPVarString_(playerid, "EditPVar_varname", chNullString);
			SetPVarString_(playerid, "EditPVar_value", chNullString);
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
			new index = DialogData[playerid][1],
				mode = DialogData[playerid][2],
				receive[3][16];
			if (response && strlen(inputtext))
			{
				switch (mode)
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
	}
	return 1;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----< SendAdminMessage >-----------------------------------------------------
stock SendAdminMessage(color, message[], level=1)
{
	for (new i = 0, t = GetMaxPlayers(); i < t; i++)
		if (GetPVarInt_(i, "pAdmin") >= level)
			SendClientMessage(i, color, message);
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
//-----<  >---------------------------------------------------------------------
