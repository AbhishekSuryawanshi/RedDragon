//
//  UIView+Extension.swift
//  RedDragon
//
//  Created by Qasr01 on 24/11/2023.
//

import UIKit
class ClickListener: UITapGestureRecognizer {
    var onClick : (() -> Void)? = nil
}

extension UIView {
    /// To curve the sides of view
    /// add suitable corners in "corners" as [.topLeft, .topRight, .bottomLeft, .bottomRight, .allCorners]
    ///
    func setOnClickListener(action :@escaping () -> Void){
        let tapRecogniser = ClickListener(target: self, action: #selector(onViewClicked(sender:)))
        tapRecogniser.onClick = action
        self.addGestureRecognizer(tapRecogniser)
    }
    @objc func onViewClicked(sender: ClickListener) {
        if let onClick = sender.onClick {
            onClick()
        }
    }
    func callOnClick(){
        
    }

    func roundCornersWithBorderLayer(cornerRadii: CGFloat, corners: UIRectCorner, bound:CGRect, borderColor: UIColor = .clear, borderWidth: CGFloat = 0) {
        let maskPath = UIBezierPath(roundedRect: bound, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadii, height: cornerRadii))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        self.layer.mask = shape
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskPath.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
    }
    
    /// To add shadow for view
    func applyShadow(radius: CGFloat,
                     opacity: Float,
                     offset: CGSize = .zero,
                     color: UIColor = .lightGray) {
        layer.masksToBounds = false
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
    }
    
    public class func fromNib(nibName: String? = nil) -> Self {
        return fromNib(nibName: nibName, type: self)
    }

    public class func fromNib<T: UIView>(nibName: String? = nil, type: T.Type) -> T {
        return fromNib(nibName: nibName, type: T.self)!
    }

    public class func fromNib<T: UIView>(nibName: String? = nil, type: T.Type) -> T? {
        var view: T?
        let name: String

        if let nibName = nibName {
            name = nibName
        } else {
            name = self.nibName
        }

        if let nibViews = Bundle.main.loadNibNamed(name, owner: nil, options: nil) {
            for nibView in nibViews {
                if let tog = nibView as? T {
                    view = tog
                }
            }
        }

        return view
    }

    public class var nibName: String {
        return "\(self)".components(separatedBy: ".").first ?? ""
    }

    public class var nib: UINib? {
        if let _ = Bundle.main.path(forResource: nibName, ofType: "nib") {
            return UINib(nibName: nibName, bundle: nil)
        } else {
            return nil
        }
    }
    
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat = 0,
                height: CGFloat = 0) -> [NSLayoutConstraint] {
      translatesAutoresizingMaskIntoConstraints = false

      var anchors = [NSLayoutConstraint]()

      if let top = top {
        anchors.append(topAnchor.constraint(equalTo: top, constant: paddingTop))
      }
      if let left = left {
        anchors.append(leftAnchor.constraint(equalTo: left, constant: paddingLeft))
      }
      if let bottom = bottom {
        anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom))
      }
      if let right = right {
        anchors.append(rightAnchor.constraint(equalTo: right, constant: -paddingRight))
      }
      if width > 0 {
        anchors.append(widthAnchor.constraint(equalToConstant: width))
      }
      if height > 0 {
        anchors.append(heightAnchor.constraint(equalToConstant: height))
      }

      anchors.forEach { $0.isActive = true }

      return anchors
    }

    @discardableResult
    func anchorToSuperview() -> [NSLayoutConstraint] {
      return anchor(top: superview?.topAnchor,
                    left: superview?.leftAnchor,
                    bottom: superview?.bottomAnchor,
                    right: superview?.rightAnchor)
    }
    
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
}
