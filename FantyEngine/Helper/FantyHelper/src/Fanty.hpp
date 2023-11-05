#pragma once

#ifdef FANTY_PLATFORM_WINDOWS
	#ifdef FANTY_BUILD_DLL
		#define FANTY_API __declspec(dllexport)
	#else
		#define FANTY_API // __declspec(dllimport) // Might be fucky
	#endif
	#else
		#error Fanty only supports Windows
#endif

#ifdef FANTY_ENABLE_ASSERTS
	#define FANTY_CORE_ASSERT(x, ...) { if(!(x)) { FANTY_CORE_ERROR("Assertion Failed {0}", __VA_ARGS__); __debugbreak(); } }
	#define FANTY_ASSERT(x, ...) { if(!x)) { FANTY_ERROR("Assertion Failed {0}", __VA_ARGS__); __debugbreak(); } }
#else
	#define FANTY_ASSERT(x, ...)
	#define FANTY_CORE_ASSERT(x, ...)
#endif

#define BIT(x) (1 << x)

// IMGUI
#include <imgui.h>
#include <imgui_impl_glfw.h>
#include <imgui_impl_opengl3.h>
#include <IconsFontAwesome6.h>

extern "C" {
	#include "Extensions/cimguiextensions.h"

	// RAYLIB
	#define BUILD_LIBTYPE_SHARED
	#include <raylib.h>
	#include <rlgl.h>
	#include <raymath.h>

	// GLFW
	#include <GLFW/glfw3.h>
}