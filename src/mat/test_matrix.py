import mat


def test_shape():
    m = mat.Matrix(3, 4)
    assert m.shape() == (3, 4)
