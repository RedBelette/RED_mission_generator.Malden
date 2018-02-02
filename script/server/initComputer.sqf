// Assigner ace action
[_this,{
	if (isServer and !hasInterface) exitWith {};
	_computer = _this select 0;

	[_computer, "checkMedicProgressBar", "Vérifier la formation médical", "Analyse en cours", {

		switch (player getVariable ['ace_medical_medicClass', 0]) do
		{
			case 2:
			{
				hint "Vous êtes médecin";
			};

			case 1:
			{
				hint "Vous êtes infirmier";
			};

			default
			{
				hint "Vous aucune formation médical";
			};
		};

		}, {}, [], 2] call RF_fnc_progressBar;

	[_computer, "assignNurseProgressBar", "Formation infirmier", "Formation en cours", {player setVariable ["ace_medical_medicClass", 1, true];}, {}, [], 5] call RF_fnc_progressBar;

	[_computer, "assignDoctorProgressBar", "Formation médecin", "Formation en cours", {player setVariable ["ace_medical_medicClass", 2, true];}, {}, [], 5] call RF_fnc_progressBar;

	[_computer, "unassignMedicProgressBar", "Enlever formation médical", "(dé)Formation en cours", {player setVariable ["ace_medical_medicClass", 0, true];}, {}, [], 5] call RF_fnc_progressBar;

	[_computer, "checkEngineerProgressBar", "Vérifier la formation ingénieur", "Analyse en cours", {

		switch (player getVariable ['ACE_IsEngineer', 0]) do
		{
			case 2:
			{
				hint "Vous êtes un brillant ingénieur";
			};

			case 1:
			{
				hint "Vous êtes ingénieur";
			};

			default
			{
				hint "Vous n'êtes pas ingénieur";
			};
		};

		}, {}, [], 2] call RF_fnc_progressBar;

	[_computer, "assignEngineerProgressBar", "Formation ingénieur", "Formation en cours", {player setVariable ["ACE_IsEngineer", 1, true];}, {}, [], 5] call RF_fnc_progressBar;

	[_computer, "assignEngineerAdvProgressBar", "Formation ingénieur avancé", "Formation en cours", {player setVariable ["ACE_IsEngineer", 2, true];}, {}, [], 5] call RF_fnc_progressBar;

	[_computer, "unassignEngineerProgressBar", "Enlever formation ingénieur", "(dé)Formation en cours", {player setVariable ["ACE_IsEngineer", 0, true];}, {}, [], 5] call RF_fnc_progressBar;

}] remoteExec ["BIS_fnc_spawn", 0, true];