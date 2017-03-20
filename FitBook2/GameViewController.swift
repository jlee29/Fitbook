//
//  GameViewController.swift
//  TestGame
//
//  Created by Jiwoo Lee on 3/17/17.
//  Copyright © 2017 jlee29. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController, GameSceneDelegate {
    
    var audioPlayer: AVAudioPlayer?
    
    func shareScore(_ score: Int) {
        let activityViewController = UIActivityViewController(activityItems: ["You scored \(score)! Wavey." as NSString], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    func gameEnded() {
        do {
            let gameOverMusic = Bundle.main.url(forResource: "gameover", withExtension: "mp3")!
            audioPlayer = try AVAudioPlayer(contentsOf: gameOverMusic)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print(error)
        }
    }
    
    func gameStarted() {
        do {
            let gameOverMusic = Bundle.main.url(forResource: "waves", withExtension: "mp3")!
            audioPlayer = try AVAudioPlayer(contentsOf: gameOverMusic)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print(error)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let skView = self.view as? SKView
        if let scene = skView?.scene {
            if scene.size != self.view.bounds.size {
                scene.size = self.view.bounds.size
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer()
        
        self.tabBarController?.tabBar.isHidden = true
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                let gameScene = scene as! GameScene
                gameScene.gameDelegate = self
                // Present the scene
                view.presentScene(gameScene)
            }
//            let fadeTransition = SKTransition.fade(withDuration: 0.2)
//            let kanyeGame = GameScene()
//            view.presentScene(kanyeGame, transition: fadeTransition)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        audioPlayer = nil
        self.tabBarController?.tabBar.isHidden = false
        super.viewWillDisappear(animated)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
