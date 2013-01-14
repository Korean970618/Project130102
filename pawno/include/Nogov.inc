/*
 *
 *
 *		PureunBa(¼­¼º¹ü)
 *
 *			Nogov Main Include
 *			v1.0.0
 *
 *
 *		Coded by PureunBa 2011-2013 @ all right reserved.
 *
 *			< pureunba.tistory.com >
 *
 *
 *		Release:	2013/01/02
 *		Update:		2013/01/14
 *
 *
 */
/*
native strcpy(dest[], src[]);
native FixBlankString(input[]);
native AntiDeAMX();
native strtok(const string[], &index, seperator=' ');
native stringslice(const string[], stringindex, separator=' ');
native stringslice_c(const string[], stringindex, separator=' ');
native ReturnUser(text[]);
native IsNumeric(const string[]);
native split(const strsrc[], strdest[][], delimiter = '|');
native GetPlayerNameA(playerid);
native GetPlayerIpA(playerid);
native Float:GetPlayerHealthA(playerid);
native Float:GetPlayerArmourA(playerid);
native Wait(time);
native Crash();
native TimeFix(time);
native SetPVarInt_(playerid, varname[], int_value, array=0);
native Float:SetPVarFloat_(playerid, varname[], Float:float_value, array=0);
native SetPVarString_(playerid, varname[], string_value[], array=0);
native GetPVarInt_(playerid, varname[], array=0);
native GetPVarFloat_(playerid, varname[], array=0);
native GetPVarString_(playerid, varname[], array=0);
native DeletePVar_(playerid, varname[], array=0);
native escape(str[])
native ResetPlayerDialogData(playerid);
 */



//-----< Pragmas
#pragma dynamic					20000000



//-----< Defines
//-----< Chars >----------------------------------------------------------------
#define chNullString            ""
#define chEmpty                 " "
#define chCr                    "\r"
#define chLf                    "\n"
#define chCrLf                  "\r\n"
//-----< System Colors >--------------------------------------------------------
#define COLOR_ADMIN				0x2587CEFF
#define COLOR_DIALOG			0xA9C4E4FF
#define C_ADMIN					"{2587CE}"
#define C_DIALOG				"{A9C4E4}"
//-----< Pastel Colors >--------------------------------------------------------
#define COLOR_PASTEL_BLACK		0x9A9691FF
#define COLOR_PASTEL_YELLOW		0xFAF5A4FF
#define COLOR_PASTEL_RED		0xFFB2BEFF
#define COLOR_PASTEL_MAGENTA	0xF9ABDDFF
#define COLOR_PASTEL_VIOLET		0xBA94DDFF
#define COLOR_PASTEL_BLUE		0x5DCEF0FF
#define COLOR_PASTEL_GREEN		0x6DE5D0FF
#define C_PASTEL_BLACK			"{9A9691}"
#define C_PASTEL_YELLOW			"{FAF5A4}"
#define C_PASTEL_RED			"{FFB2BE}"
#define C_PASTEL_MAGENTA		"{F9ABDD}"
#define C_PASTEL_VIOLET			"{BA94DD}"
#define C_PASTEL_BLUE			"{5DCEF0}"
#define C_PASTEL_GREEN			"{6DE5D0}"
//-----< General Colors >-------------------------------------------------------
#define COLOR_WHITE				0xFFFFFFFF
#define COLOR_GREY 				0xAAAAAAFF
#define COLOR_RED 				0xFF0000FF
#define COLOR_GREEN		  		0x00FF00FF
#define COLOR_BLUE		  		0x0000FFFF
#define COLOR_YELLOW			0xFFFF00FF
#define COLOR_CORAL				0xFFAB7BFF
#define COLOR_PINK				0xFFC0CBFF
#define COLOR_HOTPINK			0xFF69B4FF
#define COLOR_PURPLE			0xD1B9E3FF
#define COLOR_VIOLET			0xEE82EEFF
#define COLOR_ORANGE		  	0xFF9900FF
#define COLOR_SPRINGGREEN		0x00FF7FFF
#define COLOR_YELLOWGREEN		0x9ACD32FF
#define COLOR_LIGHTGREEN 		0xCBFEA9FF
#define COLOR_MEDIUMAQUA		0x83BFBFFF
#define COLOR_TAXIYELLOW	  	0xF0E68CFF
#define COLOR_SKYBLUE			0x9CEAFBFF
#define COLOR_LIGHTBLUE	  		0x33CCFFFF
#define COLOR_LIGHTPINK			0xFF8282FF
#define C_WHITE					"{FFFFFF}"
#define C_GREY 					"{AAAAAA}"
#define C_RED 					"{FF0000}"
#define C_GREEN		  			"{00FF00}"
#define C_BLUE		  			"{0000FF}"
#define C_YELLOW				"{FFFF00}"
#define C_CORAL					"{FFAB7B}"
#define C_PINK					"{FFC0CB}"
#define C_HOTPINK				"{FF69B4}"
#define C_PURPLE				"{D1B9E3}"
#define C_VIOLET				"{EE82EE}"
#define C_ORANGE		  		"{FF9900}"
#define C_SPRINGGREEN			"{00FF7F}"
#define C_YELLOWGREEN			"{9ACD32}"
#define C_LIGHTGREEN 			"{CBFEA9}"
#define C_MEDIUMAQUA			"{83BFBF}"
#define C_TAXIYELLOW	  		"{F0E68C}"
#define C_SKYBLUE				"{9CEAFB}"
#define C_LIGHTBLUE	  			"{33CCFF}"



//-----< Functions
//-----< strcpy >---------------------------------------------------------------
stock strcpy(dest[], src[])
{
	new i = 0;
	while ((dest[i] = src[i]))
		i++;
}
//-----< AntiDeAMX >------------------------------------------------------------
stock AntiDeAMX()
{
	new a[][] =	{"Pureun", "Ba"};
	#pragma unused a
}
//-----< FixBlankString >-------------------------------------------------------
stock FixBlankString(input[])
{
	new string[1024];
	strcpy(string, "/Empty/");
	if (strlen(input))
		strcpy(string, input);
	return string;
}
//-----< strtok >---------------------------------------------------------------
stock strtok(const string[], &index, seperator=' ')
{
	new length = strlen(string);
	new offset = index;
	new result[256];
	while ((index < length) && (string[index] != seperator) && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	if ((index < length) && (string[index] == seperator))
		index++;
	return result;
}
//-----< stringslice >----------------------------------------------------------
stock stringslice(const string[], stringindex, separator=' ')
{
	new
		stringstart,
		stringnum,
		stringlength,
		result[25]
	;
	for (stringnum = 0; stringnum <= stringindex && stringlength <= strlen(string); ++stringnum)
	{
		if (stringnum>0)
			stringlength++;
		stringstart = stringlength;
		while (stringlength <= strlen(string) && string[stringlength] != separator && string[stringlength] != EOS)
			stringlength++;
	}
	stringnum = 0;
	stringlength = stringlength-stringstart;
	while (stringnum <= stringlength && stringnum <= sizeof(result))
	{
		result[stringnum] = string[stringnum+stringstart];
		stringnum++;
	}
	result[stringlength] = EOS;
	return result;
}
//-----< stringslice_c >--------------------------------------------------------
stock stringslice_c(const string[], stringindex, separator=' ')
{
	new
		stringstart,
		stringnum,
		stringlength,
		result[512]
	;
	for (stringnum = 0; stringnum <= stringindex && stringlength <= strlen(string); stringnum++)
	{
		if (stringnum > 0)
			stringlength++;
		stringstart = stringlength;
		while (stringlength <= strlen(string) && string[stringlength] != separator && string[stringlength] != EOS)
			stringlength++;
	}
	strmid(result, string, stringstart, strlen(string));
	return result;
}
//-----< ReturnUser >-----------------------------------------------------------
stock ReturnUser(text[])
{
	new pos = 0;
	while (text[pos] < 0x21)
	{
		if (text[pos] == 0)
			return INVALID_PLAYER_ID;
		pos++;
	}
	new userid = INVALID_PLAYER_ID;
	if (IsNumeric(text[pos]))
	{
		userid = strval(text[pos]);
		if (userid >= 0 && userid < GetMaxPlayers())
		{
			if (!IsPlayerConnected(userid))
				userid = INVALID_PLAYER_ID;
			else
				return userid;
		}
	}
	new len = strlen(text[pos]);
	new count = 0;
	new name[MAX_PLAYER_NAME];
	for (new i = 0, t = GetMaxPlayers(); i < t; i++)
		if (IsPlayerConnected(i))
		{
			GetPlayerName(i, name, sizeof(name));
			if (strcmp(name, text[pos] ,true, len) == 0)
			{
				if (len == strlen(name))
					return i;
				else {
					count++;
					userid = i;
				}
			}
		}
	if (count != 1)
		userid = INVALID_PLAYER_ID;
	return userid;
}
//-----< IsNumeric >------------------------------------------------------------
stock IsNumeric(const string[])
{
	for (new i = 0, t = strlen(string); i < t; i++)
		if (string[i] < '0' || string[i] > '9')
			return false;
	return true;
}
//-----< split >----------------------------------------------------------------
stock split(const strsrc[], strdest[][], delimiter = '|')
{
	new i, li, aNum, len, srclen = strlen(strsrc);
	while (i <= srclen)
	{
		if (strsrc[i] == delimiter || i == srclen)
		{
			len = strmid(strdest[aNum], strsrc, li, i, 128);
			strdest[aNum][len] = 0;
			li = i + 1;
			aNum++;
		}
		i++;
	}
}
//-----< GetPlayerNameA >-------------------------------------------------------
stock GetPlayerNameA(playerid)
{
	new pname[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pname, sizeof(pname));
	return pname;
}
//-----< GetPlayerIpA >---------------------------------------------------------
stock GetPlayerIpA(playerid)
{
	new pip[16];
	GetPlayerIp(playerid, pip, sizeof(pip));
	return pip;
}
//-----< GetPlayerHealthA >-----------------------------------------------------
stock Float:GetPlayerHealthA(playerid)
{
	new Float:tmp;
	GetPlayerHealth(playerid, tmp);
	return tmp;
}
//-----< GetPlayerArmourA >-----------------------------------------------------
stock Float:GetPlayerArmourA(playerid)
{
	new Float:tmp;
	GetPlayerArmour(playerid, tmp);
	return tmp;
}
//-----< Wait >-----------------------------------------------------------------
stock Wait(time)
{
	new stamp = tickcount();
	while (tickcount() - stamp < time) {}
	return 1;
}
//-----< Crash >----------------------------------------------------------------
stock Crash()
{
	new File:hFile;
	hFile = fopen("crash/crash.txt", io_append);
	fwrite(hFile, "%s");
	fclose(hFile);
	return 1;
}
//-----< TimeFix >--------------------------------------------------------------
stock TimeFix(time)
{
	return floatround(time*0.85);
}
//-----< SetPVarInt_ >----------------------------------------------------------
stock SetPVarInt_(playerid, varname[], int_value, array=0)
{
	new varname_[64];
	format(varname_, sizeof(varname_), "%s_%d", varname, array);
	if (int_value == 0)
	    DeletePVar(playerid, varname_);
	else
		SetPVarInt(playerid, varname_, int_value);
}
//-----< SetPVarFloat_ >--------------------------------------------------------
stock SetPVarFloat_(playerid, varname[], Float:float_value, array=0)
{
	new varname_[64];
	format(varname_, sizeof(varname_), "%s_%d", varname, array);
	if (float_value == 0.0)
	    DeletePVar(playerid, varname_);
	else
		SetPVarFloat(playerid, varname_, float_value);
}
//-----< SetPVarString_ >-------------------------------------------------------
stock SetPVarString_(playerid, varname[], string_value[], array=0)
{
	new varname_[64];
	format(varname_, sizeof(varname_), "%s_%d", varname, array);
	if (strlen(string_value) == 0)
	    DeletePVar(playerid, varname_);
	else
		SetPVarString(playerid, varname_, string_value);
}
//-----< GetPVarInt_ >----------------------------------------------------------
stock GetPVarInt_(playerid, varname[], array=0)
{
	new varname_[64];
	format(varname_, sizeof(varname_), "%s_%d", varname, array);
	return GetPVarInt(playerid, varname_);
}
//-----< GetPVarFloat_ >--------------------------------------------------------
stock Float:GetPVarFloat_(playerid, varname[], array=0)
{
	new varname_[64];
	format(varname_, sizeof(varname_), "%s_%d", varname, array);
	return GetPVarFloat(playerid, varname_);
}
//-----< GetPVarString_ >-------------------------------------------------------
stock GetPVarString_(playerid, varname[], array=0)
{
	new
		varname_[64],
		string[512]
	;
	format(varname_, sizeof(varname_), "%s_%d", varname, array);
	GetPVarString(playerid, varname_, string, sizeof(string));
	return string;
}
//-----< DeletePVar_ >----------------------------------------------------------
stock DeletePVar_(playerid, varname[], array=0)
{
	new varname_[64];
	format(varname_, sizeof(varname_), "%s_%d", varname, array);
	DeletePVar(playerid, varname_);
}
//-----< escape >---------------------------------------------------------------
stock escape(str[])
{
	new escaped[256];
	mysql_real_escape_string(str, escaped);
	return escaped;
}
//-----< ResetPlayerDialogData >------------------------------------------------
stock ResetPlayerDialogData(playerid)
{
	for (new i = 0; i < 100; i++)
		DeletePVar_(playerid, "DialogList", i);
	return 1;
}
//-----<  >---------------------------------------------------------------------
