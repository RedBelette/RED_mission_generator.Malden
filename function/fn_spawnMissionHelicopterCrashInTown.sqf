params ["_side","_helicopterClass", "_unitTypes"];

if (isNil "_side") then {
	_side = (getMissionConfig "RedFrameworkConfig" >> "combatPatrol_CfgEnemis" >> "side") call  BIS_fnc_returnConfigEntry;
	_side = [_side] call RF_fnc_convertSideStr;
};

if (isNil "_helicopterClass") then {
	_helicopterClass = (getMissionConfig "RedFrameworkConfig" >> "combatPatrol_missions" >> "combatPatrol_helicopterCrashInTown" >> "helicopterClass") call  BIS_fnc_returnConfigEntry;
};

if (isNil "_unitTypes") then {
	_unitTypes = (getMissionConfig "RedFrameworkConfig" >> "combatPatrol_missions" >> "combatPatrol_helicopterCrashInTown" >> "unitTypes") call  BIS_fnc_returnConfigEntry;
};

_locationPos = call RF_fnc_locationGenerator;
[_locationPos] call RF_fnc_spawnCirclePatrols;
[_locationPos] call RF_fnc_spawnGarnisons;

_calculatedPos = [_locationPos, random 300, random 360] call BIS_fnc_relPos;
_vehicle = _helicopterClass createVehicle _calculatedPos;
[[_vehicle]] call RF_fnc_makeObjectsEditableForAllCurator;
removeAllItems _vehicle;
removeAllWeapons _vehicle;
clearMagazineCargo _vehicle;
clearWeaponCargoGlobal _vehicle;
_vehicle setVariable ["ace_cookoff_enable", false, true];
_vehicle setDamage 1;
_vehicle setVectorDirAndUp [[0,0,-1],[0,1,0]];

waitUntil {!isNil "RF_fnc_spawnGarnisons"};
[getPos _vehicle, 10, _side, _unitTypes, 7] call RF_fnc_spawnGarnisons;

waitUntil {!isNil "RF_fnc_spawnCirclePatrols"};
[getPos _vehicle, 10, _side, _unitTypes, [20,10,5]] call RF_fnc_spawnCirclePatrols;

[
	blufor,
	"helicopter",
	[localize "str_redMissionGenerator_mission1_description", localize "str_redMissionGenerator_mission1_title"],
	objNull,
	true,
	0,
	true,
	"heli",
	false
] call BIS_fnc_taskCreate;

[[_vehicle], {
	_action = ["helicopter",
		localize "str_redMissionGenerator_mission1_title",
		"",
		{
			[
				5,
				[],
				{
					transponder = true;
					publicVariable "transponder";
				},
				{},
				localize "str_redMissionGenerator_mission1_progressbar"
			] call ace_common_fnc_progressBar;
		},
		{true},
		{},
		[],
		[0,0,0],
		5
	] call ace_interact_menu_fnc_createAction;
	_vehicle = (_this select 0);
	[_vehicle, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
}] remoteExec ["BIS_fnc_spawn"];

["transponder", "[] spawn {['helicopter', 'SUCCEEDED'] spawn BIS_fnc_taskSetState;sleep 10; ['end1'] remoteExec ['endMission'];};"] call RF_fnc_action;