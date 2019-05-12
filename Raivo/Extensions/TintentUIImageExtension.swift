//
//  TintentUIImageExtension.swift
//  Raivo
//
//  Created by Tijme Gommers on 28/04/2019.
//  Copyright © 2019 Tijme Gommers. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    var withIconEffect: UIImage? {
        let effect = (UIApplication.shared.delegate as! AppDelegate).getIconEffect()
        
        switch effect {
        case MiscellaneousIconsEffectFormOption.OPTION_GRAYSCALE.value:
            return applying(saturation: 0)
//        case MiscellaneousIconsEffectFormOption.OPTION_RED_TINT.value:
//            return fillWithColor(ColorHelper.getTint())
        default:
            return self
        }
    }
    
    func fillWithColor(_ color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
    func applying(saturation value: NSNumber) -> UIImage? {
        return CIImage(image: self)?
            .applyingFilter("CIColorControls", parameters: [kCIInputSaturationKey: value])
            .image
    }
    
}

extension CIImage {
    
    var image: UIImage? {
        let image = UIImage(ciImage: self)
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        defer { UIGraphicsEndImageContext() }
        image.draw(in: CGRect(origin: .zero, size: image.size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}
