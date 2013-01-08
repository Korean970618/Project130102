/*
 *
 *
 *		PureunBa(¼­¼º¹ü)
 *
 *			Variables Core
 *
 *
 *		Coded by PureunBa 2011-2013 @ all right reserved.
 *
 *			< pureunba.tistory.com >
 *
 *
 *		Release:	2013/01/02
 *		Update:		2013/01/08
 *
 *
 */
/*

  < Callbacks >
	gInitHandler_Variables()
	
  < Functions >
	SetPVarString_(playerid, varname[], string_value[], index=0)
	SetPVarInt_(playerid, varname[], int_value, index=0)
	Float:SetPVarFloat_(playerid, varname[], Float:float_value, index=0)
	GetPVarString_(playerid, varname[], index=0)
	GetPVarInt_(playerid, varname[], index=0)
	Float:GetPVarFloat_(playerid, varname[], index=0)

*/



//-----< Variables
enum eServerInfo
{
	bool:sTogOOC,
	bool:sTogOOW,
	bool:sTogQA,
	bool:sTogNews
};
new ServerInfo[eServerInfo];



//-----< Defines



//-----< Callbacks
forward gInitHandler_Variables();
//-----< GameModeInitHandler_Variables >----------------------------------------
public gInitHandler_Variables()
{
	ServerInfo[sTogOOC] = false;
	ServerInfo[sTogOOW] = true;
	ServerInfo[sTogQA] = true;
	ServerInfo[sTogNews] = true;
	return 1;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----< SetPVarString_ >-------------------------------------------------------
stock SetPVarString_(playerid, varname[], string_value[], index=0)
{
	if (index == 0)
	    SetPVarString(playerid, varname, string_value);
	else
	{
	    new str[64];
	    format(str, sizeof(str), "%s_%d", varname, index);
	    SetPVarString(playerid, str, string_value);
	}
	return string_value;
}
//-----< SetPVarInt_ >----------------------------------------------------------
stock SetPVarInt_(playerid, varname[], int_value, index=0)
{
	if (index == 0)
	    SetPVarInt(playerid, varname, int_value);
	else
	{
	    new str[64];
	    format(str, sizeof(str), "%s_%d", varname, index);
	    SetPVarInt(playerid, str, int_value);
	}
	return int_value;
}
//-----< SetPVarFloat_ >--------------------------------------------------------
stock Float:SetPVarFloat_(playerid, varname[], Float:float_value, index=0)
{
	if (index == 0)
	    SetPVarFloat(playerid, varname, float_value);
	else
	{
	    new str[64];
	    format(str, sizeof(str), "%s_%d", varname, index);
	    SetPVarFloat(playerid, str, float_value);
	}
	return float_value;
}
//-----< GetPVarString_ >-------------------------------------------------------
stock GetPVarString_(playerid, varname[], index=0)
{
	new string_return[256];
	if (index == 0)
	    GetPVarString(playerid, varname, string_return, sizeof(string_return));
	else
	{
		new str[64];
		format(str, sizeof(str), "%s_%d", varname, index);
		GetPVarString(playerid, str, string_return, sizeof(string_return));
	}
	return string_return;
}
//-----< GetPVarInt_ >----------------------------------------------------------
stock GetPVarInt_(playerid, varname[], index=0)
{
	new int_return;
	if (index == 0)
		int_return = GetPVarInt(playerid, varname);
	else
	{
	    new str[64];
	    format(str, sizeof(str), "%s_%d", varname, index);
	    int_return = GetPVarInt(playerid, str);
	}
	return int_return;
}
//-----< GetPVarFloat_ >--------------------------------------------------------
stock Float:GetPVarFloat_(playerid, varname[], index=0)
{
	new Float:float_return;
	if (index == 0)
	    float_return = GetPVarFloat(playerid, varname);
	else
	{
	    new str[64];
	    format(str, sizeof(str), "%s_%d", varname, index);
	    float_return = GetPVarFloat(playerid, str);
	}
	return float_return;
}
//-----<  >---------------------------------------------------------------------
