cmake_minimum_required(VERSION 3.22)

project(sqlite3 LANGUAGES C)

list(PREPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} PARENT_SCOPE)

file(STRINGS "${CMAKE_CURRENT_SOURCE_DIR}/sqlite3.h" _ver_line
        REGEX "^#define SQLITE_VERSION  *\"[0-9]+\\.[0-9]+\\.[0-9]+\""
        LIMIT_COUNT 1)
string(REGEX MATCH "[0-9]+\\.[0-9]+\\.[0-9]+"
        SQLITE3_PROJECT_VERSION "${_ver_line}")
unset(_ver_line)

add_library(sqlite3 STATIC sqlite3.c)
add_library(SQLite::SQLite3 ALIAS sqlite3)
target_include_directories(sqlite3 SYSTEM PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

if(UNIX)
    find_library(M_LIB m)
    if(M_LIB)
        target_link_libraries(sqlite3 PRIVATE -lm)
    endif()
endif()

add_executable(sqlite3-cli shell.c)
set_target_properties(sqlite3-cli PROPERTIES OUTPUT_NAME sqlite3)
target_link_libraries(sqlite3-cli PRIVATE sqlite3)

set(SQLite3_FOUND TRUE PARENT_SCOPE)
set(SQLite3_VERSION ${SQLITE3_PROJECT_VERSION} PARENT_SCOPE)
set(SQLite3_INCLUDE_DIRS ${CMAKE_CURRENT_SOURCE_DIR} PARENT_SCOPE)
set(SQLite3_LIBRARIES SQLite::SQLite3 PARENT_SCOPE)
