import Foundation

public class Vec3 {
    private var values: [Double]
    
    public var x: Double {
        get {
            return self.values[0]
            }
        set (val) {
            self.values[0] = val
        }
    }
    public var y: Double {
        get {
            return self.values[1]
        }
        set (val) {
            self.values[1] = val
        }
    }
    public var z: Double {
        get {
            return self.values[2]
        }
        set (val) {
            self.values[2] = val
        }
    }
    
    public var squaredLength: Double {
        return (self.x * self.x) + (self.y * self.y) + (self.z * self.z)
    }
    
    public var length: Double {
        return sqrt(self.squaredLength)
    }
    
    public var unitVector: Vec3 {
        return self / self.length
    }
    
    public init(x: Double = 0, y: Double = 0, z: Double = 0) {
        self.values = [x, y, z]
    }
    
    public static prefix func -(vec: Vec3) -> Vec3 {
        return Vec3(x: -vec.x, y: -vec.y, z: -vec.z)
    }
    
    public static func +=(left: inout Vec3, right: Vec3) {
        left.x += right.x
        left.y += right.y
        left.z += right.z
    }
    
    public static func *=(vec: inout Vec3, t: Double) {
        vec.x *= t
        vec.y *= t
        vec.z *= t
    }
    
    public static func /=(vec: inout Vec3, t: Double) {
        vec *= 1.0/t
    }
    
    public static func +(left: Vec3, right: Vec3) -> Vec3 {
        return Vec3(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z)
    }
    
    public static func -(left: Vec3, right: Vec3) -> Vec3 {
        return Vec3(x: left.x - right.x, y: left.y - right.y, z: left.z - right.z)
    }
    
    public static func *(left: Vec3, right: Vec3) -> Vec3 {
        return Vec3(x: left.x * right.x, y: left.y * right.y, z: left.z * right.z)
    }
    
    public static func *(t: Double, vec: Vec3) -> Vec3 {
        return Vec3(x: vec.x * t, y: vec.y * t, z: vec.z * t)
    }
    
    public static func *(vec: Vec3, t: Double) -> Vec3 {
        return t * vec
    }
    
    public static func /(vec: Vec3, t: Double) -> Vec3 {
        return (1.0/t) * vec
    }
    
    public func dot(_ other: Vec3) -> Double {
        return (self.x * other.x) + (self.y * other.y) + (self.z * other.z)
    }
    
    public func cross(_ other: Vec3) -> Vec3 {
        return Vec3(
            x: (self.y * other.z) - (self.z * other.y),
            y: (self.z * other.x) - (self.x * other.z),
            z: (self.x * other.y) - (self.y * other.x))
    }
}
