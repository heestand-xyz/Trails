//
//  TrailsView.swift
//  Trails
//
//  Created by Hexagons on 2020-06-11.
//

import SwiftUI
struct TrailsView: View {
    let kLabelWidth: CGFloat = 40
    let kSpacing: CGFloat = 20
    @ObservedObject var trailer: Trailer
    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinesView(trailer: self.trailer,
                          size: geo.size)
                    .mask(LinearGradient(gradient: Gradient(stops: [
                        Gradient.Stop(color: Color(.displayP3, white: 1.0, opacity: 0.25),
                                      location: self.kLabelWidth / geo.size.width),
                        Gradient.Stop(color: .white,
                                      location: (self.kLabelWidth + self.kSpacing) / geo.size.width),
                        Gradient.Stop(color: .white,
                                      location: (geo.size.width - self.kLabelWidth - self.kSpacing) / geo.size.width),
                        Gradient.Stop(color: Color(.displayP3, white: 1.0, opacity: 0.25),
                                      location: (geo.size.width - self.kLabelWidth) / geo.size.width),
                    ]),
                                         startPoint: .leading,
                                         endPoint: .trailing))
                ZStack {
                    ForEach(0..<self.trailer.count) { i in
                        TrailView(trailer: self.trailer,
                                  index: i,
                                  size: CGSize(width: geo.size.width - self.kLabelWidth * 2,
                                               height: geo.size.height))
                            .offset(x: self.kLabelWidth)
                    }
                }
                    .mask(LinearGradient(gradient: Gradient(stops: [
                        Gradient.Stop(color: .clear,
                                      location: self.kLabelWidth / geo.size.width),
                        Gradient.Stop(color: .white,
                                      location: (self.kLabelWidth + self.kSpacing) / geo.size.width),
                        Gradient.Stop(color: .white,
                                      location: (geo.size.width - self.kLabelWidth - self.kSpacing) / geo.size.width),
                        Gradient.Stop(color: .clear,
                                      location: (geo.size.width - self.kLabelWidth) / geo.size.width),
                    ]),
                                         startPoint: .leading,
                                         endPoint: .trailing))
                HStack(spacing: self.kSpacing) {
                    LabelsView(trailer: self.trailer,
                               height: geo.size.height)
                        .frame(width: self.kLabelWidth)
                    Spacer()
                    LiveLabelsView(trailer: self.trailer,
                                   height: geo.size.height)
                        .frame(width: self.kLabelWidth)
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
