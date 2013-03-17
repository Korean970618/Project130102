/*
 *
 *
 *			Nogov GVar Core
 *		  	2013/02/27
 *
 *
 *		Copyright (c) sBum. All rights reserved.
 *
 *
 */
/*

  < Callbacks >
	gInitHandler_GVar()
	
  < Functions >
	CreateGVarDataTable()
	SaveGVarDataById(varid)
	SaveGVarData()
	LoadGVarData()
	
	SetGVarString(varname[], value[])
	GetGVarString(varname[])
	SetGVarInt(varname[], value)
	GetGVarInt(varname[])
	Float:SetGVarFloat(varname[], Float:value)
	Float:GetGVarFloat(varname[])
	DeleteGVar(varname[])

*/



//-----< Defines



//-----< Variables
enum GVarEnum
{
	gID,
	gName[64],
	gStringValue[512],
	gIntValue,
	Float:gFloatValue
}
new GVar[50][GVarEnum];



//-----< Callbacks
forward gInitHandler_GVar();
//-----< gInitHandler >---------------------------------------------------------
public gInitHandler_GVar()
{
	CreateGVarDataTable();
	LoadGVarData();
	return 1;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----< CreateGVarDataTable >--------------------------------------------------
stock CreateGVarDataTable()
{
	new str[512];
	strcpy(str, "CREATE TABLE IF NOT EXISTS gvardata (");
	strcat(str, "ID int(5) NOT NULL auto_increment PRIMARY KEY,");
	strcat(str, "Name varchar(64) NOT NULL default ' ',");
	strcat(str, "StringValue varchar(512) NOT NULL default ' ',");
	strcat(str, "IntValue int(16) NOT NULL default '0',");
	strcat(str, "FloatValue float(16.4) NOT NULL default '0.0') ");
	strcat(str, "ENGINE = InnoDB CHARACTER SET euckr COLLATE euckr_korean_ci");
	mysql_query(str);
	return 1;
}
//-----< SaveGVarDataById >-----------------------------------------------------
stock SaveGVarDataById(varid)
{
	new str[512];
	if (!GVar[varid][gID])
	{
		mysql_query("INSERT INTO gvardata () VALUES ()");
		GVar[varid][gID] = mysql_insert_id();
	}
	format(str, sizeof(str), "UPDATE gvardata SET");
	format(str, sizeof(str), "%s Name='%s'", str, escape(GVar[varid][gName]));
	format(str, sizeof(str), "%s,StringValue='%s'", str, escape(GVar[varid][gStringValue]));
	format(str, sizeof(str), "%s,IntValue=%d", str, GVar[varid][gIntValue]);
	format(str, sizeof(str), "%s,FloatValue=%.4f", str, GVar[varid][gFloatValue]);
	format(str, sizeof(str), "%s WHERE ID=%d", str, GVar[varid][gID]);
	mysql_query(str);
	return 1;
}
//-----< SaveGVarData >---------------------------------------------------------
stock SaveGVarData()
{
	for (new i = 0, t = sizeof(GVar); i < t; i++)
		if (GVar[i][gID])
			SaveGVarById(i);
	return 1;
}
//-----< LoadGVarData >---------------------------------------------------------
stock LoadGVarData()
{
	new str[768],
		receive[5][512],
		idx;
	mysql_query("SELECT * FROM gvardata");
	mysql_store_result();
	for (new i = 0, t = mysql_num_rows(); i < t; i++)
	{
		mysql_fetch_row(str, "|");
		split(str, receive, '|');
		idx = 0;

		GVar[i][gID] = strval(receive[idx++]);
		strcpy(GVar[i][gName], receive[idx++]);
		strcpy(GVar[i][gStringValue], receive[idx++]);
		GVar[i][gIntValue] = strval(receive[idx++]);
		GVar[i][gFloatValue] = floatstr(receive[idx++]);
	}
}
//-----<  >---------------------------------------------------------------------
//-----< SetGVarString >--------------------------------------------------------
stock SetGVarString(varname[], value[])
{
	new varid = sizeof(GVar);
	for (new i = 0, t = sizeof(GVar); i < t; i++)
	{
		if (GVar[i][gID] && !strcmp(GVar[i][gName], varname, true))
		{
			strcpy(GVar[i][gStringValue], value);
			SaveGVarDataById(i);
			return value;
		}
		else if (!GVar[i][gID] && varid > i)
			varid = i;
	}
	if (varid < sizeof(GVar))
	{
		strcpy(GVar[varid][gName], varname);
		strcpy(GVar[varid][gStringValue], value);
	}
	SaveGVarDataById(varid);
	return value;
}
//-----< GetGVarString >--------------------------------------------------------
stock GetGVarString(varname[])
{
	new value[512];
	for (new i = 0, t = sizeof(GVar); i < t; i++)
	    if (GVar[i][gID] && !strcmp(GVar[i][gName], varname, true))
	    {
	        strcpy(value, GVar[i][gStringValue]);
	        break;
	    }
	return value;
}
//-----< SetGVarInt >-----------------------------------------------------------
stock SetGVarInt(varname[], value)
{
	new varid = sizeof(GVar);
	for (new i = 0, t = sizeof(GVar); i < t; i++)
	{
		if (GVar[i][gID] && !strcmp(GVar[i][gName], varname, true))
		{
			GVar[i][gIntValue] = value;
			SaveGVarDataById(i);
			return value;
		}
		else if (!GVar[i][gID] && varid > i)
			varid = i;
	}
	if (varid < sizeof(GVar))
	{
		strcpy(GVar[varid][gName], varname);
		GVar[varid][gIntValue] = value;
	}
	SaveGVarDataById(varid);
	return value;
}
//-----< GetGVarInt >-----------------------------------------------------------
stock GetGVarInt(varname[])
{
	new value;
	for (new i = 0, t = sizeof(GVar); i < t; i++)
	    if (GVar[i][gID] && !strcmp(GVar[i][gName], varname, true))
	    {
	        value = GVar[i][gIntValue];
	        break;
	    }
	return value;
}
//-----< SetGVarFloat >---------------------------------------------------------
stock Float:SetGVarFloat(varname[], Float:value)
{
	new varid = sizeof(GVar);
	for (new i = 0, t = sizeof(GVar); i < t; i++)
	{
		if (GVar[i][gID] && !strcmp(GVar[i][gName], varname, true))
		{
			GVar[i][gFloatValue] = value;
			SaveGVarDataById(i);
			return value;
		}
		else if (!GVar[i][gID] && varid > i)
			varid = i;
	}
	if (varid < sizeof(GVar))
	{
		strcpy(GVar[varid][gName], varname);
		GVar[varid][gFloatValue] = value;
	}
	SaveGVarDataById(varid);
	return value;
}
//-----< GetGVarFloat >---------------------------------------------------------
stock Float:GetGVarFloat(varname[])
{
	new Float:value;
	for (new i = 0, t = sizeof(GVar); i < t; i++)
	    if (GVar[i][gID] && !strcmp(GVar[i][gName], varname, true))
	    {
	        value = GVar[i][gFloatValue];
	        break;
	    }
	return value;
}
//-----< DeleteGVar >-----------------------------------------------------------
stock DeleteGVar(varname[])
{
	for (new i = 0, t = sizeof(GVar); i < t; i++)
		if (GVar[i][gID] && !strcmp(GVar[i][gName], varname))
		{
			GVar[i][gID] = 0;
			break;
		}
	return 1;
}
//-----<  >---------------------------------------------------------------------
