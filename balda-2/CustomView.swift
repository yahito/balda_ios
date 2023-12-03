//
//  CustomView.swift
//  balda-2
//
//  Created by Andrey on 22/09/2023.
//

import UIKit
import SpriteKit
import GameplayKit
import CoreGraphics

protocol FlyListener {
    func move(x: Int, y: Int)
}

class CustomView: UIView {
    
    var face: UIImage! = UIImage(named: "enot")
    var eye: UIImage! = UIImage(named: "eye")
    var firstEyePos: CGPoint = CGPoint(x: 166, y: 131)
    var secondEyePos: CGPoint = CGPoint(x: 259, y: 131)
    var centerFirstEyePos: CGPoint = CGPoint(x: 166, y: 131);
    var centerSecondEyePos: CGPoint = CGPoint(x: 259, y: 131);
    var touchFlag: Bool = false
    
    var flies: [Fly] = [] // Assuming you have a Fly class or struct with getX() and getY() methods or equivalent properties
    var eyeRadius = CGFloat(78 / 2);
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self)
            let x = point.x
            let y = point.y
            
            firstEyePos = calcFirstEyePos(x: Int(x), y: Int(y))
            secondEyePos = calcSecondEyePos(x: Int(x), y: Int(y))
           
            self.setNeedsDisplay()
        }
    }
    

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        firstEyePos = centerFirstEyePos
        secondEyePos = centerSecondEyePos
        touchFlag = false
        
    }

    // If you want to handle the case where the touch event is interrupted or cancelled:
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        firstEyePos = centerFirstEyePos
        secondEyePos = centerSecondEyePos
        touchFlag = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGestureRecognizer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGestureRecognizer()
    }
    
    private func setupGestureRecognizer() {
        self.backgroundColor = .clear
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapRecognizer)
    }
    
    fileprivate func extractedFunc(_ recognizer: UITapGestureRecognizer) {
        
        class LocalClass: FlyListener {
            weak var outerInstance: CustomView?
            
            
            func move(x: Int, y: Int) {
                outerInstance?.firstEyePos = outerInstance?.calcFirstEyePos(x: Int(x), y: Int(y)) ?? CGPoint(x:0,y:0)
                outerInstance?.secondEyePos = outerInstance?.calcSecondEyePos(x: Int(x), y: Int(y)) ?? CGPoint(x:0,y:0)
                
                DispatchQueue.main.async {
                    self.outerInstance?.setNeedsDisplay()
                }
            }
        }
        
        let instance = LocalClass()
        instance.outerInstance = self
        
        let newFly = Fly(flyListener: instance)
        
        DispatchQueue.global().async { [weak newFly] in
            newFly?.backgroundTask()
        }
            
        flies.append(newFly)
    }
    
    @objc func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
        if (flies.isEmpty) {
            extractedFunc(recognizer)
        }
        
        
        // Redraw the view if needed
        self.setNeedsDisplay()
    }
    
    public func calcFirstEyePos(x: Int, y: Int) -> CGPoint {
        return getCirclePoint(x: x, y: y, circleCenterPoint: centerFirstEyePos);
    }
    
    private func calcSecondEyePos(x: Int, y: Int) -> CGPoint {
        return getCirclePoint(x: x, y: y, circleCenterPoint: centerSecondEyePos);
    }

    private func getCirclePoint(x: Int, y: Int, circleCenterPoint: CGPoint) -> CGPoint {
        let xrad: CGFloat = eyeRadius - 20
        let radians1 = atan2(circleCenterPoint.x - CGFloat(x), circleCenterPoint.y - CGFloat(y))

        let a = sin(radians1) * xrad
        let b = cos(radians1) * xrad
        return CGPoint(x: circleCenterPoint.x - a, y: circleCenterPoint.y - b)
    }


    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(), let face = face, let eye = eye else { return }
        
        // Draw face
        face.draw(at: CGPoint(x: 0, y: 0))
        
        // Draw eyes
        eye.draw(at: CGPoint(x: firstEyePos.x - (eye.size.width / 2), y: firstEyePos.y - (eye.size.height / 2)))
        eye.draw(at: CGPoint(x: secondEyePos.x - (eye.size.width / 2), y: secondEyePos.y - (eye.size.height / 2)))

        // Draw flies
        context.setFillColor(UIColor.red.cgColor)
        for fly in flies {
            let rect = CGRect(x: fly.getX() - 5, y: fly.getY() - 5, width: 10, height: 10)
            context.fill(rect)
        }
    }
    
    
    class Fly {
        private var x: Int
        private var y: Int
        
        private let random = GKRandomSource.sharedRandom()
        private var run = false
        private let flyListener: FlyListener

        init(flyListener: FlyListener) {
            self.flyListener = flyListener
            self.x = random.nextInt(upperBound: 480)
            self.y = random.nextInt(upperBound: 360)
            start();
        }

        private var moveCounter = 0
        private var positiveSign1 = true
        private var positiveSign2 = true

        func start() {
            run = true
        }

        public func backgroundTask() {
            while run {
                let addX = random.nextInt(upperBound: 5)
                x += positiveSign1 ? addX : -addX

                if x < 0 {
                    positiveSign1 = true
                } else if x > 480 {
                    positiveSign1 = false
                }

                let addY = random.nextInt(upperBound: 5)
                y += positiveSign2 ? addY : -addY

                if y < 0 {
                    positiveSign2 = true
                } else if y > 360 {
                    positiveSign2 = false
                }

                flyListener.move(x: x, y: y)

                moveCounter += 1

                if moveCounter > 30 {
                    moveCounter = 0
                    positiveSign1 = random.nextInt(upperBound: 2) == 1
                    positiveSign2 = random.nextInt(upperBound: 2) == 1
                }
                
                Thread.sleep(forTimeInterval: 0.01)
            }
        }

        func getX() -> Int {
            return x
        }

        func getY() -> Int {
            return y
        }
    }
    
}
