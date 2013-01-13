/*
 *
 *
 *		PureunBa(서성범)
 *
 *			UserData Core
 *
 *
 *		Coded by PureunBa 2011-2013 @ all right reserved.
 *
 *			< pureunba.tistory.com >
 *
 *
 *		Release:	2013/01/02
 *		Update:		2013/01/14
 *
 *
 */
/*

  < Callbacks >
	pConnectHandler_UserData(playerid)
	pRequestSpawnHandler_UserData(playerid)
	pDeathHandler_UserData(playerid, killerid, reason)
	pSpawnHandler_UserData(playerid)
	dResponseHandler_UserData(playerid, dialogid, response, listitem, inputtext[])
	pTimerTickHandler_UserData(nsec, playerid)
	
  < Functions >
	CreatePlayerDataTable()
	SavePlayerData(playerid)
	LoadPlayerData(playerid)
	ShowPlayerLoginDialog(playerid, bool:wrong)
	LetPlayerSpawn(playerid)

*/



//-----< Includes



//-----< UserData



//-----< Defines
#define DialogId_UserData(%0)      (25+%0)



//-----< Callbacks
forward pConnectHandler_UserData(playerid);
forward pRequestSpawnHandler_UserData(playerid);
forward pDeathHandler_UserData(playerid, killerid, reason);
forward pSpawnHandler_UserData(playerid);
forward pCommandTextHandler_UserData(playerid, cmdtext[]);
forward dResponseHandler_UserData(playerid, dialogid, response, listitem, inputtext[]);
forward pTimerTickHandler_UserData(nsec, playerid);
//-----< pConnectHandler >------------------------------------------------------
public pConnectHandler_UserData(playerid)
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
		ShowPlayerLoginDialog(playerid, false);
	}
	return 1;
}
//-----< pRequestSpawnHandler >-------------------------------------------------
public pRequestSpawnHandler_UserData(playerid)
{
	if (!GetPVarInt_(playerid, "LoggedIn"))
	    ShowPlayerLoginDialog(playerid, false);
	else
		return 1;
	return 0;
}
//-----< pDeathHandler >--------------------------------------------------------
public pDeathHandler_UserData(playerid, killerid, reason)
{
	SetPVarInt_(playerid, "Spawned", false);
	return 1;
}
//-----< pSpawnHandler >--------------------------------------------------------
public pSpawnHandler_UserData(playerid)
{
	SetPVarInt_(playerid, "Spawned", true);
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
public pCommandTextHandler_UserData(playerid, cmdtext[])
{
	new cmd[256], idx,
		str[256];
	cmd = strtok(cmdtext, idx);
	
	if (!GetPVarInt_(playerid, "LoggedIn")) return 0;
	else if (!strcmp(cmd, "/비번변경", true) || !strcmp(cmd, "/암호변경", true))
	{
	    format(str, sizeof(str), "\
		\n\
	    "C_WHITE"새 비밀번호를 입력하세요.\n\
		\n\
		");
		ShowPlayerDialog(playerid, DialogId_UserData(1), DIALOG_STYLE_PASSWORD, ""C_BLUE"비밀번호 변경", str, "확인", "취소");
		return 1;
	}
	return 0;
}
//-----< dResponseHandler >-----------------------------------------------------
public dResponseHandler_UserData(playerid, dialogid, response, listitem, inputtext[])
{
	new str[256];
	switch (dialogid - DialogId_UserData(0))
	{
		case 0:
	        if (!GetPVarInt_(playerid, "Registered"))
			{
				if (strval(inputtext) >= 8)
				{
				    new year, month, day;
				    getdate(year, month, day);
				    format(str, sizeof(str), "%04d%02d%02d", year, month, day);
				    SetPVarInt_(playerid, "pRegDate", strval(str));
				    format(str, sizeof(str), "INSERT INTO userdata (Username,Password,IP) VALUES ('%s',SHA1('%s'),'%s')", GetPlayerNameA(playerid), inputtext, GetPlayerIpA(playerid));
				    mysql_query(str);
				    SavePlayerData(playerid);
				    SetPVarInt_(playerid, "Registered", true);
				    SetPVarInt_(playerid, "LoggedIn", true);
					LetPlayerSpawn(playerid);
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
			        LoadPlayerData(playerid);
			        if (strlen(GetPVarString_(playerid, "pLastPos")) > 10)
			            ShowPlayerDialog(playerid, DialogId_UserData(2), DIALOG_STYLE_LIST, ""C_BLUE"로그인", ""C_WHITE"리스폰\n위치 복구", "선택", chNullString);
			        else
			            LetPlayerSpawn(playerid);
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
				    "C_WHITE"새 비밀번호를 입력하세요.\n\
                    비밀번호는 반드시 8자리 이상이어야 합니다.\n\
					\n\
					");
					ShowPlayerDialog(playerid, DialogId_UserData(1), DIALOG_STYLE_PASSWORD, ""C_BLUE"비밀번호 변경", str, "확인", "취소");
				}
		case 2:
		{
		    if (listitem == 1)
		        SetPVarInt_(playerid, "RestoreSpawn", true);
			LetPlayerSpawn(playerid);
		}
	}
	return 1;
}
//-----< pTimerTickHandler >----------------------------------------------------
public pTimerTickHandler_UserData(nsec, playerid)
{
	if (nsec != 1000) return 1;
	else if(!IsPlayerConnected(playerid)) return 1;
	new Float:pos[4],
	    interior = GetPlayerInterior(playerid),
	    virtualworld = GetPlayerVirtualWorld(playerid),
	    str[64];
	if (GetPVarInt_(playerid, "Spawned") && GetPVarInt_(playerid, "LoggedIn"))
	{
	    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	    GetPlayerFacingAngle(playerid, pos[3]);
	    format(str, sizeof(str), "%.4f,%.4f,%.4f,%.4f,%d,%d", pos[0], pos[1], pos[2], pos[3], interior, virtualworld);
	    SetPVarString_(playerid, "pLastPos", str);
	}
	SavePlayerData(playerid);
	return 1;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----< CreatePlayerDataTable >------------------------------------------------
stock CreatePlayerDataTable()
{
	new str[3840];
	format(str, sizeof(str), "CREATE TABLE IF NOT EXISTS userdata (");
	strcat(str, "ID int(5) NOT NULL auto_increment PRIMARY KEY,");
	strcat(str, "Username varchar(32) NOT NULL default '',");
	strcat(str, "Password varchar(128) NOT NULL  default '',");
	strcat(str, "IP varchar(15) NOT NULL default '0.0.0.0',");
	strcat(str, "RegDate int(8) NOT NULL default '0',");
	strcat(str, "Level int(5) NOT NULL default '0',");
	strcat(str, "Radio int(5) NOT NULL default '0',");
	strcat(str, "Origin varchar(64) NOT NULL  default '',");
	strcat(str, "Money int(10) NOT NULL default '0',");
	strcat(str, "Skin int(3) NOT NULL default '0',");
	strcat(str, "Deaths int(5) NOT NULL default '0',");
	strcat(str, "LastQuit int(1) NOT NULL default '0',");
	strcat(str, "LastPos varchar(64) NOT NULL  default '',");
	strcat(str, "Tutorial int(1) NOT NULL default '0',");
	strcat(str, "Admin int(5) NOT NULL default '0',");
	strcat(str, "Warns int(5) NOT NULL default '0',");
	strcat(str, "Praises int(5) NOT NULL default '0',");
	strcat(str, "Toy1 varchar(256) NOT NULL  default '',");
	strcat(str, "Toy2 varchar(256) NOT NULL  default '',");
	strcat(str, "Toy3 varchar(256) NOT NULL  default '',");
	strcat(str, "Toy4 varchar(256) NOT NULL  default '',");
	strcat(str, "Toy5 varchar(256) NOT NULL  default '',");
	strcat(str, "Banned varchar(256) NOT NULL default '') ");
	strcat(str, "ENGINE = InnoDB CHARACTER SET euckr COLLATE euckr_korean_ci");
	mysql_query(str);
	
	format(str, sizeof(str), "CREATE TABLE IF NOT EXISTS bandata (");
	strcat(str, "ID int(5) NOT NULL auto_increment PRIMARY KEY,");
	strcat(str, "IP varchar(15) NOT NULL default '0.0.0.0',");
	strcat(str, "Username varchar(32) NOT NULL  default '',");
	strcat(str, "Date int(8) NOT NULL default '0',");
	strcat(str, "Time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP) ");
	strcat(str, "ENGINE = InnoDB CHARACTER SET euckr COLLATE euckr_korean_ci");
	mysql_query(str);
	return 1;
}
//-----< SavePlayerData >-------------------------------------------------------
stock SavePlayerData(playerid)
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
	format(str, sizeof(str), "%s WHERE Username='%s'", str, GetPlayerNameA(playerid));
	mysql_query(str);
	return 1;
}
//-----< LoadPlayerData >-------------------------------------------------------
stock LoadPlayerData(playerid)
{
	new str[256],
	    receive[24][256],
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
    "C_YELLOW"Do not trust anyone - Nogov"C_WHITE"에 오신 것을 환영합니다.\n\
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
		ShowPlayerDialog(playerid, DialogId_UserData(0), DIALOG_STYLE_PASSWORD, ""C_BLUE"Login", str, "로그인", chNullString);
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
	    ShowPlayerDialog(playerid, DialogId_UserData(0), DIALOG_STYLE_PASSWORD, ""C_BLUE"Login", str, "가입", chNullString);
	}
	return 1;
}
//-----< LetPlayerSpawn >-------------------------------------------------------
stock LetPlayerSpawn(playerid)
{
    SetSpawnInfo(playerid,16,0, 1675.9365,-2258.1887,13.3709,108.9242, 0,0,0,0,0,0);
	SpawnPlayer(playerid);
	return 1;
}
//-----<  >---------------------------------------------------------------------
