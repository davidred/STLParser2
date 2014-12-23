##STL Parser

The STL file format is widely used across different 3D printing and modeling interfaces. It describes a surface composed of a number of triangles. The triangles are represented by a unit normal and list of 3 cartesian coordinates that make up each triangle.

This Ruby program parses an STL file and returns the number of faces (triangles), and unique vertices that are in the file.

##Install Instructions

- Clone the repository and run bundle install
- Type rspec to run tests
- Type bin/STLParser to run program
- To parse another STL file, copy it into the data folder and name it 'cube.stl'

##How it works

An STL File is made up of a lot of these triangles:

```
facet normal ni nj nk
  outer loop
    vertex v1x v1y v1z
    vertex v2x v2y v2z
    vertex v3x v3y v3z
  endloop
endfacet
```

The STL file is parsed and each facet normal increments the number of faces by one. Vertices are kept track of in a key-lookup. Any unique vertex encountered increments the number of vertices by one. Once the end of the file is reached, the number of vertices and faces is returned.
