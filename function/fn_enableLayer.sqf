params ["_layerID"];

_entities = getMissionLayerEntities _layerID;
{
	{
		if (_x isKindOf "All") then {
			_x hideObject false;
			_x allowDamage true;
			_x enableAI "ALL";
			_x enableSimulation true;
			[[_x], {
				(_this select 0) hideObject false;
				(_this select 0) allowDamage true;
				(_this select 0) enableAI "ALL";
				(_this select 0) enableSimulation true;
			}] remoteExec ["bis_fnc_call", 0];
		};
	} forEach _x;
} forEach _entities;