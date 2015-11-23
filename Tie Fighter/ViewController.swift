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
    
    // Global vars
    var crossView : UIImageView!
    var crossFighter : UIImageView!
    var hitCounterLabel: UILabel = UILabel()
    var motionManager : CMMotionManager! = CMMotionManager()
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var fighterHeight : CGFloat = 0.0
    var fighterWidth : CGFloat = 0.0
    var crossViewTargetRangeRadius = 25
    var hitCounter = 0;
    var movementCounter = 0
    var randX = 0
    var randY = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Cross
        let crossGfx = UIImage(named:"cross.png") // Load graphic cross.png
        self.crossView = UIImageView(image:crossGfx) // Declare crossView as property
        self.view.addSubview(self.crossView) // Add cross to main view
        self.crossView.center = self.view.center // Center cross on screen
        
        // Fighter
        let fighterGfx = UIImage(named:"tie.png") // Load graphic tie.png
        self.crossFighter = UIImageView(image:fighterGfx) // Declare crossFigher as property
        self.view.addSubview(self.crossFighter) // Add cross fighter to main view
        self.crossFighter.center = self.view.center // Center cross fighter
        
        // Hit Counter
        hitCounterLabel.frame = CGRectMake(10, 10, 60, 30) // Set x, y, width, height
        hitCounterLabel.textColor = UIColor.whiteColor() // Set text color
        hitCounterLabel.backgroundColor = UIColor(white: 1, alpha: 0) // Set background to transparent
        hitCounterLabel.text = "Hits: 0" // Set default value
        self.view.addSubview(hitCounterLabel) // Add label to view
        
        // Get height and width of cross fighter
        fighterHeight = crossFighter.frame.size.height
        fighterWidth = crossFighter.frame.size.width
        
        // Timer for display updates
        let displayLink = CADisplayLink(target: self, selector: "gametick:")
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)

        // Update display
        self.motionManager.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrame.XArbitraryZVertical)
        
        // Update rate
        self.motionManager.deviceMotionUpdateInterval = 1.0 / 30.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Tie fighter has been shooten
    func shoot() {
        // Hide tie fighter
        self.crossFighter.alpha = 0.0
        
        // Set tie fighter to random position
        self.crossFighter.center.x = (CGFloat(self.view.frame.width) * CGFloat(Float(arc4random()) / Float(UINT32_MAX)))
        self.crossFighter.center.y = (CGFloat(self.view.frame.height) * CGFloat(Float(arc4random()) / Float(UINT32_MAX)))
        
        // Increment hit counter and update label
        hitCounter += 1
        hitCounterLabel.text = "Hits: " + String(hitCounter)
        
        // Show tie fighter
        self.crossFighter.alpha = 1.0
    }
    
    // Begin touch on device
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        UIView.animateWithDuration(0.4, animations: {self.crossView.alpha = 0.2;})
        // If tie fighter is in cross center, hide tie fighter
        if (crossView.center.x >= crossFighter.center.x - CGFloat(crossViewTargetRangeRadius) &&
            crossView.center.x <= crossFighter.center.x + CGFloat(crossViewTargetRangeRadius)) &&
           (crossView.center.y >= crossFighter.center.y - CGFloat(crossViewTargetRangeRadius) &&
            crossView.center.y <= crossFighter.center.y + CGFloat(crossViewTargetRangeRadius)) {
            shoot()
        }
    }
    
    // End touch on device
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        UIView.animateWithDuration(0.4, animations: {self.crossView.alpha = 1.0;})
    }
    
    // Game Logic
    func gametick(displayLink: CADisplayLink) {
        if (self.motionManager.deviceMotion != nil) {
            
            movementCounter++
            
            // After every 10 tick calculation random movement
            if (movementCounter == 10) {
                randX = Int.random(-5...5)
                randY = Int.random(-5...5)
                movementCounter = 0
            }

            // Set random position at every tick
            self.crossFighter.center.x = self.crossFighter.center.x + CGFloat(randX)
            self.crossFighter.center.y = self.crossFighter.center.y + CGFloat(randY)
            
            // Get roll and pitch of device
            var roll = self.motionManager.deviceMotion!.attitude.roll
            var pitch = self.motionManager.deviceMotion!.attitude.pitch
        
            // Calculate realistic roll and pitch values for update
            pitch /= 0.1 * M_PI
            roll /= 0.1 * M_PI
        
            // Horizontal move
            if (crossFighter.center.x + CGFloat(pitch) < (fighterWidth / 2) + screenSize.width && crossFighter.center.x + CGFloat(pitch) > 0 - (fighterWidth/2)) { // Between left and right borders
                crossFighter.center.x += CGFloat(pitch)
            }
            else if (crossFighter.center.x + CGFloat(pitch) < 0 - (fighterWidth / 2)) { // Leave left border
                crossFighter.center.x += screenSize.width + CGFloat(pitch) + (fighterWidth / 2)
            }
            else { // Leave right border
                crossFighter.center.x = 0 + CGFloat(pitch) - (fighterWidth / 2)
            }
        
            // Vertical move
            if (crossFighter.center.y + CGFloat(roll) < (fighterHeight / 2) + screenSize.height && crossFighter.center.y + CGFloat(roll) > 0 - (fighterHeight/2)) { // Between top and bottom borders
                crossFighter.center.y += CGFloat(roll)
            }
            else if (crossFighter.center.y + CGFloat(roll) < 0 - (fighterHeight / 2)) { // Leave top border
                crossFighter.center.y = screenSize.height + (fighterHeight / 2)
            }
            else {
                crossFighter.center.y = 0 + CGFloat(roll) - (fighterHeight / 2) // Leave bottom border
            }
        }
    }
}

// Random Integer Extension
extension Int
{
    static func random(range: Range<Int> ) -> Int
    {
        var offset = 0
        
        if range.startIndex < 0   // allow negative ranges
        {
            offset = abs(range.startIndex)
        }
        
        let mini = UInt32(range.startIndex + offset)
        let maxi = UInt32(range.endIndex   + offset)
        
        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
}

