//
//  LineLayer.swift
//  TrainK
//
//  Created by 张之行 on 3/19/18.
//  Copyright © 2018 begin Studio. All rights reserved.
//

import UIKit

extension Segment.DrawingMode {
    var drawer: LineLayerSegment.Type {
        switch self {
        case .line:
            return LineLayerDirectSegment.self
        case .triangle:
            return LineLayerTriangleSegment.self
        case .square:
            return LineLayerSquareSegment.self
        case .curve:
            return LineLayerCurveSegment.self
        case .parallel:
            return LineLayerParallelSegment.self
        }
    }
}
class LineLayer: MetroMapLayer {
    var line: Line
    init(_ line: Line, onMapView view: MetroMapView) {
        self.line = line
        super.init()
        self.mapView = view
    }
    override init(layer: Any) {
        guard let lineLayer = layer as? LineLayer else {
            fatalError("Station Layer init(layer: Any) got unexpected layer")
        }
        self.line = lineLayer.line
        self.emphasizeLayer = lineLayer.emphasizeLayer
        self.segmentDrawers = lineLayer.segmentDrawers
        super.init(layer: layer)
        self.mapView = lineLayer.mapView
    }
    var emphasizeLayer: CAShapeLayer?
    var segmentDrawers:[Segment:LineLayerSegment] = [:]
    func createDrawers() {
        for segment in line.segments {
            let drawer = segmentDrawers[segment] ?? segment.drawingMode.drawer.init(segment, onLayer: self)
            segmentDrawers[segment] = drawer
            mapView.stationMapping[segment.from]?.connectedSegmentDrawer.insert(drawer)
            mapView.stationMapping[segment.to]?.connectedSegmentDrawer.insert(drawer)
        }
    }
    override func draw(){
        self.emphasizeLayer?.removeFromSuperlayer()
        self.emphasizeLayer = nil
        let path = UIBezierPath()
        let emphasizePath = UIBezierPath()
        for drawer in segmentDrawers.values {
            if let delegate = self.mapView.delegate, delegate.metroMap(self.mapView, shouldEmphasizeElement: .segment(drawer.segment)) {
                drawer.draw(on: emphasizePath)
            } else {
                drawer.draw(on: path)
            }
        }
        let emphasizeLayer = CAShapeLayer()
        emphasizeLayer.lineCap = "square"
        self.frame = self.bounds
        self.lineCap = "square"
        emphasizeLayer.bounds = self.bounds
        emphasizeLayer.frame = self.bounds
        self.path = path.cgPath
        emphasizeLayer.path = emphasizePath.cgPath
        self.strokeColor = UIColor.gray.cgColor
        emphasizeLayer.strokeColor = self.line.color.cgColor
        self.fillColor = UIColor.clear.cgColor
        emphasizeLayer.fillColor = UIColor.clear.cgColor
        self.lineWidth = 10
        emphasizeLayer.lineWidth = 10
        self.emphasizeLayer = emphasizeLayer
        self.addSublayer(emphasizeLayer)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open func overlapRect(_ rect: CGRect) -> Bool {
        for segment in self.segmentDrawers.values {
            if segment.overlapRect(rect) {
                return true
            }
        }
        return false
    }
}
