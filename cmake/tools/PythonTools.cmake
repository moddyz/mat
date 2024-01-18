include(CXXTools)

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

    # Install the built library.
    install(
        TARGETS ${TARGET_NAME}
        LIBRARY DESTINATION pylib
        ARCHIVE DESTINATION pylib
    )

endfunction() # cpp_library
