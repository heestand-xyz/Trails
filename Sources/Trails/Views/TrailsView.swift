//
//  TrailsView.swift
//  Trails
//
//  Created by Hexagons on 2020-06-11.
//

import SwiftUI

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
            if geo.size.width > self.labelWidth * 2 + self.kSpacing * 2 {
                if self.trailer.hasSomeValues {
                    self.mainBody(size: geo.size)
                } else {
                    self.defaultBody(size: geo.size)
                }
            } else {
                self.textBody(text: self.trailer.hasSomeValues ? "Trails..." : "No Trails")
            }
        }
    }
    func mainBody(size: CGSize) -> some View {
        ZStack {
            LinesView(trailer: self.trailer,
                      size: size)
                .mask(LinearGradient(gradient: Gradient(stops: [
                    Gradient.Stop(color: Color(.displayP3, white: 1.0, opacity: 0.25),
                                  location: self.labelWidth / size.width),
                    Gradient.Stop(color: .white,
                                  location: (self.labelWidth + self.kSpacing) / size.width),
                    Gradient.Stop(color: .white,
                                  location: (size.width - self.labelWidth - self.kSpacing) / size.width),
                    Gradient.Stop(color: Color(.displayP3, white: 1.0, opacity: 0.25),
                                  location: (size.width - self.labelWidth) / size.width),
                ]),
                                     startPoint: .leading,
                                     endPoint: .trailing))
            ZStack {
                ForEach(0..<self.trailer.count) { i in
                    TrailView(trailer: self.trailer,
                              index: i,
                              size: CGSize(width: size.width - self.labelWidth * 2,
                                           height: size.height))
                        .offset(x: self.labelWidth)
                }
            }
                .mask(LinearGradient(gradient: Gradient(stops: [
                    Gradient.Stop(color: .clear,
                                  location: self.labelWidth / size.width),
                    Gradient.Stop(color: .white,
                                  location: (self.labelWidth + self.kSpacing) / size.width),
                    Gradient.Stop(color: .white,
                                  location: (size.width - self.labelWidth - self.kSpacing) / size.width),
                    Gradient.Stop(color: .clear,
                                  location: (size.width - self.labelWidth) / size.width),
                ]),
                                     startPoint: .leading,
                                     endPoint: .trailing))
            HStack(spacing: self.kSpacing) {
                LabelsView(trailer: self.trailer,
                           height: size.height)
                    .frame(width: self.labelWidth)
                Spacer()
                LiveLabelsView(trailer: self.trailer,
                               height: size.height)
                    .frame(width: self.labelWidth)
            }
        }
    }
    func defaultBody(size: CGSize) -> some View {
        ZStack {
            DefaultLinesView(trailer: self.trailer,
                             size: size)
                .mask(LinearGradient(gradient: Gradient(stops: [
                    Gradient.Stop(color: Color(.displayP3, white: 1.0, opacity: 0.25),
                                  location: self.labelWidth / size.width),
                    Gradient.Stop(color: .white,
                                  location: (self.labelWidth + self.kSpacing) / size.width),
                    Gradient.Stop(color: .white,
                                  location: (size.width - self.labelWidth - self.kSpacing) / size.width),
                    Gradient.Stop(color: Color(.displayP3, white: 1.0, opacity: 0.25),
                                  location: (size.width - self.labelWidth) / size.width),
                ]),
                                     startPoint: .leading,
                                     endPoint: .trailing))
            HStack(spacing: self.kSpacing) {
                DefaultLabelsView(trailer: self.trailer,
                                  height: size.height)
                    .frame(width: self.labelWidth)
                Spacer()
            }
            Text("No Trails")
                .font(.system(size: self.trailer.fontSize, weight: .regular, design: {
                    #if !os(watchOS)
                    return .monospaced
                    #else
                    return .default
                    #endif
                }()))
                .padding(10)
                .background(
                    Color.primary
                        .colorInvert()
                        .blur(radius: 15)
                )
        }
    }
    func textBody(text: String) -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text(text)
                    .font(.system(size: self.trailer.fontSize, weight: .regular, design: {
                        #if !os(watchOS)
                        return .monospaced
                        #else
                        return .default
                        #endif
                    }()))
                Spacer()
            }
            Spacer()
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
