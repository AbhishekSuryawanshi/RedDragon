//
//  ImagePickerHelper.swift
//  RedDragon
//
//  Created by Qasr01 on 31/10/2023.
//

import UIKit
import AVFoundation
import Photos
import TOCropViewController

@objc protocol ImagePickerDelegate {
    func finishedPickingImage(image: UIImage, imageName: String)
    func pickerCanceled()
    @objc optional func finishedPickingVideo(videoUrl: NSURL)
}

let imagePicker = UIImagePickerController()

class ImagePicker: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate, TOCropViewControllerDelegate {
    
    var viewController: UIViewController!
    var newMedia: Bool!
    var delegate: ImagePickerDelegate!
    var me: ImagePicker!
    var imagePicked: UIImage?
    var imageName = ""
    var imageURL: URL? = nil
    
    init(viewController:UIViewController) {
        self.viewController = viewController
        super.init()
        me = self
    }
    
    func presentImagePickerController(with sourceType: UIImagePickerController.SourceType = .camera) {
        DispatchQueue.main.async {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = sourceType
            imagePickerController.modalPresentationStyle = .fullScreen
            self.viewController.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func checkCameraAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            presentImagePickerController()
        default:
            AVCaptureDevice.requestAccess(for: .video) { (grantStatus) in
                if grantStatus {
                    self.presentImagePickerController()
                } else {
                    DispatchQueue.main.async {
                        self.viewController.appPermissionAlert(type: "Camera")
                    }
                }
            }
        }
    }
    
    func checkLibraryAuthorization(with sourceType: UIImagePickerController.SourceType = .photoLibrary) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            self.presentImagePickerController(with: sourceType)
        default:
            PHPhotoLibrary.requestAuthorization { (grantStatus) in
                if grantStatus == .authorized {
                    self.presentImagePickerController(with: sourceType)
                } else {
                    DispatchQueue.main.async {
                        self.viewController.appPermissionAlert(type: "Photo Library")
                    }
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imageURL = info[.imageURL] as? URL
        picker.dismiss(animated: true, completion: nil)
        imagePicked = info[UIImagePickerController.InfoKey.originalImage]
        as? UIImage
        let imageURL = info[.imageURL] as? URL
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let dateString = formatter.string(from: Date())
        
        imageName = imageURL?.lastPathComponent ?? "678"
        imageName = imageName.replacingOccurrences(of: ".jpeg", with: "")
        imageName = imageName.replacingOccurrences(of: ".jpg", with: "")
        imageName = imageName.replacingOccurrences(of: ".png", with: "")
        if imageName == "" {
            imageName = "image_"
        }
        imageName = imageName + "\(dateString).png"
        let cropViewController = TOCropViewController(image: info[.originalImage] as! UIImage)
        cropViewController.delegate = self
        cropViewController.customAspectRatio = CGSize(width: 250, height: 320)
        cropViewController.aspectRatioLockEnabled = true
        cropViewController.resetAspectRatioEnabled = false
        let navController = UINavigationController(rootViewController: cropViewController)
        navController.modalPresentationStyle = .fullScreen
        self.viewController.present(navController, animated: true, completion: nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafeRawPointer) {
        if error != nil {
            let alert = UIAlertController(title: "Save Failed".localized,
                                          message: "Failed to save image".localized,
                                          preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "OK".localized,
                                             style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        delegate.pickerCanceled()
        self.viewController.dismiss(animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        delegate.finishedPickingImage(image: image, imageName: imageName)
        cropViewController.dismiss(animated: true, completion: nil)
    }
}

extension UIImage {
    class func scaleImageWithDivisor(img: UIImage, divisor: CGFloat) -> UIImage {
        let size = CGSize(width: img.size.width/divisor, height: img.size.height/divisor)
        UIGraphicsBeginImageContext(size)
        img.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
}
