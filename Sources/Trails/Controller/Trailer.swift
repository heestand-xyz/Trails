import Foundation
import QuartzCore.CoreAnimation
import SwiftUI

public class Trailer: ObservableObject {
    
    /// trail count
    let count: Int
    
    /// range in seconds
    @Published public var duration: Double
    
    @Published var allTimeValues: [[TimeValue]]
    var lastValuesAndHues: [(value: Double, hue: Double)] {
        zip(lastValues, lastHues).map { zip -> (value: Double, hue: Double) in
            (value: zip.0, hue: zip.1)
        }
    }
    var lastValues: [Double] { allTimeValues.compactMap(\.last).map(\.value) }
    var lastHues: [Double] {
        var hues: [Double] = []
        for (i, timeValues) in allTimeValues.enumerated() {
            if !timeValues.isEmpty {
                let hue: Double = self.hues[i]
                hues.append(hue)
            }
        }
        return hues
    }
    private var valueRange: ClosedRange<Double> {
        var min: Double!
        var max: Double!
        for timeValues in allTimeValues {
            for timeValue in timeValues {
                if min == nil || timeValue.value < min! {
                    min = timeValue.value
                }
                if max == nil || timeValue.value > max! {
                    max = timeValue.value
                }
            }
        }
        guard min != nil && max != nil else {
            return 0.0...0.0
        }
        return min...max
    }
    var fullValueRange: ClosedRange<Double> {
        let range: Double = valueRange.upperBound - valueRange.lowerBound
        guard range > 0.0 else { return valueRange }
        let padding: Double = range * paddingFraction
        return (valueRange.lowerBound - padding)...(valueRange.upperBound + padding)
    }
    @Published public var paddingFraction: Double = 0.1
    
    var magnitude: Double {
        Trailer.getMagnitude(in: valueRange)
    }
    
    var smallNonBigValueLines: [Double] {
        smallValueLines.filter { value -> Bool in
            !bigValueLines.contains(value)
        }
    }
    var smallValueLines: [Double] {
        Trailer.getMagnitudes(in: valueRange, at: magnitude, detail: 0.25, padding: 2)
    }
    var bigValueLines: [Double] {
        Trailer.getMagnitudes(in: valueRange, at: magnitude)
    }
    
    @Published public var colorsActive: Bool
    @Published public var hues: [Double]
    @Published public var colorBlend: Bool = true

    @Published public var lineWidth: CGFloat = 1
    
    @Published public var circlesActive: Bool = true
    @Published public var circleBorder: Bool = true
    @Published public var circleRadius: CGFloat = 4
    
    @Published var drawEnds: Bool = true
    
    var displayLink: CADisplayLink!
    
    public init(count: Int = 1, duration: Double) {
        precondition(count > 0)

        self.count = count
        self.duration = duration
        
        allTimeValues = .init(repeating: [], count: count)
        colorsActive = count > 1
        hues = (0..<count).map({ i in
            Double(i) / Double(count)
        })
     
        displayLink = CADisplayLink(target: self, selector: #selector(frameLoop))
        displayLink.add(to: .current, forMode: .common)
        
    }
    
    public func add(_ value: Double, at index: Int = 0) {
        precondition(index >= 0)
        precondition(index < count)
        guard duration > 0.0 else { return }
        let timeValue: TimeValue = TimeValue(value: value)
        allTimeValues[index].append(timeValue)
    }
    
    public func add(_ values: [Double]) {
        precondition(values.count == count)
        guard duration > 0.0 else { return }
        for i in 0..<count {
            let value: Double = values[i]
            let timeValue: TimeValue = TimeValue(value: value)
            allTimeValues[i].append(timeValue)
        }
    }

    @objc func frameLoop() {
        guard duration > 0.0 else {
            let totalCount: Int = allTimeValues.map(\.count).reduce(0, +)
            guard totalCount == 0 else {
                allTimeValues = .init(repeating: [], count: count)
                return
            }
            return
        }
        for i in 0..<count {
            for (j, timeValue) in allTimeValues[i].enumerated() {
                var timeValue: TimeValue = timeValue
                timeValue.seconds = -timeValue.time.timeIntervalSinceNow
                allTimeValues[i][j] = timeValue
            }
        }
        for i in 0..<count {
            for j in stride(from: allTimeValues[i].count - 1, through: 0, by: -1) {
                let timeValue: TimeValue = allTimeValues[i][j]
                if timeValue.seconds > duration {
                    allTimeValues[i].remove(at: j)
                }
            }
        }
    }
    
    static func getMagnitude(in range: ClosedRange<Double>) -> Double {

        let low: Double = range.lowerBound
        let high: Double = range.upperBound
        let span: Double = high - low

        var magnitude: Double?
        if span >= 0.5 && span <= 5.0 {
            magnitude = 1.0
        }
        if magnitude == nil {
            for i in 0..<9 {
                let inMag: Double = pow(10.0, Double(i))
                let outMag: Double = pow(10.0, Double(i + 1))
                if span > inMag * 5.0 && span <= outMag * 5.0 {
                    magnitude = outMag
                    break
                }
            }
        }
        if magnitude == nil {
            for i in 0..<9 {
                let inMag: Double = 1.0 / pow(10.0, Double(i))
                let outMag: Double = 1.0 / pow(10.0, Double(i + 1))
                if span < inMag / 2.0 && span >= outMag / 2.0 {
                    magnitude = outMag
                    break
                }
            }
        }
        
        return magnitude ?? 1.0
        
    }
    
    static func getMagnitudes(in range: ClosedRange<Double>,
                              detail: Double = 1.0,
                              padding: Int = 0) -> [Double] {
        let magnitude: Double = getMagnitude(in: range)
        return getMagnitudes(in: range, at: magnitude, detail: detail, padding: padding)
    }
    
    static func getMagnitudes(in range: ClosedRange<Double>,
                              at magnitude: Double,
                              detail: Double = 1.0,
                              padding: Int = 0) -> [Double] {
        precondition(detail != 0.0)
        precondition(padding >= 0)

        let low: Double = range.lowerBound
        let high: Double = range.upperBound

        var magnitude: Double = magnitude
        magnitude *= detail
            
        var magnitudes: [Double] = []
        let lowMagnitude: Double = (round(low / magnitude) * magnitude) - (Double(padding) * magnitude)
        let highMagnitude: Double = (round(high / magnitude) * magnitude) + (Double(padding) * magnitude)
        var currentMagnitude: Double = lowMagnitude
        while currentMagnitude <= highMagnitude {
            magnitudes.append(currentMagnitude)
            currentMagnitude += magnitude
        }
        
        return magnitudes

    }
    
}
