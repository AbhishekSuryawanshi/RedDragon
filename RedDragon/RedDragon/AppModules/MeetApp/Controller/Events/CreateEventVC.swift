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
    @IBOutlet weak var sportsCollectionView: UICollectionView!
    @IBOutlet weak var eventTitleTextField: UITextField!
    @IBOutlet weak var startEventDateTextField: UITextField!
    @IBOutlet weak var startEventTimeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var eventDescTextView: UITextView!
    @IBOutlet weak var eventImgView: UIImageView!
    @IBOutlet weak var priceSwitch: UISwitch!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var priceView: UIView!
    var dateFormatter = DateFormatter()
    var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performInitialSetup()
    }
    
    // MARK: - Methods
    func performInitialSetup() {
        self.startEventDateTextField.addInputViewDatePicker(target: self, selector: #selector(startDateDoneAction))
        self.startEventTimeTextField.addInputViewDatePicker(target: self, selector: #selector(startTimeDoneAction), datePickerMode: .time)
    }
    
    func geocodeAddress(address: String) {
        geocoder.geocodeAddressString(address) {
            placemarks, error in
            let placemark = placemarks?.first
            let lat = placemark?.location?.coordinate.latitude
            let lon = placemark?.location?.coordinate.longitude
           // print("Lat: \(lat), Lon: \(lon)")
        }
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

    @IBAction func createEventBtnAction(_ sender: Any) {
        
    }
}

//MARK: - ImagePicker Delegate
extension CreateEventVC: ImagePickerDelegate, UINavigationControllerDelegate {
    func pickerCanceled() { }
    
    func finishedPickingImage(image: UIImage, imageName: String) {
        if let imageData = image.jpegData(compressionQuality: 0.8) {
           // Pass the image data and image name to your view model for uploading
          //  SocialPostImageViewModel.shared.imageAsyncCall(imageName: imageName, imageData: imageData)
        }
    }
}
