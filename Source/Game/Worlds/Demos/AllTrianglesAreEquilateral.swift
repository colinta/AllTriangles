//
//  AllTrianglesAreEquilateral.swift
//  AllTriangles
//
//  Created by Colin Gray on 12/21/2015.
//  Copyright (c) 2015 AllTriangles. All rights reserved.
//

class AllTrianglesAreEquilateral: World {
    var A: Node!
    var B: Node!
    var C: Node!
    var A_bisect: SKSpriteNode = {
        let s = SKSpriteNode(id: .ColorLine(length: 500, color: 0x00FF00))
        s.anchorPoint = CGPoint(0, 0.5)
        return s
    }()
    var D = Dot()
    var BC_segment: SKSpriteNode = {
        let s = SKSpriteNode(id: .ColorLine(length: 500, color: 0x0000FF))
        s.anchorPoint = CGPoint(0, 0.5)
        return s
    }()
    var E = Dot()
    var Bp = Dot()
    var Cp = Dot()

    var BE_segment: SKSpriteNode = {
        let s = SKSpriteNode()
        s.anchorPoint = CGPoint(0, 0.5)
        return s
    }()
    var CE_segment: SKSpriteNode = {
        let s = SKSpriteNode()
        s.anchorPoint = CGPoint(0, 0.5)
        return s
    }()

    var BBp_segment: SKSpriteNode = {
        let s = SKSpriteNode()
        s.anchorPoint = CGPoint(0, 0.5)
        return s
    }()
    var EBp_segment: SKSpriteNode = {
        let s = SKSpriteNode()
        s.anchorPoint = CGPoint(0, 0.5)
        return s
    }()
    var CCp_segment: SKSpriteNode = {
        let s = SKSpriteNode()
        s.anchorPoint = CGPoint(0, 0.5)
        return s
    }()
    var ECp_segment: SKSpriteNode = {
        let s = SKSpriteNode()
        s.anchorPoint = CGPoint(0, 0.5)
        return s
    }()

    var dots: [Node]!
    var lines: [SKSpriteNode]!
    var moveableNode: Node!
    var update = true

    override func populateWorld() {
        let touchComponent = TouchableComponent()
        let touchNode = Node()
        touchNode.addComponent(touchComponent)
        touchComponent.on(.Down) { p in
            var closest = self.dots.first!
            for d in self.dots {
                if p.distanceTo(d.position) < p.distanceTo(closest.position) {
                    closest = d
                }
            }
            self.moveableNode = closest
        }
        touchComponent.onDragged { (p1, p2) in
            self.moveableNode.position += p2 - p1
            self.update = true
        }
        defaultNode = touchNode
        self << touchNode

        let dots = [
            Dot(at: CGPoint(0, 100)),
            Dot(at: CGPoint(-50, 0)),
            Dot(at: CGPoint(40, 10)),
        ]
        A = dots[0]
        B = dots[1]
        C = dots[2]
        self.dots = dots

        A_bisect.position = A.position
        self << self.D
        self << self.A_bisect
        self << self.BC_segment
        self << self.E
        self << self.Bp
        self << self.Cp
        self << self.BE_segment
        self << self.CE_segment
        self << self.BBp_segment
        self << self.EBp_segment
        self << self.CCp_segment
        self << self.ECp_segment

        let lines: [SKSpriteNode] = [
            SKSpriteNode(),
            SKSpriteNode(),
            SKSpriteNode(),
        ]
        self.lines = lines

        for (dot, line) in dots.zip(lines) {
            self << dot

            line.anchorPoint = CGPoint(0, 0.5)
            dot << line
        }
        moveableNode = dots[0]
    }

    override func update(dt: CGFloat) {
        guard update else { return }

        var prevDot = dots.last!
        for (dot, line) in dots.zip(lines) {
            let dist = dot.distanceTo(prevDot)
            line.textureId(.ColorLine(length: dist, color: 0xFF0000))
            line.zRotation = dot.angleTo(prevDot)
            prevDot = dot
        }

        A_bisect.position = A.position
        do {
            let angleAB = A.angleTo(B)
            let angleAC = A.angleTo(C)
            if abs(angleAB - angleAC) > TAU_2 {
                A_bisect.zRotation = normalizeAngle((angleAC + angleAB) / 2 + TAU_2)
            }
            else {
                A_bisect.zRotation = (angleAB + angleAC) / 2
            }
        }
        D.position = (B.position + C.position) / 2
        BC_segment.position = D.position
        BC_segment.zRotation = B.angleTo(C) - TAU_4

        let s1 = Segment(p1: A.position, p2: A.position + CGPoint(r: 1, a: A_bisect.zRotation))
        let s2 = Segment(p1: D.position, p2: D.position + CGPoint(r: 1, a: BC_segment.zRotation))
        if let intersection = s1.intersection(s2) {
            E.position = intersection
            BE_segment.position = intersection
            BE_segment.zRotation = intersection.angleTo(B.position)
            BE_segment.textureId(.ColorLine(length: intersection.distanceTo(B.position), color: 0x00FFFF))
            CE_segment.position = intersection
            CE_segment.zRotation = intersection.angleTo(C.position)
            CE_segment.textureId(.ColorLine(length: intersection.distanceTo(C.position), color: 0x00FFFF))

            let a = A.angleTo(B) - A_bisect.zRotation
            let Θ1 = TAU_4 - a
            do {
                let ss1 = Segment(p1: A.position, p2: B.position)
                let ss2 = Segment(p1: intersection, p2: intersection + CGPoint(r: 1, a: A_bisect.zRotation + TAU_2 - Θ1))
                if let intersection90 = ss1.intersection(ss2) {
                    Bp.position = intersection90
                    BBp_segment.position = intersection90
                    BBp_segment.zRotation = intersection90.angleTo(B.position)
                    BBp_segment.textureId(.ColorLine(length: intersection90.distanceTo(B.position), color: 0xFECC10))
                    EBp_segment.position = intersection90
                    EBp_segment.zRotation = intersection90.angleTo(E.position)
                    EBp_segment.textureId(.ColorLine(length: intersection90.distanceTo(E.position), color: 0xFECC10))
                }
            }
            do {
                let ss1 = Segment(p1: A.position, p2: C.position)
                let ss2 = Segment(p1: intersection, p2: intersection + CGPoint(r: 1, a: A_bisect.zRotation - TAU_2 + Θ1))
                if let intersection90 = ss1.intersection(ss2) {
                    Cp.position = intersection90
                    CCp_segment.position = intersection90
                    CCp_segment.zRotation = intersection90.angleTo(C.position)
                    CCp_segment.textureId(.ColorLine(length: intersection90.distanceTo(C.position), color: 0xFECC10))
                    ECp_segment.position = intersection90
                    ECp_segment.zRotation = intersection90.angleTo(E.position)
                    ECp_segment.textureId(.ColorLine(length: intersection90.distanceTo(E.position), color: 0xFECC10))
                }
            }
        }

        print("===============================")
        print("Angle Bp: \((Bp.angleTo(E) - Bp.angleTo(A)) / TAU)")
        print("Angle Cp: \((Cp.angleTo(E) - Cp.angleTo(A)) / TAU)")
        update = false
    }

}
