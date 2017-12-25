//
//  CustomNotchViewController.swift
//  UKRadio
//
//  Created by xuzepei on 2017/12/22.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

import UIKit
import Photos
import GoogleMobileAds

fileprivate let BUTTON_WIDTH: CGFloat = 114
fileprivate let BUTTON_HEIGHT: CGFloat = 54
fileprivate let BUTTON_INTERVAL: CGFloat = 9
fileprivate let MAX_BG_INDEX: Int = 10
fileprivate let MAX_BUTTON_NUM: Int = 45

class CustomNotchViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var buttonGroup: UIStackView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectionView: UIScrollView!
    var pickedImage: UIImage? = nil
    var maskImage: UIImage? = nil
    var clickedPreviewButtonTimes: Int = 0
    var changeIndex: Int = 0
    
    var selectedMark: SelectedMark = SelectedMark(frame: CGRect(x: 0, y:0, width: BUTTON_WIDTH, height: BUTTON_HEIGHT))
    let previewBgView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    
    var shouldHideStatusBar = false
    
    override var prefersStatusBarHidden: Bool {
        return shouldHideStatusBar
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initBannerView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(requestBannerAd), name: NSNotification.Name(rawValue: "REFRESH_BANNER_AD_NOTIFICATION"), object: nil)
        
        self.navigationController?.isNavigationBarHidden = true;
        self.view.backgroundColor = UIColor.black
        imageView.contentMode = UIViewContentMode.scaleAspectFill
  
        let image = UIImage(named: "bg_0.jpg")!
        let mask = UIImage(named: "mask_0.png")!
        self.maskImage = mask
        
        if let newImage = self.resizeImage(originalImage: image) {
            
            self.pickedImage = newImage
            //加上遮罩
            if let finalImage = handleImage(originalImage: newImage, maskImage: self.maskImage!) {
                self.imageView.image = finalImage
            }
        }

        initSelectionView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initSelectionView() {
        
        //self.pageControl.backgroundColor = UIColor.clear
        
        self.selectionView.contentSize = CGSize(width: BUTTON_WIDTH * CGFloat(MAX_BUTTON_NUM) + BUTTON_INTERVAL * CGFloat(MAX_BUTTON_NUM + 1), height: self.selectionView.bounds.size.height)
        self.selectionView.isPagingEnabled = false
        self.selectionView.showsVerticalScrollIndicator = false
        self.selectionView.showsHorizontalScrollIndicator = true
        self.selectionView.scrollsToTop = false
        //self.selectionView.delegate = self
        self.selectionView.bouncesZoom = false
        self.selectionView.bounces = false
        
        for index in 0..<MAX_BUTTON_NUM {
            
            let button = ChooseButton(frame: CGRect(x: BUTTON_INTERVAL + CGFloat(index) * (BUTTON_WIDTH + BUTTON_INTERVAL), y: (self.selectionView.bounds.size.height - BUTTON_HEIGHT) * 0.5, width: BUTTON_WIDTH, height: BUTTON_HEIGHT))
            button.tag = index
            
            button.clickedEventCallback = { (button) in
                
                NSLog("clickedEventCallback:\(button.tag)")
                
                Tool.showInterstitial(vc: self)
                
                NSLog(NSStringFromCGRect(self.selectedMark.frame))
                self.selectedMark.removeFromSuperview()
                button.addSubview(self.selectedMark)
                
                if let maskImage = UIImage(named: "mask_\(button.tag).png") {
                    self.maskImage = maskImage
                    
                    if let finalImage = self.handleImage(originalImage: self.pickedImage!, maskImage: self.maskImage!) {
                        self.imageView.image = finalImage
                        
                        Tool.showParticleEffect()
                    }
                }
                
            }
            
            self.selectionView.addSubview(button)
        }
    }
    
    func authorizeToAlbum(completion:@escaping (Bool)->Void) {
        
        if PHPhotoLibrary.authorizationStatus() != .authorized {
            NSLog("Will request authorization")
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    DispatchQueue.main.async(execute: {
                        completion(true)
                    })
                } else {
                    DispatchQueue.main.async(execute: {
                        completion(false)
                    })
                }
            })
            
        } else {
            DispatchQueue.main.async(execute: {
                completion(true)
            })
        }
    }
    
    func goToSettings() {
        
        let title = NSLocalizedString("Tip", comment: "")
        let message = NSLocalizedString("This app requires permission to access Photos, please kindly set in Settings (Settings -> Notch Free -> Photos)", comment: "")
        let noButton = NSLocalizedString("Cancel", comment: "")
        let yesButton = NSLocalizedString("OK", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: noButton, style: .default) { (action:UIAlertAction) in
            NSLog("You've pressed noButton");
        }
        
        let action2 = UIAlertAction(title: yesButton, style: .default) { (action:UIAlertAction) in
            
            if let settingsURL = URL(string: UIApplicationOpenSettingsURLString + Bundle.main.bundleIdentifier!) as URL? {
                UIApplication.shared.openURL(settingsURL)
            }
        }
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        
        if let temp = UIApplication.shared.delegate!.window as? UIWindow {
            temp.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func handleImage(originalImage: UIImage, maskImage: UIImage) -> UIImage? {
        
        let cgSourceImage = originalImage.cgImage!
        let cgMaskImage = maskImage.cgImage!
        
        let imageMask = CGImage(maskWidth: cgMaskImage.width, height: cgMaskImage.height, bitsPerComponent: cgMaskImage.bitsPerComponent, bitsPerPixel: cgMaskImage.bitsPerPixel, bytesPerRow: cgMaskImage.bytesPerRow, provider: cgMaskImage.dataProvider!, decode: nil, shouldInterpolate: true)
        
        let cgMaskedImage = cgSourceImage.masking(imageMask!)
        
        let maskedImage = UIImage(cgImage: cgMaskedImage!)
        
        UIGraphicsBeginImageContextWithOptions(originalImage.size, false, 1)
        UIColor.clear.set()
        maskedImage.draw(in: CGRect(x: 0, y: 0, width: maskedImage.size.width, height: maskedImage.size.height))
        let finalImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        
        return finalImage
    }
    
    //MARK: - Change
    
    @IBAction func clickedChangeButton(_ sender: Any) {
        
        Tool.showInterstitial(vc: self)
        
        self.changeIndex += 1
        
        if(self.changeIndex > MAX_BG_INDEX) {
            self.changeIndex = 0
        }
        
        if let image = UIImage(named:"bg_\(self.changeIndex).jpg") {
            if let newImage = self.resizeImage(originalImage: image) {
                
                self.pickedImage = newImage
                //加上遮罩
                if let finalImage = handleImage(originalImage: newImage, maskImage: self.maskImage!) {
                    self.imageView.image = finalImage
                    
                    Tool.showParticleEffect()
                }
            }
        }
    }
    
    //MARK: - Album
    
    @IBAction func clickedAlbumButton(_ sender: Any) {
        
        self.authorizeToAlbum { (authorized) in
            if authorized == true {
                
                Tool.showInterstitial(vc: self)
                
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                picker.sourceType = .photoLibrary
                
                self.present(picker, animated: true, completion: nil)
            } else {
                self.goToSettings()
            }
        }
    }
    
    func resizeImage(originalImage: UIImage) -> UIImage? {
        
        var screenSize = UIScreen.main.bounds.size
        screenSize.width *= UIScreen.main.scale
        screenSize.height *= UIScreen.main.scale
        
        //根据屏幕高度，按比例计算出合适的图片宽度，并生成图片
        let tempImageWidth = screenSize.height * originalImage.size.width / originalImage.size.height
        UIGraphicsBeginImageContextWithOptions(CGSize(width: tempImageWidth, height: screenSize.height), false, 0.0);
        originalImage.draw(in: CGRect(x: 0, y: 0, width: tempImageWidth, height: screenSize.height))
        //            let clippedRect = CGRect(x: (tempImageWidth - screenSize.width) * 0.5, y: 0, width: screenSize.width, height: screenSize.height)
        //            UIGraphicsGetCurrentContext()?.clip(to: clippedRect)
        let tempImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        if let tempImage = tempImage {
            
            //根据屏幕大小，裁剪图片
            let newImageX = (tempImage.size.width - screenSize.width) * 0.5
            let tempImage2 = tempImage.crop(rect: CGRect(x: newImageX, y: 0, width: screenSize.width, height: tempImage.size.height))
            
            //生成图片
            UIGraphicsBeginImageContextWithOptions(screenSize, false, 1)
            tempImage2.draw(in: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
            let newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext()
            
            return newImage
        }
        
        return nil
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            if let newImage = self.resizeImage(originalImage: pickedImage) {

                self.pickedImage = newImage
                //加上遮罩
                if let finalImage = handleImage(originalImage: newImage, maskImage: self.maskImage!) {
                    self.imageView.image = finalImage
                    
                    Tool.showParticleEffect()
                }
            }
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Preview
    @IBAction func clickedPreviewButton(_ sender: Any) {
        
        self.clickedPreviewButtonTimes += 1
        
        let index = self.clickedPreviewButtonTimes % 3
        switch index {
        case 0: do {
            
            self.previewBgView.removeFromSuperview()
            self.selectionView.isHidden = false
            self.lineView.isHidden = false
            self.bannerView.isHidden = false
            }
        case 1: do {
            
            self.previewBgView.backgroundColor = UIColor(patternImage: UIImage(named: "preview_bg_1.png")!)
            self.view .addSubview(self.previewBgView)
            self.selectionView.isHidden = true
            self.lineView.isHidden = true
            self.bannerView.isHidden = true
            self.view .bringSubview(toFront: self.buttonGroup)
            }
        case 2: do {
            
            self.previewBgView.backgroundColor = UIColor(patternImage: UIImage(named: "preview_bg_2.png")!)
            self.view .addSubview(self.previewBgView)
            self.selectionView.isHidden = true
            self.lineView.isHidden = true
            self.bannerView.isHidden = true
            self.view .bringSubview(toFront: self.buttonGroup)
            }
        default:do {
            
            }
        }
        
    }
    
    //MARK: - Save
    @IBAction func clickedSaveButton(_ sender: Any) {
        
        self.authorizeToAlbum { (authorized) in
            if authorized == true {
                
                if let finalImage = self.imageView.image {
                    
                    if let pngImage = UIImage(data: UIImagePNGRepresentation(finalImage)!) {
                        UIImageWriteToSavedPhotosAlbum(pngImage, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
                    }
                    
                }
            } else {
                self.goToSettings()
            }
        }
        
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            
            Tool.showInterstitial(vc: self, immediately: true)
            
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    //MARK: - AD
    
    func initBannerView() {
        
        bannerView.adSize = kGADAdSizeSmartBannerPortrait
        bannerView.adUnitID = GlobalDefinitions.BANNER_ID
        bannerView.rootViewController = self
        
        requestBannerAd()
    }
    
    func requestBannerAd() {
        
        NSLog("$$$Banner: requestBannerAd")
        bannerView.load(GADRequest())
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension CustomNotchViewController: GADBannerViewDelegate {
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        NSLog("$$$Banner: adViewDidReceiveAd")

    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        NSLog("$$$Banner: didFailToReceiveAdWithError: \(error.localizedDescription)")
        
        self.perform(#selector(CustomNotchViewController.requestBannerAd), with: nil, afterDelay: 5)
    }
    
}

extension UIImage {
    func crop( rect: CGRect) -> UIImage {
        var rect = rect
        rect.origin.x*=self.scale
        rect.origin.y*=self.scale
        rect.size.width*=self.scale
        rect.size.height*=self.scale
        
        let imageRef = self.cgImage!.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
}
