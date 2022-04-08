import Foundation
import CoreGraphics

actor RenderContext {
    private let width: UInt16
    private let height: UInt16
    
    private var storage: [[Pixel]]
    
    init(width: UInt16, height: UInt16) {
        self.width = width
        self.height = height
        self.storage = Array(
            repeating: Array(repeating: Pixel(), count: Int(height)),
            count: Int(width))
    }
    
    public func getPixel(at loc: (x: UInt16, y: UInt16)) -> Pixel {
        return self.storage[Int(loc.x)][Int(loc.y)]
    }
    
    public func setPixel(_ pixel: Pixel, at loc: (x: UInt16, y: UInt16)) {
        self.storage[Int(loc.x)][Int(loc.y)] = pixel
    }
    
    public func getData() -> Data {
        var renderData = Data()
        
        for y in 0..<self.height {
            for x in 0..<self.width {
                let pixel = self.getPixel(at: (x, y))
                renderData.append(contentsOf: pixel.getData())
            }
        }
        
        return renderData
    }
}

public actor RenderProgress {
    public let target: UInt32
    private var value: UInt32 = 0
    
    public var progress: Double { Double(self.value) / Double(self.target) }
    
    public init(target t: UInt32 = 1) {
        self.target = t
    }
    
    public func reset() {
        self.value = 0
    }
    
    public func increment() {
        self.value += 1
    }
}

public struct Renderer {
    public static let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
    
    private let width: UInt16
    private let height: UInt16
    
    private var context: RenderContext
    private var renderProgress: RenderProgress
    private let camera: Camera
    
//    private let sphere = Sphere(origin: Vec3(x: 0, y: 0, z: -1), radius: 0.5)
    public var scene = RenderableList()
    
    public init(width w: UInt16 = 256, height h: UInt16 = 256) {
        self.width = w
        self.height = h
        
        self.context = RenderContext(width: w, height: h)
        self.renderProgress = RenderProgress(target: UInt32(w) * UInt32(h))
        self.camera = Camera(imageWidth: w, imageHeight: h)
        
        self.scene.objects.append(Sphere(origin: Vec3(x: 0, y: 0, z: -1), radius: 0.5))
        self.scene.objects.append(Sphere(origin: Vec3(x: 0, y: -100.5, z: -1), radius: 100))
    }
    
    public func getProgress() async -> Double {
        return await self.renderProgress.progress
    }
    
    private func renderRow(_ row: UInt16) async {
        for x in 1..<self.width {
            let col = self.width - x
            let u = Double(col) / Double(self.width - 1)
            let v = Double(row) / Double(self.height - 1)
            let ray = camera.getRay(for: (u, v))
            
            await self.context.setPixel(ray.color(self.scene), at: (col, height-row))
            await self.renderProgress.increment()
        }
    }
    
    public func getCGImage() async -> CGImage {
        // Get finished data from render context and create CGImage
        let renderData = await self.context.getData()
        
        return CGImage(
            width: Int(self.width),
            height: Int(self.height),
            bitsPerComponent: 8,
            bitsPerPixel: 8 * Pixel.componentCount,
            bytesPerRow: Pixel.componentCount * Int(self.width),
            space: Renderer.colorSpace,
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
            provider: CGDataProvider(data: renderData as CFData)!,
            decode: nil,
            shouldInterpolate: false,
            intent: .perceptual)!
    }
    
    public func render() async{
        await self.renderProgress.reset()
        // Render scene
        await withTaskGroup(of: Void.self) { group in
            for y in 1..<self.height {
//                let row = self.height - y
                group.addTask {
                    await renderRow(y)
                }
            }
        }
    }
}
