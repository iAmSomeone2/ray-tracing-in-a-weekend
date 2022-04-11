import Foundation

protocol Material {
    func scatter(_ inRay: Ray, hitRecord: HitRecord, attenuation: inout Pixel, scatteredRay outRay: inout Ray) -> Bool
}
