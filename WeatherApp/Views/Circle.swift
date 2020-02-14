//
//  Circle.swift
//  WeatherApp
//
//  Created by Mark Debbane on 2/12/20.
//  Copyright © 2020 Mark Debbane. All rights reserved.
//

import UIKit
@IBDesignable
class Circle: UIView {
    
    var circleView: UIBezierPath = UIBezierPath()
    var shapeLayer = CAShapeLayer()
    var size: CGRect?
    @IBInspectable var defaultSize: CGRect = CGRect(x: 0, y: 0, width:400, height: 400) {
        didSet {
            self.size = self.defaultSize
        }
    }
    
    @IBInspectable private var radius: CGFloat = 100 {
        didSet{
            let realSize = CGRect(x: self.frame.minX, y: self.frame.minY, width: self.radius*2, height: self.radius*2)
            circleView = UIBezierPath(ovalIn: CGRect(x: realSize.minX, y: realSize.minY, width: realSize.width, height:realSize.height))
        }
    }
    @IBInspectable private var topColor: UIColor = .white {
        didSet{
            self.updateColors(top: self.topColor, bottom: self.bottomColor, size: self.size ?? self.defaultSize)
        }
    }
    
    @IBInspectable private var bottomColor: UIColor = .black {
           didSet{
            self.updateColors(top: self.topColor, bottom: self.bottomColor, size: self.size ?? self.defaultSize)
           }
       }
       
    override func draw(_ rect: CGRect) {
        let realSize = CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.width)
        self.defaultSize = realSize
        circleView = UIBezierPath(ovalIn: CGRect(x: realSize.minX, y: realSize.minY, width: realSize.width, height: realSize.height))
        shapeLayer.path = circleView.cgPath
//        updateColors(top: .yellow, bottom: .darkYellow, size: realSize)
        self.backgroundColor = .clear
    }
    
    func updateColors(top: UIColor,  bottom: UIColor, size: CGRect){
        let gradient = CAGradientLayer()
        gradient.frame = size
        gradient.colors = [top.cgColor, bottom.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.mask = shapeLayer
        layer.addSublayer(gradient)
    }
    
}


