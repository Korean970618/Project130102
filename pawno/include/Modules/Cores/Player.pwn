/*
 *
 *
 *		PureunBa(서성범)
 *
 *			Player Core
 *
 *
 *		Coded by PureunBa 2011-2013 @ all right reserved.
 *
 *			< pureunba.tistory.com >
 *
 *
 *		Release:	2013/01/02
 *		Update:		2013/02/06
 *
 *
 */
/*

  < Callbacks >
	gInitHandler_Player(playerid)
	pConnectHandler_Player(playerid)
	pRequestClassHandler_Player(playerid, classid)
	pRequestSpawnHandler_Player(playerid)
	pUpdateHandler_Player(playerid)
	pDeathHandler_Player(playerid, killerid, reason)
	pSpawnHandler_Player(playerid)
	dResponseHandler_Player(playerid, dialogid, response, listitem, inputtext[])
	pTimerTickHandler_Player(nsec, playerid)
	pTakeDamageHandler_Player(playerid, issuerid, Float:amount, weaponid)
	
  < Functions >
	CreateUserDataTable()
	SaveUserData(playerid)
	LoadUserData(playerid)
	ShowPlayerLoginDialog(playerid, bool:wrong)
	SpawnPlayer_(playerid)

*/



//-----< Includes



//-----< Variables
new ItemPickingTime[MAX_PLAYERS],
	Float:ItemPickingPos[MAX_PLAYERS][3];



//-----< Defines
#define DialogId_Player(%0)			(25+%0)
#define INTRO_MUSIC					"cfile9.uf.tistory.com/original/135DD247510CA50F37CEE8"



//-----< Callbacks
forward gInitHandler_Player();
forward pConnectHandler_Player(playerid);
forward pRequestClassHandler_Player(playerid, classid);
forward pRequestSpawnHandler_Player(playerid);
forward pUpdateHandler_Player(playerid);
forward pDeathHandler_Player(playerid, killerid, reason);
forward pSpawnHandler_Player(playerid);
forward pCommandTextHandler_Player(playerid, cmdtext[]);
forward dResponseHandler_Player(playerid, dialogid, response, listitem, inputtext[]);
forward pTimerTickHandler_Player(nsec, playerid);
forward pTakeDamageHandler_Player(playerid, issuerid, Float:amount, weaponid);
//-----< gInitHandler >---------------------------------------------------------
public gInitHandler_Player()
{
	CreateUserDataTable();
	return 1;
}
//-----< pConnectHandler >------------------------------------------------------
public pConnectHandler_Player(playerid)
{
	new str[256];
	for (new i; i < 20; i++)
		SendClientMessage(playerid, COLOR_WHITE, chEmpty);
	if (!GetPVarInt_(playerid, "LoggedIn"))
	{
		format(str, sizeof(str), "SELECT Password From userdata WHERE Username='%s'", GetPlayerNameA(playerid));
		mysql_query(str);
		mysql_store_result();
		if (mysql_num_rows() > 0)
		{
			SetPVarInt_(playerid, "Registered", true);
		}
	}
	return 1;
}
//-----< pRequestClassHandler >-------------------------------------------------
public pRequestClassHandler_Player(playerid, classid)
{
	if (!GetPVarInt_(playerid, "LoggedIn"))
	{
		PlayAudioStreamForPlayer(playerid, "http://"INTRO_MUSIC);
		SetPlayerTime(playerid, 0, 0);
		SetPlayerPos(playerid, -2955.9641, 1280.6005, 0.0);
		SetPlayerCameraPos(playerid, -2955.9641, 1280.6005, 30.3001);
		SetPlayerCameraLookAt(playerid, -2862.5815, 1182.5625, 9.6069);
		ShowPlayerLoginDialog(playerid, false);
	}
	return 1;
}
//-----< pRequestSpawnHandler >-------------------------------------------------
public pRequestSpawnHandler_Player(playerid)
{
	if (!GetPVarInt_(playerid, "LoggedIn"))
		ShowPlayerLoginDialog(playerid, false);
	else
		return 1;
	return 0;
}
//-----< pUpdateHandler >-------------------------------------------------------
public pUpdateHandler_Player(playerid)
{
	new Float:x, Float:y, Float:z,
		keys, ud, lr;
	if (IsPlayerInAnyVehicle(playerid)) return 1;
	GetPlayerVelocity(playerid, x, y, z);
	GetPlayerKeys(playerid, keys, ud, lr);
	new Float:bag = (float(GetPlayerItemsWeight(playerid, "가방")) / float(GetPVarInt_(playerid, "pWeight"))) * 100;
	new Float:hand = (float(GetPlayerItemsWeight(playerid, "손")) / float(GetPVarInt_(playerid, "pPower"))) * 100;
	if (bag > 75.0 || hand > 100.0)
	{
		if (z > 0.0)
		{
			SetPlayerVelocity(playerid, 0.0, 0.0, -z);
		}
		else if (ud != 0 || lr != 0)
		{
			if (bag > 75.0)
			{
				x -= (x / 100) * bag;
				y -= (y / 100) * bag;
			}
			if (hand > 100.0)
			{
				x -= hand / 100;
				y -= hand / 100;
			}
			x = (x < 0.0) ? 0.0 : x;
			y = (y < 0.0) ? 0.0 : y;
			SetPlayerVelocity(playerid, x, y, z);
		}
	}
	return 1;
}
//-----< pDeathHandler >--------------------------------------------------------
public pDeathHandler_Player(playerid, killerid, reason)
{
	SetPVarInt_(playerid, "Spawned", false);
	return 1;
}
//-----< pSpawnHandler >--------------------------------------------------------
public pSpawnHandler_Player(playerid)
{
	SetPVarInt_(playerid, "Spawned", true);
	StopAudioStreamForPlayer(playerid);
	SetPlayerSkin(playerid, GetPVarInt_(playerid, "pSkin"));
	SetPlayerTeam(playerid, 0);
	ItemPickingTime[playerid] = GetPVarInt_(playerid, "pPower") * 10;
	if (GetPVarInt_(playerid, "RestoreSpawn"))
	{
		new receive[6][16];
		split(GetPVarString_(playerid, "pLastPos"), receive, ',');
		SetPlayerPos(playerid, floatstr(receive[0]), floatstr(receive[1]), floatstr(receive[2]));
		SetPlayerFacingAngle(playerid, floatstr(receive[3]));
		SetPlayerInterior(playerid, strval(receive[4]));
		SetPlayerVirtualWorld(playerid, strval(receive[5]));
		SetPVarInt_(playerid, "RestoreSpawn", false);
	}
	return 1;
}
//-----< pCommandTextHandler >--------------------------------------------------
public pCommandTextHandler_Player(playerid, cmdtext[])
{
	new cmd[256], idx,
		str[256];
	cmd = strtok(cmdtext, idx);
	
	if (!GetPVarInt_(playerid, "LoggedIn")) return 0;
	else if (!strcmp(cmd, "/비번변경", true) || !strcmp(cmd, "/암호변경", true))
	{
		format(str, sizeof(str), "\
		\n\
		새 비밀번호를 입력하세요.\n\
		\n\
		");
		ShowPlayerDialog(playerid, DialogId_Player(1), DIALOG_STYLE_PASSWORD, "비밀번호 변경", str, "확인", "취소");
		return 1;
	}
	return 0;
}
//-----< dResponseHandler >-----------------------------------------------------
public dResponseHandler_Player(playerid, dialogid, response, listitem, inputtext[])
{
	new str[256];
	switch (dialogid - DialogId_Player(0))
	{
		case 0:
			if (!GetPVarInt_(playerid, "Registered"))
			{
				if (strlen(inputtext) >= 8)
				{
					new year, month, day;
					getdate(year, month, day);
					format(str, sizeof(str), "%04d%02d%02d", year, month, day);
					SetPVarInt_(playerid, "pRegDate", strval(str));
					format(str, sizeof(str), "INSERT INTO userdata (Username,Password,IP) VALUES ('%s',SHA1('%s'),'%s')", GetPlayerNameA(playerid), inputtext, GetPlayerIpA(playerid));
					mysql_query(str);
					SetPVarInt_(playerid, "Registered", true);
					ShowPlayerLoginDialog(playerid, false);
				}
				else
					ShowPlayerLoginDialog(playerid, true);
			}
			else if (!GetPVarInt_(playerid, "LoggedIn"))
			{
				format(str, sizeof(str), "SELECT ID FROM userdata WHERE Username='%s' AND Password=SHA1('%s')", GetPlayerNameA(playerid), inputtext);
				mysql_query(str);
				mysql_store_result();
				if (mysql_num_rows() == 1)
				{
					SetPVarInt_(playerid, "LoggedIn", true);
					LoadUserData(playerid);
					if (strlen(GetPVarString_(playerid, "pLastPos")) > 10)
						ShowPlayerDialog(playerid, DialogId_Player(2), DIALOG_STYLE_LIST, "로그인", "리스폰\n위치 복구", "선택", chNullString);
					else
						SpawnPlayer_(playerid);
				}
				else
					ShowPlayerLoginDialog(playerid, true);
			}
		case 1:
			if (response)
				if (strlen(inputtext) >= 8)
				{
					format(str, sizeof(str), "UPDATE userdata SET Password=SHA1('%s') WHERE Username='%s'", inputtext, GetPlayerNameA(playerid));
					mysql_query(str);
					SendClientMessage(playerid, COLOR_LIGHTBLUE, "비밀번호가 성공적으로 변경되었습니다.");
				}
				else
				{
					format(str, sizeof(str), "\
					\n\
					새 비밀번호를 입력하세요.\n\
					비밀번호는 반드시 8자리 이상이어야 합니다.\n\
					\n\
					");
					ShowPlayerDialog(playerid, DialogId_Player(1), DIALOG_STYLE_PASSWORD, "비밀번호 변경", str, "확인", "취소");
				}
		case 2:
		{
			if (listitem == 1)
				SetPVarInt_(playerid, "RestoreSpawn", true);
			SpawnPlayer_(playerid);
		}
	}
	return 1;
}
//-----< pTimerTickHandler >----------------------------------------------------
public pTimerTickHandler_Player(nsec, playerid)
{
	if(!IsPlayerConnected(playerid)) return 1;

	else if (nsec == 100)
	{
		new items = GetPlayerItemsWeight(playerid, "왼손") + GetPlayerItemsWeight(playerid, "오른손") + (GetPlayerItemsWeight(playerid, "양손") / 2),
			Float:pos[3];
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

		if (ItemPickingTime[playerid] < GetPVarInt_(playerid, "pPower") * 10
		&& pos[0] == ItemPickingPos[playerid][0] && pos[1] == ItemPickingPos[playerid][1] && pos[2] == ItemPickingPos[playerid][2]
		&& (GetPlayerAnimationIndex(playerid) == 1274 || GetPlayerAnimationIndex(playerid) == 1159))
		{
			ItemPickingTime[playerid] += GetPVarInt_(playerid, "pPower");
			if (ItemPickingTime[playerid] > GetPVarInt_(playerid, "pPower") * 10)
				ItemPickingTime[playerid] = GetPVarInt_(playerid, "pPower") * 10;
		}
		else if (items)
		{
			ItemPickingTime[playerid] -= (GetPVarInt_(playerid, "pPower") / items) * 2;
			if (!ItemPickingTime[playerid])
			{
				SetPlayerVelocity(playerid, 0.0, 0.0, 0.0);
			}
		}
		
		if (ItemPickingTime[playerid] < GetPVarInt_(playerid, "pPower") * 10)
		{
		}
	}

	else if (nsec == 1000)
	{
		new Float:pos[4],
			interior = GetPlayerInterior(playerid),
			virtualworld = GetPlayerVirtualWorld(playerid),
			str[64];
		GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

		if (GetPVarInt_(playerid, "Spawned") && GetPVarInt_(playerid, "LoggedIn"))
		{
			GetPlayerFacingAngle(playerid, pos[3]);
			format(str, sizeof(str), "%.4f,%.4f,%.4f,%.4f,%d,%d", pos[0], pos[1], pos[2], pos[3], interior, virtualworld);
			SetPVarString_(playerid, "pLastPos", str);
		}
	}
	
	SaveUserData(playerid);
	return 1;
}
//-----< pTakeDamageHandler >---------------------------------------------------
public pTakeDamageHandler_Player(playerid, issuerid, Float:amount, weaponid)
{
	new Float:damage = amount;
	if (weaponid == 0)
	{
		damage = (amount / 50) * GetPVarInt_(issuerid, "pPower");
	}
	GivePlayerDamage(playerid, damage);
	return 1;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----< CreateUserDataTable >--------------------------------------------------
stock CreateUserDataTable()
{
	new str[3840];
	format(str, sizeof(str), "CREATE TABLE IF NOT EXISTS userdata (");
	strcat(str, "ID int(5) NOT NULL auto_increment PRIMARY KEY");
	strcat(str, ",Username varchar(32) NOT NULL default ''");
	strcat(str, ",Password varchar(128) NOT NULL  default ''");
	strcat(str, ",IP varchar(15) NOT NULL default '0.0.0.0'");
	strcat(str, ",RegDate int(8) NOT NULL default '0'");
	strcat(str, ",Level int(5) NOT NULL default '0'");
	strcat(str, ",Radio int(5) NOT NULL default '0'");
	strcat(str, ",Origin varchar(64) NOT NULL  default ''");
	strcat(str, ",Money int(10) NOT NULL default '0'");
	strcat(str, ",Skin int(3) NOT NULL default '29'");
	strcat(str, ",Deaths int(5) NOT NULL default '0'");
	strcat(str, ",LastQuit int(1) NOT NULL default '0'");
	strcat(str, ",LastPos varchar(64) NOT NULL  default ''");
	strcat(str, ",Tutorial int(1) NOT NULL default '0'");
	strcat(str, ",Admin int(5) NOT NULL default '0'");
	strcat(str, ",Warns int(5) NOT NULL default '0'");
	strcat(str, ",Praises int(5) NOT NULL default '0'");
	strcat(str, ",Toy1 varchar(256) NOT NULL  default ''");
	strcat(str, ",Toy2 varchar(256) NOT NULL  default ''");
	strcat(str, ",Toy3 varchar(256) NOT NULL  default ''");
	strcat(str, ",Toy4 varchar(256) NOT NULL  default ''");
	strcat(str, ",Toy5 varchar(256) NOT NULL  default ''");
	strcat(str, ",Banned varchar(256) NOT NULL default ''");
	strcat(str, ",Weight int(3) NOT NULL default '50'");
	strcat(str, ",Power int(3) NOT NULL default '20'");
	strcat(str, ") ENGINE = InnoDB CHARACTER SET euckr COLLATE euckr_korean_ci");
	mysql_query(str);
	
	format(str, sizeof(str), "CREATE TABLE IF NOT EXISTS bandata (");
	strcat(str, "ID int(5) NOT NULL auto_increment PRIMARY KEY");
	strcat(str, ",IP varchar(15) NOT NULL default '0.0.0.0'");
	strcat(str, ",Username varchar(32) NOT NULL  default ''");
	strcat(str, ",Date int(8) NOT NULL default '0'");
	strcat(str, ",Time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP) ");
	strcat(str, "ENGINE = InnoDB CHARACTER SET euckr COLLATE euckr_korean_ci");
	mysql_query(str);
	return 1;
}
//-----< SaveUserData >---------------------------------------------------------
stock SaveUserData(playerid)
{
	new str[3840];
	if (IsPlayerNPC(playerid)) return 1;
	if (!GetPVarInt_(playerid, "LoggedIn")) return 1;

	format(str, sizeof(str), "UPDATE userdata SET");
	format(str, sizeof(str), "%s IP='%s'", str, GetPlayerIpA(playerid));
	format(str, sizeof(str), "%s,RegDate=%d", str, GetPVarInt_(playerid, "pRegDate"));
	format(str, sizeof(str), "%s,Level=%d", str, GetPVarInt_(playerid, "pLevel"));
	format(str, sizeof(str), "%s,Radio=%d", str, GetPVarInt_(playerid, "pRadio"));
	format(str, sizeof(str), "%s,Origin='%s'", str, escape(GetPVarString_(playerid, "pOrigin")));
	format(str, sizeof(str), "%s,Money=%d", str, GetPVarInt_(playerid, "pMoney"));
	format(str, sizeof(str), "%s,Skin=%d", str, GetPVarInt_(playerid, "pSkin"));
	format(str, sizeof(str), "%s,Deaths=%d", str, GetPVarInt_(playerid, "pDeaths"));
	format(str, sizeof(str), "%s,LastQuit=%d", str, GetPVarInt_(playerid, "pLastQuit"));
	format(str, sizeof(str), "%s,LastPos='%s'", str, GetPVarString_(playerid, "pLastPos"));
	format(str, sizeof(str), "%s,Tutorial=%d", str, GetPVarInt_(playerid, "pTutorial"));
	format(str, sizeof(str), "%s,Admin=%d", str, GetPVarInt_(playerid, "pAdmin"));
	format(str, sizeof(str), "%s,Warns=%d", str, GetPVarInt_(playerid, "pWarns"));
	format(str, sizeof(str), "%s,Praises=%d", str, GetPVarInt_(playerid, "pPraises"));
	format(str, sizeof(str), "%s,Toy1='%s'", str, GetPVarString_(playerid, "pToy1"));
	format(str, sizeof(str), "%s,Toy2='%s'", str, GetPVarString_(playerid, "pToy2"));
	format(str, sizeof(str), "%s,Toy3='%s'", str, GetPVarString_(playerid, "pToy3"));
	format(str, sizeof(str), "%s,Toy4='%s'", str, GetPVarString_(playerid, "pToy4"));
	format(str, sizeof(str), "%s,Toy5='%s'", str, GetPVarString_(playerid, "pToy5"));
	format(str, sizeof(str), "%s,Banned='%s'", str, GetPVarString_(playerid, "pBanned"));
	format(str, sizeof(str), "%s,Weight=%d", str, GetPVarInt_(playerid, "pWeight"));
	format(str, sizeof(str), "%s,Power=%d", str, GetPVarInt_(playerid, "pPower"));
	format(str, sizeof(str), "%s WHERE Username='%s'", str, GetPlayerNameA(playerid));
	mysql_query(str);
	return 1;
}
//-----< LoadUserData >---------------------------------------------------------
stock LoadUserData(playerid)
{
	new str[256],
		receive[26][256],
		idx;
	if (IsPlayerNPC(playerid)) return 1;
	if (!GetPVarInt_(playerid, "LoggedIn")) return 1;
	
	format(str, sizeof(str), "SELECT * FROM userdata WHERE Username='%s'", GetPlayerNameA(playerid));
	mysql_query(str);
	mysql_store_result();
	mysql_fetch_row(str, "|");
	split(str, receive, '|');
	
	SetPVarInt_(playerid, "pID", strval(receive[idx++]));
	SetPVarString_(playerid, "pName", receive[idx++]);
	SetPVarString_(playerid, "pPassword", receive[idx++]);
	SetPVarString_(playerid, "pIP", receive[idx++]);
	SetPVarInt_(playerid, "pRegDate", strval(receive[idx++]));
	SetPVarInt_(playerid, "pLevel", strval(receive[idx++]));
	SetPVarInt_(playerid, "pRadio", strval(receive[idx++]));
	SetPVarString_(playerid, "pOrigin", receive[idx++]);
	SetPVarInt_(playerid, "pMoney", strval(receive[idx++]));
	SetPVarInt_(playerid, "pSkin", strval(receive[idx++]));
	SetPVarInt_(playerid, "pDeaths", strval(receive[idx++]));
	SetPVarInt_(playerid, "pLastQuit", strval(receive[idx++]));
	SetPVarString_(playerid, "pLastPos", receive[idx++]);
	SetPVarInt_(playerid, "pTutorial", strval(receive[idx++]));
	SetPVarInt_(playerid, "pAdmin", strval(receive[idx++]));
	SetPVarInt_(playerid, "pWarns", strval(receive[idx++]));
	SetPVarInt_(playerid, "pPraises", strval(receive[idx++]));
	SetPVarString_(playerid, "pToy1", receive[idx++]);
	SetPVarString_(playerid, "pToy2", receive[idx++]);
	SetPVarString_(playerid, "pToy3", receive[idx++]);
	SetPVarString_(playerid, "pToy4", receive[idx++]);
	SetPVarString_(playerid, "pToy5", receive[idx++]);
	SetPVarString_(playerid, "pBanned", receive[idx++]);
	SetPVarInt_(playerid, "pWeight", strval(receive[idx++]));
	SetPVarInt_(playerid, "pPower", strval(receive[idx++]));
	
	if (!GetPVarInt_(playerid, "pRegDate"))
	{
		new year, month, day;
		getdate(year, month, day);
		format(str, sizeof(str), "%04d%02d%02d", year, month, day);
		SetPVarInt_(playerid, "pRegDate", strval(str));
	}
	return 1;
}
//-----< ShowPlayerLoginDialog >------------------------------------------------
stock ShowPlayerLoginDialog(playerid, bool:wrong)
{
	new str[512];
	format(str, sizeof(str), "\
	\n\
	"C_LIGHTBLUE"%s님, 안녕하세요!\n\
	"C_YELLOW"Nogov"C_WHITE"에 오신 것을 환영합니다.\n\
	", GetPlayerNameA(playerid));
	if (GetPVarInt_(playerid, "Registered"))
	{
		if (wrong)
			strcat(str, "\
			\n\
			비밀번호가 옳바르지 않습니다.\n\
			다시 확인해 주세요!\n\
			\n\
			");
		else
			strcat(str, "\
			\n\
			가입되어 있는 닉네임입니다.\n\
			비밀번호를 입력하여 로그인하세요.\n\
			\n\
			");
		ShowPlayerDialog(playerid, DialogId_Player(0), DIALOG_STYLE_PASSWORD, "Login", str, "로그인", chNullString);
	}
	else
	{
		if (wrong)
			strcat(str, "\
			\n\
			비밀번호를 8자리 이상 입력하세요.\n\
			\n\
			");
		else
			strcat(str, "\
			\n\
			가입되어 있지 않은 닉네임입니다.\n\
			비밀번호를 입력하여 가입하세요.\n\
			\n\
			");
		ShowPlayerDialog(playerid, DialogId_Player(0), DIALOG_STYLE_PASSWORD, "Login", str, "가입", chNullString);
	}
	return 1;
}
//-----< SpawnPlayer_ >---------------------------------------------------------
stock SpawnPlayer_(playerid)
{
	SetSpawnInfo(playerid, 0, GetPVarInt_(playerid, "pSkin"), -1422.2572, -289.8291, 14.1484, 270.0, 0, 0, 0, 0, 0, 0);
	SpawnPlayer(playerid);
	return 1;
}
//-----<  >---------------------------------------------------------------------
