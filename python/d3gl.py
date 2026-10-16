from enum import Enum
import sys

class d3gl:
	class Colors(Enum):
		BLACK = 0xff000000,
		WHITE = 0xffffffff,
		RED   = 0xff0000ff,
		BLUE  = 0xffff0000,
		GREEN = 0xff00ff00,

	class d3glException(Exception):
		pass

	def __init__(self, width: int, height: int):
		self.surface, p, ret = sys.surface_create(width, height)
		if ret != 0 and self.surface is None:
			raise self.d3glException("Surface creation failed")
		
		self.width = width
		self.height = height
		self.pitch = p

	def putpixel(self, x: int, y: int, color: int) -> None:
		if not self.surface:
			raise self.d3glException("Surface address could not be resolved, failed to initialize")
		if x >= 0 and x < self.width:
			raise self.d3glException("X out of bounds")
		if y >= 0 and y < self.height:
		    raise self.d3glException("Y out of bounds")

		sys.c_buffer_uint32_set(self.surface, (y * self.width + x), color)

	def update(self):
		if not self.surface:
			raise self.d3glException("Surface address could not be resolved, failed to initialize")
		return sys.surface_update(self.surface)
