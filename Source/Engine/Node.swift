//
//  Node.swift
//  AllTriangles
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 AllTriangles. All rights reserved.
//

class Node: SKNode {
    var size: CGSize = .zero
    var radius: CGFloat {
        if size.width == size.height {
            return size.width / 2
        }
        return (size.width + size.height) / 4
    }

    var components: [Component] = []
    var world: World? { return (scene as? WorldScene)?.world }

    weak var touchableComponent: TouchableComponent?

    convenience init(at point: CGPoint) {
        self.init()
        position = point
    }

    override required init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    func update(dt: CGFloat) {
    }

    var dontReset = false
    override func moveToParent(node: SKNode) {
        dontReset = true
        super.moveToParent(node)
        dontReset = false
    }

    override func removeFromParent() {
        if let world = world where !dontReset {
            world.willRemove(self)
        }
        super.removeFromParent()
    }

    func allChildNodes() -> [Node] {
        let nodes = children.filter { sknode in
            return sknode is Node
        } as! [Node]
        return nodes + nodes.flatMap { childNode in
            childNode.allChildNodes()
        }
    }

}

// MARK: Update Cycle

extension Node {

    func updateNodes(dt: CGFloat) {
        guard world != nil else { return }

        for component in components {
            if component.enabled {
                component.update(dt)
            }
        }
        update(dt)
        for sknode in children {
            if let node = sknode as? Node {
                node.updateNodes(dt)
            }
        }
    }

}

// MARK: Add/Remove Components

extension Node {

    func addComponent(component: Component) {
        component.node = self
        components << component

        if let component = component as? TouchableComponent { touchableComponent = component }

        component.didAddToNode()
    }

    func removeComponent(component: Component) {
        if let index = components.indexOf(component) {
            if component == touchableComponent { touchableComponent = nil }

            components.removeAtIndex(index)
        }
    }

}
