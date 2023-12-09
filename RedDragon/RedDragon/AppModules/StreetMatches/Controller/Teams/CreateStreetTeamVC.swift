//
//  CreateStreetTeamVC.swift
//  RedDragon
//
//  Created by Remya on 12/8/23.
//

import UIKit
import IQKeyboardManagerSwift
import Combine
import Toast

class CreateStreetTeamVC: UIViewController {

    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtTeamName: UITextField!
    @IBOutlet weak var textViewAbout: IQTextView!
    @IBOutlet weak var playersTableView: UITableView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var playersTableHeight: NSLayoutConstraint!
    @IBOutlet weak var txtChineseTeamName: UITextField!
    @IBOutlet weak var textViewChineseAbout: IQTextView!
    @IBOutlet weak var lblTitle: UILabel!
   // @IBOutlet weak var infoStack: UIStackView!
    //@IBOutlet weak var playersStack: UIStackView!
   // @IBOutlet weak var fixedUploadLogo: UILabel!
    @IBOutlet weak var fixedTeamNameEn: UILabel!
    @IBOutlet weak var fixedTeamNameCn: UILabel!
    @IBOutlet weak var fixedLocation: UILabel!
    @IBOutlet weak var fixedAboutTeamCn: UILabel!
    @IBOutlet weak var fixedAboutTeamEn: UILabel!
    @IBOutlet weak var fixedAddPlayers: UILabel!
    // @IBOutlet weak var btnAddPlayers: UIButton!
    //Variables
    var tableViewPlayersObserver: NSKeyValueObservation?
    var lat = ""
    var long = ""
    var address = ""
    var profileImage:UIImage?
    var selectedPlayers:[StreetMatchPlayer]?
    var createTeamViewModel = CreateTeamViewModel()
    var headers = ["Info".localized,"Players".localized]
    var selectedIndex = 0
    private var cancellable = Set<AnyCancellable>()
    var uploadResponse:UploadResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
   
    @IBAction func actionCreateTeam(_ sender: Any) {
        validations()
    }
   
    @IBAction func actionTapLocation(_ sender: Any) {
        chooseLocation()
    }
    
    @IBAction func tapChooseImage(_ sender: Any) {
        showNewImageActionSheet(sourceView: self.view)
    }
   
    func initialSettings(){
        nibInitialization()
        setupLocalisation()
        tableViewPlayersObserver = playersTableView.observe(\.contentSize, options: .new) { (_, change) in
                    guard let height = change.newValue?.height else { return }
                    self.playersTableHeight.constant = height
                }
        setupViewModels()
      
    }
    func nibInitialization() {
        defineTableViewNibCell(tableView: playersTableView, cellName: CellIdentifier.streetMatchPlayerTableViewCell)
    }
    
    func setupLocalisation(){
        btnCreate.setTitle("Create Team".localized, for: .normal)
        lblTitle.text = "Create Team".localized
        textViewAbout.placeholder = "About Team English".localized
        textViewChineseAbout.placeholder = "About Team Chinese".localized
        fixedTeamNameEn.text = "Team Name English".localized
        txtTeamName.placeholder = "Team Name English".localized
        fixedTeamNameCn.text = "Team Name Chinese".localized
        txtChineseTeamName.placeholder = "Team Name Chinese".localized
        fixedLocation.text = "Location".localized
        lblLocation.text = "Choose Location".localized
        fixedAboutTeamCn.text = "About Team Chinese".localized
        fixedAboutTeamEn.text = "About Team English".localized
        fixedAddPlayers.text = "Add Players".localized
    }
    
    
    func setupViewModels(){
        
        createTeamViewModel.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        createTeamViewModel.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        createTeamViewModel.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                //popup
                self?.createTeamSuccess()
            })
            .store(in: &cancellable)
        
        StreetImageUploadViewModel.shared.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        
        StreetImageUploadViewModel.shared.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        StreetImageUploadViewModel.shared.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                self?.uploadResponse = response
            })
            .store(in: &cancellable)
    }
    
    func createTeamSuccess(){
        self.customAlertView(title: ErrorMessage.success.localized, description: "Team Created!", image: ImageConstants.successImage) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showLoader(_ value: Bool) {
         value ? startLoader() : stopLoader()
    }
    
    func chooseLocation(){
        navigateToViewController(MapVC.self,storyboardName: StoryboardName.streetMatches) { vc in
            vc.delegate = self
        }
    }
    func actionAddPlayers() {
        navigateToViewController(AddStreetPlayersVC.self,storyboardName: StoryboardName.streetMatches) { vc in
            vc.chosenPlayers = self.selectedPlayers
            vc.passPlayers = { players in
                self.selectedPlayers = players
                self.playersTableView.reloadData()
            }
            
        }
       
    }
    
    func validations(){
        if profileImage == nil{
            self.view.makeToast("Please choose team logo".localized)
            return
        }
        
        if txtTeamName.text == ""{
            self.view.makeToast("Please enter team name English".localized)
            return
        }
        if txtChineseTeamName.text == ""{
            self.view.makeToast("Please enter team name Chinese".localized)
            return
        }
       
       
        if lat == ""{
            self.view.makeToast("Please choose location".localized)
            return
        }
        
        if textViewAbout.text == ""{
            self.view.makeToast("Please enter about team English".localized)
            return
        }
        
        if textViewChineseAbout.text == ""{
            self.view.makeToast("Please enter about team Chinese".localized)
            return
        }
        if selectedPlayers?.count ?? 0 == 0{
            self.view.makeToast("Please choose players".localized)
            return
        }
        
        let playerIDs:[Int] = selectedPlayers?.map{$0.id } ?? []
        let param:[String:Any] = ["name":txtTeamName.text!,
                                  "name_cn":txtChineseTeamName.text!,
                                  "location_lat":lat,
                                  "location_long":long,
                                  "address":address,
                                  "description":textViewAbout.text ?? "",
                                  "description_cn":textViewChineseAbout.text ?? "",
                                  "logo_img_url":uploadResponse?.path ?? "",
                                  "players":playerIDs]
        createTeamViewModel.createTeamAsyncCall(param: param)
    }

}


extension CreateStreetTeamVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedPlayers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.streetMatchPlayerTableViewCell, for: indexPath) as! StreetMatchPlayerTableViewCell
        cell.configureCell(obj: selectedPlayers?[indexPath.row])
        cell.callDelete = {
            self.selectedPlayers?.remove(at: indexPath.row)
            self.playersTableView.reloadData()
        }
        cell.btnDelete.isHidden = false
        return cell
        
    }
   
}

extension CreateStreetTeamVC:SetLocationDelegate{
    func sendChosenLocation(address: String, lat: String, long: String) {
        lblLocation.text = address
        self.lat = lat
        self.long = long
        self.address = address
    }
 
}

//MARK: - ImagePicker Delegate
extension CreateStreetTeamVC: ImagePickerDelegate, UINavigationControllerDelegate {
    func pickerCanceled() { }
    
    func finishedPickingImage(image: UIImage, imageName: String) {
        self.imgProfile.image = image
        self.profileImage = image
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            StreetImageUploadViewModel.shared.uploadStreetImageAsyncCall(imageName: "img", imageData: imageData)
        }
    }
}

