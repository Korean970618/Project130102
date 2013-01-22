/*
 *
 *
 *		PureunBa(������)
 *
 *			MySQL Core
 *
 *
 *		Coded by PureunBa 2011-2013 @ all right reserved.
 *
 *			< pureunba.tistory.com >
 *
 *
 *		Release:	2013/01/08
 *		Update:		2013/01/22
 *
 *
 */
/*

  < Callbacks >
	gInitHandler
	OnMysqlError(error[], errorid, MySQL:handle)

  < Functions >

*/



//-----< Variables
new MySQL:MySQL_Handle;



//-----< Defines
#define SQL_IP          "pureunba.no-ip.org"
#define SQL_ID          "samp_nogov"
#define SQL_PW          "nogov2013"
#define SQL_DB          "samp_nogov"



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
