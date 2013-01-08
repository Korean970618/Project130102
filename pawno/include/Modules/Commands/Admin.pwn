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
 *		Update:		2013/01/08
 *
 *
 */
/*

  < Callbacks >

  < Functions >

*/



//-----< Variables
new Float:Mark[MAX_PLAYERS][4];



//-----< Defines



//-----< Callbacks
forward pCommandTextHandler_Admin(playerid, cmdtext[]);
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
	    strcat(help, ""C_PASTEL_YELLOW"- 유저 -"C_WHITE"\n/체력, /아머");
	    strcat(help, ""C_PASTEL_YELLOW"- 이동 -"C_WHITE"\n/출두, /소환, /마크, /마크로, /텔레포트, /로산, /샌피, /라벤");
	    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_LIST, ""C_BLUE"관리자 도움말", help, "닫기", "");
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
		SendClientMessage(destid, COLOR_WHITE, "관리자에 의해 소환되었습니다.");
		return 1;
	}
	else if (!strcmp(cmd, "/마크", true))
	{
	    GetPlayerPos(playerid, Mark[playerid][0], Mark[playerid][1], Mark[playerid][2]);
	    GetPlayerFacingAngle(playerid, Mark[playerid][3]);
	    SendClientMessage(playerid, COLOR_WHITE, "현재 위치가 마크되었습니다.");
	    return 1;
	}
	else if (!strcmp(cmd, "/마크로", true))
	{
	    SetPlayerPos(playerid, Mark[playerid][0], Mark[playerid][1], Mark[playerid][2]);
	    SetPlayerFacingAngle(playerid, Mark[playerid][3]);
	    SetCameraBehindPlayer(playerid);
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
	else if (!strcmp(cmd, "/로산",true))
	{
		if (IsPlayerInAnyVehicle(playerid))
			SetVehiclePos(GetPlayerVehicleID(playerid), 1531.4265, -1676.7639, 13.3828 + 2.0);
		else
			SetPlayerPos(playerid, 1531.4265, -1676.7639, 13.3828 + 2.0);
		return 1;
	}
	else if (!strcmp(cmd, "/샌피",true))
	{
		if (IsPlayerInAnyVehicle(playerid))
			SetVehiclePos(GetPlayerVehicleID(playerid), -1422.2572, -289.8291, 14.1484 + 2.0);
		else
			SetPlayerPos(playerid, -1422.2572, -289.8291, 14.1484 + 2.0);
		return 1;
	}
	else if (!strcmp(cmd, "/라벤",true))
	{
		if (IsPlayerInAnyVehicle(playerid))
			SetVehiclePos(GetPlayerVehicleID(playerid), 1679.5079, 1448.0795, 47.7813 + 2.0);
		else
			SetPlayerPos(playerid, 1679.5079, 1448.0795, 47.7813 + 2.0);
		return 1;
	}
	return 0;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----<  >---------------------------------------------------------------------
