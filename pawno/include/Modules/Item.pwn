/*
 *
 *
 *			Nogov Item Module
 *		  	2013/01/18
 *
 *
 *		Copyright (c) sBum. All rights reserved.
 *
 *
 */
/*

  < Callbacks >
	gInitHandler_Item()
	pSpawnHandler_Item(playerid)
	pConnectHandler_Item(playerid)
	pKeyStateChangeHandler_Item(playerid, newkeys, oldkeys)
	pCommandHandler_Item(playerid, cmdtext[])
	dResponseHandler_Item(playerid, dialogid, response, listitem, inputtext[])

  < Functions >
	CreateItemModelDataTable()
	SaveItemModelDataById(modelid)
	SaveItemModelData()
	LoadItemModelData()
	AddItemModel(modelid, name[], model, Float:zvar, weight, info[], Float:offset1[3], Float:rot1[3], Float:scale1[3], Float:offset2[3], Float:rot2[3], Float:scale2[3])
	DestroyItemModel(modelid)
  
	CreateItemDataTable()
	SaveItemDataById(itemid)
	SaveItemData()
	LoadItemData()
	UnloadItemDataById(itemid)
	UnloadItemData()
	CreateItem(itemmodel, Float:x, Float:y, Float:z, Float:a, interiorid, worldid, memo[], health=0)
	DestroyItem(itemid)
	SetItemHealth(itemid, health)
	GetItemHealth(itemid)
	
	CreatePlayerItemDataTable()
	SavePlayerItemDataById(playerid, itemid)
	SavePlayerItemData(playerid)
	LoadPlayerItemData(playerid)
	UnloadPlayerItemDataById(playerid, itemid)
	UnloadPlayerItemData(playerid)
	CreatePlayerItem(playerid, itemmodel, savetype[], memo[], health=0)
	SetPlayerItemHealth(playerid, itemid, health)
	GetPlayerItemHealth(playerid, itemid)
	
	GivePlayerItem(playerid, itemid, savetype[]="가방")
	GivePlayerItemToPlayer(playerid, destid, itemid, savetype[]="가방")
	GetPlayerItemsWeight(playerid, savetype[]="All")
	ShowPlayerItemList(playerid, destid, dialogid, savetyoe[]="All")
	ShowPlayerItemInfo(playerid, playerid, itemid)
	ShowItemModelList(playerid, dialogid)
	GetPlayerNearestItem(playerid, Float:distance=1.0)
	GetItemSaveTypeCode(savetype[])
	
	IsValidItemModelID(modelid)
	GetMaxItemModels()
	IsValidItemID(itemid)
	GetMaxItems()
	IsValidPlayerItemID(playerid, itemid)
	GetMaxPlayerItems()

*/



//-----< Defines
#define MAX_ITEMS			500
#define MAX_PLAYERITEMS		10
#define DialogId_Item(%0)   (100+%0)



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
	iVirtualItem,
	iHealth,
	
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
	imInfo[256],
	Float:imOffset1[3],
	Float:imRot1[3],
	Float:imScale1[3],
	Float:imOffset2[3],
	Float:imRot2[3],
	Float:imScale2[3],
	imMaxHealth
}
new ItemModelInfo[100][eItemModelInfo];
/*new ItemModelInfo[2][eItemModelInfo] =
{
	{
		"TV", 1429, -0.75, 60, "TV봐서 뭐하겠노... 그냥 부숴 버릴까?",
		{ 0.2, -0.2, 0.0 }, { 0.0, 270.0, 0.0 }, { 1.0, 1.0, 1.0 },
		{ 0.1, 0.25, 0.2 }, { 280.0, 0.0, 100.0 }, { 1.0, 1.0, 1.0 }
	},
	{
		"나무판자", 1448, -0.9, 3, "무언가를 만들거나 수리할 때 쓰면 좋을 것 같다.",
		{ 0.3, -0.3, -0.3 }, { 45.0, 0.0, 90.0 }, { 1.0, 1.0, 1.0 },
		{ 0.3, 0.1, 0.1 }, { 100.0, 0.0, 75.0 }, { 1.0, 1.0, 1.0 }
	}
};*/



//-----< Callbacks
forward gInitHandler_Item();
forward pSpawnHandler_Item(playerid);
forward pConnectHandler_Item(playerid);
forward pDisconnectHandler_Item(playerid, reason);
forward pKeyStateChangeHandler_Item(playerid, newkeys, oldkeys);
forward pCommandTextHandler_Item(playerid, cmdtext[]);
forward dResponseHandler_Item(playerid, dialogid, response, listitem, inputtext[]);
forward PlunderTimer(playerid);
//-----< gInitHandler >---------------------------------------------------------
public gInitHandler_Item()
{
	CreateItemModelDataTable();
	LoadItemModelData();
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
//-----< pConnectHandler >------------------------------------------------------
public pConnectHandler_Item(playerid)
{
	for(new i = 0, t = GetMaxPlayerItems(); i < t; i++)
	{
		PlayerItemInfo[playerid][i][iID] = 0;
		PlayerItemInfo[playerid][i][iItemmodel] = 0;
		strcpy(PlayerItemInfo[playerid][i][iOwnername], chNullString);
		for(new j = 0; j < 4; j++)
			PlayerItemInfo[playerid][i][iPos][j] = 0.0;
		PlayerItemInfo[playerid][i][iInterior] = 0;
		PlayerItemInfo[playerid][i][iVirtualWorld] = 0;
		strcpy(PlayerItemInfo[playerid][i][iSaveType], chNullString);
		strcpy(PlayerItemInfo[playerid][i][iMemo], chNullString);
	}
	return 1;
}
//-----< pKeyStateChangeHandler >-----------------------------------------------
public pKeyStateChangeHandler_Item(playerid, newkeys, oldkeys)
{
	new str[256];
	if(IsPlayerInAnyVehicle(playerid)) return 1;
	if(newkeys == KEY_SECONDARY_ATTACK)
	{
		new itemid = GetPlayerNearestItem(playerid);
		if(GetPlayerItemsWeight(playerid, "가방") + ItemModelInfo[ItemInfo[itemid][iItemmodel]][imWeight] > GetPVarInt(playerid, "pWeight"))
		{
			if(GetPlayerItemsWeight(playerid, "가방") > ItemModelInfo[ItemInfo[itemid][iItemmodel]][imWeight])
				SendClientMessage(playerid, COLOR_WHITE, "가방이 너무 무겁습니다.");
			else
			{
				format(str, sizeof(str), "%s은(는) 너무 무거워서 가방에 넣을 수 없습니다.", ItemModelInfo[ItemInfo[itemid][iItemmodel]][imName]);
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
	
	if(!strcmp(cmd, "/가방", true))
	{
		ShowPlayerItemList(playerid, playerid, DialogId_Item(0), "가방");
		return 1;
	}
	else if(!strcmp(cmd, "/손", true))
	{
		ShowPlayerItemList(playerid, playerid, DialogId_Item(3), "손");
		return 1;
	}
	return 0;
}
//-----< dResponseHandler >-----------------------------------------------------
public dResponseHandler_Item(playerid, dialogid, response, listitem, inputtext[])
{
	new str[256];
	switch(dialogid - DialogId_Item(0))
	{
		case 0:
			if(response)
			{
				if(!listitem) return ShowPlayerItemList(playerid, playerid, DialogId_Item(0), "가방");
				new itemid = DialogData[playerid][listitem];
				DialogData[playerid][0] = DialogData[playerid][listitem];
				ShowPlayerDialog(playerid, DialogId_Item(1), DIALOG_STYLE_LIST, ItemModelInfo[PlayerItemInfo[playerid][itemid][iItemmodel]][imName],
					"꺼낸다.\n확인한다.\n버린다.", "선택", "뒤로");
			}
		case 1:
		{
			if(response)
			{
				new itemid = DialogData[playerid][0];
				switch(listitem)
				{
					case 0:
					{
						ShowPlayerDialog(playerid, DialogId_Item(2), DIALOG_STYLE_LIST, ItemModelInfo[PlayerItemInfo[playerid][itemid][iItemmodel]][imName],
							"왼손으로 꺼낸다.\n오른손으로 꺼낸다.\n양손으로 꺼낸다.", "선택", "뒤로");
					}
					case 1:
					{
						ShowPlayerItemInfo(playerid, DialogId_Item(5), itemid);
					}
					case 2:
					{
						new Float:x, Float:y, Float:z;
						GetPlayerVelocity(playerid, x, y, z);
						if(IsValidItemID(GetPlayerNearestItem(playerid)))
							SendClientMessage(playerid, COLOR_WHITE, "다른 아이템 근처에선 버릴 수 없습니다.");
						else if(z != 0.0)
							SendClientMessage(playerid, COLOR_WHITE, "캐릭터를 멈춘 후 다시 시도하세요.");
						else DropPlayerItem(playerid, itemid);
					}
				}
			}
			else ShowPlayerItemList(playerid, playerid, DialogId_Item(0), "가방");
		}
		case 2:
		{
			new both[32], left[32], right[32], htext[32],
				itemid = DialogData[playerid][0],
				modelid = PlayerItemInfo[playerid][itemid][iItemmodel],
				items = GetPlayerItemsWeight(playerid, "왼손") + GetPlayerItemsWeight(playerid, "오른손") + (GetPlayerItemsWeight(playerid, "양손") / 2),
				weight = ItemModelInfo[modelid][imWeight];
			if(response)
			{
				for(new i = 0, t = GetMaxPlayerItems(); i < t; i++)
					if(IsValidPlayerItemID(playerid, i) && !strcmp(PlayerItemInfo[playerid][i][iSaveType], "양손", true))
					{
						strcpy(both, ItemModelInfo[PlayerItemInfo[playerid][i][iItemmodel]][imName]);
						break;
					}
				for(new i = 0, t = GetMaxPlayerItems(); i < t; i++)
					if(IsValidPlayerItemID(playerid, i) && !strcmp(PlayerItemInfo[playerid][i][iSaveType], "왼손", true))
					{
						strcpy(left, ItemModelInfo[PlayerItemInfo[playerid][i][iItemmodel]][imName]);
						break;
					}
				for(new i = 0, t = GetMaxPlayerItems(); i < t; i++)
					if(IsValidPlayerItemID(playerid, i) && !strcmp(PlayerItemInfo[playerid][i][iSaveType], "오른손", true))
					{
						strcpy(right, ItemModelInfo[PlayerItemInfo[playerid][i][iItemmodel]][imName]);
						break;
					}
				if(strlen(both))
				{
					format(str, sizeof(str), "양손에 "C_GREEN"%s"C_WHITE"이(가) 있습니다.", both);
					SendClientMessage(playerid, COLOR_WHITE, str);
					return 1;
				}
				else if(strlen(left) && (listitem == 0 || listitem == 2))
				{
					format(str, sizeof(str), "왼손에 "C_GREEN"%s"C_WHITE"이(가) 있습니다.", left);
					SendClientMessage(playerid, COLOR_WHITE, str);
					return 1;
				}
				else if(strlen(right) && (listitem == 1 || listitem == 2))
				{
					format(str, sizeof(str), "오른손에 "C_GREEN"%s"C_WHITE"이(가) 있습니다.", right);
					SendClientMessage(playerid, COLOR_WHITE, str);
					return 1;
				}
				weight = (listitem == 2) ? (ItemModelInfo[modelid][imWeight] / 2) : ItemModelInfo[modelid][imWeight];
				if(items + weight > GetPVarInt(playerid, "pHealth"))
				{
					if(items > weight)
						SendClientMessage(playerid, COLOR_WHITE, "손이 너무 무겁습니다.");
					else
					{
						format(str, sizeof(str), "%s은(는) 너무 무거워서 들 수 없습니다.", ItemModelInfo[modelid][imName]);
						SendClientMessage(playerid, COLOR_WHITE, str);
					}
					return 1;
				}
				switch(listitem)
				{
					case 0:
					{
						strcpy(htext, "왼손");
						SetPlayerAttachedObject(playerid, 0, ItemModelInfo[modelid][imModel], 5,
							ItemModelInfo[modelid][imOffset1][0], ItemModelInfo[modelid][imOffset1][1], ItemModelInfo[modelid][imOffset1][2],
							ItemModelInfo[modelid][imRot1][0], ItemModelInfo[modelid][imRot1][1], ItemModelInfo[modelid][imRot1][2],
							ItemModelInfo[modelid][imScale1][0], ItemModelInfo[modelid][imScale1][1], ItemModelInfo[modelid][imScale1][2]);
					}
					case 1:
					{
						strcpy(htext, "오른손");
						SetPlayerAttachedObject(playerid, 1, ItemModelInfo[modelid][imModel], 6,
							ItemModelInfo[modelid][imOffset1][0], ItemModelInfo[modelid][imOffset1][1], ItemModelInfo[modelid][imOffset1][2],
							ItemModelInfo[modelid][imRot1][0], ItemModelInfo[modelid][imRot1][1], ItemModelInfo[modelid][imRot1][2],
							ItemModelInfo[modelid][imScale1][0], ItemModelInfo[modelid][imScale1][1], ItemModelInfo[modelid][imScale1][2]);
					}
					case 2:
					{
						strcpy(htext, "양손");
						SetPlayerAttachedObject(playerid, 0, ItemModelInfo[modelid][imModel], 5,
							ItemModelInfo[modelid][imOffset2][0], ItemModelInfo[modelid][imOffset2][1], ItemModelInfo[modelid][imOffset2][2],
							ItemModelInfo[modelid][imRot2][0], ItemModelInfo[modelid][imRot2][1], ItemModelInfo[modelid][imRot2][2],
							ItemModelInfo[modelid][imScale2][0], ItemModelInfo[modelid][imScale2][1], ItemModelInfo[modelid][imScale2][2]);
						SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
					}
				}
				strcpy(PlayerItemInfo[playerid][itemid][iSaveType], htext);
				SavePlayerItemDataById(playerid, itemid);
				format(str, sizeof(str), ""C_GREEN"%s"C_WHITE"을(를) %s으로 꺼냈습니다.", ItemModelInfo[modelid][imName], htext);
				SendClientMessage(playerid, COLOR_WHITE, str);
			}
			else ShowPlayerDialog(playerid, DialogId_Item(1), DIALOG_STYLE_LIST, ItemModelInfo[PlayerItemInfo[playerid][itemid][iItemmodel]][imName],
					"꺼낸다.\n확인한다.\n버린다.", "선택", "뒤로");
		}
		case 3:
			if(response)
			{
				if(!listitem) return ShowPlayerItemList(playerid, playerid, DialogId_Item(3), "손");
				new itemid = DialogData[playerid][listitem];
				DialogData[playerid][0] = DialogData[playerid][listitem];
				ShowPlayerDialog(playerid, DialogId_Item(4), DIALOG_STYLE_LIST, ItemModelInfo[PlayerItemInfo[playerid][itemid][iItemmodel]][imName],
					"가방에 넣는다.\n확인한다\n버린다.", "선택", "뒤로");
			}
		case 4:
		{
			if(response)
			{
				new itemid = DialogData[playerid][0];
				switch(listitem)
				{
					case 0:
					{
						new htext[32];
						strcpy(htext, PlayerItemInfo[playerid][itemid][iSaveType]);
						if(!strcmp(htext, "왼손", true))
							RemovePlayerAttachedObject(playerid, 0);
						else if(!strcmp(htext, "오른손", true))
							RemovePlayerAttachedObject(playerid, 1);
						else if(!strcmp(htext, "양손", true))
						{
							RemovePlayerAttachedObject(playerid, 0);
							if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY)
								SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
						}
						strcpy(PlayerItemInfo[playerid][itemid][iSaveType], "가방");
						SavePlayerItemDataById(playerid, itemid);
						format(str, sizeof(str), ""C_GREEN"%s"C_WHITE"을(를) 가방에 넣었습니다.", ItemModelInfo[PlayerItemInfo[playerid][itemid][iItemmodel]][imName]);
						SendClientMessage(playerid, COLOR_WHITE, str);
					}
					case 1:
					{
						ShowPlayerItemInfo(playerid, DialogId_Item(6), itemid);
					}
					case 2:
					{
						new Float:x, Float:y, Float:z;
						GetPlayerVelocity(playerid, x, y, z);
						if(IsValidItemID(GetPlayerNearestItem(playerid)))
							SendClientMessage(playerid, COLOR_WHITE, "다른 아이템 근처에선 버릴 수 없습니다.");
						else if(z != 0.0)
							SendClientMessage(playerid, COLOR_WHITE, "캐릭터를 멈춘 후 다시 시도하세요.");
						else
						{
							new htext[32];
							strcpy(htext, PlayerItemInfo[playerid][itemid][iSaveType]);
							if(!strcmp(htext, "왼손", true))
								RemovePlayerAttachedObject(playerid, 0);
							else if(!strcmp(htext, "오른손", true))
								RemovePlayerAttachedObject(playerid, 1);
							else if(!strcmp(htext, "양손", true))
							{
								RemovePlayerAttachedObject(playerid, 0);
								if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY)
									SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
							}
							DropPlayerItem(playerid, itemid);
						}
					}
				}
			}
			else ShowPlayerItemList(playerid, playerid, DialogId_Item(3), "손");
		}
		case 5:
			if(!response)
			{
				new itemid = DialogData[playerid][0];
				ShowPlayerDialog(playerid, DialogId_Item(1), DIALOG_STYLE_LIST, ItemModelInfo[PlayerItemInfo[playerid][itemid][iItemmodel]][imName],
					"꺼낸다.\n확인한다.\n버린다.", "선택", "뒤로");
			}
		case 6:
			if(!response)
			{
				new itemid = DialogData[playerid][0];
				ShowPlayerDialog(playerid, DialogId_Item(4), DIALOG_STYLE_LIST, ItemModelInfo[PlayerItemInfo[playerid][itemid][iItemmodel]][imName],
					"가방에 넣는다.\n확인한다\n버린다.", "선택", "뒤로");
			}
	}
	return 1;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----< CreateItemModelDataTable >---------------------------------------------
stock CreateItemModelDataTable()
{
	new str[1024];
	strcpy(str, "CREATE TABLE IF NOT EXISTS itemmodeldata (");
	strcat(str, "ID int(5) NOT NULL PRIMARY KEY");
	strcat(str, ",Name varchar(32) NOT NULL DEFAULT ' '");
	strcat(str, ",Model int(10) NOT NULL default '0'");
	strcat(str, ",ZVar float(16,4) NOT NULL default '0.0'");
	strcat(str, ",Weight int(10) NOT NULL default '0'");
	strcat(str, ",Info varchar(256) NOT NULL default ' '");
	strcat(str, ",Position1 varchar(256) NOT NULL default '0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0'");
	strcat(str, ",Position2 varchar(256) NOT NULL default '0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0'");
	strcat(str, ",MaxHealth int(10) NOT NULL default '0'");
	strcat(str, ") ENGINE = InnoDB CHARACTER SET euckr COLLATE euckr_korean_ci");
	mysql_query(str);
	return 1;
}
//-----< SaveItemModelDataById >------------------------------------------------
stock SaveItemModelDataById(modelid)
{
	new str[2048];
	format(str, sizeof(str), "UPDATE itemmodeldata SET");
	format(str, sizeof(str), "%s Name='%s'", str, escape(ItemModelInfo[modelid][imName]));
	format(str, sizeof(str), "%s,Model=%d", str, ItemModelInfo[modelid][imModel]);
	format(str, sizeof(str), "%s,ZVar=%.4f", str, ItemModelInfo[modelid][imZVar]);
	format(str, sizeof(str), "%s,Weight=%d", str, ItemModelInfo[modelid][imWeight]);
	format(str, sizeof(str), "%s,Info='%s'", str, escape(ItemModelInfo[modelid][imInfo]));
	format(str, sizeof(str), "%s,Position1='%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f'", str,
		ItemModelInfo[modelid][imOffset1][0], ItemModelInfo[modelid][imRot1][0], ItemModelInfo[modelid][imScale1][0]
		ItemModelInfo[modelid][imOffset1][1], ItemModelInfo[modelid][imRot1][1], ItemModelInfo[modelid][imScale1][1]
		ItemModelInfo[modelid][imOffset1][2], ItemModelInfo[modelid][imRot1][2], ItemModelInfo[modelid][imScale1][2]);
	format(str, sizeof(str), "%s,Position2='%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f'", str,
		ItemModelInfo[modelid][imOffset2][0], ItemModelInfo[modelid][imRot2][0], ItemModelInfo[modelid][imScale2][0]
		ItemModelInfo[modelid][imOffset2][1], ItemModelInfo[modelid][imRot2][1], ItemModelInfo[modelid][imScale2][1]
		ItemModelInfo[modelid][imOffset2][2], ItemModelInfo[modelid][imRot2][2], ItemModelInfo[modelid][imScale2][2]);
	format(str, sizeof(str), "%s,MaxHealth=%d", str, ItemModelInfo[modelid][imMaxHealth]);
	format(str, sizeof(str), "%s WHERE ID=%d", str, modelid);
	mysql_query(str);
}
//-----< SaveItemModelData >----------------------------------------------------
stock SaveItemModelData()
{
	for(new i = 0, t = GetMaxItemModels(); i < t; i++)
		if(IsValidItemModelID(i))
			SaveItemModelDataById(i);
	return 1;
}
//-----< LoadItemModelData >----------------------------------------------------
stock LoadItemModelData()
{
	new count = GetTickCount();
	new str[2048],
		id,
		receive[10][256],
		idx,
		splited[9][32];
	mysql_query("SELECT * FROM itemmodeldata");
	mysql_store_result();
	for(new i = 0, t = mysql_num_rows(); i < t; i++)
	{
		mysql_fetch_row(str, "|");
		split(str, receive, '|');
		idx = 0;

		id = strval(receive[idx++]);
		strcpy(ItemModelInfo[id][imName], receive[idx++]);
		ItemModelInfo[id][imModel] = strval(receive[idx++]);
		ItemModelInfo[id][imZVar] = floatstr(receive[idx++]);
		ItemModelInfo[id][imWeight] = strval(receive[idx++]);
		strcpy(ItemModelInfo[id][imInfo], receive[idx++]);

		split(receive[idx++], splited, ',');
		for(new j = 0; j < 3; j++)
		{
			ItemModelInfo[id][imOffset1][j] = floatstr(splited[(j*3)]);
			ItemModelInfo[id][imRot1][j] = floatstr(splited[(j*3)+1]);
			ItemModelInfo[id][imScale1][j] = floatstr(splited[(j*3)+2]);
		}

		split(receive[idx++], splited, ',');
		for(new j = 0; j < 3; j++)
		{
			ItemModelInfo[id][imOffset2][j] = floatstr(splited[(j*3)]);
			ItemModelInfo[id][imRot2][j] = floatstr(splited[(j*3)+1]);
			ItemModelInfo[id][imScale2][j] = floatstr(splited[(j*3)+2]);
		}
		
		ItemModelInfo[id][imMaxHealth] = strval(receive[idx++]);
	}
	mysql_free_result();
	printf("itemmodeldata 테이블을 불러왔습니다. - %dms", GetTickCount() - count);
	return 1;
}
//-----< AddItemModel >---------------------------------------------------------
stock AddItemModel(modelid, name[], model, Float:zvar, weight, info[], Float:offset1[3], Float:rot1[3], Float:scale1[3], Float:offset2[3], Float:rot2[3], Float:scale2[3], maxhealth)
{
	new str[2048];
	format(str, sizeof(str), "INSERT INTO itemmodeldata (ID,Name,Model,ZVar,Weight,Info,Position1,Position2,MaxHealth) VALUES (%d,%s,%d,%.4f,%d,%s,'%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f','%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f',%d)",
		modelid, name, model, zvar, weight, info, offset1[0], rot1[0], scale1[0], offset1[1], rot1[1], scale1[1], offset1[2], rot1[2], scale1[2], offset2[0], rot2[0], scale2[0], offset2[1], rot2[1], scale2[1], offset2[2], rot2[2], scale2[2], maxhealth);
	mysql_query(str);
	return 1;
}
//-----< DestroyItemModel >-----------------------------------------------------
stock DestroyItemModel(modelid)
{
	new str[1024];
	format(str, sizeof(str), "DELETE FROM itemmodeldata WHERE Model=%d", modelid);
	mysql_query(str);
	return 1;
}
//-----<  >---------------------------------------------------------------------
//-----< CreateItemDataTable >--------------------------------------------------
stock CreateItemDataTable()
{
	new str[1024];
	strcpy(str, "CREATE TABLE IF NOT EXISTS itemdata (");
	strcat(str, "ID int(5) NOT NULL auto_increment PRIMARY KEY");
	strcat(str, ",Itemmodel int(3) NOT NULL default '0'");
	strcat(str, ",Pos varchar(64) NOT NULL default '0.0,0.0,0.0,0.0,0,1'");
	strcat(str, ",Memo varchar(128) NOT NULL default ' '");
	strcat(str, ",Health int(10) NOT NULL default '0'");
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
	format(str, sizeof(str), "%s,Health=%d", str, ItemInfo[itemid][iHealth]);
	format(str, sizeof(str), "%s WHERE ID=%d", str, ItemInfo[itemid][iID]);
	mysql_query(str);
	return 1;
}
//-----< SaveItemData >---------------------------------------------------------
stock SaveItemData()
{
	for(new i = 0, t = GetMaxItems(); i < t; i++)
		if(IsValidItemID(i))
			SaveItemDataById(i);
	return 1;
}
//-----< LoadItemData >---------------------------------------------------------
stock LoadItemData()
{
	new count = GetTickCount();
	new str[1024],
		receive[7][128],
		idx,
		splited[6][16];
	UnloadItemData();
	mysql_query("SELECT * FROM itemdata");
	mysql_store_result();
	for(new i = 0, t = mysql_num_rows(); i < t; i++)
	{
		mysql_fetch_row(str, "|");
		split(str, receive, '|');
		idx = 0;

		ItemInfo[i][iID] = strval(receive[idx++]);
		ItemInfo[i][iItemmodel] = strval(receive[idx++]);

		split(receive[idx++], splited, ',');
		for(new j = 0; j < 4; j++)
			ItemInfo[i][iPos][j] = floatstr(splited[j]);
		ItemInfo[i][iInterior] = strval(splited[4]);
		ItemInfo[i][iVirtualWorld] = strval(splited[5]);

		strcpy(ItemInfo[i][iMemo], receive[idx++]);
		ItemInfo[i][iHealth] = strval(receive[idx++]);

		new Float:z = ItemInfo[i][iPos][2] + ItemModelInfo[ItemInfo[i][iItemmodel]][imZVar];
		ItemInfo[i][iObject] = CreateDynamicObject(ItemModelInfo[ItemInfo[i][iItemmodel]][imModel],
			ItemInfo[i][iPos][0], ItemInfo[i][iPos][1], z, 0.0, 0.0, ItemInfo[i][iPos][3],
			ItemInfo[i][iVirtualWorld], ItemInfo[i][iInterior]);
		ItemInfo[i][i3DText] = CreateDynamic3DTextLabel(ItemModelInfo[ItemInfo[i][iItemmodel]][imName], COLOR_WHITE,
			ItemInfo[i][iPos][0], ItemInfo[i][iPos][1], z, 3.0,
			INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0,
			ItemInfo[i][iVirtualWorld], ItemInfo[i][iInterior]);
	}
	mysql_free_result();
	printf("itemdata 테이블을 불러왔습니다. - %dms", GetTickCount() - count);
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
	for(new i = 0, t = GetMaxItems(); i < t; i++)
		if(IsValidItemID(i))
			UnloadItemDataById(i);
	return 1;
}
//-----< CreateItem >-----------------------------------------------------------
stock CreateItem(itemmodel, Float:x, Float:y, Float:z, Float:a, interiorid, worldid, memo[], health=0)
{
	new str[1024];
	format(str, sizeof(str), "INSERT INTO itemdata (Itemmodel,Pos,Memo,Health)");
	format(str, sizeof(str), "%s VALUES (%d,'%.4f,%.4f,%.4f,%.4f,%d,%d','%s',%d)", str,
		itemmodel, x, y, z, a, interiorid, worldid, escape(memo), (health == 0) ? ItemModelInfo[itemmodel][imMaxHealth] : health);
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
//-----< SetItemHealth >--------------------------------------------------------
stock SetItemHealth(itemid, health)
{
	if(!health)
		return DestroyItem(itemid);
	ItemInfo[itemid][iHealth] = health;
	return 1;
}
//-----< GetItemHealth >--------------------------------------------------------
stock GetItemHealth(itemid)
{
	return ItemInfo[itemid][iHealth];
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
	strcat(str, ",VirtualItem int(1) NOT NULL default '0'");
	strcat(str, ",Health int(10) NOT NULL default '0'");
	strcat(str, ") ENGINE = InnoDB CHARACTER SET euckr COLLATE euckr_korean_ci");
	mysql_query(str);
	return 1;
}
//-----< SavePlayerItemDataById >-----------------------------------------------
stock SavePlayerItemDataById(playerid, itemid)
{
	new str[1024];
	if(!GetPVarInt(playerid, "LoggedIn")) return 1;
	format(str, sizeof(str), "UPDATE playeritemdata SET");
	format(str, sizeof(str), "%s Itemmodel=%d", str, PlayerItemInfo[playerid][itemid][iItemmodel]);
	format(str, sizeof(str), "%s,Ownername='%s'", str, escape(PlayerItemInfo[playerid][itemid][iOwnername]));
	format(str, sizeof(str), "%s,SaveType='%s'", str, escape(PlayerItemInfo[playerid][itemid][iSaveType]));
	format(str, sizeof(str), "%s,Memo='%s'", str, escape(PlayerItemInfo[playerid][itemid][iMemo]));
	format(str, sizeof(str), "%s,VirtualItem=%d", str, PlayerItemInfo[playerid][itemid][iVirtualItem]);
	format(str, sizeof(str), "%s,Health=%d", str, PlayerItemInfo[playerid][itemid][iHealth]);
	format(str, sizeof(str), "%s WHERE ID=%d", str, PlayerItemInfo[playerid][itemid][iID]);
	mysql_query(str);
	return 1;
}
//-----< SavePlayerItemData >---------------------------------------------------
stock SavePlayerItemData(playerid)
{
	for(new i = 0, t = GetMaxPlayerItems(); i < t; i++)
		if(IsValidPlayerItemID(playerid, i))
			SavePlayerItemDataById(playerid, i);
	return 1;
}
//-----< LoadPlayerItemData >---------------------------------------------------
stock LoadPlayerItemData(playerid)
{
	new str[2048],
		receive[8][128],
		idx;
	UnloadPlayerItemData(playerid);
	format(str, sizeof(str), "SELECT * FROM playeritemdata WHERE Ownername='%s' AND VirtualItem=%d", GetPlayerNameA(playerid), GetPVarInt(playerid, "pAgentMode"));
	mysql_query(str);
	mysql_store_result();
	for(new i = 0, t = mysql_num_rows(); i < t; i++)
	{
		mysql_fetch_row(str, "|");
		split(str, receive, '|');
		idx = 0;

		PlayerItemInfo[playerid][i][iID] = strval(receive[idx++]);
		PlayerItemInfo[playerid][i][iItemmodel] = strval(receive[idx++]);
		strcpy(PlayerItemInfo[playerid][i][iOwnername], receive[idx++]);

		strcpy(PlayerItemInfo[playerid][i][iSaveType], receive[idx++]);
		strcpy(PlayerItemInfo[playerid][i][iMemo], receive[idx++]);
		PlayerItemInfo[playerid][i][iVirtualItem] = strval(receive[idx++]);
		PlayerItemInfo[playerid][i][iHealth] = strval(receive[idx++]);
		
		new modelid = PlayerItemInfo[playerid][i][iItemmodel];
		if(!strcmp(PlayerItemInfo[playerid][i][iSaveType], "왼손", true))
			SetPlayerAttachedObject(playerid, 0, ItemModelInfo[modelid][imModel], 5,
				ItemModelInfo[modelid][imOffset1][0], ItemModelInfo[modelid][imOffset1][1], ItemModelInfo[modelid][imOffset1][2],
				ItemModelInfo[modelid][imRot1][0], ItemModelInfo[modelid][imRot1][1], ItemModelInfo[modelid][imRot1][2],
				ItemModelInfo[modelid][imScale1][0], ItemModelInfo[modelid][imScale1][1], ItemModelInfo[modelid][imScale1][2]);
		else if(!strcmp(PlayerItemInfo[playerid][i][iSaveType], "오른손", true))
			SetPlayerAttachedObject(playerid, 1, ItemModelInfo[modelid][imModel], 6,
				ItemModelInfo[modelid][imOffset1][0], ItemModelInfo[modelid][imOffset1][1], ItemModelInfo[modelid][imOffset1][2],
				ItemModelInfo[modelid][imRot1][0], ItemModelInfo[modelid][imRot1][1], ItemModelInfo[modelid][imRot1][2],
				ItemModelInfo[modelid][imScale1][0], ItemModelInfo[modelid][imScale1][1], ItemModelInfo[modelid][imScale1][2]);
		else if(!strcmp(PlayerItemInfo[playerid][i][iSaveType], "양손", true))
		{
			SetPlayerAttachedObject(playerid, 0, ItemModelInfo[modelid][imModel], 5,
				ItemModelInfo[modelid][imOffset2][0], ItemModelInfo[modelid][imOffset2][1], ItemModelInfo[modelid][imOffset2][2],
				ItemModelInfo[modelid][imRot2][0], ItemModelInfo[modelid][imRot2][1], ItemModelInfo[modelid][imRot2][2],
				ItemModelInfo[modelid][imScale2][0], ItemModelInfo[modelid][imScale2][1], ItemModelInfo[modelid][imScale2][2]);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
		}
	}
	mysql_free_result();
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
	for(new i = 0, t = GetMaxPlayerItems(); i < t; i++)
		if(IsValidPlayerItemID(playerid, i))
			UnloadPlayerItemDataById(playerid, i);
	return 1;
}
//-----< CreatePlayerItem >-----------------------------------------------------
stock CreatePlayerItem(playerid, itemmodel, savetype[], memo[], health=0)
{
	new str[1024];
	format(str, sizeof(str), "INSERT INTO playeritemdata (Itemmodel,Ownername,SaveType,Memo,VirtualItem,Health)");
	format(str, sizeof(str), "%s VALUES (%d,'%s','%s','%s',%d,%d)", str,
		itemmodel, escape(GetPlayerNameA(playerid)), escape(savetype), escape(memo), GetPVarInt(playerid, "pAgentMode"), (health == 0) ? ItemModelInfo[itemmodel][imMaxHealth] : health);
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
//-----< SetPlayerItemHealth >--------------------------------------------------
stock SetPlayerItemHealth(playerid, itemid, health)
{
	if(!health)
		return DestroyPlayerItem(playerid, itemid);
	PlayerItemInfo[playerid][itemid][iHealth] = health;
	return 1;
}
//-----< GetPlayerItemHealth >--------------------------------------------------
stock GetPlayerItemHealth(playerid, itemid)
{
	return PlayerItemInfo[playerid][itemid][iHealth];
}
//-----<  >---------------------------------------------------------------------
//-----< GivePlayerItem >-------------------------------------------------------
stock GivePlayerItem(playerid, itemid, savetype[]="가방")
{
	new str[128];
	if(!IsValidItemID(itemid)) return 0;
	
	format(str, sizeof(str), ""C_GREEN"%s"C_WHITE"을(를) %s에 넣었습니다.", ItemModelInfo[ItemInfo[itemid][iItemmodel]][imName], savetype);
	SendClientMessage(playerid, COLOR_WHITE, str);
	CreatePlayerItem(playerid, ItemInfo[itemid][iItemmodel], savetype, ItemInfo[itemid][iMemo], ItemInfo[itemid][iHealth]);
	DestroyItem(itemid);
	return 1;
}
//-----< GivePlayerItemToPlayer >-----------------------------------------------
stock GivePlayerItemToPlayer(playerid, destid, itemid, savetype[]="가방")
{
	CreatePlayerItem(destid, PlayerItemInfo[playerid][itemid][iItemmodel], savetype, PlayerItemInfo[playerid][itemid][iMemo], PlayerItemInfo[playerid][itemid][iHealth]);
	DestroyPlayerItem(playerid, itemid);
	return 1;
}
//-----< DropPlayerItem >-------------------------------------------------------
stock DropPlayerItem(playerid, itemid)
{
	new str[128];
	if(!IsValidPlayerItemID(playerid, itemid)) return 0;
	
	format(str, sizeof(str), ""C_GREEN"%s"C_WHITE"을(를) 버렸습니다.", ItemModelInfo[PlayerItemInfo[playerid][itemid][iItemmodel]][imName]);
	SendClientMessage(playerid, COLOR_WHITE, str);
	new Float:x, Float:y, Float:z, Float:a;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);
	CreateItem(PlayerItemInfo[playerid][itemid][iItemmodel], x, y, z, a,
		GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), PlayerItemInfo[playerid][itemid][iMemo], PlayerItemInfo[playerid][itemid][iHealth]);
	DestroyPlayerItem(playerid, itemid);
	return 1;
}
//-----< GetPlayerItemsWeight >-------------------------------------------------
stock GetPlayerItemsWeight(playerid, savetype[]="All")
{
	new returns;
	for(new i = 0, t = GetMaxPlayerItems(); i < t; i++)
		if(IsValidPlayerItemID(playerid, i) && (GetItemSaveTypeCode(PlayerItemInfo[playerid][i][iSaveType]) == GetItemSaveTypeCode(savetype) || !strcmp(savetype, "All", true)))
			returns += ItemModelInfo[PlayerItemInfo[playerid][i][iItemmodel]][imWeight];
	return returns;
}
//-----< ShowPlayerItemList >---------------------------------------------------
stock ShowPlayerItemList(playerid, destid, dialogid, savetype[]="All")
{
	new str[2048], tmp[16], idx = 1;
	strtab(str, "번호", 5);
	strtab(str, "이름", 16);
	strcat(str, "무게");
	for(new i = 0, t = GetMaxPlayerItems(); i < t; i++)
		if(IsValidPlayerItemID(destid, i)
		&&(GetItemSaveTypeCode(savetype) == GetItemSaveTypeCode(PlayerItemInfo[destid][i][iSaveType])
		|| !strcmp(savetype, "All", true)))
		{
			strcat(str, "\n");
			format(tmp, sizeof(tmp), "%04d", idx);
			strtab(str, tmp, 5);
			strtab(str, ItemModelInfo[PlayerItemInfo[destid][i][iItemmodel]][imName], 16);
			format(tmp, sizeof(tmp), "%d", ItemModelInfo[PlayerItemInfo[destid][i][iItemmodel]][imWeight]);
			strcat(str, tmp);
			DialogData[playerid][idx++] = i;
		}
	if(!strcmp(savetype, "All", true))
		strcpy(tmp, "아이템");
	else strcpy(tmp, savetype);
	ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, tmp, str, "확인", "뒤로");
	return 1;
}
//-----< ShowPlayerItemInfo >---------------------------------------------------
stock ShowPlayerItemInfo(playerid, dialogid, itemid)
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
	ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, "아이템 정보", str, "확인", "뒤로");
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
	for(new i = 0; i < sizeof(ItemModelInfo); i++)
	{
		strcat(str, "\n");
		format(tmp, sizeof(tmp), "%04d", i);
		strtab(str, tmp, 5);
		strtab(str, ItemModelInfo[i][imName], 16);
		format(tmp, sizeof(tmp), "%d", ItemModelInfo[i][imWeight]);
		strtab(str, tmp, 5);
		strcat(str, ItemModelInfo[i][imInfo]);
	}
	ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, "아이템 목록", str, "확인", "뒤로");
	return 1;
}
//-----< GetPlayerNearestItem >-------------------------------------------------
stock GetPlayerNearestItem(playerid, Float:distance=1.0)
{
	new returns = -1,
		Float:idistance = distance+0.1;
	for(new i = 0, t = GetMaxItems(); i < t; i++)
		if(IsValidItemID(i)
		&& IsPlayerInRangeOfPoint(playerid, idistance-0.1, ItemInfo[i][iPos][0], ItemInfo[i][iPos][1], ItemInfo[i][iPos][2]))
		{
			idistance = GetPlayerDistanceFromPoint(playerid, ItemInfo[i][iPos][0], ItemInfo[i][iPos][1], ItemInfo[i][iPos][2]);
			returns = i;
		}
	return returns;
}
//-----< GetItemSaveTypeCode >--------------------------------------------------
stock GetItemSaveTypeCode(savetype[])
{
	new code = 0;
	if(!strlen(savetype)) return code;
	else if(!strcmp(savetype, "가방", true)) 	code = 1;
	else if(!strcmp(savetype, "손", true))	 code = 2;
	else if(!strcmp(savetype, "왼손", true))	code = 2;
	else if(!strcmp(savetype, "오른손", true)) code = 2;
	else if(!strcmp(savetype, "양손", true))   code = 2;
	return code;
}
//-----<  >---------------------------------------------------------------------
//-----< IsValidItemModelID >---------------------------------------------------
stock IsValidItemModelID(modelid)
	return (strlen(ItemModelInfo[modelid][imName]))?true:false;
//-----< GetMaxItemModels >-----------------------------------------------------
stock GetMaxItemModels()
	return sizeof(ItemModelInfo);
//-----< IsValidItemID >--------------------------------------------------------
stock IsValidItemID(itemid)
{
	if(itemid < 0 || itemid >= GetMaxItems()) return false;
	return (ItemInfo[itemid][iID])?true:false;
}
//-----< GetMaxItems >----------------------------------------------------------
stock GetMaxItems()
	return MAX_ITEMS;
//-----< IsValidPlayerItemID >--------------------------------------------------
stock IsValidPlayerItemID(playerid, itemid)
{
	if(itemid < 0 || itemid >= GetMaxPlayerItems()) return false;
	return (PlayerItemInfo[playerid][itemid][iID])?true:false;
}
//-----< GetMaxPlayerItems >----------------------------------------------------
stock GetMaxPlayerItems()
	return MAX_PLAYERITEMS;
//-----<  >---------------------------------------------------------------------
