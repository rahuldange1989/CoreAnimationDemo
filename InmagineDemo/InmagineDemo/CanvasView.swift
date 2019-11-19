//
//  CanvasView.swift
//  InmagineDemo
//
//  Created by Rahul Dange on 11/19/19.
//  Copyright © 2019 Rahul Dange. All rights reserved.
//

import UIKit

class CanvasView: UIView {
    
    private var rectArray: [CGRect] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        let color:UIColor = UIColor.white

        for curRect in self.rectArray {
            let drect = CGRect(
                x: curRect.origin.x,
                y: curRect.origin.y,
                width: curRect.size.width,
                height: curRect.size.height)
            let bpath:UIBezierPath = UIBezierPath(rect: drect)

            color.set()
            bpath.stroke()
        }
    }
    
    // MARK: - Internal Methods -
    func setRectanglesArray(rectArray: [CGRect]) {
        self.rectArray = rectArray
    }
}
