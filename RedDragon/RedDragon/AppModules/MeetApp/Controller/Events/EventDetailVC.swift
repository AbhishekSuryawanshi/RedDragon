//
//  EventDetailVC.swift
//  RedDragon
//
//  Created by iOS Dev on 30/11/2023.
//

import UIKit
import Combine

class EventDetailVC: UIViewController {
    @IBOutlet weak var joinEventBtn: UIButton!
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var eventCreateByUserLbl: UILabel!
    @IBOutlet weak var eventJoineesLbl: UILabel!
    @IBOutlet weak var eventDescLbl: UILabel!
    @IBOutlet weak var eventLocationLbl: UILabel!
    @IBOutlet weak var eventDateLbl: UILabel!
    @IBOutlet weak var eventTimeLbl: UILabel!
    @IBOutlet weak var eventPriceLbl: UILabel!
    @IBOutlet weak var descriptionTitleLbl: UILabel!
    @IBOutlet weak var sportsTitleLbl: UILabel!
    @IBOutlet weak var eventImgView: UIImageView!
    @IBOutlet weak var eventSportsLbl: UILabel!
    @IBOutlet weak var controllerHeaderTitleLbl: UILabel!
    @IBOutlet weak var eventCreatorImgView: UIImageView!
    private var eventDetailVM: MeetEventDetailViewModel?
    var selectedEventId = Int()
    var cancellable = Set<AnyCancellable>()
    var event: MeetEvent?
    var joinEventVM: MeetJoinEventViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performInitialSetup()
        performLanguageLocalisation()
    }
    
    // MARK: - Methods
    func performInitialSetup() {
        makeNetworkCall()
    }
    
    func  performLanguageLocalisation() {
        descriptionTitleLbl.text = "Description".localized
        sportsTitleLbl.text = "Sports:".localized
        joinEventBtn.setTitle("Join Event".localized, for: .normal)
        controllerHeaderTitleLbl.text = "Event Details".localized
    }
    
    func showLoader(_ value: Bool) {
        value ? startLoader() : stopLoader()
    }
    
    func makeNetworkCall() {
        eventDetailVM = MeetEventDetailViewModel()
        eventDetailVM?.fetchMeetEventDetailAsyncCall(eventID: selectedEventId)
        fetchEventDetailVM()
    }
    
    // MARK: - Button Actions
    @IBAction func joinEventBtnAction(_ sender: Any) {
        joinEventVM = MeetJoinEventViewModel()
        joinEventVM?.postJoinEventAsyncCall(eventID: selectedEventId)
        fetchJoinEventViewModelResponse()
    }
}

// MARK: - Network Related Response
extension EventDetailVC {
    ///fetch view model for event list
    func fetchEventDetailVM() {
        eventDetailVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        eventDetailVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        eventDetailVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] eventDetail in
                self?.execute_onEventDetailResponse(eventDetail!)
            })
            .store(in: &cancellable)
    }
    
    func execute_onEventDetailResponse(_ eventDetail: MeetEventDetailModel) {
        event = eventDetail.response?.data
        updateUI()
    }
    
    func updateUI() {
        let imgrUrl = event?.bannerImage?.image ?? ""
        self.eventImgView.setImage(imageStr: imgrUrl, placeholder: UIImage(named: "defaultEvent"))
        self.eventNameLbl.text = event?.name ?? ""
        self.eventDateLbl.text = event?.date?.formatDate(inputFormat: dateFormat.yyyyMMdd, outputFormat: dateFormat.ddMMyyyy) ?? ""
        self.eventTimeLbl.text = event?.time
        self.eventCreateByUserLbl.text = "by \(event?.creator?.name ?? "")"
        self.eventDescLbl.text = event?.description
        self.eventJoineesLbl.text = "\(event?.peopleJoinedCount ?? 0)" + "People joined".localized
        self.eventSportsLbl.text = event?.interest?.name ?? ""
        self.eventLocationLbl.text = event?.address
        let creatorImage = event?.creator?.profileImg ?? ""
        self.eventCreatorImgView.setImage(imageStr: creatorImage, placeholder: UIImage(named: "placeholderUser"))
        
        if event?.isPaid == 0 {
            self.eventPriceLbl.text = "Free".localized
        }else{
            self.eventPriceLbl.text = "Paid".localized+" $\(event?.price ?? 0.0)"
        }
        
        self.eventPriceLbl.text = event?.isPaid == 0 ? "Free".localized : "Paid".localized + " $\(event?.price ?? 0.0)"
        self.joinEventBtn.isHidden = event?.joined ?? false ? true : false
    }
    
    func fetchJoinEventViewModelResponse() {
        joinEventVM?.showError = { [weak self] error in
            self?.customAlertView(title: ErrorMessage.alert.localized, description: error, image: ImageConstants.alertImage)
        }
        joinEventVM?.displayLoader = { [weak self] value in
            self?.showLoader(value)
        }
        joinEventVM?.$responseData
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink(receiveValue: { [weak self] eventDetail in
                if eventDetail?.response?.code == 200 {
                    self?.view.makeToast(eventDetail?.response?.messages?.first ?? "")
                }
            })
          .store(in: &cancellable)
    }
}

