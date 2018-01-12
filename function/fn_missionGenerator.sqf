_archetypes = ["spawnMissionHelicopterCrashInTown"];
_randomMission = selectRandom _archetypes;
switch (_randomMission) do
{
	case ("spawnMissionHelicopterCrashInTown"):
	{
		[] spawn RF_fnc_spawnMissionHelicopterCrashInTown;
	};

	default
	{

	};
};

_randomMission