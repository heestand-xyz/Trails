<img src="http://hexagons.net/external/trails/trails_icon.png" width="90" />

# Trails

![](http://hexagons.net/external/trails/trails_demo_light_crop.gif)
![](http://hexagons.net/external/trails/trails_demo_dark.gif)

## Setup

~~~~swift
import SwiftUI
import Trails
~~~~

~~~~swift
struct ContentView: View {
    var main: Main = Main()
    var body: some View {
        TrailsView(trailer: main.trailer)
            .frame(height: 200)
    }
}
~~~~

~~~~swift
class Main {
    
    let trailer: Trailer
    
    init() {
        
        let trailCount: Int = 3
        let seconds: Double = 10.0
        trailer = Trailer(count: trailCount,
                          duration: seconds)
        trailer.circlesActive = true
        
        startTimer()
        
    }
    
    func startTimer()  {
        
        let startDate: Date = Date()
        let timer: Timer = Timer(timeInterval: 0.5, repeats: true) { _ in
            let time: Double = -startDate.timeIntervalSinceNow
            let valueA: Double = cos(time)
            let valueB: Double = cos(time + (.pi * 2) * (1.0 / 3.0))
            let valueC: Double = cos(time + (.pi * 2) * (2.0 / 3.0))
            self.trailer.add(valueA, at: 0)
            self.trailer.add(valueB, at: 1)
            self.trailer.add(valueC, at: 2)
        }
        RunLoop.current.add(timer, forMode: .common)
        
    }
    
}
~~~~

## Properties

<img src="http://hexagons.net/external/trails/trails_property_
.png" width="240" />

~~~~swift 
trailer.duration = 10.0
~~~~

> duration is in **seconds**

> `.duration` can be changed while running

> values added longer ago than the duration will be removed

<img src="http://hexagons.net/external/trails/trails_property_circles_active.png" width="240" />

~~~~swift 
trailer.circlesActive = true
~~~~

> `.circlesActive` *default* is `false`

<img src="http://hexagons.net/external/trails/trails_property_circles_border_and_radius.png" width="240" />

~~~~swift 
trailer.circleBorder = false
trailer.circleRadius = 2.0
~~~~

> `.circleBorder` *default* is `true`

> `.circleRadius` *default* is `3.0`


<img src="http://hexagons.net/external/trails/trails_property_line_width.png" width="240" />

~~~~swift 
trailer.lineWidth = 3.0
~~~~

> `.lineWidth` *default* is `1.0`

<img src="http://hexagons.net/external/trails/trails_property_color_not_active.png" width="240" />

~~~~swift 
trailer.colorsActive = false
~~~~

> when count is `1`, `c.olorsActive` is `false`

> when count is more than `1`, `.colorsActive` is `true`

<img src="http://hexagons.net/external/trails/trails_property_hues.png" width="240" />

~~~~swift 
trailer.hues = [0.0, 0.1, 0.2]
~~~~

> the number of hues must match the count passed to `Trailer`

> `.hues` is "rainbow" by *default*

~~~~swift 
trailer.colorBlend = false
~~~~

> when `.colorBlend` is `false` the lines will not be blended. this option is visible when a lot of lines overlap.

> when `.colorBlend` is `true`, in light mode the lines will be blended with `.multiply` and in dark mode the lines will be blended with `.lighten`

> `.colorBlend` is `true` by *default*

## Mock

To repilcate the randomness seen in the gifs in the top of the redame, use this code:

~~~~swift 
let trailer: Trailer = TrailerMock.make()
~~~~

provided by [TrailerMock.swift](https://github.com/hexagons/Trails/blob/master/Sources/Trails/Controller/TrailerMock.swift)
