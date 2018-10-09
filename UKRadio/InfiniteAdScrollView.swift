//
//  InfiniteAdScrollView.swift


import UIKit

let TIME_INTERVAL = 6

@objc protocol AdViewProtocol {
    
    @objc optional func clickedAd(_ token: AnyObject)
}

class AdView: UIView, AdViewProtocol {
    
    var item: NSDictionary? = nil
    var imageUrl: String? = nil
    var image: UIImage? = nil
    weak var delegate: AnyObject? = nil
    
    deinit {
    
        self.delegate = nil
    
    }

    func updateContent(_ item: AnyObject?) {
    
        self.item = item as? NSDictionary
        self.image = nil
        
        if self.item != nil {
        
            self.imageUrl = self.item!.object(forKey: "url") as? String
            
            if let imageUrl = self.imageUrl {
            
                if let image = Tool.getImageFromLocal(imageUrl) {
                    
                    self.image = image
                    
                }
                else {
                    
                    ImageLoader.sharedInstance.downloadImage(imageUrl, token: nil, result: { (url: String?, token:
                        NSDictionary?, error: Error?) in
                        
                        if imageUrl == url && error == nil {
                        
                            self.image = Tool.getImageFromLocal(imageUrl)
                        }
                        
                    })
                    
                }
            }

        }
    
        self.setNeedsDisplay()
        
    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        if let image = self.image {
        
            image.draw(in: self.bounds)
        
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if let delegate = self.delegate {
            delegate.clickedAd(self.item!)
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
    var timer: Timer?
    
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
        
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: AD_WIDTH, height: AD_HEIGHT))
        self.pageControl = UIPageControl(frame: CGRect(x: 0, y: AD_HEIGHT - 16, width: AD_WIDTH, height: 16))
        self.pageControl.backgroundColor = UIColor.clear
        super.init(frame: frame)
        
        self.scrollView.contentSize = CGSize(width: AD_WIDTH * 3, height: AD_HEIGHT)
        self.scrollView.contentOffset = CGPoint(x: AD_WIDTH, y: 0)
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.scrollsToTop = false
        self.scrollView.delegate = self
        self.scrollView.bouncesZoom = false
        self.scrollView.bounces = false
        
        self.addSubview(self.scrollView)
        
        self.backgroundColor = UIColor.gray
        
        for i in 0..<3 {
        
            let adView = AdView(frame: CGRect(x: AD_WIDTH * CGFloat(i), y: 0, width: AD_WIDTH, height: AD_HEIGHT))
            adView.delegate = self
            self.adViews.append(adView)
        
        }
        
        self.adViews[0].backgroundColor = UIColor.red
        self.adViews[1].backgroundColor = UIColor.green
        self.adViews[2].backgroundColor = UIColor.blue

        
        startTimer()
        
    }
    
    func startTimer() {
    
        if self.timer != nil {
        
            self.timer?.invalidate()
            self.timer = nil
        }
        
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(TIME_INTERVAL), target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    
    }
    
    func timerAction(_ timer: Timer) {
        
        if 0 == self.itemArray.count {
            return;
        }
    
        if self.pageControl.currentPage + 1 < self.itemArray.count {
        
            self.pageControl.currentPage = self.pageControl.currentPage + 1
        
        }else {
        
            self.pageControl.currentPage = 0
            
        }
        
        self.goToIndex(self.pageControl.currentPage)
        
    }
    
    func updateContent(_ items: [Any]?) {
    
        self.itemArray.removeAllObjects()
        
        if items != nil {
            self.itemArray.addObjects(from: items!)
        }
        
        self.pageControl.numberOfPages = self.itemArray.count
        self.pageControl.currentPage = 0
        self.pageControl.addTarget(self, action: #selector(changePage), for: UIControlEvents.valueChanged)
        self.addSubview(self.pageControl)
        self.rearrageAdViews()
    }
    
    func clickedAd(_ token: AnyObject){
        
        print("\(token.description)")
    }
    
    func changePage() {
    
        print("\(#function)")
    
    }
    
    func rearrageAdViews() {
    
        //print("\(#function)")
        
        for subView in self.scrollView.subviews {
        
            if subView.isKind(of: AdView.self) {
            
                subView.removeFromSuperview()
            }
        
        }
        
        //middle ad view
        var adView = self.adViews[1]
        adView.updateContent(self.itemArray[self.pageControl.currentPage] as AnyObject)
        adView.frame = CGRect(x: AD_WIDTH, y: 0, width: AD_WIDTH, height: AD_HEIGHT)
        self.scrollView.addSubview(adView)
        
        //left ad view
        adView = self.adViews[0]
        var index  = self.pageControl.currentPage - 1
        if index < 0 {
            index = self.itemArray.count - 1
        }
        adView.updateContent(self.itemArray[index] as AnyObject)
        adView.frame = CGRect(x: 0, y: 0, width: AD_WIDTH, height: AD_HEIGHT)
        self.scrollView.addSubview(adView)
        
        //right ad view
        adView = self.adViews[2]
        index = self.pageControl.currentPage + 1
        
        if index >= self.itemArray.count {
        
            index = 0
        }
        
        adView.updateContent(self.itemArray[index] as AnyObject)
        adView.frame = CGRect(x: AD_WIDTH*2, y: 0, width: AD_WIDTH, height: AD_HEIGHT)
        self.scrollView.addSubview(adView)
     }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if self.timer != nil {
            self.timer?.invalidate();
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let index = self.scrollView.contentOffset.x / AD_WIDTH
        
        if index > 1 {
        
            UIView.animate(withDuration: animationDuration, animations: { 
                self.scrollView.contentOffset = CGPoint(x: self.AD_WIDTH*2, y: 0)
                }, completion: { (finished : Bool) in
                    
                    self.pageControl.currentPage = self.pageControl.currentPage + 1 < self.itemArray.count ? self.pageControl.currentPage + 1 : 0
                    
                    self.scrollView.contentOffset = CGPoint(x: self.AD_WIDTH*1, y: 0)
                    
                    self.rearrageAdViews()
            })
        
        } else if index < 1 {
        
            UIView.animate(withDuration: animationDuration, animations: { 
                
                self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
                
                }, completion: { (finished: Bool) in
                    
                    self.pageControl.currentPage = self.pageControl.currentPage - 1 >= 0 ? self.pageControl.currentPage - 1 : self.itemArray.count - 1
                    
                    self.rearrageAdViews()
            })
        
        }
        
        startTimer()
    }
    
    func goToIndex(_ index: Int) {
    
        self.pageControl.currentPage = index
        
        UIView.animate(withDuration: animationDuration, animations: { 
            self.scrollView.contentOffset = CGPoint(x: self.AD_WIDTH*2, y: 0)
        }, completion: { (finished: Bool) in
                self.scrollView.contentOffset = CGPoint(x: self.AD_WIDTH*1, y: 0)
                self.rearrageAdViews()
        }) 
    
    }
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */

}
