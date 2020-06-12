//
//  ValueLinesView.swift
//  Trails
//
//  Created by Hexagons on 2020-06-12.
//

import SwiftUI

struct ValueLinesView: View {
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
            .stroke(lineWidth: 1.5)
                .opacity(0.5)
            Path { path in
                PathLines.draw(on: &path,
                               in: size,
                               valueLines: self.trailer.smallValueLines,
                               valueRange: self.trailer.valueRangeWithPadding)
            }
                .stroke()
                .opacity(0.25)
        }
    }
}

struct ValueLinesView_Previews: PreviewProvider {
    static var previews: some View {
        ValueLinesView(trailer: TrailerMoc.make(), size: CGSize(width: 300, height: 300))
            .colorScheme(.dark)
            .frame(width: 300, height: 300)
            .background(Color.black)
            .border(Color.primary)
    }
}
