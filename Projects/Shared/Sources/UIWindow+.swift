//
//  UIWindow+.swift
//  Shared
//
//  Created by 전성훈 on 3/13/25.
//

import UIKit

extension UIWindow {
    public static var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .last
    }
}
