//
//  CustomNotchViewController.swift
//  UKRadio
//
//  Created by xuzepei on 2017/12/22.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

import UIKit

class CustomNotchViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var shouldHideStatusBar = true
    
    override var prefersStatusBarHidden: Bool {
        return shouldHideStatusBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true;

        // Do any additional setup after loading the view.
        
        let image = UIImage(named: "IMG_3059.PNG")!
        let mask = UIImage(named: "mask1.png")!
        
        let cgSourceImage = image.cgImage!
        let cgMaskImage = mask.cgImage!

        let imageMask = CGImage(maskWidth: cgMaskImage.width, height: cgMaskImage.height, bitsPerComponent: cgMaskImage.bitsPerComponent, bitsPerPixel: cgMaskImage.bitsPerPixel, bytesPerRow: cgMaskImage.bytesPerRow, provider: cgMaskImage.dataProvider!, decode: nil, shouldInterpolate: true)
        
        let cgMaskedImage = cgSourceImage.masking(imageMask!)
        
        let maskedImage = UIImage(cgImage: cgMaskedImage!)

        imageView.contentMode = UIViewContentMode.scaleAspectFill

        imageView.backgroundColor = UIColor.red
        
        
        
        //    // 并把它设置成为当前正在使用的context
        //    UIGraphicsBeginImageContext(size);
        //
        //    // 绘制改变大小的图片
        //    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        //
        //    // 从当前context中创建一个改变大小后的图片
        //    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        //
        //    // 使当前的context出堆栈
        //    UIGraphicsEndImageContext();
        //
        //    NSData* data2 = UIImagePNGRepresentation(scaledImage);
        //    if(data2)
        //    {
        //        return [data2 writeToFile:saveSmallImagePath atomically:YES];
        //    }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, 1)
        //UIColor.clear.set()
        //UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        maskedImage.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        let finalImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        imageView.image = finalImage
        
        if let finalImage = finalImage {
            
            let pngImage = UIImage(data: UIImagePNGRepresentation(finalImage)!)
            
            UIImageWriteToSavedPhotosAlbum(pngImage!, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        }

        //self.perform(#selector(saveImage(image:)), with: nil, afterDelay:3)
    }
    
    func saveImage(image: Any?) {
        
        let newImage = UIImage(contentsOfFile: NSTemporaryDirectory()+"temp.png")
        
        if let image = newImage {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
        

    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
