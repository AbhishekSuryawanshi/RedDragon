//
//  CreateStreetTeamVC.swift
//  RedDragon
//
//  Created by Remya on 12/8/23.
//

import UIKit
import IQKeyboardManagerSwift

class CreateStreetTeamVC: UIViewController {

//    @IBOutlet weak var btnCreate: UIButton!
//    @IBOutlet weak var imgProfile: UIImageView!
//    @IBOutlet weak var txtTeamName: UITextField!
//    @IBOutlet weak var textViewAbout: IQTextView!
//    @IBOutlet weak var playersTableView: UITableView!
//    @IBOutlet weak var lblLocation: UILabel!
//    @IBOutlet weak var playersTableHeight: NSLayoutConstraint!
//    @IBOutlet weak var txtChineseTeamName: UITextField!
//    @IBOutlet weak var textViewChineseAbout: IQTextView!
//    @IBOutlet weak var lblTitle: UILabel!
//    @IBOutlet weak var buttonTop: NSLayoutConstraint!
//    @IBOutlet weak var infoStack: UIStackView!
//    @IBOutlet weak var playersStack: UIStackView!
//    @IBOutlet weak var collectionView:UICollectionView!
//    @IBOutlet weak var fixedUploadLogo: UILabel!
//    @IBOutlet weak var fixedTeamNameEn: UILabel!
//    @IBOutlet weak var fixedTeamNameCn: UILabel!
//    @IBOutlet weak var fixedLocation: UILabel!
//    @IBOutlet weak var fixedAboutTeamCn: UILabel!
//    @IBOutlet weak var fixedAboutTeamEn: UILabel!
//    
//    @IBOutlet weak var btnAddPlayers: UIButton!
//    //Variables
//    var tableViewPlayersObserver: NSKeyValueObservation?
//    var lat = ""
//    var long = ""
//    var address = ""
//    var profileImage:UIImage?
//    var selectedPlayers:[PlayerList]?
//    var viewModel = CreateTeamViewModel()
//    var headers = ["Info".localized,"Players".localized]
//    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  initialSettings()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.isHidden = true
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.navigationBar.isHidden = false
//    }
//    
//    @IBAction func actionBack(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//        
//    }
//   
//    @IBAction func actionAddPlayers(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlayersViewController") as! PlayersViewController
//        vc.chosenPlayers = selectedPlayers
//        vc.passPlayers = { players in
//            self.selectedPlayers = players
//            self.playersTableView.reloadData()
//        }
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    
//    @IBAction func actionCreateTeam(_ sender: Any) {
//        validations()
//    }
//    
//    
//    @IBAction func actionTapLocation(_ sender: Any) {
//        chooseLocation()
//    }
//    
//    @IBAction func actionChooseLogo(_ sender: Any) {
//        ImagePickerManager().pickImage(self) { image in
//            self.imgProfile.image = image
//            self.profileImage = image
//            self.viewModel.uploadImage(image: image)
//        }
//    }
//    
//   
//    func initialSettings(){
//        setupLocalisation()
//        buttonTop.constant = ((UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0) + 20)
//        tableViewPlayersObserver = playersTableView.observe(\.contentSize, options: .new) { (_, change) in
//                    guard let height = change.newValue?.height else { return }
//                    self.playersTableHeight.constant = height
//                }
//        playersTableView.register(UINib(nibName: "SelectedPlayerTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
//        viewModel.delegate = self
//        collectionView.register(UINib(nibName: "TypeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "typeCollectionViewCell")
//        collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
//        self.handleDisplay(index: 0)
//        
//       
//    }
//    
//    func setupLocalisation(){
//        btnCreate.setTitle("Create Team".localized, for: .normal)
//        lblTitle.text = "Create Team".localized
//        textViewAbout.placeholder = "About Team English".localized
//        textViewChineseAbout.placeholder = "About Team Chinese".localized
//        fixedUploadLogo.text = "Upload Logo".localized
//        fixedTeamNameEn.text = "Team Name English".localized
//        txtTeamName.placeholder = "Team Name English".localized
//        fixedTeamNameCn.text = "Team Name Chinese".localized
//        txtChineseTeamName.placeholder = "Team Name Chinese".localized
//        fixedLocation.text = "Location".localized
//        lblLocation.text = "Choose Location".localized
//        fixedAboutTeamCn.text = "About Team Chinese".localized
//        fixedAboutTeamEn.text = "About Team English".localized
//        btnAddPlayers.setTitle(" +  \("Add Players".localized)", for: .normal)
//       
//    }
//    
//    func chooseLocation(){
//        let vc = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
//        vc.delg = self
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    func validations(){
//        if profileImage == nil{
//            Utility.showErrorSnackView(message: "Please choose team logo".localized)
//            return
//        }
//        
//        if txtTeamName.text == ""{
//            Utility.showErrorSnackView(message: "Please enter team name English".localized)
//            return
//        }
//        if txtChineseTeamName.text == ""{
//            Utility.showErrorSnackView(message: "Please enter team name Chinese".localized)
//            return
//        }
//       
//       
//        if lat == ""{
//            Utility.showErrorSnackView(message: "Please choose location".localized)
//            return
//        }
//        
//        if textViewAbout.text == ""{
//            Utility.showErrorSnackView(message: "Please enter about team English".localized)
//            return
//        }
//        
//        if textViewChineseAbout.text == ""{
//            Utility.showErrorSnackView(message: "Please enter about team Chinese".localized)
//            return
//        }
//        if selectedPlayers?.count ?? 0 == 0{
//            Utility.showErrorSnackView(message: "Please choose players".localized)
//            return
//        }
//        
//        let playerIDs:[Int] = selectedPlayers?.map{$0.id ?? 0} ?? []
//        let param:[String:Any] = ["name":txtTeamName.text!,
//                                  "name_cn":txtChineseTeamName.text!,
//                                  "location_lat":lat,
//                                  "location_long":long,
//                                  "address":address,
//                                  "description":textViewAbout.text ?? "",
//                                  "description_cn":textViewChineseAbout.text ?? "",
//                                  "logo_img_url":viewModel.uploadResponse?.path ?? "",
//                                  "players":playerIDs]
//        viewModel.callCreateTeam(param: param)
//    }
//
//}
//
//
//extension CreateTeamViewController:UITableViewDelegate,UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return selectedPlayers?.count ?? 0
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelectedPlayerTableViewCell
//        cell.configureCell(obj: selectedPlayers?[indexPath.row])
//        cell.callDelete = {
//            self.selectedPlayers?.remove(at: indexPath.row)
//            self.playersTableView.reloadData()
//        }
//        return cell
//        
//    }
//    
//    
//}
//
//extension CreateTeamViewController:SetLocationDelegate{
//    func sendChosenLocation(address: String, lat: String, long: String) {
//        lblLocation.text = address
//        self.lat = lat
//        self.long = long
//        self.address = address
//    }
//    
//    func sendDetailedChosenLocation(address: String, lat: String, long: String, area: String, street: String) {
//    }
//    
//}
//
//
//extension CreateTeamViewController:CreateTeamViewModelDelegate{
//    func didFinishCreateTeam() {
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    
//}
//
//extension CreateTeamViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return headers.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "typeCollectionViewCell", for: indexPath) as! TypeCollectionViewCell
//        cell.configureCell(title: headers[indexPath.row])
//        cell.callSelection = {
//            self.selectedIndex = indexPath.row
//            self.handleDisplay(index: indexPath.row)
//        }
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let spacing:CGFloat = 40
//        let width = (UIScreen.main.bounds.width - spacing)/CGFloat(headers.count)
//        return CGSize(width: width, height: 40)
//    }
//    
//    func handleDisplay(index:Int){
//        if index == 0{
//            infoStack.isHidden = false
//            playersStack.isHidden = true
//            btnCreate.setTitle("Next".localized, for: .normal)
//        }
//        else{
//            infoStack.isHidden = true
//            playersStack.isHidden = false
//            btnCreate.setTitle("Create Team".localized, for: .normal)
//        }
//    }
    
    
}
