cmake_minimum_required(VERSION 3.6 FATAL_ERROR)

project(geofit LANGUAGES C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_C_STANDARD_REQUIRED ON)

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

