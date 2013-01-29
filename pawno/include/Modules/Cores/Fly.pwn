/*
 *
 *
 *		PureunBa(¼­¼º¹ü)
 *
 *			Fly Core
 *
 *
 *		Coded by PureunBa 2011-2013 @ all right reserved.
 *
 *			< pureunba.tistory.com >
 *
 *
 *		Release:	2013/01/30
 *		Update:		2013/01/30
 *
 *
 */
/*

  < Callbacks >
	gInitHandler_Fly()
	pConenctHandler_Fly(playerid)
	pUpdateHandler_Fly(playerid)
	
  < Functions >
    GetMoveDirectionFromKeys(ud, lr)
    MoveCamera(playerid)
    GetNextCameraPosition(move_mode, Float:CP[3], Float:FV[3], &Float:X, &Float:Y, &Float:Z)
    CancelFlyMode(playerid)
    FlyMode(playerid)

*/



//-----< Variables
enum eNoclipData
{
	nCameramode,
	nFlyobject,
	nMode,
	nLrold,
	nUdold,
	nLastmove,
	Float:nAccelmul
}
new NoclipData[MAX_PLAYERS][eNoclipData];



//-----< Defines
// Players Move Speed
#define MOVE_SPEED              100.0
#define ACCEL_RATE              0.03
// Players Mode
#define CAMERA_MODE_NONE    	0
#define CAMERA_MODE_FLY     	1
// Key state definitions
#define MOVE_FORWARD    		1
#define MOVE_BACK       		2
#define MOVE_LEFT       		3
#define MOVE_RIGHT      		4
#define MOVE_FORWARD_LEFT       5
#define MOVE_FORWARD_RIGHT      6
#define MOVE_BACK_LEFT          7
#define MOVE_BACK_RIGHT         8



//-----< Callbacks
forward gInitHandler_Fly();
forward pConnectHandler_Fly(playerid);
forward pUpdateHandler_Fly(playerid);
//-----< gInitHandler >---------------------------------------------------------
public gInitHandler_Fly()
{
    for (new x; x < MAX_PLAYERS; x++)
	{
		if (NoclipData[x][nCameramode] == CAMERA_MODE_FLY) CancelFlyMode(x);
	}
	return 1;
}
//-----< pConnectHandler >------------------------------------------------------
public pConnectHandler_Fly(playerid)
{
    NoclipData[playerid][nCameramode] 	= CAMERA_MODE_NONE;
	NoclipData[playerid][nLrold]	   	= 0;
	NoclipData[playerid][nUdold]   		= 0;
	NoclipData[playerid][nMode]   		= 0;
	NoclipData[playerid][nLastmove]   	= 0;
	NoclipData[playerid][nAccelmul]   	= 0.0;
	return 1;
}
//-----< pUpdateHandler >-------------------------------------------------------
public pUpdateHandler_Fly(playerid)
{
	if (NoclipData[playerid][nCameramode] == CAMERA_MODE_FLY)
	{
	    new keys, ud, lr;
	    GetPlayerKeys(playerid, keys, ud, lr);
	    
	    if (NoclipData[playerid][nMode] && (GetTickCount() - NoclipData[playerid][nLastmove] > 100))
	        MoveCamera(playerid);

		if (NoclipData[playerid][nUdold] != ud || NoclipData[playerid][nLrold] != lr)
		{
		    if ((NoclipData[playerid][nUdold] != 0 || NoclipData[playerid][nLrold] != 0) && ud == 0 && lr == 0)
		    {
		        StopPlayerObject(playerid, NoclipData[playerid][nFlyobject]);
		        NoclipData[playerid][nMode]     = 0;
		        NoclipData[playerid][nAccelmul] = 0.0;
			}
			else
			{
			    NoclipData[playerid][nMode] = GetMoveDirectionFromKeys(ud, lr);
			    MoveCamera(playerid);
			}
		}
		NoclipData[playerid][nUdold] = ud;
		NoclipData[playerid][nLrold] = lr;
		return 0;
	}
	return 1;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----< GetMoveDirectionFromKeys >---------------------------------------------
stock GetMoveDirectionFromKeys(ud, lr)
{
	new direction = 0;
	
	if (lr < 0)
	{
	    if (ud < 0)		 direction = MOVE_FORWARD_LEFT;
	    else if (ud > 0) direction = MOVE_BACK_LEFT;
	    else             direction = MOVE_LEFT;
	}
	else if (lr > 0)
	{
	    if (ud < 0)      direction = MOVE_FORWARD_RIGHT;
	    else if (ud > 0) direction = MOVE_BACK_RIGHT;
	    else             direction = MOVE_RIGHT;
	}
	else if (ud < 0)     direction = MOVE_FORWARD;
	else if (ud > 0)     direction = MOVE_BACK;
	
	return direction;
}
//-----< MoveCamera >-----------------------------------------------------------
stock MoveCamera(playerid)
{
	new Float:FV[3], Float:CP[3];
	GetPlayerCameraPos(playerid, CP[0], CP[1], CP[2]);
	GetPlayerCameraFrontVector(playerid, FV[0], FV[1], FV[2]);
	
	if (NoclipData[playerid][nAccelmul] <= 1) NoclipData[playerid][nAccelmul] += ACCEL_RATE;
	
	new Float:speed = MOVE_SPEED * NoclipData[playerid][nAccelmul];
	
	new Float:X, Float:Y, Float:Z;
	GetNextCameraPosition(NoclipData[playerid][nMode], CP, FV, X, Y, Z);
	MovePlayerObject(playerid, NoclipData[playerid][nFlyobject], X, Y, Z, speed);
	
	NoclipData[playerid][nLastmove] = GetTickCount();
	return 1;
}
//-----< GetNextCameraPosition >------------------------------------------------
stock GetNextCameraPosition(move_mode, Float:CP[3], Float:FV[3], &Float:X, &Float:Y, &Float:Z)
{
    #define OFFSET_X (FV[0]*6000.0)
	#define OFFSET_Y (FV[1]*6000.0)
	#define OFFSET_Z (FV[2]*6000.0)
	switch (move_mode)
	{
		case MOVE_FORWARD:
		{
			X = CP[0]+OFFSET_X;
			Y = CP[1]+OFFSET_Y;
			Z = CP[2]+OFFSET_Z;
		}
		case MOVE_BACK:
		{
			X = CP[0]-OFFSET_X;
			Y = CP[1]-OFFSET_Y;
			Z = CP[2]-OFFSET_Z;
		}
		case MOVE_LEFT:
		{
			X = CP[0]-OFFSET_Y;
			Y = CP[1]+OFFSET_X;
			Z = CP[2];
		}
		case MOVE_RIGHT:
		{
			X = CP[0]+OFFSET_Y;
			Y = CP[1]-OFFSET_X;
			Z = CP[2];
		}
		case MOVE_BACK_LEFT:
		{
			X = CP[0]+(-OFFSET_X - OFFSET_Y);
 			Y = CP[1]+(-OFFSET_Y + OFFSET_X);
		 	Z = CP[2]-OFFSET_Z;
		}
		case MOVE_BACK_RIGHT:
		{
			X = CP[0]+(-OFFSET_X + OFFSET_Y);
 			Y = CP[1]+(-OFFSET_Y - OFFSET_X);
		 	Z = CP[2]-OFFSET_Z;
		}
		case MOVE_FORWARD_LEFT:
		{
			X = CP[0]+(OFFSET_X  - OFFSET_Y);
			Y = CP[1]+(OFFSET_Y  + OFFSET_X);
			Z = CP[2]+OFFSET_Z;
		}
		case MOVE_FORWARD_RIGHT:
		{
			X = CP[0]+(OFFSET_X  + OFFSET_Y);
			Y = CP[1]+(OFFSET_Y  - OFFSET_X);
			Z = CP[2]+OFFSET_Z;
		}
	}
}
//-----< CancelFlyMode >--------------------------------------------------------
stock CancelFlyMode(playerid)
{
    new Float:X, Float:Y, Float:Z;
	GetPlayerCameraPos(playerid, X, Y, Z);

	DeletePVar_(playerid, "FlyMode");
	CancelEdit(playerid);
	TogglePlayerSpectating(playerid, false);

	DestroyPlayerObject(playerid, NoclipData[playerid][nFlyobject]);
	NoclipData[playerid][nCameramode] = CAMERA_MODE_NONE;
	
	SetPlayerPos(playerid, X, Y, Z);
	return 1;
}
//-----< FlyMode >--------------------------------------------------------------
stock FlyMode(playerid)
{
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	NoclipData[playerid][nFlyobject] = CreatePlayerObject(playerid, 19300, X, Y, Z, 0.0, 0.0, 0.0);

	TogglePlayerSpectating(playerid, true);
	AttachCameraToPlayerObject(playerid, NoclipData[playerid][nFlyobject]);

	SetPVarInt_(playerid, "FlyMode", 1);
	NoclipData[playerid][nCameramode] = CAMERA_MODE_FLY;
	return 1;
}
//-----<  >---------------------------------------------------------------------
