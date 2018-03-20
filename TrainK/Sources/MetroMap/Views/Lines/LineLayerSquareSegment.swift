//
//  LineLayerSquareSegment.swift
//  TrainK
//
//  Created by 张之行 on 3/20/18.
//  Copyright © 2018 begin Studio. All rights reserved.
//

import UIKit

class LineLayerSquareSegment: LineLayerSegment {
    var cornerRadius:CGFloat = 30
    override func draw(on path: UIBezierPath) {
        super.draw(on: path)
        let width = targetPoint.x - path.currentPoint.x
        let height = targetPoint.y - path.currentPoint.y
        if width != 0 && height != 0 {
            let intermediatePoint = self.segment.inverse ? CGPoint(
                x: path.currentPoint.x,
                y: targetPoint.y
            ) : CGPoint(
                x: targetPoint.x,
                y: path.currentPoint.y
            )
            let curveFrom = point(from: path.currentPoint, to: intermediatePoint, apart: self.cornerRadius)
            let curveTo = point(from: targetPoint, to: intermediatePoint, apart: self.cornerRadius)
            path.addLine(to: curveFrom)
            path.addQuadCurve(to: curveTo, controlPoint: intermediatePoint)
            
        }
        path.addLine(to: targetPoint)
    }
}