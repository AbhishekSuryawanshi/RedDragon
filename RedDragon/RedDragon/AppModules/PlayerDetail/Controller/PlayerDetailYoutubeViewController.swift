//
//  PlayerDetailYoutubeViewController.swift
//  RedDragon
//
//  Created by Ali on 11/20/23.
//

import UIKit
import YouTubePlayerKit


class PlayerDetailYoutubeViewController: UIViewController {
    
    var videoURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let video = videoURL
        let configuration = YouTubePlayer.Configuration(
            // Define which fullscreen mode should be used (system or web)
            fullscreenMode: .system,
            // Custom action to perform when a URL gets opened
           
            // Enable auto play
            autoPlay: true,
            // Hide controls
            showControls: true,
            // Enable loop
            loopEnabled: true
        )
        let youTubePlayer = YouTubePlayer(
            source: .url(video),
            configuration: configuration
        )
        
        let youTubePlayerViewController = YouTubePlayerViewController(
            player: youTubePlayer
        )
        self.present(youTubePlayerViewController, animated: true)

        
    }
    
   
    
}
