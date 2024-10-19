#define NOMINMAX

#include <iostream>
#include <string>
#include <filesystem>

#include "LuaFilesApi.h"
#include "lua.hpp"

namespace lua {
	int lua_SetClipboard(lua_State* L) {
		std::string str = luaL_checkstring(L, 1);
		lua_pushboolean(L, fn::SetClipboard(str));
		return 1;
	}

	int lua_GetClipboard(lua_State* L) {
		lua_pushstring(L, fn::GetClipboard().c_str());
		return 1;
	}
}

static luaL_Reg luaLibs[] = {
	{ "CurrentPath", lua::lua_CurrentPath},
	{ "GetDirectoryPath", lua::lua_GetDirectoryPath},
	{ "GetDirectoryPathAll", lua::lua_GetDirectoryPathAll},
	{ "GetAbsPath", lua::lua_GetAbsPath},
	{ "PathGetFileName", lua::lua_PathGetFileName},
	{ "PathExists", lua::lua_PathExists},
	{ "CreateDir", lua::lua_CreateDir},
	{ "Rename", lua::lua_Rename},

	{ "SetClipboard", lua::lua_SetClipboard},
	{ "GetClipboard", lua::lua_GetClipboard},

	{ NULL, NULL }
};

extern "C" __declspec(dllexport)
int luaopen_WandViewerDll(lua_State* L) {
	luaL_register(L, "WandViewerDll", luaLibs);  //注册函数，参数2是模块名
	return 1;
}
