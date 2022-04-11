import Foundation
import CoreGraphics

actor RenderContext {
    private let width: UInt16
    private let height: UInt16
    
//    private var storage: [[Pixel]]
    private var storage: Data
    public var data: Data { self.storage }
    
    init(width: UInt16, height: UInt16) {
        self.width = width
        self.height = height
        self.storage = Data(
            repeating: 0,
            count: (Int(width) * Int(height)) * (Pixel.bitsPerComponent/8) * Pixel.componentCount)
    }
    
    private func getIndex(for loc: (x: UInt16, y: UInt16)) -> Int {
        let pixelCount = (Int(loc.y) * Int(self.width)) + Int(loc.x)
        return pixelCount * (Pixel.bitsPerPixel / 8)
    }
    
//    public func setPixel(_ pixel: Pixel, at loc: (x: UInt16, y: UInt16)) {
//        let index = self.getIndex(for: loc)
//        let pixData = pixel.pixBytes
//        for i in 0..<pixData.count {
//            self.storage[index + i] = pixData[i]
//        }
//    }
    
    public func setRow(bytes: [UInt8], row: UInt16) {
        let startIdx = (Int(row) * Int(self.width)) * (Pixel.bitsPerPixel / 8)
        for i in 0..<bytes.count {
            let idx = startIdx + i
            self.storage[idx] = bytes[i]
        }
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
    
    public func increment(by inc: UInt32 = 1) {
        self.value += inc
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
        var rowBytes: [UInt8] = []
        for x in 1..<self.width {
            let col = self.width - x
            let u = Double(col) / Double(self.width - 1)
            let v = Double(row) / Double(self.height - 1)
            let ray = camera.getRay(for: (u, v))
            
            let pixel = ray.color(self.scene)
            for i in 0..<pixel.pixBytes.count {
                rowBytes.append(pixel.pixBytes[i])
            }
        }
        // Write row to shared buffer
        await self.context.setRow(bytes: rowBytes, row: self.height - row)
        await self.renderProgress.increment(by: UInt32(self.width))
    }
    
    public func getCGImage() async -> CGImage {
        // Get finished data from render context and create CGImage
        let renderData = await self.context.data
        
        return CGImage(
            width: Int(self.width),
            height: Int(self.height),
            bitsPerComponent: Pixel.bitsPerComponent,
            bitsPerPixel: Pixel.bitsPerPixel,
            bytesPerRow: 8 * Int(self.width),
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
                group.addTask {
                    await renderRow(y)
                }
            }
        }
    }
}
