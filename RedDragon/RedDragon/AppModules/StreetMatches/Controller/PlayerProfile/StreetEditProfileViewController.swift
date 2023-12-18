//
//  StreetEditProfileViewController.swift
//  RedDragon
//
//  Created by Remya on 12/15/23.
//

import UIKit
import IQKeyboardManagerSwift
import Combine
import Toast

class StreetEditProfileViewController: UIViewController {

    @IBOutlet weak var positionDropDown: DropDown!
    @IBOutlet weak var footDropDown: DropDown!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var textViewDescription: IQTextView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var txtHeight: UITextField!
    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var textViewDescriptionCn: IQTextView!
    @IBOutlet weak var imgPencil: UIImageView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var fixedPreferredFoot: UILabel!
    @IBOutlet weak var fixedFirstName: UILabel!
    @IBOutlet weak var fixedAboutPlayerEn: UILabel!
    @IBOutlet weak var fixedLastName: UILabel!
    @IBOutlet weak var fixedAboutPlayerCn: UILabel!
    @IBOutlet weak var fixedDob: UILabel!
    @IBOutlet weak var fixedMainPosition: UILabel!
    @IBOutlet weak var fixedLocation: UILabel!
    @IBOutlet weak var fixedWeight: UILabel!
    @IBOutlet weak var fixedHeight: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    var editProfileViewModel :StreetEditProfileViewModel?
    var positionsViewModel:PlayerPositionsViewModel?
    var myPlayerProfileVM:StreetMyPlayerProfileViewModel?
    var foot = ""
    var lat = ""
    var long = ""
    var address = ""
    var selectedPosition:Int?
    let datePicker = UIDatePicker()
    let footsArray = ["LEFT".localized,"RIGHT".localized]
    var uploadResponse:UploadResponse?
    var playerPositions:[StreetPlayerPosition]?
    var user:StreetProfileUser?
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
   
    
    @IBAction func actionTapLocation(_ sender: Any) {
        chooseLocation()
    }
    
    @IBAction func actionChooseImage(_ sender: Any) {
        showNewImageActionSheet(sourceView: self.view)
    }
    
    
    
    @IBAction func updateProfile(){
        validateInputs()
    }
    
    
   
    func initialSettings(){
        setupLocalisation()
        fillData()
        showDatePicker()
        configureDropdown()
        configureViewModels()
        makeNetworkCall()
        
    }
    
    func setupLocalisation(){
        btnSave.setTitle("Save".localized, for: .normal)
        lblTitle.text = "Edit Profile".localized
        textViewDescriptionCn.placeholder = "About Player Chinese".localized
        textViewDescription.placeholder = "About Player English".localized
        txtFirstName.placeholder = "First Name".localized
        fixedFirstName.text = "First Name".localized
        txtLastName.placeholder = "Last Name".localized
        fixedLastName.text = "Last Name".localized
        lblLocation.text = "Choose Location".localized
        fixedLocation.text = "Location".localized
        fixedMainPosition.text = "Main Position".localized
        txtDOB.placeholder = "Date of Birth".localized
        fixedDob.text = "Date of Birth".localized
        txtHeight.placeholder = "Height (cm)".localized
        fixedHeight.text = "Height (cm)".localized
        txtWeight.placeholder = "Weight (kg)".localized
        fixedWeight.text = "Weight (kg)".localized
        btnSave.setTitle("Save".localized, for: .normal)
        fixedPreferredFoot.text = "Preferred Foot".localized
        fixedAboutPlayerEn.text = "About Player English".localized
        fixedAboutPlayerCn.text = "About Player Chinese".localized
        
    }
    
    func makeNetworkCall(){
        positionsViewModel?.getPlayerPositionsAsyncCall()
        myPlayerProfileVM?.getMyProfileAsyncCall()
    }
    
    func showLoader(_ value: Bool) {
         value ? startLoader() : stopLoader()
    }
    
    func configureViewModels(){
        
        myPlayerProfileVM = StreetMyPlayerProfileViewModel()
        myPlayerProfileVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        myPlayerProfileVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        myPlayerProfileVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                if let data = response?.response?.data{
                    self?.handleUserData(data: data)
                }
            })
            .store(in: &cancellable)
        //editProfileViewModel
        editProfileViewModel = StreetEditProfileViewModel()
        editProfileViewModel?.showError = { [weak self] error in
             self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
         }
        editProfileViewModel?.displayLoader = { [weak self] value in
             self?.showLoader(value)
         }
        editProfileViewModel?.$responseData
             .receive(on: DispatchQueue.main)
             .dropFirst()
             .sink(receiveValue: { [weak self] response in
                 self?.updateProfileSuccess()
             })
             .store(in: &cancellable)
        
        
        //PositionsViewModel
        positionsViewModel = PlayerPositionsViewModel()
        positionsViewModel?.showError = { [weak self] error in
             self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
         }
        positionsViewModel?.displayLoader = { [weak self] value in
             self?.showLoader(value)
         }
        positionsViewModel?.$responseData
             .receive(on: DispatchQueue.main)
             .dropFirst()
             .sink(receiveValue: { [weak self] response in
                 if let list = response?.response?.data{
                     self?.positionListSuccess(list: list)
                 }
             })
             .store(in: &cancellable)
        
        //StreetImageUploadViewModel
        
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
                if response?.response?.data != nil{
                    self?.uploadResponse = response!.response!.data
                }
            })
            .store(in: &cancellable)
    }
    
    func positionListSuccess(list:[StreetPlayerPosition]){
        self.playerPositions = list
        if let code = user?.player?.position{
            selectedPosition = playerPositions?.firstIndex(where: {$0.code == code})
        }
        
        positionDropDown.optionArray = playerPositions?.map{$0.name ?? ""} ?? []
        
    }
    
    func updateProfileSuccess(){
        self.customAlertView(title: ErrorMessage.success.localized, description: "Profile Updated!", image: ImageConstants.successImage) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func handleUserData(data:StreetProfileUser){
        self.user = data
        fillData()
    }
    
    func fillData(){
        txtFirstName.text = user?.firstName
        txtLastName.text = user?.lastName
        imgProfile.setImage(imageStr: user?.player?.imgURL ?? "", placeholder: .placeholderUser)
        textViewDescription.text = user?.player?.description
        textViewDescriptionCn.text = user?.player?.descriptionCN
        lblLocation.text = user?.address
        address = user?.address ?? ""
        lat = "\(user?.locationLat ?? 0)"
        long = "\(user?.locationLong ?? 0)"
        footDropDown.text = (user?.player?.dominateFoot ?? "").localized
        foot = user?.player?.dominateFoot ?? ""
        positionDropDown.text = user?.player?.positionName
        txtDOB.text = user?.player?.birthdate
        txtWeight.text = "\(user?.player?.weight ?? 0)"
        txtHeight.text = "\(user?.player?.height ?? 0)"
        if let code = user?.player?.position{
            selectedPosition = playerPositions?.firstIndex(where: {$0.code == code})
        }
    }
    
    func configureDropdown(){
       
        positionDropDown.didSelect { selectedText, index, id in
            self.selectedPosition = index
        }
        
        footDropDown.optionArray = footsArray
        footDropDown.didSelect { selectedText, index, id in
            if index == 0{
                self.foot = "LEFT"
            }
            else{
                self.foot = "RIGHT"
            }
        }
        
        
    }
    
    func chooseLocation(){
        navigateToViewController(MapVC.self,storyboardName: StoryboardName.streetMatches) { vc in
            vc.delegate = self
        }
    }
    
   
    
    func validateInputs(){
        if txtFirstName.text == ""{
            self.view.makeToast("Please enter first name".localized)
            return
        }
        
        if txtLastName.text == ""{
            self.view.makeToast("Please enter last name".localized)
            return
            
        }
        
        
        
        if lat == ""{
            self.view.makeToast("Please choose your location".localized)
            return
            
        }
        
        if selectedPosition == nil{
            self.view.makeToast("Please choose player position".localized)
            return
            
        }
        if txtWeight.text == ""{
            self.view.makeToast("Please enter your weight".localized)
            return
            
        }
        if txtHeight.text == ""{
            self.view.makeToast("Please enter your height".localized)
            return
            
        }
        
        
        let param:[String:Any] = ["first_name":txtFirstName.text!,
                                  "last_name":txtLastName.text!,
                                  "location_long": long,
                                     "location_lat": lat,
                                  "address":address,
                                     "dominate_foot": foot,
                                  "birthdate":txtDOB.text ?? "",
                                  "weight": txtWeight.text ?? "",
                                  "height": txtHeight.text ?? "",
                                  "position":playerPositions![selectedPosition!].code,
                                  "description":textViewDescription.text ?? "",
                                  "img_url":uploadResponse?.path ?? "",
                                  "description_cn":textViewDescriptionCn.text ?? ""]
        editProfileViewModel?.updateProfileAsyncCall(param: param)
    }

}


extension StreetEditProfileViewController:SetLocationDelegate{
    func sendChosenLocation(address: String, lat: String, long: String) {
        lblLocation.text = address
        self.lat = lat
        self.long = long
        self.address = address
    }
  
}

//MARK: - ImagePicker Delegate
extension StreetEditProfileViewController: ImagePickerDelegate, UINavigationControllerDelegate {
    func pickerCanceled() { }
    
    func finishedPickingImage(image: UIImage, imageName: String) {
        //self.imgProfile.image = image
        self.imgProfile.image = image
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            StreetImageUploadViewModel.shared.uploadStreetImageAsyncCall(imageName: "img", imageData: imageData)
        }
    }
}





//Date Picker
extension StreetEditProfileViewController{
    
    func showDatePicker(){
    //Formate Date
     datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }

     //ToolBar
    let toolbar = UIToolbar();
    toolbar.sizeToFit()

    //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done".localized, style: UIBarButtonItem.Style.plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel".localized, style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelDatePicker))
    toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

       // add toolbar to textField
      txtDOB.inputAccessoryView = toolbar
        // add datepicker to textField
        txtDOB.inputView = datePicker

    }

 @objc func donedatePicker(){
   //For date formate
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
      txtDOB.text = formatter.string(from: datePicker.date)
    //dismiss date picker dialog
    self.view.endEditing(true)
     }

      @objc func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
         self.view.endEditing(true)
       }
}
