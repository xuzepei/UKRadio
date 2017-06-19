//
//  ContentsViewController.swift
//  UKRadio
//
//  Created by xuzepei on 17/4/26.
//  Copyright © 2017年 xuzepei. All rights reserved.
//

import UIKit

class ContentsViewController: UIViewController {
    
    var contents = [String]();
    @IBOutlet weak var contentsTableView: UITableView!
    var indicator: MBProgressHUD? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Contents"
        
        loadContents()
        contentsTableView.reloadData()
        // Do any additional setup after loading the view.
        
        updateContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadContents() {
    
        contents.append("123")
        contents.append("456")
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "go_to_second" {
        
            segue.destination.title = "Test infinite scroll ad view"
        }
        
        print("\(#function)")
    }
    
    func updateContent() {
    
        let urlString = "http://appdream.sinaapp.com/bbc/bbc_list.php?cate_id=6&page=1&isopenall=1"
        let request = HttpRequest()
        request.delegate = self
        let b = request.get(urlString, resultSelector: #selector(ContentsViewController.requestFinished(_:)), token: nil)
        if b == true {
           self.indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
           self.indicator!.labelText = "Loading..."
        }
    
    }
 
    func requestFinished(_ dict: NSDictionary) {
        
        if let indicator = self.indicator {
            indicator.hide(false)
        }
        
        let jsonString = Tool.decrypt(dict.object(forKey: "json") as! String)
        let result = Tool.parseToDictionary(jsonString)

        print("Fuction:\(#function), result:\(String(describing: result))")
    }
    
    func getItemByIndex(_ index: Int) -> AnyObject? {
        
        if index >= 0  && index < self.contents.count {
        
            return self.contents[index] as AnyObject
        }
    
        return nil
    }

}

extension ContentsViewController: UITableViewDataSource, UITableViewDelegate {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cellId = "ContentsCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator;
        
        if indexPath.row < contents.count {
            cell.textLabel?.text = contents[indexPath.row]
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.blue
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        if indexPath.row & 1 == 0 {
            cell.backgroundColor = UIColor(red: 227/255.0, green: 227/255.0, blue: 227/255.0, alpha: 227/255.0)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let item = self.getItemByIndex(indexPath.row) as? String {
        
            let controller = InfiniteScrollAdViewTestViewController(nibName: nil, bundle: nil)
            controller.hidesBottomBarWhenPushed = true
            controller.title = item
            self.navigationController!.pushViewController(controller, animated: true)
        
        }
        
        //self .performSegueWithIdentifier("go_to_second", sender: nil)
        
    }
}
