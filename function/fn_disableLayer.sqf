params ["_layerID"];

_entities = getMissionLayerEntities _layerID;
{
	{
		if (_x isKindOf "All") then {
			hideObject _x;
			_x allowDamage false;
			_x disableAI "ALL";
			_x enableSimulation false;
			[[_x], {
				hideObject (_this select 0);
				(_this select 0) allowDamage false;
				(_this select 0) disableAI "ALL";
				(_this select 0) enableSimulation false;
			}] remoteExec ["bis_fnc_call", 0];
		};
	} forEach _x;

} forEach _entities;