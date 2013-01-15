/*
 *
 *
 *		PureunBa(������)
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
 *		Update:		2013/01/15
 *
 *
 */
/*

  < Callbacks >
	pCommandTextHandler_Admin(playerid, cmdtext[])
	dResponseHandler_Admin(playerid, dialogid, response, listitem, inputtext[])

  < Functions >
	SendAdminMessage(color, message[], level=1)

*/



//-----< Variables
new Float:Mark[MAX_PLAYERS][4],
	MarkInterior[MAX_PLAYERS],
	MarkVirtualWorld[MAX_PLAYERS];



//-----< Defines
#define DialogId_Admin(%0)          (50+%0)



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
	else if (!strcmp(cmd, "/�����ڵ���", true) || !strcmp(cmd, "/adminhelp", true) || !strcmp(cmd, "/ah", true))
	{
	    new help[2048];
	    strcat(help, ""C_PASTEL_YELLOW"- ���� -"C_WHITE"\n/ü��, /�Ƹ�, /��������, /�����˻�, /���׸���, /���߾����\n\n");
	    strcat(help, ""C_PASTEL_YELLOW"- �̵� -"C_WHITE"\n/���, /��ȯ, /��ũ, /��ũ��, /�ڷ���Ʈ, /�λ�, /����, /��\n\n");
		strcat(help, ""C_PASTEL_YELLOW"- �ǹ� -"C_WHITE"\n/�ǹ�����, /�ǹ�����\n\n");
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "������ ����", help, "�ݱ�", "");
	    return 1;
	}
	//
	// ����
	//
	else if (!strcmp(cmd, "/ü��", true))
	{
	    cmd = strtok(cmdtext, idx);
	    if (!strlen(cmd))
	        return SendClientMessage(playerid, COLOR_WHITE, "����: /ü�� [�÷��̾�] [��]");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
		    return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
		    return SendClientMessage(playerid, COLOR_WHITE, "����: /ü�� [�÷��̾�] [��]");
		new Float:h = floatstr(cmd);
		new Float:bh = GetPlayerHealthA(destid);
		SetPlayerHealth(destid, h);
		format(str, sizeof(str), "%s���� ü���� �����߽��ϴ�. %f > %f", GetPlayerNameA(destid), bh, h);
		SendClientMessage(playerid, COLOR_WHITE, str);
		SendClientMessage(destid, COLOR_WHITE, "�����ڿ� ���� ü���� �����Ǿ����ϴ�.");
		return 1;
	}
	else if (!strcmp(cmd, "/�Ƹ�", true))
	{
	    cmd = strtok(cmdtext, idx);
	    if (!strlen(cmd))
	        return SendClientMessage(playerid, COLOR_WHITE, "����: /�Ƹ� [�÷��̾�] [��]");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
		    return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
		    return SendClientMessage(playerid, COLOR_WHITE, "����: /�Ƹ� [�÷��̾�] [��]");
		new Float:a = floatstr(cmd);
		new Float:ba = GetPlayerArmourA(destid);
		SetPlayerArmour(destid, a);
		format(str, sizeof(str), "%s���� �ƸӸ� �����߽��ϴ�. %f > %f", GetPlayerNameA(destid), ba, a);
		SendClientMessage(playerid, COLOR_WHITE, str);
		SendClientMessage(destid, COLOR_WHITE, "�����ڿ� ���� �ƸӰ� �����Ǿ����ϴ�.");
		return 1;
	}
	else if (!strcmp(cmd, "/��������", true))
	{
	    cmd = strtok(cmdtext, idx);
	    if (!strlen(cmd))
	        return SendClientMessage(playerid, COLOR_WHITE, "����: /�������� [�÷��̾�] [����] [�迭] [��]");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
		    return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		SetPVarInt_(playerid, "EditPVar_destid", destid);
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
		    return SendClientMessage(playerid, COLOR_WHITE, "����: /�������� [�÷��̾�] [����] [�迭] [��]");
		SetPVarString_(playerid, "EditPVar_varname", cmd);
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
		    return SendClientMessage(playerid, COLOR_WHITE, "����: /�������� [�÷��̾�] [����] [�迭] [��]");
		SetPVarInt_(playerid, "EditPVar_array", strval(cmd));
		strcpy(cmd, stringslice_c(cmdtext, 4));
		if (!strlen(cmd))
		    return SendClientMessage(playerid, COLOR_WHITE, "����: /�������� [�÷��̾�] [����] [�迭] [��]");
		SetPVarString_(playerid, "EditPVar_value", cmd);
		format(str, sizeof(str), "��������: %s(%d)", GetPlayerNameA(destid), destid);
		ShowPlayerDialog(playerid, DialogId_Admin(0), DIALOG_STYLE_LIST, str, "INTEGER\nFLOAT\nSTRING", "Ȯ��", "���");
		return 1;
	}
	else if (!strcmp(cmd, "/�����˻�", true))
	{
	    cmd = strtok(cmdtext, idx);
	    if (!strlen(cmd))
	        return SendClientMessage(playerid, COLOR_WHITE, "����: /�����˻� [�÷��̾�] [����] [�迭]");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
		    return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
        cmd = strtok(cmdtext, idx);
	    if (!strlen(cmd))
	        return SendClientMessage(playerid, COLOR_WHITE, "����: /�����˻� [�÷��̾�] [����] [�迭]");
		new varname[64];
		strcpy(varname, cmd);
        cmd = strtok(cmdtext, idx);
		new array = (strlen(cmd))?strval(cmd):0;
		format(str, sizeof(str), "- %s���� %s", GetPlayerNameA(destid), varname);
		SendClientMessage(playerid, COLOR_YELLOW, str);
		format(str, sizeof(str), "  INTEGER: %d", GetPVarInt_(playerid, varname, array));
		SendClientMessage(playerid, COLOR_YELLOW, str);
		format(str, sizeof(str), "  FLOAT: %f", GetPVarFloat_(playerid, varname, array));
		SendClientMessage(playerid, COLOR_YELLOW, str);
		format(str, sizeof(str), "  STRING: %s", GetPVarString_(playerid, varname, array));
		SendClientMessage(playerid, COLOR_YELLOW, str);
		return 1;
	}
	else if (!strcmp(cmd, "/���׸���", true))
	{
	    cmd = strtok(cmdtext, idx);
	    if (!strlen(cmd))
	        return SendClientMessage(playerid, COLOR_WHITE, "����: /���׸��� [�÷��̾�] [��]");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
		    return SendClientMessage(playerid, COLOR_WHITE, "����: /���׸��� [�÷��̾�] [��]");
		new interior = strval(cmd);
		new binterior = GetPlayerInterior(destid);
		SetPlayerInterior(destid, interior);
		format(str, sizeof(str), "%s���� ���׸�� �����߽��ϴ�. %d > %d", GetPlayerNameA(destid), binterior, interior);
		SendClientMessage(playerid, COLOR_WHITE, str);
		SendClientMessage(destid, COLOR_WHITE, "�����ڿ� ���� ���׸�� �����Ǿ����ϴ�.");
		return 1;
	}
	else if (!strcmp(cmd, "/���߾����", true))
	{
	    cmd = strtok(cmdtext, idx);
	    if (!strlen(cmd))
	        return SendClientMessage(playerid, COLOR_WHITE, "����: /���߾���� [�÷��̾�] [��]");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		cmd = strtok(cmdtext, idx);
		if (!strlen(cmd))
		    return SendClientMessage(playerid, COLOR_WHITE, "����: /���߾���� [�÷��̾�] [��]");
		new virtualworld = strval(cmd);
		new bvirtualworld = GetPlayerInterior(destid);
		SetPlayerInterior(destid, virtualworld);
		format(str, sizeof(str), "%s���� ���߾���带 �����߽��ϴ�. %d > %d", GetPlayerNameA(destid), bvirtualworld, virtualworld);
		SendClientMessage(playerid, COLOR_WHITE, str);
		SendClientMessage(destid, COLOR_WHITE, "�����ڿ� ���� ���߾���尡 �����Ǿ����ϴ�.");
		return 1;
	}
	//
	// �̵�
	//
	else if (!strcmp(cmd, "/���", true) || !strcmp(cmd, "/��", true)  || !strcmp(cmd, "/����", true))
	{
	    cmd = strtok(cmdtext, idx);
	    if (!strlen(cmd))
	        return SendClientMessage(playerid, COLOR_WHITE, "����: /��� [�÷��̾�]");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
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
	else if (!strcmp(cmd, "/��ȯ", true))
	{
	    cmd = strtok(cmdtext, idx);
	    if (!strlen(cmd))
	        return SendClientMessage(playerid, COLOR_WHITE, "����: /��ȯ [�÷��̾�]");
		destid = ReturnUser(cmd);
		if (!IsPlayerConnected(destid))
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
	else if (!strcmp(cmd, "/��ũ", true))
	{
	    GetPlayerPos(playerid, Mark[playerid][0], Mark[playerid][1], Mark[playerid][2]);
	    GetPlayerFacingAngle(playerid, Mark[playerid][3]);
	    MarkInterior[playerid] = GetPlayerInterior(playerid);
	    MarkVirtualWorld[playerid] = GetPlayerVirtualWorld(playerid);
	    SendClientMessage(playerid, COLOR_WHITE, "���� ��ġ�� ��ũ�Ǿ����ϴ�.");
	    return 1;
	}
	else if (!strcmp(cmd, "/��ũ��", true))
	{
	    SetPlayerPos(playerid, Mark[playerid][0], Mark[playerid][1], Mark[playerid][2]);
	    SetPlayerFacingAngle(playerid, Mark[playerid][3]);
	    SetCameraBehindPlayer(playerid);
	    SetPlayerInterior(playerid, MarkInterior[playerid]);
	    SetPlayerVirtualWorld(playerid, MarkVirtualWorld[playerid]);
	    return 1;
	}
	else if (!strcmp(cmd, "/�ڷ���Ʈ", true))
	{
	    cmd = strtok(cmdtext, idx);
	    if (!strlen(cmd))
	        return SendClientMessage(playerid, COLOR_WHITE, "����: /�ڷ���Ʈ [��ǥ]");
		new pos[3][10];
		split(cmd, pos, ',');
		SetPlayerPos(playerid, floatstr(pos[0]), floatstr(pos[1]), floatstr(pos[2]));
		return 1;
	}
	else if (!strcmp(cmd, "/�λ�", true))
	{
		if (IsPlayerInAnyVehicle(playerid))
			SetVehiclePos(GetPlayerVehicleID(playerid), 1531.4265, -1676.7639, 13.3828 + 2.0);
		else
			SetPlayerPos(playerid, 1531.4265, -1676.7639, 13.3828 + 2.0);
		SetPlayerInterior(playerid, 0);
		return 1;
	}
	else if (!strcmp(cmd, "/����", true))
	{
		if (IsPlayerInAnyVehicle(playerid))
			SetVehiclePos(GetPlayerVehicleID(playerid), -1422.2572, -289.8291, 14.1484 + 2.0);
		else
			SetPlayerPos(playerid, -1422.2572, -289.8291, 14.1484 + 2.0);
		SetPlayerInterior(playerid, 0);
		return 1;
	}
	else if (!strcmp(cmd, "/��", true))
	{
		if (IsPlayerInAnyVehicle(playerid))
			SetVehiclePos(GetPlayerVehicleID(playerid), 1679.5079, 1448.0795, 47.7813 + 2.0);
		else
			SetPlayerPos(playerid, 1679.5079, 1448.0795, 47.7813 + 2.0);
		SetPlayerInterior(playerid, 0);
		return 1;
	}
	//
	// �ǹ�
	//
	else if (!strcmp(cmd, "/�ǹ�����", true))
	{
		CreateProperty();
		SendClientMessage(playerid, COLOR_WHITE, "�ǹ��� �����߽��ϴ�. '/�ǹ�����'���� �����ϼ���.");
	    return 1;
	}
	else if (!strcmp(cmd, "/�ǹ�����", true))
	{
	    cmd = strtok(cmdtext, idx);
	    if (!strlen(cmd))
			return ShowPropertyList(playerid, DialogId_Admin(1));
		destid = strval(cmd);
		if (!IsValidPropertyID(destid))
		for (new i = 0, t = GetMaxProperties(); i < t; i++)
		    if (IsValidPropertyID(i) && GetPropertyDBID(i) == destid)
		        return ShowPropertyModifier(playerid, i);
		SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �ǹ��Դϴ�.");
		return 1;
	}
	return 0;
}
//-----< dResponseHandler >-----------------------------------------------------
public dResponseHandler_Admin(playerid, dialogid, response, listitem, inputtext[])
{
	new str[256];
	switch (dialogid - DialogId_Admin(0))
	{
		case 0:
		{
		    if (response)
		    {
				new destid = GetPVarInt_(playerid, "EditPVar_destid");
		        if (!IsPlayerConnected(destid))
		    		return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
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
				format(str, sizeof(str), "%s���� %s���� %s ����: %s", GetPlayerNameA(playerid), GetPlayerNameA(destid), varname, str);
				SendAdminMessage(COLOR_YELLOW, str);
			}
			SetPVarInt_(playerid, "EditPVar_destid", 0);
			SetPVarString_(playerid, "EditPVar_varname", chNullString);
			SetPVarString_(playerid, "EditPVar_value", chNullString);
		}
		case 1:
		    if (response)
		        ShowPropertyModifier(playerid, GetPVarInt_(playerid, "DialogData", listitem));
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
//-----<  >---------------------------------------------------------------------
