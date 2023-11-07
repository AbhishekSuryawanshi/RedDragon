//
//  ImageZoomVC.swift
//  RedDragon
//
//  Created by Qasr01 on 31/10/2023.
//

import UIKit
import Kingfisher

class ImageZoomVC: UIViewController {

    @IBOutlet weak var imageScrollView: ImageScrollView!
    
    var imageUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ///Get image from url and show in scroll view
        UIImageView().kf.setImage(with: URL(string: imageUrl)) { result in
            switch result {
            case .success(let value):
                self.imageScrollView.display(image: value.image)
            case .failure(let error):
                print("Error Image: \(error)")
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        ///Hide tabbar
        self.tabBarController?.tabBar.isHidden = true
    }
}
