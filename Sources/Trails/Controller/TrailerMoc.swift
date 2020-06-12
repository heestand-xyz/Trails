//
//  TrailerMoc.swift
//  Trails
//
//  Created by Hexagons on 2020-06-12.
//

import Foundation

let mocStartDate: Date = Date()

struct TrailerMoc {
    static func make() -> Trailer {
        let timeInterval: Double = 0.01
        let count: Int = 6
        let timeAmp: Double = 0.25
        let mocTrailer: Trailer = Trailer(count: count, duration: 1.0)
        var scales: [Double] = []
        var offsets: [Double] = []
        for _ in 0..<count {
            scales.append(.random(in: -10.0...10.0))
            offsets.append(.random(in: -10.0...10.0))
        }
        RunLoop.current.add(Timer(timeInterval: timeInterval, repeats: true, block: { _ in
            let time: Double = -mocStartDate.timeIntervalSinceNow
            for i in 0..<count {
                let f: Double = Double(i) / Double(count)
                mocTrailer.add(cos(time * timeAmp + .pi * 2 * f) * scales[i] + offsets[i], at: i)
            }
        }), forMode: .common)
        mocTrailer.circlesActive = false
//        mocTrailer.lineWidth = 10
//        mocTrailer.colorBlend = false
//        mocTrailer.colorsActive = false
        return mocTrailer
    }
}
