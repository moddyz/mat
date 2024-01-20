#include <pybind11/pybind11.h>
#include <pybind11/stl.h>

#include <sstream>

#include <mat/matrix.h>

void bind_Matrix( pybind11::module& module )
{
    using MatrixT = mat::Matrix< float >;

    pybind11::class_< MatrixT > cls( module, "Matrix" );

    cls.def( pybind11::init< size_t, size_t >() );
    cls.def( "shape",
             []( const MatrixT& m )
             {
                 MatrixT::shape_type shape = m.shape();
                 return pybind11::make_tuple( shape[ 0 ], shape[ 1 ] );
             } );
    cls.def( "__repr__",
             []( const MatrixT& m )
             {
                 std::stringstream ss;
                 ss << "<Matrix shape=(" << m.shape()[ 0 ] << ", " << m.shape()[ 1 ] << ")>";

                 return ss.str();
             } );
}
