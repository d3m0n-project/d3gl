import sys

class Colors:
    BLACK = 0xff000000
    WHITE = 0xffffffff
    RED   = 0xff0000ff
    BLUE  = 0xffff0000
    GREEN = 0xff00ff00


class d3glException(Exception):
    pass


class Core:
    def __init__(self,
             _width: int = 0,
             _height: int = 0,
             bg: Colors | None = None) -> None:

        surface, p, ret = sys.surface_create(_width, _height)
        if ret != 0 or surface is None:
            raise d3glException("Surface creation failed")
        surface, p, ret = sys.surface_create(_width, _height)
        if ret != 0 or surface is None:
            raise d3glException("Surface creation failed")

        self.surface = surface
        self.pitch = p
        
        self.width = _width
        self.height = _height

        if bg:
            for i in range(_width):
                for j in range(_height):
                    self.putpixel(i, j, bg)  
            
        


    def putpixel(self, x: int, y: int, color: int) -> None:
        if self.surface is None:
            raise d3glException("Surface address could not be resolved, failed to initialize")
        if x < 0 or x >= self.width:
            raise d3glException("X out of bounds")
        if y < 0 or y >= self.height:
            raise d3glException("Y out of bounds")

        sys.c_buffer_uint32_set(self.surface, (y * self.width + x), color)
        sys.c_buffer_uint32_set(self.surface, (y * self.width + x), color)


    def update(self) -> None:
        if self.surface is None:
            raise d3glException("Surface address could not be resolved, failed to initialize")
    def update(self) -> None:
        if self.surface is None:
            raise d3glException("Surface address could not be resolved, failed to initialize")

        ret = sys.surface_update(self.surface)
        ret = sys.surface_update(self.surface)

        if ret != 0:
            raise d3glException("Surface update failed")
        if ret != 0:
            raise d3glException("Surface update failed")