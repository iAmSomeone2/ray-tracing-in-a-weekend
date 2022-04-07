//
//  Ray.swift
//  Ray Tracer
//
//  Created by Brenden Davidson on 4/7/22.
//

import Foundation

public struct Ray {
    public let origin: Vec3
    public let direction: Vec3
    
    public init(origin o: Vec3, direction d: Vec3) {
        self.origin = o
        self.direction = d
    }
    
    public func getPoint(at t: Double) -> Vec3 {
        return self.origin + (t * self.direction)
    }
    
    public func color(_ p: Primative) -> Pixel {
        if p.checkHit(with: self) {
            return Pixel(red: 1, green: 0, blue: 0)
        }
        
        let unitDir = self.direction.unitVector
        let t = 0.5 * (unitDir.y + 1.0)
        return (1.0 - t) * Pixel(red: 1.0, green: 1.0, blue: 1.0) + t * Pixel(red: 0.5, green: 0.7, blue: 1.0)
    }
}
