# d3gl

**d3m0n Graphical Library for Lua and Python**

`d3gl` is a graphical library for the d3m0n operating system. It provides a simple interface for creating graphical surfaces, drawing pixels, and updating the display through Lua and Python.

## Features

- Create graphical surfaces with custom dimensions.
- Draw pixels using predefined hexadecimal color constants.
- Update the surface to display your changes.
- Support for both Lua and Python.
- Separate implementations organized into `lua/` and `python/` directories.

## Requirements

- The d3m0n operating system.
- A working Lua runtime: [d3m0n-project/lua](<https://github.com/d3m0n-project/lua>).
- A working Python runtime: [d3m0n-project/micropython](<https://github.com/d3m0n-project/micropython>).
- The required system graphics support provided by d3m0n.
- The appropriate `d3gl` implementation installed and accessible to your runtime.

## Project structure

The repository contains separate implementations for Lua and Python:

```
d3gl/
├── lua/
│   └── ...
└── python/
    └── ...
```

Each directory contains the implementation intended for its respective runtime. Install or configure the implementation for the language you want to use.

## Installation

### Lua

Install the contents of the `lua/` directory in a location accessible to your d3m0n Lua runtime.

Make sure the module is available through your Lua module search path. Then import it with:

```
local d3gl = require("d3gl")
```

The exact installation path depends on your d3m0n environment and Lua module configuration.

### Python

Install or copy the contents of the `python/` directory to a location accessible to your d3m0n Python runtime.

Ensure that the module can be imported by your Python interpreter. The exact installation path depends on your d3m0n environment and Python module search configuration.

## Getting started

### Lua example

Create a file named `main.lua`:

```
local d3gl = require("d3gl")

-- Create a 320 x 448 graphical surface.
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

### Python example

The Python implementation is provided in the `python/` directory. Import the installed module and use the functions exposed by that implementation.

The following illustrates the intended workflow; adjust the import and function names to match the actual Python API:

```
import d3gl

# Create a 320 x 448 graphical surface.
gl = d3gl(320, 448)

# Draw a few pixels.
gl.putpixel(10, 10, d3gl.Colors.RED)
gl.putpixel(11, 10, d3gl.Colors.GREEN)
gl.putpixel(12, 10, d3gl.Colors.BLUE)

# Display the changes.
gl.update()
```

Run the script using your d3m0n Python interpreter. The exact command depends on how Python is configured on your system.

**Note:** The Python example assumes that the Python implementation exposes an API equivalent to the Lua interface. Check the files in `python/` for the exact import path, function names, and constants.

## API reference

The following API describes the Lua interface. Python equivalents depend on the functions and names exported by the Python implementation.

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

Requests an update of the graphical surface so that the changes can be displayed.

Example:

```
d3gl.putpixel(20, 20, d3gl.Colors.RED)
d3gl.update()
```

For better performance, draw multiple pixels before calling `d3gl.update()` instead of updating after every pixel.

## Colors

`d3gl.Colors` provides predefined color constants.

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

Check the Python implementation for the corresponding way to access its color constants.

## Example: Draw a rectangle

This Lua example fills a rectangular region with green pixels:

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

The same approach can be implemented in Python using the equivalent functions exposed by the Python implementation.

## Notes and limitations

- Initialize the surface before calling `d3gl.putpixel()` or `d3gl.update()`.
- Drawing outside the surface bounds is invalid.
- Surface creation and updates depend on the operating system's graphics support.
- Pixel format and color channel order must match the format expected by the underlying surface.
- The API focuses on pixel-level drawing. Higher-level primitives, such as lines, circles, and rectangles, can be implemented using pixel drawing.
- Lua and Python implementations may differ in module loading, function naming, and runtime integration. Consult the corresponding directory for implementation-specific details.

## Roadmap

- [x]Basic Lua module structure
- [x]Surface creation interface
- [x]Python implementation
- [ ]More pixel color constants
- [ ]Reliable pixel-buffer access
- [x]Drawing lines and rectangles
- [x]Drawing circles
- [ ]Image loading
- [ ]Text rendering

## Related projects

- [d3m0n os](<https://github.com/d3m0n-project/d3m0n_os>)
- [d3m0n Lua](<https://github.com/d3m0n-project/lua>)
- [d3m0n MicroPython](<https://github.com/d3m0n-project/micropython>)

## License

See the repository's `LICENSE` file for licensing information.
