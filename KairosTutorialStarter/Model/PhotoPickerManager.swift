//
//  PhotoPickerManager.swift
//  KairosTutorialStarter
//

import UIKit
import MobileCoreServices
import Photos


enum CameraSourceType {
    case cameraSource
    case librarySource
}

protocol PhotoPickerManagerDelegate: class {
    func manager(_ manager: PhotoPickerManager, didPickImage image: UIImage)
}
class PhotoPickerManager: NSObject {
    
    private let imagePickerController = UIImagePickerController()
    private let presentingController: UIViewController
    weak var delegate: PhotoPickerManagerDelegate?
    private let imageManager = PHCachingImageManager()
    
    init(presentingController: UIViewController) {
        self.presentingController = presentingController
        super.init()
        configure()
    }
    
    /// dismissing picker
    func dismissPhotoPicker(animated: Bool, completion: (() -> Void)?) {
        imagePickerController.dismiss(animated: animated, completion: completion)
    }
    
    /// configure picker
    private func configure() {
        
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
            })
            return
        } else if status == .authorized {
            /// only camera photo no videos
            imagePickerController.mediaTypes = [kUTTypeImage as String]
            imagePickerController.delegate = self
        }
    }
    
    /// presenting picker from source type
    func presentPhotoPicker(from source: CameraSourceType, animated: Bool) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) && source == .cameraSource  {
            imagePickerController.sourceType = .camera
            imagePickerController.cameraDevice = .front
        } else {
            imagePickerController.sourceType = .savedPhotosAlbum
        }
        presentingController.present(imagePickerController, animated: animated, completion: nil)
    }
}
extension PhotoPickerManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.delegate?.manager(self, didPickImage: image)
        }
    }
}

















