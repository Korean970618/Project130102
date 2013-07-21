/*
 *
 *
 *			Nogov Chat Module
 *		  	2013/05/08
 *
 *
 *		Copyright (c) sBum. All rights reserved.
 *
 *
 */
/*

  < Callbacks >
	pTextHandler_Chat(playerid, text[])
	pCommandTextHandler_Chat(playerid, cmdtext[])
	
  < Functions >

*/



//-----< Defines
#define MAX_CHAT_DISTANCE		30



//-----< Variables



//-----< Callbacks
forward pTextHandler_Chat(playerid, text[]);
forward pCommandTextHandler_Chat(playerid, cmdtext[]);
//-----< pTextHandler >---------------------------------------------------------
public pTextHandler_Chat(playerid, text[])
{
	new Float:x, Float:y, Float:z;
	format(cstr, sizeof(cstr), "%s: %s", GetPlayerNameA(playerid), text);
	GetPlayerPos(playerid, x, y, z);
	
	for(new i = 0, t = GetMaxPlayers(); i < t; i++)
		if(GetPVarInt(i, "LoggedIn"))
			for(new j = MAX_CHAT_DISTANCE; j >= 0; j -= 10)
				if(IsPlayerInRangeOfPoint(i, MAX_CHAT_DISTANCE-j, x, y, z))
				{
					SendClientMessage(i, COLOR_WHITE-(500000000*j/10), cstr);
					break;
				}
	return 0;
}
//-----< pCommandTextHandler >--------------------------------------------------
public pCommandTextHandler_Chat(playerid, cmdtext[])
{
	new cmd[256], idx,
	    destid;
	cmd = strtok(cmdtext, idx);
	
	if(!strcmp(cmd, "/�ӼӸ�", true) || !strcmp(cmd, "/w", true) || !strcmp(cmd, "/whisper", true))
	{
		cmd = strtok(cmdtext, idx);
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /�ӼӸ� [�÷��̾�] [����]");
		destid = ReturnUser(cmd);
		if(!IsPlayerConnected(destid))
			return SendClientMessage(playerid, COLOR_WHITE, "�������� �ʴ� �÷��̾��Դϴ�.");
		strcpy(cmd, stringslice_c(cmdtext, idx));
		if(!strlen(cmd))
			return SendClientMessage(playerid, COLOR_WHITE, "����: /�ӼӸ� [�÷��̾�] [����]");
		format(cstr, sizeof(cstr), "%s(%d)�Կ��� �ӼӸ� ����: %s", GetPlayerNameA(destid), destid, cmd);
		SendClientMessage(playerid, COLOR_SPRINGGREEN, cstr);
		format(cstr, sizeof(cstr), "%s(%d)�����κ��� �ӼӸ� ����: %s", GetPlayerNameA(playerid), playerid, cmd);
		SendClientMessage(destid, COLOR_YELLOWGREEN, cstr);
		return 1;
	}
	
	return 1;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----<  >---------------------------------------------------------------------
