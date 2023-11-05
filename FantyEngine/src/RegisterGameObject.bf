using System;

namespace FantyEngine;

[AttributeUsage(.Class, .ReflectAttribute, ReflectUser=.All)]
public struct RegisterGameObjectAttribute : Attribute
{
	public String Name;

	public this(String name)
	{
		this.Name = name;
	}
}