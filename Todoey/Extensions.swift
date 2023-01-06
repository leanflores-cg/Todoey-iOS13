//
//  Extensions.swift
//  Todoey
//
//  Created by Lean Flores on 1/6/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
