//
//  ViewController.swift
//  InmagineDemo
//
//  Created by Rahul Dange on 11/19/19.
//  Copyright © 2019 Rahul Dange. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var canvasViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var canvasViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet weak var canvasSizeField: UITextField!
    
    var padding: CGFloat = 15.0 // -- Initial padding for 3x3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.drawRectangles()
    }
    
    // MARK: - Internal Methods -
    func drawRectangles() {
        var rectArray: [CGRect] = []
        let canvasLength = CGFloat(((self.canvasSizeField.text)! as NSString).floatValue)
        let noOfSpaces: CGFloat = padding == 15.0 ? 4.0 : 3.0
        let totalRows = padding == 15.0 ? 3 : 2
        let rectLength = (canvasLength - (padding * noOfSpaces)) / CGFloat(totalRows)
        
        // -- draw rectangles
        for i in 0..<totalRows {
            let y = (i * Int(rectLength)) + (i * Int(padding)) + Int(padding)
            for j in 0..<totalRows {
                let x = (j * Int(rectLength)) + (j * Int(padding)) + Int(padding)
                rectArray.append(.init(
                    origin: .init(x: x, y: y),
                    size: .init(width: rectLength, height: rectLength))
                )
            }
        }
        
        self.canvasView.setRectanglesArray(rectArray: rectArray)
        self.canvasView.setNeedsDisplay()
    }
    
    // MARK: - Event Handler Methods -
    @IBAction func canvasSizeChanged(_ sender: Any) {
        // -- hide keyboard
        self.view.endEditing(true)
        
        var widthHeight = ((self.canvasSizeField.text)! as NSString).floatValue
        if widthHeight == 0.0 {
            widthHeight = 300.0
            self.canvasSizeField.text = "150"
        }
        
        // -- change canvas size
        self.canvasViewWidthConstraint.constant = CGFloat(widthHeight)
        self.canvasViewHeightConstraint.constant = CGFloat(widthHeight)
        self.drawRectangles()
    }
    
    @IBAction func changeCanvasLayout(_ sender: Any) {
        let navBtn = sender as! UIBarButtonItem
        if navBtn.tag == 1 {
            navBtn.title = "3x3"
            padding = 30.0
            navBtn.tag = 2
        } else {
            navBtn.title = "2x2"
            padding = 15.0
            navBtn.tag = 1
        }
        self.drawRectangles()
    }
}

