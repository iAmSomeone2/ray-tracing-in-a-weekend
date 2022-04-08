//
//  Camera.swift
//  Ray Tracer
//
//  Created by Brenden Davidson on 4/7/22.
//

import Foundation

public struct Camera {
    public let imageWidth: UInt16
    public let imageHeight: UInt16
    
    public var aspectRatio: Double {
        return Double(imageWidth) / Double(imageHeight)
    }
    
    public let viewportHeight: Double = 2.0
    public var viewportWidth: Double {
        return self.aspectRatio * Double(self.viewportHeight)
    }
    
    public let focalLength: Double = 1.0
    
    public let origin = Vec3(x: 0, y: 0, z: 0)
    public var horizontal: Vec3 {
        return Vec3(x: viewportWidth, y: 0, z: 0)
    }
    public var vertical: Vec3 {
        return Vec3(x: 0, y: viewportHeight, z: 0)
    }
    public var lowerLeftCorner: Vec3 {
        return origin - horizontal/2.0 - vertical/2.0 - Vec3(x: 0, y: 0, z: focalLength)
    }
    
    public init(imageWidth width: UInt16, imageHeight height: UInt16) {
        self.imageWidth = width
        self.imageHeight = height
    }
    
    public func getRay(for loc: (u: Double, v: Double)) -> Ray {
        return Ray(
            origin: origin,
            direction: lowerLeftCorner + loc.u * horizontal + loc.v * vertical - origin)
    }
}
