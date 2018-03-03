// Generate first mission
_missionID = call RF_fnc_missionGenerator;
// stock lastMissionId
lastMissionID = _missionID;
// Add generated units to zeus edition
call RF_fnc_makeAllUnitsEditableForAllCurator;
// When mission is done another spawn
_condition = format ["['%1'] call RF_fnc_isMissionClosed;", _missionID];
[_condition, "execVM 'script\server\generateMission.sqf';", 5] call RF_fnc_delayedAction;

