# Project options.

include(CMakePrintHelpers)

option(BUILD_TESTING "Build & run automated tests." OFF)
option(BUILD_DOCUMENTATION "Build doxygen documentation." OFF)
option(BUILD_PYTHON_BINDINGS "Build python bindings." ON)

cmake_print_variables(BUILD_TESTING BUILD_DOCUMENTATION BUILD_PYTHON_BINDINGS)
