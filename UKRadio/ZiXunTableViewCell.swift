//
//  ZiXunTableViewCell.swift


import UIKit

class ZiXunTableViewCell: UITableViewCell {
    
    var item : [String : Any]? = nil
    
    @IBOutlet weak var zixunImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateContent(item: [String : Any]?)
    {
        self.item = item
        
        if nil == self.item {
            return
        }
        
        self.titleLabel.text = self.item!["title"] as? String
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = true
        self.titleLabel.numberOfLines = 0
        self.titleLabel.sizeToFit()
        var rect = self.titleLabel.frame;
        rect.size.width = self.bounds.size.width - 170
        self.titleLabel.frame = rect;
        
        
        if let date = self.item!["cTime"] as? String {
            if date.characters.count > 9 {
                
                let index = date.index(date.startIndex, offsetBy: 10)
                var shortdate = date.substring(to: index)
                
                if let viewCount = self.item!["viewCount"] as? NSNumber{
                    shortdate.append("      浏览次数：\(viewCount.int16Value)")
                }
                
                self.dateLabel.text = shortdate
            }
        }
        
        self.zixunImageView.image = nil;
        
        if let imageUrl = self.item!["imgUrl"] as? String{
            if let image = Tool.getImageFromLocal(imageUrl) {
                self.zixunImageView.image = image
            } else {
                
                ImageLoader.sharedInstance.downloadImage(imageUrl, token: nil, result: { (url:String?, token: NSDictionary?, error: Error?) in
                    
                    if nil == error {
                        self.zixunImageView.image = Tool.getImageFromLocal(imageUrl)
                    }
                })
            }
        }
        
    }
}
