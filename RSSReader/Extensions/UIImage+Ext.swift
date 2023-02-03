//
//  UIImage+Ext.swift
//  RSSReader
//
//  Created by zuzex-62 on 13.01.2023.
//

import Foundation
import UIKit

extension UIImage {
    
    func decodedImage() -> UIImage {
        guard let cgImage = cgImage else { return self }
        let size = CGSize(width: cgImage.width, height: cgImage.height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: cgImage.bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        context?.draw(cgImage, in: CGRect(origin: .zero, size: size))
        guard let decodedImage = context?.makeImage() else { return self }
        return UIImage(cgImage: decodedImage)
    }
    
    var diskSize: Int {
        guard let cgImage = cgImage else { return 0 }
        return cgImage.bytesPerRow * cgImage.height
    }
    
    func save() -> String? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        guard let data = self.jpegData(compressionQuality: 1) else { return nil }
        let random = Int.random(in: 100..<100000)
        let imageName = "image\(random).jpeg"
        let url = documentsDirectory.appendingPathComponent(imageName)
        do {
            try data.write(to: url)
            return imageName
        } catch {
            print("Error saving image")
            return nil
        }
    }
    
}
