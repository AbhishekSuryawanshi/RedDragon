//
//  StreetCreateEventsVC.swift
//  RedDragon
//
//  Created by Remya on 12/11/23.
//

import UIKit
import IQKeyboardManagerSwift
import Combine
import Toast


struct CustomImage{
    let image:UIImage
    let size:String
    let name:String
}

class StreetCreateEventsVC: UIViewController {

    @IBOutlet weak var teamStack: UIStackView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var textView: IQTextView!
    @IBOutlet weak var tableViewPositions: UITableView!
    @IBOutlet weak var lblTeam: UILabel!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var imageViewMedia: UIImageView!
    @IBOutlet weak var dateStack: UIStackView!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var positionsStack: UIStackView!
    @IBOutlet weak var textViewChineseDescription: IQTextView!
    @IBOutlet weak var btnCreatePost: UIButton!
    @IBOutlet weak var informationStack: UIStackView!
    @IBOutlet weak var fixedLocation: UILabel!
    @IBOutlet weak var fixedDescriptionEn: UILabel!
    @IBOutlet weak var fixedChooseTeam: UILabel!
    @IBOutlet weak var fixedDescriptionCn: UILabel!
    @IBOutlet weak var fixedTime: UILabel!
    @IBOutlet weak var fixedDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    //Variables
    var tableViewPlayersObserver: NSKeyValueObservation?
    var lat = ""
    var long = ""
    var address = ""
    var titleStr = ""
    var selectedImage:UIImage?
    var selectedTeam:StreetTeam?
    var positionsViewModel:PlayerPositionsViewModel?
    var createEventViewModel:CreateStreetEventsViewModel?
    var feedType:FeedsType?
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    var selectedIndex = 0
    var playerPositions:[StreetPlayerPosition]?
    var uploadResponse:UploadResponse?
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
   
    func initialSettings(){
        setupLocalisation()
        showDatePicker()
        nibInitialization()
        setupDisplay()
        configureViewModels()
        makeNetworkCall()
    }
    
    func setupDisplay(){
        tableViewPlayersObserver = tableViewPositions.observe(\.contentSize, options: .new) { (_, change) in
                    guard let height = change.newValue?.height else { return }
                    self.tableHeight.constant = height
                }
        
       
        if feedType == .searchTeam{
            teamStack.isHidden = true
            positionsStack.isHidden = true
        }
        
        if feedType == .challengeTeam{
            positionsStack.isHidden = true
            dateStack.isHidden = false
        }
        else{
            dateStack.isHidden = true
        }
       
    }
    
    func nibInitialization(){
        defineTableViewNibCell(tableView: tableViewPositions, cellName: CellIdentifier.playerPositionsTableViewCell)
    }
    
    func setupLocalisation(){
        btnCreatePost.setTitle("Create Event".localized, for: .normal)
        textView.placeholder = "Description English".localized
        textViewChineseDescription.placeholder = "Description Chinese".localized
        lblLocation.text = "Choose Location".localized
        fixedLocation.text = "Location".localized
        fixedDescriptionEn.text = "Description English".localized
        fixedDescriptionCn.text = "Description Chinese".localized
        fixedChooseTeam.text = "Choose Your Team".localized
        lblTeam.text = "Choose Your Team".localized
        fixedDate.text = "Date".localized
        txtDate.placeholder = "Date".localized
        fixedTime.text = "Time".localized
        txtTime.placeholder = "Time".localized
        lblTitle.text = "\("Create Event".localized) - \(titleStr)"
        
    }
    
    func makeNetworkCall(){
        positionsViewModel?.getPlayerPositionsAsyncCall()
    }
    
    func showLoader(_ value: Bool) {
         value ? startLoader() : stopLoader()
    }
    
    
    func configureViewModels() {
       
        createEventViewModel = CreateStreetEventsViewModel()
        createEventViewModel?.showError = { [weak self] error in
             self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
         }
        createEventViewModel?.displayLoader = { [weak self] value in
             self?.showLoader(value)
         }
        createEventViewModel?.$responseData
             .receive(on: DispatchQueue.main)
             .dropFirst()
             .sink(receiveValue: { [weak self] response in
                 if let errorResponse = response?.error {
                     self?.customAlertView(title: ErrorMessage.alert.localized, description: errorResponse.messages?.first ?? CustomErrors.unknown.description, image: ImageConstants.alertImage)
                     return
                 }
                 self?.createEventSuccess()
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
                     self?.playerListSuccess(list: list)
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
    
    func createEventSuccess(){
        self.customAlertView(title: ErrorMessage.success.localized, description: "Event Created!", image: ImageConstants.successImage) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func playerListSuccess(list:[StreetPlayerPosition]){
        self.playerPositions = list
        tableViewPositions.reloadData()
        
    }
    
    
    @IBAction func actionUpload() {
        showNewImageActionSheet(sourceView: self.view)

    }
    

    @IBAction func actionCreate(_ sender: UIButton) {
        validateInputs()
    }
    
    
    @IBAction func actionTapLocation(_ sender: Any) {
        chooseLocation()
    }
    
    
    @IBAction func actionTapTeam(_ sender: Any) {
        chooseTeam { team in
            self.selectedTeam = team
            self.lblTeam.text = team?.name
        }
    }
    
    
   
    
    func chooseLocation(){
        navigateToViewController(MapVC.self,storyboardName: StoryboardName.streetMatches) { vc in
            vc.delegate = self
        }
    }
    
    func chooseTeam(completion:((StreetTeam?)->Void)?){
        navigateToViewController(MyStreetTeamsVC.self,storyboardName: StoryboardName.streetMatches) { vc in
            vc.isForSelection = true
            vc.passTeam = completion
        }

    }
    
    func validateInputs(){
        if lat == ""{
            self.view.makeToast("Please choose location".localized)
            return
        }
        
        if textView.text == ""{
            self.view.makeToast("Please enter description of your post".localized)
            return
        }
        if textViewChineseDescription.text == ""{
            self.view.makeToast("Please enter chinese description of your post".localized)
            return
        }
        if feedType == .searchPlayer || feedType == .challengeTeam{
            if selectedTeam == nil{
                self.view.makeToast("Please choose a team".localized)
                return
                
            }
        }
        
        if feedType == .searchPlayer{
            if playerPositions?.count == (playerPositions?.filter{$0.count == 0}.count){
                self.view.makeToast("Please select needed player positions".localized)
                return
                
            }
        }
        
        if feedType == .challengeTeam{
            if txtDate.text == ""{
                self.view.makeToast("Please choose Match Date".localized)
                return
            }
            
            if txtTime.text == ""{
                self.view.makeToast("Please choose Match Time".localized)
                return
            }
        }
        
        var positionsDict = [[String:Any]]()
        for m in playerPositions ?? []{
            
            if m.count > 0{
                var dict = [String:Any]()
                dict["position"] = m.code
                dict["count"] = m.count
                positionsDict.append(dict)
            }
           
        }
       
        
        var param:[String:Any] = ["type":feedType!.rawValue,
                     "location_long":long,
                     "location_lat":lat,
                     "address":address,
                     "description":textView.text!,
                     "description_cn":textViewChineseDescription.text!,
                     "img_url":uploadResponse?.path ?? "",
                     "positions":positionsDict]
        if feedType != .searchTeam{
            param["team_id"] = selectedTeam!.id
        }
        
        if feedType == .challengeTeam{
            let matchTime = txtDate.text! + " " + txtTime.text!
            param["schedule_time"] = matchTime
        }
        createEventViewModel?.createStreetEventAsyncCall(parameters: param)
           
        }
    }



extension StreetCreateEventsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerPositions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.playerPositionsTableViewCell, for: indexPath) as! PlayerPositionsTableViewCell
        cell.configureCell(obj: playerPositions?[indexPath.row])
        cell.updateCount = { count in
            self.playerPositions?[indexPath.row].count = count
        }
        return cell
    }
   
}

extension StreetCreateEventsVC:SetLocationDelegate{
    func sendChosenLocation(address: String, lat: String, long: String) {
        lblLocation.text = address
        self.lat = lat
        self.long = long
        self.address = address
    }
    
}

//MARK: - ImagePicker Delegate
extension StreetCreateEventsVC: ImagePickerDelegate, UINavigationControllerDelegate {
    func pickerCanceled() { }
    
    func finishedPickingImage(image: UIImage, imageName: String) {
        //self.imgProfile.image = image
        self.selectedImage = image
        self.imageViewMedia.image = image
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            StreetImageUploadViewModel.shared.uploadStreetImageAsyncCall(imageName: "img", imageData: imageData)
        }
    }
}


//Date Picker
extension StreetCreateEventsVC{
    
    func showDatePicker(){
    //Formate Date
     datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            if #available(iOS 13.4, *) {
                timePicker.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
        }
        datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        timePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        

     //ToolBar
    let toolbar1 = UIToolbar();
    toolbar1.sizeToFit()
        let toolbar2 = UIToolbar();
        toolbar2.sizeToFit()

    //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done".localized, style: UIBarButtonItem.Style.plain, target: self, action: #selector(donedatePicker))
        let doneButton2 = UIBarButtonItem(title: "Done".localized, style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneTimePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel".localized, style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelDatePicker))
    toolbar1.setItems([doneButton,spaceButton,cancelButton], animated: false)
        toolbar2.setItems([doneButton2,spaceButton,cancelButton], animated: false)

 // add toolbar to textField
 txtDate.inputAccessoryView = toolbar1
  // add datepicker to textField
        txtDate.inputView = datePicker
        txtTime.inputAccessoryView = toolbar2
        txtTime.inputView = timePicker

    }

 @objc func donedatePicker(){
   //For date formate
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
      txtDate.text = formatter.string(from: datePicker.date)
    //dismiss date picker dialog
    self.view.endEditing(true)
     }

      @objc func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
         self.view.endEditing(true)
       }
    
    @objc func doneTimePicker(){
      //For date formate
       let formatter = DateFormatter()
       formatter.dateFormat = "HH:mm:ss"
         txtTime.text = formatter.string(from: datePicker.date)
       //dismiss date picker dialog
       self.view.endEditing(true)
        }
}
