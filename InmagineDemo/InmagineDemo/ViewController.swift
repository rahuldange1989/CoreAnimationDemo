//
//  ViewController.swift
//  InmagineDemo
//
//  Created by Rahul Dange on 11/19/19.
//  Copyright © 2019 Rahul Dange. All rights reserved.
//

import UIKit
import MetalPetal

class ViewController: UIViewController {
    
    @IBOutlet weak var canvasViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var canvasViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet weak var canvasSizeField: UITextField!
    
    var padding: CGFloat = 15.0 // -- Initial padding for 3x3
    var imageView1: UIImageView? = nil
    var imageView2: UIImageView? = nil
    var imageView3: UIImageView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.createImageViews()
        self.drawRectangles()
    }
    
    // MARK: - Internal Methods -
    func createImageViews() {
        self.imageView1 = self.createImageView()
        self.imageView2 = self.createImageView()
        self.imageView3 = self.createImageView()
        for iv in [imageView1, imageView2, imageView3] {
            self.canvasView.addSubview(iv!)
        }
    }
    
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
        self.imageView1?.frame = .init(
                origin: .init(x: padding, y: padding),
                size: .init(width: rectLength, height: rectLength)
        )
        self.imageView2?.frame = .init(
            origin: .init(x: rectLength + (2.0 * padding), y: padding),
                size: .init(width: rectLength, height: rectLength)
        )
        if totalRows == 3 {
            self.imageView3?.frame = .init(
                origin: .init(x: (2.0 * rectLength) + (3.0 * padding), y: padding),
                    size: .init(width: rectLength, height: rectLength)
            )
        } else {
            self.imageView3?.frame = .init(
                origin: .init(x: padding, y: rectLength + (2.0 * padding)),
                    size: .init(width: rectLength, height: rectLength)
            )
        }
    }
    
    func createImageView() -> UIImageView {
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "apple")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    func applyVibranceFilter(image: CGImage, amount: CGFloat) {
        DispatchQueue.global(qos: .background).async {
            let mtImage = MTIImage.init(cgImage: image, options: [MTKTextureLoader.Option.SRGB : false])
            let vibranceFilter = MTIVibranceFilter.init()
            vibranceFilter.avoidsSaturatingSkinTones = true
            vibranceFilter.inputImage = mtImage
            vibranceFilter.amount = Float(amount)
            
            if let device = MTLCreateSystemDefaultDevice(),
                let outputImage = vibranceFilter.outputImage {
                do {
                    let context = try MTIContext(device: device)
                    let filteredImage = try context.makeCGImage(from: outputImage)
                    DispatchQueue.main.async {
                        self.imageView2?.image = UIImage(cgImage: filteredImage)
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func applyClaheFilter(image: CGImage) {
        DispatchQueue.global(qos: .background).async {
            let mtImage = MTIImage.init(cgImage: image, options: [MTKTextureLoader.Option.SRGB : false])
            let claheFilter = MTICLAHEFilter.init()
            claheFilter.clipLimit = 2.0
            claheFilter.inputImage = mtImage
            if let device = MTLCreateSystemDefaultDevice(),
                let outputImage = claheFilter.outputImage {
                do {
                    let context = try MTIContext(device: device)
                    let filteredImage = try context.makeCGImage(from: outputImage)
                    DispatchQueue.main.async {
                       self.imageView3?.image = UIImage(cgImage: filteredImage)
                    }
                } catch {
                    print(error)
                }
            }
        }
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
    
    @IBAction func applyFilters(_ sender: Any) {
        // -- vibrance filter amount used is 2.0
        self.applyVibranceFilter(image: (self.imageView1?.image?.cgImage)!, amount: 2.0)
        // -- clahe filter
        self.applyClaheFilter(image: (self.imageView1?.image?.cgImage)!)
    }
}

