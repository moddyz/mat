#include <pybind11/pybind11.h>

void bind_Matrix( pybind11::module& );

PYBIND11_MODULE( mat, module )
{
    module.doc() = "mat: linear algebra";

    bind_Matrix( module );
}
