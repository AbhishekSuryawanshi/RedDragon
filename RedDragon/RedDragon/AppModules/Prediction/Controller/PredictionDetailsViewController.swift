//
//  PredictionDetailsViewController.swift
//  RedDragon
//
//  Created by Ali on 11/21/23.
//

import UIKit

class PredictionDetailsViewController: UIViewController {

    @IBOutlet weak var placePredictionDescriptionView: PlacePredictionDescription!
    @IBOutlet weak var predictionPlaceView: PlacePredictionView!
    @IBOutlet weak var predictionDetailTopView: PredictionDetailTopView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setupProgressView(){
        let stackView = UIStackView()
              stackView.axis = .horizontal
              stackView.distribution = .fillProportionally
              stackView.spacing = 8 // Adjust spacing as needed
              stackView.translatesAutoresizingMaskIntoConstraints = false
              
              // Create three subviews
              let view1 = UIView()
              view1.backgroundColor = UIColor.red
              view1.translatesAutoresizingMaskIntoConstraints = false
              
              let view2 = UIView()
              view2.backgroundColor = UIColor.green
              view2.translatesAutoresizingMaskIntoConstraints = false
              
              let view3 = UIView()
              view3.backgroundColor = UIColor.blue
              view3.translatesAutoresizingMaskIntoConstraints = false
              
              // Add subviews to stackView
              stackView.addArrangedSubview(view1)
              stackView.addArrangedSubview(view2)
              stackView.addArrangedSubview(view3)
              
              // Add stackView to the main view
              view.addSubview(stackView)
              
              // Set up Auto Layout constraints for stackView
              NSLayoutConstraint.activate([
                  stackView.topAnchor.constraint(equalTo: view.topAnchor),
                  stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                  stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                  ])
    }
    

}
