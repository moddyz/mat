#pragma once

#include <stddef.h>
#include <tuple>
#include <vector>

#include <mat/type_name.h>

namespace mat
{

/// \class Matrix
///
/// An N by M dense matrix.
///
/// \tparam DataT data type of the elements in the matrix.
template < typename DataT = float >
class Matrix final
{
public:
    /// \var data_type
    ///
    /// Type definition for the value type of the matrix elements.
    using data_type = DataT;

    /// \var shape_type
    ///
    /// Type definition for the shape type of the matrix elements.
    using shape_type = std::array< size_t, 2 >;

    /// \var matrix_type
    ///
    /// Type definition for the current matrix.
    using matrix_type = Matrix< DataT >;

    //-------------------------------------------------------------------------
    /// \name Construction
    //-------------------------------------------------------------------------

    /// Initialize a matrix with all zeroes.
    Matrix( size_t num_rows, size_t num_cols )
        : _shape{ num_rows, num_cols }
    {
        reallocate( num_rows * num_cols );
    }

    /// Creates an identity matrix of N by N dimensions.
    static matrix_type identity( size_t dim )
    {
        matrix_type matrix( dim, dim );
        for ( size_t idx = 0; idx < dim; ++idx )
        {
            matrix( idx, idx ) = 1.0;
        }
        return matrix;
    }

    //-------------------------------------------------------------------------
    /// \name Shape
    //-------------------------------------------------------------------------

    /// Returns the shape of the matrix.
    const shape_type& shape() const
    {
        return _shape;
    }

    /// Get the number of rows in this matrix
    size_t num_elements() const
    {
        return _elements.size();
    }

    /// Get the number of rows in this matrix
    size_t num_rows() const
    {
        return _shape[ 0 ];
    }

    /// Get the number of columns in this matrix
    size_t num_cols() const
    {
        return _shape[ 1 ];
    }

    //-------------------------------------------------------------------------
    /// \name Element access
    //-------------------------------------------------------------------------

    /// Matrix element read-access by row & column indices.
    ///
    /// \param row row of the element
    /// \param col column of the element
    ///
    /// \return the element at (row, col)
    const DataT& operator()( size_t row, size_t col ) const
    {
        return _elements[ row * num_cols() + col ];
    }

    /// Matrix element write-access by row & column indices.
    ///
    /// \param row row of the element
    /// \param col column of the element
    ///
    /// \return the element at (row, col)
    DataT& operator()( size_t row, size_t col )
    {
        return _elements[ row * num_cols() + col ];
    }

    /// Matrix element single-index read-access (row major).
    ///
    /// \param idx row of the element
    ///
    /// \return the element
    const DataT& operator()( size_t idx ) const
    {
        return _elements[ idx ];
    }

    /// Matrix element write-index read-access (row major).
    ///
    /// \param idx row of the element
    ///
    /// \return the element
    DataT& operator()( size_t idx )
    {
        return _elements[ idx ];
    }

    //-------------------------------------------------------------------------
    /// \name Serialization
    //-------------------------------------------------------------------------

    std::string to_str() const
    {
        std::stringstream ss;
        ss << "Matrix< " << std::string( type_name< data_type >() ).c_str() << " >(";
        for ( size_t row_idx = 0; row_idx < num_rows(); ++row_idx )
        {
            ss << "\n    ";
            for ( size_t col_idx = 0; col_idx < num_cols(); ++col_idx )
            {
                ss << _elements[ row_idx * num_cols() + col_idx ];
                if ( col_idx + 1 < num_cols() )
                {
                    ss << ", ";
                }
            }

            if ( row_idx + 1 < num_rows() )
            {
                ss << ",";
            }
        }
        ss << "\n)";
        return ss.str();
    }

private:
    // Clear and resize the internal buffer.
    void reallocate( size_t num_elements )
    {
        _elements.clear();
        _elements.resize( num_elements, 0 );
    }

    // Shape of the matrix.
    shape_type _shape;

    // Internal buffer storing the matrix elements.
    std::vector< DataT > _elements;
};

}; // namespace mat
