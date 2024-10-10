//
//  Color+light+dark.swift
//  Calendar
//
//  Created by jocke on 23/09/2024.
//

import Foundation
import SwiftUI

extension Color {
    func darker(by: CGFloat) -> Color {
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0
        let nsColor = NSColor(self)
        
        let _ = nsColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
        
        return Color(hue: hue, saturation: saturation, brightness: brightness - by/100)
    }
}
