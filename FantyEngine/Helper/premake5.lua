workspace "FantyHelper"
	architecture "x64"
	startproject "FantyHelper"

	configurations
	{
		"Debug",
		"Release"
	}

	flags
	{
		"MultiProcessorCompile"
	}
	
outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

IncludeDir = {}

LibraryDir = {}

Library = {}

-- Windows
Library["WinMM"] = "Winmm.lib"
Library["WinSock"] = "Ws2_32.lib"
Library["WinVersion"] = "Version.lib"
Library["BCrypt"] = "Bcrypt.lib"

project "FantyHelper"
	location "FantyHelper"
    kind "StaticLib"
    language "C++"
    cppdialect "C++17"
    staticruntime "On"

    targetdir ("%{wks.location}/bin/" .. outputdir .. "/%{prj.name}")
    objdir ("%{wks.location}/bin-int/" .. outputdir .. "/%{prj.name}")

    files
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.c",
        "%{prj.name}/src/**.hpp",
        "%{prj.name}/src/**.cpp",

        "%{prj.name}/vendor/raylib/src/*.c",
        "%{prj.name}/vendor/raylib/src/*.h",
        "%{prj.name}/vendor/raylib/src/external/*.h",
        "%{prj.name}/vendor/raylib/src/external/*.c",

        "%{prj.name}/vendor/cimgui/*.h",
        "%{prj.name}/vendor/cimgui/*.cpp",
        "%{prj.name}/vendor/cimgui/generator/output/cimgui_impl.h",
        "%{prj.name}/vendor/cimgui/imgui/*.h",
        "%{prj.name}/vendor/cimgui/imgui/*.cpp",
        "%{prj.name}/vendor/cimgui/imgui/backends/imgui_impl_opengl3.h",
        "%{prj.name}/vendor/cimgui/imgui/backends/imgui_impl_opengl3.cpp",
        "%{prj.name}/vendor/cimgui/imgui/backends/imgui_impl_glfw.h",
        "%{prj.name}/vendor/cimgui/imgui/backends/imgui_impl_glfw.cpp",
        "%{prj.name}/vendor/cimgui/imgui/misc/fonts/**.h",
        "%{prj.name}/vendor/cimgui/imgui/misc/fonts/**.cpp",

		"%{prj.name}/vendor/imgui-fonts/*.h",
    }

    includedirs
    {
        "%{prj.name}/src",

		"%{prj.name}/vendor/raylib/src",
        "%{prj.name}/vendor/raylib/src/external",
        "%{prj.name}/vendor/raylib/src/external/glfw/include",

        "%{prj.name}/vendor/cimgui",
        "%{prj.name}/vendor/cimgui/imgui",
        "%{prj.name}/vendor/cimgui/imgui/backends",
		"%{prj.name}/vendor/imgui-fonts",
    }

    links
    {
        "opengl32.lib",
        "winmm"
    }

    defines
    {
        "_CRT_SECURE_NO_WARNINGS",
		"GLFW_INCLUDE_NONE"
    }

    filter "system:windows"
        systemversion "latest"

        defines
        {
            "FANTY_PLATFORM_WINDOWS", "FANTY_BUILD_DLL", "GRAPHICS_API_OPENGL_33", "PLATFORM_DESKTOP", "GRAPHICS_API_OPENGL_33", "_WINSOCK_DEPRECATED_NO_WARNINGS", "_WIN32"
        }

        links
        {
            "%{Library.WinMM}",
            "%{Library.WinSock}",
            "%{Library.WinVersion}",
            "%{Library.BCrypt}",
        }

		postbuildcommands
        {
            ("{COPY} %{cfg.buildtarget.relpath} " .. "%{wks.location}../libs/libs_x64/")
        }

    filter "configurations:Debug"
        runtime "Debug"
        buildoptions "/MTd"
        symbols "on"

    filter "configurations:Release"
        runtime "Release"
        buildoptions "/MT"
        optimize "on"