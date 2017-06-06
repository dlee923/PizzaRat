//
//  SplashScreenVC.swift
//  Pizza Finder
//
//  Created by Daniel Lee on 6/6/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit
import AVFoundation

class SplashScreenVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
        setUpVideoPlayer()
        splashScreenButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let videoPlayerExists = videoPlayer {
            videoPlayerExists.play()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let videoPlayerExists = videoPlayer {
            videoPlayerExists.pause()
        }
    }
    
    var videoPlayer: AVPlayer?
    var videoPlayerContainer: AVPlayerLayer?
    
    func setUpVideoPlayer() {
        guard let url = Bundle.main.url(forResource: "pizzaRat", withExtension: "mp4") else { return }
        
        videoPlayer = AVPlayer(url: url)
        videoPlayer?.actionAtItemEnd = AVPlayerActionAtItemEnd.none
        videoPlayer?.volume = 0
        
        videoPlayerContainer = AVPlayerLayer(player: videoPlayer)
        videoPlayerContainer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPlayerContainer?.frame = self.view.layer.bounds
        view.backgroundColor = .black
        self.view.layer.insertSublayer(videoPlayerContainer!, at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoPlayer?.currentItem)
    }
    
    func playerItemDidReachEnd(notification: NSNotification) {
        print("video done playing")
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: kCMTimeZero)
        videoPlayer?.pause()
        fadeToBlack()
    }
    
    func fadeToBlack() {
        let blackScreen = UIView(frame: self.view.bounds)
        blackScreen.backgroundColor = .black
        blackScreen.alpha = 0
        self.view.addSubview(blackScreen)
        
        UIView.animate(withDuration: 0.5, animations: {
            blackScreen.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, animations: { 
                blackScreen.alpha = 0
                self.videoPlayer?.play()
            }, completion: { _ in
                blackScreen.removeFromSuperview()
            })
        })
    }
    
    lazy var enterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Unleash Your Inner Rat!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .purple
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(enterHomescreen), for: .touchUpInside)
        return button
    }()
    
    func splashScreenButton() {
        view.addSubview(enterButton)
        enterButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        enterButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        enterButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true
        enterButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
    }
    
    func enterHomescreen() {        
        present(HomescreenVC(), animated: true) {
            self.videoPlayer?.pause()
        }
    }
}
