#include <iostream>
#include <BRepPrimAPI_MakeBox.hxx>
#include <TopoDS_Shape.hxx>
#include "raylib.h"
#define RAYGUI_IMPLEMENTATION
#include "raygui.h"

int main() {
    TopoDS_Shape box = BRepPrimAPI_MakeBox(100, 50, 25).Shape();

    std::cout << "Box created successfully!" << std::endl;


    // Initialization
    InitWindow(800, 450, "Hello Raylib + Raygui");

    SetTargetFPS(60);

    while (!WindowShouldClose()) {
        BeginDrawing();
        ClearBackground(RAYWHITE);

        // Draw Hello World using Raygui
        GuiLabel((Rectangle){350, 220, 100, 20}, "Box created successfully!");

        EndDrawing();
    }

    CloseWindow();

    return 0;
}
