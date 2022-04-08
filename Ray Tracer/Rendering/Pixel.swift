import Foundation

public class Pixel {
    public static let range = 0.0...1.0
    public static let bitsPerComponent = 32
    public static let componentCount = 4
    
    private var data: [Double]
    
    public var red: Double {
        get { return self.data[0] }
        set(r) { self.data[0] = r.clamp(Pixel.range) }
    }
    
    public var u8red: UInt8 {
        get { return UInt8(self.red * Double(UINT8_MAX)) }
        set(r) {
            self.red = Double(r) / Double(UINT8_MAX)
        }
    }
    
    public var green: Double {
        get { return self.data[1] }
        set(g) { self.data[1] = g.clamp(Pixel.range) }
    }
    
    public var u8green: UInt8 {
        get { return UInt8(self.green * Double(UINT8_MAX)) }
        set(g) {
            self.green = Double(g) / Double(UINT8_MAX)
        }
    }
    
    public var blue: Double {
        get { return self.data[2] }
        set(b) { self.data[2] = b.clamp(Pixel.range) }
    }
    
    public var u8blue: UInt8 {
        get { return UInt8(self.blue * Double(UINT8_MAX)) }
        set(b) {
            self.blue = Double(b) / Double(UINT8_MAX)
        }
    }
    
    public var alpha: Double {
        get { return self.data[3] }
        set(a) { self.data[3] = a.clamp(Pixel.range) }
    }
    
    public var u8alpha: UInt8 {
        get { return UInt8(self.alpha * Double(UINT8_MAX)) }
        set(a) {
            self.alpha = Double(a) / Double(UINT8_MAX)
        }
    }
    
    public init() {
        self.data = [0.0, 0.0, 0.0, 0.0]
    }
    
    public init(red r: Double, green g: Double, blue b: Double, alpha a: Double = 1.0) {
        self.data = [r, g, b, a]
    }
    
    public func getData() -> Data {
        return Data([
            self.u8alpha,
            self.u8red,
            self.u8green,
            self.u8blue
        ])
    }
    
    public static func +=(left: inout Pixel, right: Pixel) {
        for i in 0..<3 {
            left.data[i] += right.data[i]
        }
    }
    
    public static func *=(pix: inout Pixel, t: Double) {
        for i in 0..<3 {
            pix.data[i] *= t
        }
    }
    
    public static func /=(pix: inout Pixel, t: Double) {
        pix *= 1.0/t
    }
    
    public static func +(left: Pixel, right: Pixel) -> Pixel {
        return Pixel(
            red: left.red + right.red,
            green: left.green + right.green,
            blue: left.blue + right.blue)
    }
    
    public static func +(left: Vec3, right: Pixel) -> Pixel {
        return Pixel(
            red: left.x + right.red,
            green: left.y + right.green,
            blue: left.z + right.blue)
    }
    
    public static func -(left: Pixel, right: Pixel) -> Pixel {
        return Pixel(
            red: left.red - right.red,
            green: left.green - right.green,
            blue: left.blue - right.blue)
    }
    
    public static func *(left: Pixel, right: Pixel) -> Pixel {
        return Pixel(
            red: left.red * right.red,
            green: left.green * right.green,
            blue: left.blue * right.blue)
    }
    
    public static func *(t: Double, pix: Pixel) -> Pixel {
        return Pixel(
            red: t * pix.red,
            green: t * pix.green,
            blue: t * pix.blue)
    }
    
    public static func /(pix: Pixel, t: Double) -> Pixel {
        return (1.0/t) * pix
    }
}
