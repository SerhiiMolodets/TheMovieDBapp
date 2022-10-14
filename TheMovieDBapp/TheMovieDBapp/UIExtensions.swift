//
//  UIExtensions.swift
//  TheMovieDBapp
//
//  Created by Сергей Молодец on 06.10.2022.
//

import Foundation
import UIKit

class TextFieldWithPadding: UITextField {
    var textPadding = UIEdgeInsets(
        top: 10,
        left: 15,
        bottom: 10,
        right: 15
    )
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}

extension UIView {
    func layerGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors =
        [GradientColors.start,
         GradientColors.end]
        self.layer.masksToBounds = true
        gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
        self.layer.insertSublayer(gradientLayer, at: 0)
        // gradient
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1, b: 0, c: 0, d: 3.91, tx: 0, ty: -1.44))
        
        gradientLayer.bounds = self.bounds.insetBy(dx: -0.5*self.bounds.size.width, dy: -0.5*self.bounds.size.height)
        gradientLayer.position = self.center
    }
}
extension UIView {
    func addBorderGradient() {
        self.layer.cornerRadius = 6
        self.layer.masksToBounds = true
//        self.clipsToBounds = true
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [GradientColors.start, GradientColors.end]
        gradient.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.75, y: 0.5)
        let shape = CAShapeLayer()
        shape.lineWidth = 1
        shape.path = UIBezierPath(roundedRect: self.bounds.insetBy(dx: 0.25, dy: 0.5), cornerRadius: 6).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        self.layer.addSublayer(gradient)
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
