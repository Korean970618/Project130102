/*
 *
 *
 *			Nogov Faction Module
 *		  	2013/07/05
 *
 *
 *		Copyright (c) sBum. All rights reserved.
 *
 *
 */
/*

  < Callbacks >

	
  < Functions >
	CreateFactionDataTable()
	CreateFaction(factionname[])
	DeleteFaction(factionid)
	IsValidFactionID(factionid)
	
	SetFactionVar(factionid, varname[], vartype, stringvalue[], intvalue, Float:floatvalue)
	GetFactionVar(factionid, varname[])
	
	SetFactionVarString(factionid, varname[], value[])
	GetFactionVarString(factionid, varname[])
	DeleteFactionVar(factionid, varname[])
	SetFactionVarInt(factionid, varname[], value)
	GetFactionVarInt(factionid, varname[])
	SetFactionVarFloat(factionid, varname[], Float:value)
	Float:GetFactionVarFloat(factionid, varname[])
	
	SetPlayerFactionID(playerid, factionid)
	GetPlayerFactionID(playerid, factionid)
	
	ShowFactionMemberList(playerid, factionid, dialogid, button1[], button2[])

*/



//-----< Defines
#define FACTION_VARTYPE_STRING  0
#define FACTION_VARTYPE_INT		1
#define FACTION_VARTYPE_FLOAT   2
#define MAX_FACTION_MEMBERS		128



//-----< Variables



//-----< Callbacks
forward gInitHandler_Faction();
//-----< gInitHandler >---------------------------------------------------------
public gInitHandler_Faction()
{
	CreateFactionDataTable();
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----< CreateFactionDataTable >-----------------------------------------------
stock CreateFactionDataTable()
{
	new str[1024];
	strcpy(str, "CREATE TABLE IF NOT EXISTS factiondata (");
	strcat(str, " ID int(5) NOT NULL auto_increment PRIMARY KEY");
	strcat(str, ",FactionID int(5) NOT NULL default '0'");
	strcat(str, ",VarName varchar(64) NOT NULL default ' '");
	strcat(str, ",VarType int(1) NOT NULL default '0'");
	strcat(str, ",Value varchar(512) NOT NULL default ' '");
	strcat(str, ") ENGINE = InnoDB CHARACTER SET euckr COLLATE euckr_korean_ci");
	mysql_query(str);
	return 1;
}
//-----< CreateFaction >--------------------------------------------------------
stock CreateFaction(factionname[], order=INVALID_PLAYER_ID)
{
	new returns;
	new factionscount = GetGVarInt("FactionsCount");
	while(factionscount && !IsValidFactionID(factionscount)) factionscount++;
	if(factionscount)
	{
		SetGVarInt("FactionsCount", factionscount+1);
		returns = SetFactionVarString(factionscount, "FactionName", factionname);
	}
	if(!returns)
	{
		format(str, sizeof(str), "%s%s%s 팩션 생성에 실패했습니다.", C_RED, factionname, C_WHITE);
		if(GetPVarInt(order, "LoggedIn")) SendClientMessage(playerid, COLOR_WHITE, str);
	}
	return returns;
}
//-----< DeleteFaction >--------------------------------------------------------
stock DeleteFaction(factionid)
{
	return DeleteFactionVar(factionid, "FactionName");
}
//-----< IsValidFactionID >-----------------------------------------------------
stock IsValidFactionID(factionid)
{
	return (strlen(GetFactionVarString(factionid, "FactionName"))) ? true : false;
}
//-----<  >---------------------------------------------------------------------
//-----< SetFactionVar >--------------------------------------------------------
stock SetFactionVar(factionid, varname[], vartype, stringvalue[], intvalue, Float:floatvalue)
{
	new str[768];
	format(str, sizeof(str), "SELECT * FROM factiondata WHERE FactionID=%d AND VarName='%s'", factionid, escape(varname));
	mysql_query(str);
	mysql_store_result();
	new rows = mysql_num_rows();
	mysql_free_result();
	new value[512];
	switch(vartype)
	{
		case FACTION_VARTYPE_STRING:	strcpy(value, stringvalue);
		case FACTION_VARTYPE_INT:		format(value, sizeof(value), "%d", intvalue);
		case FACTION_VARTYPE_FLOAT:		format(value, sizeof(value), "%.4f", floatvalue);
	}
	if(!rows)
	{
		format(str, sizeof(str), "INSERT INTO factiondata");
		format(str, sizeof(str), "%s (FactionID,VarName,VarType,Value) VALUES", str);
		format(str, sizeof(str), "%s (%d,'%s',%d,'%s')", str, factionid, escape(varname), vartype, escape(value));
	}
	else
	{
		format(str, sizeof(str), "UPDATE factiondtat SET");
		format(str, sizeof(str), "%s VarName='%s'", str, escape(varname));
		format(str, sizeof(str), "%s,VarType=%d", str, vartype);
		format(str, sizeof(str), "%s,Value='%s'", str, escape(value));
		format(str, sizeof(str), "%s WHERE FactionID=%d AND VarName='%s'", str, factionid, escape(varname));
	}
	return mysql_query(str);;
}
//-----< GetFactionVar >--------------------------------------------------------
stock GetFactionVar(factionid, varname[])
{
	new str[512];
	format(str, sizeof(str), "SELECT Value FROM factiondata WHERE FactionID=%d AND VarName='%s'", factionid, escape(varname));
	mysql_query(str);
	mysql_store_result();
	new value[512];
	mysql_fetch_string(value);
	mysql_free_result();
	return value;
}
//-----< DeleteFactionVar >-----------------------------------------------------
stock DeleteFactionVar(factionid, varname[])
{
	new str[256];
	format(str, sizeof(str), "DELETE FROM factiondata WHERE FactionID=%d AND VarName='%s'", factionid, escape(varname));
	return mysql_query(str);
}
//-----< SetFactionVarString >--------------------------------------------------
stock SetFactionVarString(factionid, varname[], value[])
{
	return SetFactionVar(factionid, varname, FACTION_VARTYPE_STRING, value, 0, 0.0);;
}
//-----< GetFactionVarString >--------------------------------------------------
stock GetFactionVarString(factionid, varname[])
{
	return GetFactionVar(factionid, varname);
}
//-----< SetFactionVarInt >-----------------------------------------------------
stock SetFactionVarInt(factionid, varname[], value)
{
	return SetFactionVar(factionid, varname, FACTION_VARTYPE_INT, chBlankString, value, 0.0);;
}
//-----< GetFactionVarInt >-----------------------------------------------------
stock GetFactionVarInt(factionid, varname[])
{
	return strval(GetFactionVar(factionid, varname);
}
//-----< SetFactionVarFloat >---------------------------------------------------
stock SetFactionVarFloat(factionid, varname[], Float:value)
{
	return SetFactionVar(factionid, varname, FACTION_VARTYPE_FLOAT, chBlankString, 0, value);;
}
//-----< GetFactionVarFloat >---------------------------------------------------
stock Float:GetFactionVarFloat(factionid, varname[])
{
	return floatstr(GetFactionVar(factionid, varname));
}
//-----<  >---------------------------------------------------------------------
//-----< SetPlayerFactionID >---------------------------------------------------
stock SetPlayerFactionID(playerid, factionid)
{
	new str[64], returns;
	if(!GetPVarInt(playerid, "LoggedIn") || !IsValidFactionID(factionid)) return 0;
	new memberscount = GetFactionVarInt(factionid, "MembersCount");
	if(memberscount >= MAX_FACTION_MEMBERS)
	{
		format(str, sizeof(str), "%s%s%s의 최대 인원(%d명)이 초과했습니다.", C_RED, GetFactionVarString(factionid, "FactionName"), C_WHITE, MAX_FACTION_MEMBERS);
		SendClientMessage(playerid, COLOR_WHITE, str);
	}
	else if(memberscount)
	{
		SetFactionVarInt(factionid, "MembersCount", memberscount+1);
		format(str, sizeof(str), "FactionMember%d", memberscount);
		returns = SetFactionVarString(factionid, str, GetPlayerNameA(playerid));
	}
	if(!returns)
	{
		format(str, sizeof(str), "%s%s%s 가입에 실패했습니다.", C_RED, GetFactionVarString(factionid, "FactionName"), C_WHITE);
		SendClientMessage(playerid, COLOR_WHITE, str);
	}
	return returns;
}
//-----< GetPlayerFactionID >---------------------------------------------------
stock GetPlayerFactionID(playerid, index=0)
{
	new str[256];
	if(!GetPVarInt(playerid, "LoggedIn")) return 0;
	format(str, sizeof(str), "SELECT FactionID FROM factiondata WHERE (VarName LIKE 'FactionMember%') AND Value='%s'", escape(GetPlayerNameA(playerid)));
	mysql_query(str);
	mysql_store_result();
	new returns = mysql_fetch_int();
	mysql_free_result();
	return returns;
}
//-----<  >---------------------------------------------------------------------
//-----< ShowFactionMemberList >------------------------------------------------
stock ShowFactionMemberList(playerid, factionid, dialogid, button1[], button2[])
{
	new str[MAX_FACTION_MEMBERS*(MAX_PLAYER_NAME+1)],
		info[2048], bottom[256];
	if(!GetPVarInt(playerid, "LoggedIn") || !IsValidFactionID(factionid)) return 0;
	format(str, sizeof(str), "SELECT Value FROM factiondata WHERE FactionID=%d AND (VarName LIKE 'FactionMember%')", factionid);
	mysql_query(str);
	mysql_store_result();
	strcpy(info, C_LIGHTGREEN);
	strtab(info, "이름", 24);
	strcat(info, "계급");
	strcpy(bottom, C_YELLOW);
	strcat(bottom, "\n> 이전 페이지");
	strcat(bottom, "\n> 다음 페이지");
	for(new i = 0, t = mysql_num_rows(); i < t; i++)
	{
		new tmp[256], name[MAX_PLAYER_NAME];
		mysql_fetch_string(name);

		strcat(tmp, "\n");
		for(new j = 0, u = GetMaxPlayers(); j < u; j++)
			if(GetPVarInt(j, "LoggedIn") && !strcmp(GetPlayerNameA(j), name, true))
				strcat(tmp, C_WHITE);
			else
				strcat(tmp, C_GRAY);
		strcat(tmp, name);
		
		if(strlen(info) + strlen(bottom) + strlen(tmp) > sizeof(info)) break;
		else strcat(info, tmp);
	}
	strcat(info, bottom);
	mysql_free_result();
	ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, GetFactionVarString(factionid, "FactionName"), info, button1, button2);
	return 1;
}
//-----<  >---------------------------------------------------------------------
