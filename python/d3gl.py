import sys


class Colors:
    BLACK = 0xff000000
    WHITE = 0xffffffff
    RED   = 0xff0000ff
    BLUE  = 0xffff0000
    GREEN = 0xff00ff00


class d3glException(Exception):
    pass


surface = None
width = 0
height = 0
pitch = 0


def init(_width: int, _height: int) -> None:
    global surface, width, height, pitch

    surface, p, ret = sys.surface_create(_width, _height)
    if ret != 0 or surface is None:
        raise d3glException("Surface creation failed")

    width = _width
    height = _height
    pitch = p


def putpixel(x: int, y: int, color: int) -> None:
    if surface is None:
        raise d3glException("Surface address could not be resolved, failed to initialize")
    if x < 0 or x >= width:
        raise d3glException("X out of bounds")
    if y < 0 or y >= height:
        raise d3glException("Y out of bounds")

    sys.c_buffer_uint32_set(surface, (y * width + x), color)


def update() -> None:
    if surface is None:
        raise d3glException("Surface address could not be resolved, failed to initialize")

    ret = sys.surface_update(surface)

    if ret != 0:
        raise d3glException("Surface update failed")