//
//  HealthKitPracticeViewController.swift
//  UKRadio
//
//  Created by xuzepei on 2017/10/27.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

import UIKit
import HealthKit

@available(iOS 8.0, *)
class HealthKitPracticeViewController: UIViewController {
    
    var healthStore: HKHealthStore = HKHealthStore()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "HealthKit"
        
        if #available(iOS 8.0, *) {
            if HKHealthStore.isHealthDataAvailable() == false {
                print("Opps, this device does not support HealthKit.")
                return
            }
        } else {
            print("Opps, this OS does not support HealthKit.")
        }
        
        let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        var readSet: Set<HKObjectType>? = Set<HKObjectType>()
        readSet?.insert(sampleType!)
        
        self.healthStore.requestAuthorization(toShare: nil, read: readSet) { (isSuccessful, error) in
            
            if isSuccessful == true {
            
                print("isSuccessful")
            }
            else {
                print("error:", error?.localizedDescription ?? "No description.");
            }
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
