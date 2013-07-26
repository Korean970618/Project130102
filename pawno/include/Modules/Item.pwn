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
	pEditDynamicObjectHandler_Item(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
	pEditAttachedObjectHandler_Item(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
	pTimerTickHandler_Item(nsec, playerid)

  < Functions >
	CreateItemModelDataTable()
	SaveItemModelDataById(modelid)
	SaveItemModelData()
	LodaItemModelDataById(modelid)
	LoadItemModelData()
	UnloadItemModelDataById(modelid)
	CreateItemModel(name[], model, Float:droppos[6], weight, info[] Float:offset1[3], Float:rot1[3], Float:scale1[3], Float:offset2[3], Float:rot2[3], Float:scale2[3], maxhealth, hand, effect[], effectamount)
	DestroyItemModel(modelid)
	GetItemModelName(modelid)
	GetItemModelDBID(modelid)
	UseItemModel(playerid, modelid, ...)
	ShowItemModelModifier(playerid, modelid=-1)
	ResetItemModelModifier(playerid)
	GetItemModelModifierModel(playerid)
  
	CreateItemDataTable()
	SaveItemDataById(itemid)
	SaveItemData()
	LoadItemData()
	UnloadItemDataById(itemid)
	UnloadItemData()
	CreateItem(itemmodel, Float:x, Float:y, Float:z, Float:a, interiorid, worldid, memo[], health=0, amount=1)
	DestroyItem(itemid)
	CreateItemObject(itemid)
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
	DestroyPlayerItem(playerid, itemid)
	CreatePlayerItemObject(playerid, itemid)
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
	ShowItemModelList(playerid, dialogid, params[]="")
	GetPlayerNearestItem(playerid, Float:distance=1.0)
	GetItemSaveTypeCode(savetype[])
	FindPlayerItemBySaveType(playerid, savetype[])
	
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
	imID,
	imName[32],
	imModel,
	Float:imDropPos[6],
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
enum eItemModelModifierInfo
{
	immModel,
	immOption,
	immObject,
	immHand
}
new ItemModelInfo[100][eItemModelInfo],
	ItemModelModifier[MAX_PLAYERS][eItemModelInfo],
	ItemModelModifierInfo[MAX_PLAYERS][eItemModelModifierInfo];
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
new MaxItemModels,
	WeaponItem[MAX_PLAYERS],
	MacroCheckTime[MAX_PLAYERS],
	MacroCheckText[MAX_PLAYERS][8],
	MacroCheckOwner[MAX_PLAYERS];



//-----< Callbacks
forward gInitHandler_Item();
forward pSpawnHandler_Item(playerid);
forward pConnectHandler_Item(playerid);
forward pUpdateHandler_Item(playerid);
forward pDisconnectHandler_Item(playerid, reason);
forward pKeyStateChangeHandler_Item(playerid, newkeys, oldkeys);
forward pCommandTextHandler_Item(playerid, cmdtext[]);
forward dRequestHandler_Item(playerid, dialogid, olddialogid);
forward dResponseHandler_Item(playerid, dialogid, response, listitem, inputtext[]);
forward pEditDynamicObjectHandler_Item(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz);
forward pEditAttachedObjectHandler_Item(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ);
forward pTimerTickHandler_Item(nsec, playerid);
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
	
	ResetItemModelModifier(playerid);
	
	WeaponItem[playerid] = 0;
	MacroCheckTime[playerid] = 0;
	strcpy(MacroCheckText[playerid], chNullString);
	MacroCheckOwner[playerid] = INVALID_PLAYER_ID;
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
	if(IsPlayerInAnyVehicle(playerid)) return 1;
	if(newkeys == KEY_SECONDARY_ATTACK)
	{
		new itemid = GetPlayerNearestItem(playerid);
		DialogData[playerid][0] = itemid;
		format(cstr, sizeof(cstr), ""C_GREEN"%s %d��"C_WHITE"�� �ֽ��ϴ�.\n�� ���� �ֿ�ðڽ��ϱ�?", ItemModelInfo[GetItemModelID(itemid)][imName], GetItemAmount(itemid));
		ShowPlayerDialog(playerid, DialogId_Item(7), DIALOG_STYLE_INPUT, "����", cstr, "Ȯ��", "���");
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
//-----< dRequestHandler >------------------------------------------------------
public dRequestHandler_Item(playerid, dialogid, olddialogid)
{
	if(olddialogid == DialogId_Item(10) && dialogid == 0) return 0;
	return 1;
}
//-----< dResponseHandler >-----------------------------------------------------
public dResponseHandler_Item(playerid, dialogid, response, listitem, inputtext[])
{
	new str[1024];
	switch(dialogid - DialogId_Item(0))
	{
		case 0:
			if(response)
			{
				if(!listitem) return ShowPlayerItemList(playerid, playerid, DialogId_Item(0), "����");
				new itemid = DialogData[playerid][listitem];
				DialogData[playerid][0] = DialogData[playerid][listitem];
				ShowPlayerDialog(playerid, DialogId_Item(1), DIALOG_STYLE_LIST, ItemModelInfo[GetPlayerItemModelID(playerid, itemid)][imName],
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
						ShowPlayerDialog(playerid, DialogId_Item(2), DIALOG_STYLE_LIST, ItemModelInfo[GetPlayerItemModelID(playerid, itemid)][imName],
							"�޼����� ������.\n���������� ������.\n������� ������.", "����", "�ڷ�");
					}
					case 1:
					{
						new modelid = GetPlayerItemModelID(playerid, itemid),
							result = UseItemModel(playerid, modelid);
						if(!result)
							return ShowPlayerDialog(playerid, DialogId_Item(9), DIALOG_STYLE_MSGBOX, "�˸�", "����� �� ���� �������Դϴ�.", "Ȯ��", chNullString);
						if(!--PlayerItemInfo[playerid][itemid][iAmount])
							DestroyPlayerItem(playerid, itemid);
						SavePlayerItemDataById(playerid, itemid);
						format(cstr, sizeof(cstr), ""C_GREEN"%s"C_WHITE"��(��) ����Ͽ� "C_GREEN"%s %d"C_WHITE"�� ȿ���� �޾ҽ��ϴ�.", ItemModelInfo[modelid][imName], ItemModelInfo[modelid][imEffect], ItemModelInfo[modelid][imEffectAmount]);
						if(result == 1)
							SendClientMessage(playerid, COLOR_WHITE, cstr);
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
							format(str, sizeof(str), ""C_GREEN"%s %d��"C_WHITE"�� �ֽ��ϴ�.\n�� ���� �����ðڽ��ϱ�?", GetItemModelName(GetPlayerItemModelID(playerid, itemid)), GetPlayerItemAmount(playerid, itemid));
							ShowPlayerDialog(playerid, DialogId_Item(8), DIALOG_STYLE_INPUT, "����", str, "Ȯ��", "�ڷ�");
						}
					}
				}
			}
			else ShowPlayerItemList(playerid, playerid, DialogId_Item(0), "����");
		}
		case 2:
		{
			new htext[32],
				itemid = DialogData[playerid][0];
			if(response)
			{
				strcpy(htext, HoldPlayerItem(playerid, itemid, listitem));
				if(!strlen(htext)) return 1;
				format(cstr, sizeof(cstr), ""C_GREEN"%s"C_WHITE"��(��) %s�� ������ϴ�.", ItemModelInfo[GetPlayerItemModelID(playerid, itemid)][imName], htext);
				SendClientMessage(playerid, COLOR_WHITE, cstr);
			}
			else ShowLastDialog(playerid);
		}
		case 3:
			if(response)
			{
				if(!listitem) return ShowPlayerItemList(playerid, playerid, DialogId_Item(3), "��");
				new itemid = DialogData[playerid][listitem];
				DialogData[playerid][0] = DialogData[playerid][listitem];
				ShowPlayerDialog(playerid, DialogId_Item(4), DIALOG_STYLE_LIST, ItemModelInfo[GetPlayerItemModelID(playerid, itemid)][imName],
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
						if(!strcmp(ItemModelInfo[GetPlayerItemModelID(playerid, itemid)][imEffect], "����", true))
							ResetPlayerWeapons(playerid);
						GivePlayerItemToPlayer(playerid, playerid, itemid, "����", 1);
						format(cstr, sizeof(cstr), ""C_GREEN"%s"C_WHITE"��(��) ���濡 �־����ϴ�.", ItemModelInfo[GetPlayerItemModelID(playerid, itemid)][imName]);
						SendClientMessage(playerid, COLOR_WHITE, cstr);
					}
					case 1:
					{
						new modelid = GetPlayerItemModelID(playerid, itemid),
							result = UseItemModel(playerid, modelid);
						if(!result)
							return ShowPlayerDialog(playerid, DialogId_Item(9), DIALOG_STYLE_MSGBOX, "�˸�", "����� �� ���� �������Դϴ�.", "Ȯ��", chNullString);
						if(!--ItemInfo[itemid][iAmount])
							DestroyItem(itemid);
						SaveItemDataById(itemid);
						format(cstr, sizeof(cstr), ""C_GREEN"%s"C_WHITE"��(��) ����Ͽ� "C_GREEN"%s %d"C_WHITE"�� ȿ���� �޾ҽ��ϴ�.", ItemModelInfo[modelid][imName], ItemModelInfo[modelid][imEffect], ItemModelInfo[modelid][imEffectAmount]);
						if(result == 1)
							SendClientMessage(playerid, COLOR_WHITE, cstr);
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
							format(str, sizeof(str), ""C_GREEN"%s %d��"C_WHITE"�� �ֽ��ϴ�.\n�� ���� �����ðڽ��ϱ�?", GetItemModelName(GetPlayerItemModelID(playerid, itemid)), GetPlayerItemAmount(playerid, itemid));
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
				if(GetPlayerItemsWeight(playerid, "����") + ItemModelInfo[GetItemModelID(itemid)][imWeight] > GetPVarInt(playerid, "pWeight"))
				{
					if(GetPlayerItemsWeight(playerid, "����") > ItemModelInfo[GetItemModelID(itemid)][imWeight])
						SendClientMessage(playerid, COLOR_WHITE, "������ �ʹ� ���̽��ϴ�.");
					else
					{
						format(cstr, sizeof(cstr), "%s��(��) �ʹ� ���ſ��� ���濡 ���� �� �����ϴ�.", ItemModelInfo[GetItemModelID(itemid)][imName]);
						SendClientMessage(playerid, COLOR_WHITE, cstr);
					}
				}
				else
					GivePlayerItem(playerid, itemid, "����", strval(inputtext));
			}
		case 8:
			if(response)
			{
				DialogData[playerid][1] = strval(inputtext);
				
				new htext[32],
					itemid = DialogData[playerid][0],
					amount = strval(inputtext);
				if(amount < 1) ReshowDialog(playerid);
				else if(amount < GetPlayerItemAmount(playerid, itemid)) amount = GetPlayerItemAmount(playerid, itemid);
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
				DropPlayerItem(playerid, itemid, amount);
			}
			else ShowLastDialog(playerid);
		case 9: ShowLastDialog(playerid);
		case 10:
			if(response)
			{
				new destid = strval(inputtext);
				strcpy(str, chNullString);
				for(new i = 0; i < 8; i++)
				{
					new num[2];
					format(num, sizeof(num), "%s", random(346-321)+321);
					format(str, sizeof(str), "%s%s", str, num);
				}
				strcpy(MacroCheckText[destid], str);
				MacroCheckOwner[destid] = playerid;
				MacroCheckTime[destid] = 1;
				format(str, sizeof(str), "���� ���ڸ� �״�� �Է��ϼ���. "C_RED"%s", str);
				ShowPlayerDialog(destid, DialogId_Item(11), DIALOG_STYLE_INPUT, "��ũ�� �˻��", str, "Ȯ��", chNullString);
				format(cstr, sizeof(cstr), "%s�Կ��� ��ũ�� �˻�⸦ ����߽��ϴ�.", GetPlayerNameA(destid));
				SendClientMessage(playerid, COLOR_WHITE, cstr);
			}
		case 11:
		{
			if(strcmp(inputtext, MacroCheckText[playerid], true))
			{
				ReshowDialog(playerid);
				return 1;
			}
			format(cstr, sizeof(cstr), "%s�Բ��� ��ũ�� �˻翡 ����߽��ϴ�.", GetPlayerNameA(playerid));
			SendClientMessage(MacroCheckOwner[playerid], COLOR_YELLOW, cstr);
			ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "��ũ�� �˻��", "��ũ�� �˻翡 ����߽��ϴ�.", "Ȯ��", chNullString);
			strcpy(MacroCheckText[playerid], chNullString);
			MacroCheckOwner[playerid] = INVALID_PLAYER_ID;
			MacroCheckTime[playerid] = 0;
		}
		case 12:
			if(response)
			{
				new modelid = ItemModelModifierInfo[playerid][immModel],
					varname[10], value[256],
					idx;
				ItemModelModifierInfo[playerid][immOption] = listitem;
				strcpy(varname, strtok(inputtext, idx));
				if(varname[0] != '>')
				{
					strcpy(value, stringslice_c(inputtext, idx));
					format(str, sizeof(str), ""C_LIGHTGREEN"%s"C_WHITE"�Ӽ��� ���� �Է��ϼ���.\n\n����: "C_LIGHTBLUE"%s", varname, value);
					ShowPlayerDialog(playerid, DialogId_Item(13), DIALOG_STYLE_INPUT, "�����۸� �Ӽ� ����", str, "Ȯ��", "�ڷ�");
				}
				else switch(listitem - 8)
				{
					case 0:
					{
						new Float:x, Float:y, Float:z;
						GetPlayerPos(playerid, x, y, z);
						ItemModelModifierInfo[playerid][immObject] = CreateDynamicObject(ItemModelModifier[playerid][imModel], x, y, z, 0.0, 0.0, 0.0, -1, -1, playerid);
						EditDynamicObject(playerid, ItemModelModifierInfo[playerid][immObject]);
					}
					case 1..2:
					{
						new left[32], both[32],
							lines = 10;
						strcpy(left, FindPlayerItemBySaveType(playerid, "�޼�"));
						strcpy(both, FindPlayerItemBySaveType(playerid, "���"));
						if(strlen(left))
						{
							format(str, sizeof(str), "�޼տ� "C_GREEN"%s"C_WHITE"��(��) �ֽ��ϴ�.", left);
							ShowPlayerDialog(playerid, DialogId_Item(14), DIALOG_STYLE_MSGBOX, "�����۸� �Ӽ� ����", str, "Ȯ��", chNullString);
						}
						else if(strlen(both))
						{
							format(str, sizeof(str), "��տ� "C_GREEN"%s"C_WHITE"��(��) �ֽ��ϴ�.", left);
							ShowPlayerDialog(playerid, DialogId_Item(14), DIALOG_STYLE_MSGBOX, "�����۸� �Ӽ� ����", str, "Ȯ��", chNullString);
						}
						else if(listitem-lines == 1)
							SetPlayerAttachedObject(playerid, 0, ItemModelModifier[playerid][imModel], 5,
								ItemModelModifier[playerid][imOffset1][0],	ItemModelModifier[playerid][imOffset1][1],	ItemModelModifier[playerid][imOffset1][2],
								ItemModelModifier[playerid][imRot1][0],		ItemModelModifier[playerid][imRot1][1],		ItemModelModifier[playerid][imRot1][2],
								ItemModelModifier[playerid][imScale1][0],	ItemModelModifier[playerid][imScale1][1],	ItemModelModifier[playerid][imScale1][2]);
						else
						{
							SetPlayerAttachedObject(playerid, 0, ItemModelModifier[playerid][imModel], 5,
								ItemModelModifier[playerid][imOffset2][0],	ItemModelModifier[playerid][imOffset2][1],	ItemModelModifier[playerid][imOffset2][2],
								ItemModelModifier[playerid][imRot2][0],		ItemModelModifier[playerid][imRot2][1],		ItemModelModifier[playerid][imRot2][2],
								ItemModelModifier[playerid][imScale2][0],	ItemModelModifier[playerid][imScale2][1],	ItemModelModifier[playerid][imScale2][2]);
							SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
						}
						ItemModelModifierInfo[playerid][immHand] = listitem - lines;
						EditAttachedObject(playerid, 0);
					}
					case 3:
					{
						format(str, sizeof(str), "�����۸� "C_GREEN"%s"C_WHITE"��(��) �����մϴ�.\n����Ͻðڽ��ϱ�?", ItemModelInfo[modelid][imName]);
						ShowPlayerDialog(playerid, DialogId_Item(15), DIALOG_STYLE_MSGBOX, "�����۸� �Ӽ� ����", str, "��", "�ƴϿ�");
					}
					case 4:
					{
						if(ItemModelModifierInfo[playerid][immModel] == -1)
						{
							CreateItemModel(ItemModelModifier[playerid][imName], ItemModelModifier[playerid][imModel], ItemModelModifier[playerid][imDropPos], ItemModelModifier[playerid][imWeight], ItemModelModifier[playerid][imInfo],
								ItemModelModifier[playerid][imOffset1], ItemModelModifier[playerid][imRot1], ItemModelModifier[playerid][imScale1], ItemModelModifier[playerid][imOffset2], ItemModelModifier[playerid][imRot2], ItemModelModifier[playerid][imScale2],
								ItemModelModifier[playerid][imMaxHealth], ItemModelModifier[playerid][imHand], ItemModelModifier[playerid][imEffect], ItemModelModifier[playerid][imEffectAmount]);
						}
						else
						{
							strcpy(ItemModelInfo[modelid][imName],		ItemModelModifier[playerid][imName]);
							ItemModelInfo[modelid][imModel]				= ItemModelModifier[playerid][imModel];
							for(new i; i < 6; i++)
								ItemModelInfo[modelid][imDropPos][i]	= ItemModelModifier[playerid][imDropPos][i];
							ItemModelInfo[modelid][imWeight]			= ItemModelModifier[playerid][imWeight];
							strcpy(ItemModelInfo[modelid][imInfo],		ItemModelModifier[playerid][imInfo]);
							for(new i; i < 3; i++)
							{
								ItemModelInfo[modelid][imOffset1][i]	= ItemModelModifier[playerid][imOffset1][i];
								ItemModelInfo[modelid][imRot1][i]		= ItemModelModifier[playerid][imRot1][i];
								ItemModelInfo[modelid][imScale1][i]		= ItemModelModifier[playerid][imScale1][i];
								ItemModelInfo[modelid][imOffset2][i]	= ItemModelModifier[playerid][imOffset2][i];
								ItemModelInfo[modelid][imRot2][i]		= ItemModelModifier[playerid][imRot2][i];
								ItemModelInfo[modelid][imScale2][i]		= ItemModelModifier[playerid][imScale2][i];
							}
							ItemModelInfo[modelid][imMaxHealth]			= ItemModelModifier[playerid][imMaxHealth];
							ItemModelInfo[modelid][imHand]				= ItemModelModifier[playerid][imHand];
							strcpy(ItemModelInfo[modelid][imEffect],	ItemModelModifier[playerid][imEffect]);
							ItemModelInfo[modelid][imEffectAmount]		= ItemModelModifier[playerid][imEffectAmount];
							SaveItemModelDataById(modelid);
						}
						
						ResetItemModelModifier(playerid);
						OnPlayerCommandText(playerid, "/�����۸𵨼Ӽ�����");
					}
				}
			}
		case 13:
		{
			if(response)
			{
				new optionid = ItemModelModifierInfo[playerid][immOption],
					receive[9][16];
				switch(optionid)
				{
					case 0: strcpy(ItemModelModifier[playerid][imName],		inputtext);
					case 1: ItemModelModifier[playerid][imModel]			= strval(inputtext);
					case 2:
					{
						split(inputtext, receive, ',');
						for(new i = 0; i < 6; i++)
							ItemModelModifier[playerid][imDropPos][i]		= floatstr(receive[i]);
					}
					case 3: ItemModelModifier[playerid][imWeight]			= strval(inputtext);
					case 4: strcpy(ItemModelModifier[playerid][imInfo],		chNullString);
					case 5:
					{
						split(inputtext, receive, ',');
						for(new i = 0; i < 3; i++)
							ItemModelModifier[playerid][imOffset1][i]		= floatstr(receive[i]);
						for(new i = 3; i < 6; i++)
							ItemModelModifier[playerid][imRot1][i]			= floatstr(receive[i]);
						for(new i = 6; i < 9; i++)
							ItemModelModifier[playerid][imScale1][i]		= floatstr(receive[i]);
					}
					case 6:
					{
						split(inputtext, receive, ',');
						for(new i = 0; i < 3; i++)
							ItemModelModifier[playerid][imOffset2][i]		= floatstr(receive[i]);
						for(new i = 3; i < 6; i++)
							ItemModelModifier[playerid][imRot2][i]			= floatstr(receive[i]);
						for(new i = 6; i < 9; i++)
							ItemModelModifier[playerid][imScale2][i]		= floatstr(receive[i]);
					}
					case 7: ItemModelModifier[playerid][imMaxHealth]		= 0;
					case 8: ItemModelModifier[playerid][imHand]				= 0;
					case 9: strcpy(ItemModelModifier[playerid][imEffect],	chNullString);
					case 10: ItemModelModifier[playerid][imEffectAmount]		= 0;
				}
				ShowItemModelModifier(playerid);
			}
			else ShowLastDialog(playerid);
		}
		case 14: ShowLastDialog(playerid);
		case 15:
		{
			if(response)
			{
				new modelid = ItemModelModifierInfo[playerid][immModel];
				if(!IsValidItemModelID(modelid))
					return ShowPlayerDialog(playerid, DialogId_Item(16), DIALOG_STYLE_MSGBOX, "�����۸� �Ӽ� ����", "�������� ���� �������Դϴ�.", "Ȯ��", chNullString);
				format(str, sizeof(str), "�����۸� "C_GREEN"%s"C_WHITE"��(��) �����߽��ϴ�.", ItemModelInfo[modelid][imName]);
				ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "�����۸� �Ӽ� ����", str, "Ȯ��", chNullString);
				DestroyItemModel(modelid);
				ResetItemModelModifier(playerid);
			}
			else ShowLastDialog(playerid);
		}
		case 16: ShowItemModelModifier(playerid);
	}
	return 1;
}
//-----< pEditDynamicObjectHandler >--------------------------------------------
public pEditDynamicObjectHandler_Item(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if(response == EDIT_RESPONSE_UPDATE || ItemModelModifierInfo[playerid][immObject] != objectid) return 1;
	else if(response == EDIT_RESPONSE_FINAL)
	{
		new Float:px, Float:py, Float:pz;
		GetPlayerPos(playerid, px, py, pz);
		ItemModelModifier[playerid][imDropPos][0]	= px - x;
		ItemModelModifier[playerid][imDropPos][1]	= py - y;
		ItemModelModifier[playerid][imDropPos][2]	= pz - z;
		ItemModelModifier[playerid][imDropPos][3]	= rx;
		ItemModelModifier[playerid][imDropPos][4]	= ry;
		ItemModelModifier[playerid][imDropPos][5]	= rz;
	}
	ItemModelModifierInfo[playerid][immObject] = INVALID_OBJECT_ID;
	DestroyDynamicObject(objectid);
	ShowItemModelModifier(playerid);
	return 1;
}
//-----< pEditAttachedObjectHandler >-------------------------------------------
public pEditAttachedObjectHandler_Item(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	if(response == EDIT_RESPONSE_UPDATE || !ItemModelModifierInfo[playerid][immHand]) return 1;
	else if(response == EDIT_RESPONSE_FINAL)
		switch(ItemModelModifierInfo[playerid][immHand])
		{
			case 1:
			{
				ItemModelModifier[playerid][imOffset1][0]	= fOffsetX;
				ItemModelModifier[playerid][imOffset1][1]	= fOffsetY;
				ItemModelModifier[playerid][imOffset1][2]	= fOffsetZ;
				ItemModelModifier[playerid][imRot1][0]		= fRotX;
				ItemModelModifier[playerid][imRot1][1]		= fRotY;
				ItemModelModifier[playerid][imRot1][2]		= fRotZ;
				ItemModelModifier[playerid][imScale1][0]	= fScaleX;
				ItemModelModifier[playerid][imScale1][1]	= fScaleY;
				ItemModelModifier[playerid][imScale1][2]	= fScaleZ;
			}
			case 2:
			{
				ItemModelModifier[playerid][imOffset2][0]	= fOffsetX;
				ItemModelModifier[playerid][imOffset2][1]	= fOffsetY;
				ItemModelModifier[playerid][imOffset2][2]	= fOffsetZ;
				ItemModelModifier[playerid][imRot2][0]		= fRotX;
				ItemModelModifier[playerid][imRot2][1]		= fRotY;
				ItemModelModifier[playerid][imRot2][2]		= fRotZ;
				ItemModelModifier[playerid][imScale2][0]	= fScaleX;
				ItemModelModifier[playerid][imScale2][1]	= fScaleY;
				ItemModelModifier[playerid][imScale2][2]	= fScaleZ;
			}
		}
	ItemModelModifierInfo[playerid][immHand] = 0;
	RemovePlayerAttachedObject(playerid, 0);
	ShowItemModelModifier(playerid);
	return 1;
}
//-----< pTimerTickHandler >----------------------------------------------------
public pTimerTickHandler_Item(nsec, playerid)
{
	if(nsec != 1000) return 0;
	
	if(MacroCheckTime[playerid])
	{
		MacroCheckTime[playerid]++;
		if(MacroCheckTime[playerid] == 0)
		{
			GivePlayerMoney(playerid, -GetGVarInt("��ũ�ΰ˻纸��"));
			format(cstr, sizeof(cstr), "��ũ�� �˻�⿡ ���� ��ũ�η� Ž���Ǿ� $%d�� �Ҿ����ϴ�.", GetGVarInt("��ũ�ΰ˻纸��"));
			SendClientMessage(playerid, COLOR_YELLOW, cstr);
			GivePlayerMoney(MacroCheckOwner[playerid], GetGVarInt("��ũ�ΰ˻纸��"));
			format(cstr, sizeof(cstr), "��ũ�� ����ڸ� ��� �������� $%d�� �޾ҽ��ϴ�.", GetGVarInt("��ũ�ΰ˻纸��"));
			SendClientMessage(MacroCheckOwner[playerid], COLOR_YELLOW, cstr);
			MacroCheckOwner[playerid] = INVALID_PLAYER_ID;
			Kick(playerid);
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
	strcat(str, ",DropPos varchar(256) NOT NULL default '0.0'");
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
	format(str, sizeof(str), "%s,DropPos='%.4f,%.4f,%.4f,%.4f,%.4f,%.4f'", str,
		ItemModelInfo[modelid][imDropPos][0], ItemModelInfo[modelid][imDropPos][1], ItemModelInfo[modelid][imDropPos][2],
		ItemModelInfo[modelid][imDropPos][3], ItemModelInfo[modelid][imDropPos][4], ItemModelInfo[modelid][imDropPos][5]);
	format(str, sizeof(str), "%s,Weight=%d", str, ItemModelInfo[modelid][imWeight]);
	format(str, sizeof(str), "%s,Info='%s'", str, escape(ItemModelInfo[modelid][imInfo]));
	format(str, sizeof(str), "%s,Position1='%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f'", str,
		ItemModelInfo[modelid][imOffset1][0], ItemModelInfo[modelid][imRot1][0], ItemModelInfo[modelid][imScale1][0],
		ItemModelInfo[modelid][imOffset1][1], ItemModelInfo[modelid][imRot1][1], ItemModelInfo[modelid][imScale1][1],
		ItemModelInfo[modelid][imOffset1][2], ItemModelInfo[modelid][imRot1][2], ItemModelInfo[modelid][imScale1][2]);
	format(str, sizeof(str), "%s,Position2='%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f'", str,
		ItemModelInfo[modelid][imOffset2][0], ItemModelInfo[modelid][imRot2][0], ItemModelInfo[modelid][imScale2][0],
		ItemModelInfo[modelid][imOffset2][1], ItemModelInfo[modelid][imRot2][1], ItemModelInfo[modelid][imScale2][1],
		ItemModelInfo[modelid][imOffset2][2], ItemModelInfo[modelid][imRot2][2], ItemModelInfo[modelid][imScale2][2]);
	format(str, sizeof(str), "%s,MaxHealth=%d", str, ItemModelInfo[modelid][imMaxHealth]);
	format(str, sizeof(str), "%s,Hand=%d", str, ItemModelInfo[modelid][imHand]);
	format(str, sizeof(str), "%s,Effect='%s'", str, escape(ItemModelInfo[modelid][imEffect]));
	format(str, sizeof(str), "%s,EffectAmount=%d", str, ItemModelInfo[modelid][imEffectAmount]);
	format(str, sizeof(str), "%s WHERE ID=%d", str, ItemModelInfo[modelid][imID]);
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
//-----< LoadItemModelDataById >------------------------------------------------
stock LoadItemModelDataById(modelid)
{
	new str[2048],
		receive[12][256],
		idx,
		splited[9][32];
	format(str, sizeof(str), "SELECT * FROM itemmodeldata");
	if(modelid != -1)
		format(str, sizeof(str), "%s WHERE ID=%d", str, modelid);
	mysql_query(str);
	mysql_store_result();
	for(new i = MaxItemModels, t = mysql_num_rows(); i < t; i++)
	{
		mysql_fetch_row(str, "|");
		split(str, receive, '|');
		idx = 0;
		
		MaxItemModels = i+1;
		
		ItemModelInfo[i][imID] = strval(receive[idx++]);
		strcpy(ItemModelInfo[i][imName], receive[idx++]);
		ItemModelInfo[i][imModel] = strval(receive[idx++]);
		
		split(receive[idx++], splited, ',');
		for(new j = 0; j < 6; j++)
			ItemModelInfo[i][imDropPos][j] = floatstr(splited[j]);
		
		ItemModelInfo[i][imWeight] = strval(receive[idx++]);
		strcpy(ItemModelInfo[i][imInfo], receive[idx++]);

		split(receive[idx++], splited, ',');
		for(new j = 0; j < 3; j++)
		{
			ItemModelInfo[i][imOffset1][j] = floatstr(splited[(j*3)]);
			ItemModelInfo[i][imRot1][j] = floatstr(splited[(j*3)+1]);
			ItemModelInfo[i][imScale1][j] = floatstr(splited[(j*3)+2]);
		}

		split(receive[idx++], splited, ',');
		for(new j = 0; j < 3; j++)
		{
			ItemModelInfo[i][imOffset2][j] = floatstr(splited[(j*3)]);
			ItemModelInfo[i][imRot2][j] = floatstr(splited[(j*3)+1]);
			ItemModelInfo[i][imScale2][j] = floatstr(splited[(j*3)+2]);
		}
		
		ItemModelInfo[i][imMaxHealth] = strval(receive[idx++]);
		ItemModelInfo[i][imHand] = strval(receive[idx++]);
		strcpy(ItemModelInfo[i][imEffect], receive[idx++]);
		ItemModelInfo[i][imEffectAmount] = strval(receive[idx++]);
	}
	mysql_free_result();
	return 1;
}
//-----< LoadItemModelData >----------------------------------------------------
stock LoadItemModelData()
{
	new count = GetTickCount();
	LoadItemModelDataById(-1);
	printf("itemmodeldata ���̺��� �ҷ��Խ��ϴ�. - %dms", GetTickCount() - count);
}
//-----< UnloadItemModelDataById >----------------------------------------------
stock UnloadItemModelDataById(modelid)
{
	ItemModelInfo[modelid][imID] = 0;
	if(MaxItemModels-1 == modelid)
	{
		new counter;
		for(new i = 0; i < sizeof(ItemModelInfo); i++)
			if(IsValidItemModelID(i) && counter < i)
				counter = i;
		MaxItemModels = counter+1;
	}
	strcpy(ItemModelInfo[modelid][imName], chNullString);
	ItemModelInfo[modelid][imModel] = 0;
	for(new i = 0; i < 6; i++)
		ItemModelInfo[modelid][imDropPos][i] = 0.0;
	ItemModelInfo[modelid][imWeight] = 0;
	strcpy(ItemModelInfo[modelid][imInfo], chNullString);
	for(new i = 0; i < 3; i++)
	{
		ItemModelInfo[modelid][imOffset1][i]	= 0.0;
		ItemModelInfo[modelid][imRot1][i]		= 0.0;
		ItemModelInfo[modelid][imScale1][i]		= 1.0;
		ItemModelInfo[modelid][imOffset2][i]	= 0.0;
		ItemModelInfo[modelid][imRot2][i]		= 0.0;
		ItemModelInfo[modelid][imScale2][i]		= 1.0;
	}
	ItemModelInfo[modelid][imMaxHealth] = 0;
	ItemModelInfo[modelid][imHand] = 0;
	strcpy(ItemModelInfo[modelid][imEffect], chNullString);
	ItemModelInfo[modelid][imEffectAmount] = 0;
	return 1;
}
//-----< CreateItemModel >------------------------------------------------------
/*	imID,
	imName[32],
	imModel,
	Float:imDropPos[6],
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
	imEffectAmount*/
stock CreateItemModel(name[], model, Float:droppos[], weight, info[], Float:offset1[], Float:rot1[], Float:scale1[], Float:offset2[], Float:rot2[], Float:scale2[], maxhealth, hand, effect[], effectamount)
{
	new str[2][1024], query[2048];
	
	strcpy(str[0], "INSERT INTO itemmodeldata (");
	format(str[1], 1024, "VALUES (");
	strcat(str[0], " Name");
	format(str[1], 1024, "%s '%s'", str, escape(name));
	strcat(str[0], ",Model");
	format(str[1], 1024, "%s,%d", str, model);
	strcat(str[0], ",DropPos");
	format(str[1], 1024, "%s,'%.4f,%.4f,%.4f,%.4f,%.4f,%.4f'", str, droppos[0], droppos[1], droppos[2], droppos[3], droppos[4], droppos[5]);
	strcat(str[0], ",Weight");
	format(str[1], 1024, "%s,%d", str, weight);
	strcat(str[0], ",Info");
	format(str[1], 1024, "%s,'%s'", str, escape(info));
	strcat(str[0], ",Position1");
	format(str[1], 1024, "%s,'%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f'", str, offset1[0], offset1[1], offset1[2], rot1[0], rot1[1], rot1[2], scale1[0], scale1[1], scale1[2]);
	strcat(str[0], ",Position2");
	format(str[1], 1024, "%s,'%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f'", str, offset2[0], offset2[1], offset2[2], rot2[0], rot2[1], rot2[2], scale2[0], scale2[1], scale2[2]);
	strcat(str[0], ",MaxHealth");
	format(str[1], 1024, "%s,%d", str, maxhealth);
	strcat(str[0], ",Hand");
	format(str[1], 1024, "%s,%d", str, hand);
	strcat(str[0], ",Effect");
	format(str[1], 1024, "%s,'%s'", str, effect);
	strcat(str[0], ",EffectAmount");
	format(str[1], 1024, "%s,%d", str, effectamount);
	
	format(query, sizeof(query), "%s) %s)", str[0], str[1]);
	mysql_query(query);
	
	LoadItemModelDataById(mysql_insert_id());
	return 1;
}
//-----< DestroyItemModel >-----------------------------------------------------
stock DestroyItemModel(modelid)
{
	new str[128];
	format(str, sizeof(str), "DELETE FROM itemmodeldata WHERE ID=%d", ItemModelInfo[modelid][imID]);
	mysql_query(str);
	UnloadItemModelDataById(modelid);
}
//-----< GetItemModelName >-----------------------------------------------------
stock GetItemModelName(modelid)
{
	new str[32];
	strcpy(str, ItemModelInfo[modelid][imName]);
	return str;
}
//-----< GetItemModelDBID >-----------------------------------------------------
stock GetItemModelDBID(modelid)
{
	return ItemModelInfo[modelid][imID];
}
//-----< UseItemModel >---------------------------------------------------------
stock UseItemModel(playerid, modelid, ...)
{
	new Effect[32],
		amount = ItemModelInfo[modelid][imEffectAmount],
		str[1024];
	strcpy(Effect, ItemModelInfo[modelid][imEffect]);
	
	if(!strcmp(Effect, "ġ��", true))
		SetPlayerHealth(playerid, GetPlayerHealthA(playerid) + amount);
	else if(!strcmp(Effect, "���", true))
		SetPVarInt(playerid, "pHunger", GetPVarInt(playerid, "pHunger")+1);
	else if(!strcmp(Effect, "��ũ�ΰ˻��", true))
	{
		new Float:x, Float:y, Float:z, vw = GetPlayerVirtualWorld(playerid), players;
		GetPlayerPos(playerid, x, y, z);

		strcpy(str, C_LIGHTGREEN);
		strtab(str, "ID", 3);
		strtab(str, "Name", MAX_PLAYER_NAME);
		strtab(str, "Score", 5);
		strcat(str, "Ping");
		strcat(str, C_WHITE);
		for(new i = 0, t = GetMaxPlayers(); i < t; i++)
			if(IsPlayerConnected(i)
			&& IsPlayerInRangeOfPoint(i, 30.0, x, y, z)
			&& GetPlayerVirtualWorld(i) == vw)
			{
				strcat(str, "\n");
				strtab(str, valstr_(i), 3);
				strtab(str, GetPlayerNameA(i), MAX_PLAYER_NAME);
				strtab(str, valstr_(GetPlayerScore(playerid)), 5);
				strcat(str, valstr_(GetPlayerPing(playerid)));
				players++;
			}
		if(!players) ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "�˸�", "��ó�� �ٸ� �÷��̾ �����ϴ�.", "Ȯ��", chNullString);
		else ShowPlayerDialog(playerid, DialogId_Item(10), DIALOG_STYLE_LIST, "��ũ�� �˻��", str, "���", "���");
		return 2;
	}
	else if(!strcmp(Effect, "����", true))
	{
		switch(ItemModelInfo[modelid][imHand])
		{
			case 0: return 0;
			case 1: SendClientMessage(playerid, COLOR_WHITE, "������ ���, ������ ���콺�� ���ء����� ���콺�� �߻��� �� �ֽ��ϴ�.");
			case 2: SendClientMessage(playerid, COLOR_WHITE, "�޼����� ���, ������ ���콺�� ���ء����� ���콺�� �߻��� �� �ֽ��ϴ�.");
			case 3: SendClientMessage(playerid, COLOR_WHITE, "���������� ���, ������ ���콺�� ���ء����� ���콺�� �߻��� �� �ֽ��ϴ�.");
			case 4: SendClientMessage(playerid, COLOR_WHITE, "������� ���, ������ ���콺�� ���ء����� ���콺�� �߻��� �� �ֽ��ϴ�.");
		}
	}
	else return 0;
	return 1;
}
//-----< ShowItemModelModifier >------------------------------------------------
stock ShowItemModelModifier(playerid, modelid=-1)
{
	new str[1024],
		tabsize = 8;
	if(ItemModelModifierInfo[playerid][immModel] != modelid)
	{
		ItemModelModifierInfo[playerid][immModel]		= modelid;
		strcpy(ItemModelModifier[playerid][imName],		ItemModelInfo[modelid][imName]);
		ItemModelModifier[playerid][imModel]			= ItemModelInfo[modelid][imModel];
		ItemModelModifier[playerid][imWeight]			= ItemModelInfo[modelid][imWeight];
		strcpy(ItemModelModifier[playerid][imInfo],		ItemModelInfo[modelid][imInfo]);
		ItemModelModifier[playerid][imMaxHealth]		= ItemModelInfo[modelid][imMaxHealth];
		ItemModelModifier[playerid][imHand]				= ItemModelInfo[modelid][imHand];
		strcpy(ItemModelModifier[playerid][imEffect],	ItemModelInfo[modelid][imEffect]);
		ItemModelModifier[playerid][imEffectAmount]		= ItemModelInfo[modelid][imEffectAmount];
	}
	
	if(ItemModelModifierInfo[playerid][immObject] != INVALID_OBJECT_ID)
	{
		CancelEdit(playerid);
		DestroyDynamicObject(ItemModelModifierInfo[playerid][immObject]);
		ItemModelModifierInfo[playerid][immObject] = INVALID_OBJECT_ID;
	}
	if(ItemModelModifierInfo[playerid][immHand])
	{
		CancelEdit(playerid);
		RemovePlayerAttachedObject(playerid, 0);
		ItemModelModifierInfo[playerid][immHand] = 0;
	}
	
	strcpy(str, C_LIGHTGREEN);
	strtab(str, "�̸�", tabsize);
	strcat(str, " "C_WHITE);
	strcat(str, ItemModelModifier[playerid][imName]);
	strcat(str, "\n"C_LIGHTGREEN);
	strtab(str, "�𵨹�ȣ", tabsize);
	strcat(str, " "C_WHITE);
	strcat(str, valstr_(ItemModelModifier[playerid][imModel]));
	strcat(str, "\n"C_LIGHTGREEN);
	strtab(str, "�����ǥ", tabsize);
	strcat(str, " "C_WHITE);
	format(str, sizeof(str), "%.4f,%.4f,%.4f,%.4f,%.4f,%.4f",
		ItemModelModifier[playerid][imDropPos][0], ItemModelModifier[playerid][imDropPos][1], ItemModelModifier[playerid][imDropPos][2],
		ItemModelModifier[playerid][imDropPos][3], ItemModelModifier[playerid][imDropPos][4], ItemModelModifier[playerid][imDropPos][5]);
	strcat(str, "\n"C_LIGHTGREEN);
	strtab(str, "����", tabsize);
	strcat(str, " "C_WHITE);
	strcat(str, valstr_(ItemModelModifier[playerid][imWeight]));
	strcat(str, "\n"C_LIGHTGREEN);
	strtab(str, "����", tabsize);
	strcat(str, " "C_WHITE);
	strcat(str, ItemModelModifier[playerid][imInfo]);
	strcat(str, "\n"C_LIGHTGREEN);
	strtab(str, "�Ѽպ���", tabsize);
	strcat(str, " "C_WHITE);
	format(str, sizeof(str), "%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f",
		ItemModelModifier[playerid][imOffset1][0], 	ItemModelModifier[playerid][imOffset1][1],	ItemModelModifier[playerid][imOffset1][2],
		ItemModelModifier[playerid][imRot1][0],		ItemModelModifier[playerid][imRot1][1],		ItemModelModifier[playerid][imRot1][2],
		ItemModelModifier[playerid][imScale1][0],	ItemModelModifier[playerid][imScale1][1],	ItemModelModifier[playerid][imScale1][2]);
	strcat(str, "\n"C_LIGHTGREEN);
	strtab(str, "��պ���", tabsize);
	strcat(str, " "C_WHITE);
	format(str, sizeof(str), "%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f",
		ItemModelModifier[playerid][imOffset2][0], 	ItemModelModifier[playerid][imOffset2][1],	ItemModelModifier[playerid][imOffset2][2],
		ItemModelModifier[playerid][imRot2][0],		ItemModelModifier[playerid][imRot2][1],		ItemModelModifier[playerid][imRot2][2],
		ItemModelModifier[playerid][imScale2][0],	ItemModelModifier[playerid][imScale2][1],	ItemModelModifier[playerid][imScale2][2]);
	strcat(str, "\n"C_LIGHTGREEN);
	strtab(str, "�ִ�ü��", tabsize);
	strcat(str, " "C_WHITE);
	strcat(str, valstr_(ItemModelModifier[playerid][imMaxHealth]));
	strcat(str, "\n"C_LIGHTGREEN);
	strtab(str, "������", tabsize);
	strcat(str, " "C_WHITE);
	strcat(str, valstr_(ItemModelModifier[playerid][imHand]));
	strcat(str, "\n"C_LIGHTGREEN);
	strtab(str, "ȿ��", tabsize);
	strcat(str, " "C_WHITE);
	strcat(str, ItemModelModifier[playerid][imEffect]);
	strcat(str, "\n"C_LIGHTGREEN);
	strtab(str, "ȿ����", tabsize);
	strcat(str, " "C_WHITE);
	strcat(str, valstr_(ItemModelModifier[playerid][imEffectAmount]));
	strcat(str, C_YELLOW);
	strcat(str, "\n> �����ǥ ����");
	strcat(str, "\n> �Ѽ� ������ǥ ����");
	strcat(str, "\n> ��� ������ǥ ����");
	strcat(str, "\n> ����");
	strcat(str, "\n> ����");
	
	ItemModelModifier[playerid][imID] = 1;
	ShowPlayerDialog(playerid, DialogId_Item(12), DIALOG_STYLE_LIST, "�����۸� �Ӽ� ����", str, "Ȯ��", "�ڷ�");
	return 1;
}
//-----< ResetItemModelModifier >-----------------------------------------------
stock ResetItemModelModifier(playerid)
{
	ItemModelModifier[playerid][imID]				= 0;
	strcpy(ItemModelModifier[playerid][imName],		chNullString);
	ItemModelModifier[playerid][imModel]			= 0;
	for(new i; i < 6; i++)
		ItemModelModifier[playerid][imDropPos][i]	= 0.0;
	ItemModelModifier[playerid][imWeight]			= 0;
	strcpy(ItemModelModifier[playerid][imInfo],		chNullString);
	for(new i; i < 3; i++)
	{
		ItemModelModifier[playerid][imOffset1][i]	= 0.0;
		ItemModelModifier[playerid][imRot1][i]		= 0.0;
		ItemModelModifier[playerid][imScale1][i]	= 1.0;
		ItemModelModifier[playerid][imOffset2][i]	= 0.0;
		ItemModelModifier[playerid][imRot2][i]		= 0.0;
		ItemModelModifier[playerid][imScale2][i]	= 1.0;
	}
	ItemModelModifier[playerid][imMaxHealth]		= 0;
	ItemModelModifier[playerid][imHand]				= 0;
	strcpy(ItemModelModifier[playerid][imEffect],	chNullString);
	ItemModelModifier[playerid][imEffectAmount]		= 0;
	
	ItemModelModifierInfo[playerid][immModel]		= -2;
	ItemModelModifierInfo[playerid][immOption]		= 0;
	ItemModelModifierInfo[playerid][immObject]		= INVALID_OBJECT_ID;
	ItemModelModifierInfo[playerid][immHand]		= 0;
	
	return 1;
}
//-----< GetItemModelModifierModel >--------------------------------------------
stock GetItemModelModifierModel(playerid)
	return ItemModelModifierInfo[playerid][immModel];
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

		CreateItemObject(i);
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
stock CreateItem(itemmodel, Float:x, Float:y, Float:z, Float:a, interiorid, worldid, memo[], health=1, amount=1)
{
	health = (health == 0) ? ItemModelInfo[itemmodel][imMaxHealth] : health;
	mysql_query("INSERT INTO itemdata () VALUES ()");
	for(new i = 0, t = GetMaxItems(); i < t; i++)
		if(!IsValidItemID(i))
		{
			ItemInfo[i][iID] = mysql_insert_id();
			ItemInfo[i][iItemmodel] = itemmodel;
			ItemInfo[i][iPos][0] = x;
			ItemInfo[i][iPos][1] = y;
			ItemInfo[i][iPos][2] = z;
			ItemInfo[i][iPos][3] = a;
			ItemInfo[i][iInterior] = interiorid;
			ItemInfo[i][iVirtualWorld] = worldid;
			strcpy(ItemInfo[i][iMemo], memo);
			ItemInfo[i][iHealth] = health;
			ItemInfo[i][iAmount] = amount;
			SaveItemDataById(i);
			CreateItemObject(i);
			return 1;
		}
	return 0;
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
//-----< CreateItemObject >-----------------------------------------------------
stock CreateItemObject(itemid)
{
	new modelid = GetItemModelID(itemid);
	new Float:z = ItemInfo[itemid][iPos][2] + ItemModelInfo[modelid][imDropPos][2];
	ItemInfo[itemid][iObject] = CreateDynamicObject(ItemModelInfo[modelid][imModel],
		ItemInfo[itemid][iPos][0], ItemInfo[itemid][iPos][1], z, 0.0, 0.0, ItemInfo[itemid][iPos][3],
		ItemInfo[itemid][iVirtualWorld], ItemInfo[itemid][iInterior]);
	ItemInfo[itemid][i3DText] = CreateDynamic3DTextLabel(ItemModelInfo[modelid][imName], COLOR_WHITE,
		ItemInfo[itemid][iPos][0], ItemInfo[itemid][iPos][1], z, 3.0,
		INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0,
		ItemInfo[itemid][iVirtualWorld], ItemInfo[itemid][iInterior]);
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
	for(new i = 0, t = GetMaxItemModels(); i < t; i++)
		if(ItemInfo[itemid][iItemmodel] == ItemModelInfo[i][imID])
			return i;
	return -1;
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
		
		CreatePlayerItemObject(playerid, i);
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
stock CreatePlayerItem(playerid, itemmodel, savetype[], memo[], health=1, amount=1)
{
	health = (health == 0) ? ItemModelInfo[itemmodel][imMaxHealth] : health;
	mysql_query("INSERT INTO playeritemdata () VALUES ()");
	for(new i = 0, t = GetMaxPlayerItems(); i < t; i++)
		if(!IsValidPlayerItemID(playerid, i))
		{
			PlayerItemInfo[playerid][i][iID] = mysql_insert_id();
			PlayerItemInfo[playerid][i][iItemmodel] = itemmodel;
			strcpy(PlayerItemInfo[playerid][i][iOwnername], GetPlayerNameA(playerid));
			strcpy(PlayerItemInfo[playerid][i][iSaveType], savetype);
			strcpy(PlayerItemInfo[playerid][i][iMemo], memo);
			PlayerItemInfo[playerid][i][iVirtualItem] = GetPVarInt(playerid, "pAgentMode");
			PlayerItemInfo[playerid][i][iHealth] = health;
			PlayerItemInfo[playerid][i][iAmount] = amount;
			SavePlayerItemDataById(playerid, i);
			CreatePlayerItemObject(playerid, i);
			return 1;
		}
	return 0;
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
//-----< CreatePlayerItemObject >-----------------------------------------------
stock CreatePlayerItemObject(playerid, itemid)
{
	new modelid = GetPlayerItemModelID(playerid, itemid);
	if(!strcmp(PlayerItemInfo[playerid][itemid][iSaveType], "�޼�", true))
		SetPlayerAttachedObject(playerid, 0, ItemModelInfo[modelid][imModel], 5,
			ItemModelInfo[modelid][imOffset1][0], ItemModelInfo[modelid][imOffset1][1], ItemModelInfo[modelid][imOffset1][2],
			ItemModelInfo[modelid][imRot1][0], ItemModelInfo[modelid][imRot1][1], ItemModelInfo[modelid][imRot1][2],
			ItemModelInfo[modelid][imScale1][0], ItemModelInfo[modelid][imScale1][1], ItemModelInfo[modelid][imScale1][2]);
	else if(!strcmp(PlayerItemInfo[playerid][itemid][iSaveType], "������", true))
		SetPlayerAttachedObject(playerid, 1, ItemModelInfo[modelid][imModel], 6,
			ItemModelInfo[modelid][imOffset1][0], ItemModelInfo[modelid][imOffset1][1], ItemModelInfo[modelid][imOffset1][2],
			ItemModelInfo[modelid][imRot1][0], ItemModelInfo[modelid][imRot1][1], ItemModelInfo[modelid][imRot1][2],
			ItemModelInfo[modelid][imScale1][0], ItemModelInfo[modelid][imScale1][1], ItemModelInfo[modelid][imScale1][2]);
	else if(!strcmp(PlayerItemInfo[playerid][itemid][iSaveType], "���", true))
	{
		SetPlayerAttachedObject(playerid, 0, ItemModelInfo[modelid][imModel], 5,
			ItemModelInfo[modelid][imOffset2][0], ItemModelInfo[modelid][imOffset2][1], ItemModelInfo[modelid][imOffset2][2],
			ItemModelInfo[modelid][imRot2][0], ItemModelInfo[modelid][imRot2][1], ItemModelInfo[modelid][imRot2][2],
			ItemModelInfo[modelid][imScale2][0], ItemModelInfo[modelid][imScale2][1], ItemModelInfo[modelid][imScale2][2]);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
	}
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
stock GetPlayerItemModelID(playerid, itemid)
{
	for(new i = 0, t = GetMaxItemModels(); i < t; i++)
		if(PlayerItemInfo[playerid][itemid][iItemmodel] == ItemModelInfo[i][imID])
			return i;
	return -1;
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
	new exists;
	if(!IsValidItemID(itemid)) return 0;
	
	if(ItemInfo[itemid][iAmount] < amount) amount = ItemInfo[itemid][iAmount];
	format(cstr, sizeof(cstr), ""C_GREEN"%s %d��"C_WHITE"�� %s�� �־����ϴ�.", ItemModelInfo[GetItemModelID(itemid)][imName], amount, savetype);
	SendClientMessage(playerid, COLOR_WHITE, cstr);
	for(new i = 0; i < MAX_PLAYERITEMS; i++)
		if(PlayerItemInfo[playerid][i][iItemmodel] == ItemInfo[itemid][iItemmodel]
		&& !strcmp(PlayerItemInfo[playerid][i][iMemo], ItemInfo[itemid][iMemo], true)
		&& GetItemSaveTypeCode(PlayerItemInfo[playerid][i][iSaveType]) == GetItemSaveTypeCode(savetype)
		&& PlayerItemInfo[playerid][i][iHealth] == ItemInfo[itemid][iHealth])
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
	new exists;
	if(!IsValidPlayerItemID(playerid, itemid)) return 0;
	
	new modelid = GetPlayerItemModelID(playerid, itemid);
	if(PlayerItemInfo[playerid][itemid][iAmount] < amount) amount = PlayerItemInfo[playerid][itemid][iAmount];
	format(cstr, sizeof(cstr), "%s�Կ��� "C_GREEN"%s %d��"C_WHITE"�� ��Ƚ��ϴ�.", GetPlayerNameA(destid), ItemModelInfo[modelid][imName], amount);
	SendClientMessage(playerid, COLOR_WHITE, cstr);
	format(cstr, sizeof(cstr), "%s�����κ��� "C_GREEN"%s %d��"C_WHITE"�� �޾� %s�� �־����ϴ�.", GetPlayerNameA(playerid), ItemModelInfo[modelid][imName], amount, savetype);
	SendClientMessage(destid, COLOR_WHITE, cstr);
	for(new i = 0; i < MAX_PLAYERITEMS; i++)
		if(PlayerItemInfo[destid][i][iItemmodel] == PlayerItemInfo[playerid][itemid][iItemmodel]
		&& !strcmp(PlayerItemInfo[destid][i][iMemo], PlayerItemInfo[playerid][itemid][iMemo], true)
		&& GetItemSaveTypeCode(PlayerItemInfo[destid][i][iSaveType]) == GetItemSaveTypeCode(savetype)
		&& PlayerItemInfo[destid][i][iHealth] == PlayerItemInfo[playerid][itemid][iHealth])
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
	if(!IsValidPlayerItemID(playerid, itemid)) return 0;
	
	new modelid = GetPlayerItemModelID(playerid, itemid);
	if(PlayerItemInfo[playerid][itemid][iAmount] < amount) amount = PlayerItemInfo[playerid][itemid][iAmount];
	format(cstr, sizeof(cstr), ""C_GREEN"%s %d��"C_WHITE"��(��) ���Ƚ��ϴ�.", ItemModelInfo[modelid][imName], amount);
	SendClientMessage(playerid, COLOR_WHITE, cstr);
	if(PlayerItemInfo[playerid][itemid][iAmount] <= amount)
		DestroyPlayerItem(playerid, itemid);
	else
	{
		new Float:x, Float:y, Float:z, Float:a;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
		CreateItem(modelid, x, y, z, a,
			GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), PlayerItemInfo[playerid][itemid][iMemo], PlayerItemInfo[playerid][itemid][iHealth], amount);
		PlayerItemInfo[playerid][itemid][iAmount] -= amount;
		SavePlayerItemDataById(playerid, itemid);
	}
	return 1;
}
//-----< HoldPlayerItem >-------------------------------------------------------
stock HoldPlayerItem(playerid, itemid, handid)
{
	new both[32], left[32], right[32], htext[32], blank[32],
		modelid = GetPlayerItemModelID(playerid, itemid),
		items = GetPlayerItemsWeight(playerid, "�޼�") + GetPlayerItemsWeight(playerid, "������") + (GetPlayerItemsWeight(playerid, "���") / 2),
		weight = ItemModelInfo[modelid][imWeight],
		weapon = GetPlayerWeapon(playerid);
	strcpy(both, FindPlayerItemBySaveType(playerid, "���"));
	strcpy(left, FindPlayerItemBySaveType(playerid, "�޼�"));
	strcpy(right, FindPlayerItemBySaveType(playerid, "������"));
	if(strlen(both))
	{
		format(cstr, sizeof(cstr), "��տ� "C_GREEN"%s"C_WHITE"��(��) �ֽ��ϴ�.", both);
		SendClientMessage(playerid, COLOR_WHITE, cstr);
		return blank;
	}
	else if(strlen(left) && (handid == 0 || handid == 2))
	{
		format(cstr, sizeof(cstr), "�޼տ� "C_GREEN"%s"C_WHITE"��(��) �ֽ��ϴ�.", left);
		SendClientMessage(playerid, COLOR_WHITE, cstr);
		return blank;
	}
	else if(strlen(right) && (handid == 1 || handid == 2))
	{
		format(cstr, sizeof(cstr), "�����տ� "C_GREEN"%s"C_WHITE"��(��) �ֽ��ϴ�.", right);
		SendClientMessage(playerid, COLOR_WHITE, cstr);
		return blank;
	}
	else if((IsPlayerAttachedObjectSlotUsed(playerid, 0) && (handid == 0 || handid == 2))
	|| (IsPlayerAttachedObjectSlotUsed(playerid, 1) && handid == 1))
	{
		SendClientMessage(playerid, COLOR_WHITE, "�տ� ���𰡰� ��� �ֽ��ϴ�.");
		return blank;
	}
	weight = (handid == 2) ? (ItemModelInfo[modelid][imWeight] / 2) : ItemModelInfo[modelid][imWeight];
	if(items + weight > GetPVarInt(playerid, "pHealth"))
	{
		if(items > weight)
			SendClientMessage(playerid, COLOR_WHITE, "���� �ʹ� ���̽��ϴ�.");
		else
		{
			format(cstr, sizeof(cstr), "%s��(��) �ʹ� ���ſ��� �� �� �����ϴ�.", ItemModelInfo[modelid][imName]);
			SendClientMessage(playerid, COLOR_WHITE, cstr);
		}
		return blank;
	}
	switch(handid)
	{
		case 0:
		{
			strcpy(htext, "�޼�");
			if(ItemModelInfo[modelid][imHand] != 1 && ItemModelInfo[modelid][imHand] != 2)
			{
				format(cstr, sizeof(cstr), "%s�� %s���� �� �� �����ϴ�.", ItemModelInfo[modelid][imName], htext);
				SendClientMessage(playerid, COLOR_WHITE, cstr);
				return blank;
			}
		}
		case 1:
		{
			strcpy(htext, "������");
			if(ItemModelInfo[modelid][imHand] != 1 && ItemModelInfo[modelid][imHand] != 3)
			{
				format(cstr, sizeof(cstr), "%s�� %s���� �� �� �����ϴ�.", ItemModelInfo[modelid][imName], htext);
				SendClientMessage(playerid, COLOR_WHITE, cstr);
				return blank;
			}
		}
		case 2:
		{
			strcpy(htext, "���");
			if(ItemModelInfo[modelid][imHand] != 1 && ItemModelInfo[modelid][imHand] != 4)
			{
				format(cstr, sizeof(cstr), "%s�� %s���� �� �� �����ϴ�.", ItemModelInfo[modelid][imName], htext);
				SendClientMessage(playerid, COLOR_WHITE, cstr);
				return blank;
			}
		}
	}
	if(weapon) ResetPlayerWeapons(playerid);
	if(!strcmp(ItemModelInfo[modelid][imEffect], "����", true))
		GivePlayerWeapon(playerid, ItemModelInfo[modelid][imEffectAmount], PlayerItemInfo[playerid][itemid][iAmount]);
	else
		CreatePlayerItemObject(playerid, itemid);
	strcpy(PlayerItemInfo[playerid][itemid][iSaveType], htext);
	SavePlayerItemDataById(playerid, itemid);
	return htext;
}
//-----< GetPlayerItemsWeight >-------------------------------------------------
stock GetPlayerItemsWeight(playerid, savetype[]="All")
{
	new returns;
	for(new i = 0, t = GetMaxPlayerItems(); i < t; i++)
		if(IsValidPlayerItemID(playerid, i) && (GetItemSaveTypeCode(PlayerItemInfo[playerid][i][iSaveType]) == GetItemSaveTypeCode(savetype) || !strcmp(savetype, "All", true)))
			returns += ItemModelInfo[GetPlayerItemModelID(playerid, i)][imWeight];
	return returns;
}
//-----< ShowPlayerItemList >---------------------------------------------------
stock ShowPlayerItemList(playerid, destid, dialogid, savetype[]="All")
{
	new str[2048], tmp[16], idx = 1;
	strcpy(str, C_LIGHTGREEN);
	strtab(str, "��ȣ", 5);
	strtab(str, "�̸�", 16);
	strtab(str, "����", 5);
	strcat(str, "����");
	strcat(str, C_WHITE);
	for(new i = 0, t = GetMaxPlayerItems(); i < t; i++)
		if(IsValidPlayerItemID(destid, i)
		&&(GetItemSaveTypeCode(savetype) == GetItemSaveTypeCode(PlayerItemInfo[destid][i][iSaveType])
		|| !strcmp(savetype, "All", true)))
		{
			new modelid = GetPlayerItemModelID(destid, i);
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
		modelid = GetPlayerItemModelID(playerid, itemid);
	strcpy(str, C_LIGHTGREEN);
	strtab(str, "�̸�", 5);
	strcat(str, C_WHITE);
	strcat(str, ItemModelInfo[modelid][imName]);
	strcat(str, "\n");
	strcat(str, C_LIGHTGREEN);
	strtab(str, "����", 5);
	strcat(str, C_WHITE);
	format(str, sizeof(str), "%s%d", str, ItemModelInfo[modelid][imWeight]);
	strcat(str, "\n");
	strcat(str, C_LIGHTGREEN);
	strtab(str, "ȿ��", 5);
	strcat(str, C_WHITE);
	format(str, sizeof(str), "%s%s(%d)", str, ItemModelInfo[modelid][imEffect], ItemModelInfo[modelid][imEffectAmount]);
	strcat(str, "\n");
	strcat(str, C_LIGHTGREEN);
	strtab(str, "����", 5);
	strcat(str, C_WHITE);
	strcat(str, ItemModelInfo[modelid][imInfo]);
	ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, "������ ����", str, "Ȯ��", "�ڷ�");
	return 1;
}
//-----< ShowItemModelList >----------------------------------------------------
stock ShowItemModelList(playerid, dialogid, params[]="")
{
	new str[2048], tmp[16];
	strcpy(str, C_LIGHTGREEN);
	strtab(str, "��ȣ", 5);
	strtab(str, "�̸�", 16);
	strtab(str, "����", 5);
	strcat(str, "ȿ��");
	strcat(str, C_WHITE);
	for(new i = 0; i < sizeof(ItemModelInfo); i++)
		if(strlen(ItemModelInfo[i][imName]))
		{
			strcat(str, "\n");
			format(tmp, sizeof(tmp), "%04d", i);
			strtab(str, tmp, 5);
			strtab(str, ItemModelInfo[i][imName], 16);
			format(tmp, sizeof(tmp), "%d", ItemModelInfo[i][imWeight]);
			strtab(str, tmp, 5);
			if(strlen(ItemModelInfo[i][imEffect]))
				format(tmp, sizeof(tmp), "%s(%d)", ItemModelInfo[i][imEffect], ItemModelInfo[i][imEffectAmount]);
			else
				strcpy(tmp, "����");
			strcat(str, tmp);
		}
	if(strlen(params))
	{
		strcat(str, "\n");
		strcat(str, params);
	}
	ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, "�����۸� ���", str, "Ȯ��", "�ڷ�");
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
	else if(!strcmp(savetype, "����", true))	code = 1;
	else if(!strcmp(savetype, "��", true))		code = 2;
	else if(!strcmp(savetype, "�޼�", true))	code = 2;
	else if(!strcmp(savetype, "������", true))	code = 2;
	else if(!strcmp(savetype, "���", true))	code = 2;
	return code;
}
//-----< FindPlayerItemBySaveType >---------------------------------------------
stock FindPlayerItemBySaveType(playerid, savetype[])
{
	new text[32];
	for(new i = 0, t = GetMaxPlayerItems(); i < t; i++)
		if(IsValidPlayerItemID(playerid, i) && !strcmp(PlayerItemInfo[playerid][i][iSaveType], savetype, true))
		{
			strcpy(text, ItemModelInfo[i][imName]);
			break;
		}
	return text;
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
