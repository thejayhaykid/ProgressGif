//
//  ViewController.swift
//  ProgressGif
//
//  Created by Zheng on 7/10/20.
//

import UIKit
import Photos
import RealmSwift

class ViewController: UIViewController {
    
    let realm = try! Realm()
    var globalURL = URL(fileURLWithPath: "")
    var copyingFileToStorage = false
    
    
    // MARK: - Header
    @IBOutlet weak var visualEffectView: UIVisualEffectView! /// the top bar
    @IBOutlet weak var overlayColorView: UIView!
    @IBOutlet weak var overlayBlurView: UIVisualEffectView!
    @IBOutlet weak var topMarginC: NSLayoutConstraint!
    
    @IBOutlet weak var logoButton: UIButton!
    @IBAction func logoButtonPressed(_ sender: Any) {
        
    }
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBAction func settingsButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController {
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let statusHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        topMarginC.constant = statusHeight
        view.layoutIfNeeded()
        collectionViewController?.topInset = visualEffectView.frame.height
        collectionViewController?.updateTopInset()
    }
    
    // MARK: - Import From Files
    var documentPicker: DocumentPicker!
    
    // MARK: - Photos Collection View
    
    lazy var collectionViewController: CollectionViewController? = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "CollectionViewController") as? CollectionViewController {
            
            viewController.inset = CGFloat(4)
            viewController.topInset = visualEffectView.frame.height
            viewController.collectionType = .projects
            viewController.globalURL = self.globalURL
            self.add(childViewController: viewController, inView: view)
            
            return viewController
        } else {
            return nil
        }
        
    }()
    
    // MARK: - Add button
    
    var addButtonIsPressed = false
    @IBOutlet weak var addButton: CustomButton!
    @IBAction func addButtonTouchDown(_ sender: Any) {
        handleAddButtonTouchDown()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        handleAddButtonPress()
    }
    
    @IBAction func addButtonTouchUpOutside(_ sender: Any) {
        handleAddButtonTouchUpOutside()
    }

    // MARK: - Import options
    
    @IBOutlet weak var importVideoLabel: UILabel!
    @IBOutlet weak var importVideoBottomC: NSLayoutConstraint! /// 26
    let importVideoBottomCShownConstant = CGFloat(32)
    let importVideoBottomCHiddenConstant = CGFloat(26)
    
    @IBOutlet weak var filesButton: CustomButton!
    @IBOutlet weak var photosButton: CustomButton!
    @IBOutlet weak var clipboardButton: CustomButton!
    
    @IBAction func filesTouchDown(_ sender: Any) {
        filesButton.scaleDown()
    }
    
    @IBAction func filesPressed(_ sender: Any) {
        filesButton.scaleUp()
//        presentImportController()
        importFromFiles()
        handleAddButtonPress()
    }
    
    @IBAction func filesTouchUpOutside(_ sender: Any) {
        filesButton.scaleUp()
    }
    
    @IBAction func photosTouchDown(_ sender: Any) {
        photosButton.scaleDown()
    }
    
    @IBAction func photosPressed(_ sender: Any) {
        photosButton.scaleUp()
        importVideo()
        handleAddButtonPress()
    }
    
    @IBAction func photosTouchUpOutside(_ sender: Any) {
        photosButton.scaleUp()
    }
    
    @IBAction func clipboardTouchDown(_ sender: Any) {
        clipboardButton.scaleDown()
    }
    @IBAction func clipboardPressed(_ sender: Any) {
        clipboardButton.scaleUp()
        handleAddButtonPress()
    }
    @IBAction func clipboardTouchUpOutside(_ sender: Any) {
        clipboardButton.scaleUp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// make the import from files, import from photos, and import from clipboard buttons transparent
        setUpButtonAlpha()
        
        overlayBlurView.alpha = 0
        overlayColorView.alpha = 0
        
        guard let url = URL.createFolder(folderName: "ProgressGifStoredVideos") else {
            print("Can't create url")
            return
        }
        
        globalURL = url
        
        print("global url: \(url)")
        /// initialize the collection view
        _ = collectionViewController
        
        
        
        documentPicker = DocumentPicker(presentationController: self, delegate: self)
        
    }


}






