//
//  PlayerDetailYoutubeViewController.swift
//  RedDragon
//
//  Created by Ali on 11/20/23.
//

import UIKit
import YouTubeiOSPlayerHelper


class PlayerDetailYoutubeViewController: UIViewController {
    
    var videoURL = ""

    @IBOutlet weak var playerView: YTPlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let index = (videoURL.range(of: "=")?.upperBound)
        {
            let afterEqualsTo = String(videoURL.suffix(from: index))
            loadVideo(videoId: afterEqualsTo)
        }
        
      
    }
    
    private func loadVideo(videoId: String) {
        // Set playsinline = 1 to enable the video play inside the UIViewController
        let playerVars: [String: Any] = ["playsinline": 1]
        playerView.load(withVideoId: videoId, playerVars: playerVars)
       
    }
    
   
    @IBAction func closeBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
