//
//  UIImageExt.swift
//  balda-2
//
//  Created by Andrey on 20/05/2024.
//

import UIKit

extension UIImage {
    func resized(to targetSize: CGSize) -> UIImage? {
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        //let scaleFactor = min(widthRatio, heightRatio)

        let scaledImageSize = CGSize(width: targetSize.width,
                                     height: targetSize.height)

        let renderer = UIGraphicsImageRenderer(size: scaledImageSize)
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: scaledImageSize))
        }

        return scaledImage
    }
}

extension UIView {
    func animateEmerging(front: UIView, back: UIView, duration: TimeInterval, delay: TimeInterval, _ completion: ((Bool) -> Void)? = nil) {
        

        
       /* self.alpha = 0
        let translation = CGAffineTransform(translationX: bounds.width, y: 0)
        let rotation = CGAffineTransform(rotationAngle: .pi / 180)
    
        let combinedTransform = translation.concatenating(rotation)
        
        var transform: CATransform3D

        transform = CATransform3DMakeRotation(CGFloat(0), 1, 0, 0) // X rotation
     //   transform = CATransform3DRotate(transform, CGFloat(180), 0, 1, 0) // Y rotation
        transform = CATransform3DRotate(transform, CGFloat(1), 0, 0, 1) // Z rotation

        let old = transform3D
        transform3D = transform
        //isHidden = false

        UIView.animate(withDuration: duration, delay: delay, options: [.beginFromCurrentState], animations: {
            self.alpha = 1
            self.transform3D = old
        }, completion: completion)*/
        
        back.isHidden = true
        back.transform3D = CATransform3DMakeRotation(.pi, 0, 1, 0)
        
        UIView.transition(from: front, to: self, duration: 1.0, options: [.transitionFlipFromLeft, .showHideTransitionViews],
        completion: completion)
    }
    

    func subview(at point: CGPoint) -> UIView? {
        for subview in subviews {
            if subview.frame.contains(point) {
                return subview
            }
        }
        return nil
    }
    
}


