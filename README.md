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

## Install

Add [pixtools](https://github.com/hexagons/pixtools/raw/master/pixtools) to `/usr/local/bin/`

## Example

Brighten an image up to 200%

~~~~
$ pixtools ~/in.png ~/out.png --metallib ~/PixelKitShaders-macOS.metallib --resolution 1024x1024 --effect levels -p brightness:2.0
~~~~

You can find the Metal library [here](https://github.com/hexagons/PixelKit/tree/master/Resources/Metal%20Libs)


## Effects

<img src="https://github.com/hexagons/pixtools/blob/master/Assets/in.jpg?raw=true" width="128"/>

Source image

### Blur
<img src="https://github.com/hexagons/pixtools/blob/master/Assets/effects/out_blur.jpg?raw=true" width="128"/>

~~~~
$ ... --effect blur -p radius:0.25
~~~~

### Edge
<img src="https://github.com/hexagons/pixtools/blob/master/Assets/effects/out_edge.jpg?raw=true" width="128"/>

~~~~
$ ... --effect edge -p strength:10
~~~~

### Clamp
<img src="https://github.com/hexagons/pixtools/blob/master/Assets/effects/out_clamp.jpg?raw=true" width="128"/>

~~~~
$ ... --effect clamp -p low:0.25 -p high:0.75
~~~~

### Kaleidoscope
<img src="https://github.com/hexagons/pixtools/blob/master/Assets/effects/out_kaleidoscope.jpg?raw=true" width="128"/>

~~~~
$ ... --effect kaleidoscope
~~~~

### Levels: Brightness
<img src="https://github.com/hexagons/pixtools/blob/master/Assets/effects/out_brightness.jpg?raw=true" width="128"/>

~~~~
$ ... --effect levels -p brightness:2.0
~~~~

### Levels: Gamma
<img src="https://github.com/hexagons/pixtools/blob/master/Assets/effects/out_gamma.jpg?raw=true" width="128"/>

~~~~
$ ... --effect levels -p gamma:0.5
~~~~

### Levels: Inverted
<img src="https://github.com/hexagons/pixtools/blob/master/Assets/effects/out_inverted.jpg?raw=true" width="128"/>

~~~~
$ ... --effect levels -p inverted:1
~~~~

### Levels: Opacity 
<img src="https://github.com/hexagons/pixtools/blob/master/Assets/effects/out_opacity.jpg?raw=true" width="128"/>

~~~~
$ ... --effect levels -p opacity:0.1
~~~~


### Levels: Contrast
<img src="https://github.com/hexagons/pixtools/blob/master/Assets/effects/out_contrast.jpg?raw=true" width="128"/>

~~~~
$ ... --effect levels -p contrast:2
~~~~

### Quantize
<img src="https://github.com/hexagons/pixtools/blob/master/Assets/effects/out_quantize.jpg?raw=true" width="128"/>

~~~~
$ ... --effect quantize -p fraction:0.25
~~~~

### Sharpen
<img src="https://github.com/hexagons/pixtools/blob/master/Assets/effects/out_sharpen.jpg?raw=true" width="128"/>

~~~~
$ ... --effect sharpen -p contrast:2
~~~~

### Slope
<img src="https://github.com/hexagons/pixtools/blob/master/Assets/effects/out_slope.jpg?raw=true" width="128"/>

~~~~
$ ... --effect slope -p amplitude:256
~~~~

### 
<img src="https://github.com/hexagons/pixtools/blob/master/Assets/effects/out_threshold.jpg?raw=true" width="128"/>

~~~~
$ ... --effect threshold
~~~~

### 
<img src="https://github.com/hexagons/pixtools/blob/master/Assets/effects/out_twirl.jpg?raw=true" width="128"/>

~~~~
$ ... --effect twirl
~~~~

### Transform
<img src="https://github.com/hexagons/pixtools/blob/master/Assets/effects/out_transform.jpg?raw=true" width="128"/>

~~~~
$ ... --effect transform -p rotation:0.125 -p scale:1.5
~~~~

### Sepia
<img src="https://github.com/hexagons/pixtools/blob/master/Assets/effects/out_sepia.jpg?raw=true" width="128"/>

~~~~
$ ... --effect sepia
~~~~

### Range
<img src="https://github.com/hexagons/pixtools/blob/master/Assets/effects/out_range.jpg?raw=true" width="128"/>

~~~~
$ ... --effect range -p inLow:0.25 -p inHigh:0.75
~~~~

### Saturation
<img src="https://github.com/hexagons/pixtools/blob/master/Assets/effects/out_saturation.jpg?raw=true" width="128"/>

~~~~
$ ... --effect huesaturation -p saturation:0.0
~~~~

### Hue
<img src="https://github.com/hexagons/pixtools/blob/master/Assets/effects/out_hue.jpg?raw=true" width="128"/>

~~~~
$ ... --effect huesaturation -p hue:0.5
~~~~

### Flare
<img src="https://github.com/hexagons/pixtools/blob/master/Assets/effects/out_flare.jpg?raw=true" width="128"/>

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
