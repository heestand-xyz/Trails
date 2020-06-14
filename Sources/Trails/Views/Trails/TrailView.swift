//
//  TrailView.swift
//  Trails
//
//  Created by Hexagons on 2020-06-12.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13.0, tvOS 13.0, watchOS 6, macOS 10.15, *)
struct TrailView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var trailer: Trailer
    let index: Int
    let size: CGSize
    var body: some View {
        ZStack {
            Path { path in
                PathTrail.draw(on: &path,
                               in: size,
                               with: trailer.allTimeValues[index],
                               for: trailer.duration,
                               valueRange: trailer.fullValueRange,
                               drawValueEndLines: trailer.drawValueEndLines)
            }
                .stroke(lineWidth: trailer.lineWidth)
            if trailer.circlesActive {
                Path { path in
                    PathCircle.draw(on: &path,
                                    in: size,
                                    with: trailer.allTimeValues[index],
                                    for: trailer.duration,
                                    valueRange: trailer.fullValueRange,
                                    circleRadius: trailer.circleRadius)
                }
            }
        }
            .foregroundColor(getColor(at: index))
        .mask(Group {
            if trailer.circlesActive && trailer.circleBorder {
                ZStack {
                    Color.white
                    Path { path in
                        PathCircle.draw(on: &path,
                                        in: size,
                                        with: trailer.allTimeValues[index],
                                        for: trailer.duration,
                                        valueRange: trailer.fullValueRange,
                                        circleRadius: trailer.circleRadius - trailer.lineWidth)
                    }
                        .foregroundColor(.black)
                }
                    .compositingGroup()
                    .luminanceToAlpha()
            } else {
                Color.white
            }
        })
            .blendMode(trailer.colorsActive && trailer.colorBlend ? (colorScheme == .dark ? .lighten : .multiply) : .normal)
            .clipped()
    }
    func getColor(at index: Int) -> Color {
        guard trailer.colorsActive else { return .primary }
        let hue: Double = trailer.hues[index]
        return getColor(hue: hue)
    }
    func getColor(hue: Double) -> Color {
        Color(hue: hue,
              saturation: 2 / 3,
              brightness: self.colorScheme == .light ? 0.75 : 1.0,
              opacity: 1.0)
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6, macOS 10.15, *)
struct TrailView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.primary
                .edgesIgnoringSafeArea(.all)
                .opacity(0.5)
            ZStack {
                Color.primary.colorInvert()
                TrailView(trailer: TrailerMock.make(),
                          index: 0,
                          size: CGSize(width: 300, height: 300))
//                    .colorScheme(.dark)
//                    .background(Color.black)
            }
            .frame(height: 200)
        }
    }
}
