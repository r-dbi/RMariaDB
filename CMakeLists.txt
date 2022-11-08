cmake_minimum_required(VERSION 3.14)

project(RMariaDB VERSION 0.1.0)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/")
include(Misc)

add_subdirectory(src)
