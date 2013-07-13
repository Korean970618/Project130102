/*
 *
 *
 *			Nogov Main Include
 *		  	2013/01/02
 *
 *
 *		Copyright (c) sBum. All rights reserved.
 *
 *
 */
/*

  < Hook Callbacks >
	OnPlayerConnect(playerid)
	OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
	OnPlayerStreamIn(playerid, forplayerid)

  < Hook Functions >
	ShowPlayerDialog(playerid, dialogid, style, caption[], info[], button1[], button2[])
	SetPlayerAttachedObject(playerid, index, modelid, bone, Float:fOffsetX = 0.0, Float:fOffsetY = 0.0, Float:fOffsetZ = 0.0, Float:fRotX = 0.0, Float:fRotY = 0.0, Float:fRotZ = 0.0, Float:fScaleX = 1.0, Float:fScaleY = 1.0, Float:fScaleZ = 1.0, materialcolor1 = 0, materialcolor2 = 0)

	PlayAudioStreamForPlayer(playerid, url[], Float:posX = 0.0, Float:posY = 0.0, Float:posZ = 0.0, Float:distance = 50.0, usepos = 0)
	StopAudioStreamForPlayer(playerid);

	SendClientMessage(playerid, color, const message[])
	SendClientMessageToAll(color, const message[])
	
	ApplyAnimation(playerid, animlib[], animname[], Float:fDelta, loop, lockx, locky, freeze, time, forcesync = 0)
	ClearAnimations(playerid, forcesync = 0)
	
	SetPVarInt(playerid, varname[], int_value, array=0)
	Float:SetPVarFloat(playerid, varname[], Float:float_value, array=0)
	SetPVarString(playerid, varname[], string_value[], array=0)
	GetPVarInt(playerid, varname[], array=0)
	Float:GetPVarFloat(playerid, varname[], array=0)
	GetPVarString(playerid, varname[], array=0)
	DeletePVar(playerid, varname[], array=0)
	GetPVarType(playerid, varname[], array=0)
	
	strcmp(const string1[], const string2[], bool:ignorecase=false, length=cellmax)
	strlen(const string[])
	
	GivePlayerWeapon(playerid, weaponid, ammo)
	ResetPlayerWeapons(playerid)
	SetPlayerAmmo(playerid, weaponslot, ammo)
	
	SetPlayerInterior(playerid, interiorid)
	
	SetPlayerHealth(playerid, Float:health)
	SetPlayerArmour(playerid, Float:armour)

  < Functions >
	native strcpy(dest[], src[], deststart=0, destend=-1, srcstart=0, srcend=-1);
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
	native escape(str[])
	native ResetPlayerDialogData(playerid);
	native strtab(dest[], str[], maxlength);
	native valstr_(value);
	native GivePlayerHealth(playerid, Float:amount);
	native Float:GetDistanceBetweenPoints(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2);
	native GetWeaponObjectModelID(weaponid);
	native GetWeaponNameA(weaponid);
	native udb_hash(buf[]);
	native GetWeaponSlotID(weaponid);
	native GetWeaponHand(weaponid);
	native ShowLastDialog(playerid);
	native ReshowDialog(playerid, id=0);
	native TimeConvert(returntype, second);
	native TimeMeasure(returntype, second);
	native GetDateCode();
	native GetTimeCode();

*/



//-----< Pragmas
#pragma dynamic					20000000



//-----< Defines
#define MAX_WEAPONS			 	47
#define MAX_DIALOGS			 	1000
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



//-----< Variables
new DialogData[MAX_PLAYERS][100];
new MpListData[MAX_PLAYERS][100];
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
enum eAnimationInfo
{
	aLib[32],
	aName[64],
	Float:aDelta,
	aLoop,
	aLockX,
	aLockY,
	aFreeze,
	aTime,
	aForceSync
}
enum eDialogInfo
{
	dStyle,
	dCaption[64],
	dInfo[2048],
	dButton1[64],
	dButton2[64],
	dBeforeDialog
}
new AttachedObjectInfo[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS][eAttachedObjectInfo],
	Audio_MainStreamIndex[MAX_PLAYERS],
	ClientMessages[MAX_PLAYERS],
	ClientMessageInfo[MAX_PLAYERS][100][eClientMessageInfo],
	AnimationInfo[MAX_PLAYERS][eAnimationInfo],
	DialogInfo[MAX_PLAYERS][MAX_DIALOGS][eDialogInfo],
	LastDialog[MAX_PLAYERS],
	WeaponInfo[MAX_PLAYERS][MAX_WEAPONS],
	InteriorInfo[MAX_PLAYERS],
	Float:HealthInfo[MAX_PLAYERS],
	Float:ArmourInfo[MAX_PLAYERS];



//-----< Forwards
forward OnDialogRequest(playerid, dialogid, olddialogid);



//-----< Hook Callbacks
forward OnPlayerConnect_(playerid);
forward OnPlayerEditAttachedObject_(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ);
forward OnPlayerStreamIn_(playerid, forplayerid);
forward OnPlayerKeyStateChange_(playerid, newkeys, oldkeys);
//-----< OnPlayerConnect >------------------------------------------------------
public OnPlayerConnect(playerid)
{
	for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
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
	for(new i = 0; i < 100; i++)
	{
		ClientMessageInfo[playerid][i][cmColor] = 0;
		strcpy(ClientMessageInfo[playerid][i][cmMessage], chNullString);
	}
	
	strcpy(AnimationInfo[playerid][aLib], chNullString);
	strcpy(AnimationInfo[playerid][aName], chNullString);
	AnimationInfo[playerid][aDelta] = 0.0;
	AnimationInfo[playerid][aLoop] = 0;
	AnimationInfo[playerid][aLockX] = 0;
	AnimationInfo[playerid][aLockY] = 0;
	AnimationInfo[playerid][aFreeze] = 0;
	AnimationInfo[playerid][aTime] = 0;
	AnimationInfo[playerid][aForceSync] = 0;
	
	for(new i = 0; i < MAX_DIALOGS; i++)
	{
		DialogInfo[playerid][i][dStyle] = 0;
		strcpy(DialogInfo[playerid][i][dCaption], chNullString);
		strcpy(DialogInfo[playerid][i][dInfo], chNullString);
		strcpy(DialogInfo[playerid][i][dButton1], chNullString);
		strcpy(DialogInfo[playerid][i][dButton2], chNullString);
		DialogInfo[playerid][i][dBeforeDialog] = 0;
	}
	LastDialog[playerid] = 0;
	
	for(new i = 0; i < MAX_WEAPONS; i++)
		WeaponInfo[playerid][i] = 0;
	InteriorInfo[playerid] = 0;
	HealthInfo[playerid] = 100.0;
	ArmourInfo[playerid] = 0.0;
	
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
//-----< OnPlayerStreamIn >-----------------------------------------------------
public OnPlayerStreamIn(playerid, forplayerid)
{
	if(strlen(AnimationInfo[forplayerid][aLib]) && AnimationInfo[forplayerid][aForceSync])
	{
		ApplyAnimation(forplayerid, AnimationInfo[forplayerid][aLib], AnimationInfo[forplayerid][aName], AnimationInfo[forplayerid][aDelta],
			AnimationInfo[forplayerid][aLockX], AnimationInfo[forplayerid][aLockY], AnimationInfo[forplayerid][aFreeze], AnimationInfo[forplayerid][aTime], true);
	}
	return OnPlayerStreamIn_(playerid, forplayerid);
}
#if defined _ALS_OnPlayerStreamIn
	#undef OnPlayerStreamIn
#else
	#define _ALS_OnPlayerStreamIn
#endif
#define OnPlayerStreamIn OnPlayerStreamIn_
//-----< OnPlayerKeyStateChange >-----------------------------------------------
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(strlen(AnimationInfo[playerid][aLib]) && AnimationInfo[playerid][aForceSync]
	&& (newkeys & KEY_JUMP || newkeys & KEY_FIRE || newkeys & KEY_SECONDARY_ATTACK))
		ClearAnimations_(playerid, true);
	return OnPlayerKeyStateChange_(playerid, newkeys, oldkeys);
}
#if defined _ALS_OnPlayerKeyStateChange
	#undef OnPlayerKeyStateChange
#else
	#define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange OnPlayerKeyStateChange_
//-----<  >---------------------------------------------------------------------



//-----< Hook Functions
//-----< ShowPlayerDialog >-----------------------------------------------------
stock ShowPlayerDialog_(playerid, dialogid, style, caption[], info[], button1[], button2[])
{
	new caption_[64],
		info_[2048];
	format(caption_, sizeof(caption_), "%s%s", C_PASTEL_BLUE, caption);
	format(info_, sizeof(info_), "%s%s", C_WHITE, info);
	
	if(OnDialogRequest(playerid, dialogid, LastDialog[playerid]))
	{
		DialogInfo[playerid][dialogid][dStyle] = style;
		strcpy(DialogInfo[playerid][dialogid][dCaption], caption);
		strcpy(DialogInfo[playerid][dialogid][dInfo], info);
		strcpy(DialogInfo[playerid][dialogid][dButton1], button1);
		strcpy(DialogInfo[playerid][dialogid][dButton2], button2);
		DialogInfo[playerid][dialogid][dBeforeDialog] = LastDialog[playerid];
		
		LastDialog[playerid] = dialogid;
		return ShowPlayerDialog(playerid, dialogid, style, caption_, info_, button1, button2);
	}
	return 0;
}
stock _ShowPlayerDialog(playerid, dialogid, style, caption[], info[], button1[], button2[])
	return ShowPlayerDialog(playerid, dialogid, style, caption, info, button1, button2);
#if defined _ALS_ShowPlayerDialog
	#undef ShowPlayerDialog
#else
	#define _ALS_ShowPlayerDialog
#endif
#define ShowPlayerDialog ShowPlayerDialog_
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
stock _SetPlayerAttachedObject(playerid, index, modelid, bone, Float:fOffsetX = 0.0, Float:fOffsetY = 0.0, Float:fOffsetZ = 0.0, Float:fRotX = 0.0, Float:fRotY = 0.0, Float:fRotZ = 0.0, Float:fScaleX = 1.0, Float:fScaleY = 1.0, Float:fScaleZ = 1.0, materialcolor1 = 0, materialcolor2 = 0)
	return SetPlayerAttachedObject(playerid, index, modelid, bone, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ, materialcolor1, materialcolor2);
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
	if(Audio_IsClientConnected(playerid))
	{
		Audio_MainStreamIndex[playerid] = Audio_PlayStreamed(playerid, url) + 1;
		return 1;
	}
	PlayAudioStreamForPlayer(playerid, url, posX, posY, posZ, distance, usepos);
	for(new i = 0; i < ClientMessages[playerid]; i++)
		SendClientMessage(playerid, ClientMessageInfo[playerid][i][cmColor], ClientMessageInfo[playerid][i][cmMessage]);
	return 1;
}
stock _PlayAudioStreamForPlayer(playerid, url[], Float:posX = 0.0, Float:posY = 0.0, Float:posZ = 0.0, Float:distance = 50.0, usepos = 0)
	return PlayAudioStreamForPlayer(playerid, url, posX, posY, posZ, distance, usepos);
#if defined _ALS_PlayAudioStreamForPlayer
	#undef PlayAudioStreamForPlayer
#else
	#define _ALS_PlayAudioStreamForPlayer
#endif
#define PlayAudioStreamForPlayer PlayAudioStreamForPlayer_
//-----< StopAudioStreamForPlayer >---------------------------------------------
stock StopAudioStreamForPlayer_(playerid)
{
	if(Audio_MainStreamIndex[playerid])
	{
		Audio_Stop(playerid, Audio_MainStreamIndex[playerid] - 1);
		Audio_MainStreamIndex[playerid] = 0;
	}
	return StopAudioStreamForPlayer(playerid);
}
stock _StopAudioStreamForPlayer(playerid)
	return StopAudioStreamForPlayer(playerid);
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
	if(ClientMessages[playerid] >= 100)
	{
		for(new i = 0; i < 100 - 1; i++)
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
stock _SendClientMessage(playerid, color, const message[])
	return SendClientMessage(playerid, color, message);
#if defined _ALS_SendClientMessage
	#undef SendClientMessage
#else
	#define _ALS_SendClientMessage
#endif
#define SendClientMessage SendClientMessage_
//-----< SendClientMessageToAll >-----------------------------------------------
stock SendClientMessageToAll_(color, const message[])
{
	for(new i = 0, t = GetMaxPlayers(); i < t; i++)
		SendClientMessage(i, color, message);
	return 1;
}
stock _SendClientMessageToAll(color, const message[])
	return SendClientMessageToAll(color, message);
#if defined _ALS_SendClientMessageToAll
	#undef SendClientMessageToAll
#else
	#define _ALS_SendClientMessageToAll
#endif
#define SendClientMessageToAll SendClientMessageToAll_
//-----<  >---------------------------------------------------------------------
//-----< ApplyAnimation >-------------------------------------------------------
stock ApplyAnimation_(playerid, animlib[], animname[], Float:fDelta, loop, lockx, locky, freeze, time, forcesync = 0)
{
	strcpy(AnimationInfo[playerid][aLib], animlib);
	strcpy(AnimationInfo[playerid][aName], animname);
	AnimationInfo[playerid][aDelta] = fDelta;
	AnimationInfo[playerid][aLoop] = loop;
	AnimationInfo[playerid][aLockX] = lockx;
	AnimationInfo[playerid][aLockY] = locky;
	AnimationInfo[playerid][aFreeze] = freeze;
	AnimationInfo[playerid][aTime] = time;
	AnimationInfo[playerid][aForceSync] = forcesync;
	ApplyAnimation(playerid, animlib, animname, fDelta, loop, lockx, locky, freeze, time, forcesync);
	return 1;
}
stock _ApplyAnimation(playerid, animlib[], animname[], Float:fDelta, loop, lockx, locky, freeze, time, forcesync = 0)
	return ApplyAnimation(playerid, animlib, animname, fDelta, loop, lockx, locky, freeze, time, forcesync);
#if defined _ALS_ApplyAnimation
	#undef ApplyAnimation
#else
	#define _ALS_ApplyAnimation
#endif
#define ApplyAnimation ApplyAnimation_
//-----< ClearAnimations >------------------------------------------------------
stock ClearAnimations_(playerid, forcesync = 0)
{
	_ApplyAnimation(playerid, "PED", "facgum", 4.1, 0, 1, 1, 1, 1, forcesync);
	strcpy(AnimationInfo[playerid][aLib], chNullString);
	return 1;
}
stock _ClearAnimations(playerid, forcesync = 0)
	return ClearAnimations(playerid, forcesync);
#if defined _ALS_ClearAnimations
	#undef ClearAnimations
#else
	#define _ALS_ClearAnimations
#endif
#define ClearAnimations ClearAnimations_
//-----<  >---------------------------------------------------------------------
//-----< SetPVarInt >-----------------------------------------------------------
stock SetPVarInt_(playerid, varname[], int_value, array=0)
{
	if(array == 0)
	{
		SetPlayerData(playerid, varname, PLAYER_VARTYPE_INT, int_value, 0.0, chNullString);
		SetPVarInt(playerid, varname, int_value);
	}
	else
	{
		new varname_[64];
		format(varname_, sizeof(varname_), "%s_%d", varname, array);
		if(int_value == 0)
		{
			DeletePlayerData(playerid, varname_);
			DeletePVar(playerid, varname_);
		}
		else
		{
			SetPlayerData(playerid, varname_, PLAYER_VARTYPE_INT, int_value, 0.0, chNullString);
			SetPVarInt(playerid, varname_, int_value);
		}
	}
}
stock _SetPVarInt(playerid, varname[], int_value)
	return SetPVarInt(playerid, varname, int_value);
#if defined _ALS_SetPVarInt
	#undef SetPVarInt
#else
	#define _ALS_SetPVarInt
#endif
#define SetPVarInt SetPVarInt_
//-----< SetPVarFloat >---------------------------------------------------------
stock Float:SetPVarFloat_(playerid, varname[], Float:float_value, array=0)
{
	if(array == 0)
	{
		SetPlayerData(playerid, varname, PLAYER_VARTYPE_FLOAT, 0, float_value, chNullString);
		SetPVarFloat(playerid, varname, float_value);
	}
	else
	{
		new varname_[64];
		format(varname_, sizeof(varname_), "%s_%d", varname, array);
		if(float_value == 0.0)
		{
			DeletePlayerData(playerid, varname_);
			DeletePVar(playerid, varname_);
		}
		else
		{
			SetPlayerData(playerid, varname_, PLAYER_VARTYPE_INT, 0, float_value, chNullString);
			SetPVarFloat(playerid, varname_, float_value);
		}
	}
}
stock _SetPVarFloat(playerid, varname[], Float:float_value)
	return SetPVarFloat(playerid, varname, float_value);
#if defined _ALS_SetPVarFloat
	#undef SetPVarFloat
#else
	#define _ALS_SetPVarFloat
#endif
#define SetPVarFloat SetPVarFloat_
//-----< SetPVarString >--------------------------------------------------------
stock SetPVarString_(playerid, varname[], string_value[], array=0)
{
	if(array == 0)
	{
		SetPlayerData(playerid, varname, PLAYER_VARTYPE_STRING, 0, 0.0, string_value);
		SetPVarString(playerid, varname, string_value);
	}
	else
	{
		new varname_[64];
		format(varname_, sizeof(varname_), "%s_%d", varname, array);
		if(strlen(string_value) == 0)
		{
			DeletePlayerData(playerid, varname_);
			DeletePVar(playerid, varname_);
		}
		else
		{
			SetPlayerData(playerid, varname_, PLAYER_VARTYPE_INT, 0, 0.0, string_value);
			SetPVarString(playerid, varname_, string_value);
		}
	}
}
stock _SetPVarString(playerid, varname[], string_value[])
	return SetPVarString(playerid, varname, string_value);
#if defined _ALS_SetPVarString
	#undef SetPVarString
#else
	#define _ALS_SetPVarString
#endif
#define SetPVarString SetPVarString_
//-----< GetPVarInt >-----------------------------------------------------------
stock GetPVarInt_(playerid, varname[], array=0)
{
	if(array == 0) return GetPVarInt(playerid, varname);
	new varname_[64];
	format(varname_, sizeof(varname_), "%s_%d", varname, array);
	return GetPVarInt(playerid, varname_);
}
stock _GetPVarInt(playerid, varname[])
	return GetPVarInt(playerid, varname);
#if defined _ALS_GetPVarInt
	#undef GetPVarInt
#else
	#define _ALS_GetPVarInt
#endif
#define GetPVarInt GetPVarInt_
//-----< GetPVarFloat >---------------------------------------------------------
stock Float:GetPVarFloat_(playerid, varname[], array=0)
{
	if(array == 0) return GetPVarFloat(playerid, varname);
	new varname_[64];
	format(varname_, sizeof(varname_), "%s_%d", varname, array);
	return GetPVarFloat(playerid, varname_);
}
stock _GetPVarFloat(playerid, varname[])
	return GetPVarFloat(playerid, varname);
#if defined _ALS_GetPVarFloat
	#undef GetPVarFloat
#else
	#define _ALS_GetPVarFloat
#endif
#define GetPVarFloat GetPVarFloat_
//-----< GetPVarString >--------------------------------------------------------
stock GetPVarString_(playerid, varname[], array=0)
{
	new string[512];
	if(array == 0)
	{
		GetPVarString(playerid, varname, string, sizeof(string));
		return string;
	}
	new varname_[64];
	format(varname_, sizeof(varname_), "%s_%d", varname, array);
	GetPVarString(playerid, varname_, string, sizeof(string));
	return string;
}
stock _GetPVarString(playerid, varname[])
	return GetPVarString(playerid, varname);
#if defined _ALS_GetPVarString
	#undef GetPVarString
#else
	#define _ALS_GetPVarString
#endif
#define GetPVarString GetPVarString_
//-----< DeletePVar_ >----------------------------------------------------------
stock DeletePVar_(playerid, varname[], array=0)
{
	if(array == 0)
	{
		DeletePVar(playerid, varname);
		DeletePlayerData(playerid, varname);
	}
	else
	{
		new varname_[64];
		format(varname_, sizeof(varname_), "%s_%d", varname, array);
		DeletePVar(playerid, varname_);
		DeletePlayerData(playerid, varname_);
	}
	return 1;
}
stock _DeletePVar(playerid, varname[])
	return DeletePVar(playerid, varname);
#if defined _ALS_DeletePVar
	#undef DeletePVar
#else
	#define _ALS_DeletePVar
#endif
#define DeletePVar DeletePVar_
//-----< GetPVarType >----------------------------------------------------------
stock GetPVarType_(playerid, varname[], array=0)
{
	if(array == 0) return GetPVarType(playerid, varname);
	new varname_[64];
	format(varname_, sizeof(varname_), "%s_%d", varname, array);
	return GetPVarType(playerid, varname_);
}
stock _GetPVarType(playerid, varname[])
	return GetPVarType(playerid, varname);
#if defined _ALS_GetPVarType
	#undef GetPVarType
#else
	#define _ALS_GetPVarType
#endif
#define GetPVarType GetPVarType_
//-----<  >---------------------------------------------------------------------
//-----< strcmp >---------------------------------------------------------------
stock strcmp_(const string1[], const string2[], bool:ignorecase=false, length=cellmax)
{
	if(strlen(string1) && strlen(string2) && strcmp(string1, string2, ignorecase, length) == 0) return 0;
	return 1;
}
stock _strcmp(const string1[], const string2[], bool:ignorecase=false, length=cellmax)
	return strcmp(string1, string2, ignorecase, length);
#if defined _ALS_strcmp
	#undef strcmp
#else
	#define _ALS_strcmp
#endif
#define strcmp strcmp_
//-----< strlen >---------------------------------------------------------------
stock strlen_(const string[])
{
	new len = strlen(string);
	if(len == 1 && !strcmp(string, " ", true)) return 0;
	return len;
}
stock _strlen(const string[])
	return strlen(string);
#if defined _ALS_strlen
	#undef strlen
#else
	#define _ALS_strlen
#endif
#define strlen strlen_
//-----<  >---------------------------------------------------------------------
//-----< GivePlayerWeapon >-----------------------------------------------------
stock GivePlayerWeapon_(playerid, weaponid, ammo)
{
	WeaponInfo[playerid][weaponid] += ammo;
	return GivePlayerWeapon(playerid, weaponid, ammo);
}
stock _GivePlayerWeapon(playerid, weaponid, ammo)
	return GivePlayerWeapon(playerid, weaponid, ammo);
#if defined _ALS_GivePlayerWeapon
	#undef GivePlayerWeapon
#else
	#define _ALS_GivePlayerWeapon
#endif
#define GivePlayerWeapon GivePlayerWeapon_
//-----< ResetPlayerWeapons >---------------------------------------------------
stock ResetPlayerWeapons_(playerid)
{
	for(new i = 0; i < MAX_WEAPONS; i++)
		WeaponInfo[playerid][i] = 0;
	return ResetPlayerWeapons(playerid);
}
stock _ResetPlayerWeapons(playerid)
	return ResetPlayerWeapons(playerid);
#if defined _ALS_ResetPlayerWeapons
	#undef ResetPlayerWeapons
#else
	#define _ALS_ResetPlayerWeapons
#endif
#define ResetPlayerWeapons ResetPlayerWeapons_
//-----< SetPlayerAmmo >--------------------------------------------------------
stock SetPlayerAmmo_(playerid, weaponslot, ammo)
{
	new gweapons, gammo;
	GetPlayerWeaponData(playerid, weaponslot, gweapons, gammo);
	if(gweapons)
		WeaponInfo[playerid][gweapons] = gammo;
	return SetPlayerAmmo(playerid, weaponslot, ammo);
}
stock _SetPlayerAmmo(playerid, weaponslot, ammo)
	return SetPlayerAmmo(playerid, weaponslot, ammo);
#if defined _ALS_SetPlayerAmmo
	#undef SetPlayerAmmo
#else
	#define _ALS_SetPlayerAmmo
#endif
#define SetPlayerAmmo SetPlayerAmmo_
//-----<  >---------------------------------------------------------------------
//-----< SetPlayerInterior >----------------------------------------------------
stock SetPlayerInterior_(playerid, interiorid)
{
	InteriorInfo[playerid] = interiorid;
	return SetPlayerInterior(playerid, interiorid);
}
stock _SetPlayerInterior(playerid, interiorid)
	return SetPlayerInterior(playerid, interiorid);
#if defined _ALS_SetPlayerInterior
	#undef SetPlayerInterior
#else
	#define _ALS_SetPlayerInterior
#endif
#define SetPlayerInterior SetPlayerInterior_
//-----<  >---------------------------------------------------------------------
//-----< SetPlayerHealth >------------------------------------------------------
stock SetPlayerHealth_(playerid, Float:health)
{
	HealthInfo[playerid] = health;
	return SetPlayerHealth(playerid, health);
}
stock _SetPlayerHealth(playerid, Float:health)
	return SetPlayerHealth(playerid, health);
#if defined _ALS_SetPlayerHealth
	#undef SetPlayerHealth
#else
	#define _ALS_SetPlayerHealth
#endif
#define SetPlayerHealth SetPlayerHealth_
//-----< SetPlayerArmour >------------------------------------------------------
stock SetPlayerArmour_(playerid, Float:armour)
{
	ArmourInfo[playerid] = armour;
	return SetPlayerArmour(playerid, armour);
}
stock _SetPlayerArmour(playerid, Float:armour)
	return SetPlayerArmour(playerid, armour);
#if defined _ALS_SetPlayerArmour
	#undef SetPlayerArmour
#else
	#define _ALS_SetPlayerArmour
#endif
#define SetPlayerArmour SetPlayerArmour_
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----< strcpy >---------------------------------------------------------------
stock strcpy(dest[], src[], deststart=0, destend=-1, srcstart=0, srcend=-1)
{
	new index[2];
	index[0] = deststart;
	index[1] = srcstart;
	while((dest[index[0]] = src[index[1]]))
	{
		index[0]++;
		index[1]++;
		if(destend != -1 && index[0] == destend + 1 || srcend != -1 && index[1] == srcend + 1) break;
	}
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
	if(strlen(input))
		strcpy(string, input);
	return string;
}
//-----< strtok >---------------------------------------------------------------
stock strtok(const string[], &index, seperator=' ')
{
	new length = strlen(string);
	new offset = index;
	new result[256];
	while((index < length) && (string[index] != seperator) && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	if((index < length) && (string[index] == seperator))
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
	for(stringnum = 0; stringnum <= stringindex && stringlength <= strlen(string); ++stringnum)
	{
		if(stringnum>0)
			stringlength++;
		stringstart = stringlength;
		while(stringlength <= strlen(string) && string[stringlength] != separator && string[stringlength] != EOS)
			stringlength++;
	}
	stringnum = 0;
	stringlength = stringlength-stringstart;
	while(stringnum <= stringlength && stringnum <= sizeof(result))
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
	for(stringnum = 0; stringnum <= stringindex && stringlength <= strlen(string); stringnum++)
	{
		if(stringnum > 0)
			stringlength++;
		stringstart = stringlength;
		while(stringlength <= strlen(string) && string[stringlength] != separator && string[stringlength] != EOS)
			stringlength++;
	}
	strmid(result, string, stringstart, strlen(string));
	return result;
}
//-----< ReturnUser >-----------------------------------------------------------
stock ReturnUser(text[])
{
	new pos = 0;
	while(text[pos] < 0x21)
	{
		if(text[pos] == 0)
			return INVALID_PLAYER_ID;
		pos++;
	}
	new userid = INVALID_PLAYER_ID;
	if(IsNumeric(text[pos]))
	{
		userid = strval(text[pos]);
		if(userid >= 0 && userid < GetMaxPlayers())
		{
			if(!IsPlayerConnected(userid))
				userid = INVALID_PLAYER_ID;
			else
				return userid;
		}
	}
	new len = strlen(text[pos]);
	new count = 0;
	new name[MAX_PLAYER_NAME];
	for(new i = 0, t = GetMaxPlayers(); i < t; i++)
		if(IsPlayerConnected(i))
		{
			GetPlayerName(i, name, sizeof(name));
			if(strcmp(name, text[pos] ,true, len) == 0)
			{
				if(len == strlen(name))
					return i;
				else {
					count++;
					userid = i;
				}
			}
		}
	if(count != 1)
		userid = INVALID_PLAYER_ID;
	return userid;
}
//-----< IsNumeric >------------------------------------------------------------
stock IsNumeric(const string[])
{
	for(new i = 0, t = strlen(string); i < t; i++)
		if(string[i] < '0' || string[i] > '9')
			return false;
	return true;
}
//-----< split >----------------------------------------------------------------
stock split(const strsrc[], strdest[][], delimiter = '|')
{
	new i, li, aNum, len, srclen = strlen(strsrc);
	while(i <= srclen)
	{
		if(strsrc[i] == delimiter || i == srclen)
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
	while(tickcount() - stamp < time) {}
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
//-----< escape >---------------------------------------------------------------
stock escape(str[])
{
	new escaped[256];
	mysql_real_escape_string(str, escaped);
	if(!strcmp(escaped, "NULL"))
		strcpy(escaped, " ");
	return escaped;
}
//-----< ResetPlayerDialogData >------------------------------------------------
stock ResetPlayerDialogData(playerid)
{
	for(new i = 0; i < sizeof(DialogData); i++)
		DialogData[playerid][i] = 0;
	return 1;
}
//-----< strtab >---------------------------------------------------------------
stock strtab(dest[], str[], maxlength)
{
	maxlength += 8;
	new len = strlen(dest) + maxlength;
	strcat(dest, str, len);
	for(new i = 8; i < maxlength; i += 8)
		if(strlen(str) <= i)
		{
			len += 8;
			strcat(dest, "\t", len);
		}
	len += 8;
	strcat(dest, "\t", len);
}
//-----< valstr_ >--------------------------------------------------------------
stock valstr_(value)
{
	new str[32];
	valstr(str, value);
	return str;
}
//-----< GivePlayerHealth >-----------------------------------------------------
stock GivePlayerHealth(playerid, Float:amount)
{
	new Float:armour, Float:health;
	GetPlayerArmour(playerid, armour);
	GetPlayerHealth(playerid, health);
	if(amount > 0)
	{
		if(health + amount > 100)
		{
			SetPlayerHealth(playerid, 100);
			SetPlayerArmour(playerid, armour + (100 - (health + amount)));
		}
		else SetPlayerHealth(playerid, health + amount);
	}
	else if(armour > 0)
	{
		if(armour + amount < 0)
		{
			SetPlayerArmour(playerid, 0);
			SetPlayerHealth(playerid, health + (armour + amount));
		}
		else SetPlayerArmour(playerid, armour + amount);
	}
	else
	{
		SetPlayerHealth(playerid, health + amount);
	}
	return 1;
}
//-----< GetDistanceBetweenPoints >---------------------------------------------
stock Float:GetDistanceBetweenPoints(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
{
	return floatadd(floatadd(floatsqroot(floatpower(floatsub(x1, x2), 2)), floatsqroot(floatpower(floatsub(y1, y2), 2))), floatsqroot(floatpower(floatsub(z1, z2), 2)));
}
//-----< GetWeaponObjectModelID >-----------------------------------------------
stock GetWeaponObjectModelID(weaponid)
{
	switch(weaponid)
	{
		case 1:			return 331;
		case 2..8:		return 331 + weaponid;
		case 9:			return 341;
		case 10..15:	return 311 + weaponid;
		case 16..18:	return 326 + weaponid;
		case 22..29:	return 324 + weaponid;
		case 30..31:	return 325 + weaponid;
		case 32:		return 372;
		case 33..45:	return 324 + weaponid;
		case 46:		return 371;
	}
	return 1575;
}
//-----< GetWeaponNameA >-------------------------------------------------------
stock GetWeaponNameA(weaponid)
{
	new wname[128];
	GetWeaponName(weaponid, wname, sizeof(wname));
	return wname;
}
//-----< udb_hash >-------------------------------------------------------------
stock udb_hash(buf[])
{
	new length = strlen(buf);
	new s1 = 1;
	new s2 = 0;
	new n;
	for(n = 0; n < length; n++)
	{
	   s1 = (s1 + buf[n])	% 65521;
	   s2 = (s2 + s1)		% 65521;
	}
	return (s2 << 16) + s1;
}
//-----< GetWeaponSlotID >------------------------------------------------------
stock GetWeaponSlotID(weaponid)
{
	switch(weaponid)
	{
		case 0..1:	  	return 0;
		case 2..9:	  	return 1;
		case 10..15:	return 10;
		case 16..18:	return 8;
		case 22..24:	return 2;
		case 25..27:	return 3;
		case 28..29:	return 4;
		case 30..31:	return 5;
		case 32:		return 4;
		case 33..34:	return 6;
		case 35..38:	return 6;
		case 39:		return 8;
		case 40:		return 12;
		case 41..43:	return 9;
		case 44..46:	return 11;
	}
	return 0;
}
//-----< GetWeaponHand >--------------------------------------------------------
stock GetWeaponHand(weaponid)
{
	switch(weaponid)
	{
		case 1..21:		return 'r';
		case 22:		return 'b';
		case 23..24:	return 'r';
		case 25..28:	return 'b';
		case 29:		return 'r';
		case 30..34:	return 'b';
		case 35..36:	return 'r';
		case 37..38:	return 'b';
		case 39..45:	return 'r';
	}
	return 'n';
}
//-----< ShowLastDialog >-------------------------------------------------------
stock ShowLastDialog(playerid)
{
	new id = DialogInfo[playerid][LastDialog[playerid]][dBeforeDialog];
	if(!strlen(DialogInfo[LastDialog[playerid]][dCaption])) return 0;
	
	_ShowPlayerDialog(playerid, id, DialogInfo[playerid][id][dStyle], DialogInfo[playerid][id][dCaption], DialogInfo[playerid][id][dInfo], DialogInfo[playerid][id][dButton1], DialogInfo[playerid][id][dButton2]);
	LastDialog[playerid] = id;
	return 1;
}
//-----< ReshowDialog >---------------------------------------------------------
stock ReshowDialog(playerid, id=-1)
{
	if(id == -1) id = LastDialog[playerid];
	if(!strlen(DialogInfo[id][dCaption])) return 0;
	_ShowPlayerDialog(playerid, id, DialogInfo[playerid][id][dStyle], DialogInfo[playerid][id][dCaption], DialogInfo[playerid][id][dInfo], DialogInfo[playerid][id][dButton1], DialogInfo[playerid][id][dButton2]);
	return 1;
}
//-----< TimeConvert >----------------------------------------------------------
stock TimeConvert(returntype, second)
{
	switch(returntype)
	{
		case 'd': return floatround(second/(60*60*24), floatround_floor);
		case 'h': return floatround(second/(60*60), floatround_floor);
		case 'm': return floatround(second/60, floatround_floor);
	}
	return second;
}
//-----< TimeMeasure >----------------------------------------------------------
stock TimeMeasure(returntype, second)
{
	new division = 1,
		measureval,
		returnvalue;
	switch(returntype)
	{
		case 'd':
		{
			division = 60*60*24;
		}
		case 'h':
		{
			division = 60*60;
			measureval = 24;
		}
		case 'm':
		{
			division = 60;
			measureval = 60;
		}
	}
	returnvalue = floatround(second/division, floatround_floor);
	while(division > measureval && measureval)
	{
		returnvalue -= measureval;
	}
	return returnvalue;
}
//-----< GetDateCode >----------------------------------------------------------
stock GetDateCode()
{
	new year, month, day,
		code[8];
	getdate(year, month, day);
	format(code, sizeof(code), "%04d%02d%02d", year, month, day);
	return strval(code);
}
//-----< GetTimeCode >----------------------------------------------------------
stock GetTimeCode()
{
	new hour, minute, second,
		code[6];
	gettime(hour, minute, second);
	format(code, sizeof(code), "%02d%02d%02d", hour, minute, second);
	return strval(code);
}
//-----<  >---------------------------------------------------------------------
