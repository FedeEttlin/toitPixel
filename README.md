# Como controlar una tira de Leds WS2812 conectada a un [ESP32 de Espressif](https://www.espressif.com) usando [TOIT](https://toit.io).

[![Alt text](https://img.youtube.com/vi/KAeq1OoagZs/0.jpg)](https://www.youtube.com/watch?v=KAeq1OoagZs)

¿ Que necesitamos ?

- Disponer de un ESP32 y una tira de leds WS2812.

- Crear una cuenta en [TOIT](https://toit.io).

- Instalar [Visual Studio Code](https://code.visualstudio.com).

- Instalar en Visual Studio Code [ésta](https://marketplace.visualstudio.com/items?itemName=toit.toit) extensión.

* Instalar el CLI (Command Line Interface), que lo podemos descargar desde [aqui](https://docs.toit.io/getstarted/installation).

* Seguir [estos](https://docs.toit.io/getstarted/quick_start) pasos para cargar el firmware TOIT en el ESP32 y aprovisionarlo en la nube. Luego de esta etapa toda la comunicación la vamos a hacer por WiFi.

Creamos una carpeta para nuestro proyecto y dentro de ella creamos 2 archivos:

- app.toit
- app.yaml

Dentro del archivo app.yaml escribimos lo siguiente:

```
name: app

entrypoint: app.toit
triggers:
    on_boot: true
    on_install: true
```

Este archivo es para configurar la aplicación, por ahora lo vamos a dejar así pero para conocer más detalles podemos ir a [este link](https://docs.toit.io/platform/apps/appspec).

En el archivo app.toit que es nuestra aplicación que vamos a correr en el ESP32 escribimos lo siguiente:

```
import pixel_strip show UartPixelStrip   // Importamos la librería pixel_strip que es la encargada de manejar los leds WS2812.

PIXELS ::= 8   // Definimos la cantidad de LEDS que tenemos en la tira.
TIEMPO ::= 300
PIN::= 17      // Definimos el pin del ESP32 donde vamos a conectar la tira de LEDS, como vamos a usar la comunicación por UART es el pin 17.


// Defino una matriz de colores con el formato RGB.
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

    // Por cada color.
    COLORES.do:
      color:= it   // Me quedo con el color actual.

      // Recorro la matriz de LEDs y le cargo el color actual.
      PIXELS.repeat:
        r[it] = color[0]
        g[it] = color[1]
        b[it] = color[2]

        ws2812.output r g b   // Escribimos en la tira de LEDs
        sleep --ms = TIEMPO   // Esperamos un tiempo.
```

Las librerias oficiales las podemos encontar en [este link](https://pkg.toit.io/).

Todavía nos queda instalar la librería [pixel_strip](https://pkg.toit.io/package/github.com%2Ftoitware%2Ftoit-pixel-strip@v0.0.4) en nuestro proyecto. Para esto vamos a abrir una consola dentro de vscode y vamos a escribir lo siguiente:

```
toit version   // Con esto comprobamos que tenemos instalado TOIT en nuestra computadora. Nos va a aparecer algo como esto:

+---------+------------+
| VERSION |    DATE    |
+---------+------------+
| v1.11.0 | 2021-09-24 |
+---------+------------+

toit auth login   // Ejecutamos este comando para autenticarnos en TOIT, nos va a abrir una ventana en el navegador la cual vamos a tener que aceptar.

toit pkg install github.com/toitware/toit-pixel-strip   // Esto es para instalar el paquete.

toit help // Nos sirve para obtener ayuda sobre todos los comandos.
```

¿ Todo bien pero como subo el código al ESP32 ?

Para esto tenemos que ejecutar el siguiente comando:

DeviceName es el nombre que le pusimos al ESP32.

```
toit deploy -d DeviceName app.yaml
```

En unos segundos debería cargarse la aplicación en el ESP32 y los leds cambiar de color.
