//
//  PredictionDetailsViewController.swift
//  RedDragon
//
//  Created by Ali on 11/21/23.
//

import UIKit
import SDWebImage

class PredictionDetailsViewController: UIViewController {

    @IBOutlet weak var placePredictionDescriptionView: PlacePredictionDescriptionView!
    @IBOutlet weak var predictionPlaceView: PlacePredictionView!
    @IBOutlet weak var predictionDetailTopView: PredictionDetailTopView!
    
    var selectedMatch: PredictionData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureTopView()
        setupProgressView()
        configurePlacePredictionView()
    }
    
    func configureTopView(){
        predictionDetailTopView.leagueNameLbl.text = selectedMatch?.league
        predictionDetailTopView.leagueImgView.sd_imageIndicator = SDWebImageActivityIndicator.white
        predictionDetailTopView.leagueImgView.sd_setImage(with: URL(string: selectedMatch?.logo ?? ""))
        predictionDetailTopView.team1Lbl.text = selectedMatch?.matches?[0].homeTeam
        predictionDetailTopView.team2Lbl.text = selectedMatch?.matches?[0].awayTeam
        predictionDetailTopView.dateLbl.text = Date().formatDate(outputFormat: dateFormat(rawValue: "yyyy-MM-dd")!) + " | " + (selectedMatch?.matches?[0].time)!
        
    }
    
    func configurePlacePredictionView(){
        
        predictionPlaceView.homeBtn.titleLabel?.text = "Home"
        predictionPlaceView.drawBtn.titleLabel?.text = "Draw"
        predictionPlaceView.awayBtn.titleLabel?.text = "Away"
        predictionPlaceView.homeBtn.addTarget(self, action: #selector(homeBtnAction), for: .touchUpInside)
        predictionPlaceView.drawBtn.addTarget(self, action: #selector(drawBtnAction), for: .touchUpInside)
        predictionPlaceView.awayBtn.addTarget(self, action: #selector(awayBtnAction), for: .touchUpInside)
    }
    
    @objc func homeBtnAction(){
        predictionPlaceView.homeBtn.borderWidth = 2
        predictionPlaceView.homeBtn.borderColor = UIColor.init(hex: "00658C")
        
        predictionPlaceView.drawBtn.borderWidth = 0
        predictionPlaceView.awayBtn.borderWidth = 0
    }
    @objc func drawBtnAction(){
        predictionPlaceView.drawBtn.borderWidth = 2
        predictionPlaceView.drawBtn.borderColor = UIColor.init(hex: "745B00")
        
        predictionPlaceView.homeBtn.borderWidth = 0
        predictionPlaceView.awayBtn.borderWidth = 0
        
    }
    @objc func awayBtnAction(){
        predictionPlaceView.awayBtn.borderWidth = 2
        predictionPlaceView.awayBtn.borderColor = UIColor.init(hex: "BB1910")
        
        predictionPlaceView.drawBtn.borderWidth = 0
        predictionPlaceView.homeBtn.borderWidth = 0
        
    }
    
    func setupProgressView(){
       // let stackView = UIStackView()
     //   predictionDetailTopView.progressStackView = stackView
        predictionDetailTopView.progressStackView.axis = .horizontal
        predictionDetailTopView.progressStackView.distribution = .fillProportionally
        predictionDetailTopView.progressStackView.spacing = 8 // Adjust spacing as needed
        predictionDetailTopView.progressStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Create three subviews
        let view1 = UIView()
        view1.backgroundColor = UIColor.init(hex: "00658C")
        view1.translatesAutoresizingMaskIntoConstraints = false
              
        let view2 = UIView()
        view2.backgroundColor = UIColor.init(hex: "745B00")
        view2.translatesAutoresizingMaskIntoConstraints = false
              
        let view3 = UIView()
        view3.backgroundColor = UIColor.init(hex: "BB1910")
        view3.translatesAutoresizingMaskIntoConstraints = false
              
        // Add subviews to stackView
        predictionDetailTopView.progressStackView.addArrangedSubview(view1)
        predictionDetailTopView.progressStackView.addArrangedSubview(view2)
        predictionDetailTopView.progressStackView.addArrangedSubview(view3)
              
        // Add stackView to the main view
        predictionDetailTopView.viewForStackView.addSubview(predictionDetailTopView.progressStackView)
        // Set up Auto Layout constraints for stackView
        
        NSLayoutConstraint.activate([
            predictionDetailTopView.progressStackView.topAnchor.constraint(equalTo: predictionDetailTopView.viewForStackView.topAnchor),
            predictionDetailTopView.progressStackView.leadingAnchor.constraint(equalTo: predictionDetailTopView.viewForStackView.leadingAnchor),
            predictionDetailTopView.progressStackView.trailingAnchor.constraint(equalTo: predictionDetailTopView.viewForStackView.trailingAnchor),
        ])
    }
    

}
