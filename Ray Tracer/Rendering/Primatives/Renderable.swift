//
//  Primative.swift
//  Ray Tracer
//
//  Created by Brenden Davidson on 4/7/22.
//

import Foundation

public struct HitRecord {
    public var didHit: Bool
    public var frontFace: Bool?
    public var point: Vec3?
    public var normal: Vec3?
    public var t: Double?
    
    public init(didHit: Bool, t: Double? = nil, point p: Vec3? = nil, normal n: Vec3? = nil) {
        self.didHit = didHit
        self.t = t
        self.point = p
        self.normal = n
    }
    
    public mutating func setFaceNormal(ray r: Ray, outwardNormal norm: Vec3) {
        self.frontFace = r.direction.dot(norm) < 0.0
        self.normal = self.frontFace! ? norm : -norm
    }
}

public protocol Renderable {
    func checkHit(with ray: Ray, tMin: Double, tMax: Double) -> HitRecord
}

public struct RenderableList: Renderable {
    public var objects: [Renderable] = []
    
    public func checkHit(with ray: Ray, tMin: Double, tMax: Double) -> HitRecord {
        var hit = HitRecord(didHit: false)
        var closestHit = tMax
        
        for object in objects {
            let tmpHit = object.checkHit(with: ray, tMin: tMin, tMax: closestHit)
            if tmpHit.didHit {
                hit = tmpHit
                closestHit = hit.t!
            }
        }
        
        return hit
    }
}
