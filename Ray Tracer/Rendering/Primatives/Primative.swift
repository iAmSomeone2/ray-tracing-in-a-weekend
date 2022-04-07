//
//  Primative.swift
//  Ray Tracer
//
//  Created by Brenden Davidson on 4/7/22.
//

import Foundation

public protocol Primative {
    var origin: Vec3 { get set }
    
    func checkHit(with ray: Ray) -> Bool
}
