//
//  InfiniteAdScrollView.swift


import UIKit

@objc protocol AdViewProtocol {
    
    optional func clickedAd(token: AnyObject)
}

class AdView: UIView, AdViewProtocol {
    
    var item: NSDictionary? = nil
    var imageUrl: String? = nil
    var image: UIImage? = nil
    weak var delegate: AnyObject? = nil
    
    deinit {
    
        self.delegate = nil
    
    }

    func updateContent(item: AnyObject?) {
    
        self.item = item as? NSDictionary
        self.image = nil
        
        if self.item != nil {
        
            self.imageUrl = self.item!.objectForKey("picurl") as? String
            
            if let imageUrl = self.imageUrl {
            
                if let image = Tool.getImageFromLocal(imageUrl) {
                    
                    self.image = image
                    
                }
                else {
                    
                    ImageLoader.sharedInstance.downloadImage(imageUrl, token: nil, result: { (url: String?, token:
                        NSDictionary?, error: NSError?) in
                        
                        if imageUrl == url && error == nil {
                        
                            self.image = Tool.getImageFromLocal(imageUrl)
                        }
                        
                    })
                    
                }
            }

        }
    
        self.setNeedsDisplay()
        
    }
    
    override func drawRect(rect: CGRect) {
        
        super.drawRect(rect)
        
        if let image = self.image {
        
            image.drawInRect(self.bounds)
        
        }
    }

}

class InfiniteAdScrollView: UIView, UIScrollViewDelegate {
    
    let AD_WIDTH: CGFloat
    let AD_HEIGHT: CGFloat
    let animationDuration = 0.5
    var itemArray = NSMutableArray()
    var adViews = [AdView]()
    var scrollView: UIScrollView
    var pageControl: UIPageControl
    var timer: NSTimer?
    
    deinit {
    
        if self.timer != nil {
        
            self.timer?.invalidate()
            self.timer = nil
        }
    
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        
        AD_WIDTH = frame.size.width
        AD_HEIGHT = frame.size.height
        self.scrollView = UIScrollView(frame: CGRectMake(0, 0, AD_WIDTH, AD_HEIGHT))
        self.pageControl = UIPageControl(frame: CGRectMake(0, AD_HEIGHT - 16, AD_WIDTH, 16))
        self.pageControl.backgroundColor = UIColor.clearColor()
        super.init(frame: frame)
        
        self.scrollView.contentSize = CGSizeMake(AD_WIDTH * 3, AD_HEIGHT)
        self.scrollView.contentOffset = CGPointMake(AD_WIDTH, 0)
        self.scrollView.pagingEnabled = true
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.scrollsToTop = false
        self.scrollView.delegate = self
        self.scrollView.bouncesZoom = false
        self.scrollView.bounces = false
        self.addSubview(self.scrollView)
        
        self.backgroundColor = UIColor.grayColor()
        
        for i in 0..<3 {
        
            let adView = AdView(frame: CGRectMake(AD_WIDTH * CGFloat(i), 0, AD_WIDTH, AD_HEIGHT))
            //adView.delegate = self
            self.adViews.append(adView)
        
        }
        
        self.adViews[0].backgroundColor = UIColor.redColor()
        self.adViews[1].backgroundColor = UIColor.greenColor()
        self.adViews[2].backgroundColor = UIColor.blueColor()

        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(6, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        
    }
    
    func timerAction(timer: NSTimer) {
    
        if self.pageControl.currentPage + 1 < self.itemArray.count {
        
            self.pageControl.currentPage = self.pageControl.currentPage + 1
        
        }else {
        
            self.pageControl.currentPage = 0
            
        }
        
        self.goToIndex(self.pageControl.currentPage)
        
    }
    
    func updateContent(items: [AnyObject]?) {
    
        self.itemArray.removeAllObjects()
        
        if items != nil {
            self.itemArray.addObjectsFromArray(items!)
        }
        
        self.pageControl.numberOfPages = self.itemArray.count
        self.pageControl.currentPage = 0
        self.pageControl.addTarget(self, action: #selector(changePage), forControlEvents: UIControlEvents.ValueChanged)
        self.addSubview(self.pageControl)
        self.rearrageAdViews()
    }
    
    
    func changePage() {
    
        print("\(#function)")
    
    }
    
    func rearrageAdViews() {
    
        print("\(#function)")
        
        for subView in self.scrollView.subviews {
        
            if subView.isKindOfClass(AdView) {
            
                subView.removeFromSuperview()
            }
        
        }
        
        //middle ad view
        var adView = self.adViews[1]
        adView.updateContent(self.itemArray[self.pageControl.currentPage])
        adView.frame = CGRectMake(AD_WIDTH, 0, AD_WIDTH, AD_HEIGHT)
        self.scrollView.addSubview(adView)
        
        //left ad view
        adView = self.adViews[0]
        var index  = self.pageControl.currentPage - 1
        if index < 0 {
            index = self.itemArray.count - 1
        }
        adView.updateContent(self.itemArray[index])
        adView.frame = CGRectMake(0, 0, AD_WIDTH, AD_HEIGHT)
        self.scrollView.addSubview(adView)
        
        //right ad view
        adView = self.adViews[2]
        index = self.pageControl.currentPage + 1
        
        if index >= self.itemArray.count {
        
            index = 0
        }
        
        adView.updateContent(self.itemArray[index])
        adView.frame = CGRectMake(AD_WIDTH*2, 0, AD_WIDTH, AD_HEIGHT)
        self.scrollView.addSubview(adView)
     }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let index = self.scrollView.contentOffset.x / AD_WIDTH
        
        if index > 1 {
        
            UIView.animateWithDuration(animationDuration, animations: { 
                self.scrollView.contentOffset = CGPointMake(self.AD_WIDTH*2, 0)
                }, completion: { (finished : Bool) in
                    
                    self.pageControl.currentPage = self.pageControl.currentPage + 1 < self.itemArray.count ? self.pageControl.currentPage + 1 : 0
                    
                    self.scrollView.contentOffset = CGPointMake(self.AD_WIDTH*1, 0)
                    
                    self.rearrageAdViews()
            })
        
        } else if index < 1 {
        
            UIView.animateWithDuration(animationDuration, animations: { 
                
                self.scrollView.contentOffset = CGPointMake(0, 0)
                
                }, completion: { (finished: Bool) in
                    
                    self.pageControl.currentPage = self.pageControl.currentPage - 1 >= 0 ? self.pageControl.currentPage - 1 : self.itemArray.count - 1
                    
                    self.rearrageAdViews()
            })
        
        }
    }
    
    func goToIndex(index: Int) {
    
        self.pageControl.currentPage = index
        
        UIView.animateWithDuration(animationDuration, animations: { 
            self.scrollView.contentOffset = CGPointMake(self.AD_WIDTH*2, 0)
        }) { (finished: Bool) in
                self.scrollView.contentOffset = CGPointMake(self.AD_WIDTH*1, 0)
                self.rearrageAdViews()
        }
    
    }
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */

}
