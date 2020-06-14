//
//  LiveLabelsView.swift
//  Trails
//
//  Created by Hexagons on 2020-06-12.
//

import SwiftUI

@available(iOS 13.0, tvOS 13.0, watchOS 6, macOS 10.15, *)
struct LiveLabelsView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var trailer: Trailer
    let height: CGFloat
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.clear
            ForEach(trailer.lastValuesAndHues, id: \.hue) { valueAndHue in
                ZStack {
                    if self.trailer.drawValueBackground {
                        Color.primary
                            .colorInvert()
                            .opacity(0.75)
                    }
                    Text(self.getText(value: valueAndHue.value))
                        .foregroundColor(self.getColor(hue: valueAndHue.hue))
                        .layoutPriority(1)
                }
                    .offset(y: self.getOffset(value: valueAndHue.value) - (self.trailer.fontSize * (5 / 8)))
            }
                .font(.system(size: self.trailer.fontSize, weight: .bold, design: {
                    #if !os(watchOS)
                    return .monospaced
                    #else
                    return .default
                    #endif
                }()))
        }
            .padding(.trailing, 5)
            .clipped()
    }
    func getText(value: Double) -> String {

        let magnitude: Double = trailer.magnitude / 1_000
        let magnitudeRoundedValue: Double = round(value / magnitude) * magnitude
        
        let numHandler = NSDecimalNumberHandler(roundingMode: .plain, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let roundedNum = NSDecimalNumber(value: magnitudeRoundedValue)
            .rounding(accordingToBehavior: numHandler)
        
        
        return "\(Float(truncating: roundedNum))"
    }
    func getOffset(value: Double) -> CGFloat {
        let lower: Double = trailer.fullValueRange.lowerBound
        let upper: Double = trailer.fullValueRange.upperBound
        let span: Double = upper - lower
        guard span > 0.0 else { return 0.0 }
        let fraction: Double = (value - lower) / span
        return CGFloat(1.0 - fraction) * height
    }
    func getColor(hue: Double) -> Color {
        guard trailer.colorsActive else { return .primary }
        return Color(hue: hue,
                     saturation: 2 / 3,
                     brightness: self.colorScheme == .light ? 0.75 : 1.0,
                     opacity: 1.0)
    }
}

@available(iOS 13.0, tvOS 13.0, watchOS 6, macOS 10.15, *)
struct LiveLabelsView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.primary
                .edgesIgnoringSafeArea(.all)
                .opacity(0.5)
            ZStack {
                Color.primary.colorInvert()
                LiveLabelsView(trailer: TrailerMock.make(),
                           height: 200)
//                    .colorScheme(.dark)
//                    .background(Color.black)
            }
            .frame(width: 40, height: 200)
        }
    }
}
