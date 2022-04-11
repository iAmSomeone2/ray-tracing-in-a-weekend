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
    
    public func color(_ p: Renderable, depth: UInt16) -> Pixel {
        if depth <= 0 {
            return Pixel(red: 0, green: 0, blue: 0)
        }
        
        let hit = p.checkHit(with: self, tMin: 0.001, tMax: Double.infinity)
        if hit.didHit {
//            let target = hit.point! + hit.normal! + Vec3.randomInUnitSphere().unitVector
            let target = hit.point! + Vec3.randomInHemisphere(normal: hit.normal!)
            return 0.5 * Ray(origin: hit.point!, direction: target - hit.point!).color(p, depth: depth - 1)
        }
        
        let unitDir = self.direction.unitVector
        let t = 0.5 * (unitDir.y + 1.0)
        return (1.0 - t) * Pixel(red: 1.0, green: 1.0, blue: 1.0) + t * Pixel(red: 0.5, green: 0.7, blue: 1.0)
    }
}
