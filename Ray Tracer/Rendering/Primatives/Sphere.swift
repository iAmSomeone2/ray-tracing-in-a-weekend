import Foundation

public struct Sphere : Renderable {
    public var origin: Vec3
    public var radius: Double
    
    public init(origin o: Vec3 = Vec3(), radius r: Double = 0.5) {
        self.origin = o
        self.radius = r
    }
    
    public func checkHit(with ray: Ray, tMin: Double = 0.001, tMax: Double = Double.infinity) -> HitRecord {
        let oc = ray.origin - self.origin
        let a = ray.direction.squaredLength
        let halfB = oc.dot(ray.direction)
        let c = oc.squaredLength - self.radius * self.radius
        let discriminant = (halfB * halfB) - (a * c)
        
        if discriminant < 0.0 {
            return HitRecord(didHit: false)
        }
        let sqrtD = sqrt(discriminant)
        
        // Find the nearest root that lies in the acceptable range
        var root = (-halfB - sqrtD) / a
        if root < tMin || root > tMax {
            root = (-halfB + sqrtD) / a
            if root < tMin || root > tMax {
                return HitRecord(didHit: false)
            }
        }
        
        let point = ray.getPoint(at: root)
        var hit = HitRecord(didHit: true, t: root, point: point)
        let normal = (point - self.origin) / self.radius
        hit.setFaceNormal(ray: ray, outwardNormal: normal)
        
        return hit
    }
}
