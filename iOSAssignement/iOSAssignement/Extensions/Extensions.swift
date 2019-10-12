//
//  Extensions.swift
//  iOSAssignement
//
//  Created by Иван on 9/30/19.
//  Copyright © 2019 Suprynovich.Technologies. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}

extension UIImageView {
    func setImageFromUrl(ImageURL: String, completion: @escaping (UIImage) -> Void) {
        URLSession.shared.dataTask(with: NSURL(string:ImageURL)! as URL, completionHandler: { [weak self] (data, response, error) -> Void in
            DispatchQueue.main.async {
                if let data = data {
                    if let img = UIImage(data: data) {
                        self?.image = img
                        completion(img)
                    }
                }
            }
        }).resume()
    }
}
