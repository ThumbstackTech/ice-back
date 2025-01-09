//
//  ExtensionUISlider.swift
//  HealthLayby
//
//  Created by CMR010 on 20/06/23.
//

import Foundation
import UIKit
class CustomSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let point = CGPoint(x: bounds.minX, y: bounds.midY)
        return CGRect(origin: point, size: CGSize(width: bounds.width, height: 15))
    }
}
