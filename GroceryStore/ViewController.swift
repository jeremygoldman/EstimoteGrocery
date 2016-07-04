//
// Please report any problems with this app template to contact@estimote.com
//

import UIKit

class ViewController: UIViewController, ProximityContentManagerDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var beaconImage: UIImageView!
    @IBOutlet weak var iceCreamImage: UIImageView!
    @IBOutlet weak var milkImage: UIImageView!
    @IBOutlet weak var produceImage: UIImageView!
    
    var proximityContentManager: ProximityContentManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.activityIndicator.startAnimating()

        self.proximityContentManager = ProximityContentManager(
            beaconIDs: [
                BeaconID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major: 57539, minor: 685),
                BeaconID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major: 33905, minor: 35804),
                BeaconID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major: 30349, minor: 38488)
            ],
            beaconContentFactory: CachingContentFactory(beaconContentFactory: BeaconDetailsCloudFactory()))
        self.proximityContentManager.delegate = self
        self.proximityContentManager.startContentUpdates()
    }

    func proximityContentManager(proximityContentManager: ProximityContentManager, didUpdateContent content: AnyObject?) {
        self.activityIndicator?.stopAnimating()
        self.activityIndicator?.removeFromSuperview()
        //hide beacon image, since we're done looking for beacons
        self.beaconImage.hidden = true

        if let beaconDetails = content as? BeaconDetails {
            self.view.backgroundColor = beaconDetails.backgroundColor
            self.label.text = "You're closest to \(beaconDetails.beaconName)!"
            
            if (beaconDetails.beaconName.hasSuffix("Ice1")) {
                //closest to Ice1, aka ice cream aisle
                self.iceCreamImage.hidden = false
                self.milkImage.hidden = true
                self.produceImage.hidden = true
                
                self.label.text = "You're in the ice cream section.\n" +
                    "Try the Chocolate Chip!"
                
            } else if (beaconDetails.beaconName.hasSuffix("Mint1")) {
                //closest to Mint1, aka milk aisle
                self.iceCreamImage.hidden = true
                self.milkImage.hidden = false
                self.produceImage.hidden = true
                self.label.text = "You're in the milk aisle.\n" +
                    "Make sure you buy enough!"

                
            } else {
                //closest to Mint3, aka produce section
                self.iceCreamImage.hidden = true
                self.milkImage.hidden = true
                self.produceImage.hidden = false
                self.label.text = "You're in the produce section.\n" +
                    "Try the tomatoes, they're in season!"

                
            }
        } else {
            self.view.backgroundColor = BeaconDetails.neutralColor
            self.label.text = "No beacons in range."
            self.beaconImage.hidden = true
            self.iceCreamImage.hidden = true
            self.milkImage.hidden = true
            self.produceImage.hidden = true

        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //ice cream bounding animation
        
        let icBounds = self.iceCreamImage.bounds
        
        
        UIView.animateWithDuration(1, delay: 0.0,
            options: [.Autoreverse, .Repeat, .CurveEaseInOut],
            animations: { self.iceCreamImage.bounds =
                CGRect(x: icBounds.origin.x, y: icBounds.origin.y,
                    width: icBounds.width*1.2, height: icBounds.height*1.2)
        }, completion: nil)
        
        
        //milk bouncing animation
        
        let milkBounds = self.milkImage.bounds
        
        
        UIView.animateWithDuration(1, delay: 0.0,
            options: [.Autoreverse, .Repeat, .CurveEaseInOut],
            animations: { self.milkImage.bounds =
                CGRect(x: milkBounds.origin.x, y: milkBounds.origin.y,
                    width: milkBounds.width*1.2, height: milkBounds.height*1.2)
            }, completion: nil)
        
        
        //Produce bounding animationanimation
        let produceBounds = self.produceImage.bounds
        
        
        UIView.animateWithDuration(1, delay: 0.0,
            options: [.Autoreverse, .Repeat, .CurveEaseInOut],
            animations: { self.produceImage.bounds =
                CGRect(x: produceBounds.origin.x, y: produceBounds.origin.y,
                    width: produceBounds.width*1.15, height: produceBounds.height*1.15)
            }, completion: nil)
        
    }
}
