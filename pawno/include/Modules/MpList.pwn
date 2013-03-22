/*
 *
 *
 *			Nogov MpList Module
 *		  	2013/02/27
 *
 *
 *		Copyright (c) sBum. All rights reserved.
 *
 *
 */
/*

  < Callbacks >
	pConnectHandler_MpList(playerid)
	pClickTDHandler_MpList(playerid, Text:clickedid)
	pClickPlayerTDHandler_MpList(playerid, PlayerText:playertextid)
	
  < Functions >
	ShowPlayerMpList(playerid, mplistid, caption[], items[], colors[], size=sizeof(items))

	MplGetNumberOfPages(playerid)
	PlayerText:MplCreateCurrentPageTextDraw(playerid, Float:Xpos, Float:Ypos)
	PlayerText:MplCreatePlayerDialogButton(playerid, Float:Xpos, Float:Ypos, Float:Width, Float:Height, button_text[])
	PlayerText:MplCreatePlayerHeaderTextDraw(playerid, Float:Xpos, Float:Ypos, header_text[])
	PlayerText:MplCreatePlayerBackground(playerid, Float:Xpos, Float:Ypos, Float:Width, Float:Height)
	PlayerText:MplCreateModelPreviewTextDraw(playerid, modelindex, vehcol, Float:Xpos, Float:Ypos, Float:width, Float:height)
	MplDestroyPlayerModelPreviews(playerid)
	MplShowPlayerModelPreviews(playerid)
	MplUpdatePageTextDraw(playerid)
	MplCreateSelectionMenu(playerid)
	MplDestroySelectionMenu(playerid)

*/



//-----< Defines
#define TOTAL_MPLITEMS		  	250
#define SELECTION_MPLITEMS	  	21
#define MPLITEMS_PER_LINE	   	7
#define MPL_MAX_ITEMS			500
#define MPL_NEXT_TEXT			   "Next"
#define MPL_PREV_TEXT			   "Prev"
#define MPL_DIALOG_BASE_X			75.0
#define MPL_DIALOG_BASE_Y			130.0
#define MPL_DIALOG_WIDTH			550.0
#define MPL_DIALOG_HEIGHT			180.0
#define MPL_SPRITE_DIM_X			60.0
#define MPL_SPRITE_DIM_Y			70.0



//-----< Variables
new MplHeaderText[MAX_PLAYERS][64];
new MplNumberOfPageItems[MAX_PLAYERS];
new MplPageItems[MAX_PLAYERS][MPL_MAX_ITEMS];
new MplPageColors[MAX_PLAYERS][MPL_MAX_ITEMS];
new PlayerText:MplCurrentPageTextDrawId[MAX_PLAYERS];
new PlayerText:MplHeaderTextDrawId[MAX_PLAYERS];
new PlayerText:MplBackgroundTextDrawId[MAX_PLAYERS];
new PlayerText:MplNextButtonTextDrawId[MAX_PLAYERS];
new PlayerText:MplPrevButtonTextDrawId[MAX_PLAYERS];
new PlayerText:MplSelectionItems[MAX_PLAYERS][SELECTION_MPLITEMS];
new MplItemAt[MAX_PLAYERS];
new MplId[MAX_PLAYERS];
new bool:MplActive[MAX_PLAYERS];
new MplPage[MAX_PLAYERS];



//-----< Callbacks
forward pConnectHandler_MpList(playerid);
forward pClickTDHandler_MpList(playerid, Text:clickedid);
forward pClickPlayerTDHandler_MpList(playerid, PlayerText:playertextid);
//-----< pConnectHandler >------------------------------------------------------
public pConnectHandler_MpList(playerid)
{
	MplHeaderTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
	MplBackgroundTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
	MplCurrentPageTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
	MplNextButtonTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
	MplPrevButtonTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;

	for(new x=0; x < SELECTION_MPLITEMS; x++)
		MplSelectionItems[playerid][x] = PlayerText:INVALID_TEXT_DRAW;

	MplItemAt[playerid] = 0;
	
	return 1;
}
//-----< pClickTDHandler >------------------------------------------------------
public pClickTDHandler_MpList(playerid, Text:clickedid)
{
	if (!MplActive[playerid]) return 0;

	if (clickedid == Text:INVALID_TEXT_DRAW)
	{
		MplDestroySelectionMenu(playerid);
		MplActive[playerid] = false;
		PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
		return 1;
	}

	return 0;
}
//-----< pClickPlayerTDHandler >------------------------------------------------
public pClickPlayerTDHandler_MpList(playerid, PlayerText:playertextid)
{
	if (!MplActive[playerid]) return 0;

	new curpage = MplPage[playerid];

	if (playertextid == MplNextButtonTextDrawId[playerid])
	{
		if (curpage < (MplGetNumberOfPages(playerid) - 1))
		{
			MplPage[playerid] = curpage + 1;
			MplShowPlayerModelPreviews(playerid);
			MplUpdatePageTextDraw(playerid);
			PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
		}
		else PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
		return 1;
	}

	if (playertextid == MplPrevButtonTextDrawId[playerid])
	{
		if (curpage > 0)
		{
			MplPage[playerid] = curpage - 1;
			MplShowPlayerModelPreviews(playerid);
			MplUpdatePageTextDraw(playerid);
			PlayerPlaySound(playerid, 1084, 0.0, 0.0, 0.0);
		}
		else PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
		return 1;
	}

	new x = 0;
	while (x != SELECTION_MPLITEMS)
	{
		if (playertextid == MplSelectionItems[playerid][x])
		{
			CallLocalFunction("OnMpListResponse", "ddd", playerid, MplId[playerid], MplPageItems[playerid][x + (SELECTION_MPLITEMS * MplPage[playerid])]);
			PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
			MplDestroySelectionMenu(playerid);
			CancelSelectTextDraw(playerid);
			MplActive[playerid] = false;
			return 1;
		}
		x++;
	}

	return 0;
}
//-----<  >---------------------------------------------------------------------



//-----< Functions
//-----< ShowPlayerMpList >-----------------------------------------------------
stock ShowPlayerMpList(playerid, mplistid, caption[], items[], colors[], size=sizeof(items))
{
	MplDestroySelectionMenu(playerid);
	strcpy(MplHeaderText[playerid], caption);
	MplNumberOfPageItems[playerid] = size;
	for (new i = 0; i < MplNumberOfPageItems[playerid]; i++)
	{
		MplPageItems[playerid][i] = items[i];
		MplPageColors[playerid][i] = colors[i];
	}
	MplPage[playerid] = 0;
	MplActive[playerid] = true;
	MplId[playerid] = mplistid;
	MplCreateSelectionMenu(playerid);
	SelectTextDraw(playerid, 0xACCBF1FF);
	return 1;
}
//-----< >----------------------------------------------------------------------
//-----< MplGetNumberOfPages >--------------------------------------------------
stock MplGetNumberOfPages(playerid)
{
	new size = MplNumberOfPageItems[playerid];
	if ((size >= SELECTION_MPLITEMS) && (size % SELECTION_MPLITEMS) == 0)
		return (size / SELECTION_MPLITEMS);
	else return (size / SELECTION_MPLITEMS) + 1;
}
//-----< MplCreateCurrentPageTextDraw >-----------------------------------------
stock PlayerText:MplCreateCurrentPageTextDraw(playerid, Float:Xpos, Float:Ypos)
{
	new PlayerText:txtInit;
	txtInit = CreatePlayerTextDraw(playerid, Xpos, Ypos, "0/0");
	PlayerTextDrawUseBox(playerid, txtInit, 0);
	PlayerTextDrawLetterSize(playerid, txtInit, 0.4, 1.1);
	PlayerTextDrawFont(playerid, txtInit, 1);
	PlayerTextDrawSetShadow(playerid, txtInit, 0);
	PlayerTextDrawSetOutline(playerid, txtInit, 1);
	PlayerTextDrawColor(playerid, txtInit, 0xACCBF1FF);
	PlayerTextDrawShow(playerid, txtInit);
	return txtInit;
}
//-----< MplCreatePlayerDialogButton >------------------------------------------
stock PlayerText:MplCreatePlayerDialogButton(playerid, Float:Xpos, Float:Ypos, Float:Width, Float:Height, button_text[])
{
	new PlayerText:txtInit;
	txtInit = CreatePlayerTextDraw(playerid, Xpos, Ypos, button_text);
	PlayerTextDrawUseBox(playerid, txtInit, 1);
	PlayerTextDrawBoxColor(playerid, txtInit, 0x000000FF);
	PlayerTextDrawBackgroundColor(playerid, txtInit, 0x000000FF);
	PlayerTextDrawLetterSize(playerid, txtInit, 0.4, 1.1);
	PlayerTextDrawFont(playerid, txtInit, 1);
	PlayerTextDrawSetShadow(playerid, txtInit, 0);
	PlayerTextDrawSetOutline(playerid, txtInit, 0);
	PlayerTextDrawColor(playerid, txtInit, 0x4A5A6BFF);
	PlayerTextDrawSetSelectable(playerid, txtInit, 1);
	PlayerTextDrawAlignment(playerid, txtInit, 2);
	PlayerTextDrawTextSize(playerid, txtInit, Height, Width);
	PlayerTextDrawShow(playerid, txtInit);
	return txtInit;
}
//-----< MplCreatePlayerHeaderTextDraw >----------------------------------------
stock PlayerText:MplCreatePlayerHeaderTextDraw(playerid, Float:Xpos, Float:Ypos, header_text[])
{
	new PlayerText:txtInit;
   	txtInit = CreatePlayerTextDraw(playerid, Xpos, Ypos, header_text);
   	PlayerTextDrawUseBox(playerid, txtInit, 0);
	PlayerTextDrawLetterSize(playerid, txtInit, 1.25, 3.0);
	PlayerTextDrawFont(playerid, txtInit, 0);
	PlayerTextDrawSetShadow(playerid, txtInit, 0);
	PlayerTextDrawSetOutline(playerid, txtInit, 1);
	PlayerTextDrawColor(playerid, txtInit, 0xACCBF1FF);
	PlayerTextDrawShow(playerid, txtInit);
	return txtInit;
}
//-----< MplCreatePlayerBackground >--------------------------------------------
stock PlayerText:MplCreatePlayerBackground(playerid, Float:Xpos, Float:Ypos, Float:Width, Float:Height)
{
	new PlayerText:txtBackground = CreatePlayerTextDraw(playerid, Xpos, Ypos,
	"                                            ~n~");
	PlayerTextDrawUseBox(playerid, txtBackground, 1);
	PlayerTextDrawBoxColor(playerid, txtBackground, 0x00000099);
	PlayerTextDrawLetterSize(playerid, txtBackground, 5.0, 5.0);
	PlayerTextDrawFont(playerid, txtBackground, 0);
	PlayerTextDrawSetShadow(playerid, txtBackground, 0);
	PlayerTextDrawSetOutline(playerid, txtBackground, 0);
	PlayerTextDrawColor(playerid, txtBackground,0x000000FF);
	PlayerTextDrawTextSize(playerid, txtBackground, Width, Height);
   	PlayerTextDrawBackgroundColor(playerid, txtBackground, 0x00000099);
	PlayerTextDrawShow(playerid, txtBackground);
	return txtBackground;
}
//-----< MplCreateModelPreviewTextDraw >----------------------------------------
stock PlayerText:MplCreateModelPreviewTextDraw(playerid, modelindex, vehcol, Float:Xpos, Float:Ypos, Float:width, Float:height)
{
	new PlayerText:txtPlayerSprite = CreatePlayerTextDraw(playerid, Xpos, Ypos, "");
	PlayerTextDrawFont(playerid, txtPlayerSprite, TEXT_DRAW_FONT_MODEL_PREVIEW);
	PlayerTextDrawColor(playerid, txtPlayerSprite, 0xFFFFFFFF);
	PlayerTextDrawBackgroundColor(playerid, txtPlayerSprite, 0x000000EE);
	PlayerTextDrawTextSize(playerid, txtPlayerSprite, width, height);
	PlayerTextDrawSetPreviewModel(playerid, txtPlayerSprite, modelindex);
	PlayerTextDrawSetPreviewRot(playerid,txtPlayerSprite, -16.0, 0.0, -55.0);
	PlayerTextDrawSetPreviewVehCol(playerid, txtPlayerSprite, vehcol, vehcol);
	PlayerTextDrawSetSelectable(playerid, txtPlayerSprite, 1);
	PlayerTextDrawShow(playerid,txtPlayerSprite);
	return txtPlayerSprite;
}
//-----< MplDestroyPlayerModelPreviews >----------------------------------------
stock MplDestroyPlayerModelPreviews(playerid)
{
	new x = 0;
	while (x != SELECTION_MPLITEMS)
	{
		if (MplSelectionItems[playerid][x] != PlayerText:INVALID_TEXT_DRAW)
		{
			PlayerTextDrawDestroy(playerid, MplSelectionItems[playerid][x]);
			MplSelectionItems[playerid][x] = PlayerText:INVALID_TEXT_DRAW;
		}
		x++;
	}
}
//-----< MplShowPlayerModelPreviews >-------------------------------------------
stock MplShowPlayerModelPreviews(playerid)
{
	new x = 0,
		Float:BaseX = MPL_DIALOG_BASE_X,
		Float:BaseY = MPL_DIALOG_BASE_Y - (MPL_SPRITE_DIM_Y * 0.33),
		linetracker = 0,
		itemat = MplPage[playerid] * SELECTION_MPLITEMS;

	MplDestroyPlayerModelPreviews(playerid);

	while (x != SELECTION_MPLITEMS && itemat < MplNumberOfPageItems[playerid])
	{
		if (linetracker == 0)
		{
			BaseX = MPL_DIALOG_BASE_X + 25.0;
			BaseY += MPL_SPRITE_DIM_Y * 1.0;
		}
		MplSelectionItems[playerid][x] = MplCreateModelPreviewTextDraw(playerid, MplPageItems[playerid][itemat], MplPageColors[playerid][itemat], BaseX, BaseY, MPL_SPRITE_DIM_X, MPL_SPRITE_DIM_Y);
		BaseX += MPL_SPRITE_DIM_X + 1.0;
		linetracker++;
		if (linetracker == MPLITEMS_PER_LINE) linetracker = 0;
		itemat++;
		x++;
	}
}
//-----< MplUpdatePageTextDraw >------------------------------------------------
stock MplUpdatePageTextDraw(playerid)
{
	new PageText[64+1];
	format(PageText, 64, "%d/%d", MplPage[playerid] + 1, MplGetNumberOfPages(playerid));
	PlayerTextDrawSetString(playerid, MplCurrentPageTextDrawId[playerid], PageText);
}
//-----< MplCreateSelectionMenu >-----------------------------------------------
stock MplCreateSelectionMenu(playerid)
{
	MplBackgroundTextDrawId[playerid] = MplCreatePlayerBackground(playerid, MPL_DIALOG_BASE_X, MPL_DIALOG_BASE_Y + 20.0, MPL_DIALOG_WIDTH, MPL_DIALOG_HEIGHT);
	MplHeaderTextDrawId[playerid] = MplCreatePlayerHeaderTextDraw(playerid, MPL_DIALOG_BASE_X, MPL_DIALOG_BASE_Y, MplHeaderText[playerid]);
	MplCurrentPageTextDrawId[playerid] = MplCreateCurrentPageTextDraw(playerid, MPL_DIALOG_WIDTH - 30.0, MPL_DIALOG_BASE_Y + 15.0);
	MplNextButtonTextDrawId[playerid] = MplCreatePlayerDialogButton(playerid, MPL_DIALOG_WIDTH - 30.0, MPL_DIALOG_BASE_Y+MPL_DIALOG_HEIGHT+100.0, 50.0, 16.0, MPL_NEXT_TEXT);
	MplPrevButtonTextDrawId[playerid] = MplCreatePlayerDialogButton(playerid, MPL_DIALOG_WIDTH - 90.0, MPL_DIALOG_BASE_Y+MPL_DIALOG_HEIGHT+100.0, 50.0, 16.0, MPL_PREV_TEXT);

	MplShowPlayerModelPreviews(playerid);
	MplUpdatePageTextDraw(playerid);
}
//-----< MplDestroySelectionMenu >----------------------------------------------
stock MplDestroySelectionMenu(playerid)
{
	MplDestroyPlayerModelPreviews(playerid);

	PlayerTextDrawDestroy(playerid, MplHeaderTextDrawId[playerid]);
	PlayerTextDrawDestroy(playerid, MplBackgroundTextDrawId[playerid]);
	PlayerTextDrawDestroy(playerid, MplCurrentPageTextDrawId[playerid]);
	PlayerTextDrawDestroy(playerid, MplNextButtonTextDrawId[playerid]);
	PlayerTextDrawDestroy(playerid, MplPrevButtonTextDrawId[playerid]);

	MplHeaderTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
	MplBackgroundTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
	MplCurrentPageTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
	MplNextButtonTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
	MplPrevButtonTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
}
//-----<  >---------------------------------------------------------------------
