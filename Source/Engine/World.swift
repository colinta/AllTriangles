//
//  World.swift
//  AllTriangles
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 AllTriangles. All rights reserved.
//

class World: Node {
    var screenSize: CGSize!
    var isUpdating = false

    private var didPopulateWorld = false

    var director: WorldView? {
        return (scene as? WorldScene)?.view as? WorldView
    }

    var touchedNode: Node?
    var defaultNode: Node?

    required init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    private func _populateWorld() {
    }

    func populateWorld() {
    }

    func restartWorld() {
        director?.presentWorld(self.dynamicType.init())
    }

}

extension World {

    // also called by addChild
    override func insertChild(node: SKNode, atIndex index: Int) {
        super.insertChild(node, atIndex: index)
        if let node = node as? Node {
            didAdd(node)
        }
    }

    func didAdd(node: Node) {
    }

    func willRemove(node: Node) {
        if node === defaultNode {
            defaultNode = nil
        }
    }

}

extension World {

    func updateWorld(dt: CGFloat) {
        if !didPopulateWorld {
            _populateWorld()
            populateWorld()
            didPopulateWorld = true
        }

        updateNodes(dt)
    }

}

extension World {

    func worldShook() {
    }

    func worldTapped(worldLocation: CGPoint) {
        guard let touchedNode = touchedNode else { return }

        let location = convertPoint(worldLocation, toNode: touchedNode)
        touchedNode.touchableComponent?.tapped(location)
    }

    func worldPressed(worldLocation: CGPoint) {
        guard let touchedNode = touchedNode else { return }

        let location = convertPoint(worldLocation, toNode: touchedNode)
        touchedNode.touchableComponent?.pressed(location)
    }

    func worldTouchBegan(worldLocation: CGPoint) {
        if let touchedNode = touchableNodeAtLocation(worldLocation) {
            self.touchedNode = touchedNode
        }
        else {
            self.touchedNode = defaultNode
        }

        if let touchedNode = self.touchedNode {
            let location = convertPoint(worldLocation, toNode: touchedNode)

            if let shouldAcceptTest = touchedNode.touchableComponent?.shouldAcceptTouch(location)
            where !shouldAcceptTest {
                self.touchedNode = nil
            }
            else {
                touchedNode.touchableComponent?.touchBegan(location)
            }
        }
    }

    func worldTouchEnded(worldLocation: CGPoint) {
        guard let touchedNode = touchedNode else { return }

        let location = convertPoint(worldLocation, toNode: touchedNode)
        touchedNode.touchableComponent?.touchEnded(location)

        self.touchedNode = nil
    }

    func worldDraggingBegan(worldLocation: CGPoint) {
        guard let touchedNode = touchedNode else { return }

        let location = convertPoint(worldLocation, toNode: touchedNode)
        touchedNode.touchableComponent?.draggingBegan(location)
    }

    func worldDraggingMoved(worldLocation: CGPoint) {
        guard let touchedNode = touchedNode else { return }

        let location = convertPoint(worldLocation, toNode: touchedNode)
        touchedNode.touchableComponent?.draggingMoved(location)
    }

    func worldDraggingEnded(worldLocation: CGPoint) {
        guard let touchedNode = touchedNode else { return }

        let location = convertPoint(worldLocation, toNode: touchedNode)
        touchedNode.touchableComponent?.draggingEnded(location)
    }

}

extension World {
    func touchableNodeAtLocation(worldLocation: CGPoint) -> Node? {
        return touchableNodeAtLocation(worldLocation, inChildren: self.children)
    }

    private func touchableNodeAtLocation(worldLocation: CGPoint, inChildren children: [SKNode]) -> Node? {
        for node in children.reverse() {
            if let node = node as? Node,
                touchableComponent = node.touchableComponent
            where touchableComponent.enabled {
                let nodeLocation = convertPoint(worldLocation, toNode: node)
                if touchableComponent.containsTouch(nodeLocation) {
                    return node
                }
            }
        }
        return nil
    }

}
