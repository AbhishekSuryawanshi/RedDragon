//
//  StadiumDetailsVC.swift
//  RedDragon
//
//  Created by Remya on 11/29/23.
//

import UIKit

enum SportTypes:String{
    
    case Football = "Football"
    case Basketball = "Basketball"
    case Tennis = "Tennis"
    case Cricket = "Cricket"
    
    var key:String{
        return self.rawValue.capitalized
    }
    
    var image:UIImage?{
        switch self{
        case .Football:
            return UIImage(named: "street_football")
        case .Basketball:
            return UIImage(named: "street_basketball")
        case .Tennis:
            return UIImage(named: "street_tennis")
        case .Cricket:
            return UIImage(named: "street_cricket")
        }
    }
}
enum Amenities:String{
    case Parking = "Parking"
    case Restrooms = "Rest Rooms"
    case Drinks = "Drinks"
    
    var key:String{
        return self.rawValue.capitalized
        
    }
}


class StadiumDetailsVC: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionViewImages: UICollectionView!
    @IBOutlet weak var lblLocation:UILabel!
    @IBOutlet weak var lblStadiumName:UILabel!
    @IBOutlet weak var collectionViewSports:UICollectionView!
    @IBOutlet weak var collectionViewAmenities:UICollectionView!
    @IBOutlet weak var tableViewTimings:UITableView!
    @IBOutlet weak var lblOwnerName:UILabel!
    @IBOutlet weak var lblOwnerPhone:UILabel!
    @IBOutlet weak var lblDescription:UILabel!
    @IBOutlet weak var lblAddress:UILabel!
    @IBOutlet weak var fixedOwnerName:UILabel!
    @IBOutlet weak var fixedPhone:UILabel!
    @IBOutlet weak var fixedAddress:UILabel!
    @IBOutlet weak var fixedSports:UILabel!
    @IBOutlet weak var fixedAmenities:UILabel!
    @IBOutlet weak var fixedTimings:UILabel!
    @IBOutlet weak var fixedContactDetails:UILabel!
    @IBOutlet weak var tableHeight:NSLayoutConstraint!
    @IBOutlet weak var sportsView:UIView!
    @IBOutlet weak var amenitiesView:UIView!
    @IBOutlet weak var timingsStack:UIStackView!
    
    //Variables
    
    var stadium:Stadium?
    var sports = [SportTypes]()
    var selectedAmenities = [Amenities]()
    var timings = [LocalTimings]()
    var tableViewObserver: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetups()
    }
    
    func initialSetups(){
        nibInitialization()
        fillDetails()
        tableViewObserver = tableViewTimings.observe(\.contentSize, options: .new) { (_, change) in
                    guard let height = change.newValue?.height else { return }
                    self.tableHeight.constant = height
                }
    }
    
    
    func nibInitialization() {
        defineTableViewNibCell(tableView: tableViewTimings, cellName: CellIdentifier.timingsTableViewCell)
        collectionViewAmenities.register(CellIdentifier.amenityCollectionViewCell)
        collectionViewSports.register(CellIdentifier.sportsCollectionViewCell)
        collectionViewImages.register(CellIdentifier.imageSliderCollectionViewCell)
    }
    
    func fillDetails(){
       
        lblLocation.text = stadium?.address
        lblStadiumName.text = stadium?.name
        lblDescription.text = stadium?.description
//        if Utility.getCurrentLang() == "zh-Hans"{
//            lblStadiumName.text = stadium?.nameCn
//            lblDescription.text = stadium?.descriptionCn
//        }
        lblOwnerName.text = (stadium?.owner.firstName ?? "") + " " + (stadium?.owner.lastName ?? "")
        lblOwnerPhone.text = stadium?.owner.phoneNumber ?? ""
        lblAddress.text = stadium?.owner.address
        let sportsArr:[String] = stadium?.availableSports.components(separatedBy: ",") ?? []
        let amenities:[String] = stadium?.amenities.components(separatedBy: ",") ?? []
        for m in sportsArr {
            if m == SportTypes.Football.key{
                sports.append(.Football)
            }
            else if m == SportTypes.Basketball.key{
                sports.append(.Basketball)
            }
            else if m == SportTypes.Tennis.key{
                sports.append(.Tennis)
            }
            else if m == SportTypes.Cricket.key{
                sports.append(.Cricket)
            }
        }
        
        for m in amenities {
            if m == Amenities.Parking.key{
                selectedAmenities.append(.Parking)
            }
            else if m == Amenities.Restrooms.key{
                selectedAmenities.append(.Restrooms)
            }
            else if m == Amenities.Drinks.key{
                selectedAmenities.append(.Drinks)
            }
        }
        
        let timeStr = stadium?.timings ?? ""
        do{
            let data: Data = timeStr.data(using: .utf8)!
            
            timings = try JSONDecoder().decode([LocalTimings].self, from: data)
        }
        catch{
            
        }
        collectionViewSports.reloadData()
        collectionViewAmenities.reloadData()
        pageControl.numberOfPages = stadium?.imgsUrls.count ?? 0
        collectionViewImages.reloadData()
        tableViewTimings.reloadData()
        
        if sports.count == 0{
            sportsView.isHidden = true
        }
        
        if amenities.count == 0{
            amenitiesView.isHidden = true
        }
        
        if timings.count == 0{
            timingsStack.isHidden = true
        }
    }

}

extension StadiumDetailsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewImages{
            return stadium?.imgsUrls.count ?? 0
        }
        else if collectionView == collectionViewSports{
            return sports.count
        }
        else{
            return selectedAmenities.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewImages{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.imageSliderCollectionViewCell, for: indexPath) as! ImageSliderCollectionViewCell
            cell.imageView.setImage(imageStr:stadium?.imgsUrls[indexPath.row] ?? "" ,placeholder: .placeholder1)
            cell.callLeft = {
                let toIndex = indexPath.row+1
                if toIndex < (self.stadium?.imgsUrls.count ?? 0){
                    collectionView.scrollToItem(at: IndexPath(row: toIndex, section: 0), at: .right, animated: false)
                }
                
                
            }
            cell.callRight = {
                if indexPath.row > 0{
                    collectionView.scrollToItem(at: IndexPath(row: indexPath.row-1, section: 0), at: .left, animated: false)
                }
                
            }
            cell.configureCell()
            return cell
            
        }
        else if collectionView == collectionViewSports{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.sportsCollectionViewCell, for: indexPath) as! SportsCollectionViewCell
            cell.lblSport.text = sports[indexPath.row].rawValue.localized
            cell.imgIcon.image = sports[indexPath.row].image
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.amenityCollectionViewCell, for: indexPath) as! AmenityCollectionViewCell
            cell.lblTitle.text = selectedAmenities[indexPath.row].rawValue.localized
            cell.imgSelection.image = UIImage(named: "tick")
           return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == collectionViewImages{
            pageControl.currentPage = indexPath.row
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var w:CGFloat = 140
        var h:CGFloat = 110
        if collectionView == collectionViewImages{
            h = 170
            w = (UIScreen.main.bounds.width - 20)
            
        }
        else if collectionView == collectionViewAmenities{
            h = 30
            w = selectedAmenities[indexPath.row].rawValue.size(OfFont: UIFont(name: "Roboto-Regular", size: 10)!).width + 40

            
        }
       else if collectionView == collectionViewSports{
        w = sports[indexPath.row].rawValue.size(OfFont: UIFont(name: "Roboto-Medium", size: 12)!).width + 45

        h = 35
        }
        return CGSize(width: w, height: h)
    }
    
}


extension StadiumDetailsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.timingsTableViewCell) as! TimingsTableViewCell
        cell.configureCell(obj: timings[indexPath.row])
        return cell
    }
    
}
