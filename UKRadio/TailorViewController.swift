//
//  TailorViewController.swift
//  UKRadio
//
//  Created by xuzepei on 2017/12/18.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

import UIKit

class TailorViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Test"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(clickedChooseButton(sender :)))
        
//        let image1 = UIImage(named: "IMG_3059.PNG")
//        let image2 = UIImage(named: "IMG_3061.JPG")
//        let newSize = CGSize(width: image1!.size.width, height: image1!.size.height + image2!.size.height)
//
//        UIGraphicsBeginImageContext(newSize)
//
//        image1?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: image1!.size.height))
//        image2?.draw(in: CGRect(x: 0, y: image1!.size.height, width: newSize.width, height: image2!.size.height))
//
//        let finalImage = UIGraphicsGetImageFromCurrentImageContext();
//
//        UIGraphicsEndImageContext()
//
//        imageView.contentMode = UIViewContentMode.scaleAspectFit
//
//        imageView.backgroundColor = UIColor.red
//        imageView.image = finalImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clickedChooseButton(sender: AnyObject?){
        
        NSLog("clickedChooseButton:\(sender!)")
        
        let pickVC = PickImageViewController(nibName: nil, bundle: nil)
        let temp = UINavigationController(rootViewController: pickVC)
        self .present(temp, animated: true, completion:nil)
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
