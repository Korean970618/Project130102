/*
 *
 *
 *		PureunBa(������)
 *
 *			Agent Core
 *
 *
 *		Coded by PureunBa 2011-2013 @ all right reserved.
 *
 *			< pureunba.tistory.com >
 *
 *
 *		Release:	2013/02/25
 *		Update:		2013/02/26
 *
 *
 */
/*

  < Callbacks >
	gInitHandler_Agent()
	pUpdateHandler_Agent(playerid)
	pTimerTickHandler_Agent(nsec, playerid)
	pCommandTextHandler_Agent(playerid, cmdtext[])
	dResponseHandler_Agent(playerid, dialogid, response, listitem, inputtext[])
	
  < Functions >
	AgentLog(playerid, result[])

*/



//-----< Variables
new PositionObject[MAX_PLAYERS];



//-----< Definess
#define DialogId_Agent(%0)  		(125+%0)
#define VirtualWorld_Agent(%0)  	(25+%0)



//-----< Callbacks
forward gInitHandler_Agent();
forward pUpdateHandler_Agent(playerid);
forward pTimerTickHandler_Agent(nsec, playerid);
forward pCommandTextHandler_Agent(playerid, cmdtext[]);
forward dResponseHandler_Agent(playerid, dialogid, response, listitem, inputtext[]);
//-----< gInitHandler >---------------------------------------------------------
public gInitHandler_Agent()
{
	for (new i = 0; i < sizeof(PositionObject); i++)
		PositionObject[i] = CreateDynamicObject(19133, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, VirtualWorld_Agent(0));
	return 1;
}
//-----< pUpdateHandler >-------------------------------------------------------
public pUpdateHandler_Agent(playerid)
{
	if (!GetPVarInt_(playerid, "LoggedIn") || GetPVarInt_(playerid, "pAgentMode")) return 1;
	new Float:ppos[3], Float:opos[3], Float:speed;
	GetPlayerPos(playerid, ppos[0], ppos[1], ppos[2]);
	GetDynamicObjectPos(PositionObject[playerid], opos[0], opos[1], opos[2]);
	speed = GetDistanceBetweenPoints(ppos[0], ppos[1], ppos[2], opos[0], opos[1], opos[2]);
	if (speed != 0.0)
		MoveDynamicObject(PositionObject[playerid], ppos[0], ppos[1], ppos[2], floatround(speed, floatround_ceil) * 10.0);
	return 1;
}
//-----< pTimerTickHandler >----------------------------------------------------
public pTimerTickHandler_Agent(nsec, playerid)
{
	if (!GetPVarInt_(playerid, "LoggedIn")) return 1;
	if (nsec != 100) return 1;
	new Float:orot[3];
	GetDynamicObjectRot(PositionObject[playerid], orot[0], orot[1], orot[2]);
	SetDynamicObjectRot(PositionObject[playerid], orot[0], orot[1], orot[2] + 36.0);
	return 1;
}
//-----< pCommandTextHandler >--------------------------------------------------
public pCommandTextHandler_Agent(playerid, cmdtext[])
{
	new cmd[256], idx,
		str[256],
		destid;
	cmd = strtok(cmdtext, idx);
	
	if (!GetPVarInt_(playerid, "pAgent")) return 0;
	else if (!strcmp(cmd, "/������Ʈ����", true) || !strcmp(cmd, "/agenthelp", true))
	{
		new help[2048];
		strcat(help, ""C_PASTEL_YELLOW"/������Ʈ"C_WHITE": ������Ʈ ��带 ON/OFF�մϴ�.\n");
		strcat(help, ""C_PASTEL_YELLOW"/Ŭ��ŷ"C_WHITE": �ڽ��� ����� ����ϴ�.\n");
		strcat(help, ""C_PASTEL_YELLOW"/������Ʈ��� [�÷��̾�]"C_WHITE": �ش� �÷��̾�� ����մϴ�.");
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "������Ʈ ����", help, "�ݱ�", "");
		return 1;
	}
	else if (!strcmp(cmd, "/������Ʈ", true) || !strcmp(cmd, "/agent", true))
	{
		if (GetPVarInt_(playerid, "pAgentMode"))
		{
			DeletePVar_(playerid, "pAgentMode");
			SendClientMessage(playerid, COLOR_YELLOW, "������Ʈ ��带 �����߽��ϴ�.");
			AgentLog(playerid, "������Ʈ ��带 �����߽��ϴ�.");
			return 1;
		}
		SetPVarInt_(playerid, "pAgentMode", true);
		SendClientMessage(playerid, COLOR_YELLOW, "������Ʈ ��带 �����մϴ�.");
		AgentLog(playerid, "������Ʈ ��带 �����մϴ�.");
		return 1;
	}
	
	if (!GetPVarInt_(playerid, "pAgentMode")) return 0;
	else if (!strcmp(cmd, "/Ŭ��ŷ", true) || !strcmp(cmd, "/cloaking", true))
	{
		if (GetPlayerVirtualWorld(playerid) != VirtualWorld_Agent(0))
		{
			SetPVarInt_(playerid, "pAgentVw", GetPlayerVirtualWorld(playerid));
			SetPlayerVirtualWorld(playerid, VirtualWorld_Agent(0));
			SetDynamicObjectPos(PositionObject[playerid], 0.0, 0.0, 0.0);
			GameTextForPlayer(playerid, "Cloaked", 1000, 2);
			AgentLog(playerid, "Ŭ��ŷ�Ͽ����ϴ�.");
		}
		else
		{
			SetPlayerVirtualWorld(playerid, GetPVarInt_(playerid, "pAgentVw"));
			DeletePVar_(playerid, "pAgentVw");
			GameTextForPlayer(playerid, "Uncloaked", 1000, 2);
			AgentLog(playerid, "Ŭ��ŷ�� �����߽��ϴ�.");
		}
		return 1;
	}
	else if (!strcmp(cmd, "/������Ʈ���", true))
	{
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /������Ʈ��� [�÷��̾�]");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		new Float:x, Float:y, Float:z, Float:a;
		GetDynamicObjectPos(PositionObject[destid], x, y, z);
		GetPlayerFacingAngle(destid, a);
		x += 1.0 * floatsin(-a, degrees);
		y += 1.0 * floatcos(-a, degrees);
		SetPlayerPos(playerid, x, y, z);
		SetPlayerFacingAngle(playerid, a + 180.0);
		SetCameraBehindPlayer(playerid);
		SetPlayerInterior(playerid, GetPlayerInterior(destid));
		format(str, sizeof(str), "%s�Կ��� ����߽��ϴ�.", GetPlayerNameA(destid));
		AgentLog(playerid, str);
		return 1;
	}
	
	return 0;
}
//-----< dResponseHandler >-----------------------------------------------------
public dResponseHandler_Agent(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----< AgentLog >-------------------------------------------------------------
stock AgentLog(playerid, result[])
{
	new File:fHandle,
		str[256],
		year, month, day,
		hour, minute, second;
	getdate(year, month, day);
	format(str, sizeof(str), "AgentLog/%s_%d��%d��%d��.txt", GetPlayerNameA(playerid), year, month, day);
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
