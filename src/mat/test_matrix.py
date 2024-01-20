import mat


def test_str():
    m = mat.Matrix.identity(4)
    expect = """
Matrix< float >(
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
)""".strip()
    assert str(m) == expect



def test_shape():
    m = mat.Matrix(3, 4)
    assert m.data_type == "float"


def test_shape():
    m = mat.Matrix(3, 4)
    assert m.shape == (3, 4)
