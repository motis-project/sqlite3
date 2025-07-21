if (NOT TARGET SQLite::SQLite3)
    message(FATAL_ERROR "SQLite3::SQLite3 target not found. Check pkg config.")
endif ()

get_target_property(_inc SQLite::SQLite3 INTERFACE_INCLUDE_DIRECTORIES)

set(SQLite3_INCLUDE_DIRS "${_inc}" PARENT_SCOPE)
set(SQLite3_LIBRARIES SQLite::SQLite3 PARENT_SCOPE)
set(SQLite3_FOUND TRUE PARENT_SCOPE)

# From default FindSQLite3.cmake
foreach (_d ${_inc})
    if (EXISTS "${_d}/sqlite3.h")
        file(STRINGS "${_d}/sqlite3.h" _line
                REGEX "^#define SQLITE_VERSION[ \t]+\"[0-9]+\\.[0-9]+\\.[0-9]+\""
                LIMIT_COUNT 1)
        string(REGEX MATCH "[0-9]+\\.[0-9]+\\.[0-9]+"
                _ver "${_line}")
        if (_ver)
            set(SQLite3_VERSION "${_ver}" PARENT_SCOPE)
        endif ()
        break()
    endif ()
endforeach ()
