/*
 *
 *
 *		PureunBa(서성범)
 *
 *			Item Core
 *
 *
 *		Coded by PureunBa 2011-2013 @ all right reserved.
 *
 *			< pureunba.tistory.com >
 *
 *
 *		Release:	2013/01/18
 *		Update:		2013/01/29
 *
 *
 */
/*

  < Callbacks >
	gInitHandler_Item()
	pSpawnHandler_Item(playerid)
	pKeyStateChangeHandler_Item(playerid, newkeys, oldkeys)
	pCommandHandler_Item(playerid, cmdtext[])
	dResponseHandler_Item(playerid, dialogid, response, listitem, inputtext[])

  < Functions >
	CreateItemDataTable()
	SaveItemDataById(itemid)
	SaveItemData()
	LoadItemData()
	UnloadItemDataById(itemid)
	UnloadItemData()
	CreateItem(itemmodel, Float:x, Float:y, Float:z, Float:a, interiorid, worldid, memo[])
	DestroyItem(itemid)
	
	CreatePlayerItemDataTable()
	SavePlayerItemDataById(playerid, itemid)
	SavePlayerItemData(playerid)
	LoadPlayerItemData(playerid)
	UnloadPlayerItemDataById(playerid, itemid)
	UnloadPlayerItemData(playerid)
	CreatePlayerItem(playerid, itemmodel)
	
	GivePlayerItem(playerid, itemid, savetype[]="가방")
	GetPlayerItemsWeight(playerid, savetype[]="All")
	ShowPlayerItemList(playerid, dialogid, savetyoe[]="가방")
	ShowPlayerItemInfo(playerid, itemid)
	ShowItemModelList(playerid, dialogid)
	GetPlayerNearestItem(playerid, Float:distance=1.0)
	IsValidItemID(itemid)
	GetMaxItems()
	IsValidPlayerItemID(playerid, itemid)
	GetMaxPlayerItems()

*/



//-----< Pre-Defines
#define MAX_ITEMS       500
#define MAX_PLAYERITEMS 10



//-----< Variables
enum eItemInfo
{
	iID,
	iItemmodel,
	iOwnername[MAX_PLAYER_NAME],
	Float:iPos[4],
	iInterior,
	iVirtualWorld,
	iSaveType[32],
	iMemo[128],
	
	iObject,
	Text3D:i3DText
}
new ItemInfo[MAX_ITEMS][eItemInfo],
	PlayerItemInfo[MAX_PLAYERS][MAX_PLAYERITEMS][eItemInfo];
enum eItemModelInfo
{
	imName[32],
	imModel,
	Float:imZVar,
	imWeight,
	imInfo[256]
}
new ItemModelInfo[][eItemModelInfo] =
{
	{ "TV", 		1429,	-0.75,	60,		"TV봐서 뭐하겠노... 그냥 부숴 버릴까?" },
	{ "나무판자",	1448,   -0.9,	3,		"무언가를 만들거나 수리할 때 쓰면 좋을 것 같다." }
};


//-----< Defines
#define DialogId_Item(%0)   (100+%0)



//-----< Callbacks
forward gInitHandler_Item();
forward pSpawnHandler_Item(playerid);
forward pKeyStateChangeHandler_Item(playerid, newkeys, oldkeys);
forward pCommandTextHandler_Item(playerid, cmdtext[]);
forward dResponseHandler_Item(playerid, dialogid, response, listitem, inputtext[]);
//-----< gInitHandler >---------------------------------------------------------
public gInitHandler_Item()
{
	CreateItemDataTable();
	LoadItemData();
	CreatePlayerItemDataTable();
	return 1;
}
//-----< pSpawnHandler >--------------------------------------------------------
public pSpawnHandler_Item(playerid)
{
	LoadPlayerItemData(playerid);
	return 1;
}
//-----< pKeyStateChangeHandler >-----------------------------------------------
public pKeyStateChangeHandler_Item(playerid, newkeys, oldkeys)
{
	new str[256];
    if (newkeys == KEY_SECONDARY_ATTACK)
    {
		new itemid = GetPlayerNearestItem(playerid);
		if (GetPlayerItemsWeight(playerid, "가방") + ItemModelInfo[ItemInfo[itemid][iItemmodel]][imWeight] > GetPVarInt_(playerid, "pWeight"))
		{
			if (GetPlayerItemsWeight(playerid, "가방") > ItemModelInfo[ItemInfo[itemid][iItemmodel]][imWeight])
				SendClientMessage(playerid, COLOR_WHITE, "가방이 너무 무겁습니다.");
			else
			{
			    format(str, sizeof(str), "%s은(는) 너무 무거워서 가방에 넣을 수 없습니다.");
				SendClientMessage(playerid, COLOR_WHITE, str);
			}
		}
		else
			GivePlayerItem(playerid, itemid);
	}
	return 1;
}
//-----< pCommandTextHandler >--------------------------------------------------
public pCommandTextHandler_Item(playerid, cmdtext[])
{
	new cmd[256], idx;
	cmd = strtok(cmdtext, idx);
	
	if (!strcmp(cmd, "/가방", true))
	{
	    ShowPlayerItemList(playerid, DialogId_Item(0));
	    return 1;
	}
	return 0;
}
//-----< dResponseHandler >-----------------------------------------------------
public dResponseHandler_Item(playerid, dialogid, response, listitem, inputtext[])
{
	new str[256];
	switch (dialogid - DialogId_Item(0))
	{
	    case 0:
	        if (response)
	        {
	            if (!listitem) return 1;
	            new itemid = DialogData[playerid][listitem];
	            DialogData[playerid][0] = DialogData[playerid][listitem];
	            ShowPlayerDialog(playerid, DialogId_Item(1), DIALOG_STYLE_LIST, ItemModelInfo[PlayerItemInfo[playerid][itemid][iItemmodel]][imName],
					"꺼낸다.\n확인한다.\n버린다.", "선택", "취소");
	        }
		case 1:
		    if (response)
		    {
		        new itemid = DialogData[playerid][0];
		        switch (listitem)
		        {
		            case 0:
		            {
		                ShowPlayerDialog(playerid, DialogId_Item(2), DIALOG_STYLE_LIST, ItemModelInfo[PlayerItemInfo[playerid][itemid][iItemmodel]][imName],
		                    "왼손으로 꺼낸다.\n오른손으로 꺼낸다.\n양손으로 꺼낸다.", "선택", "취소");
		            }
		            case 1:
		            {
		                ShowPlayerItemInfo(playerid, itemid);
		            }
		            case 2:
		            {
						new Float:x, Float:y, Float:z;
						GetPlayerVelocity(playerid, x, y, z);
		                if (IsValidItemID(GetPlayerNearestItem(playerid)))
		                    SendClientMessage(playerid, COLOR_WHITE, "다른 아이템 근처에선 버릴 수 없습니다.");
						else if (z != 0.0)
						    SendClientMessage(playerid, COLOR_WHITE, "캐릭터를 멈춘 후 다시 시도하세요.");
						else DropPlayerItem(playerid, itemid);
		            }
				}
		    }
		case 2:
		    if (response)
		    {
				new both[32], left[32], right[32], htext[32],
					itemid = DialogData[playerid][0];
                for (new i = 0, t = GetMaxPlayerItems(); i < t; i++)
		            if (IsValidPlayerItemID(playerid, i) && !strcmp(PlayerItemInfo[playerid][i][iSaveType], "양손", true))
		            {
		                strcpy(both, ItemModelInfo[PlayerItemInfo[playerid][i][iItemmodel]][imName]);
		                break;
					}
				for (new i = 0, t = GetMaxPlayerItems(); i < t; i++)
		            if (IsValidPlayerItemID(playerid, i) && !strcmp(PlayerItemInfo[playerid][i][iSaveType], "왼손", true))
		            {
		                strcpy(left, ItemModelInfo[PlayerItemInfo[playerid][i][iItemmodel]][imName]);
		                break;
					}
                for (new i = 0, t = GetMaxPlayerItems(); i < t; i++)
		            if (IsValidPlayerItemID(playerid, i) && !strcmp(PlayerItemInfo[playerid][i][iSaveType], "오른손", true))
		            {
		                strcpy(right, ItemModelInfo[PlayerItemInfo[playerid][i][iItemmodel]][imName]);
		                break;
					}
				if (strlen(both))
				{
				    format(str, sizeof(str), "양손에 "C_GREEN"%s"C_WHITE"이(가) 있습니다.", both);
				    SendClientMessage(playerid, COLOR_WHITE, str);
				    return 1;
				}
				else if (strlen(left) && (listitem == 0 || listitem == 2))
		        {
		            format(str, sizeof(str), "왼손에 "C_GREEN"%s"C_WHITE"이(가) 있습니다.", left);
		            SendClientMessage(playerid, COLOR_WHITE, str);
		            return 1;
				}
				else if (strlen(right) && (listitem == 1 || listitem == 2))
		        {
		            format(str, sizeof(str), "오른손에 "C_GREEN"%s"C_WHITE"이(가) 있습니다.", right);
		            SendClientMessage(playerid, COLOR_WHITE, str);
		            return 1;
				}
				switch (listitem)
				{
				    case 0: strcpy(htext, "왼손");
				    case 1: strcpy(htext, "오른손");
				    case 2: strcpy(htext, "양손");
				}
				strcpy(PlayerItemInfo[playerid][itemid][iSaveType], htext);
				format(str, sizeof(str), ""C_GREEN"%s"C_WHITE"을(를) %s으로 꺼냈습니다.", ItemModelInfo[PlayerItemInfo[playerid][itemid][iItemmodel]][imName], htext);
				SendClientMessage(playerid, COLOR_WHITE, str);
			}
	}
	return 1;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----< CreateItemDataTable >--------------------------------------------------
stock CreateItemDataTable()
{
	new str[1024];
	strcpy(str, "CREATE TABLE IF NOT EXISTS itemdata (");
	strcat(str, "ID int(5) NOT NULL auto_increment PRIMARY KEY");
	strcat(str, ",Itemmodel int(3) NOT NULL default '0'");
	strcat(str, ",Pos varchar(64) NOT NULL default '0.0,0.0,0.0,0.0,0,1'");
	strcat(str, ",Memo varchar(128) NOT NULL default ' '");
	strcat(str, ") ENGINE = InnoDB CHARACTER SET euckr COLLATE euckr_korean_ci");
	mysql_query(str);
	return 1;
}
//-----< SaveItemDataById >-----------------------------------------------------
stock SaveItemDataById(itemid)
{
	new str[1024];
	format(str, sizeof(str), "UPDATE itemdata SET");
	format(str, sizeof(str), "%s Itemmodel=%d", str, ItemInfo[itemid][iItemmodel]);
	format(str, sizeof(str), "%s,Pos='%.4f,%.4f,%.4f,%.4f,%d,%d'", str,
	    ItemInfo[itemid][iPos][0], ItemInfo[itemid][iPos][1], ItemInfo[itemid][iPos][2], ItemInfo[itemid][iPos][3],
	    ItemInfo[itemid][iInterior], ItemInfo[itemid][iVirtualWorld]);
	format(str, sizeof(str), "%s,Memo='%s'", str, escape(ItemInfo[itemid][iMemo]));
	format(str, sizeof(str), "%s WHERE ID=%d", str, ItemInfo[itemid][iID]);
	mysql_query(str);
	return 1;
}
//-----< SaveItemData >---------------------------------------------------------
stock SaveItemData()
{
	for (new i = 0, t = GetMaxItems(); i < t; i++)
	    if (IsValidItemID(i))
	        SaveItemDataById(i);
	return 1;
}
//-----< LoadItemData >---------------------------------------------------------
stock LoadItemData()
{
	new str[1024],
	    receive[6][128],
	    idx,
	    splited[6][16];
	UnloadItemData();
	mysql_query("SELECT * FROM itemdata");
	mysql_store_result();
	for (new i = 0, t = mysql_num_rows(); i < t; i++)
	{
	    mysql_fetch_row(str, "|");
	    split(str, receive, '|');
	    idx = 0;

	    ItemInfo[i][iID] = strval(receive[idx++]);
	    ItemInfo[i][iItemmodel] = strval(receive[idx++]);

		split(receive[idx++], splited, ',');
		for (new j = 0; j < 4; j++)
		    ItemInfo[i][iPos][j] = floatstr(splited[j]);
		ItemInfo[i][iInterior] = strval(splited[4]);
		ItemInfo[i][iVirtualWorld] = strval(splited[5]);

		strcpy(ItemInfo[i][iMemo], receive[idx++]);

		new Float:z = ItemInfo[i][iPos][2] + ItemModelInfo[ItemInfo[i][iItemmodel]][imZVar];
		ItemInfo[i][iObject] = CreateDynamicObject(ItemModelInfo[ItemInfo[i][iItemmodel]][imModel],
			ItemInfo[i][iPos][0], ItemInfo[i][iPos][1], z, 0.0, 0.0, ItemInfo[i][iPos][3],
			ItemInfo[i][iVirtualWorld], ItemInfo[i][iInterior]);
		ItemInfo[i][i3DText] = CreateDynamic3DTextLabel(ItemModelInfo[ItemInfo[i][iItemmodel]][imName], COLOR_WHITE,
		    ItemInfo[i][iPos][0], ItemInfo[i][iPos][1], z, 3.0,
		    INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0,
		    ItemInfo[i][iVirtualWorld], ItemInfo[i][iInterior]);
	}
	return 1;
}
//-----< UnloadItemDataById >---------------------------------------------------
stock UnloadItemDataById(itemid)
{
	ItemInfo[itemid][iID] = 0;
	DestroyDynamicObject(ItemInfo[itemid][iObject]);
	DestroyDynamic3DTextLabel(ItemInfo[itemid][i3DText]);
	return 1;
}
//-----< UnloadItemData >-------------------------------------------------------
stock UnloadItemData()
{
	for (new i = 0, t = GetMaxItems(); i < t; i++)
	    if (IsValidItemID(i))
	        UnloadItemDataById(i);
	return 1;
}
//-----< CreateItem >-----------------------------------------------------------
stock CreateItem(itemmodel, Float:x, Float:y, Float:z, Float:a, interiorid, worldid, memo[])
{
	new str[1024];
	format(str, sizeof(str), "INSERT INTO itemdata (Itemmodel,Pos,Memo)");
	format(str, sizeof(str), "%s VALUES (%d,'%.4f,%.4f,%.4f,%.4f,%d,%d','%s')", str,
		itemmodel, x, y, z, a, interiorid, worldid, escape(memo));
	mysql_query(str);
	LoadItemData();
	return 1;
}
//-----< DestroyItem >----------------------------------------------------------
stock DestroyItem(itemid)
{
	new str[128];
	format(str, sizeof(str), "DELETE FROM itemdata WHERE ID=%d", ItemInfo[itemid][iID]);
	mysql_query(str);
	UnloadItemDataById(itemid);
	return 1;
}
//-----<  >---------------------------------------------------------------------
//-----< CreatePlayerItemDataTable >--------------------------------------------
stock CreatePlayerItemDataTable()
{
	new str[1024];
	strcpy(str, "CREATE TABLE IF NOT EXISTS playeritemdata (");
	strcat(str, "ID int(5) NOT NULL auto_increment PRIMARY KEY");
	strcat(str, ",Itemmodel int(3) NOT NULL default '0'");
	strcat(str, ",Ownername varchar(32) NOT NULL default ' '");
	strcat(str, ",SaveType varchar(32) NOT NULL default ' '");
	strcat(str, ",Memo varchar(128) NOT NULL default ' '");
	strcat(str, ") ENGINE = InnoDB CHARACTER SET euckr COLLATE euckr_korean_ci");
	mysql_query(str);
	return 1;
}
//-----< SavePlayerItemDataById >-----------------------------------------------
stock SavePlayerItemDataById(playerid, itemid)
{
	new str[1024];
	format(str, sizeof(str), "UPDATE playeritemdata SET");
	format(str, sizeof(str), "%s Itemmodel=%d", str, PlayerItemInfo[playerid][itemid][iItemmodel]);
	format(str, sizeof(str), "%s,Ownername='%s'", str, escape(PlayerItemInfo[playerid][itemid][iOwnername]));
	format(str, sizeof(str), "%s,SaveType='%s'", str, escape(PlayerItemInfo[playerid][itemid][iSaveType]));
	format(str, sizeof(str), "%s,Memo='%s'", str, escape(PlayerItemInfo[playerid][itemid][iMemo]));
	format(str, sizeof(str), "%s WHERE ID=%d", str, PlayerItemInfo[playerid][itemid][iID]);
	mysql_query(str);
	return 1;
}
//-----< SavePlayerItemData >---------------------------------------------------
stock SavePlayerItemData(playerid)
{
	for (new i = 0, t = GetMaxPlayerItems(); i < t; i++)
	    if (IsValidPlayerItemID(playerid, i))
	        SavePlayerItemDataById(playerid, i);
	return 1;
}
//-----< LoadPlayerItemData >---------------------------------------------------
stock LoadPlayerItemData(playerid)
{
	new str[2048],
	    receive[7][128],
	    idx;
	UnloadPlayerItemData(playerid);
	format(str, sizeof(str), "SELECT * FROM playeritemdata WHERE Ownername='%s'", GetPlayerNameA(playerid));
	mysql_query(str);
	mysql_store_result();
	for (new i = 0, t = mysql_num_rows(); i < t; i++)
	{
	    mysql_fetch_row(str, "|");
	    split(str, receive, '|');
	    idx = 0;

	    PlayerItemInfo[playerid][i][iID] = strval(receive[idx++]);
	    PlayerItemInfo[playerid][i][iItemmodel] = strval(receive[idx++]);
	    strcpy(PlayerItemInfo[playerid][i][iOwnername], receive[idx++]);

		strcpy(PlayerItemInfo[playerid][i][iSaveType], receive[idx++]);
		strcpy(PlayerItemInfo[playerid][i][iMemo], receive[idx++]);
	}
	return 1;
}
//-----< UnloadPlayerItemDataById >---------------------------------------------
stock UnloadPlayerItemDataById(playerid, itemid)
{
	PlayerItemInfo[playerid][itemid][iID] = 0;
	return 1;
}
//-----< UnloadPlayerItemData >-------------------------------------------------
stock UnloadPlayerItemData(playerid)
{
	for (new i = 0, t = GetMaxPlayerItems(); i < t; i++)
	    if (IsValidPlayerItemID(playerid, i))
	        UnloadPlayerItemDataById(playerid, i);
	return 1;
}
//-----< CreatePlayerItem >-----------------------------------------------------
stock CreatePlayerItem(playerid, itemmodel, savetype[], memo[])
{
	new str[1024];
	format(str, sizeof(str), "INSERT INTO playeritemdata (Itemmodel,Ownername,SaveType,Memo)");
	format(str, sizeof(str), "%s VALUES (%d,'%s','%s','%s')", str,
		itemmodel, escape(GetPlayerNameA(playerid)), escape(savetype), escape(memo));
	mysql_query(str);
	LoadPlayerItemData(playerid);
	return 1;
}
//-----< DestroyPlayerItem >----------------------------------------------------
stock DestroyPlayerItem(playerid, itemid)
{
	new str[128];
	format(str, sizeof(str), "DELETE FROM playeritemdata WHERE ID=%d", PlayerItemInfo[playerid][itemid][iID]);
	mysql_query(str);
	UnloadPlayerItemDataById(playerid, itemid);
	return 1;
}
//-----<  >---------------------------------------------------------------------
//-----< GivePlayerItem >-------------------------------------------------------
stock GivePlayerItem(playerid, itemid, savetype[]="가방")
{
    new str[128];
	if (!IsValidItemID(itemid)) return 0;
	
	format(str, sizeof(str), ""C_GREEN"%s"C_WHITE"을(를) %s에 넣었습니다.", ItemModelInfo[ItemInfo[itemid][iItemmodel]][imName], savetype);
	SendClientMessage(playerid, COLOR_WHITE, str);
	CreatePlayerItem(playerid, ItemInfo[itemid][iItemmodel], savetype, ItemInfo[itemid][iMemo]);
	DestroyItem(itemid);
	return 1;
}
//-----< DropPlayerItem >-------------------------------------------------------
stock DropPlayerItem(playerid, itemid)
{
	new str[128];
	if (!IsValidPlayerItemID(playerid, itemid)) return 0;
	
	format(str, sizeof(str), ""C_GREEN"%s"C_WHITE"을(를) 버렸습니다.", ItemModelInfo[PlayerItemInfo[playerid][itemid][iItemmodel]][imName]);
	SendClientMessage(playerid, COLOR_WHITE, str);
	new Float:x, Float:y, Float:z, Float:a;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);
	CreateItem(PlayerItemInfo[playerid][itemid][iItemmodel], x, y, z, a,
		GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), PlayerItemInfo[playerid][itemid][iMemo]);
	DestroyPlayerItem(playerid, itemid);
	return 1;
}
//-----< GetPlayerItemsWeight >-------------------------------------------------
stock GetPlayerItemsWeight(playerid, savetype[]="All")
{
	new returns;
	for (new i = 0, t = GetMaxPlayerItems(); i < t; i++)
		if (IsValidPlayerItemID(playerid, i) && (!strcmp(savetype, PlayerItemInfo[playerid][i][iSaveType], true) || !strcmp(savetype, "All", true)))
			returns += ItemModelInfo[PlayerItemInfo[playerid][i][iItemmodel]][imWeight];
	return returns;
}
//-----< ShowPlayerItemList >---------------------------------------------------
stock ShowPlayerItemList(playerid, dialogid, savetype[]="가방")
{
	new str[2048], tmp[16], idx = 1;
	strtab(str, "번호", 5);
	strtab(str, "이름", 16);
	strcat(str, "무게");
	for (new i = 0, t = GetMaxPlayerItems(); i < t; i++)
	    if (IsValidPlayerItemID(playerid, i) && !strcmp(savetype, PlayerItemInfo[playerid][i][iSaveType], true))
	    {
	        strcat(str, "\n");
	        format(tmp, sizeof(tmp), "%04d", idx);
	        strtab(str, tmp, 5);
			strtab(str, ItemModelInfo[PlayerItemInfo[playerid][i][iItemmodel]][imName], 16);
			format(tmp, sizeof(tmp), "%d", ItemModelInfo[PlayerItemInfo[playerid][i][iItemmodel]][imWeight]);
			strcat(str, tmp);
			DialogData[playerid][idx++] = i;
	    }
	ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, savetype, str, "확인", "취소");
	return 1;
}
//-----< ShowPlayerItemInfo >---------------------------------------------------
stock ShowPlayerItemInfo(playerid, itemid)
{
	new str[512];
    strtab(str, "이름", 5);
    strcat(str, ItemModelInfo[PlayerItemInfo[playerid][itemid][iItemmodel]][imName]);
    strcat(str, "\n");
    strtab(str, "무게", 5);
    format(str, sizeof(str), "%s%d", str, ItemModelInfo[PlayerItemInfo[playerid][itemid][iItemmodel]][imWeight]);
    strcat(str, "\n");
    strtab(str, "설명", 5);
    strcat(str, ItemModelInfo[PlayerItemInfo[playerid][itemid][iItemmodel]][imInfo]);
    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "아이템 정보", str, "확인", chNullString);
    return 1;
}
//-----< ShowItemModelList >----------------------------------------------------
stock ShowItemModelList(playerid, dialogid)
{
	new str[4096], tmp[16];
	strtab(str, "번호", 5);
	strtab(str, "이름", 16);
	strtab(str, "무게", 5);
	strcat(str, "설명");
	for (new i = 0; i < sizeof(ItemModelInfo); i++)
	{
	    strcat(str, "\n");
		format(tmp, sizeof(tmp), "%04d", i);
		strtab(str, tmp, 5);
		strtab(str, ItemModelInfo[i][imName], 16);
		format(tmp, sizeof(tmp), "%d", ItemModelInfo[i][imWeight]);
		strtab(str, tmp, 5);
		strcat(str, ItemModelInfo[i][imInfo]);
	}
	ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, "아이템 목록", str, "확인", "취소");
	return 1;
}
//-----< GetPlayerNearestItem >-------------------------------------------------
stock GetPlayerNearestItem(playerid, Float:distance=1.0)
{
	new returns = -1,
		Float:idistance = distance+0.1;
	for (new i = 0, t = GetMaxItems(); i < t; i++)
        if (IsValidItemID(i)
        && IsPlayerInRangeOfPoint(playerid, idistance-0.1, ItemInfo[i][iPos][0], ItemInfo[i][iPos][1], ItemInfo[i][iPos][2]))
		{
		    idistance = GetPlayerDistanceFromPoint(playerid, ItemInfo[i][iPos][0], ItemInfo[i][iPos][1], ItemInfo[i][iPos][2]);
		    returns = i;
		}
	return returns;
}
//-----< IsValidItemID >--------------------------------------------------------
stock IsValidItemID(itemid)
{
	if (itemid < 0 || itemid >= GetMaxItems()) return false;
	return (ItemInfo[itemid][iID])?true:false;
}
//-----< GetMaxItems >----------------------------------------------------------
stock GetMaxItems()
	return MAX_ITEMS;
//-----< IsValidPlayerItemID >--------------------------------------------------
stock IsValidPlayerItemID(playerid, itemid)
{
	if (itemid < 0 || itemid >= GetMaxPlayerItems()) return false;
	return (PlayerItemInfo[playerid][itemid][iID])?true:false;
}
//-----< GetMaxPlayerItems >----------------------------------------------------
stock GetMaxPlayerItems()
	return MAX_PLAYERITEMS;
//-----<  >---------------------------------------------------------------------
