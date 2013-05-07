/*
 *
 *
 *			Nogov BadWord Module
 *		  	2013/05/06
 *
 *
 *		Copyright (c) sBum. All rights reserved.
 *
 *
 */
/*

  < Callbacks >
	gInitHandler_BadWord()
	
  < Functions >
	CreateBadWordDataTable()
	SaveBadWordDataById(id)
	SaveBadWordData()
	LoadBadWordData()
	UnloadBadWordDataById(id)
	UnloadBadWordData()
	InsertBadWord(word[])
	DeleteBadWord(word[])
	FindBadWords(dest[])

*/



//-----< Defines
#define MAX_BADWORDS		100



//-----< Variables
enum eBadWordInfo
{
	bwID,
	bwWord[64]
}
new BadWordInfo[MAX_BADWORDS][eBadWordInfo];



//-----< Callbacks
forward gInitHandler_BadWord();
//-----< gInitHandler >---------------------------------------------------------
public gInitHandler_BadWord()
{
	CreateBadWordDataTable();
	LoadBadWordData();
	return 1;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----< CreateBadWordDataTable >-----------------------------------------------
stock CreateBadWordDataTable()
{
	new str[256];
	
	strcpy(str, "CREATE TABLE IF NOT EXISTS badworddata (");
	strcat(str, "ID int(5) NOT NULL auto_increment PRIMARY KEY");
	strcat(str, ",Word varchar(64) NOT NULL default ' ' UNIQUE");
	strcat(str, ") ENGINE = InnoDB CHARACTER SET euckr COLLATE euckr_korean_ci");
	mysql_query(str);
	
	return 1;
}
//-----< SaveBadWordDataById >--------------------------------------------------
stock SaveBadWordDataById(id)
{
	new str[256];
	format(str, sizeof(str), "UPDATE badworddata SET");
	format(str, sizeof(str), "%s Word='%s'", str, escape(BadWordInfo[id][bwWord]));
	format(str, sizeof(str), "%s WHERE ID=%d", str, BadWordInfo[id][bwID]);
	mysql_query(str);
	return 1;
}
//-----< SaveBadWordData >------------------------------------------------------
stock SaveBadWordData()
{
	for(new i = 0; i < MAX_BADWORDS; i++)
		if(BadWordInfo[i][bwID])
			SaveBadWordDataById(i);
	return 1;
}
//-----< LoadBadWordData >------------------------------------------------------
stock LoadBadWordData()
{
	new count = GetTickCount();
	new str[512],
		receive[2][64],
		idx;
	mysql_query("SELECT * FROM badworddata");
	mysql_store_result();
	for(new i = 0, t = mysql_num_rows(); i < t; i++)
	{
		mysql_fetch_row(str, "|");
		split(str, receive, '|');
		idx = 0;

		BadWordInfo[i][bwID] = strval(receive[idx++]);
		strcpy(BadWordInfo[i][bwWord], receive[idx++]);
	}
	mysql_free_result();
	printf("badworddata 테이블을 불러왔습니다. - %dms", GetTickCount() - count);
	return 1;
}
//-----< UnloadBadWordDataById >------------------------------------------------
stock UnloadBadWordDataById(id)
{
	BadWordInfo[id][bwID] = 0;
	return 1;
}
//-----< UnloadBadWordData >----------------------------------------------------
stock UnloadBadWordData()
{
	for(new i = 0; i < MAX_BADWORDS; i++)
		if(BadWordInfo[i][bwID])
			UnloadBadWordDataById(i);
	return 1;
}
//-----< InsertBadWord >--------------------------------------------------------
stock InsertBadWord(word[])
{
	new str[128];
	format(str, sizeof(str), "INSERT INTO badworddata (Word) VALUES (%s)", word);
	mysql_query(str);
	
	for(new i = 0; i < MAX_BADWORDS; i++)
		if(!BadWordInfo[i][bwID])
		{
			BadWordInfo[i][bwID] = mysql_insert_id();
			strcpy(BadWordInfo[i][bwWord], word);
			break;
		}
	return 1;
}
//-----< DeleteBadWord >--------------------------------------------------------
stock DeleteBadWord(word[])
{
	new str[128];
	for(new i = 0; i < MAX_BADWORDS; i++)
		if(BadWordInfo[i][bwID] && !strcmp(BadWordInfo[i][bwWord], word, true))
		{
			format(str, sizeof(str), "DELETE FROM badworddata WHERE ID=%d", BadWordInfo[i][bwID]);
			mysql_query(str);
			UnloadBadWordDataById(i);
		}
	return 1;
}
//-----< FindBadWords >---------------------------------------------------------
stock FindBadWords(dest[])
{
	new returns[64];
	for(new i = 0; i < MAX_BADWORDS; i++)
		if(BadWordInfo[i][bwID] && strfind(dest, BadWordInfo[i][bwWord], true) != -1)
			returns = BadWordInfo[i][bwWord];
	return returns;
}
//-----<  >---------------------------------------------------------------------
