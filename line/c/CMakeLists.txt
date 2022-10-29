cmake_minimum_required(VERSION 3.6 FATAL_ERROR)

project(geofit LANGUAGES C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_C_STANDARD_REQUIRED ON)

find_package(PkgConfig REQUIRED) # QUIET)
pkg_search_module(CMOCKA REQUIRED cmocka)

# Ref: https://stackoverflow.com/questions/44821615/linking-gsl-in-cmakelists-txt
add_library(geofit STATIC
  fitline.c
  fitline.h
  pt.c
  pt.h
  vertical.c
  vertical.h
  )

find_package(GSL REQUIRED)
target_link_libraries(geofit  GSL::gsl GSL::gslcblas)

add_executable(demo 
  main.c
  )

target_link_libraries(demo geofit)

add_executable(test
  test_main.c
  test_line.c
  test_vertical.c
  test_pt.c
  )

target_link_libraries(test geofit cmocka)
