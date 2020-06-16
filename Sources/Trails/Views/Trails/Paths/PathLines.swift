//
//  PathLines.swift
//  Trails
//
//  Created by Hexagons on 2020-06-12.
//

import Foundation
import CoreGraphics
import SwiftUI

@available(iOS 13.0, tvOS 13.0, watchOS 6, macOS 10.15, *)
struct PathLines {
    static func draw(on path: inout Path,
                     in size: CGSize,
                     valueLines: [Double],
                     valueRange: ClosedRange<Double>) {
        let w: CGFloat = size.width
        let h: CGFloat = size.height
        for valueLine in valueLines {
            let valueSpan: Double = valueRange.upperBound - valueRange.lowerBound
            guard valueSpan > 0.0 else { continue }
            let valueFraction: Double = (valueLine - valueRange.lowerBound) / valueSpan
            let y: CGFloat = h - h * CGFloat(valueFraction)
            path.move(to: CGPoint(x: 0.0, y: y))
            path.addLine(to: CGPoint(x: w, y: y))
        }
    }
}
