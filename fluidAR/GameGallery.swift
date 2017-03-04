//
//  GameGallery.swift
//  GameFace
//
//  Created by Stanley Chiang on 10/14/16.
//  Copyright © 2016 Stanley Chiang. All rights reserved.
//

import UIKit
import SpriteKit

class GameGallery: UIViewController {
    let cameraHandler = CameraHandler()
    var cameraImage:UIImageView!
    
    var gameView:UIView!
    
    var scene:GameScene!
    
    var debugView:DebugView!
    let debugMode = false
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        cameraHandler.openSession()
        setupCameraImage()
        
        debugView = DebugView(frame: self.view.frame)
        
        self.view.addSubview(setupGameLayer())
    }

    func setupCameraImage(){
        cameraImage = UIImageView()
        cameraImage.frame = self.view.frame        
        cameraImage.transform = self.cameraImage.transform.scaledBy(x: -1, y: 1)
        self.view.addSubview(cameraImage)
    }
    
    //MARK: SpriteKit methods
    func setupGameLayer() -> UIView {
        gameView = UIView(frame: self.view.frame)
        gameView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
        gameView.transform = gameView.transform.scaledBy(x: 1, y: -1)

        let skView = SKView(frame: view.frame)
        skView.allowsTransparency = true
        
        gameView.addSubview(skView as UIView)
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        scene = GameScene(size: self.view.frame.size)
        scene.scaleMode = .aspectFill
        scene.backgroundColor = UIColor.clear
        skView.presentScene(scene)
        
        return gameView
    }
    
}
