["true", "execVM 'script\server\generateMission.sqf';", 30] call RF_fnc_delayedAction;

[computer] execVM "script\server\initComputer.sqf";

"mission04" call RED_fnc_disableLayer;