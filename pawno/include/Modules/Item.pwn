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
	pUpdateHandler_Item(playerid)
	pKeyStateChangeHandler_Item(playerid, newkeys, oldkeys)
	pCommandHandler_Item(playerid, cmdtext[])
	dResponseHandler_Item(playerid, dialogid, response, listitem, inputtext[])
	PlunderTimer(playerid)

  < Functions >
	CreateItemModelDataTable()
	SaveItemModelDataById(modelid)
	SaveItemModelData()
	LoadItemModelData()
	GetItemModelName(modelid)
	UseItemModel(playerid)
  
	CreateItemDataTable()
	SaveItemDataById(itemid)
	SaveItemData()
	LoadItemData()
	UnloadItemDataById(itemid)
	UnloadItemData()
	CreateItem(itemmodel, Float:x, Float:y, Float:z, Float:a, interiorid, worldid, memo[], health=0, amount=1)
	DestroyItem(itemid)
	SetItemHealth(itemid, health)
	GetItemHealth(itemid)
	GetItemModelID(itemid)
	GetItemAmount(itemid)
	
	CreatePlayerItemDataTable()
	SavePlayerItemDataById(playerid, itemid)
	SavePlayerItemData(playerid)
	LoadPlayerItemData(playerid)
	UnloadPlayerItemDataById(playerid, itemid)
	UnloadPlayerItemData(playerid)
	CreatePlayerItem(playerid, itemmodel, savetype[], memo[], health=0, amount=1)
	SetPlayerItemHealth(playerid, itemid, health)
	GetPlayerItemHealth(playerid, itemid)
	GetPlayerItemModelID(playerid, itemid)
	GetPlayerItemAmount(playerid, itemid)
	
	GivePlayerItem(playerid, itemid, savetype[], amount)
	GivePlayerItemToPlayer(playerid, destid, itemid, savetype[], amount)
	DropPlayerItem(playerid, itemid, amount)
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
	iAmount,
	
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
	imMaxHealth,
	imHand,
	imEffect[32],
	imEffectAmount
}
new ItemModelInfo[100][eItemModelInfo];
/*new ItemModelInfo[2][eItemModelInfo] =
{
	{
		"TV", 1429, -0.75, 60, "TV���� ���ϰڳ�... �׳� �ν� ������?",
		{ 0.2, -0.2, 0.0 }, { 0.0, 270.0, 0.0 }, { 1.0, 1.0, 1.0 },
		{ 0.1, 0.25, 0.2 }, { 280.0, 0.0, 100.0 }, { 1.0, 1.0, 1.0 }
	},
	{
		"��������", 1448, -0.9, 3, "���𰡸� ����ų� ������ �� ���� ���� �� ����.",
		{ 0.3, -0.3, -0.3 }, { 45.0, 0.0, 90.0 }, { 1.0, 1.0, 1.0 },
		{ 0.3, 0.1, 0.1 }, { 100.0, 0.0, 75.0 }, { 1.0, 1.0, 1.0 }
	}
};*/
new WeaponItem[MAX_PLAYERS];



//-----< Callbacks
forward gInitHandler_Item();
forward pSpawnHandler_Item(playerid);
forward pConnectHandler_Item(playerid);
forward pUpdateHandler_Item(playerid);
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
		PlayerItemInfo[playerid][i][iVirtualItem] = false;
		PlayerItemInfo[playerid][i][iHealth] = 0;
		PlayerItemInfo[playerid][i][iAmount] = 0;
	}
	WeaponItem[playerid] = 0;
	return 1;
}
//-----< pUpdateHandler >-------------------------------------------------------
public pUpdateHandler_Item(playerid)
{
	new weaponid = GetPlayerWeapon(playerid);
	if(weaponid != WeaponItem[playerid])
	{
		if(WeaponItem[playerid])
			SetPlayerAmmo(playerid, GetWeaponSlotID(WeaponItem[playerid]), 0);
		WeaponItem[playerid] = weaponid;
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
		DialogData[playerid][0] = itemid;
		format(str, sizeof(str), ""C_GREEN"%s %d��"C_WHITE"�� �ֽ��ϴ�.\n�� ���� �ֿ�ðڽ��ϱ�?", ItemModelInfo[ItemInfo[itemid][iItemmodel]][imName], GetItemAmount(itemid));
		ShowPlayerDialog(playerid, DialogId_Item(7), DIALOG_STYLE_INPUT, "����", str, "Ȯ��", "���");
	}
	return 1;
}
//-----< pCommandTextHandler >--------------------------------------------------
public pCommandTextHandler_Item(playerid, cmdtext[])
{
	new cmd[256], idx;
	cmd = strtok(cmdtext, idx);
	
	if(!strcmp(cmd, "/����", true))
	{
		ShowPlayerItemList(playerid, playerid, DialogId_Item(0), "����");
		return 1;
	}
	else if(!strcmp(cmd, "/��", true))
	{
		ShowPlayerItemList(playerid, playerid, DialogId_Item(3), "��");
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
				if(!listitem) return ShowPlayerItemList(playerid, playerid, DialogId_Item(0), "����");
				new itemid = DialogData[playerid][listitem];
				DialogData[playerid][0] = DialogData[playerid][listitem];
				ShowPlayerDialog(playerid, DialogId_Item(1), DIALOG_STYLE_LIST, ItemModelInfo[PlayerItemInfo[playerid][itemid][iItemmodel]][imName],
					"������.\n����Ѵ�.\nȮ���Ѵ�.\n������.", "����", "�ڷ�");
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
							"�޼����� ������.\n���������� ������.\n������� ������.", "����", "�ڷ�");
					}
					case 1:
					{
						new modelid = PlayerItemInfo[playerid][itemid][iItemmodel];
						if(!UseItemModel(playerid, modelid))
							return ShowPlayerDialog(playerid, DialogId_Item(9), DIALOG_STYLE_MSGBOX, "�˸�", "����� �� ���� �������Դϴ�.", "Ȯ��", chNullString);
						if(!--PlayerItemInfo[playerid][itemid][iAmount])
							DestroyPlayerItem(playerid, itemid);
						SavePlayerItemDataById(playerid, itemid);
						format(str, sizeof(str), ""C_GREEN"%s"C_WHITE"��(��) ����Ͽ� "C_GREEN"%s %d"C_WHITE"�� ȿ���� �޾ҽ��ϴ�.", ItemModelInfo[modelid][imName], ItemModelInfo[modelid][imEffect], ItemModelInfo[modelid][imEffectAmount]);
						SendClientMessage(playerid, COLOR_WHITE, str);
					}
					case 2:
					{
						ShowPlayerItemInfo(playerid, DialogId_Item(5), itemid);
					}
					case 3:
					{
						new Float:x, Float:y, Float:z;
						GetPlayerVelocity(playerid, x, y, z);
						if(IsValidItemID(GetPlayerNearestItem(playerid)))
							SendClientMessage(playerid, COLOR_WHITE, "�ٸ� ������ ��ó���� ���� �� �����ϴ�.");
						else if(z != 0.0)
							SendClientMessage(playerid, COLOR_WHITE, "ĳ���͸� ���� �� �ٽ� �õ��ϼ���.");
						else
						{
							format(str, sizeof(str), ""C_GREEN"%s %d��"C_WHITE"�� �ֽ��ϴ�.\n�� ���� �����ðڽ��ϱ�?", GetPlayerItemModelName(playerid, itemid), GetPlayerItemAmount(playerid, itemid));
							ShowPlayerDialog(playerid, DialogId_Item(8), DIALOG_STYLE_INPUT, "����", str, "Ȯ��", "�ڷ�");
						}
					}
				}
			}
			else ShowPlayerItemList(playerid, playerid, DialogId_Item(0), "����");
		}
		case 2:
		{
			new both[32], left[32], right[32], htext[32],
				itemid = DialogData[playerid][0],
				modelid = PlayerItemInfo[playerid][itemid][iItemmodel],
				items = GetPlayerItemsWeight(playerid, "�޼�") + GetPlayerItemsWeight(playerid, "������") + (GetPlayerItemsWeight(playerid, "���") / 2),
				weight = ItemModelInfo[modelid][imWeight],
				weapon = GetPlayerWeapon(playerid);
			if(response)
			{
				if(GetWeaponHand(ItemModelInfo[modelid][imModel]) == 'r' && listitem != 1)
				{
					format(str, sizeof(str), "%s��(��) ������ �����Դϴ�.", ItemModelInfo[modelid][imName]);
					SendClientMessage(playerid, COLOR_WHITE, str);
					return 1;
				}
				else if(GetWeaponHand(ItemModelInfo[modelid][imModel]) == 'b' && listitem != 2)
				{
					format(str, sizeof(str), "%s��(��) ��� �����Դϴ�.", ItemModelInfo[modelid][imName]);
					SendClientMessage(playerid, COLOR_WHITE, str);
					return 1;
				}
				for(new i = 0, t = GetMaxPlayerItems(); i < t; i++)
					if(IsValidPlayerItemID(playerid, i) && !strcmp(PlayerItemInfo[playerid][i][iSaveType], "���", true))
					{
						strcpy(both, ItemModelInfo[PlayerItemInfo[playerid][i][iItemmodel]][imName]);
						break;
					}
				for(new i = 0, t = GetMaxPlayerItems(); i < t; i++)
					if(IsValidPlayerItemID(playerid, i) && !strcmp(PlayerItemInfo[playerid][i][iSaveType], "�޼�", true))
					{
						strcpy(left, ItemModelInfo[PlayerItemInfo[playerid][i][iItemmodel]][imName]);
						break;
					}
				for(new i = 0, t = GetMaxPlayerItems(); i < t; i++)
					if(IsValidPlayerItemID(playerid, i) && !strcmp(PlayerItemInfo[playerid][i][iSaveType], "������", true))
					{
						strcpy(right, ItemModelInfo[PlayerItemInfo[playerid][i][iItemmodel]][imName]);
						break;
					}
				if(strlen(both))
				{
					format(str, sizeof(str), "��տ� "C_GREEN"%s"C_WHITE"��(��) �ֽ��ϴ�.", both);
					SendClientMessage(playerid, COLOR_WHITE, str);
					return 1;
				}
				else if(strlen(left) && (listitem == 0 || listitem == 2))
				{
					format(str, sizeof(str), "�޼տ� "C_GREEN"%s"C_WHITE"��(��) �ֽ��ϴ�.", left);
					SendClientMessage(playerid, COLOR_WHITE, str);
					return 1;
				}
				else if(strlen(right) && (listitem == 1 || listitem == 2))
				{
					format(str, sizeof(str), "�����տ� "C_GREEN"%s"C_WHITE"��(��) �ֽ��ϴ�.", right);
					SendClientMessage(playerid, COLOR_WHITE, str);
					return 1;
				}
				weight = (listitem == 2) ? (ItemModelInfo[modelid][imWeight] / 2) : ItemModelInfo[modelid][imWeight];
				if(items + weight > GetPVarInt(playerid, "pHealth"))
				{
					if(items > weight)
						SendClientMessage(playerid, COLOR_WHITE, "���� �ʹ� ���̽��ϴ�.");
					else
					{
						format(str, sizeof(str), "%s��(��) �ʹ� ���ſ��� �� �� �����ϴ�.", ItemModelInfo[modelid][imName]);
						SendClientMessage(playerid, COLOR_WHITE, str);
					}
					return 1;
				}
				switch(listitem)
				{
					case 0:
					{
						strcpy(htext, "�޼�");
						SetPlayerAttachedObject(playerid, 0, ItemModelInfo[modelid][imModel], 5,
							ItemModelInfo[modelid][imOffset1][0], ItemModelInfo[modelid][imOffset1][1], ItemModelInfo[modelid][imOffset1][2],
							ItemModelInfo[modelid][imRot1][0], ItemModelInfo[modelid][imRot1][1], ItemModelInfo[modelid][imRot1][2],
							ItemModelInfo[modelid][imScale1][0], ItemModelInfo[modelid][imScale1][1], ItemModelInfo[modelid][imScale1][2]);
					}
					case 1:
					{
						strcpy(htext, "������");
						SetPlayerAttachedObject(playerid, 1, ItemModelInfo[modelid][imModel], 6,
							ItemModelInfo[modelid][imOffset1][0], ItemModelInfo[modelid][imOffset1][1], ItemModelInfo[modelid][imOffset1][2],
							ItemModelInfo[modelid][imRot1][0], ItemModelInfo[modelid][imRot1][1], ItemModelInfo[modelid][imRot1][2],
							ItemModelInfo[modelid][imScale1][0], ItemModelInfo[modelid][imScale1][1], ItemModelInfo[modelid][imScale1][2]);
					}
					case 2:
					{
						strcpy(htext, "���");
						SetPlayerAttachedObject(playerid, 0, ItemModelInfo[modelid][imModel], 5,
							ItemModelInfo[modelid][imOffset2][0], ItemModelInfo[modelid][imOffset2][1], ItemModelInfo[modelid][imOffset2][2],
							ItemModelInfo[modelid][imRot2][0], ItemModelInfo[modelid][imRot2][1], ItemModelInfo[modelid][imRot2][2],
							ItemModelInfo[modelid][imScale2][0], ItemModelInfo[modelid][imScale2][1], ItemModelInfo[modelid][imScale2][2]);
						SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
					}
				}
				if(weapon) ResetPlayerWeapons(playerid);
				if(GetWeaponHand(ItemModelInfo[modelid][imModel]) != 'n')
					GivePlayerWeapon(playerid, ItemModelInfo[modelid][imModel], PlayerItemInfo[playerid][itemid][iAmount]);
				GivePlayerItemToPlayer(playerid, playerid, itemid, htext, 1);
				format(str, sizeof(str), ""C_GREEN"%s"C_WHITE"��(��) %s���� ���½��ϴ�.", ItemModelInfo[modelid][imName], htext);
				SendClientMessage(playerid, COLOR_WHITE, str);
			}
			else ShowLastDialog(playerid);
		}
		case 3:
			if(response)
			{
				if(!listitem) return ShowPlayerItemList(playerid, playerid, DialogId_Item(3), "��");
				new itemid = DialogData[playerid][listitem];
				DialogData[playerid][0] = DialogData[playerid][listitem];
				ShowPlayerDialog(playerid, DialogId_Item(4), DIALOG_STYLE_LIST, ItemModelInfo[PlayerItemInfo[playerid][itemid][iItemmodel]][imName],
					"���濡 �ִ´�.\n����Ѵ�.\nȮ���Ѵ�.\n������.", "����", "�ڷ�");
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
						if(!strcmp(htext, "�޼�", true))
							RemovePlayerAttachedObject(playerid, 0);
						else if(!strcmp(htext, "������", true))
							RemovePlayerAttachedObject(playerid, 1);
						else if(!strcmp(htext, "���", true))
						{
							RemovePlayerAttachedObject(playerid, 0);
							if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY)
								SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
						}
						GivePlayerItemToPlayer(playerid, playerid, itemid, "����", 1);
						format(str, sizeof(str), ""C_GREEN"%s"C_WHITE"��(��) ���濡 �־����ϴ�.", ItemModelInfo[PlayerItemInfo[playerid][itemid][iItemmodel]][imName]);
						SendClientMessage(playerid, COLOR_WHITE, str);
					}
					case 1:
					{
						new modelid = ItemInfo[itemid][iItemmodel];
						if(!UseItemModel(playerid, modelid))
							return ShowPlayerDialog(playerid, DialogId_Item(9), DIALOG_STYLE_MSGBOX, "�˸�", "����� �� ���� �������Դϴ�.", "Ȯ��", chNullString);
						if(!--ItemInfo[itemid][iAmount])
							DestroyItem(itemid);
						SaveItemDataById(itemid);
						format(str, sizeof(str), ""C_GREEN"%s"C_WHITE"��(��) ����Ͽ� "C_GREEN"%s %d"C_WHITE"�� ȿ���� �޾ҽ��ϴ�.", ItemModelInfo[modelid][imName], ItemModelInfo[modelid][imEffect], ItemModelInfo[modelid][imEffectAmount]);
						SendClientMessage(playerid, COLOR_WHITE, str);
					}
					case 2:
					{
						ShowPlayerItemInfo(playerid, DialogId_Item(6), itemid);
					}
					case 3:
					{
						new Float:x, Float:y, Float:z;
						GetPlayerVelocity(playerid, x, y, z);
						if(IsValidItemID(GetPlayerNearestItem(playerid)))
							SendClientMessage(playerid, COLOR_WHITE, "�ٸ� ������ ��ó���� ���� �� �����ϴ�.");
						else if(z != 0.0)
							SendClientMessage(playerid, COLOR_WHITE, "ĳ���͸� ���� �� �ٽ� �õ��ϼ���.");
						else
						{
							format(str, sizeof(str), ""C_GREEN"%s %d��"C_WHITE"�� �ֽ��ϴ�.\n�� ���� �����ðڽ��ϱ�?", GetPlayerItemModelName(playerid, itemid), GetPlayerItemAmount(playerid, itemid));
							ShowPlayerDialog(playerid, DialogId_Item(8), DIALOG_STYLE_INPUT, "����", str, "Ȯ��", "���");
						}
					}
				}
			}
			else ShowPlayerItemList(playerid, playerid, DialogId_Item(3), "��");
		}
		case 5:
			if(!response)
			{
				ShowLastDialog(playerid);
			}
		case 6:
			if(!response)
			{
				ShowLastDialog(playerid);
			}
		case 7:
			if(response)
			{
				new itemid = DialogData[playerid][0],
					amount = strval(inputtext);
				if(amount < 1) ReshowDialog(playerid);
				else if(amount > GetItemAmount(itemid)) amount = GetItemAmount(itemid);
				if(!IsPlayerInRangeOfPoint(playerid, 1.0, ItemInfo[itemid][iPos][0], ItemInfo[itemid][iPos][1], ItemInfo[itemid][iPos][2])
				|| GetPlayerVirtualWorld(playerid) != ItemInfo[itemid][iVirtualWorld])
					return ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "�˸�", "�ֿ� �������� ��ó�� ���� �ʽ��ϴ�.", "Ȯ��", chNullString);
				if(GetPlayerItemsWeight(playerid, "����") + ItemModelInfo[ItemInfo[itemid][iItemmodel]][imWeight] > GetPVarInt(playerid, "pWeight"))
				{
					if(GetPlayerItemsWeight(playerid, "����") > ItemModelInfo[ItemInfo[itemid][iItemmodel]][imWeight])
						SendClientMessage(playerid, COLOR_WHITE, "������ �ʹ� ���̽��ϴ�.");
					else
					{
						format(str, sizeof(str), "%s��(��) �ʹ� ���ſ��� ���濡 ���� �� �����ϴ�.", ItemModelInfo[ItemInfo[itemid][iItemmodel]][imName]);
						SendClientMessage(playerid, COLOR_WHITE, str);
					}
				}
				else
					GivePlayerItem(playerid, itemid, "����", strval(inputtext));
			}
			else ShowLastDialog(playerid);
		case 8:
			if(response)
			{
				new htext[32],
					itemid = DialogData[playerid][0],
					amount = strval(inputtext),
					modelid = PlayerItemInfo[playerid][itemid][iItemmodel];
				if(amount < 1) ReshowDialog(playerid);
				else if(amount < GetPlayerItemAmount(playerid, itemid)) amount = GetPlayerItemAmount(playerid, itemid);
				strcpy(htext, PlayerItemInfo[playerid][itemid][iSaveType]);
				if(!strcmp(htext, "�޼�", true) && (ItemModelInfo[modelid][imHand] == 0 || ItemModelInfo[modelid][imHand] == 1))
					RemovePlayerAttachedObject(playerid, 0);
				else if(!strcmp(htext, "������", true) && (ItemModelInfo[modelid][imHand] == 0 || ItemModelInfo[modelid][imHand] == 2))
					RemovePlayerAttachedObject(playerid, 1);
				else if(!strcmp(htext, "���", true) && (ItemModelInfo[modelid][imHand] == 0 || ItemModelInfo[modelid][imHand] == 3))
				{
					RemovePlayerAttachedObject(playerid, 0);
					if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY)
						SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
				}
				DropPlayerItem(playerid, itemid, amount);
			}
			else ShowLastDialog(playerid);
		case 9: ShowLastDialog(playerid);
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
	strcat(str, ",Hand int(1) NOT NULL default '0'");
	strcat(str, ",Effect varchar(32) NOT NULL default ' '");
	strcat(str, ",EffectAmount int(10) NOT NULL default '0'");
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
	format(str, sizeof(str), "%s,Hand=%d", str, ItemModelInfo[modelid][imHand]);
	format(str, sizeof(str), "%s,Effect='%s'", str, escape(ItemModelInfo[modelid][imEffect]));
	format(str, sizeof(str), "%s,EffectAmount=%d", str, ItemModelInfo[modelid][imEffectAmount]);
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
		receive[12][256],
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
		ItemModelInfo[id][imHand] = strval(receive[idx++]);
		strcpy(ItemModelInfo[id][imEffect], receive[idx++]);
		ItemModelInfo[id][imEffectAmount] = strval(receive[idx++]);
	}
	mysql_free_result();
	printf("itemmodeldata ���̺��� �ҷ��Խ��ϴ�. - %dms", GetTickCount() - count);
	return 1;
}
//-----< GetItemModelName >-----------------------------------------------------
stock GetItemModelName(modelid)
{
	return ItemModelInfo[modelid][imName];
}
//-----< UseItemModel >---------------------------------------------------------
stock UseItemModel(playerid, modelid)
{
	new Effect[32],
		amount = ItemModelInfo[modelid][imEffectAmount];
	strcpy(Effect, ItemModelInfo[modelid][imEffect]);
	
	if(!strcmp(Effect, "ġ��", true))
		SetPlayerHealth(playerid, GetPlayerHealthA(playerid) + amount);
	else if(!strcmp(Effect, "���", true))
		SetPVarInt(playerid, "pHunger", GetPVarInt(playerid, "pHunger")+1);
	else return 0;
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
	strcat(str, ",Amount int(10) NOT NULL default '0'");
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
	format(str, sizeof(str), "%s,Amount=%d", str, ItemInfo[itemid][iAmount]);
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
		receive[8][128],
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
		ItemInfo[i][iAmount] = strval(receive[idx++]);

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
	printf("itemdata ���̺��� �ҷ��Խ��ϴ�. - %dms", GetTickCount() - count);
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
stock CreateItem(itemmodel, Float:x, Float:y, Float:z, Float:a, interiorid, worldid, memo[], health=0, amount=1)
{
	new str[1024];
	format(str, sizeof(str), "INSERT INTO itemdata (Itemmodel,Pos,Memo,Health,Amount)");
	format(str, sizeof(str), "%s VALUES (%d,'%.4f,%.4f,%.4f,%.4f,%d,%d','%s',%d,%d)", str,
		itemmodel, x, y, z, a, interiorid, worldid, escape(memo), (health == 0) ? ItemModelInfo[itemmodel][imMaxHealth] : health, amount);
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
//-----< GetItemModelID >-------------------------------------------------------
stock GetItemModelID(itemid)
{
	return ItemInfo[itemid][iItemmodel];
}
//-----< GetItemAmount >--------------------------------------------------------
stock GetItemAmount(itemid)
{
	return ItemInfo[itemid][iAmount];
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
	strcat(str, ",Amount int(10) NOT NULL default '0'");
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
	format(str, sizeof(str), "%s,Amount=%d", str, PlayerItemInfo[playerid][itemid][iAmount]);
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
		receive[9][128],
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
		PlayerItemInfo[playerid][i][iAmount] = strval(receive[idx++]);
		
		new modelid = PlayerItemInfo[playerid][i][iItemmodel];
		if(!strcmp(PlayerItemInfo[playerid][i][iSaveType], "�޼�", true))
			SetPlayerAttachedObject(playerid, 0, ItemModelInfo[modelid][imModel], 5,
				ItemModelInfo[modelid][imOffset1][0], ItemModelInfo[modelid][imOffset1][1], ItemModelInfo[modelid][imOffset1][2],
				ItemModelInfo[modelid][imRot1][0], ItemModelInfo[modelid][imRot1][1], ItemModelInfo[modelid][imRot1][2],
				ItemModelInfo[modelid][imScale1][0], ItemModelInfo[modelid][imScale1][1], ItemModelInfo[modelid][imScale1][2]);
		else if(!strcmp(PlayerItemInfo[playerid][i][iSaveType], "������", true))
			SetPlayerAttachedObject(playerid, 1, ItemModelInfo[modelid][imModel], 6,
				ItemModelInfo[modelid][imOffset1][0], ItemModelInfo[modelid][imOffset1][1], ItemModelInfo[modelid][imOffset1][2],
				ItemModelInfo[modelid][imRot1][0], ItemModelInfo[modelid][imRot1][1], ItemModelInfo[modelid][imRot1][2],
				ItemModelInfo[modelid][imScale1][0], ItemModelInfo[modelid][imScale1][1], ItemModelInfo[modelid][imScale1][2]);
		else if(!strcmp(PlayerItemInfo[playerid][i][iSaveType], "���", true))
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
stock CreatePlayerItem(playerid, itemmodel, savetype[], memo[], health=0, amount=1)
{
	new str[1024];
	format(str, sizeof(str), "INSERT INTO playeritemdata (Itemmodel,Ownername,SaveType,Memo,VirtualItem,Health,Amount)");
	format(str, sizeof(str), "%s VALUES (%d,'%s','%s','%s',%d,%d)", str,
		itemmodel, escape(GetPlayerNameA(playerid)), escape(savetype), escape(memo), GetPVarInt(playerid, "pAgentMode"), (health == 0) ? ItemModelInfo[itemmodel][imMaxHealth] : health, amount);
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
	SavePlayerItemDataById(playerid, itemid);
	return 1;
}
//-----< GetPlayerItemHealth >--------------------------------------------------
stock GetPlayerItemHealth(playerid, itemid)
{
	return PlayerItemInfo[playerid][itemid][iHealth];
}
//-----< GetPlayerItemModelID >-------------------------------------------------
stock GetPlayerItemModelName(playerid, itemid)
{
	return PlayerItemInfo[playerid][itemid][iItemmodel];
}
//-----< GetPlayerItemAmount >--------------------------------------------------
stock GetPlayerItemAmount(playerid, itemid)
{
	return PlayerItemInfo[playerid][itemid][iAmount];
}
//-----<  >---------------------------------------------------------------------
//-----< GivePlayerItem >-------------------------------------------------------
stock GivePlayerItem(playerid, itemid, savetype[], amount)
{
	new str[128], exists;
	if(!IsValidItemID(itemid)) return 0;
	
	if(ItemInfo[itemid][iAmount] < amount) amount = ItemInfo[itemid][iAmount];
	format(str, sizeof(str), ""C_GREEN"%s %d��"C_WHITE"�� %s�� �־����ϴ�.", ItemModelInfo[ItemInfo[itemid][iItemmodel]][imName], amount, savetype);
	SendClientMessage(playerid, COLOR_WHITE, str);
	for(new i = 0; i < MAX_PLAYERITEMS; i++)
		if(PlayerItemInfo[playerid][i][iItemmodel] == ItemInfo[itemid][iItemmodel]
		&& !strcmp(PlayerItemInfo[playerid][i][iMemo], ItemInfo[itemid][iMemo], true)
		&& GetItemSaveTypeCode(PlayerItemInfo[playerid][i][iSaveType]) == GetItemSaveTypeCode(savetype))
		{
			PlayerItemInfo[playerid][i][iAmount] += amount;
			SavePlayerItemDataById(playerid, i);
			exists = true;
			break;
		}
	if(!exists)
		CreatePlayerItem(playerid, ItemInfo[itemid][iItemmodel], savetype, ItemInfo[itemid][iMemo], ItemInfo[itemid][iHealth], amount);
	if(ItemInfo[itemid][iAmount] <= amount)
		DestroyItem(itemid);
	else
	{
		ItemInfo[itemid][iAmount] -= amount;
		SaveItemDataById(itemid);
	}
	return 1;
}
//-----< GivePlayerItemToPlayer >-----------------------------------------------
stock GivePlayerItemToPlayer(playerid, destid, itemid, savetype[], amount)
{
	new str[128], exists;
	if(!IsValidPlayerItemID(playerid, itemid)) return 0;
	
	if(PlayerItemInfo[playerid][itemid][iAmount] < amount) amount = PlayerItemInfo[playerid][itemid][iAmount];
	format(str, sizeof(str), "%s�Կ��� "C_GREEN"%s %d��"C_WHITE"�� ��Ƚ��ϴ�.", GetPlayerNameA(destid), ItemModelInfo[PlayerItemInfo[playerid][itemid][iItemmodel]][imName], amount);
	SendClientMessage(playerid, COLOR_WHITE, str);
	format(str, sizeof(str), "%s�����κ��� "C_GREEN"%s %d��"C_WHITE"�� �޾� %s�� �־����ϴ�.", GetPlayerNameA(playerid), ItemModelInfo[PlayerItemInfo[playerid][itemid][iItemmodel]][imName], amount, savetype);
	SendClientMessage(destid, COLOR_WHITE, str);
	for(new i = 0; i < MAX_PLAYERITEMS; i++)
		if(PlayerItemInfo[destid][i][iItemmodel] == PlayerItemInfo[playerid][itemid][iItemmodel]
		&& !strcmp(PlayerItemInfo[destid][i][iMemo], PlayerItemInfo[playerid][itemid][iMemo], true)
		&& GetItemSaveTypeCode(PlayerItemInfo[destid][i][iSaveType]) == GetItemSaveTypeCode(savetype))
		{
			PlayerItemInfo[destid][i][iAmount] += amount;
			SavePlayerItemDataById(destid, i);
			exists = true;
			break;
		}
	if(!exists)
		CreatePlayerItem(destid, PlayerItemInfo[playerid][itemid][iItemmodel], savetype, PlayerItemInfo[playerid][itemid][iMemo], PlayerItemInfo[playerid][itemid][iHealth], amount);
	if(PlayerItemInfo[playerid][itemid][iAmount] <= amount)
		DestroyPlayerItem(playerid, itemid);
	else
	{
		PlayerItemInfo[playerid][itemid][iAmount] -= amount;
		SavePlayerItemDataById(playerid, itemid);
	}
	return 1;
}
//-----< DropPlayerItem >-------------------------------------------------------
stock DropPlayerItem(playerid, itemid, amount)
{
	new str[128];
	if(!IsValidPlayerItemID(playerid, itemid)) return 0;
	
	if(PlayerItemInfo[playerid][itemid][iAmount] < amount) amount = PlayerItemInfo[playerid][itemid][iAmount];
	format(str, sizeof(str), ""C_GREEN"%s %d��"C_WHITE"��(��) ���Ƚ��ϴ�.", ItemModelInfo[PlayerItemInfo[playerid][itemid][iItemmodel]][imName], amount);
	SendClientMessage(playerid, COLOR_WHITE, str);
	if(PlayerItemInfo[playerid][itemid][iAmount] <= amount)
		DestroyPlayerItem(playerid, itemid);
	else
	{
		new Float:x, Float:y, Float:z, Float:a;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
		CreateItem(PlayerItemInfo[playerid][itemid][iItemmodel], x, y, z, a,
			GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), PlayerItemInfo[playerid][itemid][iMemo], PlayerItemInfo[playerid][itemid][iHealth], amount);
		PlayerItemInfo[playerid][itemid][iAmount] -= amount;
		SavePlayerItemDataById(playerid, itemid);
	}
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
	strtab(str, "��ȣ", 5);
	strtab(str, "�̸�", 16);
	strtab(str, "����", 5);
	strcat(str, "����");
	for(new i = 0, t = GetMaxPlayerItems(); i < t; i++)
		if(IsValidPlayerItemID(destid, i)
		&&(GetItemSaveTypeCode(savetype) == GetItemSaveTypeCode(PlayerItemInfo[destid][i][iSaveType])
		|| !strcmp(savetype, "All", true)))
		{
			new modelid = PlayerItemInfo[destid][i][iItemmodel];
			strcat(str, "\n");
			format(tmp, sizeof(tmp), "%04d", idx);
			strtab(str, tmp, 5);
			strtab(str, ItemModelInfo[modelid][imName], 16);
			strtab(str, valstr_(ItemModelInfo[modelid][imWeight]), 5);
			strcat(str, valstr_(PlayerItemInfo[destid][i][iAmount]));
			DialogData[playerid][idx++] = i;
		}
	if(!strcmp(savetype, "All", true))
		strcpy(tmp, "������");
	else strcpy(tmp, savetype);
	ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, tmp, str, "Ȯ��", "�ڷ�");
	return 1;
}
//-----< ShowPlayerItemInfo >---------------------------------------------------
stock ShowPlayerItemInfo(playerid, dialogid, itemid)
{
	new str[512],
		modelid = PlayerItemInfo[playerid][itemid][iItemmodel];
	strtab(str, "�̸�", 5);
	strcat(str, ItemModelInfo[modelid][imName]);
	strcat(str, "\n");
	strtab(str, "����", 5);
	format(str, sizeof(str), "%s%d", str, ItemModelInfo[modelid][imWeight]);
	strcat(str, "\n");
	strtab(str, "ȿ��", 5);
	format(str, sizeof(str), "%s%s(%d)", str, ItemModelInfo[modelid][imEffect], ItemModelInfo[modelid][imEffectAmount]);
	strcat(str, "\n");
	strtab(str, "����", 5);
	strcat(str, ItemModelInfo[modelid][imInfo]);
	ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, "������ ����", str, "Ȯ��", "�ڷ�");
	return 1;
}
//-----< ShowItemModelList >----------------------------------------------------
stock ShowItemModelList(playerid, dialogid)
{
	new str[4096], tmp[16];
	strtab(str, "��ȣ", 5);
	strtab(str, "�̸�", 16);
	strtab(str, "����", 5);
	strcat(str, "ȿ��");
	for(new i = 0; i < sizeof(ItemModelInfo); i++)
	{
		strcat(str, "\n");
		format(tmp, sizeof(tmp), "%04d", i);
		strtab(str, tmp, 5);
		strtab(str, ItemModelInfo[i][imName], 16);
		format(tmp, sizeof(tmp), "%d", ItemModelInfo[i][imWeight]);
		strtab(str, tmp, 5);
		format(tmp, sizeof(tmp), "%s(%d)", ItemModelInfo[i][imEffect], ItemModelInfo[i][imEffectAmount]);
		strcat(str, tmp);
	}
	ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, "������ ���", str, "Ȯ��", "�ڷ�");
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
	else if(!strcmp(savetype, "����", true)) 	code = 1;
	else if(!strcmp(savetype, "��", true))	 code = 2;
	else if(!strcmp(savetype, "�޼�", true))	code = 2;
	else if(!strcmp(savetype, "������", true)) code = 2;
	else if(!strcmp(savetype, "���", true))   code = 2;
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
