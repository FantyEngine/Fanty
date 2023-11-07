using System.Collections;
using FantyEngine;

namespace FantyEditor.RoomEditor;

public class Selection
{
	private Vector2 m_selectionStartPos;
	private Vector2 m_SelectionEndPos;

	public List<GameObjectMarker> SelectedGameObjects = new .() ~ delete _;

	public delegate void onSelectEntity();
	public onSelectEntity OnSelectEntity;

	public void ClickSelect(GameObjectMarker gameobject)
	{
		DeselectAll();

		if (!SelectedGameObjects.Contains(gameobject))
		{
			AddGameObject(gameobject);
		}
	}

	public void ShiftClickSelect(GameObjectMarker gameobject)
	{
		if (!SelectedGameObjects.Contains(gameobject))
		{
			AddGameObject(gameobject);
		}
		else
		{
			SelectedGameObjects.Remove(gameobject);
		}
	}

	public void DragSelect(GameObjectMarker gameobject)
	{
		if (!SelectedGameObjects.Contains(gameobject))
		{
			AddGameObject(gameobject);
		}
	}

	public void Deselect(GameObjectMarker gameobject)
	{
		if (SelectedGameObjects.Contains(gameobject))
		{
			RemoveGameObject(gameobject);
		}
	}
	
	public void DeselectAll()
	{
		for (var i in SelectedGameObjects)
		{
			
		}
		SelectedGameObjects.Clear();
		if (OnSelectEntity != null)
			OnSelectEntity.Invoke();
	}

	private void AddGameObject(GameObjectMarker gameobject)
	{
		SelectedGameObjects.Add(gameobject);

		if (OnSelectEntity != null)
			OnSelectEntity.Invoke();
	}

	private void RemoveGameObject(GameObjectMarker gameobject)
	{
		SelectedGameObjects.Remove(gameobject);

		if (OnSelectEntity != null)
			OnSelectEntity.Invoke();
	}

	public bool IsSelected(GameObjectMarker gameobject)
	{
		return SelectedGameObjects.Contains(gameobject);
	}
}