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
        ZStack(alignment: .top) {
            Color.clear
            ForEach(trailer.smallNonBigValueLines, id: \.self) { value in
                Text(self.getText(value: value))
                    .offset(y: self.getOffset(value: value) - (self.trailer.fontSize * (5 / 8)))
            }
                .font(.system(size: self.trailer.fontSize, weight: .regular, design: .monospaced))
            ForEach(trailer.bigValueLines, id: \.self) { value in
                Text(self.getText(value: value))
                    .offset(y: self.getOffset(value: value) - (self.trailer.fontSize * (5 / 8)))
            }
                .font(.system(size: self.trailer.fontSize, weight: .bold, design: .monospaced))
        }
            .padding(.leading, 5)
            .clipped()
    }
    func getText(value: Double) -> String {
        "\(value)"
    }
    func getOffset(value: Double) -> CGFloat {
        let lower: Double = trailer.fullValueRange.lowerBound
        let upper: Double = trailer.fullValueRange.upperBound
        let span: Double = upper - lower
        guard span > 0.0 else { return 0.0 }
        let fraction: Double = (value - lower) / span
        return CGFloat(1.0 - fraction) * height
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
                LabelsView(trailer: TrailerMock.make(),
                           height: 200)
//                    .colorScheme(.dark)
//                    .background(Color.black)
            }
            .frame(width: 40, height: 200)
        }
    }
}
