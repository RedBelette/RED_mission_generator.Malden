if (!hasInterface) exitWith {};

loadingFinished = false;
onPreloadFinished {loadingFinished = true};
waitUntil {loadingFinished};

_posPlayerHeight = [0, 0, 500];
camera = "camera" camcreate _posPlayerHeight;
camera cameraEffect ["internal", "back"];
camera camCommit 0;
showCinemaBorder false;

sleep 2;

["media\image\cp.paa", 5] call RF_fnc_imageFullScreen;
sleep 5;

cutText ["", "BLACK OUT", 1];

player cameraEffect ["terminate","back"];
camDestroy camera;

cutText ["", "BLACK IN", 1];