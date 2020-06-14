//
//  TrailsView.swift
//  Trails
//
//  Created by Hexagons on 2020-06-11.
//

import SwiftUI

//@available(iOS 13.0, tvOS 13.0, watchOS 6, macOS 10.15, *)
//public struct TestView: View {
//    public var body: some View {
//        ZStack {
//            Color.blue
//            VStack {
//                Text("Top")
//                Spacer()
//                HStack {
//                    Text("Left")
//                    Spacer()
//                    Text("Test")
//                    Spacer()
//                    Text("Right")
//                }
//                Spacer()
//                Text("Bottom")
//            }
//        }
//    }
//}

@available(iOS 13.0, tvOS 13.0, watchOS 6, macOS 10.15, *)
public struct TrailsView: View {
    var labelWidth: CGFloat { trailer.fontSize * 4 }
    let kSpacing: CGFloat = 20
    @ObservedObject var trailer: Trailer
    public init(trailer: Trailer) {
        self.trailer = trailer
    }
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                LinesView(trailer: self.trailer,
                          size: geo.size)
                    .mask(LinearGradient(gradient: Gradient(stops: [
                        Gradient.Stop(color: Color(.displayP3, white: 1.0, opacity: 0.25),
                                      location: self.labelWidth / geo.size.width),
                        Gradient.Stop(color: .white,
                                      location: (self.labelWidth + self.kSpacing) / geo.size.width),
                        Gradient.Stop(color: .white,
                                      location: (geo.size.width - self.labelWidth - self.kSpacing) / geo.size.width),
                        Gradient.Stop(color: Color(.displayP3, white: 1.0, opacity: 0.25),
                                      location: (geo.size.width - self.labelWidth) / geo.size.width),
                    ]),
                                         startPoint: .leading,
                                         endPoint: .trailing))
                ZStack {
                    ForEach(0..<self.trailer.count) { i in
                        TrailView(trailer: self.trailer,
                                  index: i,
                                  size: CGSize(width: geo.size.width - self.labelWidth * 2,
                                               height: geo.size.height))
                            .offset(x: self.labelWidth)
                    }
                }
                    .mask(LinearGradient(gradient: Gradient(stops: [
                        Gradient.Stop(color: .clear,
                                      location: self.labelWidth / geo.size.width),
                        Gradient.Stop(color: .white,
                                      location: (self.labelWidth + self.kSpacing) / geo.size.width),
                        Gradient.Stop(color: .white,
                                      location: (geo.size.width - self.labelWidth - self.kSpacing) / geo.size.width),
                        Gradient.Stop(color: .clear,
                                      location: (geo.size.width - self.labelWidth) / geo.size.width),
                    ]),
                                         startPoint: .leading,
                                         endPoint: .trailing))
                HStack(spacing: self.kSpacing) {
                    LabelsView(trailer: self.trailer,
                               height: geo.size.height)
                        .frame(width: self.labelWidth)
                    Spacer()
                    LiveLabelsView(trailer: self.trailer,
                                   height: geo.size.height)
                        .frame(width: self.labelWidth)
                }
            }
        }
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6, macOS 10.15, *)
struct TrailsView_Previews: PreviewProvider {
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
