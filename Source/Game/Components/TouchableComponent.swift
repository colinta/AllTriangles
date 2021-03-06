//
//  TouchableComponent.swift
//  AllTriangles
//
//  Created by Colin Gray on 12/22/2015.
//  Copyright (c) 2015 AllTriangles. All rights reserved.
//

class TouchableComponent: Component {
    enum TouchEvent {
        // a quick tap, no dragging
        case Tapped
        case TappedInside
        case TappedOutside
        // any length press, no dragging
        case Pressed
        case PressedInside
        case PressedOutside
        // drag events
        case DragBegan
        case DragMoved
        case DragEnded
        // generic down/up/move
        case Down
        case DownInside
        case DownOutside
        case Up
        case UpInside
        case UpOutside
        case Moved
        case MovedInside
        case MovedOutside
        // useful for highlight effects
        case Enter
        case Exit
    }

    enum TouchTestShape {
        case Square
        case Circle

        var touchTest: TouchTest {
            switch self {
            case .Square:
                return { (node, location) in
                    let width = max(44, node.size.width)
                    let height = max(44, node.size.height)
                    if abs(location.x) <= width / 2 && abs(location.y) <= height / 2 {
                        return true
                    }
                    return false
                }
            case .Circle:
                return { (node, location) in
                    let width = max(44, node.size.width) / 2
                    let height = max(44, node.size.height) / 2
                    return location.lengthWithin(min(width, height))
                }
            }
        }
    }

    typealias OnTouchEvent = (CGPoint) -> Void
    typealias OnDragged = (CGPoint, CGPoint) -> Void
    typealias TouchTest = (Node, CGPoint) -> Bool

    var isIgnoring = false
    var isTouching = false
    var isTouchingInside = false
    var touchedFor: CGFloat = 0
    var prevLocation: CGPoint?
    var touchEvents = [TouchEvent: [OnTouchEvent]]()
    var _onDragged: [OnDragged] = []
    var containsTouchTest: TouchTest?
    var shouldAcceptTouchTest: TouchTest?

    override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init()
    }

    override func encodeWithCoder(encoder: NSCoder) {
        super.encodeWithCoder(encoder)
    }

    override func reset() {
        super.reset()
        touchEvents = [:]
        _onDragged = []
    }

    override func update(dt: CGFloat) {
        if isTouching {
            self.touchedFor = touchedFor + dt
        }
    }
}

extension TouchableComponent {

    func tapped(location: CGPoint) {
        guard !isIgnoring else { return }

        trigger(.Tapped, location: location)
        if isTouchingInside {
            trigger(.TappedInside, location: location)
        }
        else {
            trigger(.TappedOutside, location: location)
        }
    }

    func pressed(location: CGPoint) {
        guard !isIgnoring else { return }

        trigger(.Pressed, location: location)
        if isTouchingInside {
            trigger(.PressedInside, location: location)
        }
        else {
            trigger(.PressedOutside, location: location)
        }
    }

    func touchBegan(location: CGPoint) {
        isIgnoring = !self.enabled
        guard !isIgnoring else { return }

        isTouchingInside = false
        isTouching = true
        touchedFor = 0

        trigger(.Down, location: location)
        trigger(.Moved, location: location)

        touchUpdateInOut(location)
        if isTouchingInside {
            trigger(.DownInside, location: location)
            trigger(.MovedInside, location: location)
        }
        else {
            trigger(.DownOutside, location: location)
            trigger(.MovedOutside, location: location)
        }

        prevLocation = location
    }

    func touchEnded(location: CGPoint) {
        if !isIgnoring {
            if isTouchingInside {
                trigger(.Exit, location: location)
                trigger(.UpInside, location: location)
            }
            else {
                trigger(.UpOutside, location: location)
            }
            trigger(.Up, location: location)
        }

        touchedFor = 0
        isIgnoring = false
        isTouching = false
        isTouchingInside = false
        prevLocation = nil
    }

    func touchUpdateInOut(location: CGPoint) {
        let isInsideNow = containsTouch(location)
        if !isTouchingInside && isInsideNow {
            isTouchingInside = true
            trigger(.Enter, location: location)
        }
        else if isTouchingInside && !isInsideNow {
            isTouchingInside = false
            trigger(.Exit, location: location)
        }
    }

    func draggingBegan(location: CGPoint) {
        guard !isIgnoring else { return }

        trigger(.DragBegan, location: location)
        touchUpdateInOut(location)

        prevLocation = location
    }

    func draggingMoved(location: CGPoint) {
        guard !isIgnoring else { return }

        trigger(.Moved, location: location)
        trigger(.DragMoved, location: location)

        if let prevLocation = prevLocation {
            for handler in _onDragged {
                handler(prevLocation, location)
            }
        }

        touchUpdateInOut(location)
        if isTouchingInside {
            trigger(.MovedInside, location: location)
        }
        else {
            trigger(.MovedOutside, location: location)
        }

        prevLocation = location
    }

    func draggingEnded(location: CGPoint) {
        guard !isIgnoring else { return }
        trigger(.DragEnded, location: location)
    }

}

extension TouchableComponent {

    func onDragged(handler: OnDragged) {
        _onDragged << handler
    }
    func offDragged() {
        _onDragged = []
    }

    func off(event: TouchEvent) {
        touchEvents[event] = nil
    }

    func on(event: TouchEvent, _ handler: OnTouchEvent) {
        if touchEvents[event] == nil {
            touchEvents[event] = [handler]
        }
        else {
            touchEvents[event]! << handler
        }
    }

    func trigger(event: TouchEvent, location: CGPoint) {
        if let handlers = touchEvents[event] {
            for handler in handlers {
                handler(location)
            }
        }
    }

}

extension TouchableComponent {

    class func defaultTouchTest(shape: TouchTestShape = .Square) -> TouchTest {
        return shape.touchTest
    }


    func shouldAcceptTouch(location: CGPoint) -> Bool {
        return shouldAcceptTouchTest?(node, location) ?? true
    }

    func containsTouch(location: CGPoint) -> Bool {
        guard enabled else { return false }
        return containsTouchTest?(node, location) ?? false
    }

}
