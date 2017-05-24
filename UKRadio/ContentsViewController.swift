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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Contents"
        
        loadContents();
        contentsTableView.reloadData()
        // Do any additional setup after loading the view.
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func requestFinished(dict: NSDictionary) {
        
        let jsonString = Tool.decrypt(dict.objectForKey("json") as! String)
        let result = Tool.parseToDictionary(jsonString)
        
        print("Fuction:\(#function), result:\(result)")
    }
 

}

extension ContentsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cellId = "ContentsCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
        
        if indexPath.row < contents.count {
            cell.textLabel?.text = contents[indexPath.row]
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.Blue
        cell.textLabel?.font = UIFont.systemFontOfSize(20)
        if indexPath.row & 1 == 0 {
            cell.backgroundColor = UIColor(red: 227/255.0, green: 227/255.0, blue: 227/255.0, alpha: 227/255.0)
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let urlString = "http://appdream.sinaapp.com/bbc/bbc_list.php?cate_id=6&page=1&isopenall=1"
        let request = HttpRequest()
        request.delegate = self
        request.get(urlString, resultSelector: #selector(ContentsViewController.requestFinished(_:)), token: nil)
    }
    

    
}
