set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# clang-format support
function(add_clang_format_target)
    set(options)
    set(oneValueArgs)
    set(multiValueArgs SOURCES)
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}"
                          "${multiValueArgs}" ${ARGN})
    if(NOT ${PROJECT_NAME}_CLANG_FORMAT_BINARY)
			find_program(${PROJECT_NAME}_CLANG_FORMAT_BINARY clang-format)
    endif()

    message(STATUS ${ARG_SOURCES})

    if(${PROJECT_NAME}_CLANG_FORMAT_BINARY)
      add_custom_target(clang-format
          COMMAND ${${PROJECT_NAME}_CLANG_FORMAT_BINARY} --verbose
          -i ${ARG_SOURCES}
          WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR})

			message(STATUS "Format the project using the `clang-format` target (i.e: cmake --build build --target clang-format).\n")
    endif()
endfunction()
