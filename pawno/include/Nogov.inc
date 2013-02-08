/*
 *
 *
 *		PureunBa(¼­¼º¹ü)
 *
 *			Nogov Main Include
 *
 *
 *		Coded by PureunBa 2011-2013 @ all right reserved.
 *
 *			< pureunba.tistory.com >
 *
 *
 *		Release:	2013/01/02
 *		Update:		2013/01/30
 *
 *
 */
/*

  < Hook Callbacks >
	OnGameModeInit()
	OnPlayerConnect(playerid)
	OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)

  < Hook Functions >
	ShowPlayerDialog(playerid, dialogid, style, caption[], info[], button1[], button2[])

	SetPlayerAttachedObject(playerid, index, modelid, bone, Float:fOffsetX = 0.0, Float:fOffsetY = 0.0, Float:fOffsetZ = 0.0, Float:fRotX = 0.0, Float:fRotY = 0.0, Float:fRotZ = 0.0, Float:fScaleX = 1.0, Float:fScaleY = 1.0, Float:fScaleZ = 1.0, materialcolor1 = 0, materialcolor2 = 0)

	PlayAudioStreamForPlayer(playerid, url[], Float:posX = 0.0, Float:posY = 0.0, Float:posZ = 0.0, Float:distance = 50.0, usepos = 0)
	StopAudioStreamForPlayer(playerid);

	SendClientMessage(playerid, color, const message[])
	SendClientMessageToAll(color, const message[])
	
	Text:TextDrawCreate(Float:x, Float:y, text[])
	TextDrawDestroy(Text:text)
	TextDrawLetterSize(Text:text, Float:x, Float:y)
	TextDrawTextSize(Text:text, Float:x, Float:y)
	TextDrawAlignment(Text:text, alignment)
	TextDrawColor(Text:text, color)
	TextDrawUseBox(Text:text, use)
	TextDrawBoxColor(Text:text, color)
	TextDrawSetShadow(Text:text, size)
	TextDrawSetOutline(Text:text, size)
	TextDrawBackgroundColor(Text:text, color)
	TextDrawFont(Text:text, font)
	TextDrawSetProportional(Text:text, set)
	TextDrawShowForPlayer(playerid, Text:text)
	TextDrawHideForPlayer(playerid, Text:text)
	TextDrawShowForAll(Text:text)
	TextDrawHideForAll(Text:text)
	TextDrawSetString(Text:text, string[])
	TextDrawSetPreviewModel(Text:text, modelindex)
	TextDrawSetPreviewRot(Text:text, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fZoom = 1.0)
	TextDrawSetPreviewVehCol(Text:text, color1, color2)

  < Functions >
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
	native SetPVarFloat_(playerid, varname[], Float:float_value, array=0);
	native SetPVarString_(playerid, varname[], string_value[], array=0);
	native GetPVarInt_(playerid, varname[], array=0);
	native Float:GetPVarFloat_(playerid, varname[], array=0);
	native GetPVarString_(playerid, varname[], array=0);
	native DeletePVar_(playerid, varname[], array=0);
	native GetPVarType_(playerid, varname[], array=0);
	native escape(str[])
	native ResetPlayerDialogData(playerid);
	native strtab(dest[], str[], maxlength);
	native valstr_(value);
	native GivePlayerDamage(playerid, Float:amount);

*/



//-----< Pragmas
#pragma dynamic					20000000



//-----< Variables
new DialogData[MAX_PLAYERS][100];
enum eAttachedObjectInfo
{
	aoModel,
	aoBone,
	Float:aoOffset[3],
	Float:aoRot[3],
	Float:aoScale[3],
	aoMColor[2]
}
enum eClientMessageInfo
{
	cmColor,
	cmMessage[512]
}
enum eTextDrawInfo
{
	Text:tdID,
	Float:tdPos[2],
	tdText[512],
	Float:tdLetterSize[2],
	Float:tdTextSize[2],
	tdAlignment,
	tdColor,
	tdUseBox,
	tdShadow,
	tdOutline,
	tdBackgroundColor,
	tdFont,
	tdProportional,
	bool:tdPlayer[MAX_PLAYERS],
	tdPreviewModel,
	Float:tdPreviewRot[4],
	tdPreviewVehCol[2]
}
new AttachedObjectInfo[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS][eAttachedObjectInfo],
	Audio_MainStreamIndex[MAX_PLAYERS],
	ClientMessages[MAX_PLAYERS],
	ClientMessageInfo[MAX_PLAYERS][100][eClientMessageInfo],
	TextDrawInfo[MAX_TEXT_DRAWS][eTextDrawInfo];



//-----< Defines
//-----< Chars >----------------------------------------------------------------
#define chNullString			""
#define chEmpty				 	" "
#define chCr					"\r"
#define chLf					"\n"
#define chCrLf				  	"\r\n"
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



//-----< Hook Callbacks
forward OnGameModeInit_();
forward OnPlayerConnect_(playerid);
forward OnPlayerEditAttachedObject_(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ);
//-----< OnGameModeInit >-------------------------------------------------------
public OnGameModeInit_()
{
	for (new i = 0; i < MAX_TEXT_DRAWS; i++)
	{
		TextDrawInfo[i][tdID] = INVALID_TEXT_DRAW;
	}
	return OnGameModeInit();
}
#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit OnGameModeInit_
//-----< OnPlayerConnect >------------------------------------------------------
public OnPlayerConnect(playerid)
{
	for (new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
	{
		AttachedObjectInfo[playerid][i][aoModel] 		= 0;
		AttachedObjectInfo[playerid][i][aoBone] 		= 0;
		AttachedObjectInfo[playerid][i][aoOffset][0] 	= 0.0;
		AttachedObjectInfo[playerid][i][aoOffset][1] 	= 0.0;
		AttachedObjectInfo[playerid][i][aoOffset][2] 	= 0.0;
		AttachedObjectInfo[playerid][i][aoRot][0] 		= 0.0;
		AttachedObjectInfo[playerid][i][aoRot][1] 		= 0.0;
		AttachedObjectInfo[playerid][i][aoRot][2] 		= 0.0;
		AttachedObjectInfo[playerid][i][aoScale][0] 	= 0.0;
		AttachedObjectInfo[playerid][i][aoScale][1] 	= 0.0;
		AttachedObjectInfo[playerid][i][aoScale][2] 	= 0.0;
		RemovePlayerAttachedObject(playerid, i);
	}
	
	ClientMessages[playerid] = 0;
	for (new i = 0; i < 100; i++)
	{
		ClientMessageInfo[playerid][i][cmColor] = 0;
		strcpy(ClientMessageInfo[playerid][i][cmMessage], chNullString);
	}
	
	return OnPlayerConnect_(playerid);
}
#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect OnPlayerConnect_
//-----< OnPlayerEditAttachedObject >-------------------------------------------
public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	AttachedObjectInfo[playerid][index][aoModel] 		= modelid;
	AttachedObjectInfo[playerid][index][aoBone] 		= boneid;
	AttachedObjectInfo[playerid][index][aoOffset][0] 	= fOffsetX;
	AttachedObjectInfo[playerid][index][aoOffset][1] 	= fOffsetY;
	AttachedObjectInfo[playerid][index][aoOffset][2] 	= fOffsetZ;
	AttachedObjectInfo[playerid][index][aoRot][0] 		= fRotX;
	AttachedObjectInfo[playerid][index][aoRot][1] 		= fRotY;
	AttachedObjectInfo[playerid][index][aoRot][2] 		= fRotZ;
	AttachedObjectInfo[playerid][index][aoScale][0] 	= fScaleX;
	AttachedObjectInfo[playerid][index][aoScale][1] 	= fScaleY;
	AttachedObjectInfo[playerid][index][aoScale][2] 	= fScaleZ;
	return OnPlayerEditAttachedObject_(playerid, response, index, modelid, boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ);
}
#if defined _ALS_OnPlayerEditAttachedObject
	#undef OnPlayerEditAttachedObject
#else
	#define _ALS_OnPlayerEditAttachedObject
#endif
#define OnPlayerEditAttachedObject OnPlayerEditAttachedObject_
//-----<  >---------------------------------------------------------------------



//-----< Hook Functions
//-----< ShowPlayerDialog >-----------------------------------------------------
stock ShowPlayerDialog_(playerid, dialogid, style, caption[], info[], button1[], button2[])
{
	new caption_[128],
		info_[10240];
	format(caption_, sizeof(caption_), "%s[Nogov] %s%s", C_PASTEL_BLUE, C_WHITE, caption);
	format(info_, sizeof(info_), "%s%s", C_WHITE, info);
	return ShowPlayerDialog(playerid, dialogid, style, caption_, info_, button1, button2);
}
#if defined _ALS_ShowPlayerDialog
	#undef ShowPlayerDialog
#else
	#define _ALS_ShowPlayerDialog
#endif
#define ShowPlayerDialog ShowPlayerDialog_
//-----<  >---------------------------------------------------------------------
//-----< SetPlayerAttachedObject >----------------------------------------------
stock SetPlayerAttachedObject_(playerid, index, modelid, bone, Float:fOffsetX = 0.0, Float:fOffsetY = 0.0, Float:fOffsetZ = 0.0, Float:fRotX = 0.0, Float:fRotY = 0.0, Float:fRotZ = 0.0, Float:fScaleX = 1.0, Float:fScaleY = 1.0, Float:fScaleZ = 1.0, materialcolor1 = 0, materialcolor2 = 0)
{
	AttachedObjectInfo[playerid][index][aoModel] 		= modelid;
	AttachedObjectInfo[playerid][index][aoBone] 		= bone;
	AttachedObjectInfo[playerid][index][aoOffset][0] 	= fOffsetX;
	AttachedObjectInfo[playerid][index][aoOffset][1] 	= fOffsetY;
	AttachedObjectInfo[playerid][index][aoOffset][2] 	= fOffsetZ;
	AttachedObjectInfo[playerid][index][aoRot][0] 		= fRotX;
	AttachedObjectInfo[playerid][index][aoRot][1] 		= fRotY;
	AttachedObjectInfo[playerid][index][aoRot][2] 		= fRotZ;
	AttachedObjectInfo[playerid][index][aoScale][0] 	= fScaleX;
	AttachedObjectInfo[playerid][index][aoScale][1] 	= fScaleY;
	AttachedObjectInfo[playerid][index][aoScale][2] 	= fScaleZ;
	AttachedObjectInfo[playerid][index][aoMColor][0]	= materialcolor1;
	AttachedObjectInfo[playerid][index][aoMColor][1]	= materialcolor2;
	return SetPlayerAttachedObject(playerid, index, modelid, bone, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ, materialcolor1, materialcolor2);
}
#if defined _ALS_SetPlayerAttachedObject
	#undef SetPlayerAttachedObject
#else
	#define _ALS_SetPlayerAttachedObject
#endif
#define SetPlayerAttachedObject SetPlayerAttachedObject_
//-----<  >---------------------------------------------------------------------
//-----< PlayAudioStreamForPlayer >---------------------------------------------
stock PlayAudioStreamForPlayer_(playerid, url[], Float:posX = 0.0, Float:posY = 0.0, Float:posZ = 0.0, Float:distance = 50.0, usepos = 0)
{
	if (Audio_IsClientConnected(playerid))
	{
		Audio_MainStreamIndex[playerid] = Audio_PlayStreamed(playerid, url) + 1;
		return 1;
	}
	PlayAudioStreamForPlayer(playerid, url, posX, posY, posZ, distance, usepos);
	for (new i = 0; i < ClientMessages[playerid]; i++)
		SendClientMessage(playerid, ClientMessageInfo[playerid][i][cmColor], ClientMessageInfo[playerid][i][cmMessage]);
	return 1;
}
#if defined _ALS_PlayAudioStreamForPlayer
	#undef PlayAudioStreamForPlayer
#else
	#define _ALS_PlayAudioStreamForPlayer
#endif
#define PlayAudioStreamForPlayer PlayAudioStreamForPlayer_
//-----< StopAudioStreamForPlayer >---------------------------------------------
stock StopAudioStreamForPlayer_(playerid)
{
	if (Audio_MainStreamIndex[playerid])
	{
		Audio_Stop(playerid, Audio_MainStreamIndex[playerid] - 1);
		Audio_MainStreamIndex[playerid] = 0;
	}
	return StopAudioStreamForPlayer(playerid);
}
#if defined _ALS_StopAudioStreamForPlayer
	#undef StopAudioStreamForPlayer
#else
	#define _ALS_StopAudioStreamForPlayer
#endif
#define StopAudioStreamForPlayer StopAudioStreamForPlayer_
//-----<  >---------------------------------------------------------------------
//-----< SendClientMessage >----------------------------------------------------
stock SendClientMessage_(playerid, color, const message[])
{
	if (ClientMessages[playerid] >= 100)
	{
		for (new i = 0; i < 100 - 1; i++)
		{
			ClientMessageInfo[i][cmColor] = ClientMessageInfo[i+1][cmColor];
			strcpy(ClientMessageInfo[i][cmMessage], ClientMessageInfo[i+1][cmMessage]);
		}
		ClientMessages[playerid] = 100 - 1;
	}
	new index = ClientMessages[playerid];
	ClientMessageInfo[playerid][index][cmColor] = color;
	strmid(ClientMessageInfo[playerid][index][cmMessage], message, 0, 512, 512);
	ClientMessages[playerid]++;
	return SendClientMessage(playerid, color, message);
}
#if defined _ALS_SendClientMessage
	#undef SendClientMessage
#else
	#define _ALS_SendClientMessage
#endif
#define SendClientMessage SendClientMessage_
//-----< SendClientMessageToAll >-----------------------------------------------
stock SendClientMessageToAll_(color, const message[])
{
	for (new i = 0, t = GetMaxPlayers(); i < t; i++)
		SendClientMessage(i, color, message);
	return 1;
}
#if defined _ALS_SendClientMessageToAll
	#undef SendClientMessageToAll
#else
	#define _ALS_SendClientMessageToAll
#endif
#define SendClientMessageToAll SendClientMessageToAll_
//-----<  >---------------------------------------------------------------------
//-----< TextDrawCreate >-------------------------------------------------------
stock Text:TextDrawCreate_(Float:x, Float:y, text[])
{
	new Text:text = TextDrawCreate(x, y, text);
	for (new i = 0; i < MAX_TEXT_DRAWS; i++)
		if (TextDrawInfo[i][tdID] == INVALID_TEXT_DRAW)
		{
			TextDrawInfo[i][tdID]				= text;
			TextDrawInfo[i][tdPos][0]			= x;
			TextDrawInfo[i][tdPos][1]			= y;
			strmid(TextDrawInfo[i][tdText], text, 0, 512, 512);
			TextDrawInfo[i][tdLetterSize][0]	= 0.0;
			TextDrawInfo[i][tdLetterSize][1]	= 0.0;
			TextDrawInfo[i][tdTextSize][0]		= 0.0;
			TextDrawInfo[i][tdTextSize][1]		= 0.0;
			TextDrawInfo[i][tdAlignment]		= 0;
			TextDrawInfo[i][tdColor]			= 0;
			TextDrawInfo[i][tdUseBox]			= 0;
			TextDrawInfo[i][tdShadow]			= 0;
			TextDrawInfo[i][tdOutline]			= 0;
			TextDrawInfo[i][tdBackgroundColor]	= 0;
			TextDrawInfo[i][tdFont]				= 0;
			TextDrawInfo[i][tdProportional]		= 0;
			for (new j = 0, t = GetMaxPlayers(); j < t; j++)
				TextDrawInfo[i][tdPlayer][j]	= false;
			TextDrawInfo[i][tdPreviewModel]		= 0;
			TextDrawInfo[i][tdPreviewRot][0]	= 0.0;
			TextDrawInfo[i][tdPreviewRot][1]	= 0.0;
			TextDrawInfo[i][tdPreviewRot][2]	= 0.0;
			TextDrawInfo[i][tdPreviewRot][3]	= 0.0;
			TextDrawInfo[i][tdPreviewVehCol][0] = 0;
			TextDrawInfo[i][tdPreviewVehCol][1] = 0;
			break;
		}
	return text;
}
#if defined _ALS_TextDrawCreate
	#undef TextDrawCreate
#else
	#define _ALS_TextDrawCreate
#endif
#define TextDrawCreate TextDrawCreate_
//-----< TextDrawDestroy >------------------------------------------------------
stock TextDrawDestroy_(Text:text)
{
	for (new i = 0; i < MAX_TEXT_DRAWS; i++)
		if (TextDrawInfo[i][tdID] == text)
		{
			TextDrawInfo[i][tdID] = INVALID_TEXT_DRAW;
			break;
		}
	return TextDrawDestroy(text);
}
#if defined _ALS_TextDrawDestroy
	#undef TextDrawDestroy
#else
	#define _ALS_TextDrawDestroy
#endif
#define TextDrawDestroy TextDrawDestroy_
//-----< TextDrawLetterSize >---------------------------------------------------
stock TextDrawLetterSize_(Text:text, Float:x, Float:y)
{
	for (new i = 0; i < MAX_TEXT_DRAWS; i++)
		if (TextDrawInfo[i][tdID] == text)
		{
			TextDrawInfo[i][tdLetterSize][0] = x;
			TextDrawInfo[i][tdLetterSize][1] = y;
			break;
		}
	return TextDrawLetterSize(text, x, y);
}
#if defined _ALS_TextDrawLetterSize
	#undef TextDrawLetterSize
#else
	#define _ALS_TextDrawLetterSize
#endif
#define TextDrawLetterSize TextDrawLetterSize_
//-----< TextDrawTextSize >-----------------------------------------------------
stock TextDrawTextSize_(Text:text, Float:x, Float:y)
{
	for (new i = 0; i < MAX_TEXT_DRAWS; i++)
		if (TextDrawInfo[i][tdID] == text)
		{
			TextDrawInfo[i][tdTextSize][0] = x;
			TextDrawInfo[i][tdTextSize][1] = y;
			break;
		}
	return TextDrawTextSize(text, x, y);
}
#if defined _ALS_TextDrawTextSize
	#undef TextDrawTextSize
#else
	#define _ALS_TextDrawTextSize
#endif
#define TextDrawTextSize TextDrawTextSize_
//-----< TextDrawAlignment >----------------------------------------------------
stock TextDrawAlignment_(Text:text, alignment)
{
	for (new i = 0; i < MAX_TEXT_DRAWS; i++)
		if (TextDrawInfo[i][tdID] == text)
		{
			TextDrawInfo[i][tdAlignment] = alignment;
			break;
		}
	return TextDrawAlignment(text, alignment);
}
#if defined _ALS_TextDrawAlignment
	#undef TextDrawAlignment
#else
	#define _ALS_TextDrawAlignment
#endif
#define TextDrawAlignment TextDrawAlignment_
//-----< TextDrawColor >--------------------------------------------------------
stock TextDrawColor_(Text:text, color)
{
	for (new i = 0; i < MAX_TEXT_DRAWS; i++)
		if (TextDrawInfo[i][tdID] == text)
		{
			TextDrawInfo[i][tdColor] = color;
			break;
		}
	return TextDrawColor(text, color);
}
#if defined _ALS_TextDrawColor
	#undef TextDrawColor
#else
	#define _ALS_TextDrawColor
#endif
#define TextDrawColor TextDrawColor_
//-----< TextDrawUseBox >-------------------------------------------------------
stock TextDrawUseBox_(Text:text, use)
{
	for (new i = 0; i < MAX_TEXT_DRAWS; i++)
		if (TextDrawInfo[i][tdID] == text)
		{
			TextDrawInfo[i][tdUseBox] = use;
			break;
		}
	return TextDrawUseBox(text, use);
}
#if defined _ALS_TextDrawUseBox
	#undef TextDrawUseBox
#else
	#define _ALS_TextDrawUseBox
#endif
#define TextDrawUseBox TextDrawUseBox_
//-----< TextDrawBoxColor >-----------------------------------------------------
stock TextDrawBoxColor_(Text:text, color)
{
	for (new i = 0; i < MAX_TEXT_DRAWS; i++)
		if (TextDrawInfo[i][tdID] == text)
		{
			TextDrawInfo[i][tdBoxColor] = color;
			break;
		}
	return TextDrawBoxColor(text, color);
}
#if defined _ALS_TextDrawBoxColor
	#undef TextDrawBoxColor
#else
	#define _ALS_TextDrawBoxColor
#endif
#define TextDrawBoxColor TextDrawBoxColor_
//-----< TextDrawSetShadow >----------------------------------------------------
stock TextDrawSetShadow_(Text:text, size)
{
	for (new i = 0; i < MAX_TEXT_DRAWS; i++)
		if (TextDrawInfo[i][tdID] == text)
		{
			TextDrawInfo[i][tdShadow] = size;
			break;
		}
	return TextDrawSetShadow(text, size);
}
#if defined _ALS_TextDrawSetShadow
	#undef TextDrawSetShadow
#else
	#define _ALS_TextDrawSetShadow
#endif
#define TextDrawSetShadow TextDrawSetShadow_
//-----< TextDrawSetOutline >---------------------------------------------------
stock TextDrawSetOutline_(Text:text, size)
{
	for (new i = 0; i < MAX_TEXT_DRAWS; i++)
		if (TextDrawInfo[i][tdID] == text)
		{
			TextDrawInfo[i][tdOutline] = size;
			break;
		}
	return TextDrawSetOutline(text, size);
}
#if defined _ALS_TextDrawSetOutline
	#undef TextDrawSetOutline
#else
	#define _ALS_TextDrawSetOutline
#endif
#define TextDrawSetOutline TextDrawSetOutline_
//-----< TextDrawBackgroundColor >----------------------------------------------
stock TextDrawBackgroundColor_(Text:text, color)
{
	for (new i = 0; i < MAX_TEXT_DRAWS; i++)
		if (TextDrawInfo[i][tdID] == text)
		{
			TextDrawInfo[i][tdBackgroundColor] = color;
			break;
		}
	return TextDrawBackgroundColor(text, color);
}
#if defined _ALS_TextDrawBackgroundColor
	#undef TextDrawBackgroundColor
#else
	#define _ALS_TextDrawBackgroundColor
#endif
#define TextDrawBackgroundColor TextDrawBackgroundColor_
//-----< TextDrawFont >---------------------------------------------------------
stock TextDrawFont_(Text:text, font)
{
	for (new i = 0; i < MAX_TEXT_DRAWS; i++)
		if (TextDrawInfo[i][tdID] == text)
		{
			TextDrawInfo[i][tdFont] = font;
			break;
		}
	return TextDrawFont(text, font);
}
#if defined _ALS_TextDrawFont
	#undef TextDrawFont
#else
	#define _ALS_TextDrawFont
#endif
#define TextDrawFont TextDrawFont_
//-----< TextDrawSetProportional >----------------------------------------------
stock TextDrawSetProportional_(Text:text, set)
{
	for (new i = 0; i < MAX_TEXT_DRAWS; i++)
		if (TextDrawInfo[i][tdID] == text)
		{
			TextDrawInfo[i][tdProportional] = set;
			break;
		}
	return TextDrawSetProportional(text, set);
}
#if defined _ALS_TextDrawSetProportional
	#undef TextDrawSetProportional
#else
	#define _ALS_TextDrawSetProportional
#endif
#define TextDrawsetProportional TextDrawSetProportional_
//-----< TextDrawSetSelectable >------------------------------------------------
stock TextDrawSetSelectable_(Text:text, set)
{
	for (new i = 0; i < MAX_TEXT_DRAWS; i++)
		if (TextDrawInfo[i][tdID] == text)
		{
			TextDrawInfo[i][tdSelectable] = set;
			break;
		}
	return TextDrawSetSelectable(text, set);
}
#if defined _ALS_TextDrawSetSelectable
	#undef TextDrawSetSelectable
#else
	#define _ALS_TextDrawSetSelectable
#endif
#define TextDrawSetSelectable TextDrawSetSelectable_
//-----< TextDrawShowForPlayer >------------------------------------------------
stock TextDrawShowForPlayer_(playerid, Text:text)
{
	for (new i = 0; i < MAX_TEXT_DRAWS; i++)
		if (TextDrawInfo[i][tdID] == text)
		{
			TextDrawInfo[i][tdPlayer][playerid] = true;
			break;
		}
	return TextDrawShowForPlayer(text, playerid);
}
#if defined _ALS_TextDrawShowForPlayer
	#undef TextDrawShowForPlayer
#else
	#define _ALS_TextDrawShowForPlayer
#endif
#define TextDrawShowForPlayer TextDrawShowForPlayer_
//-----< TextDrawHideForPlayer >------------------------------------------------
stock TextDrawHideForPlayer_(playerid, Text:text)
{
	for (new i = 0; i < MAX_TEXT_DRAWS; i++)
		if (TextDrawInfo[i][tdID] == text)
		{
			TextDrawInfo[i][tdPlayer][playerid] = false;
			break;
		}
	return TextDrawHideForPlayer(text, playerid);
}
#if defined _ALS_TextDrawHideForPlayer
	#undef TextDrawUseBox
#else
	#define _ALS_TextDrawUseBox
#endif
#define TextDrawUseBox TextDrawUseBox_
//-----< TextDrawShowForAll >---------------------------------------------------
stock TextDrawShowForAll_(Text:text)
{
	for (new i = 0; i < MAX_TEXT_DRAWS; i++)
		if (TextDrawInfo[i][tdID] == text)
		{
			for (new j = 0, t = GetMaxPlayers(); j < t; j++)
				TextDrawInfo[i][tdPlayer][j] = true;
			break;
		}
	return TextDrawShowForAll(text);
}
#if defined _ALS_TextDrawShowForAll
	#undef TextDrawShowForAll
#else
	#define _ALS_TextDrawShowForAll
#endif
#define TextDrawShowForAll TextDrawShowForAll_
//-----< TextDrawHideForAll >---------------------------------------------------
stock TextDrawHideForAll_(Text:text)
{
	for (new i = 0; i < MAX_TEXT_DRAWS; i++)
		if (TextDrawInfo[i][tdID] == text)
		{
			for (new j = 0, t = GetMaxPlayers(); j < t; j++)
				TextDrawInfo[i][tdPlayer][j] = false;
			break;
		}
	return TextDrawHideForAll(text);
}
#if defined _ALS_TextDrawHideForAll
	#undef TextDrawHideForAll
#else
	#define _ALS_TextDrawHideForAll
#endif
#define TextDrawHideForAll TextDrawHideForAll_
//-----< TextDrawSetString >----------------------------------------------------
stock TextDrawSetString_(Text:text, string[])
{
	for (new i = 0; i < MAX_TEXT_DRAWS; i++)
		if (TextDrawInfo[i][tdID] == text)
		{
			strmid(TextDrawInfo[i][tdText], string, 0, 512, 512);
			break;
		}
	return TextDrawSetString(text, string);
}
#if defined _ALS_TextDrawSetString
	#undef TextDrawSetString
#else
	#define _ALS_TextDrawSetString
#endif
#define TextDrawSetString TextDrawSetString_
//-----< TextDrawSetPreviewModel >----------------------------------------------
stock TextDrawSetPreviewModel_(Text:text, modelindex)
{
	for (new i = 0; i < MAX_TEXT_DRAWS; i++)
		if (TextDrawInfo[i][tdID] == text)
		{
			TextDrawInfo[i][tdPreviewModel] = modelindex;
			break;
		}
	return TextDrawSetPreviewModel(text, modelindex);
}
#if defined _ALS_TextDrawSetPreviewModel
	#undef TextDrawSetPreviewModel
#else
	#define _ALS_TextDrawSetPreviewModel
#endif
#define TextDrawSetPreviewModel TextDrawSetPreviewModel_
//-----< TextDrawSetPreviewRot >------------------------------------------------
stock TextDrawSetPreviewRot_(Text:text, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fZoom = 1.0)
{
	for (new i = 0; i < MAX_TEXT_DRAWS; i++)
		if (TextDrawInfo[i][tdID] == text)
		{
			TextDrawInfo[i][tdPreviewRot][0] = fRotX;
			TextDrawInfo[i][tdPreviewRot][1] = fRotY;
			TextDrawInfo[i][tdPreviewRot][2] = fRotZ;
			TextDrawInfo[i][tdPreviewRot][3] = fZoom;
			break;
		}
	return TextDrawSetPreviewRot(text, fRotX, fRotY, fRotZ, fZoom);
}
#if defined _ALS_TextDrawSetPreviewRot
	#undef TextDrawSetPreviewRot
#else
	#define _ALS_TextDrawSetPreviewRot
#endif
#define TextDrawSetPreviewRot TextDrawSetPreviewRot_
//-----< TextDrawSetPreviewVehCol >---------------------------------------------
stock TextDrawSetPreviewVehCol_(Text:text, color1, color2)
{
	for (new i = 0; i < MAX_TEXT_DRAWS; i++)
		if (TextDrawInfo[i][tdID] == text)
		{
			TextDrawInfo[i][tdPreviewVehCol][0] = color1;
			TextDrawInfo[i][tdPreviewVehCol][1] = color2;
			break;
		}
	return TextDrawSetPreviewVehCol(text, color1, color2);
}
#if defined _ALS_TextDrawSetPreviewVehCol
	#undef TextDrawSetPreviewVehCol
#else
	#define _ALS_TextDrawSetPreviewVehCol
#endif
#define TextDrawSetPreviewVehCol TextDrawSetPreviewVehCol_
//-----<  >---------------------------------------------------------------------



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
//-----< GetPVarType_ >---------------------------------------------------------
stock GetPVarType_(playerid, varname[], array=0)
{
	new varname_[64];
	format(varname_, sizeof(varname_), "%s_%d", varname, array);
	return GetPVarType(playerid, varname_);
}
//-----< escape >---------------------------------------------------------------
stock escape(str[])
{
	new escaped[256];
	mysql_real_escape_string(str, escaped);
	if (!strcmp(escaped, "NULL"))
		strcpy(escaped, " ");
	return escaped;
}
//-----< ResetPlayerDialogData >------------------------------------------------
stock ResetPlayerDialogData(playerid)
{
	for (new i = 0; i < sizeof(DialogData); i++)
		DialogData[playerid][i] = 0;
	return 1;
}
//-----< strtab >---------------------------------------------------------------
stock strtab(dest[], str[], maxlength)
{
	new len = strlen(dest) + maxlength;
	strcat(dest, str, len);
	for (new i = 7; i < maxlength; i += 7)
		if (strlen(str) <= i)
		{
			len += 7;
			strcat(dest, "\t", len);
		}
	len += 7;
	strcat(dest, "\t", len);
}
//-----< valstr_ >--------------------------------------------------------------
stock valstr_(value)
{
	new str[32];
	valstr(str, value);
	return str;
}
//-----< GivePlayerDamage >-----------------------------------------------------
stock GivePlayerDamage(playerid, Float:amount)
{
	new Float:armour, Float:health;
	GetPlayerArmour(playerid, armour);
	GetPlayerHealth(playerid, health);
	if(amount > 0)
	{
		if(armour > 0)
		{
			if(armour >= amount)
			{
		   		SetPlayerArmour(playerid, armour - amount);
			}
			else
			{
				SetPlayerArmour(playerid, 0);
				SetPlayerHealth(playerid, health + (armour - amount));
			}
		}
		else
		{
			SetPlayerHealth(playerid, health - amount);
		}
	}
	else
	{
		if(armour > 0)
		{
		   	SetPlayerArmour(playerid, armour - amount);
		}
		else
		{
			SetPlayerHealth(playerid, health - amount);
		}
	}
	return 1;
}

//-----<  >---------------------------------------------------------------------
