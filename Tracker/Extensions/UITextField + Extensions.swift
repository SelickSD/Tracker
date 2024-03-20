//
//  UITextField + Extensions.swift
//  Tracker
//
//  Created by Сергей Денисенко on 12.12.2023.
//
import UIKit
extension UITextField {
    func indent(size: CGFloat) {
        self.leftView = UIView(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: size, height: self.frame.height))
        self.leftViewMode = .always
    }
}
