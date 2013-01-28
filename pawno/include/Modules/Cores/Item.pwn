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
 *		Update:		2013/01/28
 *
 *
 */
/*

  < Callbacks >
	gInitHandler_Item()
	pKeyStateChangeHandler_Item(playerid, newkeys, oldkeys)

  < Functions >
	CreateItemDataTable()
	SaveItemDataById(itemid)
	SaveItemData()
	LoadItemData()
	UnloadItemDataById(itemid)
	UnloadItemData()
	CreateItem(itemname[], Float:x, Float:y, Float:z, Float:a, interiorid, worldid, weight, memo[])
	DestroyItem(itemid)
	
	CreatePlayerItemDataTable()
	SavePlayerItemDataById(playerid, itemid)
	SavePlayerItemData(playerid)
	LoadPlayerItemData(playerid)
	UnloadPlayerItemDataById(playerid, itemid)
	UnloadPlayerItemData(playerid)
	CreatePlayerItem(playerid, itemname[], weight)
	
	GivePlayerItem(playerid, itemid, savetype[]="가방")
	GetPlayerItemsWeight(playerid, savetype[]="All")
	ShowPlayerItemList(playerid, dialogid, savetyoe[]="가방")
	GetPlayerNearestItem(playerid, Float:distance=2.0)
	GetItemObjectModel(itemname[])
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
	iItemname[32],
	iOwnername[MAX_PLAYER_NAME],
	Float:iPos[4],
	iInterior,
	iVirtualWorld,
	iWeight,
	iSaveType[32],
	iMemo[128],
	
	iObject,
	Text3D:i3DText
}
new ItemInfo[MAX_ITEMS][eItemInfo],
	PlayerItemInfo[MAX_PLAYERS][MAX_PLAYERITEMS][eItemInfo];



//-----< Defines
#define DialogId_Item(%0)   (100+%0)



//-----< Callbacks
forward gInitHandler_Item();
forward pSpawnHandler_Item(playerid);
forward pKeyStateChangeHandler_Item(playerid, newkeys, oldkeys);
forward pCommandTextHandler_Item(playerid, cmdtext[]);
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
    if (newkeys == KEY_SECONDARY_ATTACK)
    {
		new itemid = GetPlayerNearestItem(playerid);
		if (GetPlayerItemsWeight(playerid, "가방") + ItemInfo[itemid][iWeight] > GetPVarInt_(playerid, "pWeight"))
		{
			if (GetPlayerItemsWeight(playerid, "가방") > ItemInfo[itemid][iWeight])
				SendClientMessage(playerid, COLOR_WHITE, "가방이 너무 무겁습니다.");
			else
				SendClientMessage(playerid, COLOR_WHITE, "아이템이 너무 무겁습니다.");
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
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----< CreateItemDataTable >--------------------------------------------------
stock CreateItemDataTable()
{
	new str[1024];
	strcpy(str, "CREATE TABLE IF NOT EXISTS itemdata (");
	strcat(str, "ID int(5) NOT NULL auto_increment PRIMARY KEY");
	strcat(str, ",Itemname varchar(32) NOT NULL default ' '");
	strcat(str, ",Pos varchar(64) NOT NULL default '0.0,0.0,0.0,0.0,0,1'");
	strcat(str, ",Weight int(10) NOT NULL default '0'");
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
	format(str, sizeof(str), "%s Itemname='%s'", str, escape(ItemInfo[itemid][iItemname]));
	format(str, sizeof(str), "%s,Pos='%.4f,%.4f,%.4f,%.4f,%d,%d'", str,
	    ItemInfo[itemid][iPos][0], ItemInfo[itemid][iPos][1], ItemInfo[itemid][iPos][2], ItemInfo[itemid][iPos][3],
	    ItemInfo[itemid][iInterior], ItemInfo[itemid][iVirtualWorld]);
	format(str, sizeof(str), "%s,Weight=%d", str, ItemInfo[itemid][iWeight]);
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
	    strcpy(ItemInfo[i][iItemname], receive[idx++]);

		split(receive[idx++], splited, ',');
		for (new j = 0; j < 4; j++)
		    ItemInfo[i][iPos][j] = floatstr(splited[j]);
		ItemInfo[i][iInterior] = strval(splited[4]);
		ItemInfo[i][iVirtualWorld] = strval(splited[5]);

		ItemInfo[i][iWeight] = strval(receive[idx++]);
		strcpy(ItemInfo[i][iMemo], receive[idx++]);

		ItemInfo[i][iObject] = CreateDynamicObject(GetItemObjectModel(ItemInfo[i][iItemname]),
			ItemInfo[i][iPos][0], ItemInfo[i][iPos][1], ItemInfo[i][iPos][2], 0.0, 0.0, ItemInfo[i][iPos][3],
			ItemInfo[i][iVirtualWorld], ItemInfo[i][iInterior]);
		ItemInfo[i][i3DText] = CreateDynamic3DTextLabel(ItemInfo[i][iItemname], COLOR_WHITE,
		    ItemInfo[i][iPos][0], ItemInfo[i][iPos][1], ItemInfo[i][iPos][2], 3.0,
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
stock CreateItem(itemname[], Float:x, Float:y, Float:z, Float:a, interiorid, worldid, weight, memo[])
{
	new str[1024];
	format(str, sizeof(str), "INSERT INTO itemdata (Itemname,Pos,Weight,Memo)");
	format(str, sizeof(str), "%s VALUES ('%s','%.4f,%.4f,%.4f,%.4f,%d,%d',%d,'%s')", str,
		escape(itemname), x, y, z, a, interiorid, worldid, weight, escape(memo));
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
	strcat(str, ",Itemname varchar(32) NOT NULL default ' '");
	strcat(str, ",Ownername varchar(32) NOT NULL default ' '");
	strcat(str, ",Weight int(10) NOT NULL default '0'");
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
	format(str, sizeof(str), "%s Itemname='%s'", str, escape(PlayerItemInfo[playerid][itemid][iItemname]));
	format(str, sizeof(str), "%s,Ownername='%s'", str, escape(PlayerItemInfo[playerid][itemid][iOwnername]));
	format(str, sizeof(str), "%s,Weight=%d", str, PlayerItemInfo[playerid][itemid][iWeight]);
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
	new str[1024],
	    receive[7][128],
	    idx;
	UnloadPlayerItemData(playerid);
	format(str, sizeof(str), "SELECT * FROM playeritemdata WHERE Ownername='%s'", GetPlayerNameA(playerid));
	mysql_store_result();
	for (new i = 0, t = mysql_num_rows(); i < t; i++)
	{
	    mysql_fetch_row(str, "|");
	    split(str, receive, '|');
	    idx = 0;

	    PlayerItemInfo[playerid][i][iID] = strval(receive[idx++]);
	    strcpy(PlayerItemInfo[playerid][i][iItemname], receive[idx++]);
	    strcpy(PlayerItemInfo[playerid][i][iOwnername], receive[idx++]);

		PlayerItemInfo[playerid][i][iWeight] = strval(receive[idx++]);
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
stock CreatePlayerItem(playerid, itemname[], weight, savetype[], memo[])
{
	new str[1024];
	format(str, sizeof(str), "INSERT INTO playeritemdata (Itemname,Ownername,Weight,SaveType,Memo)");
	format(str, sizeof(str), "%s VALUES ('%s','%s',%d,'%s','%s')", str,
		escape(itemname), escape(GetPlayerNameA(playerid)), weight, escape(savetype), escape(memo));
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
	
	format(str, sizeof(str), ""C_GREEN"%s"C_WHITE"을(를) 가방에 넣었습니다.", ItemInfo[itemid][iItemname]);
	SendClientMessage(playerid, COLOR_WHITE, str);
	CreatePlayerItem(playerid, ItemInfo[itemid][iItemname], ItemInfo[itemid][iWeight], savetype, ItemInfo[itemid][iMemo]);
	DestroyItem(itemid);
	return 1;
}
//-----< GetPlayerItemsWeight >-------------------------------------------------
stock GetPlayerItemsWeight(playerid, savetype[]="All")
{
	new returns;
	for (new i = 0, t = GetMaxPlayerItems(); i < t; i++)
		if (IsValidPlayerItemID(playerid, i) && (!strcmp(savetype, PlayerItemInfo[playerid][i][iSaveType], true) || !strcmp(savetype, "All", true)))
			returns += PlayerItemInfo[playerid][i][iWeight];
	return returns;
}
//-----< ShowPlayerItemList >---------------------------------------------------
stock ShowPlayerItemList(playerid, dialogid, savetype[]="가방")
{
	new str[1024];
	strtab(str, "이름", 16);
	strcat(str, "무게\n");
	for (new i = 0, t = GetMaxPlayerItems(); i < t; i++)
	    if (IsValidPlayerItemID(playerid, i) && !strcmp(savetype, PlayerItemInfo[playerid][i][iSaveType], true))
	    {
			strtab(str, PlayerItemInfo[playerid][i][iItemname], 16);
			format(str, sizeof(str), "%s%d", str, PlayerItemInfo[playerid][i][iWeight]);
	    }
	ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, savetype, str, "확인", "취소");
	return 1;
}
//-----< GetPlayerNearestItem >-------------------------------------------------
stock GetPlayerNearestItem(playerid, Float:distance=2.0)
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
//-----< GetItemObjectModel >---------------------------------------------------
stock GetItemObjectModel(itemname[])
{
	if (!strlen(itemname)) return 0;
	else if (!strcmp(itemname, "나무표지판", true))
	    return 3927;
	else if (!strcmp(itemname, "표적판", true))
	{
	    new r = random(2);
	    if (r) return 3693;
		else return 3692;
	}
	else if (!strcmp(itemname, "동상", true))
	{
		new r = random(2);
		if (r) return 2745;
		else return 14467;
	}
	else if (!strcmp(itemname, "TV", true))
	    return 1429;
	else if (!strcmp(itemname, "침대", true))
	    return 1647;
	else if (!strcmp(itemname, "나무더미", true))
	    return 1469;
	else if (!strcmp(itemname, "나무판자", true))
	    return 1448;
	return 0;
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
