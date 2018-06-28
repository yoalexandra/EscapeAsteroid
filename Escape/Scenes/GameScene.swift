//
//  GameScene.swift
//  Escape
//
//  Created by Администратор on 16.11.2017.
//  Copyright © 2017 alejandra. All rights reserved.
//
import GoogleMobileAds
import SpriteKit
import GameKit

class GameScene: SKScene, SKPhysicsContactDelegate, GKGameCenterControllerDelegate {
    
    // MARK: Properties
    var stars: SKEmitterNode!
    var player: SKSpriteNode!
    
    var scoreLabel: SKLabelNode!
    var bestScoreLabel: SKLabelNode!
    var leaderBoardLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var bestScore = UserDefaults().integer(forKey: "HIGHSCORE")
    
    var enemies = ["obstacle", "obstacle1", "obstacle2"]
    var timer: Timer!
    var isGameOver = false
    
    var playButton = SKSpriteNode()
    var goToMenu = SKSpriteNode()
    var leaderBoardNode = SKSpriteNode()
    var backgroundMusic = SKAudioNode()
    var bigBangSound = SKAction.playSoundFileNamed("big-bang.mp3", waitForCompletion: false)
  
    override func didMove(to view: SKView) {
        setupScene()
        addStarsEmitterNode()
        addPlayer()
        addScoreLabels()
        addLeaderboardButton()
        addBackgroundMusic()
        scheduleTimer()
    }
    
    func scheduleTimer() {
         timer = Timer.scheduledTimer(timeInterval: 0.30,
                                      target: self,
                                      selector: #selector(createEnemy),
                                      userInfo: nil,
                                      repeats: true)
    }
    
    @objc func createEnemy() {
        enemies = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: enemies) as! [String]
        let randomDistribution = GKRandomDistribution(lowestValue: 50, highestValue: 375) // 736
        
        let sprite = SKSpriteNode(imageNamed: enemies[0])
        sprite.position = CGPoint(x: 1200, y: randomDistribution.nextInt())
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody?.angularVelocity = 5
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
    }
    
    func  addPlayer() {
        player = SKSpriteNode(imageNamed: "ufo2")
        player.size = CGSize(width: 90, height: 40)
        player.position = CGPoint(x: 100, y: 175)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
    }
    
    func addScoreLabels() {
        // Score label
        scoreLabel = SKLabelNode(fontNamed: "AvenirNext-HeavyItalic")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.fontColor = .brown
        scoreLabel.fontSize = 18
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        score = 0
        
        // Best score label
        bestScoreLabel = SKLabelNode(fontNamed: "AvenirNext-HeavyItalic")
        bestScoreLabel.position = CGPoint(x: self.frame.width - 65, y: 16)
        bestScoreLabel.fontColor = .red
        bestScoreLabel.fontSize = 18
        bestScoreLabel.horizontalAlignmentMode = .right
        bestScoreLabel.text = "Best: \(bestScore)"
        addChild(bestScoreLabel)
    }
    
    func addLeaderboardButton() {
     
        leaderBoardNode = SKSpriteNode(color: .green, size: CGSize(width: 120, height: 20))
        leaderBoardNode.position = CGPoint(x: self.frame.width / 2, y: 26)
        leaderBoardNode.alpha = 0.4
        leaderBoardNode.name = "leaderboard"
        addChild(leaderBoardNode)
        
        leaderBoardLabel = SKLabelNode(fontNamed: "AvenirNext-HeavyItalic")
        leaderBoardLabel.position = CGPoint(x: self.frame.width / 2, y: 20)
        leaderBoardLabel.zPosition = -1
        leaderBoardLabel.fontColor = .white
        leaderBoardLabel.fontSize = 14
        leaderBoardLabel.text = "Leaderboard"
        addChild(leaderBoardLabel)
    }

    func addBackgroundMusic() {
        backgroundMusic = SKAudioNode(fileNamed: "bg5.mp3")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }

    func showMenuButtons() {
        playButton = SKSpriteNode(imageNamed: "button")
        playButton.size = CGSize(width: 150, height: 47)
        playButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 30)
        playButton.name = "restartGame"
        playButton.zPosition = 5
        addChild(playButton)
        
        goToMenu = SKSpriteNode(imageNamed: "buttonM")
        goToMenu.size = CGSize(width: 150, height: 47)
        goToMenu.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 30)
        goToMenu.name = "returnToMenu"
        goToMenu.zPosition = 5
        addChild(goToMenu)
        
        // Animate buttons nodes
        let pulseAction = SKAction.sequence([SKAction.fadeAlpha(to: 0.5, duration: 0.9), SKAction.fadeAlpha(to: 1, duration: 0.9)])
        playButton.run(SKAction.repeatForever(pulseAction))
        goToMenu.run(SKAction.repeatForever(pulseAction))
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        if !isGameOver {
            score += 1
        }
        if score > UserDefaults().integer(forKey: "HIGHSCORE") {
            savingBestScore()
        }
    }
    
    // Save high score
    func savingBestScore() {
        UserDefaults.standard.set(score, forKey: "HIGHSCORE")
        bestScoreLabel.text = "Best: \(UserDefaults().integer(forKey: "HIGHSCORE"))"
    }
    
    func postNotificationToShowAds() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gameStateOff"), object: nil)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        player.removeFromParent()
        isGameOver = true
        backgroundMusic.removeFromParent()
        run(bigBangSound)
        showMenuButtons()
        postNotificationToShowAds()
    
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        if location.y < 100 {
            location.y = 100
        } else if location.y > 750 {
            location.y = 750
        }
        player.position = location
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedSprite = atPoint(location)
            if touchedSprite.name == "restartGame" {
                goToScene(scene: GameScene(size: self.size))
            } else if touchedSprite.name == "returnToMenu" {
                goToScene(scene: MenuScene(size: self.size))
                backgroundMusic.removeFromParent()
            } else if touchedSprite.name == "leaderboard" {
                submitHighScoreGC(score: score)
                showLeaderBoard()
            }
        }
    }
    
    func addStarsEmitterNode() {
        stars = SKEmitterNode(fileNamed: "Stars")!
        stars.position = CGPoint(x: 800, y: 375)
        stars.advanceSimulationTime(10)
        addChild(stars)
        stars.zPosition = -1
    }
    
    func setupScene() {
        self.scaleMode = .aspectFill
        backgroundColor = UIColor.black
        // PhysicsWorld delegate
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
    }
    // Scene transition
    func goToScene(scene: SKScene) {
        let sceneTransition = SKTransition.fade(with: UIColor.white, duration: 0.5)
        self.view?.presentScene(scene, transition: sceneTransition)
    }
    // MARK: - Game Center saving high score
    // Submit highScore to Game Center
    func submitHighScoreGC(score: Int) {
        if GKLocalPlayer.localPlayer().isAuthenticated {
            let reporter = GKScore(leaderboardIdentifier: "best_score1")
            reporter.value = Int64(score)
            let scoreArr: [GKScore] = [reporter]
            GKScore.report(scoreArr, withCompletionHandler: nil)
        }
    }
    // Show leaderboard
    func showLeaderBoard(){
        let viewController = self.view?.window?.rootViewController
        let gcvc = GKGameCenterViewController()
        gcvc.gameCenterDelegate = self
        viewController?.present(gcvc, animated: true, completion: nil)
        
    }
    // Delegate to dismiss the Game Center controller
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
}  // end GameScene




