//
//  EmbedVCHelper.swift
//  RedDragon
//
//  Created by Qasr01 on 31/10/2023.
//

import UIKit

/// To add a view controller in a container view programmatically
class ViewEmbedder {
    class func loadVC(
        parent:UIViewController,
        container:UIView,
        child:UIViewController,
        previous:UIViewController?){
            
            if let previous = previous {
                removeFromParent(vc: previous)
            }
            child.willMove(toParent: parent)
            parent.addChild(child)
            container.addSubview(child.view)
            child.didMove(toParent: parent)
            let w = container.frame.size.width;
            let h = container.frame.size.height;
            child.view.frame = CGRect(x: 0, y: 0, width: w, height: h)
        }
    
    class func removeFromParent(vc:UIViewController){
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
    
    /// Use this fuction to this functionality
    /// Pass storyboard Id, storyboard name, current view controller object / self , container view object
    
    class func embed(withIdentifier id:String, storyboard: UIStoryboard, parent:UIViewController, container:UIView, completion:((UIViewController)->Void)? = nil){
        
        let vc = storyboard.instantiateViewController(withIdentifier: id)
        loadVC(
            parent: parent,
            container: container,
            child: vc,
            previous: parent.children.first
        )
        completion?(vc)
    }
}


