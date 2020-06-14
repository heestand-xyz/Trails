<img src="http://hexagons.net/external/trails/trails_icon.png" width="90" />

# Trails

SwiftUI View for Trails of Values over Time

<img src="http://hexagons.net/external/trails/trails_demo_light.gif" width="180" />
<img src="http://hexagons.net/external/trails/trails_demo_dark.gif" width="180" />

## Trailer Mock

To replicate the demo above use the Trailer Mock:

~~~~swift 
struct TrailsMock_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.primary
                .edgesIgnoringSafeArea(.all)
                .opacity(0.5)
            ZStack {
                Color.primary.colorInvert()
                TrailsView(trailer: TrailerMock.make())
//                    .colorScheme(.dark)
//                    .background(Color.black)
            }
                .frame(height: 200)
        }
    }
}
~~~~
[TrailerMock.swift](https://github.com/hexagons/Trails/blob/master/Sources/Trails/Controller/TrailerMock.swift)
