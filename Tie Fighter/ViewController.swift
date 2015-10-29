//
//  ViewController.swift
//  Tie Fighter
//
//  Created by Michael Andorfer on 29.10.15.
//  Copyright © 2015 FH Salzburg. All rights reserved.
//

import UIKit
import CoreMotion
import QuartzCore

class ViewController: UIViewController {
    
    var crossView : UIImageView!
    var crossFighter : UIImageView!
    var motionManager : CMMotionManager! = CMMotionManager()
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var fighterHeight : CGFloat = 0.0
    var fighterWidth : CGFloat = 0.0


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let crossGfx = UIImage(named:"cross.png") // Grafik liegt auf Wiki
        self.crossView = UIImageView(image:crossGfx) // crossView als property deklarieren
        self.view.addSubview(self.crossView) // Zielkreuz zum Hauptview hinzufügen
        self.crossView.center = self.view.center // und zentrieren.
        
        let fighterGfx = UIImage(named:"tie.png") // Grafik liegt auf Wiki
        self.crossFighter = UIImageView(image:fighterGfx) // crossView als property deklarieren
        self.view.addSubview(self.crossFighter) // Zielkreuz zum Hauptview hinzufügen
        self.crossFighter.center = self.view.center // und zentrieren.
        
        fighterHeight = crossFighter.frame.size.height
        fighterWidth = crossFighter.frame.size.width
        
        let displayLink = CADisplayLink(target: self, selector: "gametick:")
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)

        self.motionManager.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrame.XArbitraryZVertical)
        
        self.motionManager.deviceMotionUpdateInterval = 1.0/30.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        UIView.animateWithDuration(0.4, animations: {self.crossView.alpha = 0.2;})
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        UIView.animateWithDuration(0.4, animations: {self.crossView.alpha = 1.0;})
    }
    
    func gametick(displayLink: CADisplayLink) {
        if (self.motionManager.deviceMotion != nil) {
            var roll = self.motionManager.deviceMotion!.attitude.roll
            var pitch = self.motionManager.deviceMotion!.attitude.pitch
        
            pitch /= 0.1 * M_PI
            roll /= 0.1 * M_PI
        
            if (crossFighter.center.x + CGFloat(pitch) < (fighterWidth / 2) + screenSize.width && crossFighter.center.x + CGFloat(pitch) > 0 - (fighterWidth/2)) {
                crossFighter.center.x += CGFloat(pitch)
            }
            else if (crossFighter.center.x + CGFloat(pitch) < 0 - (fighterWidth / 2)) {
                crossFighter.center.x += screenSize.width + CGFloat(pitch) + (fighterWidth / 2)
            }
            else {
                crossFighter.center.x = 0 + CGFloat(pitch) - (fighterWidth / 2)
            }
        
        
        if (crossFighter.center.y + CGFloat(roll) < (fighterHeight / 2) + screenSize.height && crossFighter.center.y + CGFloat(roll) > 0 - (fighterHeight/2)) {
            crossFighter.center.y += CGFloat(roll)
        }
            else if (crossFighter.center.y + CGFloat(roll) < 0 - (fighterHeight / 2)) {
            crossFighter.center.y = screenSize.height + (fighterHeight / 2)
        }
            else {
            crossFighter.center.y = 0 + CGFloat(roll) - (fighterHeight / 2)
        }
        }
        
    }
}

