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
        setTitle()
        UIApplication.shared.statusBarStyle = .lightContent
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buttonImage.transparentButton(text: "Find Your Pizza Slice!", fontSize: 12, borderWidth: 8, xInset: 5, yInset: 5, alpha: self.splashScreenAlpha, color: .white)
    }
    
    var videoPlayer: AVPlayer?
    var videoPlayerContainer: AVPlayerLayer?
    
    let loopFadeSpeed = 0.25
    
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
        videoPlayer?.pause()
        fadeToBlack(notification: notification)
    }
    
    func fadeToBlack(notification: NSNotification) {
        let blackScreen = UIView(frame: self.view.bounds)
        blackScreen.backgroundColor = .white
        blackScreen.alpha = 0
        self.view.addSubview(blackScreen)
        
        UIView.animate(withDuration: self.loopFadeSpeed, animations: {
            
            blackScreen.alpha = 1
            
        }, completion: { _ in
            
            let p: AVPlayerItem = notification.object as! AVPlayerItem
            p.seek(to: kCMTimeZero)
            
            UIView.animate(withDuration: self.loopFadeSpeed, animations: {
                blackScreen.alpha = 0
                self.videoPlayer?.play()
            }, completion: { _ in
                blackScreen.removeFromSuperview()
            })
        })
    }
    
    let splashScreenAlpha: CGFloat = 0.7
    
    var appTitle: UILabel?
    
    var appSubtitle: UILabel?
    
    lazy var enterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(enterHomescreen), for: .touchUpInside)
        return button
    }()
    
    let buttonImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    func splashScreenButton() {
        
        view.addSubview(buttonImage)
        
        buttonImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        buttonImage.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -50).isActive = true
        buttonImage.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.15).isActive = true
        buttonImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
        
        view.addSubview(enterButton)
        enterButton.widthAnchor.constraint(equalTo: buttonImage.widthAnchor, multiplier: 1).isActive = true
        enterButton.heightAnchor.constraint(equalTo: buttonImage.heightAnchor, multiplier: 1).isActive = true
        enterButton.centerXAnchor.constraint(equalTo: buttonImage.centerXAnchor).isActive = true
        enterButton.centerYAnchor.constraint(equalTo: buttonImage.centerYAnchor).isActive = true
    }
    
    func splashText(text: String, fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = fontReno?.withSize(fontSize)
        label.textColor = .white
        label.alpha = self.splashScreenAlpha
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func setTitle() {
        appTitle = splashText(text: "PIZZA RAT", fontSize: 40)
        view.addSubview(appTitle!)
        appTitle?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        appTitle?.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85).isActive = true
        appTitle?.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true
        appTitle?.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -150).isActive = true
        
        appSubtitle = splashText(text: "A New York City Exclusive", fontSize: 12)
        view.addSubview(appSubtitle!)
        appSubtitle?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        appSubtitle?.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85).isActive = true
        appSubtitle?.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.025).isActive = true
        appSubtitle?.topAnchor.constraint(equalTo: (appTitle?.bottomAnchor)!, constant: 0).isActive = true
    }
    
    func enterHomescreen() {
        
        self.videoPlayer?.pause()

        self.dismiss(animated: true, completion: nil)
        
//        present(HomescreenVC(), animated: true) {
//            self.videoPlayer?.pause()
//            self.dismiss(animated: false, completion: nil)
//        }
    }
    

    
    deinit {
        print("deinit")
        NotificationCenter.default.removeObserver(self)
    }
}
