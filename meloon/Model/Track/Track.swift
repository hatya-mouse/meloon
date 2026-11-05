//
//  Track.swift
//  meloon
//
//  Created by Kasatani Shuntaro on 2026/11/04.
//

import SwiftUI

/// A protocol that represents a track.
protocol Track {
    /// The unique ID for the track.
    var id: UUID { get set }
    /// The name of the track.
    var name: String { get set }
    /// The color of the track in HEX value.
    var color: RGBColor { get set }
}

/// Color for the track.
struct RGBColor {
    let r: UInt8
    let g: UInt8
    let b: UInt8
    let a: UInt8
    
    init(r: UInt8, g: UInt8, b: UInt8, a: UInt8 = 0) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
}

extension Color {
    init(rgbColor c: RGBColor) {
        self = Color(red: Double(c.r) / 255, green: Double(c.g) / 255, blue: Double(c.b) / 255, opacity: Double(255 - c.a) / 255)
    }
}
