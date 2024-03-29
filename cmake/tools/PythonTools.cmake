include(CXXTools)

set(PYTHON_LIB_DIR "pylib")

# Specifies that this project needs a particular python module.
# Will raise a FATAL_ERROR if the module cannot be imported.
function(
    require_python_import
    MODULE_NAME
)

    execute_process(
        COMMAND ${Python_EXECUTABLE} -c "import ${MODULE_NAME}"
        RESULT_VARIABLE PYTHON_RESULT
        OUTPUT_VARIABLE PYTHON_STDOUT
        ERROR_VARIABLE PYTHON_STDERR
    )


    if (NOT PYTHON_RESULT EQUAL 0)
        message(FATAL_ERROR ${PYTHON_STDOUT} ${PYTHON_STDERR} "Please make sure the ${MODULE_NAME} python module is installed on your system.\n")
    endif()

endfunction()

# Builds a pybind11-based C++ python module.
#
# pybind11 will need to be made available as an imported library.
function(
    pybind11_module
    MODULE_NAME
)
    set(options)
    set(oneValueArgs
        TYPE
    )
    set(multiValueArgs
        CPPFILES
        INCLUDE_PATHS
        LIBRARIES
        DEFINES
    )

    cmake_parse_arguments(
        args
        "${options}"
        "${oneValueArgs}"
        "${multiValueArgs}"
        ${ARGN}
    )

    # Add a prefix to avoid conflict(s) between C++ targets and python target names.
    # Other targets should not be linking against python plugins anyway, so it is ok
    # if the target name is obfuscated.
    set(TARGET_NAME _${MODULE_NAME})

    # Add a new shared library target.
    add_library(${TARGET_NAME}
        SHARED
        ${args_CPPFILES}
    )

    # Apply properties.
    _cpp_target_properties(${TARGET_NAME}
        INCLUDE_PATHS
            ${args_INCLUDE_PATHS}
        DEFINES
            ${args_DEFINES}
        LIBRARIES
            ${args_LIBRARIES}
            pybind11
            Python::Module
    )

    # Strip lib prefix.
    set_target_properties(${TARGET_NAME} PROPERTIES PREFIX "")

    # Set library name (due to prefixed target name).
    set_target_properties(${TARGET_NAME}
        PROPERTIES
            OUTPUT_NAME ${MODULE_NAME}
    )

    # Mirror installation structure under binary tree to make it easier to setup the runtime environments for tests.
    add_custom_command(
        TARGET ${TARGET_NAME}
        POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E make_directory ${PROJECT_BINARY_DIR}/${PYTHON_LIB_DIR}
            COMMAND ${CMAKE_COMMAND} -E create_symlink $<TARGET_FILE:${TARGET_NAME}> ${PROJECT_BINARY_DIR}/${PYTHON_LIB_DIR}/$<TARGET_FILE_NAME:${TARGET_NAME}>
    )

    # Install the built library.
    install(
        TARGETS ${TARGET_NAME}
        LIBRARY DESTINATION ${PYTHON_LIB_DIR}
        ARCHIVE DESTINATION ${PYTHON_LIB_DIR}
    )

endfunction() # cpp_library

# Adds a python file that is executed as a test.
function(python_test TARGET_NAME PYTHON_FILE)

    if (NOT BUILD_PYTHON_BINDINGS)
        message(STATUS "Skipping python tests.")
        return()
    endif()

    # Can we find the python executable
    if (NOT ${Python_Interpreter_FOUND})
        message(STATUS "Project is not configured with ${Python_EXECUTABLE}")
        return()
    endif()

    # Make sure pytest is importable.
    require_python_import("pytest")

    # Add a new test target.
    add_test(
        NAME ${TARGET_NAME}
        COMMAND ${Python_EXECUTABLE} -m pytest -s -vv ${PYTHON_FILE}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )

    # Set-up runtime environment variables for the test.
    set(TEST_ENV_VARS "")
    set(TEST_PYTHON_PATH "$ENV{PYTHONPATH}")
    if (MSVC)
        string(REGEX REPLACE "\\\\" "/" TEST_PYTHON_PATH "${TEST_PYTHON_PATH}")
    endif()
    string(PREPEND TEST_PYTHON_PATH "PYTHONPATH=")
    list(APPEND TEST_PYTHON_PATH
        "${PROJECT_BINARY_DIR}/${PYTHON_LIB_DIR}"
    )

    list(APPEND TEST_ENV_VARS "${TEST_PYTHON_PATH}")
    list(JOIN TEST_ENV_VARS ":" TEST_ENV_VARS)

    # Set the
    set_tests_properties(${TARGET_NAME}
        PROPERTIES
            ENVIRONMENT
            "${TEST_ENV_VARS}"
    )

endfunction()
