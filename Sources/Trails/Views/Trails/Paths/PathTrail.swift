//
//  PathTrail.swift
//  Trails
//
//  Created by Hexagons on 2020-06-12.
//

import Foundation
import CoreGraphics
#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 13.0, tvOS 13.0, watchOS 6, macOS 10.15, *)
struct PathTrail {
    static func draw(on path: inout Path,
                     in size: CGSize,
                     with timeValues: [TimeValue],
                     for duration: Double,
                     valueRange: ClosedRange<Double>,
                     drawValueEndLines: Bool) {
        let w: CGFloat = size.width
        let h: CGFloat = size.height
        for (i, timeValue) in timeValues.enumerated() {
            let timeFraction: Double = timeValue.seconds / duration
            let x: CGFloat = w - w * CGFloat(timeFraction)
            let valueFraction: Double = (timeValue.value - valueRange.lowerBound) / (valueRange.upperBound - valueRange.lowerBound)
            let y: CGFloat = h - h * CGFloat(valueFraction)
            if drawValueEndLines {
                if i == 0 {
                    path.move(to: CGPoint(x: 0.0, y: y))
                }
                path.addLine(to: CGPoint(x: x, y: y))
                if i == timeValues.count - 1 {
                    path.addLine(to: CGPoint(x: w, y: y))
                }
            } else {
                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
        }
    }
}
