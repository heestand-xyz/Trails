import Foundation
import QuartzCore.CoreAnimation
import SwiftUI

public class Trailer: ObservableObject {
    
    /// trail count
    let count: Int
    
    /// range in seconds
    @Published public var duration: Double
    
    @Published var allTimeValues: [[TimeValue]]
    var valueRange: ClosedRange<Double> {
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
    var valueRangeWithPadding: ClosedRange<Double> {
        let range: Double = valueRange.upperBound - valueRange.lowerBound
        guard range > 0.0 else { return valueRange }
        let padding: Double = range * paddingFraction
        return (valueRange.lowerBound - padding)...(valueRange.upperBound + padding)
    }
    @Published public var paddingFraction: Double = 0.1
    
    var smallValueLines: [Double] {
        [0.5, 1.5]
    }
    var bigValueLines: [Double] {
        [0.0, 1.0, 2.0, 4.0, 16.0]
    }
    
    @Published public var colorsActive: Bool
    @Published public var colors: [Color]
    @Published public var colorBlend: Bool = true

    @Published public var lineWidth: CGFloat = 1
    
    @Published public var circlesActive: Bool = true
    @Published public var circleBorder: Bool = true
    @Published public var circleRadius: CGFloat = 4
    
    @Published var drawEnds: Bool = false
    
    var displayLink: CADisplayLink!
    
    public init(count: Int = 1, duration: Double) {
        precondition(count > 0)

        self.count = count
        self.duration = duration
        
        allTimeValues = .init(repeating: [], count: count)
        colorsActive = count > 1
        colors = (0..<count).map({ i in
            Color(hue: Double(i) / Double(count),
                  saturation: 2 / 3,
                  brightness: 1.0,
                  opacity: 1.0)
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
    
//    func magnutudeValues(in range: ClosedRange<Double>, detail: Bool = false) -> [Double] {
//
//        let span: Double = range.upperBound - range.lowerBound
//
//        var magnitude: Double!
//        if span <= 5.0 {
//            magnitude = 1.0
//        }
//        if magnitude == nil {
//            for i in 0..<9 {
//                let inMag: Double = pow(10.0, Double(i))
//                let outMag: Double = pow(10.0, Double(i + 1))
//                if span > inMag * 5.0 && span <= outMag * 5.0 {
//                    magnitude = outMag
//                    break
//                }
//            }
//        }
//        if magnitude == nil {
//            for i in 0..<9 {
//                let inMag: Double = 1.0 / pow(10.0, Double(i))
//                let outMag: Double = 1.0 / pow(10.0, Double(i + 1))
//                if span > inMag / 5.0 && span <= outMag / 5.0 {
//                    magnitude = ...inMag
//                    break
//                }
//            }
//        }
//        switch range {
//        case 0.000_000_1...0.000_001:
//            magnitude = 0.000_000_1
//        default:
//            <#code#>
//        }
//
//            = span < 0.001 ? nil : span < 0.01 ? 0.001 : span < 0.1 ? 0.01 : span < 1 ? 0.1 : span < 10 ? 1 : span < 100 ? 10 : span < 1000 ? 100 : span < 10000 ? 1000 : nil
//        if detail {
//            magnitude? /= 10 // Detail
//        }
//
//        if magnitude != nil {
//
//            var current_magnitude = ceil(low! / magnitude!) * magnitude!
//            while current_magnitude <= high! {
//
//                let mag_path = CGMutablePath()
//                let y = CGFloat((current_magnitude - low!) / span) * self.size.height
//                mag_path.move(to: CGPoint(x: self.size.width * (1.0 - layoutFraction), y: y))
//                mag_path.addLine(to: CGPoint(x: self.size.width, y: y))
//                let mag_line = SKShapeNode(path: mag_path)
//                mag_line.strokeColor = NSColor(white: 1.0, alpha: 0.5)
//                self.addChild(mag_line)
//
//                let mag_label = SKLabelNode(text: current_magnitude != 0 ? "\(current_magnitude)" : "0")
//                mag_label.fontName = "Helvetica-Bold"
//                mag_label.fontSize = 10 //self.size.width / 10 < 20 ? self.size.width / 10 : 20
//                mag_label.fontColor = NSColor(white: 1.0, alpha: 0.5)
//                mag_label.position = CGPoint(x: self.size.width / 20 < 10 ? self.size.width / 20 : 10, y: y)
//                mag_label.verticalAlignmentMode = .center
//                mag_label.horizontalAlignmentMode = .left
//                self.addChild(mag_label)
//
//                current_magnitude += magnitude!
//            }
//
//            magnitude! /= 10
//            current_magnitude = ceil(low! / magnitude!) * magnitude!
//            while current_magnitude <= high! {
//
//                let mag_path = CGMutablePath()
//                let y = CGFloat((current_magnitude - low!) / span) * self.size.height
//                mag_path.move(to: CGPoint(x: 0, y: y))
//                mag_path.addLine(to: CGPoint(x: self.size.width, y: y))
//                let mag_line = SKShapeNode(path: mag_path)
//                mag_line.strokeColor = NSColor(white: 1.0, alpha: 0.1)
//                self.addChild(mag_line)
//
//                current_magnitude += magnitude!
//            }
//
//        }
//
//    }
    
}
