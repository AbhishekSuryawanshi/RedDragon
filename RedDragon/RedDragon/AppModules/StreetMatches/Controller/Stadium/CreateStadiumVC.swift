//
//  CreateStadiumVC.swift
//  RedDragon
//
//  Created by Remya on 12/1/23.
//

import UIKit
import IQKeyboardManagerSwift
import Toast
import Combine

class CreateStadiumVC:UIViewController{
    @IBOutlet weak var collectionViewImages:UICollectionView!
    @IBOutlet weak var fixedStadiumNamEn:UILabel!
    @IBOutlet weak var fixedStadiumNamCn:UILabel!
    @IBOutlet weak var fixedLblLocation:UILabel!
    @IBOutlet weak var fixedAboutStadiumEn:UILabel!
    @IBOutlet weak var fixedAboutStadiumCn:UILabel!
    @IBOutlet weak var fixedTimings:UILabel!
    @IBOutlet weak var lblLocation:UILabel!
    @IBOutlet weak var txtStadiumNameEn:UITextField!
    @IBOutlet weak var txtStadiumNameCn:UITextField!
    //@IBOutlet weak var txtOwnerName:UITextField!
    @IBOutlet weak var textViewAboutEn:IQTextView!
    @IBOutlet weak var textViewAboutCn:IQTextView!
   // @IBOutlet weak var textViewAddress:IQTextView!
    @IBOutlet weak var tableviewTimings:UITableView!
    @IBOutlet weak var tableviewHights:NSLayoutConstraint!
    @IBOutlet weak var collectionViewSports: UICollectionView!
    @IBOutlet weak var collectionViewAmenities: UICollectionView!
    @IBOutlet weak var fixedInfo: UILabel!
    @IBOutlet weak var fixedChooseSports: UILabel!
    @IBOutlet weak var fixedChooseAmenities: UILabel!
    @IBOutlet weak var btnCreateStadium: UIButton!
    @IBOutlet weak var fixedAdditionalInfo: UILabel!
    @IBOutlet weak var fixedLblCreateStadium: UILabel!
    @IBOutlet weak var fixedLblMedia: UILabel!
    
    
    //Variables
    var images = [UIImage]()
    var createStadiumViewModel = CreateStadiumViewModel()
    private var cancellable = Set<AnyCancellable>()
    var lat = ""
    var long = ""
    var address = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    
    @IBAction func actionTapLocation(_ sender: Any) {
        chooseLocation()
    }
    
    func chooseLocation(){
        navigateToViewController(MapVC.self,storyboardName: StoryboardName.streetMatches) { vc in
            vc.delegate = self
        }
        
    }
    
    
    @IBAction func actionCreateStadium(){
        if validateFields(){
            var sports = [String]()
            var amenities = [String]()
            
            for m in createStadiumViewModel.selectedSportTypes{
                sports.append(m.key)
            }
            for m in createStadiumViewModel.selectedAmenities{
                amenities.append(m.key)
            }
            let sportsStr = sports.joined(separator: ",")
            let amenityStr = amenities.joined(separator: ",")
//            var timeDictArray = [[String:Any]]()
//            for m in createStadiumViewModel.timings{
//                timeDictArray.append(m.getDictionary())
//            }
            let timeStr = createStadiumViewModel.timings.convertToString ?? ""
            let param:[String:Any] = ["name":txtStadiumNameEn.text!,
                                      "name_cn":txtStadiumNameCn.text!,
                                      "location_lat" :lat,
                                      "location_long":long,
                                      "address":address,
                                      "description":textViewAboutEn.text!,
                                      "description_cn":textViewAboutCn.text!,
                                      "available_sports":sportsStr,
                                      "amenities":amenityStr,
                                      "timings":timeStr,
                                      "imgs_urls":createStadiumViewModel.imagePaths]
            print(param)
            createStadiumViewModel.cretaeStadiumAsyncCall(parameters: param)
            
        }
        
    }
    
    
    @IBAction func tapChooseImage(_ sender: Any) {
        showNewImageActionSheet(sourceView: self.view)
    }
    
    func initialSettings(){
        nibInitialization()
        setupLocalisation()
        createStadiumViewModel.populateTimings()
        setupViewModels()


    }
    
    func setupViewModels(){
        
        createStadiumViewModel.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        createStadiumViewModel.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        createStadiumViewModel.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] response in
                //popup
                self?.stadiumSuccess()
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
                self?.createStadiumViewModel.imagePaths.append(response?.response?.data?.path ?? "")
            })
            .store(in: &cancellable)
    }
    
    func stadiumSuccess(){
        self.customAlertView(title: ErrorMessage.success.localized, description: "Stadium registered!", image: ImageConstants.successImage) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showLoader(_ value: Bool) {
         value ? startLoader() : stopLoader()
    }
    
    func setupLocalisation(){
        fixedLblCreateStadium.text = "Create A Stadium".localized
        fixedStadiumNamEn.text = "Stadium Name English".localized
        txtStadiumNameEn.placeholder = "Stadium Name English".localized
        fixedStadiumNamCn.text = "Stadium Name Chinese".localized
        txtStadiumNameCn.placeholder = "Stadium Name Chinese".localized
        fixedLblLocation.text = "Location".localized
        lblLocation.text = "Choose Location".localized
        fixedAboutStadiumEn.text = "About Stadium English".localized
        textViewAboutEn.placeholder = "About Stadium English".localized
        fixedAboutStadiumCn.text = "About Stadium Chinese".localized
        textViewAboutCn.placeholder = "About Stadium Chinese".localized
        fixedAdditionalInfo.text = "Additional Info".localized
        fixedChooseSports.text = "Choose Available Sports".localized
        fixedChooseAmenities.text = "Choose Available Amenities".localized
        fixedTimings.text = "Timings".localized
        btnCreateStadium.setTitle("Create Stadium".localized, for: .normal)
        fixedInfo.text = "Information".localized
        fixedLblMedia.text = "Media".localized
    }
    
  
    
    func nibInitialization() {
        defineTableViewNibCell(tableView: tableviewTimings, cellName: CellIdentifier.hoursTableViewCell)
        collectionViewAmenities.register(CellIdentifier.amenityCollectionViewCell)
        collectionViewSports.register(CellIdentifier.sportsCollectionViewCell)
        collectionViewImages.register(CellIdentifier.stadiumImageCollectionViewCell)
    }
    
    func validateFields()->Bool{
        if !isUserLoggedIn(){
            self.view.makeToast("Please login to continue".localized)
            return false
        }
        
        if !isUserStreetProfileUpdated(){
            self.view.makeToast("Please update player profile to continue".localized)
            return false
        }
        if images.count == 0{
            self.view.makeToast("Please choose at least one stadium image".localized)
            return false
        }
        if txtStadiumNameEn.text == ""{
            self.view.makeToast("Please enter Stadium Name English".localized)
            return false
        }
        if txtStadiumNameCn.text == ""{
            self.view.makeToast("Please enter Stadium Name Chinese".localized)
            return false
        }
        if lat == ""{
            self.view.makeToast("Please choose Stadium Location".localized)
            return false
        }
        
        if textViewAboutEn.text == ""{
            self.view.makeToast("Please enter About Stadium English".localized)
            return false
        }
        
        if textViewAboutCn.text == ""{
            self.view.makeToast("Please enter About Stadium Chinese".localized)
            return false
        }
        
        if createStadiumViewModel.selectedSportTypes.count == 0{
            self.view.makeToast("Please choose available sport types".localized)
            return false
        }
        if createStadiumViewModel.selectedAmenities.count == 0{
            self.view.makeToast("Please choose available amenities".localized)
            return false
        }
        if !createStadiumViewModel.checkEmptyTimings(){
            self.view.makeToast("Please fill stadium timings completely".localized)
            return false
        }
        return true
        
    }
    

}

//MARK: - ImagePicker Delegate
extension CreateStadiumVC: ImagePickerDelegate, UINavigationControllerDelegate {
    func pickerCanceled() { }
    
    func finishedPickingImage(image: UIImage, imageName: String) {
        self.images.append(image)
        self.collectionViewImages.reloadData()
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            StreetImageUploadViewModel.shared.uploadStreetImageAsyncCall(imageName: "img", imageData: imageData)
        }
    }
}

extension CreateStadiumVC:SetLocationDelegate{
    func sendChosenLocation(address: String, lat: String, long: String) {
        lblLocation.text = address
        self.lat = lat
        self.long = long
        self.address = address
        
    }
    
}



extension CreateStadiumVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewImages{
            return images.count
        }
        else if collectionView == collectionViewSports{
            return createStadiumViewModel.sportTypes.count
        }
        else{
            return createStadiumViewModel.amenities.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewImages{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.stadiumImageCollectionViewCell, for: indexPath) as! StadiumImageCollectionViewCell
            cell.callDelete = { [weak self] in
                self?.images.remove(at: indexPath.row)
                if indexPath.row < (self?.createStadiumViewModel.imagePaths.count ?? 0) {
                    self?.createStadiumViewModel.imagePaths.remove(at: indexPath.row)
                }
                collectionView.reloadData()
                
            }
            
            cell.imgPhoto.image = images[indexPath.row]
            return cell
        }
        else if collectionView == collectionViewSports{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SportsCollectionViewCell", for: indexPath) as! SportsCollectionViewCell
            cell.lblSport.text = createStadiumViewModel.sportTypes[indexPath.row].rawValue.localized
            cell.imgIcon.image = createStadiumViewModel.sportTypes[indexPath.row].image
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AmenityCollectionViewCell", for: indexPath) as! AmenityCollectionViewCell
            cell.lblTitle.text = createStadiumViewModel.amenities[indexPath.row].rawValue.localized
           return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        if collectionView == collectionViewSports{
            guard let cell1 = cell as? SportsCollectionViewCell else {return}
            if createStadiumViewModel.selectedSportTypes.contains(createStadiumViewModel.sportTypes[indexPath.row]){
                cell1.setupCell(selected: true, sport: createStadiumViewModel.sportTypes[indexPath.row])
            }
            else{
                cell1.setupCell(selected: false, sport: createStadiumViewModel.sportTypes[indexPath.row])
            }
        }
        else if collectionView == collectionViewAmenities{
            guard let cell1 = cell as? AmenityCollectionViewCell else {return}
            if createStadiumViewModel.selectedAmenities.contains(createStadiumViewModel.amenities[indexPath.row]){
                cell1.imgSelection.image = .filledTick
            }
            else{
                cell1.imgSelection.image = .tick
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewSports{
            if createStadiumViewModel.selectedSportTypes.contains(createStadiumViewModel.sportTypes[indexPath.row]){
                if let indx = createStadiumViewModel.selectedSportTypes.firstIndex(of: createStadiumViewModel.sportTypes[indexPath.row]){
                    createStadiumViewModel.selectedSportTypes.remove(at: indx)
                }
            }
            else{
                createStadiumViewModel.selectedSportTypes.append(createStadiumViewModel.sportTypes[indexPath.row])
            }
            collectionView.reloadData()
        }
        else if collectionView == collectionViewAmenities{
            if createStadiumViewModel.selectedAmenities.contains(createStadiumViewModel.amenities[indexPath.row]){
                if let indx = createStadiumViewModel.selectedAmenities.firstIndex(of: createStadiumViewModel.amenities[indexPath.row]){
                    createStadiumViewModel.selectedAmenities.remove(at: indx)
                }
            }
            else{
                createStadiumViewModel.selectedAmenities.append(createStadiumViewModel.amenities[indexPath.row])
            }
            collectionView.reloadData()
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                var w:CGFloat = 100
        var h:CGFloat = 100
        if collectionView == collectionViewAmenities{
            
            h = 30
            w = createStadiumViewModel.amenities[indexPath.row].rawValue.size(OfFont: UIFont(name: "Roboto-Regular", size: 10)!).width + 40
        }
        if collectionView == collectionViewSports{
            h = 35
            w = createStadiumViewModel.sportTypes[indexPath.row].rawValue.size(OfFont: UIFont(name: "Roboto-Medium", size: 12)!).width + 45
 
        }
        return CGSize(width: w, height: h)
    }
}


extension CreateStadiumVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return createStadiumViewModel.timings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.hoursTableViewCell) as! HoursTableViewCell
        cell.configureCell(obj: createStadiumViewModel.timings[indexPath.row])
        cell.passTime = { [weak self] time,isFrom in
            if isFrom{
                self?.createStadiumViewModel.timings[indexPath.row].from = time
            }
            else{
                self?.createStadiumViewModel.timings[indexPath.row].to = time
                
            }
        }
        
        cell.callDelete = { [weak self] in
            self?.createStadiumViewModel.timings[indexPath.row].from = ""
            self?.createStadiumViewModel.timings[indexPath.row].to = ""
        }
        return cell
    }
    
}
