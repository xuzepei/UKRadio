//
//  ZiXunTableViewCell.swift


import UIKit

class ZiXunTableViewCell: UITableViewCell {
    
    var item : [String : String]? = nil

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
    
    func updateContent(item: [String : String]?)
    {
        self.item = item
        
        if nil == self.item {
            return
        }
        
        self.titleLabel.text = self.item!["name"]
        self.dateLabel.text = self.item!["date"]
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = true
        self.titleLabel.numberOfLines = 0
        self.titleLabel.sizeToFit()
        var rect = self.titleLabel.frame;
        rect.size.width = self.bounds.size.width - 170
        self.titleLabel.frame = rect;
        
        self.zixunImageView.image = nil;
        
        if let imageUrl = self.item!["image_url"] {
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
