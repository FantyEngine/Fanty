using System;
namespace FantyEngine;

public class Asset
{
	private String m_FileLocation = new .() ~ delete _;

	/// Real location on the filesystem (Only in editor and debug builds)
	public String FileLocation
	{
		get
		{
			return m_FileLocation;
		}
		set
		{
			m_FileLocation = value;
		}
	}
}