//
//  CreateStadiumVC.swift
//  RedDragon
//
//  Created by Remya on 12/1/23.
//

import UIKit
import IQKeyboardManagerSwift
import Toast

class CreateStadiumVC:UIViewController{
    @IBOutlet weak var collectionViewImages:UICollectionView!
    @IBOutlet weak var fixedStadiumNamEn:UILabel!
    @IBOutlet weak var fixedStadiumNamCn:UILabel!
    @IBOutlet weak var fixedLblLocation:UILabel!
    @IBOutlet weak var fixedLblChoose:UILabel!
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
    
    
    //Variables
    var images = [UIImage]()
   // var viewModel = CreateStadiumViewModel()
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
//        if validateFields(){
//            var sports = [String]()
//            var amenities = [String]()
//            
//            for m in viewModel.selectedSportTypes{
//                sports.append(m.key)
//            }
//            for m in viewModel.selectedAmenities{
//                amenities.append(m.key)
//            }
//            let sportsStr = sports.joined(separator: ",")
//            let amenityStr = amenities.joined(separator: ",")
//            var timeDictArray = [[String:Any]]()
//            for m in viewModel.timings{
//                timeDictArray.append(m.getDictionary())
//            }
//            let timeStr = Utility.getJson(obj: timeDictArray)
//            let param:[String:Any] = ["name":txtStadiumNameEn.text!,
//                                      "name_cn":txtStadiumNameCn.text!,
//                                      "location_lat" :lat,
//                                      "location_long":long,
//                                      "address":address,
//                                      "description":textViewAboutEn.text!,
//                                      "description_cn":textViewAboutCn.text!,
//                                      "available_sports":sportsStr,
//                                      "amenities":amenityStr,
//                                      "timings":timeStr,
//                                      "imgs_urls":viewModel.imagePaths]
//            print(param)
//            viewModel.createStadium(param: param)
//            
//        }
        
    }
    
    
    @IBAction func tapChooseImage(_ sender: Any) {
//        ImagePickerManager().pickImage(self) { image in
//            self.viewModel.uploadImage(image: image)
//            self.images.append(image)
//            self.collectionViewImages.reloadData()
//            self.collectionViewImages.isHidden = false
//        }
        
    }
    
    func initialSettings(){
//        setupLocalisation()
//        viewModel.populateTimings()
//        viewModel.callCreateStadiumCallBack = { [weak self] in
//            self?.navigationController?.popViewController(animated: true)
//            
//        }
//        registerCells()
//        setBackButton()
//        self.navigationItem.titleView = getHeaderLabel(title: "Create Stadium".localized)
    }
    
    func setupLocalisation(){
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
        fixedInfo.text = "Info".localized
        fixedLblChoose.text = "Choose your image files here".localized
    }
    
    func registerCells(){
//        collectionViewImages.registerCell(identifier: "ImageCollectionViewCell")
//        collectionViewSports.registerCell(identifier: "SportsCollectionViewCell")
//        collectionViewAmenities.registerCell(identifier: "AmenityCollectionViewCell")
//        tableviewTimings.register(UINib(nibName: "HoursTableViewCell", bundle: nil), forCellReuseIdentifier: "hoursTableViewCell")
    }
    
    func validateFields()->Bool{
//        if !Utility.isUserLoggedIn(){
//            self.view.makeToast("Please login first to continue".localized)
//            return false
//        }
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
        
//        if viewModel.selectedSportTypes.count == 0{
//            self.view.makeToast("Please choose available sport types".localized)
//            return false
//        }
//        if viewModel.selectedAmenities.count == 0{
//            self.view.makeToast("Please choose available amenities".localized)
//            return false
//        }
//        if !viewModel.checkEmptyTimings(){
//            self.view.makeToast("Please fill stadium timings completely".localized)
//            return false
//        }
        return true
        
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


//
//extension CreateStadiumVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == collectionViewImages{
//            return images.count
//        }
//        else if collectionView == collectionViewSports{
//            return viewModel.sportTypes.count
//        }
//        else{
//            return viewModel.amenities.count
//        }
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == collectionViewImages{
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
//            cell.callDelete = { [weak self] in
//                self?.images.remove(at: indexPath.row)
//                if indexPath.row < (self?.viewModel.imagePaths.count ?? 0) {
//                    self?.viewModel.imagePaths.remove(at: indexPath.row)
//                }
//                collectionView.reloadData()
//                if self?.images.count == 0{
//                    collectionView.isHidden = true
//                }
//            }
//            
//            cell.imgPhoto.image = images[indexPath.row]
//            return cell
//        }
//        else if collectionView == collectionViewSports{
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SportsCollectionViewCell", for: indexPath) as! SportsCollectionViewCell
//            cell.lblSport.text = viewModel.sportTypes[indexPath.row].rawValue.localized
//            cell.imgIcon.image = viewModel.sportTypes[indexPath.row].image
//            return cell
//        }
//        else{
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AmenityCollectionViewCell", for: indexPath) as! AmenityCollectionViewCell
//            cell.lblTitle.text = viewModel.amenities[indexPath.row].rawValue.localized
//           return cell
//        }
//    }
//    
//    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
//        if collectionView == collectionViewSports{
//            guard let cell1 = cell as? SportsCollectionViewCell else {return}
//            if viewModel.selectedSportTypes.contains(viewModel.sportTypes[indexPath.row]){
//                    cell1.backView.borderColor = Colors.accentColor()
//            }
//            else{
//                cell1.backView.borderColor = .white
//            }
//        }
//        else if collectionView == collectionViewAmenities{
//            guard let cell1 = cell as? AmenityCollectionViewCell else {return}
//            if viewModel.selectedAmenities.contains(viewModel.amenities[indexPath.row]){
//                cell1.imgSelection.image = UIImage(named: "tick1")
//            }
//            else{
//                cell1.imgSelection.image = UIImage(named: "checkbox")
//            }
//        }
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView == collectionViewSports{
//            if viewModel.selectedSportTypes.contains(viewModel.sportTypes[indexPath.row]){
//                if let indx = viewModel.selectedSportTypes.firstIndex(of: viewModel.sportTypes[indexPath.row]){
//                    viewModel.selectedSportTypes.remove(at: indx)
//                }
//            }
//            else{
//                viewModel.selectedSportTypes.append(viewModel.sportTypes[indexPath.row])
//            }
//            collectionView.reloadData()
//        }
//        else if collectionView == collectionViewAmenities{
//            if viewModel.selectedAmenities.contains(viewModel.amenities[indexPath.row]){
//                if let indx = viewModel.selectedAmenities.firstIndex(of: viewModel.amenities[indexPath.row]){
//                    viewModel.selectedAmenities.remove(at: indx)
//                }
//            }
//            else{
//                viewModel.selectedAmenities.append(viewModel.amenities[indexPath.row])
//            }
//            collectionView.reloadData()
//            
//        }
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        var w = 140
//        var h = 110
//        if collectionView == collectionViewAmenities{
//            h = 50
//            w = 160
//        }
//        if collectionView == collectionViewSports{
//            w = 100
//            h = 88
//        }
//        return CGSize(width: w, height: h)
//    }
//   
//}
//
//
//extension CreateStadiumVC:UITableViewDelegate,UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.timings.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "hoursTableViewCell") as! HoursTableViewCell
//        cell.configureCell(obj: viewModel.timings[indexPath.row])
//        cell.passTime = { [weak self] time,isFrom in
//            if isFrom{
//                self?.viewModel.timings[indexPath.row].from = time
//            }
//            else{
//                self?.viewModel.timings[indexPath.row].to = time
//                
//            }
//        }
//        
//        cell.callDelete = { [weak self] in
//            self?.viewModel.timings[indexPath.row].from = ""
//            self?.viewModel.timings[indexPath.row].to = ""
//        }
//        return cell
//    }
//    
//}
