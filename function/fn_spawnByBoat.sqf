params ["_spawnPos", "_boatClass", "_side", "_unitsClass", "_unitsLocation", ["_isSearchingCar", false], "_arrivalLocation", ["_maxDistanceSearchingCar", 1000], ["_typeVehiclesSearchingCar", ["Car", "Truck"]]];

// defaults parameters
if (isNil "_boatClass") then {
	_boatClass = "C_Boat_Civil_01_F";
};

if (isNil "_side") then {
	_side = civilian;
};

if (isNil "_unitsClass") then {
	_unitsClass = ["C_man_1", "C_man_1"];
};

// Spawn boat
_boat = _boatClass createVehicle _spawnPos;

if (isNil "_arrivalLocation") then {
	// Move boat to the naval port
	_arrivalLocation = nearestLocation [getPos _boat, "NameMarine"];
};

if (isNil "_unitsLocation") then {
	_locations = call RF_fnc_locations;
	_unitsLocation = _locations select (random (count _locations));
};

// Spawn crew inside boat
_crewGroup = createGroup [_side, true];
_driver = _crewGroup createUnit ["C_man_1", getPos _boat, [], 0, "NONE"];
_driver moveInDriver _boat;
_driver setskill 1;

// Spawn units inside boat
_unitsGroup = createGroup [_side, true];
{
	_unit = _unitsGroup createUnit [_x, getPos _boat, [], 0, "NONE"];
	_unit moveInCargo _boat;
} forEach _unitsClass;

// Link crewGroup with UnitsGroup
_crewGroup setVariable ["_passengerGroup", _unitsGroup];

// Approach marina
_approachMarineWaypoint = _crewGroup addWaypoint [position _arrivalLocation, 0];
// _approachMarineWaypoint setWaypointSpeed "LIMITED";
// When arrival, units get down
_approachMarineWaypoint setWaypointType "TR UNLOAD";
_approachMarineWaypoint setWaypointStatements ["true", "
_passengerGroup = this getVariable '_passengerGroup';
_camera = 'camera' camcreate getPos leader _passengerGroup;
_camera cameraEffect ['internal', 'back'];
_camera attachTo [this, [0,-7,0.5]];
_camera camCommit 0;
"];

// Stop the car and take position
if (!isNil "_isSearchingCar" and _isSearchingCar) then {
	_cars = nearestObjects [position _arrivalLocation, _typeVehiclesSearchingCar, _maxDistanceSearchingCar];
	if (!isNil "_cars") then {
		_unitsSearchCarWaypoint = _unitsGroup addWaypoint [position (_cars select 0), 0];
		_unitsSearchCarWaypoint setWaypointType "GETIN NEAREST";
	};
};


// Go in direction of the final position
_unitsWaypoint = _unitsGroup addWaypoint [position _unitsLocation, 0];

// When arrival and after discharging go on start position
_boatGetOutWaypoint = _crewGroup addWaypoint [_spawnPos, 0];
_boatGetOutWaypoint setWaypointSpeed "LIMITED";

// Remove boat and crew
_boatGetOutWaypoint setWaypointStatements ["true", "
_boat = vehicle this;
{
	deleteVehicle _x;
} forEach crew _boat;
deleteVehicle _boat;
"];

_unitsGroup