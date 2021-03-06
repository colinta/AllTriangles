//
//  WorldView.swift
//  AllTriangles
//
//  Created by Colin Gray on 12/21/15.
//  Copyright © 2015 colinta. All rights reserved.
//

class WorldView: SKView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: 0x3f3f3f)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            (scene as? WorldScene)?.gameShook()
        }
    }

    func presentWorld(world: World) {
        let scene = WorldScene(size: frame.size, world: world)
        presentScene(scene)
    }
}
