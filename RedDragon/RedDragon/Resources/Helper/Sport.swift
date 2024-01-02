//
//  Sport.swift
//  RedDragon
//
//  Created by Qoo on 15/11/2023.
//

import Foundation
import UIKit


public enum Sports: String, CaseIterable {
    case football = "Football"
    case basketball = "Basketball"
    case tennis = "Tennis"
    case handball = "Handball"
    case hockey = "Hockey"
    case volleyball = "Volleyball"
    
    var image: UIImage? {
        switch self {
        case .football:
            return UIImage(named: "football")!
        case .basketball:
            return UIImage(named: "basketball")!
        case .tennis:
            return UIImage(named: "tennis")!
        case .handball:
            return UIImage(named: "handball")!
        case .hockey:
            return UIImage(named: "hockey")!
        case .volleyball:
            return UIImage(named: "volleyball")!
        }
    }
    
    var title: String {
        switch self {
        case .football:
            return "Football"
        case .basketball:
            return "Basketball"
        case .tennis:
            return "Tennis"
        case .handball:
            return "Handball"
        case .hockey:
            return "Hockey"
        case .volleyball:
            return "Volleyball"
        }
    }
}

public enum BetsTitleCollectionView : String{
    
    case All = "All"
    case Live = "Live"
    case Win = "Win"
    case Lose = "Lose"
    
    var title : String{
        switch self {
        case .All:
            return "UpComing".localized
        case .Live:
            return "Live".localized
        case .Win:
            return "Win".localized
        case .Lose:
            return "Lose".localized
        }
    }
}
