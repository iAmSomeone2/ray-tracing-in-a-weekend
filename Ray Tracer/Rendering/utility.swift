//
//  utility.swift
//  Ray Tracer
//
//  Created by Brenden Davidson on 4/6/22.
//

import Foundation

extension Double {
    /// Clamp this float to a given range
    ///
    /// - Parameters:
    ///     - range: closed range to clamp to
    public func clamp(_ range: ClosedRange<Double>) -> Double {
        if self > range.upperBound {
            return range.upperBound
        } else if self < range.lowerBound {
            return range.lowerBound
        } else {
            return self
        }
    }
    
    public var bytes: [UInt8] {
        get {
            var bytes: [UInt8] = Array(repeating: 0, count: 8)
            var mask: UInt64 = 0xFF00000000000000
            var shift = 56
            
            for i in 0..<bytes.count {
                bytes[i] = UInt8((self.bitPattern & mask) >> shift)
                mask = mask >> 8
                shift -= 8
            }
            
            return bytes
        }
    }
}
