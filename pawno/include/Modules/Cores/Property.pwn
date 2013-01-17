/*
 *
 *
 *		PureunBa(서성범)
 *
 *			Property Core
 *
 *
 *		Coded by PureunBa 2011-2013 @ all right reserved.
 *
 *			< pureunba.tistory.com >
 *
 *
 *		Release:	2013/01/14
 *		Update:		2013/01/15
 *
 *
 */
/*

  < Callbacks >
	gInitHandler_Property()
	pConnectHandler_Property(playerid)
	pKeyStateChangeHandler_Property(playerid, newkeys, oldkeys)
	pCommandTextHandler_Property(playerid, cmdtext[])
	dResponseHandler_Property(playerid, dialogid, response, listitem, inputtext[])

  < Functions >
	CreatePropertyDataTable()
	SavePropertyDataById(propid)
	SavePropertyData()
	LoadPropertyData()
	UnloadPropertyDataById(propid)
	UnloadPropertyData()
	RemoveProperty(propid)
	ShowPropertyList(playerid, dialogid)
	GetPropertyDBID(propid)
	IsValidPropertyID(propid)
	GetMaxProperties()

*/



//-----< Variables
enum ePropertyInfo
{
	pID,
	pPropname[32],
	pOwnername[MAX_PLAYER_NAME],
	Float:pPosEn[4],
	Float:pPosEx[4],
	pInteriorEn,
	pInteriorEx,
	pVirtualWorldEn,
	pVirtualWorldEx,
	pShowPickupEn,
	pShowPickupEx,
	pLocked,
	pMemo[256],
	
	pPickupEn,
	pPickupEx
}
new PropertyInfo[128][ePropertyInfo],
	PropertyModifyDest[MAX_PLAYERS],
	PropertyModify[MAX_PLAYERS][ePropertyInfo];



//-----< Defines
#define DialogId_Property(%0)       (75+%0)



//-----< Callbacks
forward gInitHandler_Property();
forward pConnectHandler_Property(playerid);
forward pKeyStateChangeHandler_Property(playerid, newkeys, oldkeys);
forward pCommandTextHandler_Property(playerid, cmdtext[]);
forward dResponseHandler_Property(playerid, dialogid, response, listitem, inputtext[]);
//-----< gInitHandler >---------------------------------------------------------
public gInitHandler_Property()
{
	CreatePropertyDataTable();
	LoadPropertyData();
	return 1;
}
//-----< pConnectHandler >------------------------------------------------------
public pConnectHandler_Property(playerid)
{
	PropertyModifyDest[playerid] = -1;
	return 1;
}
//-----< pKeyStateChangeHandler >-----------------------------------------------
public pKeyStateChangeHandler_Property(playerid, newkeys, oldkeys)
{
	if (newkeys == KEY_SECONDARY_ATTACK)
		for (new i = 0, t = GetMaxProperties(); i < t; i++)
		    if (IsValidPropertyID(i))
		        if (IsPlayerInRangeOfPoint(playerid, 1.0, PropertyInfo[i][pPosEn][0], PropertyInfo[i][pPosEn][1], PropertyInfo[i][pPosEn][2])
		        && GetPlayerVirtualWorld(playerid) == PropertyInfo[i][pVirtualWorldEn])
		        {
		            if (PropertyInfo[i][pLocked] && !GetPVarInt_(playerid, "AdminDuty"))
		                return SendClientMessage(playerid, COLOR_WHITE, "이 문은 잠겨 있습니다.");
		            SetPlayerPos(playerid, PropertyInfo[i][pPosEx][0], PropertyInfo[i][pPosEx][1], PropertyInfo[i][pPosEx][2]);
		            SetPlayerFacingAngle(playerid, PropertyInfo[i][pPosEx][3]);
		            SetPlayerInterior(playerid, PropertyInfo[i][pInteriorEx]);
		            SetPlayerVirtualWorld(playerid, PropertyInfo[i][pVirtualWorldEx]);
				}
				else if (IsPlayerInRangeOfPoint(playerid, 1.0, PropertyInfo[i][pPosEx][0], PropertyInfo[i][pPosEx][1], PropertyInfo[i][pPosEx][2])
				&& GetPlayerVirtualWorld(playerid) == PropertyInfo[i][pVirtualWorldEx])
				{
				    if (PropertyInfo[i][pLocked] && !GetPVarInt_(playerid, "AdminDuty"))
		                return SendClientMessage(playerid, COLOR_WHITE, "이 문은 잠겨 있습니다.");
		            SetPlayerPos(playerid, PropertyInfo[i][pPosEn][0], PropertyInfo[i][pPosEn][1], PropertyInfo[i][pPosEn][2]);
		            SetPlayerFacingAngle(playerid, PropertyInfo[i][pPosEn][3]);
		            SetPlayerInterior(playerid, PropertyInfo[i][pInteriorEn]);
		            SetPlayerVirtualWorld(playerid, PropertyInfo[i][pVirtualWorldEn]);
				}
	return 1;
}
//-----< pCommandTextHandler >--------------------------------------------------
public pCommandTextHandler_Property(playerid, cmdtext[])
{
	new cmd[256],
		idx,
		destid;
	cmd = strtok(cmdtext, idx);
	
	if (!strcmp(cmd, "/건물도움말", true))
	{
		ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "건물 도움말", "/건물설정", "닫기", "");
	    return 1;
	}
	else if (!strcmp(cmd, "/건물설정", true) && !GetPVarInt_(playerid, "pAdmin"))
	{
	    for (new i = 0, t = GetMaxProperties(); i < t; i++)
		    if (IsValidPropertyID(i) && !strcmp(PropertyInfo[i][pOwnername], GetPlayerNameA(playerid), true) && strlen(PropertyInfo[i][pOwnername]))
		        if (IsPlayerInRangeOfPoint(playerid, 1.0, PropertyInfo[i][pPosEn][0], PropertyInfo[i][pPosEn][1], PropertyInfo[i][pPosEn][2])
		        && GetPlayerVirtualWorld(playerid) == PropertyInfo[i][pVirtualWorldEn]
				|| IsPlayerInRangeOfPoint(playerid, 1.0, PropertyInfo[i][pPosEx][0], PropertyInfo[i][pPosEx][1], PropertyInfo[i][pPosEx][2])
				&& GetPlayerVirtualWorld(playerid) == PropertyInfo[i][pVirtualWorldEx])
		        {
		            destid = i;
		            break;
				}
		if (!IsValidPropertyID(destid))
		    return SendClientMessage(playerid, COLOR_WHITE, "소유한 건물의 문 앞에서 사용하세요.");
		ShowPropertyModifier(playerid, destid);
		return 1;
	}
	
	return 0;
}
//-----< dResponseHandler >-----------------------------------------------------
public dResponseHandler_Property(playerid, dialogid, response, listitem, inputtext[])
{
	new str[512],
		propid = PropertyModifyDest[playerid];
	if (propid < 0) return 1;
	switch (dialogid - DialogId_Property(0))
	{
		case 0:
			if (response)
			    if (!GetPVarInt_(playerid, "pAdmin") && (listitem >= 1 && listitem <= 4 || listitem >= 8 && listitem <= 10))
			    {
			        SendClientMessage(playerid, COLOR_WHITE, "관리자만 설정할 수 있는 항목입니다.");
			        ShowPropertyModifier(playerid, propid);
				}
				else
				    switch (listitem)
				    {
				        case 0:
				        {
				            format(str, sizeof(str), "건물 이름을 입력하세요. (현재: %s)", PropertyModify[playerid][pPropname]);
				            ShowPlayerDialog(playerid, DialogId_Property(1), DIALOG_STYLE_INPUT, "건물 설정", str, "확인", "취소");
						}
						case 1:
						{
						    format(str, sizeof(str), "주인 이름을 입력하세요. (현재: %s)", PropertyModify[playerid][pOwnername]);
						    ShowPlayerDialog(playerid, DialogId_Property(2), DIALOG_STYLE_INPUT, "건물 설정", str, "확인", "취소");
						}
						case 2:
						{
						    GetPlayerPos(playerid, PropertyModify[playerid][pPosEn][0], PropertyModify[playerid][pPosEn][1], PropertyModify[playerid][pPosEn][2]);
						    GetPlayerFacingAngle(playerid, PropertyModify[playerid][pPosEn][3]);
						    PropertyModify[playerid][pInteriorEn] = GetPlayerInterior(playerid);
						    PropertyModify[playerid][pVirtualWorldEn] = GetPlayerVirtualWorld(playerid);
						    ShowPropertyModifier(playerid, propid);
						}
						case 3:
						{
							PropertyModify[playerid][pShowPickupEn] = (PropertyModify[playerid][pShowPickupEn])?false:true;
							ShowPropertyModifier(playerid, propid);
						}
						case 4:
						{
						    GetPlayerPos(playerid, PropertyModify[playerid][pPosEx][0], PropertyModify[playerid][pPosEx][1], PropertyModify[playerid][pPosEx][2]);
						    GetPlayerFacingAngle(playerid, PropertyModify[playerid][pPosEx][3]);
						    PropertyModify[playerid][pInteriorEx] = GetPlayerInterior(playerid);
						    PropertyModify[playerid][pVirtualWorldEx] = GetPlayerVirtualWorld(playerid);
						    ShowPropertyModifier(playerid, propid);
						}
						case 5:
						{
							PropertyModify[playerid][pShowPickupEx] = (PropertyModify[playerid][pShowPickupEx])?false:true;
	                        ShowPropertyModifier(playerid, propid);
						}
						case 6:
						{
							PropertyModify[playerid][pLocked] = (PropertyModify[playerid][pLocked])?false:true;
							ShowPropertyModifier(playerid, propid);
						}
						case 7:
						{
						    format(str, sizeof(str), "메모할 내용을 입력하세요. (현재: %s)", PropertyModify[playerid][pMemo]);
						    ShowPlayerDialog(playerid, DialogId_Property(3), DIALOG_STYLE_INPUT, "건물 설정", str, "확인", "취소");
						}
						case 8:
						{
						    SetPlayerPos(playerid, PropertyModify[playerid][pPosEn][0], PropertyModify[playerid][pPosEn][1], PropertyModify[playerid][pPosEn][2]);
						    SetPlayerFacingAngle(playerid, PropertyModify[playerid][pPosEn][3]);
						    SetPlayerInterior(playerid, PropertyModify[playerid][pInteriorEn]);
						    SetPlayerVirtualWorld(playerid, PropertyModify[playerid][pVirtualWorldEn]);
						}
						case 9:
						{
						    SetPlayerPos(playerid, PropertyModify[playerid][pPosEx][0], PropertyModify[playerid][pPosEx][1], PropertyModify[playerid][pPosEx][2]);
						    SetPlayerFacingAngle(playerid, PropertyModify[playerid][pPosEx][3]);
						    SetPlayerInterior(playerid, PropertyModify[playerid][pInteriorEx]);
						    SetPlayerVirtualWorld(playerid, PropertyModify[playerid][pVirtualWorldEx]);
						}
						case 10:
						{
							RemoveProperty(propid);
							PropertyModifyDest[playerid] = -1;
							format(str, sizeof(str), "%s님에 의해 %d번 건물이 제거되었습니다.", GetPlayerNameA(playerid), propid);
							SendAdminMessage(COLOR_YELLOW, str);
						}
						case 11:
						{
							strcpy(PropertyInfo[propid][pPropname], PropertyModify[playerid][pPropname]);
							strcpy(PropertyInfo[propid][pOwnername], PropertyModify[playerid][pOwnername]);
							for (new i = 0; i < 4; i++)
							{
							    PropertyInfo[propid][pPosEn][i] = PropertyModify[playerid][pPosEn][i];
							    PropertyInfo[propid][pPosEx][i] = PropertyModify[playerid][pPosEx][i];
							}
							PropertyInfo[propid][pInteriorEn] = PropertyModify[playerid][pInteriorEn];
							PropertyInfo[propid][pInteriorEx] = PropertyModify[playerid][pInteriorEx];
							PropertyInfo[propid][pVirtualWorldEn] = PropertyModify[playerid][pVirtualWorldEn];
							PropertyInfo[propid][pVirtualWorldEx] = PropertyModify[playerid][pVirtualWorldEx];
							PropertyInfo[propid][pShowPickupEn] = PropertyModify[playerid][pShowPickupEn];
							PropertyInfo[propid][pShowPickupEx] = PropertyModify[playerid][pShowPickupEx];
							PropertyInfo[propid][pLocked] = PropertyModify[playerid][pLocked];
							strcpy(PropertyInfo[propid][pMemo], PropertyModify[playerid][pMemo]);
							SavePropertyDataById(propid);
							LoadPropertyData();
							PropertyModifyDest[playerid] = -1;
						}
						case 12:
						{
						    PropertyModifyDest[playerid] = -1;
						}
					}
		case 1:
		{
		    if (response)
		        strcpy(PropertyModify[playerid][pPropname], inputtext);
			ShowPropertyModifier(playerid, propid);
		}
		case 2:
		{
		    if (response)
		        strcpy(PropertyModify[playerid][pOwnername], inputtext);
			ShowPropertyModifier(playerid, propid);
		}
		case 3:
		{
		    if (response)
		        strcpy(PropertyModify[playerid][pMemo], inputtext);
			ShowPropertyModifier(playerid, propid);
		}
	}
	return 1;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----< CreatePropertyDataTable >----------------------------------------------
stock CreatePropertyDataTable()
{
	new str[3840];
	strcpy(str, "CREATE TABLE IF NOT EXISTS propertydata (");
	strcat(str, "ID int(5) NOT NULL auto_increment PRIMARY KEY,");
	strcat(str, "Propname varchar(32) NOT NULL default '',");
	strcat(str, "Ownername varchar(32) NOT NULL default '',");
	strcat(str, "PosEn varchar(64) NOT NULL default '',");
	strcat(str, "PosEx varchar(64) NOT NULL default '',");
	strcat(str, "ShowPickupEn int(1) NOT NULL default '1',");
	strcat(str, "ShowPickupEx int(1) NOT NULL default '1',");
	strcat(str, "Locked int(1) NOT NULL default '0',");
	strcat(str, "Memo varchar(256) NOT NULL default '') ");
	strcat(str, "ENGINE = InnoDB CHARACTER SET euckr COLLATE euckr_korean_ci");
	mysql_query(str);
	return 1;
}
//-----< SavePropertyDataById >-------------------------------------------------
stock SavePropertyDataById(propid)
{
	new str[3840];
	format(str, sizeof(str), "UPDATE propertydata SET");
	format(str, sizeof(str), "%s Propname='%s'", str, escape(PropertyInfo[propid][pPropname]));
	format(str, sizeof(str), "%s,Ownername='%s'", str, escape(PropertyInfo[propid][pOwnername]));
	format(str, sizeof(str), "%s,PosEn='%.4f,%.4f,%.4f,%.4f,%d,%d'", str,
	    PropertyInfo[propid][pPosEn][0], PropertyInfo[propid][pPosEn][1], PropertyInfo[propid][pPosEn][2], PropertyInfo[propid][pPosEn][3],
	    PropertyInfo[propid][pInteriorEn], PropertyInfo[propid][pVirtualWorldEn]);
	format(str, sizeof(str), "%s,PosEx='%.4f,%.4f,%.4f,%.4f,%d,%d'", str,
	    PropertyInfo[propid][pPosEx][0], PropertyInfo[propid][pPosEx][1], PropertyInfo[propid][pPosEx][2], PropertyInfo[propid][pPosEx][3],
	    PropertyInfo[propid][pInteriorEx], PropertyInfo[propid][pVirtualWorldEx]);
	format(str, sizeof(str), "%s,ShowPickupEn=%d", str, PropertyInfo[propid][pShowPickupEn]);
	format(str, sizeof(str), "%s,ShowPickupEx=%d", str, PropertyInfo[propid][pShowPickupEx]);
	format(str, sizeof(str), "%s,Locked=%d", str, PropertyInfo[propid][pLocked]);
	format(str, sizeof(str), "%s,Memo='%s'", str, escape(PropertyInfo[propid][pMemo]));
	format(str, sizeof(str), "%s WHERE ID=%d", str, PropertyInfo[propid][pID]);
	mysql_query(str);
	return 1;
}
//-----< SavePropertyData >-----------------------------------------------------
stock SavePropertyData()
{
	for (new i = 0, t = GetMaxProperties; i < t; i++)
	    if (IsValidPropertyID(i))
	        SavePropertyDataById(i);
	return 1;
}
//-----< LoadPropertyData >-----------------------------------------------------
stock LoadPropertyData()
{
	new str[512],
	    receive[9][256],
		idx,
		splited[6][16];
	UnloadPropertyData();
	mysql_query("SELECT * FROM propertydata");
	mysql_store_result();
	for (new i = 0, t = mysql_num_rows(); i < t; i++)
	{
		mysql_fetch_row(str, "|");
		split(str, receive, '|');
		idx = 0;
		
		PropertyInfo[i][pID] = strval(receive[idx++]);
		strcpy(PropertyInfo[i][pPropname], receive[idx++]);
		strcpy(PropertyInfo[i][pOwnername], receive[idx++]);
		
		split(receive[idx++], splited, ',');
		for (new j = 0; j < 4; j++)
		    PropertyInfo[i][pPosEn][j] = floatstr(splited[j]);
		PropertyInfo[i][pInteriorEn] = strval(splited[4]);
		PropertyInfo[i][pVirtualWorldEn] = strval(splited[5]);
		
		split(receive[idx++], splited, ',');
		for (new j = 0; j < 4; j++)
		    PropertyInfo[i][pPosEx][j] = floatstr(splited[j]);
		PropertyInfo[i][pInteriorEx] = strval(splited[4]);
		PropertyInfo[i][pVirtualWorldEx] = strval(splited[5]);
		
		PropertyInfo[i][pShowPickupEn] = strval(receive[idx++]);
		PropertyInfo[i][pShowPickupEx] = strval(receive[idx++]);
		PropertyInfo[i][pLocked] = strval(receive[idx++]);
		strcpy(PropertyInfo[i][pMemo], receive[idx++]);
		
		if (PropertyInfo[i][pShowPickupEn])
		    PropertyInfo[i][pPickupEn] = CreateDynamicPickup(1239, 1, PropertyInfo[i][pPosEn][0], PropertyInfo[i][pPosEn][1], PropertyInfo[i][pPosEn][2], -1, PropertyInfo[i][pVirtualWorldEn]);
		if (PropertyInfo[i][pShowPickupEx])
		    PropertyInfo[i][pPickupEx] = CreateDynamicPickup(1239, 1, PropertyInfo[i][pPosEx][0], PropertyInfo[i][pPosEx][1], PropertyInfo[i][pPosEx][2], -1, PropertyInfo[i][pVirtualWorldEx]);
	}
	return 1;
}
//-----< UnloadPropertyDataById >-----------------------------------------------
stock UnloadPropertyDataById(propid)
{
    PropertyInfo[propid][pID] = 0;
	DestroyDynamicPickup(PropertyInfo[propid][pPickupEn]);
	DestroyDynamicPickup(PropertyInfo[propid][pPickupEx]);
	return 1;
}
//-----< UnloadPropertyData >---------------------------------------------------
stock UnloadPropertyData()
{
	for (new i = 0, t = GetMaxProperties(); i < t; i++)
	    if (IsValidPropertyID(i))
			UnloadPropertyDataById(i);
	return 1;
}
//-----< CreateProperty >-------------------------------------------------------
stock CreateProperty()
{
	mysql_query("INSERT INTO propertydata (Propname,Ownername,PosEn,PosEx,Memo) VALUES ('(생성중...)',' ','0.0,0.0,0.0,0.0,0,-1','0.0,0.0,0.0,0.0,0,-1',' ')");
	LoadPropertyData();
	return 1;
}
//-----< RemoveProperty >-------------------------------------------------------
stock RemoveProperty(propid)
{
	new str[128];
	format(str, sizeof(str), "DELETE FROM propertydata WHERE ID=%d", PropertyInfo[propid][pID]);
	mysql_query(str);
	UnloadPropertyDataById(propid);
	return 1;
}
//-----< ShowPropertyList >-----------------------------------------------------
stock ShowPropertyList(playerid, dialogid)
{
	new str[5120],
	    tmp[128], idx;
	ResetPlayerDialogData(playerid);
	for (new i = 0, t = GetMaxProperties(); i < t; i++)
	    if (IsValidPropertyID(i))
	    {
	        format(tmp, sizeof(tmp), "[%04d] %s\n", PropertyInfo[i][pID], PropertyInfo[i][pPropname]);
	        strcat(str, tmp);
	        SetPVarInt_(playerid, "DialogData", i, idx++);
		}
	if (!idx)
		SendClientMessage(playerid, COLOR_WHITE, "생성된 건물이 없습니다.");
	else
		ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, "건물 목록", str, "선택", "닫기");
	return 1;
}
//-----< ShowPropertyModifier >-------------------------------------------------
stock ShowPropertyModifier(playerid, propid)
{
	new str[2560];

	if (PropertyModifyDest[playerid] != propid)
	{
	    PropertyModifyDest[playerid] = propid;
		strcpy(PropertyModify[playerid][pPropname], PropertyInfo[propid][pPropname]);
		strcpy(PropertyModify[playerid][pOwnername], PropertyInfo[propid][pOwnername]);
		for (new i = 0; i < 4; i++)
		{
		    PropertyModify[playerid][pPosEn][i] = PropertyInfo[propid][pPosEn][i];
		    PropertyModify[playerid][pPosEx][i] = PropertyInfo[propid][pPosEx][i];
		}
		PropertyModify[playerid][pInteriorEn] = PropertyInfo[propid][pInteriorEn];
		PropertyModify[playerid][pInteriorEx] = PropertyInfo[propid][pInteriorEx];
		PropertyModify[playerid][pVirtualWorldEn] = PropertyInfo[propid][pVirtualWorldEn];
		PropertyModify[playerid][pVirtualWorldEx] = PropertyInfo[propid][pVirtualWorldEx];
		PropertyModify[playerid][pShowPickupEn] = PropertyInfo[propid][pShowPickupEn];
		PropertyModify[playerid][pShowPickupEx] = PropertyInfo[propid][pShowPickupEx];
		PropertyModify[playerid][pLocked] = PropertyInfo[propid][pLocked];
		strcpy(PropertyModify[playerid][pMemo], PropertyInfo[propid][pMemo]);
	}
	
	format(str, sizeof(str), "건물 이름:\t\t%s", PropertyModify[playerid][pPropname]);
	if (!GetPVarInt_(playerid, "pAdmin")) strcat(str, C_GREY);
	format(str, sizeof(str), "%s\n주인 이름:\t\t%s", str, PropertyModify[playerid][pOwnername]);
	format(str, sizeof(str), "%s\n입구 좌표:\t\t%.4f,%.4f,%.4f / %.4f / %d / %d", str,
		PropertyModify[playerid][pPosEn][0], PropertyModify[playerid][pPosEn][1], PropertyModify[playerid][pPosEn][2],
		PropertyModify[playerid][pPosEn][3], PropertyModify[playerid][pInteriorEn], PropertyModify[playerid][pVirtualWorldEn]);
    format(str, sizeof(str), "%s\n입구 픽업:\t\t", str);
    if (PropertyModify[playerid][pShowPickupEn]) strcat(str, "보임");
    else strcat(str, "숨김");
	format(str, sizeof(str), "%s\n출구 좌표:\t\t%.4f,%.4f,%.4f / %.4f / %d / %d", str,
		PropertyModify[playerid][pPosEx][0], PropertyModify[playerid][pPosEx][1], PropertyModify[playerid][pPosEx][2],
		PropertyModify[playerid][pPosEx][3], PropertyModify[playerid][pInteriorEx], PropertyModify[playerid][pVirtualWorldEx]);
	format(str, sizeof(str), "%s\n출구 픽업:\t\t", str);
	if (PropertyModify[playerid][pShowPickupEx]) strcat(str, "보임");
    else strcat(str, "숨김");
    if (!GetPVarInt_(playerid, "pAdmin")) strcat(str, C_WHITE);
	format(str, sizeof(str), "%s\n잠금:\t\t\t", str);
	if (PropertyModify[playerid][pLocked]) strcat(str, "잠금");
	else strcat(str, "열림");
	format(str, sizeof(str), "%s\n메모:\t\t\t%s", str, PropertyModify[playerid][pMemo]);
	if (!GetPVarInt_(playerid, "pAdmin")) strcat(str, C_GREY);
	strcat(str, "\n> 입구로 이동하기");
	strcat(str, "\n> 출구로 이동하기");
	strcat(str, "\n> 건물 제거하기");
	if (!GetPVarInt_(playerid, "pAdmin")) strcat(str, C_WHITE);
	strcat(str, "\n> 저장하기");
	strcat(str, "\n> 취소하기");
	
	ShowPlayerDialog(playerid, DialogId_Property(0), DIALOG_STYLE_LIST, "건물 설정", str, "확인", "닫기");
	return 1;
}
//-----< GetPropertyDBID >------------------------------------------------------
stock GetPropertyDBID(propid)
	return PropertyInfo[propid][pID];
//-----< IsValidPropertyID >----------------------------------------------------
stock IsValidPropertyID(propid)
	return (PropertyInfo[propid][pID])?true:false;
//-----< GetMaxProperties >-----------------------------------------------------
stock GetMaxProperties()
	return sizeof(PropertyInfo);
//-----<  >---------------------------------------------------------------------
