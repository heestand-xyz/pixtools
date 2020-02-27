# pixtools

Powered by [PixelKit](https://github.com/hexagons/pixelkit) and Metal

## Options

~~~~
$ pixtools
pixtools <input> <output>
[-m | --metallib <path>]
[-r | --resolution <1920x1080>]
[-e | --effect <name>]
[-p | --property <name:float>]
~~~~


## Example

Brighten an image up to 200%:

~~~~
$ pixtools ~/in.png ~/out.png --metallib ~/PixelKitShaders-macOS.metallib --resolution 1024x1024 --effect levels -p brightness:2.0
~~~~

You can find the Metal library [here](https://github.com/hexagons/PixelKit/tree/master/Resources/Metal%20Libs)


## Effects
<img src="in" width:"128"/>

### Blur
<img src="blur" width:"128"/>
~~~~
$ ... --effect blur -p radius:0.25
~~~~

### Edge
<img src="edge" width:"128"/>
~~~~
$ ... --effect edge -p strength:10
~~~~

### Clamp
<img src="clamp" width:"128"/>
~~~~
$ ... --effect clamp -p low:0.25 -p high:0.75
~~~~

### Kaleidoscope
<img src="kaleidoscope" width:"128"/>
~~~~
$ ... --effect kaleidoscope
~~~~

### Levels: Brightness
<img src="brightness" width:"128"/>
~~~~
$ ... --effect levels -p brightness:2.0
~~~~

### Levels: Gamma
<img src="gamma" width:"128"/>
~~~~
$ ... --effect levels -p gamma:0.5
~~~~

### Levels: Inverted
<img src="inverted" width:"128"/>
~~~~
$ ... --effect levels -p inverted:1
~~~~

### Levels: Opacity 
<img src="opacity" width:"128"/>
~~~~
$ ... --effect levels -p opacity:0.1
~~~~


### Levels: Contrast
<img src="contrast" width:"128"/>
~~~~
$ ... --effect levels -p contrast:2
~~~~

### Quantize
<img src="quantize" width:"128"/>
~~~~
$ ... --effect quantize -p fraction:0.25
~~~~

### Sharpen
<img src="sharpen" width:"128"/>
~~~~
$ ... --effect sharpen -p contrast:2
~~~~

### Slope
<img src="slope" width:"128"/>
~~~~
$ ... --effect slope -p amplitude:256
~~~~

### 
<img src="threshold" width:"128"/>
~~~~
$ ... --effect threshold
~~~~

### 
<img src="twirl" width:"128"/>
~~~~
$ ... --effect twirl
~~~~

### Transform
<img src="transform" width:"128"/>
~~~~
$ ... --effect transform -p rotation:0.125 -p scale:1.5
~~~~

### Sepia
<img src="sepia" width:"128"/>
~~~~
$ ... --effect sepia
~~~~

### Range
<img src="range" width:"128"/>
~~~~
$ ... --effect range -p inLow:0.25 -p inHigh:0.75
~~~~

### Saturation
<img src="saturation" width:"128"/>
~~~~
$ ... --effect huesaturation -p saturation:0.0
~~~~

### Hue
<img src="hue" width:"128"/>
~~~~
$ ... --effect huesaturation -p hue:0.5
~~~~

### Flare
<img src="flare" width:"128"/>
~~~~
$ ... --effect flare
~~~~


## Tips

Tip 1, list all effects: 
~~~~
$ pixtools ~/in.png ~/out.png --effect ?
~~~~

Tip 2, list all effect properties:
~~~~
$ pixtools ~/in.png ~/out.png --effect levels -p ?:?
~~~~
