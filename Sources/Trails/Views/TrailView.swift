//
//  TrailView.swift
//  Trails
//
//  Created by Hexagons on 2020-06-12.
//

import SwiftUI

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
                               valueRange: trailer.valueRangeWithPadding,
                               drawEnds: trailer.drawEnds)
            }
                .stroke(lineWidth: trailer.lineWidth)
            if trailer.circlesActive {
                Path { path in
                    PathCircle.draw(on: &path,
                                    in: size,
                                    with: trailer.allTimeValues[index],
                                    for: trailer.duration,
                                    valueRange: trailer.valueRangeWithPadding,
                                    circleRadius: trailer.circleRadius)
                }
            }
        }
            .foregroundColor(trailer.colorsActive ? trailer.colors[index] : .primary)
        .mask(Group {
            if trailer.circlesActive && trailer.circleBorder {
                ZStack {
                    Color.white
                    Path { path in
                        PathCircle.draw(on: &path,
                                        in: size,
                                        with: trailer.allTimeValues[index],
                                        for: trailer.duration,
                                        valueRange: trailer.valueRangeWithPadding,
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
    }
}

struct TrailView_Previews: PreviewProvider {
    static var previews: some View {
        let trailer: Trailer = TrailerMoc.make()
        return TrailView(trailer: trailer, index: 0, size: CGSize(width: 300, height: 300))
            .colorScheme(.dark)
            .frame(width: 300, height: 300)
            .background(Color.black)
            .border(Color.primary)
    }
}
