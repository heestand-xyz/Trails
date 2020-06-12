//
//  TrailsView.swift
//  Trails
//
//  Created by Hexagons on 2020-06-11.
//

import SwiftUI

struct TrailsView: View {
    @ObservedObject var trailer: Trailer
    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinesView(trailer: self.trailer, size: geo.size)
                ForEach(0..<self.trailer.count) { i in
                    TrailView(trailer: self.trailer, index: i, size: geo.size)
                }
                    .opacity(0.5)
            }
        }
    }
}

struct TrailsView_Previews: PreviewProvider {
    static var previews: some View {
        TrailsView(trailer: TrailerMoc.make())
            .colorScheme(.dark)
            .background(Color.black)
            .frame(height: 200)
            .border(Color.primary)
    }
}
