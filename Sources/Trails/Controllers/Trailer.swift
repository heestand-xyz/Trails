import Foundation
#if os(iOS) || os(tvOS)
import QuartzCore.CoreAnimation
#endif
import SwiftUI

@available(iOS 13.0, tvOS 13.0, watchOS 6, macOS 10.15, *)
public class Trailer: ObservableObject {
    
    /// trail count
    let count: Int
    
    /// range in seconds
    ///
    /// values added longer ago than the duration will be removed
    @Published public var duration: Double
    
    var hasSomeValues: Bool { totalValueCount > 0 }
    var totalValueCount: Int { allTimeValues.map(\.count).reduce(0, +) }
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
    @Published var paddingFraction: Double = 0.1
    
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
    
    lazy var defaultFullValueRange: ClosedRange<Double> = {
        (-paddingFraction)...(1.0 + paddingFraction)
    }()
    let defaultSmallNonBigValueLines: [Double] = [0.25, 0.5, 0.75]
    let defaultBigValueLines: [Double] = [0.0, 1.0]
    
    /// *default* is `true` if `count` is `2` or more
    @Published public var colorsActive: Bool
    /// *default* is "rainbow"
    ///
    /// the number of values in the array **must match** the `count` passed to `Trailer`
    ///
    /// a hue is a value between `0.0` and `1.0`, low values: *red to green*, middle values: *green to blue*, high values: *blue to red*
    @Published public var hues: [Double]
    /// *default* is `true`
    @Published public var colorBlend: Bool = true

    /// *default* is `1.0`
    @Published public var lineWidth: CGFloat = 1.0
    
    /// *default* is `false`
    @Published public var circlesActive: Bool = false
    /// *default* is `true`
    @Published public var circleBorder: Bool = true
    /// *default* is `3.0`
    @Published public var circleRadius: CGFloat = 3.0
    
    /// *default* is `true`
    @Published public var drawValueEndLines: Bool = true
    /// *default* is `true` on **iOS** and **watchOS**
    ///
    /// can be useful to turn to `false` if your background is **transparent**
    @Published public var drawValueBackground: Bool  = {
        #if os(iOS) || os(watchOS)
        return true
        #else
        return false
        #endif
    }()
    /// *default* is `true` on **iOS** and **watchOS**
    ///
    /// can be useful to turn to `false` if your background is **transparent**
    @Published public var drawDefaultTextBackground: Bool = {
        #if os(iOS) || os(watchOS)
        return true
        #else
        return false
        #endif
    }()
    
    /// *default* is `8.0`
    @Published public var fontSize: CGFloat = 8.0

    /// *default* is `20.0`
    @Published public var leftSpacing: CGFloat = 20
    /// *default* is `20.0`
    @Published public var rightSpacing: CGFloat = 20.0

    #if os(iOS) || os(tvOS)
    var displayLink: CADisplayLink!
    #else
    var timerLink: Timer!
    #endif
    
    public init(count: Int = 1, duration: Double) {
        precondition(count > 0)

        self.count = count
        self.duration = duration
        
        allTimeValues = .init(repeating: [], count: count)
        colorsActive = count > 1
        hues = (0..<count).map({ i in
            Double(i) / Double(count)
        })
        
        #if os(iOS) || os(tvOS)
        displayLink = CADisplayLink(target: self, selector: #selector(frameLoop))
        displayLink.add(to: .current, forMode: .common)
        #else
        timerLink = Timer(timeInterval: 1.0 / 60.0, target: self, selector: #selector(frameLoop), userInfo: nil, repeats: true)
        RunLoop.current.add(timerLink, forMode: .common)
        #endif
     
        
    }
    
    public func addFirst(_ value: Double) {
        add(value, at: 0)
    }
    
    public func add(_ value: Double, at index: Int) {
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
    
    public func clear() {
        allTimeValues = .init(repeating: [], count: count)
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
