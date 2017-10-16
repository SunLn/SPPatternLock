//
//  Components.swift
//  SPPatternLock
//
//  Created by Suraj Pathak on 14/2/17.
//  Copyright © 2017 Suraj. All rights reserved.
//

import UIKit
import CoreGraphics

/// A customizable circle that aligned together form the input for pattern lock
class Circle: UIView {
    
    // *** Customizable attributes ***
    var outerColor = UIColor.magenta {
        didSet { setNeedsDisplay() }
    }
    
    var outerCircleRaidus: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }
    
    var outerCircleBorderColor: UIColor = UIColor.black {
        didSet { setNeedsDisplay() }
    }
    
    var outerCircleHightColor: UIColor = UIColor.black {
        didSet { setNeedsDisplay() }
    }
    
    var innercolor = UIColor.darkGray {
        didSet { setNeedsDisplay() }
    }
    
    var innerHighlightColor = UIColor.darkGray {
        didSet { setNeedsDisplay() }
    }
    
    var innerBorderColor = UIColor.darkGray {
        didSet { setNeedsDisplay() }
    }
    
    var highlightColor = UIColor.yellow {
        didSet { setNeedsDisplay() }
    }
    
    var lineWidth: CGFloat = 5 {
        didSet { setNeedsDisplay() }
    }
    
    /// If selected is `true`, the circle will appear as filled with a smaller circle
    var isSelected: Bool {
        didSet { setNeedsDisplay() }
    }
    
    override init(frame: CGRect) {
        self.isSelected = false
        super.init(frame: frame)
    }
    
    convenience init(radius: CGFloat) {
        let frame = CGRect(origin: .zero, size: CGSize(width: radius*2, height: radius*2))
        self.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        // Outermost circle
        let x: CGFloat, y: CGFloat
        var outerRectWidth = outerCircleRaidus * 2
        if outerRectWidth != 0 {
            x = rect.origin.x + rect.size.width/2 - outerCircleRaidus
            y = rect.origin.y + rect.size.height/2 - outerCircleRaidus
        } else {
            x = rect.origin.x + lineWidth
            y = rect.origin.y + lineWidth
            outerRectWidth = rect.size.width - 2 * lineWidth
        }
        
        let outerRect = CGRect(
            origin: CGPoint(x: x, y: y),
            size: CGSize(
                width: outerRectWidth,
                height: outerRectWidth
            )
        )

        ctx?.setLineWidth(lineWidth)
        
        ctx?.setFillColor(outerCircleBorderColor.cgColor)
        ctx?.setStrokeColor(outerColor.cgColor)
        
        ctx?.fillEllipse(in: outerRect)
        
        // For selected circles, the third circle
        if isSelected {
            let highlightRect = outerRect.insetBy(dx: -15, dy: -15)
            ctx?.setFillColor(innerBorderColor.cgColor)
            ctx?.fillEllipse(in: highlightRect)
            
            let highlightRect2 = highlightRect.insetBy(dx: 1, dy: 1)
            ctx?.setFillColor(highlightColor.cgColor)
            ctx?.fillEllipse(in: highlightRect2)
        }
        
        // Second circle
        let innerRect = outerRect.insetBy(dx: -4, dy: -4)
        if isSelected {
            ctx?.setFillColor(innerHighlightColor.cgColor)
            ctx?.fillEllipse(in: innerRect)
            ctx?.setFillColor(outerCircleHightColor.cgColor)
            ctx?.setStrokeColor(outerColor.cgColor)
            
            ctx?.fillEllipse(in: outerRect)
        } else {
            ctx?.setFillColor(innercolor.cgColor)
            ctx?.fillEllipse(in: innerRect)
        }
        

    }
    
}

/// A Line represents the line that will be drawn on the canvas when user drags around on the pattern lock
struct Line {
    
    var fromPoint: CGPoint
    var toPoint: CGPoint
    /// Boolean to indicate if the line is a full edge or a partial edge
    var isFullLength: Bool
    
    init(fromPoint: CGPoint, toPoint: CGPoint, isFullLength: Bool) {
        self.fromPoint = fromPoint
        self.toPoint = toPoint
        self.isFullLength = isFullLength
    }
    
}

/// A pattern view represents the drawing of bunch of lines on the canvas. It's composed of a number of lines
class PatternView: UIView {
    var lines: [Line] {
        didSet { setNeedsDisplay() }
    }
    
    var lineWidth: CGFloat = 5 {
        didSet { setNeedsDisplay() }
    }
    
    var lineColor: UIColor = UIColor.green {
        didSet { setNeedsDisplay() }
    }
    
    var linePointColor: UIColor = UIColor.white {
        didSet { setNeedsDisplay() }
    }
    
    override init(frame: CGRect) {
        lines = []
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setLineWidth(lineWidth)
        ctx?.setStrokeColor(lineColor.cgColor)
        for line in lines {
            ctx?.move(to: line.fromPoint)
            ctx?.addLine(to: line.toPoint)
            ctx?.strokePath()
            let bubbleWidth = lineWidth // The top and end of the line contains a circular bubble for better UI feel
            let frontBubbleFrame = CGRect(origin: CGPoint(x: line.fromPoint.x - bubbleWidth, y: line.fromPoint.y - bubbleWidth), size: CGSize(width: bubbleWidth * 2, height: bubbleWidth * 2))
            ctx?.setFillColor(linePointColor.cgColor)
            ctx?.fillEllipse(in: frontBubbleFrame)
            
            if line.isFullLength {
                let backBubbleFrame = CGRect(origin: CGPoint(x: line.toPoint.x - bubbleWidth, y: line.toPoint.y - bubbleWidth), size: CGSize(width: bubbleWidth * 2, height: bubbleWidth * 2))
                ctx?.setFillColor(linePointColor.cgColor)
                ctx?.fillEllipse(in: backBubbleFrame)
            }
        }
    }
}

