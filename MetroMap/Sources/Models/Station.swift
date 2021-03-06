//
//  Station.swift
//  TrainK
//
//  Created by 张之行 on 3/19/18.
//  Copyright © 2018 begin Studio. All rights reserved.
//

import UIKit
import SwiftyJSON

open class Node: NSObject {
    open var id: Int
    @objc dynamic open var position = CGPoint()
    public init(data: JSON, spacing: Double) {
        self.id = data["id"].intValue
        
        let position = data["position"]
        self.position = CGPoint(x: position[0].doubleValue * spacing, y: position[1].doubleValue * spacing)
        
    }
    public init(id: Int){
        self.id = id
    }
    
    override open var hashValue: Int {
        return self.id
    }
    
    open static func ==(lhs: Node, rhs: Node) -> Bool {
        return lhs.id == rhs.id
    }
}

open class Station:Node {
    public enum Level:String {
        case minor
        case major
        case interchange
        case intercity
    }
    open var level: Level = .minor

    open var name: String?

    public override init(data: JSON, spacing: Double) {
        super.init(data: data, spacing: spacing)
        self.name = data["name"].stringValue
        if let levelName = data["level"].string, let level = Level(rawValue: levelName) {
            self.level = level
        }
        
    }
    public override init(id: Int){
        super.init(id: id)
    }
}
