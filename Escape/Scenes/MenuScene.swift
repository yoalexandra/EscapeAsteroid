//
//  Menu.swift
//  Escape
//
//  Created by Администратор on 23.11.2017.
//  Copyright © 2017 alejandra. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    var playButton = SKSpriteNode()
    var goToTutorial = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        setupScene()
        addButtons()
        addLogoLabel()
    }
    func addLogoLabel() {
        let logo = SKLabelNode(fontNamed: "AvenirNext-HeavyItalic")
        logo.text = "Escape"
        logo.position = CGPoint(x: 0, y: 90)
        logo.fontSize = 60
        self.addChild(logo)
    }
    func addButtons() {
        let buttonSize = CGSize(width: 250, height: 70)
        
        playButton = SKSpriteNode(imageNamed: "button")
        playButton.size = buttonSize
        playButton.name = "play"
        playButton.position = CGPoint(x: 0 , y: 25)
        addChild(playButton)
        
        goToTutorial = SKSpriteNode(imageNamed: "buttonT")
        goToTutorial.size = buttonSize
        goToTutorial.position = CGPoint(x: 0, y: -55)
        goToTutorial.name = "tutorial"
        addChild(goToTutorial)
        
        // Animate buttons
        let pulseAction = SKAction.sequence([SKAction.fadeAlpha(to: 0.5, duration: 0.9), SKAction.fadeAlpha(to: 1, duration: 0.9)])
        playButton.run(SKAction.repeatForever(pulseAction))
        goToTutorial.run(SKAction.repeatForever(pulseAction))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedSprite = atPoint(location)
            if touchedSprite.name == "play" {
                self.view?.presentScene(GameScene(size: self.size))
            } else if touchedSprite.name == "tutorial" {
                goToScene(scene: TutorialScene(size: self.size))
            }
        }
    }
    
    func setupScene() {
        self.scaleMode = .aspectFill
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let backgroundImg = SKSpriteNode(imageNamed: "bg-menu")
        // backgroundImg.size = CGSize(width: 1334, height: 750)
        backgroundImg.zPosition = -1
        addChild(backgroundImg)
    }
    
    // Scene transition
    func goToScene(scene: SKScene) {
        let sceneTransition = SKTransition.fade(with: UIColor.white, duration: 0.5)
        self.view?.presentScene(scene, transition: sceneTransition)
    }
}















