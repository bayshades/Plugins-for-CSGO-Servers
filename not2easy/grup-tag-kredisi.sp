#include <sourcemod>
#include <store>
#include <sdktools>
#include <cstrike>
#pragma semicolon 1

Handle g_ClanTagi;
Handle g_EklentiTagi;
Handle TimeAuto = null;
ConVar PlayerCredits;
ConVar SpecPlayerCredits;
ConVar CreditsTime;
ConVar g_GrupId;

public Plugin:myinfo = 
{
	name = "Clan Tag Kullanana Bonus Kredi",
	author = "ImPossibLe`, lazhoroni",
	description = "DrK # GaminG",
	version = "1.0"
}

public OnPluginStart()
{
	g_EklentiTagi = CreateConVar("n2e_eklenti_tagi", "not2easy", "Eklenti taginizi yaziniz.");	
	g_ClanTagi = CreateConVar("n2e_clan_tag", "ZMTR #", "Clan taginizi yaziniz.");	
	PlayerCredits = CreateConVar("n2e_clantag_kredisi", "5", "Kac kredi verilecegini ayarlayin.");
	SpecPlayerCredits = CreateConVar("n2e_clantag_speckredisi", "2", "İzleyicilere kac kredi verilecegini ayarlayin.");
	CreditsTime = CreateConVar("n2e_clantagkredi_suresi", "60", "Kac saniyede bir kredi verilecegini ayarlayin.");
	g_GrupId = CreateConVar("n2e_grup_tagi", "ZMTR #", "Grup taginizi yaziniz.");
	HookConVarChange(CreditsTime, Change_CreditsTime);
	AutoExecConfig(true, "grup_tag_kredisi");
}

public void OnMapStart()
{
	TimeAuto = CreateTimer(CreditsTime.FloatValue, Timer_Gruptag_Credi, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public Action Timer_Gruptag_Credi(Handle timer, any data)
{
		char sClanTagi[64];
		char sEklentiTagi[64];
		GetConVarString(g_ClanTagi, sClanTagi, sizeof(sClanTagi));
		GetConVarString(g_EklentiTagi, sEklentiTagi, sizeof(sEklentiTagi));
		int i;
		for(i=1; i<MAXPLAYERS; i++)
		{
			if(IsClientInGame(i))
			{
				char Grup_Tagi[16];
				char g_Grup_Id[16];
				int pcredits = PlayerCredits.IntValue;
				int specpcredits = SpecPlayerCredits.IntValue;
				CS_GetClientClanTag(i, Grup_Tagi, 16);
				GetConVarString(g_GrupId, g_Grup_Id, 16);
				if((StrEqual(Grup_Tagi, g_Grup_Id) == true) && (GetClientTeam(i) == 2) || (StrEqual(Grup_Tagi, g_Grup_Id) == true) && (GetClientTeam(i) == 3))
				{
					Store_SetClientCredits(i, Store_GetClientCredits(i) + pcredits);
					PrintToChat(i, " \x02[%s] \x0C%s \x09Clan tagını kullandığınız için \x0Efazladan %i \x09kredi kazandınız.", sEklentiTagi, sClanTagi, pcredits);
				}
				else if((StrEqual(Grup_Tagi, g_Grup_Id) == true) && (GetClientTeam(i) == 1))
				{
					Store_SetClientCredits(i, Store_GetClientCredits(i) + specpcredits);
					PrintToChat(i, " \x02[%s] \x0C%s \x09Clan tagını kullandığınız için \x0Efazladan %i \x09kredi kazandınız.", sEklentiTagi, sClanTagi, specpcredits);
				}
				else if((StrEqual(Grup_Tagi, g_Grup_Id) == false))
				{
					PrintToChat(i, " \x02[%s] \x0C%s \x09Clan tagını kullanırsanız, her el \x0Efazladan %i \x09kredi kazanırsınız.", sEklentiTagi, sClanTagi, pcredits);
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
