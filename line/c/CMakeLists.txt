cmake_minimum_required(VERSION 3.6 FATAL_ERROR)

project(geofit LANGUAGES C)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_C_STANDARD_REQUIRED ON)

# Ref: https://stackoverflow.com/questions/44821615/linking-gsl-in-cmakelists-txt
set(SOURCE_FILES 
  fitline.c
  main.c
  pt.c 
  vertical.c 
)

add_executable(demo ${SOURCE_FILES})

find_package(GSL REQUIRED)
target_link_libraries(demo  GSL::gsl GSL::gslcblas)


