

import Foundation


struct LocalTimings:Codable{
    var day:String?
    var from:String?
    var to:String?
    init(day:String,from:String,to:String) {
        self.day = day
        self.from = from
        self.to = to
    }
    
//    init(_ json: JSON) {
//        day = json["day"].stringValue
//        from = json["from"].stringValue
//        to = json["to"].stringValue
//    }
    
    func getDictionary()->[String:Any]{
        let dict:[String:Any] = ["day":day ?? "",
                                 "from":from ?? "",
                                 "to":to ?? ""]
        return dict
    }
   
}
