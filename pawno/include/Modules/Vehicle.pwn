/*
 *
 *
 *			Nogov Vehicle Module
 *		  	2013/01/17
 *
 *
 *		Copyright (c) sBum. All rights reserved.
 *
 *
 */
/*

  < Callbacks >
	
  < Functions >

*/



//-----< Defines



//-----< Variables
enum eVehicleInfo
{
	vID,
	vVID,
	vOwnername[MAX_PLAYER_NAME],
	vModel,
	Float:vPos[4],
	vInterior,
	vVirtualWorld,
	vColor1,
	vColor2,
	vPaintjob,
	vMemo[128],
	
	bool:vLocked,
	bool:vEngine
}
new VehicleInfo[MAX_VEHICLES][eVehicleInfo];



//-----< Callbacks
forward gInitHandler_Vehicle();
//-----< gInitHandler >---------------------------------------------------------
public gInitHandler_Vehicle()
{
	CreateVehicleDataTable();
	LoadVehicleData();
	return 1;
}



//-----< Functions
//-----< CreateVehicleDataTable >-----------------------------------------------
stock CreateVehicleDataTable()
{
	new str[1024];
	strcpy(str, "CREATE TABLE IF NOT EXISTS vehicledata (");
	strcat(str, "ID int(5) NOT NULL auto_increment PRIMARY KEY,");
	strcat(str, "Ownername varchar(32) NOT NULL default ' ',");
	strcat(str, "Model int(4) NOT NULL default '0',");
	strcat(str, "LastPos varchar(64) NOT NULL default '0.0,0.0,0.0,0.0,0,-1',");
	strcat(str, "Color1 int(3) NOT NULL default '0',");
	strcat(str, "Color2 int(3) NOT NULL default '0',");
	strcat(str, "Paintjob int(3) NOT NULL default '0',");
	strcat(str, "Memo varchar(128) NOT NULL default ' ',");
	strcat(str, "CreatedTime timestamp NOT NULL default CURRENT_TIMESTAMP) ");
	strcat(str, "ENGINE = InnoDB CHARACTER SET euckr COLLATE euckr_korean_ci");
	mysql_query(str);
	return 1;
}
//-----< SaveVehicleDataById >--------------------------------------------------
stock SaveVehicleDataById(vehicleid)
{
	new str[1024];
	format(str, sizeof(str), "UPDATE vehicledata SET");
	format(str, sizeof(str), "%s Ownername='%s'", str, escape(VehicleInfo[vehicleid][vOwnername]));
	format(str, sizeof(str), "%s,Model=%d", str, VehicleInfo[vehicleid][vModel]);
	format(str, sizeof(str), "%s,LastPos='%.4f,%.4f,%.4f,%.4f,%d,%d'", str,
		VehicleInfo[vehicleid][vPos][0], VehicleInfo[vehicleid][vPos][1], VehicleInfo[vehicleid][vPos][2], VehicleInfo[vehicleid][vPos][3],
		VehicleInfo[vehicleid][vInterior], VehicleInfo[vehicleid][vVirtualWorld]);
	format(str, sizeof(str), "%s,Color1=%d", str, VehicleInfo[vehicleid][vColor1]);
	format(str, sizeof(str), "%s,Color2=%d", str, VehicleInfo[vehicleid][vColor2]);
	format(str, sizeof(str), "%s,Paintjob=%d", str, VehicleInfo[vehicleid][vPaintjob]);
	format(str, sizeof(str), "%s,Memo='%s'", str, escape(VehicleInfo[vehicleid][vMemo]));
	format(str, sizeof(str), "%s WHERE ID=%d", VehicleInfo[vehicleid][vID]);
	mysql_query(str);
	return 1;
}
//-----< SaveVehicleData >------------------------------------------------------
stock SaveVehicleData()
{
	for(new i = 0, t = GetMaxVehicles(); i < t; i++)
		if(IsValidVehicleID(i))
			SaveVehicleDataById(i);
	return 1;
}
//-----< LoadVehicleData >------------------------------------------------------
stock LoadVehicleData()
{
	new count = GetTickCount();
	new str[512],
		receive[8][128],
		idx,
		splited[6][16];
	mysql_query("SELECT * FROM vehicledata");
	mysql_store_result();
	for(new i = 0, t = mysql_num_rows(); i < t; i++)
	{
		mysql_fetch_row(str, "|");
		split(str, receive, '|');
		idx = 0;

		VehicleInfo[i][vID] = strval(receive[idx++]);
		strcpy(VehicleInfo[i][vOwnername], receive[idx++]);
		VehicleInfo[i][vModel] = strval(receive[idx++]);

		split(receive[idx++], splited, ',');
		for(new j = 0; j < 4; j++)
			VehicleInfo[i][vPos][j] = floatstr(splited[j]);
		VehicleInfo[i][vInterior] = strval(splited[4]);
		VehicleInfo[i][vVirtualWorld] = strval(splited[5]);
		
		VehicleInfo[i][vColor1] = strval(receive[idx++]);
		VehicleInfo[i][vColor2] = strval(receive[idx++]);
		VehicleInfo[i][vPaintjob] = strval(receive[idx++]);
		strcpy(VehicleInfo[i][vMemo], receive[idx++]);
		
		VehicleInfo[i][vVID] = CreateVehicle(VehicleInfo[i][vModel],
			VehicleInfo[i][vPos][0], VehicleInfo[i][vPos][1], VehicleInfo[i][vPos][2], VehicleInfo[i][vPos][3],
			VehicleInfo[i][vColor1], VehicleInfo[i][vColor2], -1);
		LinkVehicleToInterior(VehicleInfo[i][vVID], VehicleInfo[i][vInterior]);
		SetVehicleVirtualWorld(VehicleInfo[i][vVID], VehicleInfo[i][vVirtualWorld]);
		ChangeVehiclePaintjob(VehicleInfo[i][vVID], VehicleInfo[i][vPaintjob]);
	}
	mysql_free_result();
	printf("vehicledata 테이블을 불러왔습니다. - %dms", GetTickCount() - count);
	return 1;
}
//-----< UnloadVehicleDataById >------------------------------------------------
stock UnloadVehicleDataById(vehicleid)
{
	VehicleInfo[vehicleid][vID] = 0;
	DestroyVehicle(VehicleInfo[vehicleid][vVID]);
	return 1;
}
//-----< UnloadVehicleData >----------------------------------------------------
stock UnloadVehicleData()
{
	for(new i = 0, t = GetMaxVehicles(); i < t; i++)
		if(IsValidVehicleID(i))
			UnloadVehicleDataById(i);
	return 1;
}
//-----< CreateVehicle_ >-------------------------------------------------------
stock CreateVehicle_(vehicletype, Float:x, Float:y, Float:z, Float:rotation, interiorid, worldid, color1, color2, respawn_delay=-1)
{
	new str[5];
	for(new i = 0, t = GetMaxVehicles(); i < t; i++)
		if(!IsValidVehicleID(i))
		{
			mysql_query("INSERT INTO vehicledata (Model) VALUES (0)");
			mysql_query("SELECT ID FROM vehicledata WHERE Model=0");
			mysql_store_result();
			mysql_fetch_row(str, "|");
			
			new dbid = strval(str),
				vehicleid = CreateVehicle(vehicletype, x, y, z, rotation, color1, color2, respawn_delay);
			LinkVehicleToInterior(vehicleid, interiorid);
			SetVehicleVirtualWorld(vehicleid, worldid);

			VehicleInfo[i][vID] = dbid;
			VehicleInfo[i][vVID] = vehicleid;
			VehicleInfo[i][vModel] = vehicletype;
			VehicleInfo[i][vPos][0] = x;
			VehicleInfo[i][vPos][1] = y;
			VehicleInfo[i][vPos][2] = z;
			VehicleInfo[i][vPos][3] = rotation;
			VehicleInfo[i][vInterior] = interiorid;
			VehicleInfo[i][vVirtualWorld] = worldid;
			VehicleInfo[i][vColor1] = color1;
			VehicleInfo[i][vColor2] = color2;
			return i;
		}
	return INVALID_VEHICLE_ID;
}
//-----< DestroyVehicle_ >------------------------------------------------------
stock DestroyVehicle_(vehicleid)
{
	new str[128];
	format(str, sizeof(str), "DELETE FROM vehicledata WHERE ID=%d", VehicleInfo[vehicleid][vID]);
	mysql_query(str);
	UnloadVehicleDataById(vehicleid);
	return 1;
}
//-----< IsValidVehicleID >-----------------------------------------------------
stock IsValidVehicleID(vehicleid)
	return (VehicleInfo[vehicleid][vID])?true:false;
//-----< GetMaxVehicles >-------------------------------------------------------
stock GetMaxVehicles()
	return sizeof(VehicleInfo);
//-----<  >---------------------------------------------------------------------
