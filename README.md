<a href="https://github.com/moddyz/mat/actions?query=workflow%3A%22Build+and+test%22"><img src="https://github.com/moddyz/mat/workflows/Build%20and%20test/badge.svg"/></a>

# mat

C++ & python linear algebra library.  Developed as part of learning linear algebra.

## Table of Contents

- [Dependencies](#dependencies)
- [Building](#building)
- [Template usage](#template-usage)

### Dependencies

The following dependencies are mandatory:
- C++ compiler
- [CMake](https://cmake.org/documentation/) (3.12 or greater)

The following dependencies are optional:
- [Doxygen](https://www.doxygen.nl/index.html) and [graphviz](https://graphviz.org/) for documentation.

## Building

Example snippet for building this project:
```
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX="~/install/mat/" ..
cmake --build  . -- VERBOSE=1 -j8 all test install
```
CMake options for configuring this project:

| CMake Variable name     | Description                                                            | Default |
| ----------------------- | ---------------------------------------------------------------------- | ------- |
| `BUILD_TESTING`         | Enable automated testing.                                              | `OFF`   |
| `BUILD_DOCUMENTATION`   | Build documentation.                                                   | `OFF`   |
