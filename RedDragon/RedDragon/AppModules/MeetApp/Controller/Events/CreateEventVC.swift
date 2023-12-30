//
//  CreateEventVC.swift
//  RedDragon
//
//  Created by iOS Dev on 28/11/2023.
//

import UIKit
import CoreLocation
import Combine

class CreateEventVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var eventTitleTextField: UITextField!
    @IBOutlet weak var startEventDateTextField: UITextField!
    @IBOutlet weak var startEventTimeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var eventDescTextView: UITextView!
    @IBOutlet weak var eventImgView: UIImageView!
    @IBOutlet weak var priceSegmentControl: UISegmentedControl!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var sportsTitleLabel: UILabel!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDescriptionTitleLabel: UILabel!
    @IBOutlet weak var addImageTitleLabel: UILabel!
    @IBOutlet weak var startEventTitleLabel: UILabel!
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var eventPriceTitleLabel: UILabel!
    @IBOutlet weak var scheduleEventButton: UIButton!
    @IBOutlet weak var eventCreatedTitleLabel: UILabel!
    @IBOutlet weak var eventMessageSubtitleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var controllerHeaderTitleLabel: UILabel!
    
    var dateFormatter = DateFormatter()
    var geocoder = CLGeocoder()
    var eventRequest: MeetEvent!
    var sportsInterestArray = [SportsInterest]()
    var sportsInterestVM: MeetUserSportsInterestViewModel?
    var meetCreateEventVM: MeetCreateEventVM?
    var cancellable = Set<AnyCancellable>()
    var selectedCellRow = 0
    var selectedImage: (String, Data)?
    var isPaid: Int = 0
    var price = Float()
    var latitude = Double()
    var longitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performInitialSetup()
        performLanguageLocalisation()
    }
    
    // MARK: - Methods
    func performLanguageLocalisation() {
        controllerHeaderTitleLabel.text = "Schedule a Match".localized
        sportsTitleLabel.text = "Select sports type *".localized
        eventTitleLabel.text = "Event Title *".localized
        eventDescriptionTitleLabel.text = "Event Description *".localized
        addImageTitleLabel.text = "Add Image *".localized
        startEventTitleLabel.text = "Start Event *".localized
        locationTitleLabel.text = "Location *".localized
        eventPriceTitleLabel.text = "Event Price *".localized
        eventCreatedTitleLabel.text = "Event Created!".localized
        eventMessageSubtitleLabel.text = "The event has been created successfully.".localized
        scheduleEventButton.setTitle("Schedule Event".localized, for: .normal)
        doneButton.setTitle("Done".localized, for: .normal)
        priceSegmentControl.setTitle("Free".localized, forSegmentAt: 0)
        priceSegmentControl.setTitle("Paid".localized, forSegmentAt: 1)
    }
    
    func performInitialSetup() {
        self.startEventDateTextField.addInputViewDatePicker(target: self, selector: #selector(startDateDoneAction))
        self.startEventTimeTextField.addInputViewDatePicker(target: self, selector: #selector(startTimeDoneAction), datePickerMode: .time)
        nibInitialization()
        makeNetworkCall()
        fetchMeetUserSportsInterestViewModel()
        priceSegmentAction(priceSegmentControl)
        successView.isHidden = true
    }
    
    func nibInitialization() {
        collectionView.register(CellIdentifier.headerBottom_1CollectionViewCell)
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    func makeNetworkCall() {
        sportsInterestVM = MeetUserSportsInterestViewModel()
        sportsInterestVM?.fetchSportsInterestAsyncCall()
    }
    
    func geocodeAddress(address: String) {
        geocoder.geocodeAddressString(address) { [self]
            placemarks, error in
            let placemark = placemarks?.first
            self.latitude = (placemark?.location?.coordinate.latitude) ?? 0.0
            self.longitude = (placemark?.location?.coordinate.longitude) ?? 0.0
            print("Lat: \(latitude), Lon: \(self.longitude)")
        }
    }
    
    func validate() -> Bool {
        if eventTitleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.view.makeToast(ErrorMessage.eventTitleEmptyAlert.localized)
            return false
        } else if eventDescTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.view.makeToast(ErrorMessage.eventDescEmptyAlert.localized)
            return false
        } else if selectedImage?.0 == nil {
            self.view.makeToast(ErrorMessage.eventImageEmptyAlert.localized)
            return false
        } else if startEventDateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.view.makeToast(ErrorMessage.eventStartDateEmptyAlert.localized)
            return false
        } else if startEventTimeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.view.makeToast(ErrorMessage.eventStartTimeEmptyAlert.localized)
            return false
        } else if locationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.view.makeToast(ErrorMessage.eventLocationEmptyAlert.localized)
            return false
        }else if (isPaid == 1 && price == 0.0) {
            self.view.makeToast(ErrorMessage.eventPriceEmptyAlert.localized)
            return false
        }
        return true
    }
    
    // MARK: - Button Actions
    @objc func startDateDoneAction(textField: UITextField) { // 2023-10-15 , // 03:30:00
        if let datePickerView = self.startEventDateTextField.inputView as? UIDatePicker {
            dateFormatter.dateFormat = dateFormat.yyyyMMdd.rawValue
            //"yyyy-MM-dd"
            let dateString = dateFormatter.string(from: datePickerView.date)
            self.startEventDateTextField.text = dateString
            self.startEventDateTextField.resignFirstResponder()
        }
    }
    
    @objc func startTimeDoneAction(textField: UITextField) { // 2023-10-15 , // 03:30:00
        if let datePickerView = self.startEventTimeTextField.inputView as? UIDatePicker {
            dateFormatter.dateFormat = dateFormat.hhmmss.rawValue
            let dateString = dateFormatter.string(from: datePickerView.date)
            self.startEventTimeTextField.text = dateString
            self.startEventTimeTextField.resignFirstResponder()
        }
    }
    
    @IBAction func addEventImageBtnAction(_ sender: Any) {
        showNewImageActionSheet(sourceView: self.view)
    }
    
    @IBAction func priceSegmentAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            priceView.isHidden = true
            isPaid = 0
        }else {
            priceView.isHidden = false
            isPaid = 1
        }
    }
    
    @IBAction func createEventBtnAction(_ sender: Any) {
    
        if validate() {
            geocodeAddress(address: locationTextField.text!)
            var priceString = priceTextField.text ?? "0"
            if priceString == ""{
                priceString = "0"
            }
            price = Float(priceString)!
            eventRequest =
            MeetEvent(name: eventTitleTextField.text!, description: eventDescTextView.text!, interestId: sportsInterestArray[self.selectedCellRow].id!, latitude: latitude, longitude: longitude, date: startEventDateTextField.text!, time: startEventTimeTextField.text!, address: locationTextField.text!, isPaid: isPaid, price: price)
            print(eventRequest as Any)
            let dict = eventRequest.dictionary
            meetCreateEventVM = MeetCreateEventVM()
            meetCreateEventVM?.postCreateEventAsyncCall(params: dict, imageName: selectedImage!.0, imageData: selectedImage!.1)
            fetchCreateEventViewModelResponse()
        }
    }
    
    @IBAction func successAlertDoneBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: - ImagePicker Delegate
extension CreateEventVC: ImagePickerDelegate, UINavigationControllerDelegate {
    func pickerCanceled() { }
    
    func finishedPickingImage(image: UIImage, imageName: String) {
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            // Pass the image data and image name to your view model for uploading
            eventImgView.image = image
            selectedImage = (imageName, imageData)
        }
    }
}

extension CreateEventVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sportsInterestArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionCell(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = sportsInterestArray[indexPath.row].name?.capitalized ?? ""
        return CGSize(width: title.size(withAttributes: [NSAttributedString.Key.font : fontSemiBold(15)]).width + 70, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedCellRow = indexPath.row
        collectionView.reloadData()
    }
}

extension CreateEventVC {
    func fetchMeetUserSportsInterestViewModel() {
        ///fetch view model for user sport interest list
        sportsInterestVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        sportsInterestVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        sportsInterestVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] interestList in
                self?.execute_onUserSportInterestListResponse(interestList!)
            })
            .store(in: &cancellable)
    }
    
    func fetchCreateEventViewModelResponse() {
        meetCreateEventVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        meetCreateEventVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        meetCreateEventVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] detail in
                self?.execute_onCreateEventResponseData(detail!)
            })
            .store(in: &cancellable)
    }
    
    func execute_onUserSportInterestListResponse(_ interestList: MeetUserSportsInterestModel) {
        self.sportsInterestArray = interestList.response?.data ?? []
        collectionView.reloadData()
    }
    
    func execute_onCreateEventResponseData(_ detail: MeetEventDetailModel) {
        if detail.response?.code == 200 {
            successView.isHidden = false
        }
    }
    
    private func collectionCell(indexPath:IndexPath) -> HeaderBottom_1CollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.headerBottom_1CollectionViewCell, for: indexPath) as! HeaderBottom_1CollectionViewCell
        let title = sportsInterestArray[indexPath.row].name?.capitalized ?? ""
        let icon = sportsInterestArray[indexPath.row].sportImage?.image ?? ""
        cell.configure(title: title, iconName: icon, selected: indexPath.row == selectedCellRow)
        return cell
    }
}
