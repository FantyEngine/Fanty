using FantyEngine;
using System;

namespace FantyEditor.RoomEditor;

public class GameObjectMarker
{
	public GameObjectInstance GameObject = null;
	public Guid EditorID { get; private set; }

	private bool m_Resizing = false;
	private ResizingSide m_ResizingSide = .None;

	private Vector2 m_ResizingStartMousePos = .zero;

	private Vector2 m_ResizingStartPos = .zero;
	private Vector2 m_ResizingStartScale = .zero;
	private bool m_HoveringResize = false;

	private bool m_Moving = false;
	private Vector2 m_StartMovingOffset = .zero;

	private enum ResizingSide
	{
		None,
		Top,
		TopLeft,
		TopRight,
		Left,
		Right,
		Bottom,
		BottomLeft,
		BottomRight,
	}

	public this(ref GameObjectInstance instance, Guid ID)
	{
		this.GameObject = instance;
		this.EditorID = ID;
	}

	public void Update(Vector2 cursorPos, Vector2 cursorWorldPos, bool mouseInViewport, bool snapping, Vector2Int snapSize)
	{
		if (mouseInViewport && RaylibBeef.Raylib.IsMouseButtonPressed((int32)RaylibBeef.MouseButton.MOUSE_BUTTON_LEFT))
		{
			let bbox = GameObject.Bounds;

			let inX = FantyEngine.Mathf.IsWithin(cursorWorldPos.x, bbox.left, bbox.right);
			let inY = FantyEngine.Mathf.IsWithin(cursorWorldPos.y, bbox.top, bbox.bottom);

			if (inX && inY)
			{
				RoomEditor.[Friend]m_Selection.ClickSelect(this);
			}
			else
			{
				if (!m_Resizing && !m_HoveringResize)
					RoomEditor.[Friend]m_Selection.Deselect(this);
			}
		}

		if (m_Resizing)
		{
			let resizeOffset = (snapping) ? GameObject.SpriteAsset.Size.x * 0.5f : 0;
			switch (m_ResizingSide)
			{
			case .Right:
				GameObject.ImageXScale = ((cursorWorldPos.x - m_ResizingStartMousePos.x + resizeOffset) / GameObject.SpriteAsset.Size.x) + m_ResizingStartScale.x;
				if (snapping) GameObject.ImageXScale = Mathf.Round2Nearest(GameObject.ImageXScale, GameObject.SpriteAsset.Size.x / snapSize.x);

				if (GameObject.ImageXScale < 0)
				{
					GameObject.x = (cursorWorldPos.x + GameObject.xOrigin + resizeOffset);
					if (snapping) GameObject.x = Mathf.Round2Nearest(GameObject.x, snapSize.x);
				}
				break;
			case .Left:
				GameObject.x = (cursorWorldPos.x + GameObject.xOrigin + resizeOffset);
				if (snapping) GameObject.x = Mathf.Round2Nearest(GameObject.x, snapSize.x);

				GameObject.ImageXScale = ((m_ResizingStartPos.x - GameObject.x) / GameObject.SpriteAsset.Size.x) + m_ResizingStartScale.x;
				break;
			case .Bottom:
				GameObject.ImageYScale = ((cursorWorldPos.y - m_ResizingStartMousePos.y + resizeOffset) / GameObject.SpriteAsset.Size.y) + m_ResizingStartScale.y;
				if (snapping) GameObject.ImageYScale = Mathf.Round2Nearest(GameObject.ImageYScale, GameObject.SpriteAsset.Size.y / snapSize.y);
				break;
			case .Top:
				GameObject.y = (cursorWorldPos.y + GameObject.yOrigin + resizeOffset);
				if (snapping) GameObject.y = Mathf.Round2Nearest(GameObject.y, snapSize.y);

				GameObject.ImageYScale = ((m_ResizingStartPos.y - GameObject.y) / GameObject.SpriteAsset.Size.y) + m_ResizingStartScale.y;
				break;
			default:
			}
		}
		if (m_Moving)
		{
			GameObject.x = cursorWorldPos.x - m_StartMovingOffset.x;
			GameObject.y = cursorWorldPos.y - m_StartMovingOffset.y;
			if (snapping)
			{
				GameObject.x = Mathf.Round2Nearest(GameObject.x, snapSize.x);
				GameObject.y = Mathf.Round2Nearest(GameObject.y, snapSize.y);
			}
		}
		
		if (RaylibBeef.Raylib.IsMouseButtonReleased((int32)RaylibBeef.MouseButton.MOUSE_BUTTON_LEFT))
		{
			m_Resizing = false;
			m_Moving = false;
		}
	}

	public void Draw(RaylibBeef.Camera2D editorCamera)
	{
		let gameobject = GameObject;
		if (gameobject.HasSprite())
		{
			FantyEngine.Fanty.DrawSpriteExt(
				gameobject.GameObjectAsset.SpriteAssetName,
				0,
				.(gameobject.x, gameobject.y),
				.(gameobject.xOrigin, gameobject.yOrigin),
				.(gameobject.ImageXScale, gameobject.ImageYScale), gameobject.ImageAngle);
		}
		else
		{
			RaylibBeef.Raylib.DrawCircle((int32)gameobject.x, (int32)gameobject.y, 16, Color.gray);
			RaylibBeef.Raylib.DrawText("?", (int32)gameobject.x - 4, (int32)gameobject.y - 6, 16, Color.white);
		}
	}

	public void DrawGui(RaylibBeef.Camera2D editorCamera, Vector2 cursorPos, Vector2 cursorWorldPos)
	{
		var hoveringSide = ResizingSide.None;

		if (IsSelected())
		{
			let bbox = GameObject.Bounds;
			let minScreen = RaylibBeef.Raylib.GetWorldToScreen2D(.(bbox.left, bbox.top), editorCamera);
			let maxScreen = RaylibBeef.Raylib.GetWorldToScreen2D(.(bbox.right, bbox.bottom), editorCamera);
			let gameobjectScreenPosMin = Vector2(minScreen.x, minScreen.y);
			let gameobjectScreenPosMax = Vector2(maxScreen.x, maxScreen.y);

			RoomEditor.DrawRectangle(.(
				gameobjectScreenPosMin.x,
				gameobjectScreenPosMin.y,
				gameobjectScreenPosMax.x - gameobjectScreenPosMin.x,
				gameobjectScreenPosMax.y - gameobjectScreenPosMin.y),
				Color.blue, 2);
			RoomEditor.DrawRectangle(.(gameobjectScreenPosMin.x - 4, gameobjectScreenPosMin.y - 4, 8, 8), FantyEngine.Color.blue, 2); // top left
			RoomEditor.DrawRectangle(.(gameobjectScreenPosMin.x - 4, gameobjectScreenPosMax.y - 4, 8, 8), FantyEngine.Color.blue, 2); // bottom left
			RoomEditor.DrawRectangle(.(gameobjectScreenPosMax.x - 4, gameobjectScreenPosMin.y - 4, 8, 8), FantyEngine.Color.blue, 2); // top right
			RoomEditor.DrawRectangle(.(gameobjectScreenPosMax.x - 4, gameobjectScreenPosMax.y - 4, 8, 8), FantyEngine.Color.blue, 2); // bottom right

			let mouseRightSide = Mathf.IsWithin(cursorPos.x, gameobjectScreenPosMax.x - 4, gameobjectScreenPosMax.x + 4)
				&& Mathf.IsWithin(cursorPos.y, gameobjectScreenPosMin.y, gameobjectScreenPosMax.y);
			let mouseLeftSide = Mathf.IsWithin(cursorPos.x, gameobjectScreenPosMin.x - 4, gameobjectScreenPosMin.x + 4)
				&& Mathf.IsWithin(cursorPos.y, gameobjectScreenPosMin.y, gameobjectScreenPosMax.y);

			let mouseTopSide = Mathf.IsWithin(cursorPos.x, gameobjectScreenPosMin.x, gameobjectScreenPosMax.x)
				&& Mathf.IsWithin(cursorPos.y, gameobjectScreenPosMin.y - 4, gameobjectScreenPosMin.y + 4);
			let mouseBottomSide = Mathf.IsWithin(cursorPos.x, gameobjectScreenPosMin.x, gameobjectScreenPosMax.x)
				&& Mathf.IsWithin(cursorPos.y, gameobjectScreenPosMax.y - 4, gameobjectScreenPosMax.y + 4);

			if (mouseRightSide) hoveringSide = .Right;
			if (mouseLeftSide) hoveringSide = .Left;
			if (mouseTopSide) hoveringSide = .Top;
			if (mouseBottomSide) hoveringSide = .Bottom;

			if (RaylibBeef.Raylib.IsMouseButtonPressed((int32)RaylibBeef.MouseButton.MOUSE_BUTTON_LEFT))
			{
				if (mouseRightSide)
				{
					m_Resizing = true;
					m_ResizingSide = .Right;
				}
				else if (mouseLeftSide)
				{
					m_Resizing = true;
					m_ResizingSide = .Left;
				}
				else if (mouseBottomSide)
				{
					m_Resizing = true;
					m_ResizingSide = .Bottom;
				}
				else if (mouseTopSide)
				{
					m_Resizing = true;
					m_ResizingSide = .Top;
				}
				else
				{
					if (Mathf.IsWithin(cursorPos.x, gameobjectScreenPosMin.x, gameobjectScreenPosMax.x)
						&& Mathf.IsWithin(cursorPos.y, gameobjectScreenPosMin.y, gameobjectScreenPosMax.y))
					{
						m_Moving = true;
						m_StartMovingOffset = .(cursorWorldPos.x - GameObject.x, cursorWorldPos.y - GameObject.y);
					}
				}

				if (m_Resizing)
				{
					m_ResizingStartMousePos = .(cursorWorldPos.x, cursorWorldPos.y);
					m_ResizingStartScale = .(GameObject.ImageXScale, GameObject.ImageYScale);
					m_ResizingStartPos = .(GameObject.x, GameObject.y);
				}
			}
		}

		if (!m_Moving)
		{
			if (m_Resizing)
			{
				switch (m_ResizingSide)
				{
				case .Left:
					RaylibBeef.Raylib.SetMouseCursor((int32)RaylibBeef.MouseCursor.MOUSE_CURSOR_RESIZE_EW);
					break;
				case .Right:
					RaylibBeef.Raylib.SetMouseCursor((int32)RaylibBeef.MouseCursor.MOUSE_CURSOR_RESIZE_EW);
					break;
				case .Top:
					RaylibBeef.Raylib.SetMouseCursor((int32)RaylibBeef.MouseCursor.MOUSE_CURSOR_RESIZE_NS);
					break;
				case .Bottom:
					RaylibBeef.Raylib.SetMouseCursor((int32)RaylibBeef.MouseCursor.MOUSE_CURSOR_RESIZE_NS);
				default:
				}
			}
			if (hoveringSide != .None)
			{
				switch (hoveringSide)
				{
				case .Left:
					RaylibBeef.Raylib.SetMouseCursor((int32)RaylibBeef.MouseCursor.MOUSE_CURSOR_RESIZE_EW);
					break;
				case .Right:
					RaylibBeef.Raylib.SetMouseCursor((int32)RaylibBeef.MouseCursor.MOUSE_CURSOR_RESIZE_EW);
					break;
				case .Top:
					RaylibBeef.Raylib.SetMouseCursor((int32)RaylibBeef.MouseCursor.MOUSE_CURSOR_RESIZE_NS);
					break;
				case .Bottom:
					RaylibBeef.Raylib.SetMouseCursor((int32)RaylibBeef.MouseCursor.MOUSE_CURSOR_RESIZE_NS);
				default:
				}
				m_HoveringResize = true;
			}
			else
				m_HoveringResize = false;
		}
		else
		{
			RaylibBeef.Raylib.SetMouseCursor((int32)RaylibBeef.MouseCursor.MOUSE_CURSOR_RESIZE_ALL);

		}
	}

	public void LateUpdate()
	{
		if (IsSelected())
		{
			if (RaylibBeef.Raylib.IsKeyPressed((int32)RaylibBeef.KeyboardKey.KEY_DELETE))
			{
				RoomEditor.RemoveGameObject(this);
				return;
			}
		}
	}

	private bool IsSelected()
	{
		return RoomEditor.[Friend]m_Selection.IsSelected(this);
	}
}