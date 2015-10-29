//
//  ViewController.swift
//  Tie Fighter
//
//  Created by Michael Andorfer on 29.10.15.
//  Copyright © 2015 FH Salzburg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var crossView : UIImageView!
    var crossFighter : UIImageView!

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

}

