//
//  LabelsView.swift
//  Trails
//
//  Created by Hexagons on 2020-06-12.
//

import SwiftUI

@available(iOS 13.0, tvOS 13.0, watchOS 6, macOS 10.15, *)
struct LabelsView: View {
    @ObservedObject var trailer: Trailer
    let height: CGFloat
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.clear
            if trailer.smallNonBigValueLines.count < 10 {
                ForEach(trailer.smallNonBigValueLines, id: \.self) { value in
                    Text(self.getText(value: value))
                        .lineLimit(1)
                        .offset(y: self.getOffset(value: value) - (self.trailer.fontSize * (5 / 8)))
                }
                .font(.system(size: self.trailer.fontSize, weight: .regular, design: {
                    #if !os(watchOS)
                    return .monospaced
                    #else
                    return .default
                    #endif
                }()))
            }
            ForEach(trailer.bigValueLines, id: \.self) { value in
                Text(self.getText(value: value))
                    .lineLimit(1)
                    .offset(y: self.getOffset(value: value) - (self.trailer.fontSize * (5 / 8)))
            }
                .font(.system(size: self.trailer.fontSize, weight: .bold, design: {
                    #if !os(watchOS)
                    return .monospaced
                    #else
                    return .default
                    #endif
                }()))
        }
            .padding(.leading, 5)
            .clipped()
    }
    func getText(value: Double) -> String {
        String(format: "%.3f", value)
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

@available(iOS 13.0, tvOS 13.0, watchOS 6, macOS 10.15, *)
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
