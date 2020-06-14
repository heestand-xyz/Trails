//
//  TrailerMock.swift
//  Trails
//
//  Created by Hexagons on 2020-06-12.
//

import Foundation

let mockStartDate: Date = Date()

@available(iOS 13.0, tvOS 13.0, watchOS 6, macOS 10.15, *)
public struct TrailerMock {
    public static func make() -> Trailer {
        let timeInterval: Double = 0.01
        let count: Int = 6
        let timeAmp: Double = 1.0
        let mockTrailer: Trailer = Trailer(count: count, duration: 1.0)
        var scales: [Double] = []
        var offsets: [Double] = []
        for _ in 0..<count {
            scales.append(.random(in: -100.0...100.0))
            offsets.append(.random(in: -100.0...100.0))
        }
        RunLoop.current.add(Timer(timeInterval: timeInterval, repeats: true, block: { _ in
            let time: Double = -mockStartDate.timeIntervalSinceNow
            for i in 0..<count {
                let f: Double = Double(i) / Double(count)
                var value: Double = cos(time * timeAmp + .pi * 2 * f) * scales[i] + offsets[i]
                value *= cos(time * 0.1) / 2 + 0.5
                mockTrailer.add(value, at: i)
            }
        }), forMode: .common)
        mockTrailer.circlesActive = false
        mockTrailer.lineWidth = 2
        return mockTrailer
    }
}
