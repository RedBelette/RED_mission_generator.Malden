_missionID = ["mission02_intrusion", blufor, "", localize "str_redMissionGenerator_mission2_title", localize "str_redMissionGenerator_mission2_description"] call RF_fnc_createMission;

// random spawn location
/*_centerOfTheWorld = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");*/
/*_centerOfTheWorld = [6452.52,6532.05,0];
_spawnPos = [_centerOfTheWorld, 6800, random 360] call BIS_fnc_relPos;*/
_spawnPos = selectRandom [[6401.73,12398.7,0], [8014.42,1782.85,0], [2096.96,8424.12,0]];
_unitsLocation = nearestLocation [_spawnPos, "nameCity"];

/*_locations = call RF_fnc_locations;
_unitsLocation = _locations select (random (count _locations));*/


_spawnedGroups = [];
_patrolGroups = [];
_garnisonGroups = [];

_garnisonPatrolBreakIndice = 0;
_i = 0;
while {_i < 3} do
{
	{
		_spawnPos = [(_spawnPos select 0) + 10, _spawnPos select 1, _spawnPos select 2];
		_spawnedGroup = [_spawnPos, "O_Boat_Transport_01_F", opfor, _x, _unitsLocation] call RED_fnc_spawnByBoat;
		_spawnedGroup setBehaviour "COMBAT";
		_spawnedGroup setCombatMode "RED";
		_spawnedGroup setSpeedMode "FULL";
		_spawnedGroups pushBack _spawnedGroup;
		if (_garnisonPatrolBreakIndice < 4) then {
			_garnisonGroups pushBack _spawnedGroup;
		} else {
			_patrolGroups pushBack _spawnedGroup;
		};
		_garnisonPatrolBreakIndice = _garnisonPatrolBreakIndice + 1;
		sleep 10;
	} forEach [["LOP_US_Infantry_Officer", "LOP_US_Infantry_Rifleman_2", "LOP_US_Infantry_Rifleman_4", "LOP_US_Infantry_Rifleman"], ["LOP_US_Infantry_Officer", "LOP_US_Infantry_Rifleman_2", "LOP_US_Infantry_Rifleman_4", "LOP_US_Infantry_Rifleman"], ["LOP_US_Infantry_Officer", "LOP_US_Infantry_Rifleman_2", "LOP_US_Infantry_Rifleman_4", "LOP_US_Infantry_Rifleman"],["LOP_US_Infantry_Officer", "LOP_US_Infantry_Rifleman_2", "LOP_US_Infantry_Rifleman_4", "LOP_US_Infantry_Rifleman"],["LOP_US_Infantry_Officer", "LOP_US_Infantry_Rifleman_2", "LOP_US_Infantry_Rifleman_4", "LOP_US_Infantry_Rifleman"]];

	call RF_fnc_makeAllUnitsEditableForAllCurator;
	sleep 60;
	_i = _i + 1;
};

_dir = 0;
_stepDir = 360 / (count _garnisonGroups);
{
	_calculatedPos = [position _unitsLocation, 200, _dir] call BIS_fnc_relPos;
	_nearBuilding = nearestBuilding _calculatedPos;
	_garnisonWp = _x addWaypoint [_nearBuilding, 0];
	_x setWaypointBehaviour "SAFE";
	_x setWaypointSpeed "LIMITED";
	_x setWaypointStatements ["true", "
		[this] call CBA_fnc_taskDefend;
	"];
	_dir = _dir + _stepDir;
} forEach _garnisonGroups;

_dir = 0;
_stepDir = 360 / (count _patrolGroups);
{
	_calculatedPos = [position _unitsLocation, 800, _dir] call BIS_fnc_relPos;
	_patrolWp = _x addWaypoint [_calculatedPos, 0];
	[_x, _calculatedPos, 150] call CBA_fnc_taskPatrol;
	_dir = _dir + _stepDir;
} forEach _patrolGroups;

