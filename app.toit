import pixel_strip show UartPixelStrip

PIXELS ::= 3 
TIEMPO ::= 1000
PIN::= 17

COLORES ::= [
  [0xFF, 0x00, 0x00], 
  [0x00, 0xFF, 0x00], 
  [0x00, 0x00, 0xFF], 
  [0xFF, 0xFF, 0x00], 
  [0x00, 0xAA, 0xE4], 
  [0xFF, 0xFF, 0xFF]
]

r := ByteArray PIXELS
g := ByteArray PIXELS
b := ByteArray PIXELS

ws2812 := UartPixelStrip PIXELS --pin = PIN

main:

  while true:

    COLORES.do:
      color:= it

      PIXELS.repeat:
        r[it] = color[0]
        g[it] = color[1]
        b[it] = color[2]

        ws2812.output r g b
        sleep --ms = TIEMPO