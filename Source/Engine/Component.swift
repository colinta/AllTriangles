//
//  Component.swift
//  AllTriangles
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 AllTriangles. All rights reserved.
//

@objc
class Component: NSObject, NSCoding {
    var enabled = true
    weak var node: Node!

    func update(dt: CGFloat) {
    }

    func reset() {
    }

    override init() {
    }

    func didAddToNode() {
    }

    func removeFromNode() {
        if let node = node {
            node.removeComponent(self)
        }
        reset()
    }

    required init?(coder: NSCoder) {
        super.init()
    }

    func encodeWithCoder(encoder: NSCoder) {
    }

}

class GrowToComponent: Component {}
