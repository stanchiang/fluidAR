//
//  GameScene.swift
//  Space Race
//
//  Created by Jason Eng on 9/13/15.
//  Copyright (c) 2015 EngJason. All rights reserved.
//

import SpriteKit

protocol GameVarDelegate: class {
    func getAdjustedPPI() -> CGFloat
}

class GameScene: SKScene {
    
    weak var gameVarDelegate:GameVarDelegate?
    
    var distance: Float!
    var mouthColor: UIColor!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func update(_ currentTime: TimeInterval) {
        let mouth = appDelegate.mouth
        
//        if we have data to work with
        if !mouth.isEmpty && mouth.first!.x != 0 && mouth.first!.y != 0 {
//        create player position and draw shape based on mouth array
            
            if checkMouth(mouth, dist: 10) {
                mouthColor = UIColor.green
            } else {
                mouthColor = UIColor.red
            }
            
            if let mouthSprite = childNode(withName: Sprite.mouth.rawValue) { mouthSprite.removeFromParent() }
            
            if let mouthShape = childNode(withName: "mouthShape") { mouthShape.removeFromParent() }
            
            addMouth(mouth, color: mouthColor)
        }
    }
    
    func checkMouth(_ mouth:[CGPoint], dist:Float) -> Bool{
        if !mouth.isEmpty && mouth.first!.x != 0 && mouth.first!.y != 0 {
            let p1 = mouth[2]
            let p2 = mouth[6]
            distance = hypotf(Float(p1.x) - Float(p2.x), Float(p1.y) - Float(p2.y));
            
            if distance > dist { return true }
        }
        return false
    }
    
    func addMouth(_ mouth:[CGPoint], color: UIColor) {
        var anchorPoint:CGPoint!
        let pathToDraw:CGMutablePath = CGMutablePath()
        let center = mouth[2].midpoint(with: mouth[6])
        
        for m in mouth {
            let mm = self.view!.convert(m, to: self)
            if m == mouth.first! {
                anchorPoint = mm
                pathToDraw.move(to: mm)
            } else {
                pathToDraw.addLine(to: mm)
            }
        }
        pathToDraw.addLine(to: anchorPoint)
        
        let mouthShape = SKShapeNode(path: pathToDraw)
        mouthShape.isAntialiased = true
        mouthShape.strokeColor = color
        mouthShape.name = "mouthshape"

        let texture = view!.texture(from: mouthShape)
        let mouthSprite = SKSpriteNode(texture: texture, size: mouthShape.calculateAccumulatedFrame().size)
        mouthSprite.physicsBody = SKPhysicsBody(texture: mouthSprite.texture!, size: mouthSprite.calculateAccumulatedFrame().size)
        
        mouthSprite.name = Sprite.mouth.rawValue
        mouthSprite.position = self.view!.convert(center, to: self)
        mouthSprite.physicsBody?.affectedByGravity = false
        self.addChild(mouthSprite)

    }
}

