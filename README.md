<img src="http://hexagons.net/external/trails/trails_icon.png" width="90" />

# Trails

SwiftUI View for Trails of Values over Time

<img src="http://hexagons.net/external/trails/trails_demo_light_crop_480.gif" width="240" />
<img src="http://hexagons.net/external/trails/trails_demo_dark_480.gif" width="240" />

## Setup

~~~~swift
import SwiftUI
import Trails
~~~~

~~~~swift 
struct ContentView: View {
    var body: some View {
        TrailsView(trailer: TrailerMock.make())
            .frame(height: 200)
    }
}
~~~~

## Properties

<img src="http://hexagons.net/external/trails/trails_property_default.png" width="240" />

~~~~swift 
trailer.duration = 10.0
~~~~

> duration is in seconds


<img src="http://hexagons.net/external/trails/trails_property_circles_active.png" width="240" />

~~~~swift 
trailer.circlesActive = true
~~~~

<img src="http://hexagons.net/external/trails/trails_property_circles_border_and_radius.png" width="240" />

~~~~swift 
trailer.circleBorder = false
trailer.circleRadius = 2.0
~~~~


<img src="http://hexagons.net/external/trails/trails_property_line_width.png" width="240" />

~~~~swift 
trailer.lineWidth = 3.0
~~~~


<img src="http://hexagons.net/external/trails/trails_property_color_not_active.png" width="240" />

~~~~swift 
trailer.colorsActive = false
~~~~

<img src="http://hexagons.net/external/trails/trails_property_hues.png" width="240" />

~~~~swift 
trailer.hues = [0.0, 0.1, 0.2]
~~~~

> The number of hues must match the count passed to Trailer

~~~~swift 
trailer.colorBlend = false
~~~~

> when `colorBlend` is `true`, in light mode the lines will be blended with `.multiply` and in dark mode the lines will be blended with `.lighten`
> colorBlend is `true` by default

## Mock

To repilcate the gifs, use `let trailer: Trailer = TrailerMock.make()`, provided by [TrailerMock.swift](https://github.com/hexagons/Trails/blob/master/Sources/Trails/Controller/TrailerMock.swift)
