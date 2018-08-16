//
//  UIImageViewExtension.swift
//  RepCounter
//

import Foundation
import UIKit

// simple caching mechanism
let cachedImage = NSCache<NSString, UIImage>()

extension UIImageView {
    func downloadFrom(urlString: String, contentMode mode: UIViewContentMode = .scaleAspectFit, placeHolder: UIImage = #imageLiteral(resourceName: "logo")) {
        contentMode = mode
        
        if let cachedImage = cachedImage.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    self.image = placeHolder
                    return
            }
            cachedImage.setObject(image, forKey: urlString as NSString)
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
