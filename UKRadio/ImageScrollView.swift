
import UIKit

class ImageScrollView: UIView, UIScrollViewDelegate {
    
    let AD_WIDTH: CGFloat = 200
    let AD_HEIGHT: CGFloat = 100
    let AD_OFFSET: CGFloat = 10.0
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
        
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        self.scrollView.backgroundColor = UIColor.blue
        self.pageControl = UIPageControl(frame: CGRect(x: 0, y: frame.size.height - 16, width: frame.size.width, height: 16))
        self.pageControl.backgroundColor = UIColor.green
        
        super.init(frame: frame)
        

        self.scrollView.isPagingEnabled = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = true
        self.scrollView.scrollsToTop = false
        self.scrollView.delegate = self
        self.scrollView.bouncesZoom = false
        self.scrollView.bounces = false
        
        self.addSubview(self.scrollView)
        
        self.backgroundColor = UIColor.gray
        
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
        
        self.scrollView.contentSize = CGSize(width: (AD_WIDTH + AD_OFFSET*2) * (CGFloat)(self.itemArray.count), height: self.bounds.size.height)
        self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        
        var index = 0
        for item in self.itemArray {
            
            let adView = AdView(frame: CGRect(x: AD_OFFSET + (AD_WIDTH + AD_OFFSET) * CGFloat(index), y: 44.0 + (self.scrollView.bounds.size.height - AD_HEIGHT)/2.0, width: AD_WIDTH, height: AD_HEIGHT))
            adView.updateContent(item as AnyObject)
            adView.delegate = self
            self.adViews.append(adView)
            
            print("orgin.y:\(adView.frame.origin.y)^^^^^^height:\(adView.frame.size.height)")
            
            index += 1
            self.scrollView.addSubview(adView)
        }
        
        self.pageControl.numberOfPages = self.itemArray.count/2 + self.itemArray.count%2
        self.pageControl.currentPage = 0
        self.pageControl.addTarget(self, action: #selector(changePage), for: UIControlEvents.valueChanged)
        self.addSubview(self.pageControl)
        
        
        startTimer()
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
        
        let index = self.scrollView.contentOffset.x / self.bounds.size.width
        
        if index > 2 {
            
            UIView.animate(withDuration: animationDuration, animations: {
                self.scrollView.contentOffset = CGPoint(x: self.bounds.size.width*index, y: 0)
            }, completion: { (finished : Bool) in

                self.pageControl.currentPage = self.pageControl.currentPage + 1 < self.itemArray.count ? self.pageControl.currentPage + 1 : 0

                self.scrollView.contentOffset = CGPoint(x: 0, y: 0)

                self.rearrageAdViews()
            })
            
        } else if index < 1 {
            
//            UIView.animate(withDuration: animationDuration, animations: {
//
//                self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
//
//            }, completion: { (finished: Bool) in
//
//                self.pageControl.currentPage = self.pageControl.currentPage - 1 >= 0 ? self.pageControl.currentPage - 1 : self.itemArray.count - 1
//
//                self.rearrageAdViews()
//            })
            
        }
        
        startTimer()
    }
    
    func goToIndex(_ index: Int) {
        
        self.pageControl.currentPage = index
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.scrollView.contentOffset = CGPoint(x: self.bounds.size.width * (CGFloat)(index), y: 0)
        }, completion: { (finished: Bool) in
//            self.scrollView.contentOffset = CGPoint(x: self.AD_WIDTH*1, y: 0)
//            self.rearrageAdViews()
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
