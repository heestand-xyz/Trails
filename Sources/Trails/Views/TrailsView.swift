//
//  TrailsView.swift
//  Trails
//
//  Created by Hexagons on 2020-06-11.
//

import SwiftUI
struct TrailsView: View {
    let kLabelWidth: CGFloat = 30
    let kSpacing: CGFloat = 20
    @ObservedObject var trailer: Trailer
    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinesView(trailer: self.trailer,
                          size: geo.size)
                    .mask(LinearGradient(gradient: Gradient(colors: [Color(.displayP3, white: 1.0, opacity: 0.25), .white]),
                                         startPoint: UnitPoint(x: self.kLabelWidth / geo.size.width, y: 0),
                                         endPoint: UnitPoint(x: (self.kLabelWidth + self.kSpacing) / geo.size.width, y: 0)))
                ZStack {
                    ForEach(0..<self.trailer.count) { i in
                        TrailView(trailer: self.trailer,
                                  index: i,
                                  size: geo.size)
                    }
                }
                .mask(LinearGradient(gradient: Gradient(colors: [.clear, .white]),
                                         startPoint: UnitPoint(x: self.kLabelWidth / geo.size.width, y: 0),
                                         endPoint: UnitPoint(x: (self.kLabelWidth + self.kSpacing) / geo.size.width, y: 0)))
                HStack(spacing: self.kSpacing) {
                    LabelsView(trailer: self.trailer,
                               height: geo.size.height)
                        .frame(width: self.kLabelWidth)
                    Spacer()
                }
            }
        }
    }
}

struct TrailsView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.primary
                .edgesIgnoringSafeArea(.all)
                .opacity(0.5)
            ZStack {
                Color.primary.colorInvert()
                TrailsView(trailer: TrailerMoc.make())
//                    .colorScheme(.dark)
//                    .background(Color.black)
            }
                .frame(height: 200)
        }
    }
}
