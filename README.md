# d3gl

**d3m0n Graphical Library for Lua**

`d3gl` is a graphical library for Lua, designed for the d3m0n operating system. It provides a simple interface for creating graphical surfaces, drawing pixels, and updating the display.

Python support through CPython is planned.

## Features

- Create graphical surfaces with a custom width and height.
- Draw pixels using RGBA-style hexadecimal color constants.
- Update the surface to display your changes.
- Simple Lua API designed for graphics programming.
- Future support for Python.

## Requirements

- The d3m0n operating system.
- A working Lua runtime: [d3m0n-project/lua](https://github.com/d3m0n-project/lua).
- The `sys` Lua module provided by the operating system.
- The `d3gl` library installed in your Lua module path.

## Installation

Place the library in your Lua library directory:

```
/lib/lua/d3gl/
└── init.lua
```

If your Lua runtime uses `/lib/lua/?.lua` and `/lib/lua/?/init.lua` as module search paths, you can import the library with:

```
local d3gl = require("d3gl")
```

If your runtime does not handle the starting directory correctly, configure the module search path or use your system's Lua loader.

## Getting started

Create a file named `main.lua`:

```
local d3gl = require("d3gl")

-- Create a 320 x 448 (fullscreen) graphical surface.
d3gl.init(320, 448)

-- Draw a few pixels.
d3gl.putpixel(10, 10, d3gl.Colors.RED)
d3gl.putpixel(11, 10, d3gl.Colors.GREEN)
d3gl.putpixel(12, 10, d3gl.Colors.BLUE)

-- Display the changes.
d3gl.update()
```

Run the script using your d3m0n Lua interpreter:

```
lua main.lua
```

## API reference

### `d3gl.init(width, height)`

Creates a graphical surface with the specified dimensions.

| Parameter | Type | Description |
| --- | --- | --- |
| `width` | Integer | Surface width in pixels |
| `height` | Integer | Surface height in pixels |

Example:

```
d3gl.init(320, 448)
```

Call `d3gl.init()` before drawing. Surface creation can fail if the dimensions are invalid or the system cannot allocate the surface.

### `d3gl.putpixel(x, y, color)`

Writes a pixel to the surface.

| Parameter | Type | Description |
| --- | --- | --- |
| `x` | Integer | Horizontal coordinate |
| `y` | Integer | Vertical coordinate |
| `color` | Integer | Pixel color in ABGR |

The origin `(0, 0)` is the top-left corner of the surface.

Example:

```
d3gl.putpixel(50, 30, d3gl.Colors.WHITE)
```

Coordinates must remain within the surface dimensions.

### `d3gl.update()`

Requests an update of the graphical surface so the changes can be displayed.

Example:

```
d3gl.putpixel(20, 20, d3gl.Colors.RED)
d3gl.update()
```

For better performance, draw multiple pixels before calling `d3gl.update()` instead of updating after every pixel.

## Colors

`d3gl.Colors` provides predefined colors.

| Constant | Value |
| --- | --- |
| `BLACK` | `0xFF000000` |
| `WHITE` | `0xFFFFFFFF` |
| `RED` | `0xFF0000FF` |
| `BLUE` | `0xFFFF0000` |
| `GREEN` | `0xFF00FF00` |

Example:

```
local d3gl = require("d3gl")

d3gl.init(320, 200)

d3gl.putpixel(0, 0, d3gl.Colors.BLACK)
d3gl.putpixel(1, 0, d3gl.Colors.WHITE)

d3gl.update()
```

These constants use the numeric values defined by the library. The actual channel layout depends on the pixel format expected by the d3m0n graphics subsystem.

## Example: Draw a rectangle

```
local d3gl = require("d3gl")

local width = 320
local height = 200

d3gl.init(width, height)

local x1, y1 = 50, 40
local x2, y2 = 150, 100

for y = y1, y2 do
    for x = x1, x2 do
        d3gl.putpixel(x, y, d3gl.Colors.GREEN)
    end
end

d3gl.update()
```

This example fills a rectangular region with green pixels.

## Notes and limitations

- Initialize the surface before calling `d3gl.putpixel()` or `d3gl.update()`.
- Drawing outside the surface bounds is invalid.
- Surface creation and updates depend on the operating system's graphics support.
- The pixel format and color channel order must match the format expected by the underlying surface.
- The current API focuses on pixel-level drawing. Higher-level primitives, such as lines, circles, and rectangles, can be implemented on top of `d3gl.putpixel()`.
- The API anDrawing lines and rectanglesd examples may evolve as the library develops.

## Roadmap

- [x] Basic Lua module structure
- [x] Surface creation interface
- [ ] More pixel color constants
- [ ] Reliable pixel-buffer access
- [ ] Drawing lines and rectangles
- [ ] Drawing circles
- [ ] Image loading
- [ ] Text rendering
- [ ] Python bindings

## Related projects

- [d3m0n lua](https://github.com/d3m0n-project/lua)
- [d3m0n CPython](https://github.com/d3m0n-project/cpython)

## License

See the repository's `LICENSE` file for licensing information.

Implementation note: Your current C binding returns a raw surface pointer as Lua light userdata. For the README's `d3gl.putpixel()` examples to work, the library must expose a pixel-writing function or a Lua-accessible buffer; raw pointers cannot be indexed directly from standard Lua.