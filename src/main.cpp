
#include <iostream>

// Include OpenCascade headers
#include <BRepPrimAPI_MakeBox.hxx>
#include <TopoDS_Shape.hxx>

int main() {
    // Create a box using OpenCascade
    TopoDS_Shape box = BRepPrimAPI_MakeBox(100, 50, 25).Shape();

    std::cout << "Box created successfully!" << std::endl;

    return 0;
}
