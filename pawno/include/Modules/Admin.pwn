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
	if(CallLocalFunction("OnPlayerAdminCommandText", "ds", playerid, FixBlankString(cmdtext)))
	{
		new str[256];
		format(str, sizeof(str), "��ɾ� ���: %s", cmdtext);
		if(GetPVarInt(playerid, "pAgent"))
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

	if(!GetPVarInt(playerid, "pAgent")) return 0;
	else if(!strcmp(cmd, "/������Ʈ", true) || !strcmp(cmd, "/agent", true))
	{
		if(GetPVarInt(playerid, "pAgentMode"))
		{
			DeletePVar(playerid, "pAgentMode");
			UnloadPlayerItemData(playerid);
			LoadPlayerItemData(playerid);
			SendClientMessage(playerid, COLOR_YELLOW, "������Ʈ ��带 �����߽��ϴ�.");
			AgentLog(playerid, "������Ʈ ��带 �����߽��ϴ�.");
			return 1;
		}
		SetPVarInt(playerid, "pAgentMode", true);
		LoadPlayerItemData(playerid);
		for(new i = 0, t = GetMaxPlayerItems(); i < t; i++)
			if(IsValidPlayerItemID(playerid, i))
				DestroyPlayerItem(playerid, i);
		SendClientMessage(playerid, COLOR_YELLOW, "������Ʈ ��带 �����մϴ�.");
		AgentLog(playerid, "������Ʈ ��带 �����մϴ�.");
		return 1;
	}

	if(GetPVarInt(playerid, "pAdmin") < 1
	&& !IsGrantedCommand(playerid, cmd)) return 0;
	else if(!strcmp(cmd, "/�����ڵ���", true) || !strcmp(cmd, "/adminhelp", true) || !strcmp(cmd, "/ah", true))
	{
		new help[2048];
		strcat(help, ""C_PASTEL_YELLOW"- ���� -"C_WHITE"\n\
		/ü��, /�Ƹ�, /��������, /�����˻�, /���׸���, /���߾����, /��Ų, /��Ų����, /������, /��, /����\n\
		/����, /��ɾ���Ѻο�, /��ɾ����ȸ��, /�������ӵ�, /��������Ͽ���, /�α��α�Ͽ���, /���ȿ���, /��ǰ����\n\
		\n");
		strcat(help, ""C_PASTEL_YELLOW"- �ൿ -"C_WHITE"\n\
		/����, /Ŭ��ŷ\n\
		\n");
		strcat(help, ""C_PASTEL_YELLOW"- �̵� -"C_WHITE"\n\
		/���, /��ȯ, /��ũ, /��ũ��, /�ڷ���Ʈ, /�λ�, /����, /��, /�ǹ���\n\
		\n");
		strcat(help, ""C_PASTEL_YELLOW"- ���� -"C_WHITE"\n\
		/�ǹ�����, /�ǹ�����, /�����ۻ���, /����������\n\
		\n");
		strcat(help, ""C_PASTEL_YELLOW"- ����� -"C_WHITE"\n\
		/����������Ʈ, /����, /ī�޶�����, /���ӵ�, /�ִ��ε���, /����Ⱦ׼�, /������Ʈ����\n\
		\n");
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "������ ����", help, "�ݱ�", "");
		return 1;
	}
	//
	// ����
	//
	else if(!strcmp(cmd, "/ü��", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /ü�� [�÷��̾�] [��]");
		destid = ReturnUser(cmd);
		if(!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /ü�� [�÷��̾�] [��]");
		new Float:h = floatstr(cmd);
		new Float:bh = GetPlayerHealthA(destid);
		SetPlayerHealth(destid, h);
		format(str, sizeof(str), "%s���� ü���� �����߽��ϴ�. %f > %f", GetPlayerNameA(destid), bh, h);
		SendClientMessage(playerid, COLOR_WHITE, str);
		SendClientMessage(destid, COLOR_WHITE, "�����ڿ� ���� ü���� �����Ǿ����ϴ�.");
		return 1;
	}
	else if(!strcmp(cmd, "/�Ƹ�", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /�Ƹ� [�÷��̾�] [��]");
		destid = ReturnUser(cmd);
		if(!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /�Ƹ� [�÷��̾�] [��]");
		new Float:a = floatstr(cmd);
		new Float:ba = GetPlayerArmourA(destid);
		SetPlayerArmour(destid, a);
		format(str, sizeof(str), "%s���� �ƸӸ� �����߽��ϴ�. %f > %f", GetPlayerNameA(destid), ba, a);
		SendClientMessage(playerid, COLOR_WHITE, str);
		SendClientMessage(destid, COLOR_WHITE, "�����ڿ� ���� �ƸӰ� �����Ǿ����ϴ�.");
		return 1;
	}
	else if(!strcmp(cmd, "/��������", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /�������� [�÷��̾�] [����] [�迭] [��]");
		destid = ReturnUser(cmd);
		if(!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		SetPVarInt(playerid, "EditPVar_destid", destid);
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /�������� [�÷��̾�] [����] [�迭] [��]");
		SetPVarString(playerid, "EditPVar_varname", cmd);
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /�������� [�÷��̾�] [����] [�迭] [��]");
		SetPVarInt(playerid, "EditPVar_array", strval(cmd));
		strcpy(cmd, stringslice_c(cmdtext, 4));
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /�������� [�÷��̾�] [����] [�迭] [��]");
		SetPVarString(playerid, "EditPVar_value", cmd);
		format(str, sizeof(str), "��������: %s(%d)", GetPlayerNameA(destid), destid);
		ShowPlayerDialog(playerid, DialogId_Admin(0), DIALOG_STYLE_LIST, str, "INTEGER\nFLOAT\nSTRING", "Ȯ��", "���");
		return 1;
	}
	else if(!strcmp(cmd, "/�����˻�", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /�����˻� [�÷��̾�] [����] [�迭]");
		destid = ReturnUser(cmd);
		if(!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /�����˻� [�÷��̾�] [����] [�迭]");
		new varname[64];
		strcpy(varname, cmd);
		cmd = strtok(cmdtext, idx);
		new array = (strlen(cmd))?strval(cmd):0;
		format(str, sizeof(str), "- %s���� %s", GetPlayerNameA(destid), varname);
		SendClientMessage(playerid, COLOR_YELLOW, str);
		format(str, sizeof(str), "  INTEGER: %d", GetPVarInt(playerid, varname, array));
		SendClientMessage(playerid, COLOR_YELLOW, str);
		format(str, sizeof(str), "  FLOAT: %f", GetPVarFloat(playerid, varname, array));
		SendClientMessage(playerid, COLOR_YELLOW, str);
		format(str, sizeof(str), "  STRING: %s", GetPVarString(playerid, varname, array));
		SendClientMessage(playerid, COLOR_YELLOW, str);
		return 1;
	}
	else if(!strcmp(cmd, "/���׸���", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /���׸��� [�÷��̾�] [��]");
		destid = ReturnUser(cmd);
		if(!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /���׸��� [�÷��̾�] [��]");
		new interior = strval(cmd);
		new binterior = GetPlayerInterior(destid);
		SetPlayerInterior(destid, interior);
		format(str, sizeof(str), "%s���� ���׸�� �����߽��ϴ�. %d > %d", GetPlayerNameA(destid), binterior, interior);
		SendClientMessage(playerid, COLOR_WHITE, str);
		SendClientMessage(destid, COLOR_WHITE, "�����ڿ� ���� ���׸�� ����Ǿ����ϴ�.");
		return 1;
	}
	else if(!strcmp(cmd, "/���߾����", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /���߾���� [�÷��̾�] [��]");
		destid = ReturnUser(cmd);
		if(!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /���߾���� [�÷��̾�] [��]");
		new virtualworld = strval(cmd);
		new bvirtualworld = GetPlayerVirtualWorld(destid);
		SetPlayerVirtualWorld(destid, virtualworld);
		format(str, sizeof(str), "%s���� ���߾���带 �����߽��ϴ�. %d > %d", GetPlayerNameA(destid), bvirtualworld, virtualworld);
		SendClientMessage(playerid, COLOR_WHITE, str);
		SendClientMessage(destid, COLOR_WHITE, "�����ڿ� ���� ���߾���尡 ����Ǿ����ϴ�.");
		return 1;
	}
	else if(!strcmp(cmd, "/��Ų", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /��Ų [�÷��̾�] [��]");
		destid = ReturnUser(cmd);
		if(!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /��Ų [�÷��̾�] [��]");
		new skin = strval(cmd);
		new bskin = GetPlayerSkin(destid);
		SetPlayerSkin(playerid, skin);
		format(str, sizeof(str), "%s���� ��Ų�� �����߽��ϴ�. %d > %d", GetPlayerNameA(destid), bskin, skin);
		SendClientMessage(playerid, COLOR_WHITE, str);
		SendClientMessage(destid, COLOR_WHITE, "�����ڿ� ���� ��Ų�� ����Ǿ����ϴ�.");
		return 1;
	}
	else if(!strcmp(cmd, "/��Ų����", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /��Ų���� [�÷��̾�]");
		destid = ReturnUser(cmd);
		if(!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		new list[300], colors[300];
		for(new i = 0; i < sizeof(list); i++)
			list[i] = i;
		MpListData[playerid][0] = destid;
		ShowPlayerMpList(playerid, MpListId_Admin(1), "Skins", list, colors, sizeof(list));
		return 1;
	}
	else if(!strcmp(cmd, "/������", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /������ [�÷��̾�]");
		destid = ReturnUser(cmd);
		if(!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		SpawnPlayer_(destid);
		format(str, sizeof(str), "%s���� ���������׽��ϴ�.", GetPlayerNameA(destid));
		SendClientMessage(playerid, COLOR_WHITE, str);
		SendClientMessage(destid, COLOR_WHITE, "�����ڿ� ���� �������Ǿ����ϴ�.");
		return 1;
	}
	else if(!strcmp(cmd, "/��", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /�� [�÷��̾�]");
		destid = ReturnUser(cmd);
		if(!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		TogglePlayerControllable(playerid, 0);
		format(str, sizeof(str), "%s���� ��Ƚ��ϴ�.", GetPlayerNameA(destid));
		SendClientMessage(playerid, COLOR_WHITE, str);
		SendClientMessage(playerid, COLOR_WHITE, "�����ڿ� ���� ������ϴ�.");
		return 1;
	}
	else if(!strcmp(cmd, "/����", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /���� [�÷��̾�]");
		destid = ReturnUser(cmd);
		if(!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		TogglePlayerControllable(playerid, 1);
		format(str, sizeof(str), "%s���� �쿴���ϴ�.", GetPlayerNameA(destid));
		SendClientMessage(playerid, COLOR_WHITE, str);
		SendClientMessage(playerid, COLOR_WHITE, "�����ڿ� ���� ��ҽ��ϴ�.");
		return 1;
	}
	else if(!strcmp(cmd, "/����", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /���� [�÷��̾�]");
		destid = ReturnUser(cmd);
		if(!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		new list[MAX_WEAPONS], colors[MAX_WEAPONS], items;
		for(new i = 0; i < MAX_WEAPONS; i++)
			if(GetWeaponObjectModelID(i) != 1575)
			{
				list[items] = GetWeaponObjectModelID(i);
				items++;
			}
		MpListData[playerid][0] = destid;
		ShowPlayerMpList(playerid, MpListId_Admin(0), "Weapons", list, colors, items);
		return 1;
	}
	else if(!strcmp(cmd, "/��ɾ���Ѻο�", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /��ɾ���Ѻο� [�÷��̾�] [��ɾ�]");
		destid = ReturnUser(cmd);
		if(!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /��ɾ���Ѻο� [�÷��̾�] [��ɾ�]");
		GrantCommand(destid, cmd);
		format(str, sizeof(str), "%s�Կ��� "C_BLUE"%s"C_YELLOW"�� ��� ������ �ο��߽��ϴ�.", GetPlayerNameA(destid), cmd);
		SendClientMessage(playerid, COLOR_YELLOW, str);
		format(str, sizeof(str), "�����ڰ� "C_BLUE"%s"C_YELLOW"�� ��� ������ �ο��߽��ϴ�.", cmd);
		SendClientMessage(destid, COLOR_YELLOW, str);
		return 1;
	}
	else if(!strcmp(cmd, "/��ɾ����ȸ��", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /��ɾ����ȸ�� [�÷��̾�] [��ɾ�]");
		destid = ReturnUser(cmd);
		if(!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /��ɾ����ȸ�� [�÷��̾�] [��ɾ�]");
		RevokeCommand(destid, cmd);
		format(str, sizeof(str), "%s�����κ��� "C_BLUE"%s"C_YELLOW"�� ��� ������ ȸ���߽��ϴ�.", GetPlayerNameA(destid), cmd);
		SendClientMessage(playerid, COLOR_YELLOW, str);
		format(str, sizeof(str), "�����ڰ� "C_BLUE"%s"C_YELLOW"�� ��� ������ ȸ���߽��ϴ�.", cmd);
		SendClientMessage(destid, COLOR_YELLOW, str);
		return 1;
	}
	else if(!strcmp(cmd, "/�������ӵ�", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /�������ӵ� [�÷��̾�] [���ӵ�]");
		destid = ReturnUser(cmd);
		if(!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /�������ӵ� [�÷��̾�] [���ӵ�]");
		SetPVarFloat(playerid, "pAccel", floatstr(cmd));
		format(str, sizeof(str), "�����ڿ� ���� �������ӵ� ���� - %.4f", floatstr(cmd));
		SendClientMessage(destid, COLOR_YELLOW, str);
		format(str, sizeof(str), "%s���� �������ӵ� ���� - %.4f", GetPlayerNameA(destid), floatstr(cmd));
		SendClientMessage(playerid, COLOR_YELLOW, str);
		return 1;
	}
	else if(!strcmp(cmd, "/��������Ͽ���", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /��������Ͽ��� [�÷��̾�]");
		destid = ReturnUser(cmd);
		if(!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		ShowPlayerDamageLog(playerid, destid);
		return 1;
	}
	else if(!strcmp(cmd, "/�α��α�Ͽ���", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /�α��α�Ͽ��� [�÷��̾�]");
		destid = ReturnUser(cmd);
		if(!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		ShowPlayerLoginTryLog(playerid, destid);
		return 1;
	}
	else if(!strcmp(cmd, "/���ȿ���", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /���ȿ��� [�÷��̾�]");
		destid = ReturnUser(cmd);
		if(!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		ShowPlayerStatus(playerid, destid);
		return 1;
	}
	else if(!strcmp(cmd, "/��ǰ����", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /��ǰ���� [�÷��̾�] [������ġ]");
		destid = ReturnUser(cmd);
		if(!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /��ǰ���� [�÷��̾�] [������ġ]");
		ShowPlayerItemList(playerid, destid, 0, cmd);
		return 1;
	}
	//
	// �ൿ
	//
	else if(!strcmp(cmd, "/����", true))
	{
		if(GetPVarType(playerid, "FlyMode")) CancelFlyMode(playerid);
		else FlyMode(playerid);
		return 1;
	}
	else if(!strcmp(cmd, "/Ŭ��ŷ", true) || !strcmp(cmd, "/cloaking", true))
	{
		if(GetPlayerVirtualWorld(playerid) != VirtualWorld_Position(0))
		{
			SetPVarInt(playerid, "pClockingVw", GetPlayerVirtualWorld(playerid));
			SetPlayerVirtualWorld(playerid, VirtualWorld_Position(0));
			SetDynamicObjectPos(PositionObject[playerid], 0.0, 0.0, 0.0);
			GameTextForPlayer(playerid, "Cloaked", 1000, 2);
			AgentLog(playerid, "Ŭ��ŷ�Ͽ����ϴ�.");
		}
		else
		{
			SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "pClockingVw"));
			DeletePVar(playerid, "pClockingVw");
			GameTextForPlayer(playerid, "Uncloaked", 1000, 2);
			AgentLog(playerid, "Ŭ��ŷ�� �����߽��ϴ�.");
		}
		return 1;
	}
	//
	// �̵�
	//
	else if(!strcmp(cmd, "/���", true) || !strcmp(cmd, "/��", true)  || !strcmp(cmd, "/����", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /��� [�÷��̾�]");
		destid = ReturnUser(cmd);
		if(!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
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
	else if(!strcmp(cmd, "/��ȯ", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /��ȯ [�÷��̾�]");
		destid = ReturnUser(cmd);
		if(!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
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
		SendClientMessage(destid, COLOR_WHITE, "�����ڿ� ���� ��ȯ�Ǿ����ϴ�.");
		return 1;
	}
	else if(!strcmp(cmd, "/��ũ", true))
	{
		GetPlayerPos(playerid, Mark[playerid][0], Mark[playerid][1], Mark[playerid][2]);
		GetPlayerFacingAngle(playerid, Mark[playerid][3]);
		MarkInterior[playerid] = GetPlayerInterior(playerid);
		MarkVirtualWorld[playerid] = GetPlayerVirtualWorld(playerid);
		SendClientMessage(playerid, COLOR_WHITE, "���� ��ġ�� ��ũ�Ǿ����ϴ�.");
		return 1;
	}
	else if(!strcmp(cmd, "/��ũ��", true))
	{
		SetPlayerPos(playerid, Mark[playerid][0], Mark[playerid][1], Mark[playerid][2]);
		SetPlayerFacingAngle(playerid, Mark[playerid][3]);
		SetCameraBehindPlayer(playerid);
		SetPlayerInterior(playerid, MarkInterior[playerid]);
		SetPlayerVirtualWorld(playerid, MarkVirtualWorld[playerid]);
		return 1;
	}
	else if(!strcmp(cmd, "/�ڷ���Ʈ", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /�ڷ���Ʈ [��ǥ]");
		new pos[3][10];
		split(cmd, pos, ',');
		SetPlayerPos(playerid, floatstr(pos[0]), floatstr(pos[1]), floatstr(pos[2]));
		return 1;
	}
	else if(!strcmp(cmd, "/�λ�", true))
	{
		if(IsPlayerInAnyVehicle(playerid))
			SetVehiclePos(GetPlayerVehicleID(playerid), 1531.4265, -1676.7639, 13.3828 + 2.0);
		else
			SetPlayerPos(playerid, 1531.4265, -1676.7639, 13.3828 + 2.0);
		SetPlayerInterior(playerid, 0);
		return 1;
	}
	else if(!strcmp(cmd, "/����", true))
	{
		if(IsPlayerInAnyVehicle(playerid))
			SetVehiclePos(GetPlayerVehicleID(playerid), -1422.2572, -289.8291, 14.1484 + 2.0);
		else
			SetPlayerPos(playerid, -1422.2572, -289.8291, 14.1484 + 2.0);
		SetPlayerInterior(playerid, 0);
		return 1;
	}
	else if(!strcmp(cmd, "/��", true))
	{
		if(IsPlayerInAnyVehicle(playerid))
			SetVehiclePos(GetPlayerVehicleID(playerid), 1679.5079, 1448.0795, 47.7813 + 2.0);
		else
			SetPlayerPos(playerid, 1679.5079, 1448.0795, 47.7813 + 2.0);
		SetPlayerInterior(playerid, 0);
		return 1;
	}
	else if(!strcmp(cmd, "/�ǹ���", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /�ǹ��� [�ǹ���ȣ]");
		destid = strval(cmd);
		if(!IsValidPropertyID(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �ǹ��Դϴ�.");
		if(GetPVarInt(playerid, "pAgent"))
		{
			if(!GetPropertyEnable(destid))
				return SendClientMessage(playerid, COLOR_WHITE, "�̹� �ٸ� ������Ʈ�� ����߽��ϴ�.");
			else
				TogglePropertyEnable(destid, false);
		}
		SetPlayerPosToProperty(playerid, destid);
		return 1;
	}
	//
	// ����
	//
	else if(!strcmp(cmd, "/�ǹ�����", true))
	{
		CreateProperty();
		SendClientMessage(playerid, COLOR_WHITE, "�ǹ��� �����߽��ϴ�. '/�ǹ�����'���� �����ϼ���.");
		return 1;
	}
	else if(!strcmp(cmd, "/�ǹ�����", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return ShowPropertyList(playerid, DialogId_Admin(1));
		destid = strval(cmd);
		if(!IsValidPropertyID(destid))
		for(new i = 0, t = GetMaxProperties(); i < t; i++)
			if(IsValidPropertyID(i) && GetPropertyDBID(i) == destid)
				return ShowPropertyModifier(playerid, i);
		SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �ǹ��Դϴ�.");
		return 1;
	}
	else if(!strcmp(cmd, "/�����ۻ���", true))
	{
		/*strcpy(cmd, stringslice_c(cmdtext, 1));
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /�����ۻ��� [�̸�]");
		new Float:x, Float:y, Float:z, Float:a;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
		CreateItem(cmd, x, y, z + GetItemZVariation(cmd), a, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), 0, chEmpty);*/
		ShowItemModelList(playerid, DialogId_Admin(2));
		return 1;
	}
	else if(!strcmp(cmd, "/����������", true))
	{
		new itemid = GetPlayerNearestItem(playerid);
		if(!IsValidItemID(itemid))
			return SendClientMessage(playerid, COLOR_WHITE, "��ó�� ������ �������� �����ϴ�.");
		DestroyItem(itemid);
		return 1;
	}
	//
	// �����
	//
	else if(!strcmp(cmd, "/����������Ʈ", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /����������Ʈ [�÷��̾�]");
		destid = ReturnUser(cmd);
		if(!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		DialogData[playerid][0] = destid;
		ShowPlayerDialog(playerid, DialogId_Admin(3), DIALOG_STYLE_LIST, "����������Ʈ", "���\n����\n����", "Ȯ��", "���");
		return 1;
	}
	else if(!strcmp(cmd, "/����", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /���� [�÷��̾�] ([URL])");
		destid = ReturnUser(cmd);
		if(!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		strcpy(cmd, stringslice_c(cmdtext, 2));
		if(!strlen(cmd))
			return StopAudioStreamForPlayer(destid);
		PlayAudioStreamForPlayer(destid, cmd);
		return 1;
	}
	else if(!strcmp(cmd, "/ī�޶�����", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /ī�޶����� [�÷��̾�]");
		destid = ReturnUser(cmd);
		if(!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		new Float:px, Float:py, Float:pz,
			Float:vx, Float:vy, Float:vz,
			dstr[256];
		GetPlayerCameraPos(destid, px, py, pz);
		GetPlayerCameraFrontVector(destid, vx, vy, vz);
		strcpy(dstr, chNullString);
		strcat(dstr, C_LIGHTGREEN);
		strtab(dstr, "�̸�", 13);
		strcat(dstr, C_WHITE);
		strcat(dstr, GetPlayerNameA(destid));
		strcat(dstr, "\n");
		strcat(dstr, C_LIGHTGREEN);
		strtab(dstr, "ī�޶���ǥ", 13);
		strcat(dstr, C_WHITE);
		format(str, sizeof(str), "%.4f, %.4f, %.4f", px, py, pz);
		strcat(dstr, str);
		strcat(dstr, "\n");
		strcat(dstr, C_LIGHTGREEN);
		strtab(dstr, "ī�޶���", 13);
		strcat(dstr, C_WHITE);
		format(str, sizeof(str), "%.4f, %.4f, %.4f", vx, vy, vz);
		strcat(dstr, str);
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "ī�޶�����", dstr, "Ȯ��", chNullString);
		return 1;
	}
	else if(!strcmp(cmd, "/���ӵ�", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /���ӵ� [�÷��̾�] ([��])");
		destid = ReturnUser(cmd);
		if(!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
		{
			new Float:x, Float:y, Float:z;
			GetPlayerVelocity(destid, x, y, z);
			format(str, sizeof(str), "%s���� ���ӵ�: %.4f, %.4f, %.4f", GetPlayerNameA(destid), x, y, z);
			SendClientMessage(playerid, COLOR_WHITE, str);
			return 1;
		}
		new velocity[3][16];
		split(cmd, velocity, ',');
		SetPlayerVelocity(destid, floatstr(velocity[0]), floatstr(velocity[1]), floatstr(velocity[2]));
		format(str, sizeof(str), "%s���� ���ӵ�: %.4f, %.4f, %.4f", GetPlayerNameA(destid), floatstr(velocity[0]), floatstr(velocity[1]), floatstr(velocity[2]));
		SendClientMessage(playerid, COLOR_WHITE, str);
		return 1;
	}
	else if(!strcmp(cmd, "/�ִ��ε���", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /�ִ��ε��� [�÷��̾�] ([��])");
		destid = ReturnUser(cmd);
		if(!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		format(str, sizeof(str), "%s���� �ִϸ��̼� �ε���: %d", GetPlayerNameA(destid), GetPlayerAnimationIndex(destid));
		SendClientMessage(playerid, COLOR_WHITE, str);
		return 1;
	}
	else if(!strcmp(cmd, "/����Ⱦ׼�", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /����Ⱦ׼� [�÷��̾�] ([��])");
		destid = ReturnUser(cmd);
		if(!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
		{
			format(str, sizeof(str), "%s���� ����� �׼�: %d", GetPlayerNameA(destid), GetPlayerSpecialAction(destid));
			SendClientMessage(playerid, COLOR_WHITE, str);
			return 1;
		}
		SetPlayerSpecialAction(playerid, strval(cmd));
		format(str, sizeof(str), "%s���� ����� �׼�: %d", GetPlayerNameA(destid), strval(cmd));
		SendClientMessage(playerid, COLOR_WHITE, str);
		return 1;
	}
	else if(!strcmp(cmd, "/������Ʈ����", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /������Ʈ���� [�÷��̾�]");
		destid = ReturnUser(cmd);
		if(!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		SelectObject(destid);
		return 1;
	}
	return 0;
}
//-----< dResponseHandler >-----------------------------------------------------
public dResponseHandler_Admin(playerid, dialogid, response, listitem, inputtext[])
{
	new str[256], destid, receive[4][16];
	switch(dialogid - DialogId_Admin(0))
	{
		case 0:
		{
			if(response)
			{
				destid = GetPVarInt(playerid, "EditPVar_destid");
				if(!IsPlayerConnected(destid))
					return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
				new varname[64];
				strcpy(varname, GetPVarString(playerid, "EditPVar_varname"));
				new array = GetPVarInt(playerid, "EditPVar_array");
				strcpy(str, GetPVarString(playerid, "EditPVar_value"));
				switch(listitem)
				{
					case 0:
						SetPVarInt(destid, varname, strval(str), array);
					case 1:
						SetPVarFloat(destid, varname, floatstr(str), array);
					default:
						SetPVarString(destid, varname, str, array);
				}
				format(str, sizeof(str), "%s���� %s���� %s ����: %s", GetPlayerNameA(playerid), GetPlayerNameA(destid), varname, str);
				SendAdminMessage(COLOR_YELLOW, str, 0);
			}
			SetPVarInt(playerid, "EditPVar_destid", 0);
			SetPVarString(playerid, "EditPVar_varname", chNullString);
			SetPVarString(playerid, "EditPVar_value", chNullString);
		}
		case 1:
			if(response)
				ShowPropertyModifier(playerid, DialogData[playerid][listitem]);
		case 2:
			if(response && listitem)
			{
				DialogData[playerid][0] = listitem - 1;
				format(str, sizeof(str), ""C_GREEN"%s"C_WHITE"��(��) �� �� �����Ͻðڽ��ϱ�?", GetItemModelName(listitem - 1));
				ShowPlayerDialog(playerid, DialogId_Admin(17), DIALOG_STYLE_INPUT, "����", str, "Ȯ��", "�ڷ�");
			}
		case 3:
			if(response)
			{
				destid = DialogData[playerid][0];
				switch(listitem)
				{
					case 0: ShowAttachedObjectList(playerid, destid, DialogId_Admin(4));
					case 1: ShowAttachedObjectList(playerid, destid, DialogId_Admin(6));
					case 2: ShowAttachedObjectList(playerid, destid, DialogId_Admin(9));
				}
			}
		case 4:
		{
			if(response)
			{
				destid = DialogData[playerid][0];
				if(!listitem)
					return ShowAttachedObjectList(playerid, destid, DialogId_Admin(4));
				new index = listitem - 1;
				if(!IsPlayerAttachedObjectSlotUsed(destid, index))
				{
					SendClientMessage(playerid, COLOR_WHITE, "������� �ʴ� �ε����Դϴ�.");
					ShowAttachedObjectList(playerid, destid, DialogId_Admin(4));
					return 1;
				}
				ShowAttachedObjectModifier(playerid, destid, index, DialogId_Admin(5), DIALOG_STYLE_MSGBOX);
			}
			else ShowPlayerDialog(playerid, DialogId_Admin(3), DIALOG_STYLE_LIST, "����������Ʈ", "���\n����\n����", "Ȯ��", "���");
		}
		case 5:
			if(!response)
				ShowAttachedObjectList(playerid, destid, DialogId_Admin(4));
		case 6:
		{
			if(response)
			{
				destid = DialogData[playerid][0];
				if(!listitem)
					return ShowAttachedObjectList(playerid, destid, DialogId_Admin(6));
				new index = listitem - 1;
				DialogData[playerid][1] = index;
				if(!IsPlayerAttachedObjectSlotUsed(destid, index))
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
			else ShowPlayerDialog(playerid, DialogId_Admin(3), DIALOG_STYLE_LIST, "����������Ʈ", "���\n����\n����", "Ȯ��", "���");
		}
		case 7:
		{
			destid = DialogData[playerid][0];
			if(response)
			{
				new index = DialogData[playerid][1];
				if(!listitem)
					return ShowAttachedObjectModifier(playerid, destid, index, DialogId_Admin(7), DIALOG_STYLE_LIST);
				DialogData[playerid][2] = listitem;
				switch(listitem)
				{
					case 1: format(str, sizeof(str), "���� Model: %d", AttachedObjectInfo[destid][index][aoModel]);
					case 2: format(str, sizeof(str), "���� Bone: %d", AttachedObjectInfo[destid][index][aoBone]);
					case 3: format(str, sizeof(str), "���� Offset: %.4f,%.4f,%.4f",
								AttachedObjectInfo[destid][index][aoOffset][0],
								AttachedObjectInfo[destid][index][aoOffset][1],
								AttachedObjectInfo[destid][index][aoOffset][2]);
					case 4: format(str, sizeof(str), "���� Rot: %.4f,%.4f,%.4f",
								AttachedObjectInfo[destid][index][aoRot][0],
								AttachedObjectInfo[destid][index][aoRot][1],
								AttachedObjectInfo[destid][index][aoRot][2]);
					case 5: format(str, sizeof(str), "���� Scale: %.4f,%.4f,%.4f",
								AttachedObjectInfo[destid][index][aoScale][0],
								AttachedObjectInfo[destid][index][aoScale][1],
								AttachedObjectInfo[destid][index][aoScale][2]);
					case 6: format(str, sizeof(str), "���� MColor: %d,%d",
								AttachedObjectInfo[destid][index][aoMColor][0],
								AttachedObjectInfo[destid][index][aoMColor][1]);
				}
				ShowPlayerDialog(playerid, DialogId_Admin(8), DIALOG_STYLE_INPUT, "����������Ʈ", str, "Ȯ��", "���");
			}
			else ShowAttachedObjectList(playerid, destid, DialogId_Admin(6));
		}
		case 8:
		{
			destid = DialogData[playerid][0];
			new index = DialogData[playerid][1];
			if(response && strlen(inputtext))
			{
				switch(DialogData[playerid][2])
				{
					case 1: AttachedObjectInfo[destid][index][aoModel] = strval(inputtext);
					case 2: AttachedObjectInfo[destid][index][aoBone] = strval(inputtext);
					case 3:
					{
						split(inputtext, receive, ',');
						for(new i = 0; i < 3; i++)
							AttachedObjectInfo[destid][index][aoOffset][i] = floatstr(receive[i]);
					}
					case 4:
					{
						split(inputtext, receive, ',');
						for(new i = 0; i < 3; i++)
							AttachedObjectInfo[destid][index][aoRot][i] = floatstr(receive[i]);
					}
					case 5:
					{
						split(inputtext, receive, ',');
						for(new i = 0; i < 3; i++)
							AttachedObjectInfo[destid][index][aoScale][i] = floatstr(receive[i]);
					}
					case 6:
					{
						split(inputtext, receive, ',');
						for(new i = 0; i < 2; i++)
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
			if(response)
			{
				destid = DialogData[playerid][0];
				if(!listitem)
					return ShowAttachedObjectList(playerid, destid, DialogId_Admin(9));
				RemovePlayerAttachedObject(playerid, listitem - 1);
				ShowAttachedObjectList(playerid, destid, DialogId_Admin(9));
			}
			else ShowPlayerDialog(playerid, DialogId_Admin(3), DIALOG_STYLE_LIST, "����������Ʈ", "���\n����\n����", "Ȯ��", "���");
		}
		case 16:
		{
			if(response)
			{
				GivePlayerWeapon(MpListData[playerid][0], MpListData[playerid][1], strval(inputtext));
				format(str, sizeof(str), "%s�Բ� "C_BLUE"%s"C_WHITE"��(��) %d�� ��Ƚ��ϴ�.", GetPlayerNameA(MpListData[playerid][0]), GetWeaponNameA(MpListData[playerid][1]), strval(inputtext));
				SendClientMessage(playerid, COLOR_WHITE, str);
				format(str, sizeof(str), "�����ڰ� "C_BLUE"%s"C_WHITE"��(��) %d�� �ּ̽��ϴ�.", GetWeaponNameA(MpListData[playerid][1]), strval(inputtext));
				SendClientMessage(MpListData[playerid][0], COLOR_WHITE, str);
			}
			else
			{
				format(str, sizeof(str), "/���� %d", MpListData[playerid][0]);
				OnPlayerCommandText(playerid, str);
			}
		}
		case 17:
		{
			if(response)
			{
				new itemid = DialogData[playerid][0] - 1,
					amount = strval(inputtext);
				if(amount <= 0) ReshowDialog(playerid);
				new Float:x, Float:y, Float:z, Float:a;
				GetPlayerPos(playerid, x, y, z);
				GetPlayerFacingAngle(playerid, a);
				CreateItem(itemid, x, y, z, a, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), chEmpty, amount);
			}
			else ShowLastDialog(playerid);
		}
	}
	return 1;
}
//-----< mplResponseHandler >---------------------------------------------------
public mplResponseHandler_Admin(playerid, mplistid, selecteditem)
{
	new str[256];
	switch(MpListId_Admin(0) - mplistid)
	{
		case 0:
		{
			for(new i = 0; i < MAX_WEAPONS; i++)
				if(GetWeaponObjectModelID(i) == selecteditem)
				{
					MpListData[playerid][1] = i;
					format(str, sizeof(str), ""C_WHITE"%s�Կ��� "C_BLUE"%s"C_WHITE"��(��) �� �� �ֽðڽ��ϱ�?", GetPlayerNameA(MpListData[playerid][0]), GetWeaponNameA(i));
					ShowPlayerDialog(playerid, DialogId_Admin(16), DIALOG_STYLE_INPUT, ""C_BLUE"����", str, "Ȯ��", "�ڷ�");
				}
		}
		case 1:
		{
			SetPlayerSkin(MpListData[playerid][0], selecteditem);
			format(str, sizeof(str), "%s���� ��Ų�� �����߽��ϴ�.", GetPlayerNameA(MpListData[playerid][0]));
			SendClientMessage(playerid, COLOR_WHITE, str);
			SendClientMessage(MpListData[playerid][0], COLOR_WHITE, "�����ڰ� ����� ��Ų�� �����߽��ϴ�.");
		}
	}
	return 1;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----< SendAdminMessage >-----------------------------------------------------
stock SendAdminMessage(color, message[], level=1)
{
	for(new i = 0, t = GetMaxPlayers(); i < t; i++)
	{
		new alevel = GetPVarInt(i, "pAdmin");
		if(alevel && alevel >= level
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
	for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
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
	ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, "����������Ʈ", str, "Ȯ��", "���");
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
	ShowPlayerDialog(playerid, dialogid, dialogstyle, "����������Ʈ", str, "Ȯ��", "���");
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
	format(str, sizeof(str), "Logs/AdminLog/%s_%d��%d��%d��.txt", GetPlayerNameA(playerid), year, month, day);
	fHandle = fopen(str, io_append);
	if(fHandle)
	{
		gettime(hour, minute, second);
		format(str, sizeof(str), "\r\n[%d:%d:%d] ", hour, minute, second);
		fwrite(fHandle, str);
		for(new i = 0, t = strlen(result); i < t; i++)
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
	format(str, sizeof(str), "Logs/AgentLog/%s_%d��%d��%d��.txt", GetPlayerNameA(playerid), year, month, day);
	fHandle = fopen(str, io_append);
	if(fHandle)
	{
		gettime(hour, minute, second);
		format(str, sizeof(str), "\r\n[%d:%d:%d] ", hour, minute, second);
		fwrite(fHandle, str);
		for(new i = 0, t = strlen(result); i < t; i++)
			fputchar(fHandle, result[i], false);
	}
	fclose(fHandle);
}
//-----<  >---------------------------------------------------------------------
