﻿using System.Collections.Generic;
#if UNITY_EDITOR
using UnityEditor;
#endif

namespace AC
{

	[System.Serializable]
	public class ActionObjectiveSet : Action, IObjectiveReferencerAction
	{

		public int objectiveID;
		public int objectiveParameterID = -1;

		public int newStateID;
		public bool selectAfter;
		public int playerID;
		public bool setPlayer;
		

		public override ActionCategory Category { get { return ActionCategory.Objective; }}
		public override string Title { get { return "Set state"; }}
		public override string Description { get { return "Updates an objective's current state."; }}


		public override void AssignValues (List<ActionParameter> parameters)
		{
			objectiveID = AssignObjectiveID (parameters, objectiveParameterID, objectiveID);
		}


		public override float Run ()
		{
			if (KickStarter.inventoryManager.ObjectiveIsPerPlayer (objectiveID) && setPlayer)
			{
				KickStarter.runtimeObjectives.SetObjectiveState (objectiveID, newStateID, playerID);
			}
			else
			{
				KickStarter.runtimeObjectives.SetObjectiveState (objectiveID, newStateID, selectAfter);
			}

			Menu[] menus = PlayerMenus.GetMenus (true).ToArray ();
			foreach (Menu menu in menus)
			{
				menu.Recalculate ();
			}

			return 0f;
		}


		#if UNITY_EDITOR

		public override void ShowGUI (List<ActionParameter> parameters)
		{
			if (KickStarter.inventoryManager == null)
			{
				EditorGUILayout.HelpBox ("An Inventory Manager must be defined to use this Action", MessageType.Warning);
				return;
			}

			objectiveParameterID = Action.ChooseParameterGUI ("Objective:", parameters, objectiveParameterID, ParameterType.Objective);
			if (objectiveParameterID < 0)
			{
				objectiveID = InventoryManager.ObjectiveSelectorList (objectiveID);

				Objective objective = KickStarter.inventoryManager.GetObjective (objectiveID);
				if (objective != null)
				{
					newStateID = objective.StateSelectorList (newStateID, "Set to state:");

					if (KickStarter.inventoryManager.ObjectiveIsPerPlayer (objectiveID))
					{
						setPlayer = EditorGUILayout.Toggle ("Affect specific Player?", setPlayer);
						if (setPlayer)
						{
							playerID = ChoosePlayerGUI (playerID, false);
						}
						else
						{
							selectAfter = EditorGUILayout.Toggle ("Select after?", selectAfter);
						}
					}
					else
					{
						selectAfter = EditorGUILayout.Toggle ("Select after?", selectAfter);
					}
				}
			}
			else
			{
				newStateID = EditorGUILayout.IntField ("Set to state ID:", newStateID);
			}
		}
		

		public override string SetLabel ()
		{
			if (objectiveParameterID < 0)
			{
				Objective objective = KickStarter.inventoryManager.GetObjective (objectiveID);
				if (objective != null)
				{
					return objective.Title;
				}
			}			
			return string.Empty;
		}


		public int GetNumObjectiveReferences (int _objectiveID)
		{
			return (objectiveParameterID < 0 && objectiveID == _objectiveID) ? 1 : 0;
		}


		public int UpdateObjectiveReferences (int oldObjectiveID, int newObjectiveID)
		{
			if (objectiveParameterID < 0 && objectiveID == oldObjectiveID)
			{
				objectiveID = newObjectiveID;
				return 1;
			}
			return 0;
		}

		#endif
		
	}

}