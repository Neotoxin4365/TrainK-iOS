//
//  Station.swift
//  TrainK
//
//  Created by 张之行 on 3/19/18.
//  Copyright © 2018 begin Studio. All rights reserved.
//

import UIKit
import SwiftyJSON

open class Node:Hashable {
    open var id: Int
    open var position: CGPoint
    public init(data: JSON) {
        self.id = data["id"].intValue
        
        let position = data["position"]
        self.position = CGPoint(x: position[0].doubleValue, y: position[1].doubleValue)
        
    }
    
    open var hashValue: Int {
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
    open var level: Level = .major

    open var name: String?

    public override init(data: JSON) {
        super.init(data: data)
        self.name = data["name"].stringValue
        if let levelName = data["level"].string, let level = Level(rawValue: levelName) {
            self.level = level
        }
        
    }
}