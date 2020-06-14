//
//  LabelsView.swift
//  Trails
//
//  Created by Hexagons on 2020-06-12.
//

import SwiftUI

struct LabelsView: View {
    @ObservedObject var trailer: Trailer
    let height: CGFloat
    var body: some View {
        VStack {
            Text("1_000_000.0")
            Text("1_000.0")
            Text("1.0")
            Spacer()
            Text("1.999999999999")
            Spacer()
            Text("0.1")
            Text("0.000_1")
            Text("0.000_000_1")
        }
            .font(.system(size: 8, weight: .bold, design: .monospaced))
            .padding(.leading, 5)
    }
}

struct LabelsView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.primary
                .edgesIgnoringSafeArea(.all)
                .opacity(0.5)
            ZStack {
                Color.primary.colorInvert()
                LabelsView(trailer: TrailerMoc.make(),
                           height: 200)
//                    .colorScheme(.dark)
//                    .background(Color.black)
            }
            .frame(height: 200)
        }
    }
}
