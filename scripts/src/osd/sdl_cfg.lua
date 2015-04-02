forcedincludes {
	MAME_DIR .. "src/osd/sdl/sdlprefix.h"
}

if SDL_NETWORK~="" and not _OPTIONS["DONT_USE_NETWORK"] then
	defines {
		"USE_NETWORK",
		"OSD_NET_USE_" .. string.upper(SDL_NETWORK),
	}
end

if _OPTIONS["NO_OPENGL"]~="1" and _OPTIONS["USE_DISPATCH_GL"]~="1" and _OPTIONS["MESA_INSTALL_ROOT"] then
	includedirs {
		path.join(_OPTIONS["MESA_INSTALL_ROOT"],"include"),
	}
end


if _OPTIONS["NO_X11"]=="1" then
	defines {
		"SDLMAME_NO_X11",
	}
else
	defines {
		"SDLMAME_X11",
	}
	includedirs {
		"/usr/X11/include",
		"/usr/X11R6/include",
		"/usr/openwin/include",
	}
end

if _OPTIONS["NO_USE_XINPUT"]=="1" then
	defines {
		"USE_XINPUT=0",
	}
else
	defines {
		"USE_XINPUT=1",
		"USE_XINPUT_DEBUG=0",
	}
end

if _OPTIONS["NO_USE_MIDI"]~="1" and _OPTIONS["targetos"]=="linux" then
	buildoptions {
		backtick("pkg-config --cflags alsa"),
	}
end

if _OPTIONS["SDL_LIBVER"]=="sdl2" then
	defines {
		"SDLMAME_SDL2=1",
	}
	if _OPTIONS["SDL2_MULTIAPI"]=="1" then
		defines {
			"SDL2_MULTIAPI",
		}
	end
else
	defines {
		"SDLMAME_SDL2=0",
	}
end

defines {
	"OSD_SDL",
	"SYNC_IMPLEMENTATION=" .. SYNC_IMPLEMENTATION,
}

if BASE_TARGETOS=="unix" then
	defines {
		"SDLMAME_UNIX",
	}
	if _OPTIONS["targetos"]=="macosx" then
		if _OPTIONS["MACOSX_USE_LIBSDL"]~="1" then
			buildoptions {
				"-F" .. _OPTIONS["SDL_FRAMEWORK_PATH"],
			}
		else
			defines {
				"NO_SDL_GLEXT",
				"MACOSX_USE_LIBSDL",
			}
			buildoptions {
				backtick(sdlconfigcmd() .. " --cflags | sed 's:/SDL::'"),
			}
		end
	else
		buildoptions {
			backtick(sdlconfigcmd() .. " --cflags"),
		}
		if _OPTIONS["targetos"]~="emscripten" then
			buildoptions {
				backtick("pkg-config --cflags fontconfig"),
			}
		end
	end
end

if _OPTIONS["targetos"]=="windows" then
	defines {
		"UNICODE",
		"_UNICODE",
		"main=utf8_main",
	}

	configuration { "vs*" }
		includedirs {
			path.join(_OPTIONS["SDL_INSTALL_ROOT"],"include")
		}
	configuration { }

elseif _OPTIONS["targetos"]=="linux" then
	buildoptions {
		'$(shell pkg-config --cflags QtGui)',
	}
elseif _OPTIONS["targetos"]=="macosx" then
	defines {
		"SDLMAME_MACOSX",
		"SDLMAME_DARWIN",
	}
elseif _OPTIONS["targetos"]=="freebsd" then
	buildoptions {
		-- /usr/local/include is not considered a system include director on FreeBSD.  GL.h resides there and throws warnings
		"-isystem /usr/local/include",
	}
elseif _OPTIONS["targetos"]=="os2" then
	buildoptions {
		backtick(sdlconfigcmd() .. " --cflags"),
	}
end
