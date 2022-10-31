# Description
This is a C library that fits clouds of points to geometric features.  It is a work in progress.

| Geometric Feature | Status      |
| ----------------- | ----------- |
| Line              | In progress |
| Circle            | Planned     |
| Ellipse           | Planned     |
| Plane             | Maybe       |


# Dependencies

| Library    | Installation Instructions       |
|----------- | ------------------------------- |
| cmake      | sudo apt install cmake          |
| GSL        | sudo apt install libgsl-dev     |
| gslcblas   | (comes with gsl)                |
| cmocka     | sudo apt install libcmocka-dev  |
| pkg-config | sudo apt install pkg-config     |

# Build Instructions
1. Create a `build` directory under this directory.
1. `cd build`
1. `cmake ..`
1. `cmake --build .`

