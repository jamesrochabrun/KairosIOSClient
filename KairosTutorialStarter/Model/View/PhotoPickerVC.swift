//
//  ViewController.swift
//  KairosTutorialStarter
//
//  Created by James Rochabrun on 3/2/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import UIKit
import Photos

private enum AnalyzedStatus {
    case analyzing
    case analyzed
    
    var textStatus: String {
        switch self {
        case .analyzing: return "Analyzing..."
        case .analyzed: return ""
        }
    }
}


class PhotoPickerVC: UIViewController {

    // MARK: UI
    @IBOutlet weak var thumbnailImageView: UIImageView! {
        didSet {
            thumbnailImageView.layer.borderColor = UIColor.white.cgColor
            thumbnailImageView.layer.borderWidth = 2.5
        }
    }
    @IBOutlet weak var photoImageView: UIImageView! {
        didSet {
            photoImageView.layer.borderColor = UIColor.white.cgColor
            photoImageView.layer.borderWidth = 2.5
            photoImageView.layer.cornerRadius = 15
        }
    }
    @IBOutlet weak var shotButton: UIButton!
    @IBOutlet weak var analyzedTextLabel: UILabel!
    
    
    // MARK: Picker
    lazy var photoPickerManager: PhotoPickerManager = {
        let manager = PhotoPickerManager(presentingController: self)
        manager.delegate = self
        return manager
    }()
    
    // MARK: App LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        thumbnailImageView.layer.cornerRadius = 10
        shotButton.layer.cornerRadius = shotButton.frame.size.width / 2
    }
    
    @IBAction func shotButtonTapped(_ sender: UIButton) {
        photoPickerManager.presentPhotoPicker(from: CameraSourceType.cameraSource, animated: true)
        setUIForResponse(.analyzing)
    }
    
    @IBAction func thumbnailTapped(_ sender: UITapGestureRecognizer) {
        photoPickerManager.presentPhotoPicker(from: CameraSourceType.librarySource, animated: true)
        setUIForResponse(.analyzing)
    }
    
    private func setUIForResponse(_ status: AnalyzedStatus) {
        self.analyzedTextLabel.text = status.textStatus
    }
}

// MARK: - camera and library picker
extension PhotoPickerVC: PhotoPickerManagerDelegate {
    
    func manager(_ manager: PhotoPickerManager, didPickImage image: UIImage, asset: PHAsset?) {
        photoImageView.image = image
        setUIForResponse(.analyzed)
        manager.dismissPhotoPicker(animated: true, completion: nil)
    }
}








