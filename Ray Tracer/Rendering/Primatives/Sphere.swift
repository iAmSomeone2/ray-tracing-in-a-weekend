import Foundation

public struct Sphere : Primative {
    public var origin: Vec3
    public var radius: Double
    
    public init(origin o: Vec3 = Vec3(), radius r: Double = 0.5) {
        self.origin = o
        self.radius = r
    }
    
    public func checkHit(with ray: Ray) -> Bool {
        let oc = ray.origin - self.origin
        let a = ray.direction.dot(ray.direction)
        let b = 2.0 * oc.dot(ray.direction)
        let c = oc.dot(oc) - self.radius * self.radius
        let discriminant = (b * b) - (4 * a * c)
        
        return discriminant > 0.0
    }
}
