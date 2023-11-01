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
        
        UIImageView().kf.setImage(with: URL(string: imageUrl)) { result in
            switch result {
            case .success(let value):
                self.imageScrollView.display(image: value.image)
            case .failure(let error):
                print("Error Image: \(error)")
            }
        }
    }

}
