<img src="http://heestand.xyz/packages/Trails/trails_icon.png" width="90" />

# Trails

![](http://heestand.xyz/packages/Trails/trails_demo_light_crop.gif)

*works on __iOS__, __tvOS__, __watchOS__ and __macOS__*

## Install

### Swift Package

~~~~swift
.package(url: "https://github.com/hexagons/Trails.git", from: "1.1.1")
~~~~

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

<img src="http://heestand.xyz/packages/Trails/trails_property_default.png" width="240" />

~~~~swift 
trailer.duration = 10.0
~~~~

> duration is in **seconds**

> `.duration` can be changed while running

> values added longer ago than the duration will be removed

<img src="http://heestand.xyz/packages/Trails/trails_property_circles_active.png" width="240" />

~~~~swift 
trailer.circlesActive = true
~~~~

> `.circlesActive` *default* is `false`

<img src="http://heestand.xyz/packages/Trails/trails_property_circles_border_and_radius.png" width="240" />

~~~~swift 
trailer.circleBorder = false
trailer.circleRadius = 2.0
~~~~

> `.circleBorder` *default* is `true`

> `.circleRadius` *default* is `3.0`


<img src="http://heestand.xyz/packages/Trails/trails_property_line_width.png" width="240" />

~~~~swift 
trailer.lineWidth = 3.0
~~~~

> `.lineWidth` *default* is `1.0`

<img src="http://heestand.xyz/packages/Trails/trails_property_color_not_active.png" width="240" />

~~~~swift 
trailer.colorsActive = false
~~~~

> when count is `1`, `.colorsActive` is `false` by *default*

> when count is `2` or more, `.colorsActive` is `true` by *default*

~~~~swift 
trailer.hues = [0.0, 0.1, 0.2]
~~~~

> the number of hues **must match** the count passed to `Trailer`

> `.hues` is "rainbow" by *default*

> a hue is a value between `0.0` and `1.0`, low values: *red to green*, middle values: *green to blue*, high values: *blue to red*

~~~~swift 
trailer.colorBlend = false
~~~~

> when `.colorBlend` is `false` the lines will not be blended. this option is visible when a lot of lines overlap

> when `.colorBlend` is `true`, **light mode** blends with `.multiply`, **dark mode** blends with `.lighten`

> `.colorBlend` is `true` by *default*

~~~~swift 
trailer.drawValueEndLines = false
~~~~

> `.drawValueEndLines` is `true` by *default*

~~~~swift 
trailer.drawValueBackground = false
~~~~

> `.drawValueBackground` is `true` by *default* on **iOS** and **watchOS**
> can be useful to turn to `false` if your background is **transparent**

~~~~swift 
trailer.drawDefaultTextBackground = false
~~~~

> `.drawValueBackground` is `true` by *default* on **iOS** and **watchOS**
> can be useful to turn to `false` if your background is **transparent**

~~~~swift 
trailer.fontSize = 12.0
~~~~

> `.fontSize` is `8.0` by *default*

~~~~swift 
trailer.leftSpacing = 10.0
trailer.rightSpacing = 10.0
~~~~

> `.leftSpacing` and `.rightSpacing` is `20.0` by *default*


## Mock

To repilcate the **randomness** seen in the gifs in the top of this readme, use this code:

~~~~swift 
let trailer: Trailer = TrailerMock.make()
~~~~

provided by [TrailerMock.swift](https://github.com/heestand-xyz/Trails/blob/master/Sources/Trails/Controller/TrailerMock.swift)
