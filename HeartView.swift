//
//  HeartView.swift
//  FitBook2
//
//  Created by Jiwoo Lee on 3/18/17.
//  Copyright © 2017 jlee29. All rights reserved.
//

import UIKit

class HeartView: UIView {
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        self.backgroundColor = UIColor.white
        
        let upperShift = bounds.size.height/4
        
        let heartCenter = CGPoint(x: bounds.midX, y: bounds.midY-upperShift)
        path.move(to: CGPoint(x:heartCenter.x - bounds.size.width/4, y: bounds.midY-upperShift))
        path.addLine(to: CGPoint(x:heartCenter.x, y: bounds.midY + bounds.size.height/4-upperShift))
        path.addLine(to: CGPoint(x:heartCenter.x + bounds.size.width/4, y: bounds.midY-upperShift))
        path.addQuadCurve(to: heartCenter, controlPoint: CGPoint(x:heartCenter.x+bounds.size.width/8, y:heartCenter.y-upperShift/2))
        path.addQuadCurve(to: CGPoint(x:heartCenter.x - bounds.size.width/4, y: bounds.midY-upperShift), controlPoint: CGPoint(x:heartCenter.x-bounds.size.width/8, y:heartCenter.y-upperShift/2))
        
        UIColor.red.setStroke()
        path.stroke()
        UIColor.red.setFill()
        path.fill(with: .normal, alpha: 0.5)
    }
}
