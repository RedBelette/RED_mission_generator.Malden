// B_Lifeboat

// Calculate spawn position
_spawnPos = [7701.42,2970.35,30.1061];

// Spawn boat
_boat = "C_Boat_Civil_01_F" createVehicle _spawnPos;

// Debug camera
_camera = "camera" camcreate getPos _boat;
_camera cameraEffect ["internal", "back"];
_camera attachTo [_boat, [0,-7,0.5]];
_camera camCommit 0;
waitUntil {camCommitted _camera};

// Spawn crew inside boat
_crewGroup = createGroup [civilian, true];
_driver = _crewGroup createUnit ["C_man_1", getPos _boat, [], 0, "NONE"];
_driver moveInDriver _boat;

// Spawn units inside boat
_unitsGroup = createGroup [civilian, true];
_unit1 = _unitsGroup createUnit ["C_man_1", getPos _boat, [], 0, "NONE"];
_unit1 moveInCargo _boat;
_unit2 = _unitsGroup createUnit ["C_man_1", getPos _boat, [], 0, "NONE"];
_unit2 moveInCargo _boat;

// Link crewGroup with UnitsGroup
_crewGroup setVariable ["_passengerGroup", _unitsGroup];

// Move boat to the naval port
_nearestLocationMarine = nearestLocation [getPos _boat, "NameMarine"];

// Approach marina
_approachMarineWaypoint = _crewGroup addWaypoint [position _nearestLocationMarine, 0];
// When arrival, units get down
_approachMarineWaypoint setWaypointType "TR UNLOAD";
_approachMarineWaypoint setWaypointStatements ["true", "
_passengerGroup = this getVariable '_passengerGroup';
_camera = 'camera' camcreate getPos leader _passengerGroup;
_camera cameraEffect ['internal', 'back'];
_camera attachTo [this, [0,-7,0.5]];
_camera camCommit 0;
"];

// Generate location
_locations = call RF_fnc_locations;
_randomLocation = _locations select (random (count _locations));

// Stop the car and take position
_cars = nearestObjects [position _nearestLocationMarine, ["Car"],
1000];
if (!isNil "_cars") then {
	_unitsSearchCarWaypoint = _unitsGroup addWaypoint [position (_cars select 0), 0];
	_unitsSearchCarWaypoint setWaypointType "GETIN NEAREST";
};

// Go in direction of the final position
_unitsWaypoint = _unitsGroup addWaypoint [position _randomLocation, 0];
_unitsWaypoint setWaypointSpeed "LIMITED";


// When arrival and after discharging go on start position
_boatGetOutWaypoint = _crewGroup addWaypoint [_spawnPos, 0];

// Remove boat and crew
_boatGetOutWaypoint setWaypointStatements ["true", "
_boat = vehicle this;
{
	deleteVehicle _x;
} forEach crew _boat;
deleteVehicle _boat;
"];