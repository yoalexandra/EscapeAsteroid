//
//  Tutorial.swift
//  Escape
//
//  Created by Администратор on 23.11.2017.
//  Copyright © 2017 alejandra. All rights reserved.
//

import SpriteKit

class TutorialScene: SKScene { 
    
    var goToMenu = SKSpriteNode()
    var goToPlay = SKSpriteNode()

    override func didMove(to view: SKView) {
        setupScene()
        addButtons()
        addLabels()
    }
    
    func addLabels() {
        let welcomeText = SKLabelNode(fontNamed: "AvenirNext-HeavyItalic")
        welcomeText.text = "★ Welcome to the Tutorial ★"
        welcomeText.fontSize = 30
        welcomeText.position = CGPoint(x: 0, y: 70)
        addChild(welcomeText)
        
        let aboutGameTextLabel = SKLabelNode(fontNamed: "AvenirNext-MediumItalic")
        aboutGameTextLabel.position = CGPoint(x: 0, y: -120)
        aboutGameTextLabel.numberOfLines = 8
        aboutGameTextLabel.text = """
            This is the awesome game of Escape where you can get
        as many points as you can by flying and dodging obstacles
        without crashing.
        How To Play:
            Simply touch the screen and move your finger
        around the obstacles to dodge them.
        Tap anywhere on the screen to teleport to that location.
                                                                        LET'S GO SPACE"
        """
        aboutGameTextLabel.fontSize = 15
        addChild(aboutGameTextLabel)
    }
    
    func addButtons() {
        let buttonSize = CGSize(width: 70, height: 40)
        goToMenu = SKSpriteNode(imageNamed: "buttonMenu")
        goToMenu.size = buttonSize
        goToMenu.position = CGPoint(x: -self.frame.width / 2 + 60, y: self.frame.height / 2 - 35)
        goToMenu.name = "menu"
        addChild(goToMenu)
        
        goToPlay = SKSpriteNode(imageNamed: "buttonPlay")
        goToPlay.size = buttonSize
        goToPlay.position = CGPoint(x: -self.frame.width / 2 + 160, y: self.frame.height / 2 - 35)
        goToPlay.name = "play"
        addChild(goToPlay)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedSprite = atPoint(location)
             if touchedSprite.name == "menu" {
                goToScene(scene: MenuScene(size: self.size))
             } else if touchedSprite.name == "play" {
                goToScene(scene: GameScene(size: self.size))
            }
        }
     }
    
    func setupScene() {
        self.scaleMode = .aspectFill
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = .black
    }
    // Scene transition
    func goToScene(scene: SKScene) {
        let sceneTransition = SKTransition.fade(with: UIColor.white, duration: 0.5)
        self.view?.presentScene(scene, transition: sceneTransition)
    }
}


