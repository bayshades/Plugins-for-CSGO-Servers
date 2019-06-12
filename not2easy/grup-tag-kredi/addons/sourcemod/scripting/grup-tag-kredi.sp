#include <sourcemod>
#include <store>
#include <sdktools>
#include <cstrike>
#include <multicolors>
#pragma semicolon 1
Handle g_ClanTagi, TimeAuto = null;
ConVar PlayerCredits, SpecPlayerCredits, CreditsTime, g_GrupId;
public Plugin:myinfo = 
{
	name = "Clan Tag Kullanana Bonus Kredi",
	author = "ImPossibLe`, lazhoroni",
	description = "DrK # GaminG",
	version = "1.0"
}
public OnPluginStart()
{	
	g_ClanTagi = CreateConVar("n2e_clan_tag", "ZMTR #", "Clan taginizi yaziniz.");	
	PlayerCredits = CreateConVar("n2e_clantag_kredisi", "5", "Kac kredi verilecegini ayarlayin.");
	SpecPlayerCredits = CreateConVar("n2e_clantag_speckredisi", "2", "İzleyicilere kac kredi verilecegini ayarlayin.");
	CreditsTime = CreateConVar("n2e_clantagkredi_suresi", "60", "Kac saniyede bir kredi verilecegini ayarlayin.");
	g_GrupId = CreateConVar("n2e_grup_tagi", "ZMTR #", "Grup taginizi yaziniz.");
	HookConVarChange(CreditsTime, Change_CreditsTime);
	AutoExecConfig(true, "grup_tag_kredi");
	LoadTranslations("grup_tag_kredi.phrases");
}
public void OnMapStart()
{
	TimeAuto = CreateTimer(CreditsTime.FloatValue, Timer_Gruptag_Credi, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}
public Action Timer_Gruptag_Credi(Handle timer, any data)
{
	char sClanTagi[64];
	GetConVarString(g_ClanTagi, sClanTagi, sizeof(sClanTagi));
	for(int i=1; i<MAXPLAYERS; i++)
	{
		if(IsClientInGame(i))
		{
			char Grup_Tagi[16], g_Grup_Id[16];
			int pcredits = PlayerCredits.IntValue;
			int specpcredits = SpecPlayerCredits.IntValue;
			CS_GetClientClanTag(i, Grup_Tagi, 16);
			GetConVarString(g_GrupId, g_Grup_Id, 16);
			if((StrEqual(Grup_Tagi, g_Grup_Id) == true) && (GetClientTeam(i) == 2) || (StrEqual(Grup_Tagi, g_Grup_Id) == true) && (GetClientTeam(i) == 3))
			{
				Store_SetClientCredits(i, Store_GetClientCredits(i) + pcredits);
				CPrintToChat(i, "%t", "Kredi-Odul-Mesaji", g_cvarChatTag, sClanTagi, pcredits);
			}
			else if((StrEqual(Grup_Tagi, g_Grup_Id) == true) && (GetClientTeam(i) == 1))
			{
				Store_SetClientCredits(i, Store_GetClientCredits(i) + specpcredits);
				CPrintToChat(i, "%t", "Spec-Kredi-Odul-Mesaji", g_cvarChatTag, sClanTagi, specpcredits);
			}
			else if((StrEqual(Grup_Tagi, g_Grup_Id) == false))
			{
				CPrintToChat(i, "%t", "Grup-Tagi-Almayana-Mesaj", g_cvarChatTag, sClanTagi);
			}
		}
	}
}
public void Change_CreditsTime(Handle cvar, const char[] oldVal, const char[] newVal)
{
	if (TimeAuto != null)
	{
		KillTimer(TimeAuto);
		TimeAuto = null;
	}
	TimeAuto = CreateTimer(CreditsTime.FloatValue, Timer_Gruptag_Credi, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}