//
//  LinesView.swift
//  Trails
//
//  Created by Hexagons on 2020-06-12.
//

import SwiftUI

struct LinesView: View {
    @ObservedObject var trailer: Trailer
    let size: CGSize
    var body: some View {
        ZStack {
            Path { path in
                PathLines.draw(on: &path,
                               in: size,
                               valueLines: self.trailer.bigValueLines,
                               valueRange: self.trailer.valueRangeWithPadding)
            }
            .stroke(lineWidth: trailer.lineWidth * 1.5)
                .opacity(0.25)
            Path { path in
                PathLines.draw(on: &path,
                               in: size,
                               valueLines: self.trailer.smallValueLines,
                               valueRange: self.trailer.valueRangeWithPadding)
            }
                .stroke(lineWidth: trailer.lineWidth)
                .opacity(0.125)
        }
            .clipped()
    }
}

struct LinesView_Previews: PreviewProvider {
    static var previews: some View {
        LinesView(trailer: TrailerMoc.make(), size: CGSize(width: 300, height: 300))
//            .colorScheme(.dark)
//            .background(Color.black)
            .frame(width: 300, height: 300)
            .border(Color.primary)
    }
}
