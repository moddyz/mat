cpp_shared_library(mat
    CPPFILES
        matrix.cpp
    PUBLIC_HEADERS
        matrix.h
        type_name.h
)

pybind11_module(mat
    TYPE
        SHARED
    CPPFILES
        py_module.cpp
        py_matrix.cpp
    LIBRARIES
        mat
)

python_test(test_matrix test_matrix.py)
