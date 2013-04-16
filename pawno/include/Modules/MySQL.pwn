/*
 *
 *
 *			Nogov MySQL Module
 *		  	2013/01/08
 *
 *
 *		Copyright (c) sBum. All rights reserved.
 *
 *
 */
/*

  < Callbacks >
	gInitHandler
	OnMysqlError(error[], errorid, MySQL:handle)

  < Functions >

*/



//-----< Defines
#define SQL_IP		  "acu.pe.kr"
#define SQL_ID		  "roto"
#define SQL_PW		  "130414"
#define SQL_DB		  "samp_roto"



//-----< Variables
new MySQL:MySQL_Handle;



//-----< Callbacks
forward gInitHandler_MySQL();
//-----< gInitHandler >---------------------------------------------------------
public gInitHandler_MySQL()
{
	printf("DB ������ �������Դϴ�.");
	MySQL_Handle = mysql_init(LOG_OFF, true);
	if (mysql_connect(SQL_IP, SQL_ID, SQL_PW, SQL_DB, MySQL_Handle))
	{
		printf("DB ������ �����߽��ϴ�.");
		mysql_query("SET NAMES 'euckr'");
	}
	else
	{
		printf("DB ������ ������ �� �����ϴ�.");
		printf("������ �����մϴ�.");
		Wait(3000);
		Crash();
	}
	return 1;
}
public OnMysqlError(error[], errorid, MySQL:handle)
{
	if (errorid == 2006)
	{
		printf("MySQL�� ������ ������ϴ�.");
		printf("������ ������մϴ�.");
		SendRconCommand("gmx");
	}
	return 1;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----<  >---------------------------------------------------------------------
