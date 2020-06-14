//
//  PathCircle.swift
//  Trails
//
//  Created by Hexagons on 2020-06-12.
//

import Foundation
import CoreGraphics
import SwiftUI

@available(iOS 13.0, tvOS 13.0, watchOS 6, macOS 10.15, *)
struct PathCircle {
    static func draw(on path: inout Path,
                     in size: CGSize,
                     with timeValues: [TimeValue],
                     for duration: Double,
                     valueRange: ClosedRange<Double>,
                     circleRadius: CGFloat) {
        let w: CGFloat = size.width
        let h: CGFloat = size.height
        for timeValue in timeValues {
            let timeFraction: Double = timeValue.seconds / duration
            let x: CGFloat = w - w * CGFloat(timeFraction)
            let valueFraction: Double = (timeValue.value - valueRange.lowerBound) / (valueRange.upperBound - valueRange.lowerBound)
            let y: CGFloat = h - h * CGFloat(valueFraction)
            path.addEllipse(in: CGRect(x: x - circleRadius,
                                       y: y - circleRadius,
                                       width: circleRadius * 2,
                                       height: circleRadius * 2))
        }
    }
}
