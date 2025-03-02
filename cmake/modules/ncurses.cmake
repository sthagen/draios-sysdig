#
# ncurses, keep it simple for the moment
#
option(USE_BUNDLED_NCURSES "Enable building of the bundled ncurses" ${USE_BUNDLED_DEPS})

if(CURSES_INCLUDE_DIR)
	# we already have ncurses
elseif(NOT USE_BUNDLED_NCURSES)
	set(CURSES_NEED_NCURSES TRUE)
	find_package(Curses REQUIRED)
	message(STATUS "Found ncurses: include: ${CURSES_INCLUDE_DIR}, lib: ${CURSES_LIBRARIES}")
else()
	set(CURSES_BUNDLE_DIR "${PROJECT_BINARY_DIR}/ncurses-prefix/src/ncurses")
	set(CURSES_INCLUDE_DIR "${CURSES_BUNDLE_DIR}/include/")
	set(CURSES_LIBRARIES "${CURSES_BUNDLE_DIR}/lib/libncursesw.a")

	if(NOT TARGET ncurses)
		message(STATUS "Using bundled ncurses in '${CURSES_BUNDLE_DIR}'")

		ExternalProject_Add(ncurses
			PREFIX "${PROJECT_BINARY_DIR}/ncurses-prefix"
			URL "https://ftp.gnu.org/gnu/ncurses/ncurses-6.5.tar.gz"
			URL_MD5 "ac2d2629296f04c8537ca706b6977687"
			CONFIGURE_COMMAND ./configure --without-cxx --without-cxx-binding --without-ada --without-manpages --without-progs --without-tests --with-terminfo-dirs=/etc/terminfo:/lib/terminfo:/usr/share/terminfo
			BUILD_COMMAND ${CMD_MAKE}
			BUILD_IN_SOURCE 1
			BUILD_BYPRODUCTS ${CURSES_LIBRARIES}
			INSTALL_COMMAND "")
	endif()
endif()

include_directories("${CURSES_INCLUDE_DIR}")
