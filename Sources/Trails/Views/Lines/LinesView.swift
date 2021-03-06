//
//  LinesView.swift
//  Trails
//
//  Created by Hexagons on 2020-06-12.
//

import SwiftUI

@available(iOS 13.0, tvOS 13.0, watchOS 6, macOS 10.15, *)
struct LinesView: View {
    @ObservedObject var trailer: Trailer
    let size: CGSize
    var body: some View {
        ZStack {
            Path { path in
                PathLines.draw(on: &path,
                               in: size,
                               valueLines: self.trailer.bigValueLines,
                               valueRange: self.trailer.fullValueRange)
            }
            .stroke(lineWidth: trailer.lineWidth * 1.5)
            .opacity(0.25)
            Path { path in
                PathLines.draw(on: &path,
                               in: size,
                               valueLines: self.trailer.smallValueLines,
                               valueRange: self.trailer.fullValueRange)
            }
                .stroke(lineWidth: trailer.lineWidth)
                .opacity(0.125)
        }
            .clipped()
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6, macOS 10.15, *)
struct LinesView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.primary
                .edgesIgnoringSafeArea(.all)
                .opacity(0.5)
            ZStack {
                Color.primary.colorInvert()
                LinesView(trailer: TrailerMock.make(),
                          size: CGSize(width: 300, height: 200))
//                    .colorScheme(.dark)
//                    .background(Color.black)
            }
            .frame(height: 200)
        }
    }
}
