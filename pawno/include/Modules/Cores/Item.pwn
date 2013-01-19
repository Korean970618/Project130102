/*
 *
 *
 *		PureunBa(������)
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
 *		Update:		2013/01/19
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
	CreateItem(itemname[], Float:x, Float:y, Float:z, Float:a, interiorid, worldid, weight, size)
	GivePlayerItem(playerid, itemid)
	GetItemObjectModel(itemname[])
	IsValidItemID(itemid)
	GetMaxItems()

*/



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
	iSize,
	iMemo[128],
	
	iObject,
	Text3D:i3DText
}
new ItemInfo[500][eItemInfo],
	PlayerItemInfo[MAX_PLAYERS][500][eItemInfo];



//-----< Defines



//-----< Callbacks
forward gInitHandler_Item();
forward pKeyStateChangeHandler_Item(playerid, newkeys, oldkeys);
//-----< gInitHandler >---------------------------------------------------------
public gInitHandler_Item()
{
	CreateItemDataTable();
	LoadItemData();
	return 1;
}
//-----< pKeyStateChangeHandler >-----------------------------------------------
public pKeyStateChangeHandler_Item(playerid, newkeys, oldkeys)
{
    if (newkeys == KEY_SECONDARY_ATTACK)
		for (new i = 0, t = GetMaxItems(); i < t; i++)
		    if (IsValidItem(i))
		        if (!strlen(ItemInfo[i][iOwnername])
		        && IsPlayerInRangeOfPoint(playerid, 2.0, ItemInfo[i][iPos][0], ItemInfo[i][iPos][1], ItemInfo[i][iPos][2]))
		            GivePlayerItem(playerid, i);
	return 1;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----< CreateItemDataTable >--------------------------------------------------
stock CreateItemDataTable()
{
	new str[1024];
	strcpy(str, "CREATE TABLE IF NOT EXISTS itemdata (");
	strcat(str, "ID int(5) NOT NULL auto_increment PRIMARY KEY,");
	strcat(str, "Itemname varchar(32) NOT NULL default ' ',");
	strcat(str, "Ownername varchar(32) NOT NULL default ' ',");
	strcat(str, "Pos varchar(64) NOT NULL default '0.0,0.0,0.0,0.0,0,1',");
	strcat(str, "Weight int(10) NOT NULL default '0',");
	strcat(str, "Size int(10) NOT NULL default '0',");
	strcat(str, "Memo varchar(128) NOT NULL default ' ') ");
	strcat(str, "ENGINE = InnoDB CHARACTER SET euckr COLLATE euckr_korean_ci");
	mysql_query(str);
	return 1;
}
//-----< SaveItemDataById >-----------------------------------------------------
stock SaveItemDataById(itemid)
{
	new str[1024];
	format(str, sizeof(str), "UPDATE itemdata SET");
	format(str, sizeof(str), "%s Itemname='%s'", str, escape(ItemInfo[itemid][iItemname]));
	format(str, sizeof(str), "%s,Ownername='%s'", str, escape(ItemInfo[itemid][iOwnername]));
	format(str, sizeof(str), "%s,Pos='%.4f,%.4f,%.4f,%.4f,%d,%d'", str,
	    ItemInfo[itemid][iPos][0], ItemInfo[itemid][iPos][1], ItemInfo[itemid][iPos][2], ItemInfo[itemid][iPos][3],
	    ItemInfo[itemid][iInterior], ItemInfo[itemid][iVirtualWorld]);
	format(str, sizeof(str), "%s,Weight=%d", str, ItemInfo[itemid][iWeight]);
	format(str, sizeof(str), "%s,Size=%d", str, ItemInfo[itemid][iSize]);
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
	    receive[8][128],
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
	    strcpy(ItemInfo[i][iOwnername], receive[idx++]);

		split(receive[idx++], splited, ',');
		for (new j = 0; j < 4; j++)
		    ItemInfo[i][iPos][j] = floatstr(splited[j]);
		ItemInfo[i][iInterior] = strval(splited[4]);
		ItemInfo[i][iVirtualWorld] = strval(splited[5]);
		
		ItemInfo[i][iWeight] = strval(receive[idx++]);
		ItemInfo[i][iSize] = strval(receive[idx++]);
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
stock CreateItem(itemname[], Float:x, Float:y, Float:z, Float:a, interiorid, worldid, weight, size)
{
	new str[1024];
	format(str, sizeof(str), "INSERT INTO ITEMDATA (Itemname,Pos,Weight,Size)");
	format(str, sizeof(str), "%s VALUES ('%s','%.4f,%.4f,%.4f,%.4f,%d,%d',%d,%d)", str,
		escape(itemname), x, y, z, a, interiorid, worldid, weight, size);
	mysql_query(str);
	LoadItemData();
	return 1;
}
//-----< GivePlayerItem >-------------------------------------------------------
stock GivePlayerItem(playerid, itemid)
{
	DestroyDynamicObject(ItemInfo[itemid][iObject]);
	DestroyDynamic3DTextLabel(ItemInfo[itemid][i3DText]);

	strcpy(ItemInfo[itemid][iOwnername], GetPlayerNameA(playerid));
	SaveItemDataById(itemid);
	return 1;
}
//-----< GetItemObjectModel >---------------------------------------------------
stock GetItemObjectModel(itemname[])
{
	if (!strlen(itemname)) return 0;
	else if (!strcmp(itemname, "����ǥ����", true))
	    return 3927;
	else if (!strcmp(itemname, "ǥ����", true))
	{
	    new r = random(2);
	    if (r) return 3693;
		else return 3692;
	}
	else if (!strcmp(itemname, "����", true))
	{
	    new r = random(2);
	    if (r) return 2745;
	    else 14467;
	}
	else if (!strcmp(itemname, "TV", true))
	    return 1429;
	else if (!strcmp(itemname, "ħ��", true))
	    return 1647;
	else if (!strcmp(itemname, "��������", true))
	    return 1469;
	else if (!strcmp(itemname, "��������", true))
	    return 1448;
	else return 0;
}
//-----< IsValidItemID >--------------------------------------------------------
stock IsValidItemID(itemid)
	return (ItemInfo[itemid][iID])?true:false;
//-----< GetMaxItems >----------------------------------------------------------
stock GetMaxItems()
	return sizeof(ItemInfo);
//-----<  >---------------------------------------------------------------------
