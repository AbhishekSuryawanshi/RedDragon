//
//  GossipDetailVC.swift
//  RedDragon
//
//  Created by Qasr01 on 12/12/2023.
//

import UIKit

class GossipDetailVC: UIViewController {

    @IBOutlet weak var titlteLabel: UILabel!
    @IBOutlet weak var gossipImageView: UIImageView!
    @IBOutlet weak var contentLabel: ExpandableLabel!
    
    var commentSectionID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Button Action

    @IBAction func shareButtonTapped(_ sender: UIButton) {
   
    }
    
    @IBAction func commentButtonTapped(_ sender: UIButton) {
        navigateToViewController(NewsCommentsVC.self, storyboardName: StoryboardName.gossip, animationType: .autoReverse(presenting: .zoom)) { vc in
            vc.sectionId = self.commentSectionID
            vc.newsTitle = "Title"
        }
    }
}
