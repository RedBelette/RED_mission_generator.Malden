_missionID = call RF_fnc_spawnMissionHelicopterCrashInTown;
_condition = format ["['%1'] call RF_fnc_isMissionClosed", _missionID];
[_condition, "[lastMissionID] call RF_fnc_closeMission;"] call RF_fnc_action;