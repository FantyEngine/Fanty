using System;

namespace FantyEngine;

[AttributeUsage(.Class, .ReflectAttribute, ReflectUser=.All, AlwaysIncludeUser=.All)]
public struct RegisterGameObjectAttribute : Attribute
{
	public String Name;

	public this(String name)
	{
		this.Name = name;
	}
}