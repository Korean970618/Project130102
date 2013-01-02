/*
 *
 *
 *		PureunBa(¼­¼º¹ü)
 *
 *			Nogov Main Include
 *			v1.0.0
 *
 *
 *		Coded by PureunBa 2011-2013 @ all right reserved.
 *
 *			< pureunba.tistory.com >
 *
 *
 *		Release:	2013/01/12
 *		Update:		2013/01/12
 *
 *
 */
/*
native strcpy(dest[],src[]);
native FixBlankString(input[]);
native AntiDeAMX();
 */



//-----< Defines
//-----< System Colors >--------------------------------------------------------
#define COLOR_ADMIN				0x2587CEFF // *Admin:
#define COLOR_DIALOG			0xA9C4E4FF
#define C_ADMIN					"{2587CE}"
#define C_DIALOG				"{A9C4E4}"
//-----< Pastel Colors >--------------------------------------------------------
#define COLOR_PASTEL_BLACK		0x9A9691FF
#define COLOR_PASTEL_YELLOW		0xFAF5A4FF
#define COLOR_PASTEL_RED		0xFFB2BEFF
#define COLOR_PASTEL_MAGENTA	0xF9ABDDFF
#define COLOR_PASTEL_VIOLET		0xBA94DDFF
#define COLOR_PASTEL_BLUE		0x5DCEF0FF
#define COLOR_PASTEL_GREEN		0x6DE5D0FF
#define C_PASTEL_BLACK			"{9A9691}"
#define C_PASTEL_YELLOW			"{FAF5A4}"
#define C_PASTEL_RED			"{FFB2BE}"
#define C_PASTEL_MAGENTA		"{F9ABDD}"
#define C_PASTEL_VIOLET			"{BA94DD}"
#define C_PASTEL_BLUE			"{5DCEF0}"
#define C_PASTEL_GREEN			"{6DE5D0}"
//-----< General Colors >-------------------------------------------------------
#define COLOR_WHITE				0xFFFFFFFF
#define COLOR_GREY 				0xAAAAAAFF
#define COLOR_RED 				0xFF0000FF
#define COLOR_GREEN		  		0x00FF00FF
#define COLOR_BLUE		  		0x0000FFFF
#define COLOR_YELLOW			0xFFFF00FF
#define COLOR_CORAL				0xFFAB7BFF
#define COLOR_PINK				0xFFC0CBFF
#define COLOR_HOTPINK			0xFF69B4FF
#define COLOR_PURPLE			0xD1B9E3FF
#define COLOR_VIOLET			0xEE82EEFF
#define COLOR_ORANGE		  	0xFF9900FF
#define COLOR_SPRINGGREEN		0x00FF7FFF
#define COLOR_YELLOWGREEN		0x9ACD32FF
#define COLOR_LIGHTGREEN 		0xCBFEA9FF
#define COLOR_MEDIUMAQUA		0x83BFBFFF
#define COLOR_TAXIYELLOW	  	0xF0E68CFF
#define COLOR_SKYBLUE			0x9CEAFBFF
#define COLOR_LIGHTBLUE	  		0x33CCFFFF
#define COLOR_LIGHTPINK			0xFF8282FF
#define C_WHITE					"{FFFFFF}"
#define C_GREY 					"{AAAAAA}"
#define C_RED 					"{FF0000}"
#define C_GREEN		  			"{00FF00}"
#define C_BLUE		  			"{0000FF}"
#define C_YELLOW				"{FFFF00}"
#define C_CORAL					"{FFAB7B}"
#define C_PINK					"{FFC0CB}"
#define C_HOTPINK				"{FF69B4}"
#define C_PURPLE				"{D1B9E3}"
#define C_VIOLET				"{EE82EE}"
#define C_ORANGE		  		"{FF9900}"
#define C_SPRINGGREEN			"{00FF7F}"
#define C_YELLOWGREEN			"{9ACD32}"
#define C_LIGHTGREEN 			"{CBFEA9}"
#define C_MEDIUMAQUA			"{83BFBF}"
#define C_TAXIYELLOW	  		"{F0E68C}"
#define C_SKYBLUE				"{9CEAFB}"
#define C_LIGHTBLUE	  			"{33CCFF}"



//-----< Functions
//-----< strcpy >---------------------------------------------------------------
stock strcpy(dest[],src[])
{
	new i = 0;
	while((dest[i] = src[i]))
		i++;
}
//-----< AntiDeAMX >------------------------------------------------------------
stock AntiDeAMX()
{
	new a[][] =	{"Pureun","Ba"};
	#pragma unused a
}
//-----< FixBlankString >-------------------------------------------------------
stock FixBlankString(input[])
{
	new string[1024];
	strcpy(string,"/Empty/");
	if(strlen(input))
		strcpy(string,input);
	return string;
}
//-----<  >---------------------------------------------------------------------
