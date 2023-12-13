//
//  CreateStreetMatchVC.swift
//  RedDragon
//
//  Created by Remya on 12/9/23.
//

import UIKit
import IQKeyboardManagerSwift
import Combine
import Toast

class CreateStreetMatchVC: UIViewController {

    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var textView: IQTextView!
    @IBOutlet weak var textViewChineseDescription: IQTextView!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var lblAwayTeamName: UILabel!
    @IBOutlet weak var lblHomeTeamName: UILabel!
    @IBOutlet weak var fixedHome: UILabel!
    @IBOutlet weak var fixedTime: UILabel!
    @IBOutlet weak var fixedAway: UILabel!
    @IBOutlet weak var fixedLocation: UILabel!
    @IBOutlet weak var fixedDate: UILabel!
    @IBOutlet weak var fixedAboutMatchCn: UILabel!
    @IBOutlet weak var fixedAboutMatchEn: UILabel!
    
    //Variables
    var homeTeam:StreetTeam?
    var awayTeam:StreetTeam?
    var lat = ""
    var long = ""
    var address = ""
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    var createMatchViewModel:CreateMatchViewModel?
    var headers = ["Team".localized,"Details".localized]
    var selectedIndex = 0
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()

    }
    
  
    
    @IBAction func actionTapHome(_ sender: Any) {
        
        chooseTeam { team in
            if team?.id == self.awayTeam?.id{
                self.view.makeToast("Please choose a different team".localized)
                return
            }
            self.homeTeam = team
            self.lblHomeTeamName.text = team?.name
        }
        
    }
    
    
    @IBAction func actionTapAway(_ sender: Any) {
        chooseTeam { team in
            if team?.id == self.homeTeam?.id{
                self.view.makeToast("Please choose a different team".localized)
                return
            }
            self.awayTeam = team
            self.lblAwayTeamName.text = team?.name
        }
    }
    
    
    @IBAction func tapLocation(_ sender: Any) {
        chooseLocation()
    }
    
    @IBAction func actionCreate(_ sender: Any) {
        validations()
    }
    
    func initialSettings(){
        setupLocalisation()
        showDatePicker()
        setupViewModels()
    }
    
    func setupLocalisation(){
        btnCreate.setTitle("Create Match".localized, for: .normal)
        textView.placeholder = "Description English".localized
        textViewChineseDescription.placeholder = "Description Chinese".localized
        txtDate.placeholder = "Date".localized
        fixedDate.text = "Date".localized
        txtTime.placeholder = "Time".localized
        fixedTime.text = "Time".localized
        fixedLocation.text = "Location".localized
        lblLocation.text = "Choose Location".localized
        lblHomeTeamName.text = "Choose Home Team".localized
        lblAwayTeamName.text = "Choose Away Team".localized
        fixedHome.text = "Home Team".localized
        fixedAway.text = "Away Team".localized
        fixedAboutMatchCn.text = "About Match Chinese".localized
        fixedAboutMatchEn.text = "About Match English".localized
    }
    
    func setupViewModels(){
        createMatchViewModel = CreateMatchViewModel()
        createMatchViewModel?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        createMatchViewModel?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        createMatchViewModel?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                //popup
                self?.createMatchSuccess()
            })
            .store(in: &cancellable)
        
        
    }
    
    func createMatchSuccess(){
        self.customAlertView(title: ErrorMessage.success.localized, description: "Match Created!", image: ImageConstants.successImage) {
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
    
    func chooseTeam(completion:((StreetTeam?)->Void)?){
        navigateToViewController(MyStreetTeamsVC.self,storyboardName: StoryboardName.streetMatches) { vc in
            vc.isForSelection = true
            vc.passTeam = completion
        }
    }
    
    func validations(){
        if homeTeam == nil{
            self.view.makeToast("Please choose home team".localized)
            return
        }
        
        if awayTeam == nil{
            self.view.makeToast("Please choose away team".localized)
            return
        }
        
        if txtDate.text == ""{
            self.view.makeToast("Please choose Match Date".localized)
            return
        }
        
        if txtTime.text == ""{
            self.view.makeToast("Please choose Match Time".localized)
            return
        }
        
        if lat == ""{
            self.view.makeToast("Please choose Match location".localized)
            return
        }
        let matchTime = txtDate.text! + " " + txtTime.text!
        let params:[String:Any] = ["home_team_id":homeTeam!.id,
                                   "away_team_id":awayTeam!.id,
                                   "location_long":long,
                                   "location_lat":lat,
                                   "address":address,
                                   "schedule_time":matchTime,
                                   "description":textView.text ?? "",
                                   "description_cn":textViewChineseDescription.text ?? ""]
        createMatchViewModel?.createMatchAsyncCall(parameters: params)
        
    }

   
   
}


extension CreateStreetMatchVC:SetLocationDelegate{
    func sendChosenLocation(address: String, lat: String, long: String) {
        lblLocation.text = address
        self.lat = lat
        self.long = long
        self.address = address
    }
    
}


//Date Picker
extension CreateStreetMatchVC{
    
    func showDatePicker(){
    //Formate Date
     datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
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
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donedatePicker))
        let doneButton2 = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneTimePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelDatePicker))
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


